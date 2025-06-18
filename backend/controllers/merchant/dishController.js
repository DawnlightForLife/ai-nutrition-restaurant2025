/**
 * 菜品控制器
 * 处理菜品相关的所有请求，包括菜品管理、营养信息等
 * @module controllers/merchant/dishController
 */

const StoreDish = require('../../models/merchant/storeDishModel');
const ProductDish = require('../../models/merchant/productDishModel');
const { validationResult } = require('express-validator');

// ✅ 命名风格统一（camelCase）
// ✅ 所有控制器方法为 async / await
// ✅ 每个接口预期返回 { success, message, data } 结构
// ✅ 支持权限验证和资源权限检查

/**
 * 创建菜品
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建菜品的JSON响应
 */
exports.createDish = async (req, res) => {
  try {
    // 检查输入验证错误
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
      price,
      discountPrice,
      ingredients,
      nutrition,
      images,
      tags,
      preparationTime,
      allergens,
      isVegetarian,
      isVegan,
      isGlutenFree,
      spicyLevel
    } = req.body;

    // 检查用户是否有关联的店铺
    if (!req.user.franchiseStoreId) {
      return res.status(403).json({
        success: false,
        message: '需要关联店铺才能创建菜品'
      });
    }

    // 创建产品菜品（模板）
    const productDish = new ProductDish({
      name,
      description,
      category,
      basePrice: price,
      ingredients: ingredients || [],
      nutrition: nutrition || {},
      images: images || [],
      tags: tags || [],
      preparationTime: preparationTime || 0,
      allergens: allergens || [],
      isVegetarian: isVegetarian || false,
      isVegan: isVegan || false,
      isGlutenFree: isGlutenFree || false,
      spicyLevel: spicyLevel || 0,
      createdBy: req.user._id,
      merchantId: req.user.franchiseStoreId
    });

    await productDish.save();

    // 在店铺中添加该菜品
    const storeDish = new StoreDish({
      storeId: req.user.franchiseStoreId,
      dishId: productDish._id,
      priceOverride: price,
      discountPriceOverride: discountPrice,
      isAvailable: true,
      inventory: {
        currentStock: 100, // 默认库存
        alertThreshold: 10
      }
    });

    await storeDish.save();

    // 返回创建的菜品信息
    const result = await StoreDish.findById(storeDish._id)
      .populate('dishId');

    res.status(201).json({
      success: true,
      message: '菜品创建成功',
      data: result
    });

  } catch (error) {
    console.error('创建菜品失败:', error);
    res.status(500).json({
      success: false,
      message: '创建菜品失败',
      error: error.message
    });
  }
};

/**
 * 获取菜品列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含菜品列表的JSON响应
 */
exports.getDishList = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      category,
      isAvailable,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    // 构建查询条件
    const query = {
      storeId: req.user.franchiseStoreId
    };

    if (category) {
      query.category = category;
    }

    if (isAvailable !== undefined) {
      query.isAvailable = isAvailable === 'true';
    }

    // 构建排序条件
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页计算
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 执行查询
    let dishQuery = StoreDish.find(query)
      .populate('dishId')
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit));

    // 如果有搜索条件，在菜品名称和描述中搜索
    if (search) {
      dishQuery = dishQuery.populate({
        path: 'dishId',
        match: {
          $or: [
            { name: { $regex: search, $options: 'i' } },
            { description: { $regex: search, $options: 'i' } }
          ]
        }
      });
    }

    const dishes = await dishQuery;

    // 过滤出populated成功的记录（搜索时需要）
    const filteredDishes = search ? 
      dishes.filter(dish => dish.dishId) : 
      dishes;

    // 获取总数
    const total = await StoreDish.countDocuments(query);

    res.json({
      success: true,
      message: '获取菜品列表成功',
      data: {
        dishes: filteredDishes,
        pagination: {
          current: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
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
 * 获取单个菜品详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个菜品的JSON响应
 */
exports.getDishById = async (req, res) => {
  try {
    const { dishId } = req.params;

    const dish = await StoreDish.findOne({
      _id: dishId,
      storeId: req.user.franchiseStoreId
    }).populate('dishId');

    if (!dish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    res.json({
      success: true,
      message: '获取菜品详情成功',
      data: dish
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
 * 更新菜品
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后菜品的JSON响应
 */
exports.updateDish = async (req, res) => {
  try {
    const { dishId } = req.params;
    const updates = req.body;

    // 检查菜品是否存在且属于当前用户的店铺
    const storeDish = await StoreDish.findOne({
      _id: dishId,
      storeId: req.user.franchiseStoreId
    });

    if (!storeDish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    // 分离店铺级别的更新和产品级别的更新
    const storeUpdates = {};
    const productUpdates = {};

    // 店铺级别的字段
    const storeFields = ['priceOverride', 'discountPriceOverride', 'isAvailable', 'storeSpecificDescription', 'inventory', 'promotion'];
    // 产品级别的字段
    const productFields = ['name', 'description', 'category', 'ingredients', 'nutrition', 'images', 'tags', 'preparationTime', 'allergens', 'isVegetarian', 'isVegan', 'isGlutenFree', 'spicyLevel'];

    Object.keys(updates).forEach(key => {
      if (storeFields.includes(key)) {
        storeUpdates[key] = updates[key];
      } else if (productFields.includes(key)) {
        productUpdates[key] = updates[key];
      }
    });

    // 更新产品信息
    if (Object.keys(productUpdates).length > 0) {
      await ProductDish.findByIdAndUpdate(storeDish.dishId, productUpdates);
    }

    // 更新店铺菜品信息
    if (Object.keys(storeUpdates).length > 0) {
      Object.assign(storeDish, storeUpdates);
      await storeDish.save();
    }

    // 返回更新后的菜品信息
    const updatedDish = await StoreDish.findById(dishId).populate('dishId');

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
 * 删除菜品
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.deleteDish = async (req, res) => {
  try {
    const { dishId } = req.params;
    const { permanent = false } = req.query;

    // 检查菜品是否存在且属于当前用户的店铺
    const storeDish = await StoreDish.findOne({
      _id: dishId,
      storeId: req.user.franchiseStoreId
    });

    if (!storeDish) {
      return res.status(404).json({
        success: false,
        message: '菜品不存在或无权限访问'
      });
    }

    if (permanent === 'true') {
      // 物理删除
      await StoreDish.findByIdAndDelete(dishId);
      // 注意：这里不删除ProductDish，因为其他店铺可能还在使用
    } else {
      // 逻辑删除（标记为不可用）
      storeDish.isAvailable = false;
      await storeDish.save();
    }

    res.json({
      success: true,
      message: permanent === 'true' ? '菜品已永久删除' : '菜品已下架',
      data: { dishId, permanent: permanent === 'true' }
    });

  } catch (error) {
    console.error('删除菜品失败:', error);
    res.status(500).json({
      success: false,
      message: '删除菜品失败',
      error: error.message
    });
  }
};

/**
 * 批量更新菜品价格
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.batchUpdatePrices = async (req, res) => {
  try {
    const { percentage, category, dishIds } = req.body;

    if (!percentage || isNaN(percentage)) {
      return res.status(400).json({
        success: false,
        message: '价格调整百分比必须是有效数字'
      });
    }

    const filters = {};
    if (category) filters.category = category;
    if (dishIds && Array.isArray(dishIds)) filters._id = { $in: dishIds };

    const result = await StoreDish.batchUpdatePrices(
      req.user.franchiseStoreId,
      percentage,
      filters
    );

    res.json({
      success: true,
      message: `成功调整 ${result.updated} 个菜品的价格`,
      data: result
    });

  } catch (error) {
    console.error('批量更新价格失败:', error);
    res.status(500).json({
      success: false,
      message: '批量更新价格失败',
      error: error.message
    });
  }
};

/**
 * 获取热销菜品
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含热销菜品列表的JSON响应
 */
exports.getBestSellers = async (req, res) => {
  try {
    const { limit = 10 } = req.query;

    const bestSellers = await StoreDish.findBestSellers(
      req.user.franchiseStoreId,
      parseInt(limit)
    );

    res.json({
      success: true,
      message: '获取热销菜品成功',
      data: bestSellers
    });

  } catch (error) {
    console.error('获取热销菜品失败:', error);
    res.status(500).json({
      success: false,
      message: '获取热销菜品失败',
      error: error.message
    });
  }
};

/**
 * 获取库存预警菜品
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含库存预警菜品列表的JSON响应
 */
exports.getLowStockDishes = async (req, res) => {
  try {
    const lowStockDishes = await StoreDish.findLowStock(req.user.franchiseStoreId);

    res.json({
      success: true,
      message: '获取库存预警菜品成功',
      data: lowStockDishes
    });

  } catch (error) {
    console.error('获取库存预警菜品失败:', error);
    res.status(500).json({
      success: false,
      message: '获取库存预警菜品失败',
      error: error.message
    });
  }
};
