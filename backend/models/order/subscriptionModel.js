const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 订阅项目子模式（如餐品、营养指导等）
const subscriptionItemSchema = new mongoose.Schema({
  itemType: {
    type: String,
    enum: ['meal', 'dish', 'consultation', 'nutritionPlan'],
    required: true,
    description: '订阅项目类型'
  },
  itemId: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'items.itemTypeRef',
    description: '订阅项目ID',
    sensitivityLevel: 2
  },
  itemTypeRef: {
    type: String,
    enum: ['Dish', 'AiRecommendation', 'Nutritionist'],
    required: true,
    description: '订阅项目引用类型'
  },
  itemName: {
    type: String,
    required: true,
    description: '订阅项目名称'
  },
  quantity: {
    type: Number,
    min: 1,
    default: 1,
    description: '数量'
  },
  frequency: {
    type: String,
    enum: ['daily', 'weekdays', 'weekends', 'weekly', 'monthly', 'custom'],
    default: 'daily',
    description: '配送频率'
  },
  // 自定义重复模式 - 自定义配送时间表
  customSchedule: {
    days: [{ 
      type: Number, 
      min: 0, 
      max: 6,
      description: '周几（0-6表示周日至周六）'
    }],
    weeks: [{ 
      type: Number, 
      min: 1, 
      max: 5,
      description: '第几周（1-5表示一个月的第几周）'
    }],
    months: [{ 
      type: Number, 
      min: 1, 
      max: 12,
      description: '第几月（1-12表示一年的第几个月）'
    }]
  },
  nutritionProfileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    description: '关联的营养档案ID',
    sensitivityLevel: 2
  },
  pricePerUnit: {
    type: Number,
    required: true,
    min: 0,
    description: '单价'
  },
  subtotal: {
    type: Number,
    required: true,
    min: 0,
    description: '小计金额'
  }
});

// 定义主订阅模式
const subscriptionSchema = new mongoose.Schema({
  // 基本信息
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '订阅用户ID',
    sensitivityLevel: 2
  },
  merchantId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    description: '商家ID',
    sensitivityLevel: 2
  },
  subscriptionNumber: {
    type: String,
    required: true,
    unique: true,
    description: '订阅编号'
  },
  // 订阅类型
  subscriptionType: {
    type: String,
    enum: ['mealPlan', 'nutritionistService', 'gymMeal', 'maternityMeal', 'schoolCompanyMeal'],
    required: true,
    description: '订阅类型'
  },
  // 订阅名称
  name: {
    type: String,
    required: true,
    description: '订阅名称'
  },
  description: {
    type: String,
    description: '订阅描述'
  },
  // 订阅项目
  items: [subscriptionItemSchema],
  // 订阅时间段
  startDate: {
    type: Date,
    required: true,
    description: '订阅开始日期'
  },
  endDate: {
    type: Date,
    description: '订阅结束日期，如果为空则为无限期'
  },
  autoRenew: {
    type: Boolean,
    default: false,
    description: '是否自动续订'
  },
  // 订阅状态
  status: {
    type: String,
    enum: ['active', 'paused', 'cancelled', 'expired', 'pending'],
    default: 'pending',
    description: '订阅状态'
  },
  // 创建人追踪
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'createdByType',
    description: '创建人ID（用户/营养师/管理员）'
  },
  createdByType: {
    type: String,
    enum: ['User', 'Nutritionist', 'Admin'],
    description: '创建人类型'
  },
  // 支付信息
  payment: {
    billingCycle: {
      type: String,
      enum: ['weekly', 'biweekly', 'monthly', 'quarterly', 'annually'],
      default: 'monthly',
      description: '计费周期'
    },
    priceDetails: {
      basePrice: {
        type: Number,
        required: true,
        description: '基础价格'
      },
      discount: {
        type: Number,
        default: 0,
        description: '折扣金额'
      },
      tax: {
        type: Number,
        default: 0,
        description: '税费'
      },
      total: {
        type: Number,
        required: true,
        description: '总金额'
      }
    },
    paymentMethod: {
      type: String,
      enum: ['creditCard', 'debitCard', 'wechatPay', 'alipay', 'bankTransfer'],
      required: true,
      description: '支付方式'
    },
    paymentStatus: {
      type: String,
      enum: ['paid', 'pending', 'failed'],
      default: 'pending',
      description: '支付状态'
    },
    nextBillingDate: {
      type: Date,
      description: '下次计费日期'
    },
    paymentHistory: [{
      transactionId: {
        type: String,
        description: '交易ID',
        sensitivityLevel: 2
      },
      amount: {
        type: Number,
        description: '支付金额',
        sensitivityLevel: 2
      },
      date: {
        type: Date,
        default: Date.now,
        description: '支付日期'
      },
      status: {
        type: String,
        enum: ['success', 'pending', 'failed', 'refunded'],
        default: 'success',
        description: '支付结果状态'
      }
    }]
  },
  // 配送信息
  delivery: {
    address: {
      line1: {
        type: String,
        description: '地址第一行'
      },
      line2: {
        type: String,
        description: '地址第二行'
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
        description: '邮政编码'
      },
      country: {
        type: String,
        default: 'China',
        description: '国家'
      }
    },
    preferredTime: {
      type: String,
      enum: ['morning', 'noon', 'afternoon', 'evening'],
      default: 'noon',
      description: '首选配送时间'
    },
    deliveryInstructions: {
      type: String,
      description: '配送说明'
    },
    contactPhone: {
      type: String,
      description: '联系电话',
      sensitivityLevel: 2
    }
  },
  // 订阅偏好设置
  preferences: {
    allowSubstitutions: {
      type: Boolean,
      default: true,
      description: '是否允许替代品'
    },
    notificationPreferences: {
      email: {
        type: Boolean,
        default: true,
        description: '是否接收邮件通知'
      },
      sms: {
        type: Boolean,
        default: true,
        description: '是否接收短信通知'
      },
      app: {
        type: Boolean,
        default: true,
        description: '是否接收应用通知'
      }
    },
    specialInstructions: {
      type: String,
      description: '特殊说明'
    }
  },
  // 相关的营养档案
  nutritionProfileId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile',
    description: '关联的营养档案ID'
  },
  // 订单生成历史
  orderHistory: [{
    orderId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Order',
      description: '关联订单ID'
    },
    generatedAt: {
      type: Date,
      default: Date.now,
      description: '生成日期'
    },
    status: {
      type: String,
      enum: ['generated', 'delivered', 'cancelled', 'skipped'],
      default: 'generated',
      description: '订单状态'
    }
  }],
  // 访问控制
  privacyLevel: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private',
    description: '隐私级别'
  },
  // 授权记录
  accessGrants: [{
    grantedTo: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'accessGrants.grantedToType',
      description: '授权对象ID'
    },
    grantedToType: {
      type: String,
      enum: ['Nutritionist', 'Merchant', 'Admin'],
      description: '授权对象类型'
    },
    grantedAt: {
      type: Date,
      default: Date.now,
      description: '授权时间'
    },
    validUntil: {
      type: Date,
      description: '授权有效期'
    },
    accessLevel: {
      type: String,
      enum: ['read', 'modify', 'full'],
      default: 'read',
      description: '授权级别'
    }
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引
subscriptionSchema.index({ userId: 1 });
subscriptionSchema.index({ merchantId: 1 });
subscriptionSchema.index({ status: 1 });
subscriptionSchema.index({ subscriptionType: 1 });
subscriptionSchema.index({ 'plan.id': 1 });
subscriptionSchema.index({ startDate: 1 });
subscriptionSchema.index({ endDate: 1 });

// 虚拟字段
subscriptionSchema.virtual('isActive').get(function() {
  const now = new Date();
  if (this.status !== 'active') return false;
  
  if (this.startDate > now) return false;
  
  if (this.endDate && this.endDate < now) return false;
  
  return true;
});

subscriptionSchema.virtual('daysRemaining').get(function() {
  if (!this.endDate) return Infinity; // 无限期订阅
  
  const now = new Date();
  const end = new Date(this.endDate);
  
  return Math.max(0, Math.ceil((end - now) / (1000 * 60 * 60 * 24)));
});

subscriptionSchema.virtual('renewalStatus').get(function() {
  if (!this.endDate || !this.autoRenew) return 'not_applicable';
  
  const daysRemaining = this.daysRemaining;
  return daysRemaining <= 3 ? 'upcoming' : 'scheduled';
});

subscriptionSchema.virtual('currentPeriod').get(function() {
  const now = new Date();
  
  // 获取当前周期的起始日期
  let periodStart = new Date(this.startDate);
  let periodEnd;
  
  if (this.payment && this.payment.billingCycle) {
    // 如果存在结束日期且在当前日期之前，则不在活跃周期内
    if (this.endDate && new Date(this.endDate) < now) {
      return null;
    }
    
    // 根据计费周期计算当前周期的结束日期
    if (this.payment.nextBillingDate) {
      periodEnd = new Date(this.payment.nextBillingDate);
    }
  }
  
  return {
    start: periodStart,
    end: periodEnd || this.endDate || null
  };
});

// 关联查询虚拟字段
subscriptionSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

subscriptionSchema.virtual('merchant', {
  ref: 'Merchant',
  localField: 'merchantId',
  foreignField: '_id',
  justOne: true
});

subscriptionSchema.virtual('nutritionProfile', {
  ref: 'NutritionProfile',
  localField: 'nutritionProfileId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
subscriptionSchema.methods.calculateNextPaymentDate = function() {
  const now = new Date();
  let nextDate = new Date(this.startDate);
  
  // 如果没有设置计费周期，则返回null
  if (!this.payment || !this.payment.billingCycle) {
    return null;
  }
  
  // 根据计费周期计算下次付款日期
  while (nextDate <= now) {
    switch (this.payment.billingCycle) {
      case 'weekly':
        nextDate.setDate(nextDate.getDate() + 7);
        break;
      case 'biweekly':
        nextDate.setDate(nextDate.getDate() + 14);
        break;
      case 'monthly':
        nextDate.setMonth(nextDate.getMonth() + 1);
        break;
      case 'quarterly':
        nextDate.setMonth(nextDate.getMonth() + 3);
        break;
      case 'annually':
        nextDate.setFullYear(nextDate.getFullYear() + 1);
        break;
    }
  }
  
  return nextDate;
};

subscriptionSchema.methods.addBillingCycle = function(amount, status = 'pending') {
  const now = new Date();
  
  // 创建新的付款记录
  if (!this.payment.paymentHistory) {
    this.payment.paymentHistory = [];
  }
  
  // 生成一个简单的交易ID
  const transactionId = `txn_${Date.now()}_${Math.floor(Math.random() * 1000)}`;
  
  // 添加到付款历史记录
  this.payment.paymentHistory.push({
    transactionId,
    amount,
    date: now,
    status
  });
  
  // 更新下次计费日期
  this.payment.nextBillingDate = this.calculateNextPaymentDate();
  
  // 如果状态是待处理，则设置付款状态为待处理
  if (status === 'pending') {
    this.payment.paymentStatus = 'pending';
  } else if (status === 'success') {
    this.payment.paymentStatus = 'paid';
    
    // 如果有结束日期且计费周期不为空，则根据计费周期延长结束日期
    if (this.endDate && this.payment.billingCycle) {
      switch (this.payment.billingCycle) {
        case 'weekly':
          this.endDate.setDate(this.endDate.getDate() + 7);
          break;
        case 'biweekly':
          this.endDate.setDate(this.endDate.getDate() + 14);
          break;
        case 'monthly':
          this.endDate.setMonth(this.endDate.getMonth() + 1);
          break;
        case 'quarterly':
          this.endDate.setMonth(this.endDate.getMonth() + 3);
          break;
        case 'annually':
          this.endDate.setFullYear(this.endDate.getFullYear() + 1);
          break;
      }
    }
  }
  
  return this;
};

subscriptionSchema.methods.cancel = function(reason = '用户取消', immediate = false) {
  if (immediate) {
    // 立即取消订阅
    this.status = 'cancelled';
    this.cancelReason = reason;
    this.endDate = new Date(); // 设置结束日期为当前日期
  } else {
    // 到期后取消订阅（禁止自动续订）
    this.autoRenew = false;
    this.cancelReason = reason;
  }
  
  return this.save();
};

subscriptionSchema.methods.pause = function(resumeDate = null, reason = null) {
  // 确保订阅当前是活跃状态
  if (this.status !== 'active') {
    throw new Error('只能暂停活跃状态的订阅');
  }
  
  // 保存当前状态以便之后恢复
  this._previousStatus = {
    status: this.status,
    endDate: this.endDate
  };
  
  // 更新状态
  this.status = 'paused';
  
  // 如果提供了恢复日期，则设置
  if (resumeDate && resumeDate instanceof Date) {
    this.resumeDate = resumeDate;
  }
  
  // 如果提供了暂停原因，则记录
  if (reason) {
    this.pauseReason = reason;
  }
  
  // 如果有结束日期，需要延长结束日期以补偿暂停期
  if (this.endDate) {
    this._pauseStartDate = new Date(); // 记录暂停开始时间
  }
  
  return this.save();
};

subscriptionSchema.methods.resume = function() {
  // 确保订阅当前是暂停状态
  if (this.status !== 'paused') {
    throw new Error('只能恢复暂停状态的订阅');
  }
  
  // 恢复到活跃状态
  this.status = 'active';
  
  // 清除恢复日期
  this.resumeDate = undefined;
  
  // 清除暂停原因
  this.pauseReason = undefined;
  
  // 如果有结束日期，需要根据暂停的时长延长结束日期
  if (this.endDate && this._pauseStartDate) {
    const pauseDuration = new Date() - this._pauseStartDate;
    this.endDate = new Date(this.endDate.getTime() + pauseDuration);
    this._pauseStartDate = undefined;
  }
  
  return this.save();
};

// 静态方法
subscriptionSchema.statics.findActiveByUser = function(userId) {
  const now = new Date();
  
  return this.find({
    userId: userId,
    status: 'active',
    startDate: { $lte: now },
    $or: [
      { endDate: { $gt: now } },
      { endDate: null }
    ]
  });
};

subscriptionSchema.statics.findExpiringSubscriptions = function(daysThreshold = 7) {
  const now = new Date();
  const thresholdDate = new Date();
  thresholdDate.setDate(thresholdDate.getDate() + daysThreshold);
  
  return this.find({
    status: 'active',
    endDate: { $gte: now, $lte: thresholdDate },
    autoRenew: false
  });
};

subscriptionSchema.statics.getTotalActiveSubscriptions = async function(merchantId = null) {
  const now = new Date();
  
  const match = {
    status: 'active',
    startDate: { $lte: now },
    $or: [
      { endDate: { $gt: now } },
      { endDate: null }
    ]
  };
  
  if (merchantId) {
    match.merchantId = mongoose.Types.ObjectId(merchantId);
  }
  
  const result = await this.aggregate([
    { $match: match },
    { $group: {
      _id: '$subscriptionType',
      count: { $sum: 1 }
    }},
    { $project: {
      _id: 0,
      subscriptionType: '$_id',
      count: 1
    }}
  ]);
  
  return result;
};

// 生成订阅编号
function generateSubscriptionNumber() {
  const timestamp = Date.now().toString().slice(-8);
  const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
  return `SUB${timestamp}${random}`;
}

// 更新订阅状态中间件
subscriptionSchema.pre('save', async function(next) {
  // 如果是新建订阅，生成订阅编号
  if (this.isNew && !this.subscriptionNumber) {
    this.subscriptionNumber = generateSubscriptionNumber();
  }
  
  // 更新订阅状态
  const now = new Date();
  
  // 如果开始日期在未来，状态应为pending
  if (this.startDate > now && this.status === 'active') {
    this.status = 'pending';
  }
  
  // 如果超过结束日期，更新状态为expired
  if (this.endDate && this.endDate < now && this.status !== 'cancelled') {
    this.status = 'expired';
  }
  
  // 如果订阅是活跃的，但结束日期接近且不自动续订，则触发即将到期提醒
  if (this.status === 'active' && this.endDate && !this.autoRenew) {
    const daysToExpiry = Math.ceil((this.endDate - now) / (1000 * 60 * 60 * 24));
    
    if (daysToExpiry <= 7 && (!this._previouslyWarned || this._previouslyWarned > daysToExpiry)) {
      // 在这里可以添加通知逻辑，例如发送邮件、短信等
      console.log(`订阅 ${this.subscriptionNumber} 将在 ${daysToExpiry} 天后到期`);
      
      // 记录已经提醒过，避免重复提醒
      this._previouslyWarned = daysToExpiry;
    }
  }
  
  next();
});

// 为模型添加一些在订阅操作的钩子
subscriptionSchema.methods.setNextBillingDate = function() {
  // 记录上次更新时间
  this.updatedAt = Date.now();
  
  // 计算下一个计费日期
  if (this.status === 'active' && this.payment && this.payment.billingCycle) {
    const nextBillingDate = this.calculateNextPaymentDate();
    if (nextBillingDate) {
      this.payment.nextBillingDate = nextBillingDate;
    }
  }
  
  return this;
};

// 一些操作的封装，方便接口调用
// 暂停订阅
subscriptionSchema.methods.pauseSubscription = function(userId, userType, reason) {
  // 检查是否有权限
  const canPause = userType === 'admin' || 
                  (userType === 'user' && this.userId.toString() === userId.toString()) ||
                  (userType === 'merchant' && this.merchantId.toString() === userId.toString());
  
  if (!canPause) {
    throw new Error('没有权限暂停此订阅');
  }
  
  return this.pause(null, reason);
};

// 取消订阅
subscriptionSchema.methods.cancelSubscription = function(userId, userType, reason) {
  // 检查是否有权限
  const canCancel = userType === 'admin' || 
                  (userType === 'user' && this.userId.toString() === userId.toString()) ||
                  (userType === 'merchant' && this.merchantId.toString() === userId.toString());
  
  if (!canCancel) {
    throw new Error('没有权限取消此订阅');
  }
  
  // 默认为到期后取消
  const immediate = userType === 'admin'; // 只有管理员可以立即取消
  
  return this.cancel(reason, immediate);
};

// 为订阅添加分析功能
subscriptionSchema.statics.getSubscriptionAnalytics = async function(options = {}) {
  const { 
    merchantId = null,
    startDate = null,
    endDate = null,
    groupBy = 'day'
  } = options;
  
  const match = {};
  
  if (merchantId) {
    match.merchantId = mongoose.Types.ObjectId(merchantId);
  }
  
  if (startDate || endDate) {
    match.createdAt = {};
    if (startDate) match.createdAt.$gte = new Date(startDate);
    if (endDate) match.createdAt.$lte = new Date(endDate);
  }
  
  let dateFormat;
  if (groupBy === 'day') {
    dateFormat = { $dateToString: { format: '%Y-%m-%d', date: '$createdAt' } };
  } else if (groupBy === 'week') {
    dateFormat = { 
      $dateToString: { 
        format: '%Y-W%U', 
        date: '$createdAt'
      }
    };
  } else if (groupBy === 'month') {
    dateFormat = { $dateToString: { format: '%Y-%m', date: '$createdAt' } };
  }
  
  const pipeline = [
    { $match: match },
    { $group: {
      _id: {
        timePeriod: dateFormat,
        subscriptionType: '$subscriptionType'
      },
      count: { $sum: 1 },
      revenue: { $sum: '$payment.priceDetails.total' }
    }},
    { $sort: { '_id.timePeriod': 1 } }
  ];
  
  const results = await this.aggregate(pipeline);
  
  // 转换结果为更易于使用的格式
  const formatted = {};
  results.forEach(item => {
    const period = item._id.timePeriod;
    const type = item._id.subscriptionType;
    
    if (!formatted[period]) {
      formatted[period] = { total: 0 };
    }
    
    formatted[period][type] = item.count;
    formatted[period].total += item.count;
    formatted[period].revenue = (formatted[period].revenue || 0) + (item.revenue || 0);
  });
  
  return formatted;
};

// 前置钩子：在保存前格式化数据
subscriptionSchema.pre('save', function(next) {
  // 设置下次计费日期
  if (this.isNew || this.isModified('payment.billingCycle') || this.isModified('startDate')) {
    this.setNextBillingDate();
  }
  
  next();
});

// 创建模型
const Subscription = ModelFactory.createModel('Subscription', subscriptionSchema);

// 添加分片支持
Subscription.getShardKey = function(doc) {
  return doc.userId.toString();
};

module.exports = Subscription; 