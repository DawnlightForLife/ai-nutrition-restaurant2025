/**
 * 餐厅设置领域实体
 * @module domain/restaurant/setting
 */

class RestaurantSetting {
  constructor({
    id,
    restaurantId,
    branchId,
    orderSettings,
    paymentSettings,
    deliverySettings,
    tableSettings,
    notificationSettings,
    operationalSettings,
    nutritionSettings,
    promotionSettings,
    createdAt,
    updatedAt
  }) {
    // 基本信息
    this.id = id;
    this.restaurantId = restaurantId;
    this.branchId = branchId; // 可选，如果为空则为餐厅级设置
    
    // 订单设置
    this.orderSettings = orderSettings || {
      enableOnlineOrder: true,
      enableTableOrder: true,
      orderPrefix: 'ORD',
      autoConfirmMinutes: 5, // 自动确认时间
      autoCancelMinutes: 30, // 自动取消时间
      minOrderAmount: 0,
      maxOrderAmount: 10000,
      requirePhone: true,
      requireAddress: false,
      allowPreorder: true,
      preorderDays: 7, // 提前预订天数
      orderTimeSlots: [], // 可选时间段
      blackoutDates: [] // 不可订餐日期
    };
    
    // 支付设置
    this.paymentSettings = paymentSettings || {
      enableOnlinePayment: true,
      enableCashPayment: true,
      paymentMethods: ['alipay', 'wechat_pay'],
      paymentTimeout: 15, // 支付超时（分钟）
      depositRequired: false,
      depositPercentage: 0,
      taxRate: 0,
      serviceChargeRate: 0,
      roundingMethod: 'none' // 'none' | 'up' | 'down' | 'nearest'
    };
    
    // 配送设置
    this.deliverySettings = deliverySettings || {
      enableDelivery: false,
      deliveryRadius: 5, // 公里
      deliveryFee: 0,
      freeDeliveryAmount: 0,
      deliveryTimeSlots: [],
      estimatedDeliveryTime: 30, // 分钟
      deliveryPartners: [] // 第三方配送
    };
    
    // 桌位设置
    this.tableSettings = tableSettings || {
      enableTableReservation: true,
      reservationDeposit: 0,
      reservationDuration: 120, // 分钟
      tableOccupancyTimeout: 150, // 分钟
      enableQROrdering: true,
      serviceCallEnabled: true,
      tableTurnoverTime: 90 // 平均翻台时间（分钟）
    };
    
    // 通知设置
    this.notificationSettings = notificationSettings || {
      orderNotifications: {
        sms: true,
        push: true,
        email: false
      },
      marketingNotifications: {
        sms: false,
        push: true,
        email: true
      },
      staffNotifications: {
        newOrder: true,
        orderUpdate: true,
        lowInventory: true
      }
    };
    
    // 运营设置
    this.operationalSettings = operationalSettings || {
      autoAcceptOrders: false,
      orderCapacity: 100, // 每天最大订单数
      kitchenCapacity: 50, // 同时处理订单数
      preparationTime: {
        breakfast: 15,
        lunch: 20,
        dinner: 25
      },
      peakHourSurcharge: {
        enabled: false,
        percentage: 10,
        timeSlots: []
      },
      inventoryTracking: true,
      lowStockAlert: 10
    };
    
    // 营养设置
    this.nutritionSettings = nutritionSettings || {
      displayNutrition: true,
      displayCalories: true,
      displayAllergens: true,
      healthyChoiceLabel: true,
      customLabels: [], // 自定义标签
      nutritionCalculation: 'auto', // 'auto' | 'manual'
      allowCustomization: true // 允许菜品定制
    };
    
    // 促销设置
    this.promotionSettings = promotionSettings || {
      enablePromotions: true,
      enableCoupons: true,
      enableLoyaltyProgram: true,
      pointsPerYuan: 1, // 每元获得积分
      pointsToYuanRatio: 100, // 积分兑换比例
      memberDiscount: 0, // 会员折扣
      birthdayDiscount: 10, // 生日折扣
      referralBonus: 20 // 推荐奖励
    };
    
    // 时间戳
    this.createdAt = createdAt || new Date();
    this.updatedAt = updatedAt || new Date();
  }
  
  // 获取设置值
  getSetting(category, key) {
    if (this[category] && this[category][key] !== undefined) {
      return this[category][key];
    }
    return null;
  }
  
  // 更新设置
  updateSetting(category, key, value) {
    if (!this[category]) {
      throw new Error(`Invalid setting category: ${category}`);
    }
    
    if (typeof this[category] === 'object') {
      this[category][key] = value;
    } else {
      this[category] = value;
    }
    
    this.updatedAt = new Date();
  }
  
  // 批量更新设置
  updateSettings(updates) {
    Object.keys(updates).forEach(category => {
      if (this[category] !== undefined) {
        if (typeof this[category] === 'object' && typeof updates[category] === 'object') {
          this[category] = { ...this[category], ...updates[category] };
        } else {
          this[category] = updates[category];
        }
      }
    });
    
    this.updatedAt = new Date();
  }
  
  // 验证设置合法性
  validate() {
    // 验证订单设置
    if (this.orderSettings.minOrderAmount < 0) {
      throw new Error('Minimum order amount cannot be negative');
    }
    if (this.orderSettings.maxOrderAmount <= this.orderSettings.minOrderAmount) {
      throw new Error('Maximum order amount must be greater than minimum');
    }
    
    // 验证支付设置
    if (this.paymentSettings.depositPercentage < 0 || this.paymentSettings.depositPercentage > 100) {
      throw new Error('Deposit percentage must be between 0 and 100');
    }
    
    // 验证配送设置
    if (this.deliverySettings.deliveryRadius < 0) {
      throw new Error('Delivery radius cannot be negative');
    }
    
    return true;
  }
  
  // 合并设置（用于分店继承餐厅设置）
  static mergeSettings(restaurantSettings, branchSettings) {
    const merged = JSON.parse(JSON.stringify(restaurantSettings));
    
    if (branchSettings) {
      Object.keys(branchSettings).forEach(key => {
        if (key !== 'id' && key !== 'restaurantId' && key !== 'branchId' && 
            key !== 'createdAt' && key !== 'updatedAt') {
          merged[key] = branchSettings[key];
        }
      });
    }
    
    return merged;
  }
  
  // 转换为普通对象
  toObject() {
    return {
      id: this.id,
      restaurantId: this.restaurantId,
      branchId: this.branchId,
      orderSettings: this.orderSettings,
      paymentSettings: this.paymentSettings,
      deliverySettings: this.deliverySettings,
      tableSettings: this.tableSettings,
      notificationSettings: this.notificationSettings,
      operationalSettings: this.operationalSettings,
      nutritionSettings: this.nutritionSettings,
      promotionSettings: this.promotionSettings,
      createdAt: this.createdAt,
      updatedAt: this.updatedAt
    };
  }
}

module.exports = RestaurantSetting;