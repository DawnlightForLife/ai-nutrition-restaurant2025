/**
 * 订单控制器
 * 处理订单相关的所有请求，包括下单、支付、订单管理等
 * @module controllers/order/orderController
 */

const Order = require('../../models/order/orderModel');
const StoreDish = require('../../models/merchant/storeDishModel');
const { validationResult } = require('express-validator');

// ✅ 命名风格 camelCase
// ✅ 所有方法为 async 函数
// ✅ 返回结构统一为 { success, message, data? }
// ✅ 支持权限验证和资源权限检查

/**
 * 生成订单号
 * @returns {string} 唯一订单号
 */
function generateOrderNumber() {
  const timestamp = Date.now().toString();
  const randomStr = Math.random().toString(36).substring(2, 8).toUpperCase();
  return `ORD${timestamp}${randomStr}`;
}

/**
 * 创建订单
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建订单的JSON响应
 */
exports.createOrder = async (req, res) => {
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
      storeId,
      items,
      deliveryAddress,
      contactPhone,
      notes,
      orderType = 'takeout' // takeout, dine_in, delivery
    } = req.body;

    // 验证订单项
    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({
        success: false,
        message: '订单必须包含至少一个商品'
      });
    }

    // 验证每个商品的可用性和价格
    let totalAmount = 0;
    const validatedItems = [];

    for (const item of items) {
      const storeDish = await StoreDish.findOne({
        _id: item.dishId,
        storeId: storeId,
        isAvailable: true
      }).populate('dishId');

      if (!storeDish) {
        return res.status(400).json({
          success: false,
          message: `商品 ${item.dishId} 不存在或不可用`
        });
      }

      // 检查库存
      if (storeDish.inventory && storeDish.inventory.currentStock < item.quantity) {
        return res.status(400).json({
          success: false,
          message: `商品 ${storeDish.dishId.name} 库存不足`
        });
      }

      const unitPrice = storeDish.effectivePrice || storeDish.priceOverride;
      const itemTotal = unitPrice * item.quantity;
      totalAmount += itemTotal;

      validatedItems.push({
        dishId: item.dishId,
        storeDishId: storeDish._id,
        name: storeDish.dishId.name,
        quantity: item.quantity,
        unitPrice: unitPrice,
        totalPrice: itemTotal,
        specifications: item.specifications || {}
      });

      // 减少库存
      if (storeDish.inventory) {
        await storeDish.updateStock(-item.quantity);
      }
    }

    // 创建订单
    const order = new Order({
      orderNumber: generateOrderNumber(),
      userId: req.user._id,
      storeId: storeId,
      items: validatedItems,
      totalAmount: totalAmount,
      status: 'pending_payment',
      orderType: orderType,
      deliveryAddress: deliveryAddress,
      contactPhone: contactPhone || req.user.phone,
      notes: notes || '',
      paymentStatus: 'unpaid',
      createdAt: new Date()
    });

    await order.save();

    res.status(201).json({
      success: true,
      message: '订单创建成功',
      data: order
    });

  } catch (error) {
    console.error('创建订单失败:', error);
    res.status(500).json({
      success: false,
      message: '创建订单失败',
      error: error.message
    });
  }
};

/**
 * 获取订单列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含订单列表的JSON响应
 */
exports.getOrderList = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      status,
      orderType,
      startDate,
      endDate,
      storeId
    } = req.query;

    // 构建查询条件
    const query = {};

    // 根据用户角色限制查询范围
    if (req.user.role === 'customer') {
      query.userId = req.user._id;
    } else if (['store_manager', 'store_staff'].includes(req.user.role)) {
      // 商家只能看到自己店铺的订单
      query.storeId = storeId || req.user.franchiseStoreId;
    }

    if (status) {
      query.status = status;
    }

    if (orderType) {
      query.orderType = orderType;
    }

    // 时间范围过滤
    if (startDate || endDate) {
      query.createdAt = {};
      if (startDate) {
        query.createdAt.$gte = new Date(startDate);
      }
      if (endDate) {
        query.createdAt.$lte = new Date(endDate);
      }
    }

    // 分页计算
    const skip = (parseInt(page) - 1) * parseInt(limit);

    // 执行查询
    const orders = await Order.find(query)
      .populate('userId', 'nickname phone')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(parseInt(limit));

    const total = await Order.countDocuments(query);

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
 * 获取单个订单详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个订单的JSON响应
 */
exports.getOrderById = async (req, res) => {
  try {
    const { orderId } = req.params;

    const order = await Order.findById(orderId)
      .populate('userId', 'nickname phone email');

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在'
      });
    }

    // 权限检查：用户只能查看自己的订单，商家只能查看自己店铺的订单
    if (req.user.role === 'customer' && order.userId._id.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权限访问此订单'
      });
    }

    if (['store_manager', 'store_staff'].includes(req.user.role) && 
        order.storeId.toString() !== req.user.franchiseStoreId.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权限访问此订单'
      });
    }

    res.json({
      success: true,
      message: '获取订单详情成功',
      data: order
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
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后订单的JSON响应
 */
exports.updateOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { status, paymentStatus, notes } = req.body;

    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在'
      });
    }

    // 权限检查
    if (req.user.role === 'customer' && order.userId.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权限修改此订单'
      });
    }

    if (['store_manager', 'store_staff'].includes(req.user.role) && 
        order.storeId.toString() !== req.user.franchiseStoreId.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权限修改此订单'
      });
    }

    // 更新允许的字段
    if (status) {
      order.status = status;
      order.statusHistory.push({
        status: status,
        timestamp: new Date(),
        operator: req.user._id,
        notes: notes || ''
      });
    }

    if (paymentStatus && ['store_manager', 'admin'].includes(req.user.role)) {
      order.paymentStatus = paymentStatus;
      if (paymentStatus === 'paid') {
        order.paidAt = new Date();
      }
    }

    if (notes) {
      order.notes = notes;
    }

    order.updatedAt = new Date();
    await order.save();

    res.json({
      success: true,
      message: '订单更新成功',
      data: order
    });

  } catch (error) {
    console.error('更新订单失败:', error);
    res.status(500).json({
      success: false,
      message: '更新订单失败',
      error: error.message
    });
  }
};

/**
 * 取消订单
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 */
exports.cancelOrder = async (req, res) => {
  try {
    const { orderId } = req.params;
    const { reason } = req.body;

    const order = await Order.findById(orderId);

    if (!order) {
      return res.status(404).json({
        success: false,
        message: '订单不存在'
      });
    }

    // 权限检查
    if (req.user.role === 'customer' && order.userId.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        success: false,
        message: '无权限取消此订单'
      });
    }

    // 检查订单状态是否允许取消
    if (!['pending_payment', 'paid', 'confirmed'].includes(order.status)) {
      return res.status(400).json({
        success: false,
        message: '当前订单状态不允许取消'
      });
    }

    // 恢复库存
    for (const item of order.items) {
      const storeDish = await StoreDish.findById(item.storeDishId);
      if (storeDish && storeDish.inventory) {
        await storeDish.updateStock(item.quantity);
      }
    }

    // 更新订单状态
    order.status = 'cancelled';
    order.cancelledAt = new Date();
    order.cancelReason = reason || '用户取消';
    order.statusHistory.push({
      status: 'cancelled',
      timestamp: new Date(),
      operator: req.user._id,
      notes: reason || '用户取消'
    });

    await order.save();

    res.json({
      success: true,
      message: '订单已取消',
      data: order
    });

  } catch (error) {
    console.error('取消订单失败:', error);
    res.status(500).json({
      success: false,
      message: '取消订单失败',
      error: error.message
    });
  }
};
