const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { merchantTypeValues } = require('../merchant/merchantTypeEnum');

const orderItemSchema = new mongoose.Schema({
  dishId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Dish',
    required: true,
    description: '菜品ID'
  },
  name: {
    type: String,
    required: true,
    description: '菜品名称'
  },
  price: {
    type: Number,
    required: true,
    min: 0,
    description: '菜品单价'
  },
  quantity: {
    type: Number,
    required: true,
    min: 1,
    default: 1,
    description: '菜品数量'
  },
  customizations: [{
    optionName: {
      type: String,
      description: '选项名称'
    },
    optionValue: {
      type: String,
      description: '选项值'
    },
    additionalPrice: {
      type: Number,
      default: 0,
      description: '额外费用'
    }
  }],
  specialInstructions: {
    type: String,
    description: '特殊要求'
  },
  itemTotal: {
    type: Number,
    required: true,
    description: '菜品总价'
  }
});

const orderSchema = new mongoose.Schema({
  orderNumber: {
    type: String,
    required: true,
    unique: true,
    description: '订单编号'
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '下单用户ID'
  },
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    description: '商家ID'
  },
  merchantType: {
    type: String,
    enum: merchantTypeValues,
    required: true,
    description: '商家类型（驼峰命名）'
  },
  items: [orderItemSchema],
  // 使用的营养档案（可选）
  nutritionProfileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    description: '使用的营养档案ID'
  },
  // 相关的AI推荐
  aiRecommendationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation',
    description: '相关的AI推荐ID'
  },
  // 订单状态
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded'],
    default: 'pending',
    description: '订单状态'
  },
  // 订单类型
  orderType: {
    type: String,
    enum: ['dine_in', 'takeout', 'delivery', 'catering', 'subscription'],
    default: 'dine_in',
    description: '订单类型'
  },
  // 订单来源
  source: {
    type: String,
    enum: ['user', 'admin', 'subscription', 'system'],
    default: 'user',
    description: '订单创建来源'
  },
  // 支付信息
  payment: {
    method: {
      type: String,
      enum: ['cash', 'credit_card', 'debit_card', 'mobile_payment', 'subscription', 'other'],
      required: true,
      description: '支付方式'
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'partially_refunded', 'refunded', 'failed'],
      default: 'pending',
      description: '支付状态'
    },
    transactionId: {
      type: String,
      description: '交易ID'
    },
    paymentTime: {
      type: Date,
      description: '支付时间'
    },
    refundId: {
      type: String,
      description: '退款ID'
    },
    refundTime: {
      type: Date,
      description: '退款时间'
    }
  },
  // 价格明细
  priceDetails: {
    subtotal: {
      type: Number,
      required: true,
      description: '小计金额'
    },
    tax: {
      type: Number,
      default: 0,
      description: '税费'
    },
    deliveryFee: {
      type: Number,
      default: 0,
      description: '配送费'
    },
    serviceFee: {
      type: Number,
      default: 0,
      description: '服务费'
    },
    tip: {
      type: Number,
      default: 0,
      description: '小费'
    },
    discount: {
      type: Number,
      default: 0,
      description: '折扣金额'
    },
    discountCode: {
      type: String,
      description: '折扣码'
    },
    total: {
      type: Number,
      required: true,
      description: '总金额'
    }
  },
  // 配送信息（如适用）
  delivery: {
    address: {
      line1: {
        type: String,
        description: '地址行1'
      },
      line2: {
        type: String,
        description: '地址行2'
      },
      city: {
        type: String,
        description: '城市'
      },
      state: {
        type: String,
        description: '省/州'
      },
      postalCode: {
        type: String,
        description: '邮编'
      },
      country: {
        type: String,
        default: 'China',
        description: '国家'
      },
      coordinates: {
        latitude: {
          type: Number,
          description: '纬度'
        },
        longitude: {
          type: Number,
          description: '经度'
        }
      }
    },
    contactName: {
      type: String,
      description: '联系人姓名'
    },
    contactPhone: {
      type: String,
      description: '联系人电话'
    },
    deliveryInstructions: {
      type: String,
      description: '配送说明'
    },
    estimatedDeliveryTime: {
      type: Date,
      description: '预计配送时间'
    },
    actualDeliveryTime: {
      type: Date,
      description: '实际配送时间'
    },
    deliveryPerson: {
      id: {
        type: String,
        description: '配送员ID'
      },
      name: {
        type: String,
        description: '配送员姓名'
      },
      phone: {
        type: String,
        description: '配送员电话'
      }
    }
  },
  // 堂食信息
  dineIn: {
    tableNumber: {
      type: String,
      description: '桌号'
    },
    numberOfPeople: {
      type: Number,
      description: '人数'
    },
    estimatedCompletionTime: {
      type: Date,
      description: '预计完成时间'
    }
  },
  // 订单营养摘要（汇总所有菜品）
  nutritionSummary: {
    calories: {
      type: Number,
      description: '总卡路里'
    },
    protein: {
      type: Number,
      description: '总蛋白质(g)'
    },
    fat: {
      type: Number,
      description: '总脂肪(g)'
    },
    carbohydrates: {
      type: Number,
      description: '总碳水化合物(g)'
    },
    suitableForHealthConditions: {
      type: [String],
      description: '适合的健康状况'
    },
    allergens: {
      type: [String],
      description: '过敏原'
    }
  },
  // 订单与营养目标吻合度评分（由AI计算）
  nutritionGoalAlignment: {
    score: {
      type: Number,
      min: 0,
      max: 100,
      description: '营养目标吻合度评分(0-100)'
    },
    analysis: {
      type: String,
      description: '营养分析'
    }
  },
  // 访问控制与隐私
  privacyLevel: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private',
    description: '隐私级别'
  },
  // 订单访问授权
  accessGrants: [{
    grantedTo: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessGrants.grantedToType',
      description: '被授权者ID'
    },
    grantedToType: {
      type: String,
      enum: ['Nutritionist', 'Merchant', 'Admin'],
      description: '被授权者类型'
    },
    grantedAt: {
      type: Date,
      default: Date.now,
      description: '授权时间'
    },
    validUntil: {
      type: Date,
      description: '有效期至'
    },
    accessLevel: {
      type: String,
      enum: ['read', 'read_write'],
      default: 'read',
      description: '访问级别'
    },
    revoked: {
      type: Boolean,
      default: false,
      description: '是否已撤销'
    },
    revokedAt: {
      type: Date,
      description: '撤销时间'
    }
  }],
  // 评价
  rating: {
    overall: {
      type: Number,
      min: 1,
      max: 5,
      description: '总体评分(1-5)'
    },
    foodQuality: {
      type: Number,
      min: 1,
      max: 5,
      description: '食物质量评分(1-5)'
    },
    service: {
      type: Number,
      min: 1,
      max: 5,
      description: '服务评分(1-5)'
    },
    deliveryExperience: {
      type: Number,
      min: 1,
      max: 5,
      description: '配送体验评分(1-5)'
    },
    nutritionQuality: {
      type: Number,
      min: 1,
      max: 5,
      description: '营养质量评分(1-5)'
    },
    reviewText: {
      type: String,
      description: '评价内容'
    },
    reviewDate: {
      type: Date,
      description: '评价日期'
    },
    merchantResponse: {
      type: String,
      description: '商家回复'
    },
    merchantResponseDate: {
      type: Date,
      description: '商家回复日期'
    }
  },
  // 数据审计
  statusHistory: [{
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed', 'cancelled', 'refunded'],
      description: '状态'
    },
    timestamp: {
      type: Date,
      default: Date.now,
      description: '时间戳'
    },
    updatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'statusHistory.updatedByType',
      description: '更新者ID'
    },
    updatedByType: {
      type: String,
      enum: ['User', 'Merchant', 'Admin', 'System'],
      description: '更新者类型'
    },
    notes: {
      type: String,
      description: '备注'
    }
  }],
  // 安全和审计
  accessLog: [{
    timestamp: {
      type: Date,
      default: Date.now,
      description: '时间戳'
    },
    accessedBy: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessLog.accessedByType',
      description: '访问者ID'
    },
    accessedByType: {
      type: String,
      enum: ['User', 'Merchant', 'Nutritionist', 'Admin', 'System'],
      description: '访问者类型'
    },
    ipAddress: {
      type: String,
      description: 'IP地址'
    },
    action: {
      type: String,
      enum: ['view', 'update', 'pay', 'cancel', 'refund', 'rate'],
      description: '操作类型'
    }
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 添加索引以优化查询性能
orderSchema.index({ orderNumber: 1 }, { unique: true });
orderSchema.index({ userId: 1 });
orderSchema.index({ merchantId: 1 });
orderSchema.index({ status: 1 });
orderSchema.index({ createdAt: -1 });
orderSchema.index({ 'payment.status': 1 });
orderSchema.index({ orderType: 1 });
orderSchema.index({ 'payment.transactionId': 1 });
orderSchema.index({ 'delivery.estimatedDeliveryTime': 1 });
orderSchema.index({ 'nutritionProfileId': 1 });
orderSchema.index({ 'aiRecommendationId': 1 });

// 添加虚拟字段
orderSchema.virtual('isPaid').get(function() {
  return this.payment && this.payment.status === 'paid';
});

orderSchema.virtual('isCompleted').get(function() {
  return ['completed', 'delivered'].includes(this.status);
});

orderSchema.virtual('isCancelled').get(function() {
  return ['cancelled', 'refunded'].includes(this.status);
});

orderSchema.virtual('orderProgressPercent').get(function() {
  const statusOrder = ['pending', 'confirmed', 'preparing', 'ready', 'in_delivery', 'delivered', 'completed'];
  const currentIndex = statusOrder.indexOf(this.status);
  
  if (currentIndex === -1 || this.isCancelled) return 0;
  return Math.round((currentIndex / (statusOrder.length - 1)) * 100);
});

orderSchema.virtual('deliveryTimeRemaining').get(function() {
  if (!this.delivery || !this.delivery.estimatedDeliveryTime) return null;
  
  const now = new Date();
  const estimatedTime = new Date(this.delivery.estimatedDeliveryTime);
  
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
  localField: 'merchantId',
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
  const subtotal = this.items.reduce((sum, item) => sum + item.itemTotal, 0);
  
  // 计算税费 (假设税率为10%)
  const tax = Math.round(subtotal * 0.1 * 100) / 100;
  
  // 获取配送费和服务费
  const deliveryFee = this.priceDetails.deliveryFee || 0;
  const serviceFee = this.priceDetails.serviceFee || 0;
  const tip = this.priceDetails.tip || 0;
  const discount = this.priceDetails.discount || 0;
  
  // 计算总计
  const total = subtotal + tax + deliveryFee + serviceFee + tip - discount;
  
  // 更新价格明细
  this.priceDetails = {
    ...this.priceDetails,
    subtotal,
    tax,
    total
  };
  
  return this.priceDetails;
};

orderSchema.methods.addItem = function(item) {
  // 检查是否已存在相同菜品
  const existingItemIndex = this.items.findIndex(
    i => i.dishId.toString() === item.dishId.toString() && 
         JSON.stringify(i.customizations) === JSON.stringify(item.customizations)
  );
  
  if (existingItemIndex !== -1) {
    // 更新现有项目的数量和总金额
    this.items[existingItemIndex].quantity += item.quantity || 1;
    this.items[existingItemIndex].itemTotal = 
      this.items[existingItemIndex].price * this.items[existingItemIndex].quantity;
  } else {
    // 添加新项目，确保计算itemTotal
    const newItem = {
      ...item,
      quantity: item.quantity || 1,
      itemTotal: item.price * (item.quantity || 1)
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
  this.statusHistory = this.statusHistory || [];
  this.statusHistory.push({
    status: newStatus,
    timestamp: new Date(),
    notes: reason // 显式赋值
  });
  
  // 根据状态更新其他字段
  if (newStatus === 'confirmed') {
    // 设置订单确认时间
    this.confirmedAt = new Date();
  } else if (newStatus === 'in_delivery') {
    // 设置开始配送时间
    this.delivery = this.delivery || {};
    this.delivery.startDeliveryTime = new Date();
  } else if (newStatus === 'delivered') {
    // 设置实际配送时间
    this.delivery = this.delivery || {};
    this.delivery.actualDeliveryTime = new Date();
  } else if (newStatus === 'completed') {
    // 设置完成时间
    this.completedAt = new Date();
  }
  
  return this;
};

// 静态方法
orderSchema.statics.findByOrderNumber = function(orderNumber) {
  return this.findOne({ orderNumber: orderNumber });
};

orderSchema.statics.findByUserAndStatus = function(userId, status) {
  return this.find({ userId: userId, status });
};

orderSchema.statics.findPendingDeliveries = function() {
  return this.find({ 
    status: 'in_delivery',
    orderType: 'delivery'
  }).sort({ 'delivery.estimatedDeliveryTime': 1 });
};

orderSchema.statics.getUserOrderStats = async function(userId) {
  return this.aggregate([
    { $match: { userId: mongoose.Types.ObjectId(userId) } },
    { $group: {
      _id: "$userId",
      total_orders: { $sum: 1 },
      total_spent: { $sum: "$priceDetails.total" },
      average_order_value: { $avg: "$priceDetails.total" },
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
  if (!this.orderNumber) {
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
    
    this.orderNumber = `${prefix}${sequence}${random}`;
  }
  
  // 确保计算总金额
  if (this.isNew || this.isModified('items') || this.isModified('priceDetails')) {
    this.calculateTotals();
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Order = ModelFactory.createModel('Order', orderSchema);

module.exports = Order;