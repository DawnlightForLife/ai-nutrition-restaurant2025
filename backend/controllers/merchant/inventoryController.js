/**
 * 库存管理控制器
 * 处理食材库存的增删改查、预警、自动补货等功能
 * @module controllers/merchant/inventoryController
 */

const { IngredientInventory, ALERT_TYPES, STOCK_STATUS } = require('../../models/merchant/ingredientInventoryModel');
const { IngredientNutrition } = require('../../models/nutrition/ingredientNutritionModel');
const { validationResult } = require('express-validator');
const mongoose = require('mongoose');
const inventoryWebSocketService = require('../../services/websocket/inventoryWebSocketService');
const { getMerchantId } = require('../../utils/merchantUtils');

/**
 * 获取库存列表
 */
exports.getInventoryList = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      category,
      status,
      search,
      sortBy = 'name',
      sortOrder = 'asc',
      usageFrequency,
      showLowStock = false,
      showExpiring = false
    } = req.query;

    const merchantId = getMerchantId(req);
    
    // 构建查询条件
    const query = { merchantId, isActive: true };
    
    if (category) query.category = category;
    if (status) query.status = status;
    if (usageFrequency) query['usageStats.usageFrequency'] = usageFrequency;
    
    // 特殊过滤
    if (showLowStock === 'true') {
      query.status = { $in: [STOCK_STATUS.LOW, STOCK_STATUS.CRITICAL, STOCK_STATUS.OUT] };
    }
    
    if (showExpiring === 'true') {
      const threeDaysLater = new Date();
      threeDaysLater.setDate(threeDaysLater.getDate() + 3);
      query['stockBatches.expiryDate'] = { $lte: threeDaysLater, $gt: new Date() };
    }

    // 搜索条件
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { chineseName: { $regex: search, $options: 'i' } },
        { 'stockBatches.batchNumber': { $regex: search, $options: 'i' } }
      ];
    }

    // 排序
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 执行查询
    const inventories = await IngredientInventory.find(query)
      .populate('ingredientId')
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit));

    // 获取总数
    const total = await IngredientInventory.countDocuments(query);

    // 计算统计信息
    const stats = await IngredientInventory.aggregate([
      { $match: { merchantId: mongoose.Types.ObjectId(merchantId), isActive: true } },
      {
        $group: {
          _id: null,
          totalItems: { $sum: 1 },
          totalValue: { $sum: '$costAnalysis.totalInventoryValue' },
          lowStockCount: {
            $sum: {
              $cond: [{ $eq: ['$status', STOCK_STATUS.LOW] }, 1, 0]
            }
          },
          criticalStockCount: {
            $sum: {
              $cond: [{ $eq: ['$status', STOCK_STATUS.CRITICAL] }, 1, 0]
            }
          },
          outOfStockCount: {
            $sum: {
              $cond: [{ $eq: ['$status', STOCK_STATUS.OUT] }, 1, 0]
            }
          },
          averageStockLevel: { $avg: '$stockPercentage' }
        }
      }
    ]);

    res.json({
      success: true,
      message: '获取库存列表成功',
      data: {
        inventories,
        pagination: {
          current: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        },
        statistics: stats[0] || {
          totalItems: 0,
          totalValue: 0,
          lowStockCount: 0,
          criticalStockCount: 0,
          outOfStockCount: 0,
          averageStockLevel: 0
        }
      }
    });

  } catch (error) {
    console.error('获取库存列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取库存列表失败',
      error: error.message
    });
  }
};

/**
 * 获取库存详情
 */
exports.getInventoryById = async (req, res) => {
  try {
    const { inventoryId } = req.params;
    const merchantId = getMerchantId(req);

    const inventory = await IngredientInventory.findOne({
      _id: inventoryId,
      merchantId
    }).populate('ingredientId');

    if (!inventory) {
      return res.status(404).json({
        success: false,
        message: '库存记录不存在或无权限访问'
      });
    }

    // 获取即将过期的批次
    const expiringBatches = inventory.getExpiringBatches(7); // 7天内过期

    // 计算使用预测
    const usagePrediction = {
      estimatedDaysRemaining: inventory.estimatedDaysRemaining,
      daysUntilReorder: inventory.daysUntilReorder,
      recommendedOrderQuantity: inventory.reorderQuantity || 0
    };

    res.json({
      success: true,
      message: '获取库存详情成功',
      data: {
        inventory,
        expiringBatches,
        usagePrediction,
        nutritionInfo: inventory.ingredientId
      }
    });

  } catch (error) {
    console.error('获取库存详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取库存详情失败',
      error: error.message
    });
  }
};

/**
 * 创建库存记录
 */
exports.createInventory = async (req, res) => {
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
      ingredientId,
      name,
      chineseName,
      category,
      minThreshold,
      maxCapacity,
      optimalLevel,
      reorderPoint,
      reorderQuantity,
      initialStock = {},
      alertSettings = {},
      autoReorderSettings = {}
    } = req.body;

    const merchantId = getMerchantId(req);

    // 检查是否已存在
    const existing = await IngredientInventory.findOne({
      merchantId,
      $or: [
        { ingredientId },
        { name },
        { chineseName }
      ]
    });

    if (existing) {
      return res.status(400).json({
        success: false,
        message: '该食材库存记录已存在'
      });
    }

    // 验证营养信息是否存在
    let ingredientNutrition = null;
    if (ingredientId) {
      ingredientNutrition = await IngredientNutrition.findById(ingredientId);
      if (!ingredientNutrition) {
        return res.status(400).json({
          success: false,
          message: '食材营养信息不存在'
        });
      }
    }

    // 创建库存记录
    const inventory = new IngredientInventory({
      merchantId,
      ingredientId: ingredientId || null,
      name: name || ingredientNutrition?.name,
      chineseName: chineseName || ingredientNutrition?.chineseName,
      category: category || ingredientNutrition?.category,
      minThreshold,
      maxCapacity,
      optimalLevel: optimalLevel || Math.floor(maxCapacity * 0.7),
      reorderPoint: reorderPoint || minThreshold * 2,
      reorderQuantity: reorderQuantity || Math.floor(maxCapacity * 0.5),
      alertSettings: {
        lowStockAlert: true,
        expiryAlert: true,
        qualityAlert: true,
        alertDaysBefore: 3,
        ...alertSettings
      },
      autoReorderSettings: {
        enabled: false,
        ...autoReorderSettings
      },
      stockBatches: [],
      usageStats: {
        dailyConsumption: 0,
        weeklyConsumption: 0,
        monthlyConsumption: 0,
        usageFrequency: 'medium'
      },
      costAnalysis: {
        averagePurchasePrice: 0,
        totalInventoryValue: 0,
        wasteValue: 0
      }
    });

    // 如果有初始库存，添加初始批次
    if (initialStock.quantity && initialStock.quantity > 0) {
      const batchData = {
        batchNumber: initialStock.batchNumber || `INIT_${Date.now()}`,
        quantity: initialStock.quantity,
        unit: initialStock.unit || 'kg',
        purchaseDate: initialStock.purchaseDate || new Date(),
        expiryDate: initialStock.expiryDate || new Date(Date.now() + 30 * 24 * 60 * 60 * 1000), // 默认30天
        purchasePrice: initialStock.purchasePrice || 0,
        supplier: initialStock.supplier || { name: '初始库存' },
        qualityGrade: initialStock.qualityGrade || 'A',
        storageLocation: initialStock.storageLocation || '',
        notes: initialStock.notes || '初始库存'
      };

      inventory.addStock(batchData);
    }

    await inventory.save();

    const result = await IngredientInventory.findById(inventory._id)
      .populate('ingredientId');

    res.status(201).json({
      success: true,
      message: '库存记录创建成功',
      data: result
    });

  } catch (error) {
    console.error('创建库存记录失败:', error);
    res.status(500).json({
      success: false,
      message: '创建库存记录失败',
      error: error.message
    });
  }
};

/**
 * 入库操作
 */
exports.addStock = async (req, res) => {
  try {
    const { inventoryId } = req.params;
    const {
      batchNumber,
      quantity,
      unit,
      expiryDate,
      purchasePrice,
      supplier = {},
      qualityGrade = 'A',
      storageLocation = '',
      notes = ''
    } = req.body;

    const merchantId = getMerchantId(req);

    const inventory = await IngredientInventory.findOne({
      _id: inventoryId,
      merchantId
    });

    if (!inventory) {
      return res.status(404).json({
        success: false,
        message: '库存记录不存在或无权限访问'
      });
    }

    // 检查批次号是否唯一
    const existingBatch = inventory.stockBatches.find(
      batch => batch.batchNumber === batchNumber
    );

    if (existingBatch) {
      return res.status(400).json({
        success: false,
        message: '批次号已存在'
      });
    }

    // 添加新批次
    const batchData = {
      batchNumber,
      quantity: parseFloat(quantity),
      unit,
      purchaseDate: new Date(),
      expiryDate: new Date(expiryDate),
      purchasePrice: parseFloat(purchasePrice),
      supplier,
      qualityGrade,
      storageLocation,
      notes
    };

    inventory.addStock(batchData);
    await inventory.save();

    // 触发WebSocket通知
    await inventoryWebSocketService.notifyInventoryUpdate(merchantId, inventory);

    res.json({
      success: true,
      message: '入库成功',
      data: {
        inventory,
        newBatch: batchData
      }
    });

  } catch (error) {
    console.error('入库操作失败:', error);
    res.status(500).json({
      success: false,
      message: '入库操作失败',
      error: error.message
    });
  }
};

/**
 * 出库操作
 */
exports.consumeStock = async (req, res) => {
  try {
    const { inventoryId } = req.params;
    const { quantity, reason = '菜品制作', orderId = null } = req.body;

    const merchantId = getMerchantId(req);

    const inventory = await IngredientInventory.findOne({
      _id: inventoryId,
      merchantId
    });

    if (!inventory) {
      return res.status(404).json({
        success: false,
        message: '库存记录不存在或无权限访问'
      });
    }

    if (quantity <= 0) {
      return res.status(400).json({
        success: false,
        message: '出库数量必须大于0'
      });
    }

    if (inventory.availableStock < quantity) {
      return res.status(400).json({
        success: false,
        message: `可用库存不足，当前可用: ${inventory.availableStock}`
      });
    }

    // 执行出库
    const actualConsumed = inventory.consumeStock(parseFloat(quantity));
    
    // 更新使用统计
    const now = new Date();
    inventory.usageStats.lastUsed = now;
    
    // 简单的使用量统计更新
    if (inventory.usageStats.dailyConsumption) {
      inventory.usageStats.dailyConsumption = 
        (inventory.usageStats.dailyConsumption + actualConsumed) / 2;
    } else {
      inventory.usageStats.dailyConsumption = actualConsumed;
    }

    await inventory.save();

    // 触发WebSocket通知
    await inventoryWebSocketService.notifyInventoryUpdate(merchantId, inventory);

    res.json({
      success: true,
      message: '出库成功',
      data: {
        actualConsumed,
        remainingStock: inventory.availableStock,
        reason,
        orderId
      }
    });

  } catch (error) {
    console.error('出库操作失败:', error);
    res.status(500).json({
      success: false,
      message: '出库操作失败',
      error: error.message
    });
  }
};

/**
 * 库存预警
 */
exports.getInventoryAlerts = async (req, res) => {
  try {
    const merchantId = getMerchantId(req);
    
    const alerts = await IngredientInventory.getInventoryAlerts(merchantId);

    // 分类整理预警
    const categorizedAlerts = {
      lowStock: [],
      critical: [],
      expiring: [],
      expired: []
    };

    alerts.forEach(item => {
      item.alerts.forEach(alert => {
        switch (alert.type) {
          case 'low_stock':
            if (alert.severity === 'critical') {
              categorizedAlerts.critical.push({
                ...alert,
                inventoryId: item._id,
                name: item.name,
                chineseName: item.chineseName
              });
            } else {
              categorizedAlerts.lowStock.push({
                ...alert,
                inventoryId: item._id,
                name: item.name,
                chineseName: item.chineseName
              });
            }
            break;
          case 'expiring_soon':
            categorizedAlerts.expiring.push({
              ...alert,
              inventoryId: item._id,
              name: item.name,
              chineseName: item.chineseName
            });
            break;
          case 'expired':
            categorizedAlerts.expired.push({
              ...alert,
              inventoryId: item._id,
              name: item.name,
              chineseName: item.chineseName
            });
            break;
        }
      });
    });

    // 计算预警统计
    const alertStats = {
      total: alerts.length,
      lowStock: categorizedAlerts.lowStock.length,
      critical: categorizedAlerts.critical.length,
      expiring: categorizedAlerts.expiring.length,
      expired: categorizedAlerts.expired.length
    };

    res.json({
      success: true,
      message: '获取库存预警成功',
      data: {
        alerts: categorizedAlerts,
        statistics: alertStats
      }
    });

  } catch (error) {
    console.error('获取库存预警失败:', error);
    res.status(500).json({
      success: false,
      message: '获取库存预警失败',
      error: error.message
    });
  }
};

/**
 * 清理过期库存
 */
exports.removeExpiredStock = async (req, res) => {
  try {
    const { inventoryId } = req.params;
    const merchantId = getMerchantId(req);

    const inventory = await IngredientInventory.findOne({
      _id: inventoryId,
      merchantId
    });

    if (!inventory) {
      return res.status(404).json({
        success: false,
        message: '库存记录不存在或无权限访问'
      });
    }

    const result = inventory.removeExpiredStock();
    await inventory.save();

    res.json({
      success: true,
      message: '过期库存清理完成',
      data: {
        removedBatches: result.removedBatches,
        wasteValue: result.wasteValue,
        remainingStock: inventory.availableStock
      }
    });

  } catch (error) {
    console.error('清理过期库存失败:', error);
    res.status(500).json({
      success: false,
      message: '清理过期库存失败',
      error: error.message
    });
  }
};

/**
 * 库存分析报告
 */
exports.getInventoryAnalytics = async (req, res) => {
  try {
    const { period = '30d' } = req.query;
    const merchantId = getMerchantId(req);

    // 计算时间范围
    const days = parseInt(period.replace('d', ''));
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const analytics = await IngredientInventory.aggregate([
      { $match: { merchantId: mongoose.Types.ObjectId(merchantId), isActive: true } },
      {
        $facet: {
          // 库存概览
          overview: [
            {
              $group: {
                _id: null,
                totalItems: { $sum: 1 },
                totalValue: { $sum: '$costAnalysis.totalInventoryValue' },
                totalWaste: { $sum: '$costAnalysis.wasteValue' },
                averageTurnover: { $avg: '$costAnalysis.turnoverRate' },
                lowStockCount: {
                  $sum: {
                    $cond: [
                      { $in: ['$status', [STOCK_STATUS.LOW, STOCK_STATUS.CRITICAL, STOCK_STATUS.OUT]] },
                      1,
                      0
                    ]
                  }
                }
              }
            }
          ],
          // 类别分布
          categoryDistribution: [
            {
              $group: {
                _id: '$category',
                count: { $sum: 1 },
                totalValue: { $sum: '$costAnalysis.totalInventoryValue' }
              }
            },
            { $sort: { count: -1 } }
          ],
          // 使用频率分析
          usageFrequency: [
            {
              $group: {
                _id: '$usageStats.usageFrequency',
                count: { $sum: 1 },
                avgConsumption: { $avg: '$usageStats.dailyConsumption' }
              }
            }
          ],
          // 供应商分析
          supplierAnalysis: [
            { $unwind: '$suppliers' },
            { $match: { 'suppliers.isActive': true } },
            {
              $group: {
                _id: '$suppliers.name',
                itemCount: { $sum: 1 },
                avgPrice: { $avg: '$suppliers.pricePerUnit' },
                avgQuality: { $avg: '$suppliers.qualityRating' },
                avgReliability: { $avg: '$suppliers.reliabilityRating' }
              }
            },
            { $sort: { itemCount: -1 } },
            { $limit: 10 }
          ]
        }
      }
    ]);

    const result = analytics[0];

    // 计算库存健康评分
    const overview = result.overview[0] || {};
    const healthScore = Math.round(
      ((overview.totalItems - overview.lowStockCount) / overview.totalItems) * 100
    ) || 0;

    res.json({
      success: true,
      message: '获取库存分析报告成功',
      data: {
        period,
        overview: {
          ...overview,
          healthScore,
          wastePercentage: overview.totalValue > 0 
            ? Math.round((overview.totalWaste / overview.totalValue) * 100)
            : 0
        },
        categoryDistribution: result.categoryDistribution,
        usageFrequency: result.usageFrequency,
        supplierAnalysis: result.supplierAnalysis
      }
    });

  } catch (error) {
    console.error('获取库存分析失败:', error);
    res.status(500).json({
      success: false,
      message: '获取库存分析失败',
      error: error.message
    });
  }
};

/**
 * 更新库存设置
 */
exports.updateInventorySettings = async (req, res) => {
  try {
    const { inventoryId } = req.params;
    const updates = req.body;
    const merchantId = getMerchantId(req);

    const inventory = await IngredientInventory.findOne({
      _id: inventoryId,
      merchantId
    });

    if (!inventory) {
      return res.status(404).json({
        success: false,
        message: '库存记录不存在或无权限访问'
      });
    }

    // 允许更新的字段
    const allowedFields = [
      'minThreshold', 'maxCapacity', 'optimalLevel', 'reorderPoint', 
      'reorderQuantity', 'alertSettings', 'autoReorderSettings'
    ];

    Object.keys(updates).forEach(key => {
      if (allowedFields.includes(key)) {
        if (key === 'alertSettings' || key === 'autoReorderSettings') {
          inventory[key] = { ...inventory[key], ...updates[key] };
        } else {
          inventory[key] = updates[key];
        }
      }
    });

    await inventory.save();

    res.json({
      success: true,
      message: '库存设置更新成功',
      data: inventory
    });

  } catch (error) {
    console.error('更新库存设置失败:', error);
    res.status(500).json({
      success: false,
      message: '更新库存设置失败',
      error: error.message
    });
  }
};

module.exports = exports;