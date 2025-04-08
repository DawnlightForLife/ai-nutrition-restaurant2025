const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

// 订阅项目子模式（如餐品、营养指导等）
const subscriptionItemSchema = new mongoose.Schema({
  item_type: {
    type: String,
    enum: ['meal', 'dish', 'consultation', 'nutrition_plan'],
    required: true
  },
  item_id: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'items.item_type_ref'
  },
  item_type_ref: {
    type: String,
    enum: ['Dish', 'AiRecommendation', 'Nutritionist'],
    required: true
  },
  item_name: {
    type: String,
    required: true
  },
  quantity: {
    type: Number,
    min: 1,
    default: 1
  },
  frequency: {
    type: String,
    enum: ['daily', 'weekdays', 'weekends', 'weekly', 'monthly', 'custom'],
    default: 'daily'
  },
  // 自定义重复模式
  custom_schedule: {
    days: [{ 
      type: Number, 
      min: 0, 
      max: 6 
    }], // 0-6 (周日-周六)
    weeks: [{ 
      type: Number, 
      min: 1, 
      max: 5 
    }], // 1-5 (一个月的第几周)
    months: [{ 
      type: Number, 
      min: 1, 
      max: 12 
    }] // 1-12 (一年的第几个月)
  },
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  price_per_unit: {
    type: Number,
    required: true,
    min: 0
  },
  subtotal: {
    type: Number,
    required: true,
    min: 0
  }
});

// 定义主订阅模式
const subscriptionSchema = new mongoose.Schema({
  // 基本信息
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  merchant_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true
  },
  subscription_number: {
    type: String,
    required: true,
    unique: true
  },
  // 订阅类型
  subscription_type: {
    type: String,
    enum: ['meal_plan', 'nutritionist_service', 'gym_meal', 'maternity_meal', 'school_company_meal'],
    required: true
  },
  // 订阅名称
  name: {
    type: String,
    required: true
  },
  description: String,
  // 订阅项目
  items: [subscriptionItemSchema],
  // 订阅时间段
  start_date: {
    type: Date,
    required: true
  },
  end_date: Date, // 如果为空则为无限期
  auto_renew: {
    type: Boolean,
    default: false
  },
  // 订阅状态
  status: {
    type: String,
    enum: ['active', 'paused', 'cancelled', 'expired', 'pending'],
    default: 'pending'
  },
  // 支付信息
  payment: {
    billing_cycle: {
      type: String,
      enum: ['weekly', 'biweekly', 'monthly', 'quarterly', 'annually'],
      default: 'monthly'
    },
    price_details: {
      base_price: {
        type: Number,
        required: true
      },
      discount: {
        type: Number,
        default: 0
      },
      tax: {
        type: Number,
        default: 0
      },
      total: {
        type: Number,
        required: true
      }
    },
    payment_method: {
      type: String,
      enum: ['credit_card', 'debit_card', 'wechat_pay', 'alipay', 'bank_transfer'],
      required: true
    },
    payment_status: {
      type: String,
      enum: ['paid', 'pending', 'failed'],
      default: 'pending'
    },
    next_billing_date: Date,
    payment_history: [{
      transaction_id: String,
      amount: Number,
      date: {
        type: Date,
        default: Date.now
      },
      status: {
        type: String,
        enum: ['success', 'pending', 'failed', 'refunded']
      }
    }]
  },
  // 配送信息
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
      }
    },
    preferred_time: {
      type: String,
      enum: ['morning', 'noon', 'afternoon', 'evening'],
      default: 'noon'
    },
    delivery_instructions: String,
    contact_phone: String
  },
  // 订阅偏好设置
  preferences: {
    allow_substitutions: {
      type: Boolean,
      default: true
    },
    notification_preferences: {
      email: {
        type: Boolean,
        default: true
      },
      sms: {
        type: Boolean,
        default: true
      },
      app: {
        type: Boolean,
        default: true
      }
    },
    special_instructions: String
  },
  // 相关的营养档案
  nutrition_profile_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NutritionProfile'
  },
  // 订单生成历史
  order_history: [{
    order_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Order'
    },
    generated_at: {
      type: Date,
      default: Date.now
    },
    status: {
      type: String,
      enum: ['generated', 'delivered', 'cancelled', 'skipped'],
      default: 'generated'
    }
  }],
  // 访问控制
  privacy_level: {
    type: String,
    enum: ['private', 'share_with_nutritionist', 'share_with_merchant', 'public'],
    default: 'private'
  },
  // 授权记录
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
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System']
    },
    ip_address: String,
    action: {
      type: String,
      enum: ['view', 'create', 'update', 'cancel', 'renew', 'pause']
    }
  }],
  // 修改历史
  modification_history: [{
    modified_at: {
      type: Date,
      default: Date.now
    },
    modified_by: {
      type: mongoose.Schema.Types.ObjectId,
      refPath: 'modification_history.modified_by_type'
    },
    modified_by_type: {
      type: String,
      enum: ['User', 'Nutritionist', 'Merchant', 'Admin', 'System']
    },
    changes: [String],
    reason: String
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
subscriptionSchema.index({ user_id: 1 });
subscriptionSchema.index({ merchant_id: 1 });
subscriptionSchema.index({ status: 1 });
subscriptionSchema.index({ subscription_type: 1 });
subscriptionSchema.index({ 'plan.id': 1 });
subscriptionSchema.index({ start_date: 1 });
subscriptionSchema.index({ end_date: 1 });
subscriptionSchema.index({ 'payment.next_payment_date': 1 });
subscriptionSchema.index({ 'nutrition_profile_id': 1 });

// 添加虚拟字段
subscriptionSchema.virtual('is_active').get(function() {
  const now = new Date();
  const startDate = new Date(this.start_date);
  const endDate = this.end_date ? new Date(this.end_date) : null;
  
  return this.status === 'active' && 
         startDate <= now && 
         (!endDate || endDate >= now);
});

subscriptionSchema.virtual('days_remaining').get(function() {
  if (!this.is_active || !this.end_date) return 0;
  
  const now = new Date();
  const endDate = new Date(this.end_date);
  const diffTime = endDate - now;
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
  
  return Math.max(0, diffDays);
});

subscriptionSchema.virtual('renewal_status').get(function() {
  if (!this.is_active) return 'inactive';
  if (this.auto_renew) return 'auto_renewal';
  if (this.days_remaining <= 7) return 'expiring_soon';
  return 'active_no_renewal';
});

subscriptionSchema.virtual('current_period').get(function() {
  const now = new Date();
  
  // 查找当前周期
  if (!this.billing_cycles || this.billing_cycles.length === 0) {
    return null;
  }
  
  return this.billing_cycles
    .sort((a, b) => new Date(b.period_start) - new Date(a.period_start))
    .find(cycle => {
      const periodStart = new Date(cycle.period_start);
      const periodEnd = new Date(cycle.period_end);
      return periodStart <= now && periodEnd >= now;
    }) || null;
});

// 关联
subscriptionSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

subscriptionSchema.virtual('merchant', {
  ref: 'Merchant',
  localField: 'merchant_id',
  foreignField: '_id',
  justOne: true
});

subscriptionSchema.virtual('nutrition_profile', {
  ref: 'NutritionProfile',
  localField: 'nutrition_profile_id',
  foreignField: '_id',
  justOne: true
});

// 实例方法
subscriptionSchema.methods.calculateNextPaymentDate = function() {
  if (!this.is_active || !this.auto_renew) return null;
  
  const now = new Date();
  let nextPaymentDate;
  
  if (this.billing_frequency === 'monthly') {
    nextPaymentDate = new Date(now.getFullYear(), now.getMonth() + 1, now.getDate());
  } else if (this.billing_frequency === 'quarterly') {
    nextPaymentDate = new Date(now.getFullYear(), now.getMonth() + 3, now.getDate());
  } else if (this.billing_frequency === 'annual') {
    nextPaymentDate = new Date(now.getFullYear() + 1, now.getMonth(), now.getDate());
  } else {
    // 默认按月
    nextPaymentDate = new Date(now.getFullYear(), now.getMonth() + 1, now.getDate());
  }
  
  // 更新下次付款日期
  if (!this.payment) this.payment = {};
  this.payment.next_payment_date = nextPaymentDate;
  
  return nextPaymentDate;
};

subscriptionSchema.methods.addBillingCycle = function(amount, status = 'pending') {
  const now = new Date();
  let periodEnd;
  
  if (this.billing_frequency === 'monthly') {
    periodEnd = new Date(now.getFullYear(), now.getMonth() + 1, now.getDate());
  } else if (this.billing_frequency === 'quarterly') {
    periodEnd = new Date(now.getFullYear(), now.getMonth() + 3, now.getDate());
  } else if (this.billing_frequency === 'annual') {
    periodEnd = new Date(now.getFullYear() + 1, now.getMonth(), now.getDate());
  } else {
    // 默认按月
    periodEnd = new Date(now.getFullYear(), now.getMonth() + 1, now.getDate());
  }
  
  const newCycle = {
    period_start: now,
    period_end: periodEnd,
    amount: amount,
    status: status,
    created_at: now
  };
  
  if (!this.billing_cycles) this.billing_cycles = [];
  this.billing_cycles.push(newCycle);
  
  // 更新订阅结束日期
  this.end_date = periodEnd;
  
  return newCycle;
};

subscriptionSchema.methods.cancel = function(reason = '用户取消', immediate = false) {
  if (immediate) {
    this.status = 'cancelled';
    this.end_date = new Date(); // 立即结束
  } else {
    // 只取消自动续费，让订阅到期后结束
    this.auto_renew = false;
    this.status = 'ending'; // 标记为即将结束
  }
  
  this.cancellation = {
    date: new Date(),
    reason: reason
  };
  
  return this;
};

subscriptionSchema.methods.pause = function(resumeDate = null, reason = null) {
  if (this.status !== 'active') {
    throw new Error('只有活跃的订阅才能被暂停');
  }
  
  this.status = 'paused';
  this.pause_history = this.pause_history || [];
  
  this.pause_history.push({
    paused_at: new Date(),
    scheduled_resume_date: resumeDate,
    reason: reason
  });
  
  // 如果指定了恢复日期，相应延长订阅结束日期
  if (resumeDate && this.end_date) {
    const now = new Date();
    const resumeDateObj = new Date(resumeDate);
    const pauseDuration = resumeDateObj - now;
    
    if (pauseDuration > 0) {
      const newEndDate = new Date(this.end_date);
      newEndDate.setTime(newEndDate.getTime() + pauseDuration);
      this.end_date = newEndDate;
    }
  }
  
  return this;
};

subscriptionSchema.methods.resume = function() {
  if (this.status !== 'paused') {
    throw new Error('只有已暂停的订阅才能被恢复');
  }
  
  this.status = 'active';
  
  // 更新最后一次暂停记录
  if (this.pause_history && this.pause_history.length > 0) {
    const lastPause = this.pause_history[this.pause_history.length - 1];
    lastPause.resumed_at = new Date();
    
    // 计算实际暂停时间与计划的差异
    if (lastPause.scheduled_resume_date) {
      const scheduledResume = new Date(lastPause.scheduled_resume_date);
      const actualResume = new Date(lastPause.resumed_at);
      
      // 如果提前恢复，缩短结束日期
      if (actualResume < scheduledResume && this.end_date) {
        const timeDiff = scheduledResume - actualResume;
        const newEndDate = new Date(this.end_date);
        newEndDate.setTime(newEndDate.getTime() - timeDiff);
        this.end_date = newEndDate;
      }
    }
  }
  
  return this;
};

// 静态方法
subscriptionSchema.statics.findActiveByUser = function(userId) {
  const now = new Date();
  
  return this.find({
    user_id: userId,
    status: 'active',
    start_date: { $lte: now },
    $or: [
      { end_date: { $gte: now } },
      { end_date: null }
    ]
  });
};

subscriptionSchema.statics.findExpiringSubscriptions = function(daysThreshold = 7) {
  const now = new Date();
  const thresholdDate = new Date();
  thresholdDate.setDate(now.getDate() + daysThreshold);
  
  return this.find({
    status: 'active',
    auto_renew: false,
    start_date: { $lte: now },
    end_date: { $gte: now, $lte: thresholdDate }
  });
};

subscriptionSchema.statics.getTotalActiveSubscriptions = async function(merchantId = null) {
  const match = {
    status: 'active',
    start_date: { $lte: new Date() },
    $or: [
      { end_date: { $gte: new Date() } },
      { end_date: null }
    ]
  };
  
  if (merchantId) {
    match.merchant_id = mongoose.Types.ObjectId(merchantId);
  }
  
  const result = await this.aggregate([
    { $match: match },
    { $group: {
      _id: null,
      total: { $sum: 1 },
      revenue: { $sum: '$price' }
    }}
  ]);
  
  return result.length > 0 ? result[0] : { total: 0, revenue: 0 };
};

// 生成唯一订阅号
subscriptionSchema.pre('save', async function(next) {
  if (this.isNew) {
    const now = new Date();
    const year = now.getFullYear().toString().substr(-2);
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const random = Math.floor(Math.random() * 10000).toString().padStart(4, '0');
    
    // 尝试生成一个唯一的订阅号
    let isUnique = false;
    let attempts = 0;
    let generatedNumber;
    
    while (!isUnique && attempts < 10) {
      generatedNumber = `SUB${year}${month}${day}${random}${attempts}`;
      
      // 检查是否唯一
      const existingSubscription = await this.constructor.findOne({ subscription_number: generatedNumber });
      if (!existingSubscription) {
        isUnique = true;
      }
      
      attempts++;
    }
    
    if (!isUnique) {
      return next(new Error('无法生成唯一订阅号'));
    }
    
    this.subscription_number = generatedNumber;
    
    // 如果设置了自动续订，但没有设置结束日期，则设置下次计费日期
    if (this.auto_renew && !this.end_date) {
      this.setNextBillingDate();
    }
  }
  
  // 更新时间
  this.updated_at = Date.now();
  
  next();
});

// 设置下一个计费日期的方法
subscriptionSchema.methods.setNextBillingDate = function() {
  const nextDate = new Date();
  
  switch(this.payment.billing_cycle) {
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
    default:
      nextDate.setMonth(nextDate.getMonth() + 1);
  }
  
  this.payment.next_billing_date = nextDate;
};

// 暂停订阅
subscriptionSchema.methods.pauseSubscription = function(userId, userType, reason) {
  this.status = 'paused';
  
  // 记录修改历史
  if (!this.modification_history) {
    this.modification_history = [];
  }
  
  this.modification_history.push({
    modified_at: Date.now(),
    modified_by: userId,
    modified_by_type: userType,
    changes: ['status changed to paused'],
    reason: reason || '用户请求暂停'
  });
};

// 取消订阅
subscriptionSchema.methods.cancelSubscription = function(userId, userType, reason) {
  this.status = 'cancelled';
  
  // 记录修改历史
  if (!this.modification_history) {
    this.modification_history = [];
  }
  
  this.modification_history.push({
    modified_at: Date.now(),
    modified_by: userId,
    modified_by_type: userType,
    changes: ['status changed to cancelled'],
    reason: reason || '用户请求取消'
  });
};

// 重新激活订阅
subscriptionSchema.methods.reactivateSubscription = function(userId, userType, reason) {
  this.status = 'active';
  this.setNextBillingDate();
  
  // 记录修改历史
  if (!this.modification_history) {
    this.modification_history = [];
  }
  
  this.modification_history.push({
    modified_at: Date.now(),
    modified_by: userId,
    modified_by_type: userType,
    changes: ['status changed to active', 'next_billing_date updated'],
    reason: reason || '用户请求重新激活'
  });
};

// 续订订阅
subscriptionSchema.methods.renewSubscription = function(endDate = null) {
  // 如果指定了新的结束日期，则更新它
  if (endDate) {
    this.end_date = endDate;
  }
  
  this.status = 'active';
  this.setNextBillingDate();
  
  // 记录修改历史
  if (!this.modification_history) {
    this.modification_history = [];
  }
  
  this.modification_history.push({
    modified_at: Date.now(),
    modified_by: this.user_id,
    modified_by_type: 'User',
    changes: ['subscription renewed', 'next_billing_date updated'],
    reason: '订阅续期'
  });
};

// 记录支付
subscriptionSchema.methods.recordPayment = function(transactionId, amount, status = 'success') {
  if (!this.payment.payment_history) {
    this.payment.payment_history = [];
  }
  
  this.payment.payment_history.push({
    transaction_id: transactionId,
    amount: amount,
    date: Date.now(),
    status: status
  });
  
  // 如果支付成功，更新支付状态和下次计费日期
  if (status === 'success') {
    this.payment.payment_status = 'paid';
    this.setNextBillingDate();
  } else if (status === 'failed') {
    this.payment.payment_status = 'failed';
  }
};

// 添加订单到订阅历史
subscriptionSchema.methods.addOrder = function(orderId, status = 'generated') {
  if (!this.order_history) {
    this.order_history = [];
  }
  
  this.order_history.push({
    order_id: orderId,
    generated_at: Date.now(),
    status: status
  });
};

// 授权访问方法
subscriptionSchema.methods.grantAccess = function(granteeId, granteeType, validUntil, accessLevel = 'read') {
  if (!this.access_grants) {
    this.access_grants = [];
  }
  
  // 检查是否已存在授权
  const existingGrant = this.access_grants.find(
    g => g.granted_to.equals(granteeId) && g.granted_to_type === granteeType && !g.revoked
  );
  
  if (existingGrant) {
    // 更新现有授权
    existingGrant.valid_until = validUntil;
    existingGrant.access_level = accessLevel;
  } else {
    // 创建新授权
    this.access_grants.push({
      granted_to: granteeId,
      granted_to_type: granteeType,
      granted_at: Date.now(),
      valid_until: validUntil,
      access_level: accessLevel
    });
  }
};

// 撤销授权方法
subscriptionSchema.methods.revokeAccess = function(granteeId, granteeType) {
  if (!this.access_grants) return false;
  
  let found = false;
  this.access_grants.forEach(grant => {
    if (grant.granted_to.equals(granteeId) && grant.granted_to_type === granteeType && !grant.revoked) {
      grant.revoked = true;
      grant.revoked_at = Date.now();
      found = true;
    }
  });
  
  return found;
};

// 记录访问方法
subscriptionSchema.methods.logAccess = async function(userId, userType, ipAddress, action) {
  if (!this.access_log) {
    this.access_log = [];
  }
  
  // 保持日志大小合理
  if (this.access_log.length >= 20) {
    this.access_log = this.access_log.slice(-19);
  }
  
  // 添加新的访问记录
  this.access_log.push({
    timestamp: Date.now(),
    accessed_by: userId,
    accessed_by_type: userType,
    ip_address: ipAddress,
    action: action
  });
  
  await this.save();
};

// 安全查询方法 - 考虑访问控制
subscriptionSchema.statics.findWithPermissionCheck = async function(query = {}, options = {}, user) {
  // 如果是用户查询自己的订阅，直接返回
  if (user && query.user_id && user._id.equals(query.user_id)) {
    return this.find(query, options);
  }
  
  // 如果是商户查询自己的订阅
  if (user && user.role === 'merchant' && query.merchant_id && user._id.equals(query.merchant_id)) {
    return this.find(query, options);
  }
  
  // 如果是营养师，检查是否有授权
  if (user && user.role === 'nutritionist') {
    const nutritionistId = user._id;
    
    // 扩展查询条件，添加权限检查
    const permissionQuery = {
      ...query,
      $or: [
        // 用户授权给这个营养师的订阅
        { 'access_grants.granted_to': nutritionistId, 'access_grants.granted_to_type': 'Nutritionist', 'access_grants.revoked': false },
        // 用户在隐私设置中分享给营养师的订阅
        { privacy_level: 'share_with_nutritionist' }
      ]
    };
    
    return this.find(permissionQuery, options);
  }
  
  // 如果是管理员，直接返回结果
  if (user && (user.role === 'admin' || user.role === 'super_admin')) {
    return this.find(query, options);
  }
  
  // 其他情况，返回空结果
  return [];
};

// 前置钩子 - 保存前自动计算下次付款日期
subscriptionSchema.pre('save', function(next) {
  if (this.isNew || this.isModified('auto_renew') || this.isModified('billing_frequency')) {
    if (this.is_active && this.auto_renew) {
      this.calculateNextPaymentDate();
    }
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Subscription = ModelFactory.createModel('Subscription', subscriptionSchema);

module.exports = Subscription; 