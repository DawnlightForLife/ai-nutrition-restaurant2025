/**
 * 订单处理控制器
 * 处理商家端订单管理、状态更新、制作流程追踪等功能
 * @module controllers/merchant/orderProcessingController
 */

const Order = require('../../models/order/orderModel');
const { IngredientInventory } = require('../../models/merchant/ingredientInventoryModel');
const StoreDish = require('../../models/merchant/storeDishModel');
const { validationResult } = require('express-validator');
const mongoose = require('mongoose');
const orderTrackingWebSocketService = require('../../services/websocket/orderTrackingWebSocketService');
const deliveryService = require('../../services/delivery/deliveryService');

/**
 * 获取商家订单列表
 */
exports.getOrderList = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      status,
      orderType,
      dateFrom,
      dateTo,
      search,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = req.query;

    const merchantId = req.user.merchantId || req.user.franchiseStoreId;
    
    // 构建查询条件
    const query = { merchantId };
    
    if (status) {
      if (status.includes(',')) {
        query.status = { $in: status.split(',') };
      } else {
        query.status = status;
      }
    }
    
    if (orderType) query.orderType = orderType;
    
    // 日期范围
    if (dateFrom || dateTo) {
      query.createdAt = {};
      if (dateFrom) query.createdAt.$gte = new Date(dateFrom);
      if (dateTo) query.createdAt.$lte = new Date(dateTo);
    }

    // 搜索条件
    if (search) {
      query.$or = [
        { orderNumber: { $regex: search, $options: 'i' } },
        { 'delivery.contactName': { $regex: search, $options: 'i' } },
        { 'delivery.contactPhone': { $regex: search, $options: 'i' } },
        { 'items.name': { $regex: search, $options: 'i' } }
      ];
    }

    // 排序
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 分页
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 执行查询
    const orders = await Order.find(query)
      .populate('userId', 'nickname phone')
      .populate('nutritionProfileId')
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit));

    // 获取总数
    const total = await Order.countDocuments(query);

    // 获取统计信息
    const stats = await Order.aggregate([
      { $match: { merchantId: mongoose.Types.ObjectId(merchantId) } },
      {
        $group: {
          _id: null,
          totalOrders: { $sum: 1 },
          pendingOrders: {
            $sum: { $cond: [{ $eq: ['$status', 'pending'] }, 1, 0] }
          },
          preparingOrders: {
            $sum: { $cond: [{ $eq: ['$status', 'preparing'] }, 1, 0] }
          },
          readyOrders: {
            $sum: { $cond: [{ $eq: ['$status', 'ready'] }, 1, 0] }
          },
          deliveryOrders: {
            $sum: { $cond: [{ $eq: ['$status', 'in_delivery'] }, 1, 0] }
          },
          totalRevenue: { $sum: '$priceDetails.total' },
          averageOrderValue: { $avg: '$priceDetails.total' }
        }
      }
    ]);

    res.json({
      success: true,
      message: '获取订单列表成功',
      data: {
        orders,
        pagination: {
          current: parseInt(page),
          limit: parseInt(limit),
          total,
          pages: Math.ceil(total / parseInt(limit))
        },
        statistics: stats[0] || {
          totalOrders: 0,
          pendingOrders: 0,
          preparingOrders: 0,
          readyOrders: 0,
          deliveryOrders: 0,
          totalRevenue: 0,
          averageOrderValue: 0
        }
      }
    });

  } catch (error) {
    console.error('获取订单列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取订单列表失败',
      error: error.message
    });
  }
};

/**
 * 获取订单详情
 */
exports.getOrderById = async (req, res) => {
  try {
    const { orderId } = req.params;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    const order = await Order.findOne({
      _id: orderId,
      merchantId
    })
    .populate('userId', 'nickname phone avatar')
    .populate('nutritionProfileId')
    .populate({
      path: 'items.dishId',
      select: 'name description imageUrl nutritionFacts'
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在或无权限访问'
      });
    }

    // 检查制作所需的库存情况
    const ingredientRequirements = [];
    for (const item of order.items) {
      if (item.dishId && item.dishId.ingredients) {
        for (const ingredient of item.dishId.ingredients) {
          const inventory = await IngredientInventory.findOne({
            merchantId,
            name: ingredient,
            isActive: true
          });
          
          const requiredQuantity = item.quantity * 0.1; // 假设每份菜品需要0.1单位食材
          
          ingredientRequirements.push({
            ingredient,
            required: requiredQuantity,
            available: inventory ? inventory.availableStock : 0,
            sufficient: inventory ? inventory.availableStock >= requiredQuantity : false,
            unit: inventory ? inventory.stockBatches[0]?.unit : 'g'
          });
        }
      }
    }

    // 计算制作时间估算
    const totalPreparationTime = order.items.reduce((total, item) => {
      const dishPrepTime = item.dishId?.preparationTime || 15; // 默认15分钟
      return total + (dishPrepTime * item.quantity);
    }, 0);

    res.json({
      success: true,
      message: '获取订单详情成功',
      data: {
        order,
        ingredientRequirements,
        canProduce: ingredientRequirements.every(req => req.sufficient),
        estimatedPreparationTime: totalPreparationTime,
        productionCapacity: Math.min(...ingredientRequirements.map(req => 
          Math.floor(req.available / req.required)
        ))
      }
    });

  } catch (error) {
    console.error('获取订单详情失败:', error);
    res.status(500).json({
      success: false,
      message: '获取订单详情失败',
      error: error.message
    });
  }
};

/**
 * 更新订单状态
 */
exports.updateOrderStatus = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status, reason, estimatedTime } = req.body;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    const order = await Order.findOne({
      _id: orderId,
      merchantId
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在或无权限访问'
      });
    }

    // 验证状态转换
    const validTransitions = {
      'pending': ['confirmed', 'cancelled'],
      'confirmed': ['preparing', 'cancelled'],
      'preparing': ['ready', 'cancelled'],
      'ready': ['in_delivery', 'completed', 'cancelled'],
      'in_delivery': ['delivered', 'cancelled'],
      'delivered': ['completed'],
      'completed': [],
      'cancelled': []
    };

    if (!validTransitions[order.status].includes(status)) {
      return res.status(400).json({
        success: false,
        message: `无效的状态转换: ${order.status} -> ${status}`
      });
    }

    // 特殊处理逻辑
    if (status === 'confirmed') {
      // 确认订单时检查库存并预留
      for (const item of order.items) {
        if (item.dishId) {
          const storeDish = await StoreDish.findById(item.dishId);
          if (storeDish && storeDish.ingredients) {
            for (const ingredient of storeDish.ingredients) {
              const inventory = await IngredientInventory.findOne({
                merchantId,
                name: ingredient,
                isActive: true
              });
              
              if (inventory) {
                const requiredQuantity = item.quantity * 0.1; // 每份需要0.1单位
                if (!inventory.reserveStock(requiredQuantity)) {
                  return res.status(400).json({
                    success: false,
                    message: `食材 ${ingredient} 库存不足，无法确认订单`
                  });
                }
                await inventory.save();
              }
            }
          }
        }
      }
    }

    if (status === 'preparing') {
      // 开始制作时消耗库存
      for (const item of order.items) {
        if (item.dishId) {
          const storeDish = await StoreDish.findById(item.dishId);
          if (storeDish && storeDish.ingredients) {
            for (const ingredient of storeDish.ingredients) {
              const inventory = await IngredientInventory.findOne({
                merchantId,
                name: ingredient,
                isActive: true
              });
              
              if (inventory) {
                const requiredQuantity = item.quantity * 0.1;
                inventory.consumeStock(requiredQuantity);
                inventory.releaseReservedStock(requiredQuantity);
                await inventory.save();
              }
            }
          }
        }
      }

      // 设置预计完成时间
      if (estimatedTime) {
        order.dineIn = order.dineIn || {};
        order.dineIn.estimatedCompletionTime = new Date(Date.now() + estimatedTime * 60000);
      }
    }

    if (status === 'cancelled') {
      // 取消订单时释放预留库存
      for (const item of order.items) {
        if (item.dishId) {
          const storeDish = await StoreDish.findById(item.dishId);
          if (storeDish && storeDish.ingredients) {
            for (const ingredient of storeDish.ingredients) {
              const inventory = await IngredientInventory.findOne({
                merchantId,
                name: ingredient,
                isActive: true
              });
              
              if (inventory) {
                const requiredQuantity = item.quantity * 0.1;
                inventory.releaseReservedStock(requiredQuantity);
                await inventory.save();
              }
            }
          }
        }
      }
    }

    // 保存旧状态
    const oldStatus = order.status;
    
    // 更新订单状态
    order.updateStatus(status, reason);
    
    // 记录操作者
    if (!order.statusHistory) order.statusHistory = [];
    order.statusHistory[order.statusHistory.length - 1].updatedBy = req.user._id;
    order.statusHistory[order.statusHistory.length - 1].updatedByType = 'Merchant';

    await order.save();

    // 发送WebSocket通知
    await orderTrackingWebSocketService.notifyOrderStatusChange(order, oldStatus, status);

    res.json({
      success: true,
      message: `订单状态已更新为: ${status}`,
      data: {
        orderId: order._id,
        oldStatus: oldStatus,
        newStatus: status,
        estimatedCompletionTime: order.dineIn?.estimatedCompletionTime
      }
    });

  } catch (error) {
    console.error('更新订单状态失败:', error);
    res.status(500).json({
      success: false,
      message: '更新订单状态失败',
      error: error.message
    });
  }
};

/**
 * 批量更新订单状态
 */
exports.batchUpdateOrderStatus = async (req, res) => {
  try {
    const { orderIds, status, reason } = req.body;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    if (!orderIds || !Array.isArray(orderIds) || orderIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请选择要操作的订单'
      });
    }

    const results = {
      success: [],
      failed: []
    };

    for (const orderId of orderIds) {
      try {
        const order = await Order.findOne({
          _id: orderId,
          merchantId
        });

        if (!order) {
          results.failed.push({
            orderId,
            reason: '订单不存在或无权限访问'
          });
          continue;
        }

        order.updateStatus(status, reason);
        order.statusHistory[order.statusHistory.length - 1].updatedBy = req.user._id;
        order.statusHistory[order.statusHistory.length - 1].updatedByType = 'Merchant';
        
        await order.save();
        
        results.success.push({
          orderId,
          orderNumber: order.orderNumber,
          newStatus: status
        });

      } catch (error) {
        results.failed.push({
          orderId,
          reason: error.message
        });
      }
    }

    res.json({
      success: true,
      message: `批量更新完成，成功: ${results.success.length}，失败: ${results.failed.length}`,
      data: results
    });

  } catch (error) {
    console.error('批量更新订单状态失败:', error);
    res.status(500).json({
      success: false,
      message: '批量更新订单状态失败',
      error: error.message
    });
  }
};

/**
 * 获取生产队列
 */
exports.getProductionQueue = async (req, res) => {
  try {
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    // 获取需要制作的订单
    const productionOrders = await Order.find({
      merchantId,
      status: { $in: ['confirmed', 'preparing'] },
      orderType: { $in: ['dine_in', 'takeout'] }
    })
    .populate('userId', 'nickname phone')
    .sort({ createdAt: 1 });

    // 计算制作时间和优先级
    const queue = productionOrders.map(order => {
      const totalPrepTime = order.items.reduce((total, item) => {
        return total + ((item.preparationTime || 15) * item.quantity);
      }, 0);

      const priority = order.status === 'preparing' ? 'high' : 'normal';
      const waitingTime = Date.now() - order.createdAt.getTime();
      
      return {
        orderId: order._id,
        orderNumber: order.orderNumber,
        status: order.status,
        customer: order.userId,
        items: order.items,
        totalPreparationTime: totalPrepTime,
        priority,
        waitingTime: Math.round(waitingTime / 60000), // 分钟
        tableNumber: order.dineIn?.tableNumber,
        estimatedCompletionTime: order.dineIn?.estimatedCompletionTime,
        createdAt: order.createdAt
      };
    });

    // 按优先级和等待时间排序
    queue.sort((a, b) => {
      if (a.priority !== b.priority) {
        return a.priority === 'high' ? -1 : 1;
      }
      return a.waitingTime - b.waitingTime;
    });

    res.json({
      success: true,
      message: '获取生产队列成功',
      data: {
        queue,
        summary: {
          total: queue.length,
          preparing: queue.filter(q => q.status === 'preparing').length,
          waiting: queue.filter(q => q.status === 'confirmed').length,
          averageWaitTime: queue.length > 0 
            ? Math.round(queue.reduce((sum, q) => sum + q.waitingTime, 0) / queue.length)
            : 0
        }
      }
    });

  } catch (error) {
    console.error('获取生产队列失败:', error);
    res.status(500).json({
      success: false,
      message: '获取生产队列失败',
      error: error.message
    });
  }
};

/**
 * 获取配送管理
 */
exports.getDeliveryManagement = async (req, res) => {
  try {
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    // 获取配送订单
    const deliveryOrders = await Order.find({
      merchantId,
      orderType: 'delivery',
      status: { $in: ['ready', 'in_delivery'] }
    })
    .populate('userId', 'nickname phone')
    .sort({ 'delivery.estimatedDeliveryTime': 1 });

    // 分类订单
    const readyForDelivery = deliveryOrders.filter(order => order.status === 'ready');
    const inDelivery = deliveryOrders.filter(order => order.status === 'in_delivery');

    // 计算配送统计
    const stats = {
      readyCount: readyForDelivery.length,
      deliveryCount: inDelivery.length,
      averageDeliveryTime: 0,
      onTimeRate: 0
    };

    // 计算平均配送时间和准时率
    const completedDeliveries = await Order.find({
      merchantId,
      orderType: 'delivery',
      status: 'delivered',
      'delivery.actualDeliveryTime': { $exists: true },
      createdAt: { $gte: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000) } // 最近7天
    });

    if (completedDeliveries.length > 0) {
      const totalDeliveryTime = completedDeliveries.reduce((total, order) => {
        const deliveryTime = order.delivery.actualDeliveryTime - order.createdAt;
        return total + deliveryTime;
      }, 0);

      stats.averageDeliveryTime = Math.round(totalDeliveryTime / completedDeliveries.length / 60000); // 分钟

      const onTimeDeliveries = completedDeliveries.filter(order => 
        order.delivery.actualDeliveryTime <= order.delivery.estimatedDeliveryTime
      );
      
      stats.onTimeRate = Math.round((onTimeDeliveries.length / completedDeliveries.length) * 100);
    }

    res.json({
      success: true,
      message: '获取配送管理信息成功',
      data: {
        readyForDelivery,
        inDelivery,
        statistics: stats
      }
    });

  } catch (error) {
    console.error('获取配送管理失败:', error);
    res.status(500).json({
      success: false,
      message: '获取配送管理失败',
      error: error.message
    });
  }
};

/**
 * 更新订单制作进度
 */
exports.updateProductionProgress = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { step, progress, notes } = req.body;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    const order = await Order.findOne({
      _id: orderId,
      merchantId
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在或无权限访问'
      });
    }

    // 初始化制作进度对象
    if (!order.productionProgress) {
      order.productionProgress = {};
    }
    
    // 更新特定步骤的进度
    order.productionProgress[step] = {
      status: progress,
      updatedAt: new Date(),
      updatedBy: req.user._id,
      notes
    };

    // 如果是开始制作，自动更新订单状态为preparing
    if (order.status === 'confirmed' && step === 'cooking' && progress === 'in_progress') {
      order.updateStatus('preparing');
    }

    // 检查是否所有步骤完成
    const requiredSteps = ['cooking', 'plating'];
    const allCompleted = requiredSteps.every(s => 
      order.productionProgress[s]?.status === 'completed'
    );

    // 如果所有步骤完成，更新订单状态为ready
    if (allCompleted && order.status === 'preparing') {
      order.updateStatus('ready');
    }

    await order.save();

    res.json({
      success: true,
      message: '制作进度已更新',
      data: {
        orderId: order._id,
        step,
        progress,
        overallStatus: order.status,
        productionProgress: order.productionProgress
      }
    });

  } catch (error) {
    console.error('更新制作进度失败:', error);
    res.status(500).json({
      success: false,
      message: '更新制作进度失败',
      error: error.message
    });
  }
};

/**
 * 订单统计分析
 */
exports.getOrderAnalytics = async (req, res) => {
  try {
    const { period = '7d' } = req.query;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    // 计算时间范围
    const days = parseInt(period.replace('d', ''));
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const analytics = await Order.aggregate([
      {
        $match: {
          merchantId: mongoose.Types.ObjectId(merchantId),
          createdAt: { $gte: startDate }
        }
      },
      {
        $facet: {
          // 总体统计
          overview: [
            {
              $group: {
                _id: null,
                totalOrders: { $sum: 1 },
                totalRevenue: { $sum: '$priceDetails.total' },
                averageOrderValue: { $avg: '$priceDetails.total' },
                completedOrders: {
                  $sum: { $cond: [{ $eq: ['$status', 'completed'] }, 1, 0] }
                },
                cancelledOrders: {
                  $sum: { $cond: [{ $eq: ['$status', 'cancelled'] }, 1, 0] }
                }
              }
            }
          ],
          // 按日期分组
          dailyTrend: [
            {
              $group: {
                _id: {
                  date: { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } }
                },
                orders: { $sum: 1 },
                revenue: { $sum: '$priceDetails.total' }
              }
            },
            { $sort: { '_id.date': 1 } }
          ],
          // 按订单类型分组
          orderTypeDistribution: [
            {
              $group: {
                _id: '$orderType',
                count: { $sum: 1 },
                revenue: { $sum: '$priceDetails.total' }
              }
            }
          ],
          // 热销菜品
          popularDishes: [
            { $unwind: '$items' },
            {
              $group: {
                _id: '$items.dishId',
                name: { $first: '$items.name' },
                totalQuantity: { $sum: '$items.quantity' },
                totalRevenue: { $sum: '$items.itemTotal' }
              }
            },
            { $sort: { totalQuantity: -1 } },
            { $limit: 10 }
          ],
          // 时段分析
          hourlyDistribution: [
            {
              $group: {
                _id: { $hour: '$createdAt' },
                orders: { $sum: 1 },
                revenue: { $sum: '$priceDetails.total' }
              }
            },
            { $sort: { '_id': 1 } }
          ]
        }
      }
    ]);

    const result = analytics[0];
    const overview = result.overview[0] || {};

    // 计算完成率
    const completionRate = overview.totalOrders > 0 
      ? Math.round((overview.completedOrders / overview.totalOrders) * 100)
      : 0;

    const cancellationRate = overview.totalOrders > 0
      ? Math.round((overview.cancelledOrders / overview.totalOrders) * 100)
      : 0;

    res.json({
      success: true,
      message: '获取订单分析成功',
      data: {
        period,
        overview: {
          ...overview,
          completionRate,
          cancellationRate
        },
        dailyTrend: result.dailyTrend,
        orderTypeDistribution: result.orderTypeDistribution,
        popularDishes: result.popularDishes,
        hourlyDistribution: result.hourlyDistribution
      }
    });

  } catch (error) {
    console.error('获取订单分析失败:', error);
    res.status(500).json({
      success: false,
      message: '获取订单分析失败',
      error: error.message
    });
  }
};

/**
 * 分配配送员
 */
exports.assignDeliveryDriver = async (req, res) => {
  try {
    const { orderId } = req.params;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    // 验证订单权限
    const order = await Order.findOne({
      _id: orderId,
      merchantId
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在或无权限访问'
      });
    }

    if (order.status !== 'ready') {
      return res.status(400).json({
        success: false,
        message: '只有准备完成的订单才能分配配送员'
      });
    }

    // 分配配送员
    const result = await deliveryService.assignDeliveryDriver(orderId);

    res.json({
      success: true,
      message: '配送员分配成功',
      data: result
    });

  } catch (error) {
    console.error('分配配送员失败:', error);
    res.status(500).json({
      success: false,
      message: error.message || '分配配送员失败'
    });
  }
};

/**
 * 获取配送员列表
 */
exports.getDeliveryDrivers = async (req, res) => {
  try {
    const drivers = deliveryService.getAllDrivers();
    
    res.json({
      success: true,
      message: '获取配送员列表成功',
      data: drivers
    });

  } catch (error) {
    console.error('获取配送员列表失败:', error);
    res.status(500).json({
      success: false,
      message: '获取配送员列表失败',
      error: error.message
    });
  }
};

/**
 * 获取配送路线
 */
exports.getDeliveryRoute = async (req, res) => {
  try {
    const { orderId } = req.params;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    // 验证订单权限
    const order = await Order.findOne({
      _id: orderId,
      merchantId
    });

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在或无权限访问'
      });
    }

    const route = await deliveryService.getDeliveryRoute(orderId);

    res.json({
      success: true,
      message: '获取配送路线成功',
      data: route
    });

  } catch (error) {
    console.error('获取配送路线失败:', error);
    res.status(500).json({
      success: false,
      message: error.message || '获取配送路线失败'
    });
  }
};

/**
 * 批量分配订单
 */
exports.batchAssignOrders = async (req, res) => {
  try {
    const { orderIds } = req.body;
    const merchantId = req.user.merchantId || req.user.franchiseStoreId;

    if (!orderIds || !Array.isArray(orderIds) || orderIds.length === 0) {
      return res.status(400).json({
        success: false,
        message: '请选择要分配的订单'
      });
    }

    // 验证所有订单权限
    const orders = await Order.find({
      _id: { $in: orderIds },
      merchantId
    });

    if (orders.length !== orderIds.length) {
      return res.status(400).json({
        success: false,
        message: '部分订单不存在或无权限访问'
      });
    }

    const results = await deliveryService.batchAssignOrders(orderIds);

    res.json({
      success: true,
      message: '批量分配完成',
      data: results
    });

  } catch (error) {
    console.error('批量分配订单失败:', error);
    res.status(500).json({
      success: false,
      message: '批量分配订单失败',
      error: error.message
    });
  }
};

module.exports = exports;