/**
 * 下单用例
 * 协调订单领域、支付领域和商家领域，完成订单创建流程
 */
class PlaceOrderUseCase {
  /**
   * @param {Object} dependencies - 依赖注入
   * @param {import('../../../domain/order/repositories/order_repository')} dependencies.orderRepository - 订单仓储
   * @param {import('../../../domain/user/repositories/user_repository')} dependencies.userRepository - 用户仓储
   * @param {import('../../../domain/restaurant/repositories/restaurant_repository')} dependencies.restaurantRepository - 餐厅仓储
   * @param {import('../../../domain/nutrition/repositories/meal_repository')} dependencies.mealRepository - 餐品仓储
   * @param {import('../../../domain/payment/services/payment_service')} dependencies.paymentService - 支付服务
   * @param {import('../../../domain/notification/services/notification_service')} dependencies.notificationService - 通知服务
   */
  constructor({
    orderRepository,
    userRepository,
    restaurantRepository,
    mealRepository,
    paymentService,
    notificationService
  }) {
    this._orderRepository = orderRepository;
    this._userRepository = userRepository;
    this._restaurantRepository = restaurantRepository;
    this._mealRepository = mealRepository;
    this._paymentService = paymentService;
    this._notificationService = notificationService;
  }

  /**
   * 执行下单流程
   * @param {string} userId - 用户ID
   * @param {string} restaurantId - 餐厅ID
   * @param {Array<Object>} orderItems - 订单项列表 [{mealId, quantity, note, customizations}]
   * @param {Object} paymentInfo - 支付信息
   * @param {Object} deliveryInfo - 配送信息
   * @param {string} note - 订单备注
   * @returns {Promise<Object>} 订单创建结果
   */
  async execute(userId, restaurantId, orderItems, paymentInfo, deliveryInfo, note = '') {
    // 1. 验证用户存在
    const user = await this._userRepository.findById(userId);
    if (!user) {
      throw new Error('用户不存在');
    }

    // 2. 验证餐厅存在
    const restaurant = await this._restaurantRepository.findById(restaurantId);
    if (!restaurant) {
      throw new Error('餐厅不存在');
    }

    // 3. 验证餐品信息并构建订单项
    const Order = require('../../../domain/order/entities/order');
    const OrderItem = require('../../../domain/order/value_objects/order_item');
    
    const orderItemEntities = [];
    let subtotal = 0;
    
    for (const item of orderItems) {
      // 获取餐品信息
      const meal = await this._mealRepository.findById(item.mealId);
      if (!meal) {
        throw new Error(`餐品不存在: ${item.mealId}`);
      }
      
      // 创建订单项值对象
      const orderItem = new OrderItem(
        meal.id,
        meal.name,
        item.quantity,
        meal.price,
        item.customizations || {},
        item.note || ''
      );
      
      orderItemEntities.push(orderItem);
      subtotal += orderItem.getTotalPrice();
    }
    
    // 4. 计算税费和配送费
    const tax = this._calculateTax(subtotal, restaurant);
    const deliveryFee = this._calculateDeliveryFee(deliveryInfo, restaurant);
    
    // 5. 创建订单实体
    const order = Order.create(
      userId,
      restaurantId,
      orderItemEntities,
      deliveryInfo,
      paymentInfo,
      subtotal,
      tax,
      deliveryFee,
      0, // 暂时没有折扣
      note
    );
    
    // 6. 处理支付
    const paymentResult = await this._paymentService.processPayment({
      userId,
      amount: order.getTotalAmount(),
      paymentMethod: paymentInfo.paymentMethod,
      paymentDetails: paymentInfo.details,
      orderId: order.id,
      description: `付款至 ${restaurant.name}`
    });
    
    if (!paymentResult.success) {
      throw new Error(`支付失败: ${paymentResult.message}`);
    }
    
    // 7. 保存订单
    const savedOrder = await this._orderRepository.save(order);
    
    // 8. 通知商家
    await this._notificationService.notifyMerchant(restaurantId, {
      type: 'NEW_ORDER',
      orderId: savedOrder.id,
      orderAmount: savedOrder.getTotalAmount(),
      itemCount: savedOrder.items.length,
      estimatedDeliveryTime: this._calculateEstimatedDeliveryTime(savedOrder, restaurant)
    });
    
    // 9. 给用户发送订单确认
    await this._notificationService.notifyUser(userId, {
      type: 'ORDER_CONFIRMED',
      orderId: savedOrder.id,
      restaurantName: restaurant.name,
      orderAmount: savedOrder.getTotalAmount(),
      estimatedDeliveryTime: this._calculateEstimatedDeliveryTime(savedOrder, restaurant)
    });
    
    // 10. 返回订单信息
    return {
      order: savedOrder.toJSON(),
      paymentStatus: paymentResult.status,
      estimatedDeliveryTime: this._calculateEstimatedDeliveryTime(savedOrder, restaurant)
    };
  }
  
  /**
   * 计算税费
   * @private
   */
  _calculateTax(subtotal, restaurant) {
    // 基于餐厅所在地区和系统设置计算税费
    return subtotal * (restaurant.taxRate || 0.06); // 默认6%
  }
  
  /**
   * 计算配送费
   * @private
   */
  _calculateDeliveryFee(deliveryInfo, restaurant) {
    // 根据配送距离、餐厅设置等计算配送费
    // 这里简化实现
    return restaurant.baseDeliveryFee || 5.00;
  }
  
  /**
   * 计算预估送达时间
   * @private
   */
  _calculateEstimatedDeliveryTime(order, restaurant) {
    // 基于订单内容、距离、餐厅繁忙程度等计算预计送达时间
    const now = new Date();
    // 默认45分钟后送达
    return new Date(now.getTime() + 45 * 60 * 1000);
  }
}

module.exports = PlaceOrderUseCase; 