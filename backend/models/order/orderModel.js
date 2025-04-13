const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

const orderItemSchema = new mongoose.Schema({
  dish_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true
  },
  name: {
    type: String,
    required: true
  },
  price: {
    type: Number,
    required: true,
    min: 0
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
    default: 1
  },
  customizations: [{
    option_name: String,
    option_value: String,
    additional_price: {
      type: Number,
      default: 0
    }
  }],
  special_instructions: String,
  item_total: {
    type: Number,
    required: true
  }
});

const orderSchema = new mongoose.Schema({
  order_number: {
    type: String,
    required: true,
    unique: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  merchant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true
  },
  merchant_type: {
    type: String,
    enum: ['restaurant', 'gym', 'maternity_center', 'school_company'],
    required: true
  },
  items: [orderItemSchema],
  // 使用的营养档案（可选）
  nutritionProfileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  // 相关的AI推荐
  ai_recommendation_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation'
  },
  // 订单状态
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded'],
    default: 'pending'
  },
  // 订单类型
  order_type: {
    type: String,
    enum: ['dine_in', 'takeout', 'delivery', 'catering', 'subscription'],
    default: 'dine_in'
  },
  // 支付信息
  payment: {
    method: {
      type: String,
      enum: ['cash', 'credit_card', 'debit_card', 'mobile_payment', 'subscription', 'other'],
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'partially_refunded', 'refunded', 'failed'],
      default: 'pending'
    },
    transaction_id: String,
    payment_time: Date,
    refund_id: String,
    refund_time: Date
  },
  // 价格明细
  price_details: {
    subtotal: {
      type: Number,
      required: true
    },
    tax: {
      type: Number,
      default: 0
    },
    delivery_fee: {
      type: Number,
      default: 0
    },
    service_fee: {
      type: Number,
      default: 0
    },
    tip: {
      type: Number,
      default: 0
    },
    discount: {
      type: Number,
      default: 0
    },
    discount_code: String,
    total: {
      type: Number,
      required: true
    }
  },
  // 配送信息（如适用）
  delivery: {
    address: {
      line1: String,
      line2: String,
      city: String,
      state: String,
      postal_code: String,
      country: {
        type: String,
        default: 'China'
      },
      coordinates: {
        latitude: Number,
        longitude: Number
      }
    },
    contact_name: String,
    contact_phone: String,
    delivery_instructions: String,
    estimated_delivery_time: Date,
    actual_delivery_time: Date,
    delivery_person: {
      id: String,
      name: String,
      phone: String
    }
  },
  // 堂食信息
  dine_in: {
    table_number: String,
    number_of_people: Number,
    estimated_completion_time: Date
  },
  // 订单营养摘要（汇总所有菜品）
  nutrition_summary: {
    calories: Number,
    protein: Number,
    fat: Number,
    carbohydrates: Number,
    suitable_for_health_conditions: [String],
    allergens: [String]
  },
  // 订单与营养目标吻合度评分（由AI计算）
  nutrition_goal_alignment: {
    score: {
      type: Number,
      min: 0,
      max: 100
    },
    analysis: String
  },
  // 访问控制与隐私
  privacy_level: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private'
  },
  // 订单访问授权
  access_grants: [{
    granted_to: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_grants.granted_to_type'
    },
    granted_to_type: {
      type: String,
      enum: ['Nutritionist', 'Merchant', 'Admin']
    },
    granted_at: {
      type: Date,
      default: Date.now
    },
    valid_until: Date,
    access_level: {
      type: String,
      enum: ['read', 'read_write'],
      default: 'read'
    },
    revoked: {
      type: Boolean,
      default: false
    },
    revoked_at: Date
  }],
  // 评价
  rating: {
    overall: {
      type: Number,
      min: 1,
      max: 5
    },
    food_quality: {
      type: Number,
      min: 1,
      max: 5
    },
    service: {
      type: Number,
      min: 1,
      max: 5
    },
    delivery_experience: {
      type: Number,
      min: 1,
      max: 5
    },
    nutrition_quality: {
      type: Number,
      min: 1,
      max: 5
    },
    review_text: String,
    review_date: Date,
    merchant_response: String,
    merchant_response_date: Date
  },
  // 数据审计
  status_history: [{
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded']
    },
    timestamp: {
      type: Date,
      default: Date.now
    },
    updated_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'status_history.updated_by_type'
    },
    updated_by_type: {
      type: String,
      enum: ['User', 'Merchant', 'Admin', 'System']
    },
    notes: String
  }],
  // 安全和审计
  access_log: [{
    timestamp: {
      type: Date,
      default: Date.now
    },
    accessed_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'access_log.accessed_by_type'
    },
    accessed_by_type: {
      type: String,
      enum: ['User', 'Merchant', 'Nutritionist', 'Admin', 'System']
    },
    ip_address: String,
    action: {
      type: String,
      enum: ['view', 'update', 'pay', 'cancel', 'refund', 'rate']
    }
  }],
  // 时间戳
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
orderSchema.index({ order_number: 1 }, { unique: true });
orderSchema.index({ userId: 1 });
orderSchema.index({ merchant_id: 1 });
orderSchema.index({ status: 1 });
orderSchema.index({ createdAt: -1 });
orderSchema.index({ 'payment.status': 1 });
orderSchema.index({ order_type: 1 });
orderSchema.index({ 'payment.transaction_id': 1 });
orderSchema.index({ 'delivery.estimated_delivery_time': 1 });
orderSchema.index({ 'nutritionProfileId': 1 });
orderSchema.index({ 'ai_recommendation_id': 1 });

// 添加虚拟字段
orderSchema.virtual('is_paid').get(function() {
  return this.payment && this.payment.status === 'paid';
});

orderSchema.virtual('is_completed').get(function() {
  return ['completed', 'delivered'].includes(this.status);
});

orderSchema.virtual('is_cancelled').get(function() {
  return ['cancelled', 'refunded'].includes(this.status);
});

orderSchema.virtual('order_progress_percent').get(function() {
  const statusOrder = ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed'];
  const currentIndex = statusOrder.indexOf(this.status);
  
  if (currentIndex === -1 || this.is_cancelled) return 0;
  return Math.round((currentIndex / (statusOrder.length - 1)) * 100);
});

orderSchema.virtual('delivery_time_remaining').get(function() {
  if (!this.delivery || !this.delivery.estimated_delivery_time) return null;
  
  const now = new Date();
  const estimatedTime = new Date(this.delivery.estimated_delivery_time);
  
  if (now > estimatedTime) return 0;
  
  // 返回剩余分钟数
  return Math.round((estimatedTime - now) / 60000);
});

// 关联
orderSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

orderSchema.virtual('merchant', {
  ref: 'Merchant',
  localField: 'merchant_id',
  foreignField: '_id',
  justOne: true
});

orderSchema.virtual('nutritionProfile', {
  ref: 'NutritionProfile',
  localField: 'nutritionProfileId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
orderSchema.methods.calculateTotals = function() {
  // 计算小计
  const subtotal = this.items.reduce((sum, item) => sum + item.item_total, 0);
  
  // 计算税费 (假设税率为10%)
  const tax = Math.round(subtotal * 0.1 * 100) / 100;
  
  // 获取配送费和服务费
  const deliveryFee = this.price_details.delivery_fee || 0;
  const serviceFee = this.price_details.service_fee || 0;
  const tip = this.price_details.tip || 0;
  const discount = this.price_details.discount || 0;
  
  // 计算总计
  const total = subtotal + tax + deliveryFee + serviceFee + tip - discount;
  
  // 更新价格明细
  this.price_details = {
    ...this.price_details,
    subtotal,
    tax,
    total
  };
  
  return this.price_details;
};

orderSchema.methods.addItem = function(item) {
  // 检查是否已存在相同菜品
  const existingItemIndex = this.items.findIndex(
    i => i.dish_id.toString() === item.dish_id.toString() && 
         JSON.stringify(i.customizations) === JSON.stringify(item.customizations)
  );
  
  if (existingItemIndex !== -1) {
    // 更新现有项目的数量和总金额
    this.items[existingItemIndex].quantity += item.quantity || 1;
    this.items[existingItemIndex].item_total = 
      this.items[existingItemIndex].price * this.items[existingItemIndex].quantity;
  } else {
    // 添加新项目，确保计算item_total
    const newItem = {
      ...item,
      quantity: item.quantity || 1,
      item_total: item.price * (item.quantity || 1)
    };
    this.items.push(newItem);
  }
  
  // 重新计算订单总额
  this.calculateTotals();
  
  return this;
};

orderSchema.methods.removeItem = function(itemId) {
  const initialLength = this.items.length;
  this.items = this.items.filter(item => item._id.toString() !== itemId.toString());
  
  // 如果移除了项目，重新计算总金额
  if (initialLength !== this.items.length) {
    this.calculateTotals();
  }
  
  return this;
};

orderSchema.methods.updateStatus = function(newStatus, reason) {
  // 验证状态转换是否有效
  const validTransitions = {
    'pending': ['confirmed', 'cancelled'],
    'confirmed': ['preparing', 'cancelled'],
    'preparing': ['ready', 'cancelled'],
    'ready': ['in_delivery', 'completed', 'cancelled'],
    'in_delivery': ['delivered', 'cancelled'],
    'delivered': ['completed', 'refunded'],
    'completed': ['refunded'],
    'cancelled': [],
    'refunded': []
  };
  
  if (!validTransitions[this.status].includes(newStatus)) {
    throw new Error(`无效的状态转换: ${this.status} -> ${newStatus}`);
  }
  
  // 更新状态
  this.status = newStatus;
  
  // 记录状态历史
  this.status_history = this.status_history || [];
  this.status_history.push({
    status: newStatus,
    timestamp: new Date(),
    reason: reason
  });
  
  // 根据状态更新其他字段
  if (newStatus === 'confirmed') {
    // 设置订单确认时间
    this.confirmed_at = new Date();
  } else if (newStatus === 'in_delivery') {
    // 设置开始配送时间
    this.delivery = this.delivery || {};
    this.delivery.start_delivery_time = new Date();
  } else if (newStatus === 'delivered') {
    // 设置实际配送时间
    this.delivery = this.delivery || {};
    this.delivery.actual_delivery_time = new Date();
  } else if (newStatus === 'completed') {
    // 设置完成时间
    this.completed_at = new Date();
  }
  
  return this;
};

// 静态方法
orderSchema.statics.findByOrderNumber = function(orderNumber) {
  return this.findOne({ order_number: orderNumber });
};

orderSchema.statics.findByUserAndStatus = function(userId, status) {
  return this.find({ userId: userId, status });
};

orderSchema.statics.findPendingDeliveries = function() {
  return this.find({ 
    status: 'in_delivery',
    order_type: 'delivery'
  }).sort({ 'delivery.estimated_delivery_time': 1 });
};

orderSchema.statics.getUserOrderStats = async function(userId) {
  return this.aggregate([
    { $match: { userId: mongoose.Types.ObjectId(userId) } },
    { $group: {
      _id: "$userId",
      total_orders: { $sum: 1 },
      total_spent: { $sum: "$price_details.total" },
      average_order_value: { $avg: "$price_details.total" },
      completed_orders: { 
        $sum: { 
          $cond: [{ $eq: ["$status", "completed"] }, 1, 0] 
        }
      }
    }}
  ]);
};

// 前置钩子 - 生成订单编号
orderSchema.pre('save', async function(next) {
  if (!this.order_number) {
    const date = new Date();
    const prefix = date.getFullYear().toString().substr(-2) + 
                  (date.getMonth() + 1).toString().padStart(2, '0') + 
                  date.getDate().toString().padStart(2, '0');
    
    // 获取当天的订单数量
    const todayStart = new Date();
    todayStart.setHours(0, 0, 0, 0);
    
    const todayEnd = new Date();
    todayEnd.setHours(23, 59, 59, 999);
    
    const orderCount = await this.constructor.countDocuments({
      createdAt: { $gte: todayStart, $lte: todayEnd }
    });
    
    // 生成序列号：日期(6位) + 当天订单序号(4位) + 随机数(2位)
    const sequence = (orderCount + 1).toString().padStart(4, '0');
    const random = Math.floor(Math.random() * 100).toString().padStart(2, '0');
    
    this.order_number = `${prefix}${sequence}${random}`;
  }
  
  // 确保计算总金额
  if (this.isNew || this.isModified('items') || this.isModified('price_details')) {
    this.calculateTotals();
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Order = ModelFactory.createModel('Order', orderSchema);

module.exports = Order; 