const mongoose = require('mongoose');
const { Schema, ObjectId } = mongoose;

const pointsRuleSchema = new Schema({
  // 规则名称
  name: {
    type: String,
    required: true,
    maxlength: 100
  },
  
  // 规则类型
  type: {
    type: String,
    enum: [
      'order_completion',    // 订单完成
      'order_amount',        // 订单金额
      'review_submission',   // 提交评价
      'referral_success',    // 推荐成功
      'daily_checkin',       // 每日签到
      'birthday_bonus',      // 生日奖励
      'activity_participation', // 活动参与
      'membership_upgrade',  // 会员升级
      'first_order',         // 首次下单
      'consecutive_orders'   // 连续下单
    ],
    required: true,
    index: true
  },
  
  // 规则状态
  status: {
    type: String,
    enum: ['active', 'inactive', 'expired'],
    default: 'active',
    index: true
  },
  
  // 积分计算配置
  pointsConfig: {
    // 计算方式
    calculationType: {
      type: String,
      enum: ['fixed', 'percentage', 'tiered', 'formula'],
      required: true
    },
    
    // 固定积分数量
    fixedAmount: {
      type: Number,
      min: 0
    },
    
    // 百分比（订单金额的百分比）
    percentage: {
      type: Number,
      min: 0,
      max: 100
    },
    
    // 分层积分配置
    tiers: [{
      minAmount: { type: Number, required: true },
      maxAmount: Number,
      points: { type: Number, required: true },
      multiplier: { type: Number, default: 1 }
    }],
    
    // 自定义公式
    formula: String,
    
    // 最小积分
    minPoints: {
      type: Number,
      default: 0
    },
    
    // 最大积分
    maxPoints: Number,
    
    // 倍率
    multiplier: {
      type: Number,
      default: 1,
      min: 0
    }
  },
  
  // 触发条件
  conditions: {
    // 最小订单金额
    minOrderAmount: Number,
    
    // 最大订单金额
    maxOrderAmount: Number,
    
    // 指定商品类别
    categoryIds: [{ type: ObjectId, ref: 'Category' }],
    
    // 指定门店
    storeIds: [{ type: ObjectId, ref: 'Store' }],
    
    // 用户会员等级
    membershipLevels: [String],
    
    // 用户注册时间要求（天数）
    minRegistrationDays: Number,
    
    // 历史订单数量要求
    minOrderCount: Number,
    
    // 时间限制
    timeRestrictions: {
      dayOfWeek: [Number], // 0-6, 0为周日
      hourOfDay: {
        start: Number, // 0-23
        end: Number    // 0-23
      },
      dateRange: {
        start: Date,
        end: Date
      }
    },
    
    // 自定义条件表达式
    customCondition: String
  },
  
  // 频率限制
  frequency: {
    // 限制类型
    limitType: {
      type: String,
      enum: ['once', 'daily', 'weekly', 'monthly', 'unlimited'],
      default: 'unlimited'
    },
    
    // 限制次数
    limitCount: {
      type: Number,
      default: 1
    },
    
    // 冷却时间（小时）
    cooldownHours: {
      type: Number,
      default: 0
    }
  },
  
  // 有效期配置
  validity: {
    // 规则有效期开始时间
    startDate: {
      type: Date,
      default: Date.now
    },
    
    // 规则有效期结束时间
    endDate: Date,
    
    // 获得积分的有效期（天数）
    pointsValidityDays: {
      type: Number,
      default: 365 // 默认积分1年有效
    }
  },
  
  // 优先级
  priority: {
    type: Number,
    default: 0,
    index: true
  },
  
  // 描述
  description: {
    type: String,
    maxlength: 500
  },
  
  // 创建者
  createdBy: {
    type: ObjectId,
    ref: 'User',
    required: true
  },
  
  // 最后修改者
  lastModifiedBy: {
    type: ObjectId,
    ref: 'User'
  },
  
  // 使用统计
  usageStats: {
    totalUsages: { type: Number, default: 0 },
    totalPointsIssued: { type: Number, default: 0 },
    lastUsedAt: Date,
    avgPointsPerUsage: { type: Number, default: 0 }
  },
  
  // A/B测试配置
  abTestConfig: {
    isTestRule: { type: Boolean, default: false },
    testGroup: String,
    testPercentage: { type: Number, min: 0, max: 100 },
    controlRuleId: { type: ObjectId, ref: 'PointsRule' }
  },
  
  // 标签
  tags: [String]
}, {
  timestamps: true,
  collection: 'points_rules'
});

// 索引优化
pointsRuleSchema.index({ type: 1, status: 1, priority: -1 });
pointsRuleSchema.index({ status: 1, 'validity.startDate': 1, 'validity.endDate': 1 });
pointsRuleSchema.index({ 'conditions.storeIds': 1 });
pointsRuleSchema.index({ 'conditions.categoryIds': 1 });

// 获取适用的积分规则
pointsRuleSchema.statics.getApplicableRules = async function(context) {
  const { type, userId, orderAmount, storeId, categoryIds, timestamp = new Date() } = context;
  
  const query = {
    type,
    status: 'active',
    'validity.startDate': { $lte: timestamp }
  };
  
  // 检查有效期
  if (timestamp) {
    query.$or = [
      { 'validity.endDate': { $exists: false } },
      { 'validity.endDate': null },
      { 'validity.endDate': { $gte: timestamp } }
    ];
  }
  
  const rules = await this.find(query).sort({ priority: -1 });
  
  // 过滤符合条件的规则
  const applicableRules = [];
  
  for (const rule of rules) {
    if (await this.checkConditions(rule, context)) {
      applicableRules.push(rule);
    }
  }
  
  return applicableRules;
};

// 检查规则条件
pointsRuleSchema.statics.checkConditions = async function(rule, context) {
  const { userId, orderAmount, storeId, categoryIds, userMembershipLevel, userRegistrationDate, userOrderCount } = context;
  const conditions = rule.conditions;
  
  // 检查订单金额条件
  if (orderAmount !== undefined) {
    if (conditions.minOrderAmount && orderAmount < conditions.minOrderAmount) return false;
    if (conditions.maxOrderAmount && orderAmount > conditions.maxOrderAmount) return false;
  }
  
  // 检查门店条件
  if (storeId && conditions.storeIds && conditions.storeIds.length > 0) {
    if (!conditions.storeIds.includes(storeId)) return false;
  }
  
  // 检查商品类别条件
  if (categoryIds && conditions.categoryIds && conditions.categoryIds.length > 0) {
    const hasMatchingCategory = categoryIds.some(catId => 
      conditions.categoryIds.some(condCatId => condCatId.toString() === catId.toString())
    );
    if (!hasMatchingCategory) return false;
  }
  
  // 检查会员等级条件
  if (conditions.membershipLevels && conditions.membershipLevels.length > 0) {
    if (!userMembershipLevel || !conditions.membershipLevels.includes(userMembershipLevel)) return false;
  }
  
  // 检查注册时间条件
  if (conditions.minRegistrationDays && userRegistrationDate) {
    const daysSinceRegistration = Math.floor((Date.now() - new Date(userRegistrationDate).getTime()) / (1000 * 60 * 60 * 24));
    if (daysSinceRegistration < conditions.minRegistrationDays) return false;
  }
  
  // 检查历史订单数量条件
  if (conditions.minOrderCount && userOrderCount !== undefined) {
    if (userOrderCount < conditions.minOrderCount) return false;
  }
  
  // 检查时间限制
  if (conditions.timeRestrictions) {
    const now = new Date();
    const timeRestrictions = conditions.timeRestrictions;
    
    // 检查星期几限制
    if (timeRestrictions.dayOfWeek && timeRestrictions.dayOfWeek.length > 0) {
      if (!timeRestrictions.dayOfWeek.includes(now.getDay())) return false;
    }
    
    // 检查小时限制
    if (timeRestrictions.hourOfDay) {
      const currentHour = now.getHours();
      const { start, end } = timeRestrictions.hourOfDay;
      if (start <= end) {
        if (currentHour < start || currentHour > end) return false;
      } else {
        // 跨天的情况
        if (currentHour < start && currentHour > end) return false;
      }
    }
    
    // 检查日期范围限制
    if (timeRestrictions.dateRange) {
      const { start, end } = timeRestrictions.dateRange;
      if (start && now < new Date(start)) return false;
      if (end && now > new Date(end)) return false;
    }
  }
  
  // 检查频率限制
  if (userId && rule.frequency.limitType !== 'unlimited') {
    const isWithinLimit = await this.checkFrequencyLimit(rule._id, userId, rule.frequency);
    if (!isWithinLimit) return false;
  }
  
  return true;
};

// 检查频率限制
pointsRuleSchema.statics.checkFrequencyLimit = async function(ruleId, userId, frequency) {
  const PointsTransaction = mongoose.model('PointsTransaction');
  
  let startDate;
  const now = new Date();
  
  switch (frequency.limitType) {
    case 'daily':
      startDate = new Date(now);
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'weekly':
      startDate = new Date(now);
      startDate.setDate(now.getDate() - now.getDay());
      startDate.setHours(0, 0, 0, 0);
      break;
    case 'monthly':
      startDate = new Date(now.getFullYear(), now.getMonth(), 1);
      break;
    case 'once':
      startDate = new Date(0); // 从一开始
      break;
    default:
      return true;
  }
  
  const usageCount = await PointsTransaction.countDocuments({
    userId,
    'ruleInfo.ruleId': ruleId,
    createdAt: { $gte: startDate },
    status: 'completed'
  });
  
  return usageCount < frequency.limitCount;
};

// 计算积分
pointsRuleSchema.methods.calculatePoints = function(context) {
  const { orderAmount = 0, customValue = 0 } = context;
  const config = this.pointsConfig;
  let points = 0;
  
  switch (config.calculationType) {
    case 'fixed':
      points = config.fixedAmount || 0;
      break;
      
    case 'percentage':
      points = Math.floor((orderAmount * (config.percentage || 0)) / 100);
      break;
      
    case 'tiered':
      for (const tier of config.tiers || []) {
        if (orderAmount >= tier.minAmount && 
            (!tier.maxAmount || orderAmount <= tier.maxAmount)) {
          points = tier.points * (tier.multiplier || 1);
          break;
        }
      }
      break;
      
    case 'formula':
      try {
        // 简单的公式计算支持
        const formula = config.formula
          .replace(/orderAmount/g, orderAmount)
          .replace(/customValue/g, customValue);
        points = Math.floor(eval(formula));
      } catch (error) {
        console.error('积分公式计算错误:', error);
        points = 0;
      }
      break;
  }
  
  // 应用倍率
  points = Math.floor(points * (config.multiplier || 1));
  
  // 应用最小最大限制
  if (config.minPoints !== undefined) {
    points = Math.max(points, config.minPoints);
  }
  if (config.maxPoints !== undefined) {
    points = Math.min(points, config.maxPoints);
  }
  
  return points;
};

// 记录使用统计
pointsRuleSchema.methods.recordUsage = async function(pointsIssued) {
  this.usageStats.totalUsages += 1;
  this.usageStats.totalPointsIssued += pointsIssued;
  this.usageStats.lastUsedAt = new Date();
  this.usageStats.avgPointsPerUsage = this.usageStats.totalPointsIssued / this.usageStats.totalUsages;
  
  return await this.save();
};

// 获取规则使用报告
pointsRuleSchema.statics.getUsageReport = async function(options = {}) {
  const { startDate, endDate, ruleType, storeId } = options;
  
  const matchConditions = {};
  
  if (startDate || endDate) {
    matchConditions.createdAt = {};
    if (startDate) matchConditions.createdAt.$gte = new Date(startDate);
    if (endDate) matchConditions.createdAt.$lte = new Date(endDate);
  }
  
  if (ruleType) {
    matchConditions.type = ruleType;
  }
  
  const PointsTransaction = mongoose.model('PointsTransaction');
  
  const report = await PointsTransaction.aggregate([
    {
      $match: {
        'ruleInfo.ruleId': { $exists: true },
        status: 'completed',
        ...matchConditions
      }
    },
    {
      $lookup: {
        from: 'points_rules',
        localField: 'ruleInfo.ruleId',
        foreignField: '_id',
        as: 'rule'
      }
    },
    {
      $unwind: '$rule'
    },
    {
      $group: {
        _id: '$ruleInfo.ruleId',
        ruleName: { $first: '$rule.name' },
        ruleType: { $first: '$rule.type' },
        totalUsages: { $sum: 1 },
        totalPoints: { $sum: '$amount' },
        avgPoints: { $avg: '$amount' },
        uniqueUsers: { $addToSet: '$userId' }
      }
    },
    {
      $addFields: {
        uniqueUserCount: { $size: '$uniqueUsers' }
      }
    },
    {
      $sort: { totalUsages: -1 }
    }
  ]);
  
  return report;
};

// 验证规则配置
pointsRuleSchema.pre('save', function(next) {
  // 验证积分配置
  const config = this.pointsConfig;
  
  if (config.calculationType === 'fixed' && !config.fixedAmount) {
    return next(new Error('固定积分模式必须设置积分数量'));
  }
  
  if (config.calculationType === 'percentage' && !config.percentage) {
    return next(new Error('百分比模式必须设置百分比'));
  }
  
  if (config.calculationType === 'tiered' && (!config.tiers || config.tiers.length === 0)) {
    return next(new Error('分层模式必须设置分层配置'));
  }
  
  if (config.calculationType === 'formula' && !config.formula) {
    return next(new Error('公式模式必须设置计算公式'));
  }
  
  next();
});

module.exports = mongoose.model('PointsRule', pointsRuleSchema);