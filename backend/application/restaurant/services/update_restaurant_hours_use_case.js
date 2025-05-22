/**
 * 更新餐厅营业时间用例
 * 协调餐厅领域和通知领域，处理餐厅营业时间更新及相关通知
 */
class UpdateRestaurantHoursUseCase {
  /**
   * @param {Object} dependencies - 依赖注入
   * @param {import('../../../domain/restaurant/repositories/restaurant_repository')} dependencies.restaurantRepository - 餐厅仓储
   * @param {import('../../../domain/user/repositories/user_repository')} dependencies.userRepository - 用户仓储
   * @param {import('../../../domain/notification/services/notification_service')} dependencies.notificationService - 通知服务
   * @param {import('../../../domain/order/repositories/order_repository')} dependencies.orderRepository - 订单仓储
   */
  constructor({
    restaurantRepository,
    userRepository,
    notificationService,
    orderRepository
  }) {
    this._restaurantRepository = restaurantRepository;
    this._userRepository = userRepository;
    this._notificationService = notificationService;
    this._orderRepository = orderRepository;
  }

  /**
   * 执行更新餐厅营业时间流程
   * @param {string} restaurantId - 餐厅ID
   * @param {string} merchantUserId - 商家用户ID
   * @param {Object} businessHours - 营业时间数据
   * @param {boolean} updateFutureOrderStatus - 是否更新未来订单状态
   * @returns {Promise<Object>} 更新结果
   */
  async execute(restaurantId, merchantUserId, businessHours, updateFutureOrderStatus = true) {
    // 1. 验证餐厅存在
    const restaurant = await this._restaurantRepository.findById(restaurantId);
    if (!restaurant) {
      throw new Error('餐厅不存在');
    }

    // 2. 验证用户权限
    const user = await this._userRepository.findById(merchantUserId);
    if (!user) {
      throw new Error('用户不存在');
    }

    // 验证用户是否为该餐厅的管理员
    if (!await this._hasRestaurantPermission(user, restaurantId)) {
      throw new Error('无权限更新此餐厅');
    }

    // 3. 检查营业时间变更是否影响当天营业
    const todayChanges = this._checkTodayChanges(restaurant.businessHours, businessHours);
    
    // 4. 更新餐厅营业时间
    const updatedRestaurant = restaurant.updateBusinessHours(businessHours);
    await this._restaurantRepository.save(updatedRestaurant);

    // 5. 处理受影响的订单（如果需要更新未来订单状态）
    let affectedOrders = [];
    if (updateFutureOrderStatus && todayChanges.hasChanges) {
      // 找出受影响的未来订单
      const pendingOrders = await this._orderRepository.findPendingByRestaurantId(restaurantId);
      
      // 过滤出受营业时间变更影响的订单
      affectedOrders = pendingOrders.filter(order => {
        const estimatedTime = new Date(order.estimatedDeliveryTime);
        return !this._isWithinBusinessHours(estimatedTime, businessHours);
      });
      
      // 处理受影响的订单
      if (affectedOrders.length > 0) {
        await this._handleAffectedOrders(affectedOrders, businessHours);
      }
    }

    // 6. 发送通知
    if (todayChanges.hasChanges) {
      // 通知餐厅员工
      await this._notificationService.notifyRestaurantStaff(restaurantId, {
        type: 'BUSINESS_HOURS_CHANGED',
        changes: todayChanges,
        updatedBy: user.name || merchantUserId
      });
      
      // 如果今日有闭店/开店变化，通知相关客户
      if (todayChanges.isClosing || todayChanges.isOpening) {
        await this._notifyAffectedCustomers(restaurantId, updatedRestaurant.name, todayChanges);
      }
    }

    // 7. 返回更新结果
    return {
      restaurant: updatedRestaurant.toJSON(),
      todayChanges,
      affectedOrders: affectedOrders.map(order => ({
        orderId: order.id,
        originalTime: order.estimatedDeliveryTime,
        status: order.status
      }))
    };
  }

  /**
   * 检查用户是否有餐厅管理权限
   * @private
   */
  async _hasRestaurantPermission(user, restaurantId) {
    // 管理员有所有权限
    if (user.role === 'ADMIN') {
      return true;
    }
    
    // 检查用户是否为餐厅管理员
    return user.role === 'MERCHANT' && user.managedRestaurants && 
      user.managedRestaurants.includes(restaurantId);
  }

  /**
   * 检查今日营业时间变更
   * @private
   */
  _checkTodayChanges(oldHours, newHours) {
    const today = new Date().toLocaleString('en-us', { weekday: 'long' }).toUpperCase();
    const oldToday = oldHours[today] || { isOpen: false, hours: [] };
    const newToday = newHours[today] || { isOpen: false, hours: [] };
    
    // 检查是否由开店变为闭店
    const isClosing = oldToday.isOpen && !newToday.isOpen;
    
    // 检查是否由闭店变为开店
    const isOpening = !oldToday.isOpen && newToday.isOpen;
    
    // 检查营业时段是否有变化
    const hoursChanged = JSON.stringify(oldToday.hours) !== JSON.stringify(newToday.hours);
    
    return {
      hasChanges: isClosing || isOpening || hoursChanged,
      isClosing,
      isOpening,
      hoursChanged,
      oldHours: oldToday,
      newHours: newToday
    };
  }

  /**
   * 检查时间是否在营业时间内
   * @private
   */
  _isWithinBusinessHours(date, businessHours) {
    const dayOfWeek = date.toLocaleString('en-us', { weekday: 'long' }).toUpperCase();
    const dayHours = businessHours[dayOfWeek];
    
    // 如果当天不营业，直接返回false
    if (!dayHours || !dayHours.isOpen) {
      return false;
    }
    
    // 检查是否在任一时段内
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const timeInMinutes = hours * 60 + minutes;
    
    return dayHours.hours.some(timeRange => {
      const [start, end] = timeRange.split('-');
      const [startHour, startMinute] = start.split(':').map(Number);
      const [endHour, endMinute] = end.split(':').map(Number);
      
      const startInMinutes = startHour * 60 + startMinute;
      const endInMinutes = endHour * 60 + endMinute;
      
      return timeInMinutes >= startInMinutes && timeInMinutes <= endInMinutes;
    });
  }

  /**
   * 处理受影响的订单
   * @private
   */
  async _handleAffectedOrders(affectedOrders, newBusinessHours) {
    const OrderStatus = require('../../../domain/order/value_objects/order_status');
    
    for (const order of affectedOrders) {
      // 获取订单预计配送时间
      const estimatedTime = new Date(order.estimatedDeliveryTime);
      const dayOfWeek = estimatedTime.toLocaleString('en-us', { weekday: 'long' }).toUpperCase();
      
      // 如果当天不营业，取消订单
      if (!newBusinessHours[dayOfWeek] || !newBusinessHours[dayOfWeek].isOpen) {
        // 检查是否能转换到取消状态
        if (order.status.canTransitionTo(OrderStatus.CANCELLED)) {
          const cancelledOrder = order.updateStatus(OrderStatus.CANCELLED);
          await this._orderRepository.save(cancelledOrder);
          
          // 通知用户订单被取消
          await this._notificationService.notifyUser(order.userId, {
            type: 'ORDER_CANCELLED',
            orderId: order.id,
            reason: '餐厅营业时间变更，无法在预定时间提供服务'
          });
        }
      }
      // 否则尝试调整到最接近的营业时间
      else {
        // 实际实现可能需要更复杂的调度算法
        // 这里仅作为示例，简单实现
      }
    }
  }

  /**
   * 通知受影响的客户
   * @private
   */
  async _notifyAffectedCustomers(restaurantId, restaurantName, changes) {
    // 获取最近在该餐厅有订单的客户
    const recentCustomers = await this._orderRepository.findRecentCustomersByRestaurantId(restaurantId, 30);
    
    if (changes.isClosing) {
      // 通知最近的客户餐厅暂停营业
      for (const customerId of recentCustomers) {
        await this._notificationService.notifyUser(customerId, {
          type: 'RESTAURANT_CLOSED',
          restaurantId,
          restaurantName,
          message: `${restaurantName} 已暂停营业，给您带来不便敬请谅解。`
        });
      }
    } else if (changes.isOpening) {
      // 通知最近的客户餐厅恢复营业
      for (const customerId of recentCustomers) {
        await this._notificationService.notifyUser(customerId, {
          type: 'RESTAURANT_REOPENED',
          restaurantId,
          restaurantName,
          message: `${restaurantName} 已恢复营业，欢迎再次光临！`
        });
      }
    }
  }
}

module.exports = UpdateRestaurantHoursUseCase; 