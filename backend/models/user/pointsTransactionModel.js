const mongoose = require('mongoose');
const { Schema, ObjectId } = mongoose;

const pointsTransactionSchema = new Schema({
  // 用户ID
  userId: {
    type: ObjectId,
    ref: 'User',
    required: true,
    index: true
  },
  
  // 交易类型
  type: {
    type: String,
    enum: [
      'earn_order',        // 订单获得积分
      'earn_review',       // 评价获得积分
      'earn_referral',     // 推荐获得积分
      'earn_checkin',      // 签到获得积分
      'earn_birthday',     // 生日积分
      'earn_activity',     // 活动获得积分
      'earn_bonus',        // 额外奖励积分
      'spend_order',       // 订单消费积分
      'spend_redeem',      // 兑换奖品消费积分
      'adjust_admin',      // 管理员调整
      'expire_auto',       // 自动过期
      'refund_order'       // 订单退款返还积分
    ],
    required: true,
    index: true
  },
  
  // 积分变动数量（正数为获得，负数为消费）
  amount: {
    type: Number,
    required: true,
    validate: {
      validator: function(v) {
        return v !== 0;
      },
      message: '积分变动数量不能为0'
    }
  },
  
  // 交易前余额
  balanceBefore: {
    type: Number,
    required: true,
    min: 0
  },
  
  // 交易后余额
  balanceAfter: {
    type: Number,
    required: true,
    min: 0
  },
  
  // 关联对象信息
  relatedObject: {
    objectType: {
      type: String,
      enum: ['order', 'review', 'referral', 'activity', 'redemption', 'admin_action'],
      index: true
    },
    objectId: {
      type: ObjectId,
      index: true
    },
    objectNumber: String, // 订单号、活动编号等
    objectTitle: String   // 对象标题或描述
  },
  
  // 积分规则信息
  ruleInfo: {
    ruleId: { type: ObjectId, ref: 'PointsRule' },
    ruleName: String,
    ruleType: String,
    multiplier: { type: Number, default: 1 }, // 倍率
    baseAmount: Number // 基础积分
  },
  
  // 积分有效期（获得积分时记录）
  expiresAt: {
    type: Date,
    index: true
  },
  
  // 交易状态
  status: {
    type: String,
    enum: ['pending', 'completed', 'cancelled', 'expired'],
    default: 'completed',
    index: true
  },
  
  // 交易描述
  description: {
    type: String,
    required: true,
    maxlength: 200
  },
  
  // 操作员信息（管理员操作时记录）
  operator: {
    operatorId: { type: ObjectId, ref: 'User' },
    operatorName: String,
    operatorRole: String,
    reason: String // 操作原因
  },
  
  // 门店信息（如果与特定门店相关）
  storeInfo: {
    storeId: { type: ObjectId, ref: 'Store' },
    storeName: String,
    storeCode: String
  },
  
  // 设备和位置信息
  deviceInfo: {
    deviceId: String,
    deviceType: String,
    ipAddress: String,
    location: {
      latitude: Number,
      longitude: Number,
      address: String
    }
  },
  
  // 批次信息（批量操作时使用）
  batchId: String,
  
  // 是否已过期
  isExpired: {
    type: Boolean,
    default: false,
    index: true
  },
  
  // 过期处理时间
  expiredAt: Date,
  
  // 交易标签
  tags: [String]
}, {
  timestamps: true,
  collection: 'points_transactions'
});

// 复合索引优化
pointsTransactionSchema.index({ userId: 1, createdAt: -1 });
pointsTransactionSchema.index({ userId: 1, type: 1, createdAt: -1 });
pointsTransactionSchema.index({ userId: 1, status: 1, createdAt: -1 });
pointsTransactionSchema.index({ 'relatedObject.objectType': 1, 'relatedObject.objectId': 1 });
pointsTransactionSchema.index({ expiresAt: 1 }, { sparse: true });
pointsTransactionSchema.index({ batchId: 1 }, { sparse: true });

// 创建积分交易记录
pointsTransactionSchema.statics.createTransaction = async function(transactionData) {
  const { userId, type, amount, description } = transactionData;
  
  // 获取用户当前积分余额
  const User = mongoose.model('User');
  const user = await User.findById(userId);
  if (!user) {
    throw new Error('用户不存在');
  }
  
  const balanceBefore = user.points || 0;
  const balanceAfter = Math.max(0, balanceBefore + amount);
  
  // 检查积分是否足够（消费积分时）
  if (amount < 0 && balanceAfter > balanceBefore) {
    throw new Error('积分余额不足');
  }
  
  // 创建交易记录
  const transaction = new this({
    userId,
    type,
    amount,
    balanceBefore,
    balanceAfter,
    description,
    ...transactionData
  });
  
  // 设置积分有效期（获得积分时）
  if (amount > 0 && transactionData.expiresAt) {
    transaction.expiresAt = transactionData.expiresAt;
  }
  
  // 保存交易记录
  await transaction.save();
  
  // 更新用户积分余额
  await User.findByIdAndUpdate(userId, { 
    points: balanceAfter,
    lastPointsUpdate: new Date()
  });
  
  return transaction;
};

// 批量创建积分交易
pointsTransactionSchema.statics.createBatchTransactions = async function(transactions, batchId) {
  const User = mongoose.model('User');
  const results = [];
  
  for (const transactionData of transactions) {
    try {
      const transaction = await this.createTransaction({
        ...transactionData,
        batchId
      });
      results.push({ success: true, transaction });
    } catch (error) {
      results.push({ 
        success: false, 
        error: error.message, 
        userId: transactionData.userId 
      });
    }
  }
  
  return results;
};

// 获取用户积分统计
pointsTransactionSchema.statics.getUserPointsStats = async function(userId, options = {}) {
  const { startDate, endDate, type } = options;
  
  const matchConditions = { userId: new mongoose.Types.ObjectId(userId) };
  
  if (startDate || endDate) {
    matchConditions.createdAt = {};
    if (startDate) matchConditions.createdAt.$gte = new Date(startDate);
    if (endDate) matchConditions.createdAt.$lte = new Date(endDate);
  }
  
  if (type) {
    matchConditions.type = type;
  }
  
  const stats = await this.aggregate([
    { $match: matchConditions },
    {
      $group: {
        _id: {
          type: '$type',
          year: { $year: '$createdAt' },
          month: { $month: '$createdAt' }
        },
        totalAmount: { $sum: '$amount' },
        count: { $sum: 1 },
        avgAmount: { $avg: '$amount' }
      }
    },
    {
      $group: {
        _id: '$_id.type',
        totalAmount: { $sum: '$totalAmount' },
        count: { $sum: '$count' },
        avgAmount: { $avg: '$avgAmount' },
        monthlyData: {
          $push: {
            year: '$_id.year',
            month: '$_id.month',
            amount: '$totalAmount',
            count: '$count'
          }
        }
      }
    }
  ]);
  
  return stats;
};

// 处理过期积分
pointsTransactionSchema.statics.processExpiredPoints = async function() {
  const expiredTransactions = await this.find({
    expiresAt: { $lte: new Date() },
    status: 'completed',
    amount: { $gt: 0 }, // 只处理获得积分的记录
    isExpired: false
  });
  
  const User = mongoose.model('User');
  const expiredResults = [];
  
  for (const transaction of expiredTransactions) {
    try {
      // 创建过期扣除记录
      const expireTransaction = await this.createTransaction({
        userId: transaction.userId,
        type: 'expire_auto',
        amount: -transaction.amount,
        description: `积分过期自动扣除 (原交易: ${transaction.description})`,
        relatedObject: {
          objectType: 'admin_action',
          objectId: transaction._id,
          objectTitle: '积分过期处理'
        }
      });
      
      // 标记原交易为已过期
      transaction.isExpired = true;
      transaction.expiredAt = new Date();
      await transaction.save();
      
      expiredResults.push({
        userId: transaction.userId,
        expiredAmount: transaction.amount,
        originalTransaction: transaction._id,
        expireTransaction: expireTransaction._id
      });
      
    } catch (error) {
      console.error('处理过期积分失败:', error);
    }
  }
  
  return expiredResults;
};

// 获取积分变动趋势
pointsTransactionSchema.statics.getPointsTrend = async function(userId, days = 30) {
  const startDate = new Date();
  startDate.setDate(startDate.getDate() - days);
  
  const trend = await this.aggregate([
    {
      $match: {
        userId: new mongoose.Types.ObjectId(userId),
        createdAt: { $gte: startDate },
        status: 'completed'
      }
    },
    {
      $group: {
        _id: {
          year: { $year: '$createdAt' },
          month: { $month: '$createdAt' },
          day: { $dayOfMonth: '$createdAt' }
        },
        earned: {
          $sum: {
            $cond: [{ $gt: ['$amount', 0] }, '$amount', 0]
          }
        },
        spent: {
          $sum: {
            $cond: [{ $lt: ['$amount', 0] }, { $abs: '$amount' }, 0]
          }
        },
        transactions: { $sum: 1 }
      }
    },
    {
      $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 }
    }
  ]);
  
  return trend;
};

// 验证交易数据
pointsTransactionSchema.pre('save', function(next) {
  // 验证余额计算
  if (this.balanceAfter !== this.balanceBefore + this.amount) {
    return next(new Error('积分余额计算错误'));
  }
  
  // 验证积分余额不能为负数
  if (this.balanceAfter < 0) {
    return next(new Error('积分余额不能为负数'));
  }
  
  next();
});

// 自动设置交易描述
pointsTransactionSchema.pre('save', function(next) {
  if (!this.description && this.type && this.amount) {
    const actionMap = {
      'earn_order': '订单完成获得积分',
      'earn_review': '评价获得积分',
      'earn_referral': '推荐好友获得积分',
      'earn_checkin': '签到获得积分',
      'spend_order': '订单消费积分',
      'spend_redeem': '积分兑换'
    };
    
    this.description = actionMap[this.type] || '积分变动';
  }
  
  next();
});

module.exports = mongoose.model('PointsTransaction', pointsTransactionSchema);