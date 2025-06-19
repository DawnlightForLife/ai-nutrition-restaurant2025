/**
 * 增强的菜品控制器
 * 支持完整的CRUD操作、图片上传、营养信息管理、库存关联等
 * @module controllers/merchant/dishControllerEnhanced
 */

const StoreDish = require('../../models/merchant/storeDishModel');
const ProductDish = require('../../models/merchant/productDishModel');
const { IngredientInventory } = require('../../models/merchant/ingredientInventoryModel');
const { IngredientNutrition } = require('../../models/nutrition/ingredientNutritionModel');
const { validationResult } = require('express-validator');
const multer = require('multer');
const path = require('path');
const fs = require('fs').promises;
const { getMerchantId } = require('../../utils/merchantUtils');

// 配置图片上传
const storage = multer.diskStorage({
  destination: async (req, file, cb) => {
    const uploadPath = path.join(process.cwd(), 'uploads', 'dishes');
    try {
      await fs.mkdir(uploadPath, { recursive: true });
      cb(null, uploadPath);
    } catch (error) {
      cb(error);
    }
  },
  filename: (req, file, cb) => {
    const uniqueName = `dish_${Date.now()}_${Math.round(Math.random() * 1E9)}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

const upload = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB
    files: 10 // 最多10张图片
  },
  fileFilter: (req, file, cb) => {
    const allowedTypes = /jpeg|jpg|png|webp/;
    const extname = allowedTypes.test(path.extname(file.originalname).toLowerCase());
    const mimetype = allowedTypes.test(file.mimetype);
    
    if (mimetype && extname) {
      return cb(null, true);
    }
    cb(new Error('只允许上传 jpeg, jpg, png, webp 格式的图片'));
  }
});

/**
 * 图片上传中间件
 */
exports.uploadDishImages = upload.array('images', 10);

/**
 * 创建菜品（增强版）
 */
exports.createDish = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        message: '输入验证失败',
        errors: errors.array()
      });
    }

    const {
      name,
      description,
      category,
      subCategory,
      price,
      discountedPrice,
      ingredients = [],
      nutritionFacts = {},
      nutritionAttributes = [],
      allergens = [],
      tags = [],
      preparationTime,
      spicyLevel = 0,
      regions = [],
      seasons = [],
      isPackage = false,
      packageDishes = [],
      suitableMerchantTypes = ['all'],
      healthBenefits = [],
      suitableDiets = [],
      suitableActivityLevels = ['all'],
      suitableAgeGroups = ['all']
    } = req.body;

    // 处理上传的图片
    const imageUrls = [];
    if (req.files && req.files.length > 0) {
      req.files.forEach(file => {
        const imageUrl = `/uploads/dishes/${file.filename}`;
        imageUrls.push(imageUrl);
      });
    }

    // 获取当前用户的商家ID
    const merchantId = getMerchantId(req);
    if (!merchantId) {
      return res.status(403).json({
        success: false,
        message: '需要关联商家才能创建菜品'
      });
    }

    // 验证食材库存
    const ingredientChecks = [];
    if (ingredients.length > 0) {
      for (const ingredient of ingredients) {
        const inventory = await IngredientInventory.findOne({
          merchantId,
          name: ingredient,
          isActive: true
        });
        
        ingredientChecks.push({
          name: ingredient,
          hasInventory: !!inventory,
          currentStock: inventory ? inventory.availableStock : 0
        });
      }
    }

    // 创建产品菜品
    const productDish = new ProductDish({
      name,
      description,
      imageUrl: imageUrls[0] || '', // 主图片
      price,
      discountedPrice,
      category,
      subCategory,
      tags,
      nutritionFacts,
      nutritionAttributes,
      ingredients,
      allergens,
      spicyLevel,
      preparationTime,
      regions,
      seasons,
      isPackage,
      packageDishes,
      suitableMerchantTypes,
      healthBenefits,
      suitableDiets,
      suitableActivityLevels,
      suitableAgeGroups,
      createdBy: req.user._id,
      isActive: true,
      visibility: 'merchantOnly' // 默认仅商家可见
    });

    // 设置商家关联
    productDish.merchantId = merchantId;

    await productDish.save();

    // 创建店铺菜品关联
    const storeDish = new StoreDish({
      storeId: merchantId,
      dishId: productDish._id,
      priceOverride: price,
      discountPriceOverride: discountedPrice,
      isAvailable: true,
      images: imageUrls, // 存储所有图片
      inventory: {
        currentStock: 100, // 默认库存
        alertThreshold: 10,
        maxCapacity: 500
      },
      storeSpecificData: {
        ingredientChecks
      }
    });

    await storeDish.save();

    // 返回完整信息
    const result = await StoreDish.findById(storeDish._id)
      .populate('dishId')
      .populate('storeId');

    res.status(201).json({
      success: true,
      message: '菜品创建成功',
      data: {
        dish: result,
        ingredientChecks
      }
    });

  } catch (error) {
    console.error('创建菜品失败:', error);
    
    // 清理上传的文件
    if (req.files && req.files.length > 0) {
      req.files.forEach(async (file) => {
        try {
          await fs.unlink(file.path);
        } catch (unlinkError) {
          console.error('清理上传文件失败:', unlinkError);
        }
      });
    }

    res.status(500).json({
      success: false,
      message: '创建菜品失败',
      error: error.message
    });
  }
};

/**
 * 获取菜品列表（增强版）
 */
exports.getDishList = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      category,
      subCategory,
      isAvailable,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc',
      nutritionAttributes,
      allergens,
      priceMin,
      priceMax,
      spicyLevel,
      tags
    } = req.query;

    const merchantId = getMerchantId(req);
    
    // 构建查询条件
    const query = { storeId: merchantId };
    
    if (isAvailable !== undefined) {
      query.isAvailable = isAvailable === 'true';
    }

    // 构建菜品过滤条件
    const dishFilters = {};
    if (category) dishFilters.category = category;
    if (subCategory) dishFilters.subCategory = subCategory;
    if (nutritionAttributes) {
      dishFilters.nutritionAttributes = { $in: nutritionAttributes.split(',') };
    }
    if (allergens) {
      dishFilters.allergens = { $nin: allergens.split(',') };
    }
    if (spicyLevel !== undefined) {
      dishFilters.spicyLevel = { $lte: parseInt(spicyLevel) };
    }
    if (tags) {
      dishFilters.tags = { $in: tags.split(',') };
    }

    // 价格过滤
    if (priceMin || priceMax) {
      const priceFilter = {};
      if (priceMin) priceFilter.$gte = parseFloat(priceMin);
      if (priceMax) priceFilter.$lte = parseFloat(priceMax);
      query.$or = [
        { priceOverride: priceFilter },
        { 'dishId.price': priceFilter }
      ];
    }

    // 构建排序
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 聚合查询
    const pipeline = [
      { $match: query },
      {
        $lookup: {
          from: 'dishes', // ProductDish集合名
          localField: 'dishId',
          foreignField: '_id',
          as: 'dishInfo'
        }
      },
      { $unwind: '$dishInfo' },
      { $match: { 'dishInfo': dishFilters } }
    ];

    // 搜索条件
    if (search) {
      pipeline.push({
        $match: {
          $or: [
            { 'dishInfo.name': { $regex: search, $options: 'i' } },
            { 'dishInfo.description': { $regex: search, $options: 'i' } },
            { 'dishInfo.tags': { $regex: search, $options: 'i' } },
            { 'dishInfo.ingredients': { $regex: search, $options: 'i' } }
          ]
        }
      });
    }

    // 添加计算字段
    pipeline.push({
      $addFields: {
        finalPrice: {
          $ifNull: ['$priceOverride', '$dishInfo.price']
        },
        finalDiscountPrice: {
          $ifNull: ['$discountPriceOverride', '$dishInfo.discountedPrice']
        },
        stockStatus: {
          $cond: [
            { $lte: ['$inventory.currentStock', '$inventory.alertThreshold'] },
            'low',
            'normal'
          ]
        }
      }
    });

    // 排序
    pipeline.push({ $sort: sort });

    // 获取总数
    const totalPipeline = [...pipeline, { $count: 'total' }];
    const totalResult = await StoreDish.aggregate(totalPipeline);
    const total = totalResult[0]?.total || 0;

    // 分页
    pipeline.push({ $skip: skip }, { $limit: parseInt(limit) });

    const dishes = await StoreDish.aggregate(pipeline);

    res.json({
      success: true,
      message: '获取菜品列表成功',
      data: {
        dishes,
        pagination: {
          current: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        },
        filters: {
          category,
          subCategory,
          isAvailable,
          nutritionAttributes,
          allergens,
          priceRange: { min: priceMin, max: priceMax },
          spicyLevel,
          tags
        }
      }
    });

  } catch (error) {
    console.error('获取菜品列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取菜品列表失败',
      error: error.message
    });
  }
};

/**
 * 获取菜品详情（增强版）
 */
exports.getDishById = async (req, res) => {
  try {
    const { dishId } = req.params;
    const merchantId = getMerchantId(req);

    const dish = await StoreDish.findOne({
      _id: dishId,
      storeId: merchantId
    })
    .populate('dishId')
    .populate('storeId');

    if (!dish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    // 获取相关的食材库存信息
    const ingredientInventories = [];
    if (dish.dishId.ingredients && dish.dishId.ingredients.length > 0) {
      for (const ingredient of dish.dishId.ingredients) {
        const inventory = await IngredientInventory.findOne({
          merchantId,
          name: ingredient,
          isActive: true
        });
        
        if (inventory) {
          ingredientInventories.push({
            name: ingredient,
            currentStock: inventory.availableStock,
            minThreshold: inventory.minThreshold,
            status: inventory.status,
            unit: inventory.stockBatches[0]?.unit || 'g'
          });
        }
      }
    }

    // 获取营养分析
    const nutritionAnalysis = dish.dishId.getNutritionalValue();

    res.json({
      success: true,
      message: '获取菜品详情成功',
      data: {
        dish,
        ingredientInventories,
        nutritionAnalysis,
        canProduce: ingredientInventories.every(inv => inv.status !== 'out'),
        productionCapacity: Math.min(...ingredientInventories.map(inv => inv.currentStock))
      }
    });

  } catch (error) {
    console.error('获取菜品详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取菜品详情失败',
      error: error.message
    });
  }
};

/**
 * 更新菜品（增强版）
 */
exports.updateDish = async (req, res) => {
  try {
    const { dishId } = req.params;
    const updates = req.body;
    const merchantId = getMerchantId(req);

    // 检查权限
    const storeDish = await StoreDish.findOne({
      _id: dishId,
      storeId: merchantId
    });

    if (!storeDish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    // 处理新上传的图片
    let newImageUrls = [];
    if (req.files && req.files.length > 0) {
      req.files.forEach(file => {
        newImageUrls.push(`/uploads/dishes/${file.filename}`);
      });
    }

    // 合并图片列表
    if (newImageUrls.length > 0) {
      updates.images = [...(storeDish.images || []), ...newImageUrls];
    }

    // 分离更新字段
    const storeUpdates = {};
    const productUpdates = {};

    const storeFields = [
      'priceOverride', 'discountPriceOverride', 'isAvailable', 
      'storeSpecificDescription', 'inventory', 'promotion', 'images'
    ];
    const productFields = [
      'name', 'description', 'category', 'subCategory', 'ingredients', 
      'nutritionFacts', 'nutritionAttributes', 'allergens', 'tags', 
      'preparationTime', 'spicyLevel', 'regions', 'seasons', 'healthBenefits',
      'suitableDiets', 'suitableActivityLevels', 'suitableAgeGroups'
    ];

    Object.keys(updates).forEach(key => {
      if (storeFields.includes(key)) {
        storeUpdates[key] = updates[key];
      } else if (productFields.includes(key)) {
        productUpdates[key] = updates[key];
      }
    });

    // 更新产品信息
    if (Object.keys(productUpdates).length > 0) {
      // 设置修改人信息
      productUpdates._current_user_id = req.user._id;
      await ProductDish.findByIdAndUpdate(storeDish.dishId, productUpdates);
    }

    // 更新店铺信息
    if (Object.keys(storeUpdates).length > 0) {
      Object.assign(storeDish, storeUpdates);
      await storeDish.save();
    }

    // 如果更新了食材，重新验证库存
    if (updates.ingredients) {
      const ingredientChecks = [];
      for (const ingredient of updates.ingredients) {
        const inventory = await IngredientInventory.findOne({
          merchantId,
          name: ingredient,
          isActive: true
        });
        
        ingredientChecks.push({
          name: ingredient,
          hasInventory: !!inventory,
          currentStock: inventory ? inventory.availableStock : 0
        });
      }
      
      storeDish.storeSpecificData = {
        ...storeDish.storeSpecificData,
        ingredientChecks
      };
      await storeDish.save();
    }

    // 返回更新后的数据
    const updatedDish = await StoreDish.findById(dishId)
      .populate('dishId')
      .populate('storeId');

    res.json({
      success: true,
      message: '菜品更新成功',
      data: updatedDish
    });

  } catch (error) {
    console.error('更新菜品失败:', error);
    res.status(500).json({
      success: false,
      message: '更新菜品失败',
      error: error.message
    });
  }
};

/**
 * 删除菜品图片
 */
exports.removeImage = async (req, res) => {
  try {
    const { dishId } = req.params;
    const { imageUrl } = req.body;
    const merchantId = getMerchantId(req);

    const storeDish = await StoreDish.findOne({
      _id: dishId,
      storeId: merchantId
    });

    if (!storeDish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    // 从图片列表中移除
    if (storeDish.images) {
      storeDish.images = storeDish.images.filter(img => img !== imageUrl);
      await storeDish.save();
    }

    // 删除物理文件
    if (imageUrl.startsWith('/uploads/dishes/')) {
      const filename = path.basename(imageUrl);
      const filePath = path.join(process.cwd(), 'uploads', 'dishes', filename);
      
      try {
        await fs.unlink(filePath);
      } catch (unlinkError) {
        console.warn('删除图片文件失败:', unlinkError);
      }
    }

    res.json({
      success: true,
      message: '图片删除成功',
      data: { imageUrl }
    });

  } catch (error) {
    console.error('删除图片失败:', error);
    res.status(500).json({
      success: false,
      message: '删除图片失败',
      error: error.message
    });
  }
};

/**
 * 批量操作菜品
 */
exports.batchOperations = async (req, res) => {
  try {
    const { operation, dishIds, data } = req.body;
    const merchantId = getMerchantId(req);

    if (!dishIds || !Array.isArray(dishIds) || dishIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请选择要操作的菜品'
      });
    }

    let result = {};
    
    switch (operation) {
      case 'updateStatus':
        result = await StoreDish.updateMany(
          { _id: { $in: dishIds }, storeId: merchantId },
          { isAvailable: data.isAvailable }
        );
        break;
        
      case 'updatePrice':
        const percentage = data.percentage;
        if (!percentage || isNaN(percentage)) {
          return res.status(400).json({
            success: false,
            message: '价格调整百分比必须是有效数字'
          });
        }
        
        const dishes = await StoreDish.find({
          _id: { $in: dishIds },
          storeId: merchantId
        }).populate('dishId');
        
        let updated = 0;
        for (const dish of dishes) {
          const currentPrice = dish.priceOverride || dish.dishId.price;
          const newPrice = Math.round(currentPrice * (1 + percentage / 100) * 100) / 100;
          
          dish.priceOverride = newPrice;
          await dish.save();
          updated++;
        }
        
        result = { updated };
        break;
        
      case 'updateCategory':
        // 更新ProductDish的类别
        const productDishIds = await StoreDish.find({
          _id: { $in: dishIds },
          storeId: merchantId
        }).distinct('dishId');
        
        result = await ProductDish.updateMany(
          { _id: { $in: productDishIds } },
          { category: data.category, subCategory: data.subCategory }
        );
        break;
        
      case 'delete':
        if (data.permanent) {
          result = await StoreDish.deleteMany({
            _id: { $in: dishIds },
            storeId: merchantId
          });
        } else {
          result = await StoreDish.updateMany(
            { _id: { $in: dishIds }, storeId: merchantId },
            { isAvailable: false }
          );
        }
        break;
        
      default:
        return res.status(400).json({
          success: false,
          message: '不支持的操作类型'
        });
    }

    res.json({
      success: true,
      message: `批量${operation}操作完成`,
      data: result
    });

  } catch (error) {
    console.error('批量操作失败:', error);
    res.status(500).json({
      success: false,
      message: '批量操作失败',
      error: error.message
    });
  }
};

/**
 * 获取菜品分析报告
 */
exports.getDishAnalytics = async (req, res) => {
  try {
    const merchantId = getMerchantId(req);
    
    const analytics = await StoreDish.aggregate([
      { $match: { storeId: merchantId } },
      {
        $lookup: {
          from: 'dishes',
          localField: 'dishId',
          foreignField: '_id',
          as: 'dishInfo'
        }
      },
      { $unwind: '$dishInfo' },
      {
        $group: {
          _id: null,
          totalDishes: { $sum: 1 },
          availableDishes: {
            $sum: { $cond: ['$isAvailable', 1, 0] }
          },
          averagePrice: {
            $avg: { $ifNull: ['$priceOverride', '$dishInfo.price'] }
          },
          categoryDistribution: {
            $push: '$dishInfo.category'
          },
          lowStockDishes: {
            $sum: {
              $cond: [
                { $lte: ['$inventory.currentStock', '$inventory.alertThreshold'] },
                1,
                0
              ]
            }
          },
          totalInventoryValue: {
            $sum: {
              $multiply: [
                '$inventory.currentStock',
                { $ifNull: ['$priceOverride', '$dishInfo.price'] }
              ]
            }
          }
        }
      }
    ]);

    const report = analytics[0] || {
      totalDishes: 0,
      availableDishes: 0,
      averagePrice: 0,
      categoryDistribution: [],
      lowStockDishes: 0,
      totalInventoryValue: 0
    };

    // 计算类别分布
    const categoryCount = {};
    report.categoryDistribution.forEach(category => {
      categoryCount[category] = (categoryCount[category] || 0) + 1;
    });

    report.categoryDistribution = Object.entries(categoryCount).map(([category, count]) => ({
      category,
      count,
      percentage: Math.round((count / report.totalDishes) * 100)
    }));

    res.json({
      success: true,
      message: '获取菜品分析报告成功',
      data: report
    });

  } catch (error) {
    console.error('获取分析报告失败:', error);
    res.status(500).json({
      success: false,
      message: '获取分析报告失败',
      error: error.message
    });
  }
};

module.exports = exports;