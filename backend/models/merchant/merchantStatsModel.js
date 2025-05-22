const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ModelFactory = require('../modelFactory');

// 导入需要的模型
const Order = require('../order/orderModel');
const Dish = require('./productDishModel');
const AiRecommendation = require('../nutrition/aiRecommendationModel');

// 商家销售统计预聚合模型
const merchantStatsSchema = new Schema({
  // 商家 ID
  merchantId: {
    type: Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true,
    description: '商家 ID',
    sensitivityLevel: 2
  },
  // 统计周期类型（日/周/月）
  periodType: {
    type: String,
    enum: ['daily', 'weekly', 'monthly'],
    required: true,
    description: '统计周期类型（日/周/月）'
  },
  // 统计开始日期
  startDate: {
    type: Date,
    required: true,
    description: '统计开始日期'
  },
  // 统计结束日期
  endDate: {
    type: Date,
    required: true,
    description: '统计结束日期'
  },
  // 周期唯一标识符
  key: {
    type: String,
    unique: true,
    description: '周期唯一标识符'
  },
  // 销售统计
  sales: {
    orderCount: {
      type: Number,
      default: 0,
      description: '订单数量'
    },
    totalRevenue: {
      type: Number,
      default: 0,
      description: '总收入'
    },
    avgOrderValue: {
      type: Number,
      default: 0,
      description: '平均订单金额'
    },
    // 支付方式统计
    paymentMethods: {
      creditCard: { type: Number, default: 0, description: '信用卡支付订单数', sensitivityLevel: 3 },
      debitCard: { type: Number, default: 0, description: '借记卡支付订单数', sensitivityLevel: 3 },
      cash: { type: Number, default: 0, description: '现金支付订单数', sensitivityLevel: 3 },
      mobilePayment: { type: Number, default: 0, description: '移动支付订单数', sensitivityLevel: 3 }
    }
  },
  // 菜品统计
  dishStats: {
    // 热门菜品信息
    topDishes: [{
      dishId: { type: Schema.Types.ObjectId, description: '菜品ID', sensitivityLevel: 2 },
      dishName: { type: String, description: '菜品名称', sensitivityLevel: 2 },
      quantity: { type: Number, description: '售出数量' },
      revenue: { type: Number, description: '销售额' }
    }],
    // 类别销售统计
    categorySales: [{
      category: { type: String, description: '菜品类别' },
      quantity: { type: Number, description: '售出数量' },
      revenue: { type: Number, description: '销售额' }
    }]
  },
  // 用户统计
  customerStats: {
    newCustomers: {
      type: Number,
      default: 0,
      description: '新客户数量'
    },
    returningCustomers: {
      type: Number,
      default: 0,
      description: '回头客数量'
    },
    avgRating: {
      type: Number,
      default: 0,
      description: '平均评分',
      sensitivityLevel: 3
    }
  },
  // 营养相关统计
  nutritionStats: {
    // AI推荐转化数据
    aiRecommendationConversions: {
      recommendedCount: { type: Number, default: 0, description: 'AI推荐次数', sensitivityLevel: 3 },
      followedCount: { type: Number, default: 0, description: 'AI推荐被采纳次数', sensitivityLevel: 3 },
      conversionRate: { type: Number, default: 0, description: 'AI推荐转化率（%）', sensitivityLevel: 3 }
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
merchantStatsSchema.index({ merchantId: 1, periodType: 1, startDate: 1 });

// 添加复合索引以加速按日期检索
merchantStatsSchema.index({ startDate: -1, periodType: 1 });
merchantStatsSchema.index({ endDate: -1, periodType: 1 });

// 添加虚拟字段
merchantStatsSchema.virtual('periodLabel').get(function() {
  // 根据周期类型生成人类可读的标签
  const start = new Date(this.startDate);
  const end = new Date(this.endDate);
  if (this.periodType === 'daily') {
    return start.toISOString().split('T')[0];
  } else if (this.periodType === 'weekly') {
    return `${start.toISOString().split('T')[0]} 至 ${end.toISOString().split('T')[0]}`;
  } else if (this.periodType === 'monthly') {
    return `${start.getFullYear()}年${start.getMonth() + 1}月`;
  }
  return 'Unknown period';
});

merchantStatsSchema.virtual('daysCount').get(function() {
  // 计算统计周期包含多少天
  const start = new Date(this.startDate);
  const end = new Date(this.endDate);
  const diffTime = Math.abs(end - start);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 包含开始和结束当天
});

merchantStatsSchema.virtual('saleGrowthRate').get(function() {
  // 如果有上一期数据，可以计算环比增长率
  if (this._previousPeriodStats && this._previousPeriodStats.sales &&
      this._previousPeriodStats.sales.totalRevenue > 0) {
    const currentRevenue = this.sales.totalRevenue;
    const previousRevenue = this._previousPeriodStats.sales.totalRevenue;
    return ((currentRevenue - previousRevenue) / previousRevenue) * 100;
  }
  return null;
});

merchantStatsSchema.virtual('conversionRate').get(function() {
  // AI推荐转化率
  if (this.nutritionStats &&
      this.nutritionStats.aiRecommendationConversions &&
      this.nutritionStats.aiRecommendationConversions.recommendedCount > 0) {
    return (this.nutritionStats.aiRecommendationConversions.followedCount /
            this.nutritionStats.aiRecommendationConversions.recommendedCount) * 100;
  }
  return 0;
});

// 保存前设置唯一键
merchantStatsSchema.pre('save', function(next) {
  this.key = `${this.merchantId}_${this.periodType}_${this.startDate.toISOString().split('T')[0]}`;
  // 如果是新记录，确保所有数值字段有合法默认值
  if (this.isNew) {
    // 确保销售数据有默认值
    if (!this.sales) {
      this.sales = {
        orderCount: 0,
        totalRevenue: 0,
        avgOrderValue: 0,
        paymentMethods: {
          creditCard: 0,
          debitCard: 0,
          cash: 0,
          mobilePayment: 0
        }
      };
    }
    // 确保菜品统计有默认值
    if (!this.dishStats) {
      this.dishStats = {
        topDishes: [],
        categorySales: []
      };
    }
    // 确保用户统计有默认值
    if (!this.customerStats) {
      this.customerStats = {
        newCustomers: 0,
        returningCustomers: 0,
        avgRating: 0
      };
    }
    // 确保营养统计有默认值
    if (!this.nutritionStats) {
      this.nutritionStats = {
        aiRecommendationConversions: {
          recommendedCount: 0,
          followedCount: 0,
          conversionRate: 0
        }
      };
    }
  }
  next();
});

/**
 * 计算并生成统计数据
 * @param {ObjectId} merchantId 商家ID
 * @param {String} periodType 周期类型 ('daily', 'weekly', 'monthly')
 * @param {Date} startDate 开始日期
 * @param {Date} endDate 结束日期
 * @returns {Promise<Object>} 计算的统计数据
 */
merchantStatsSchema.statics.calculateStats = async function(merchantId, periodType, startDate, endDate) {
  // 使用导入的模型
  // 获取销售数据
  const salesData = await Order.aggregate([
    {
      $match: {
        merchantId: mongoose.Types.ObjectId(merchantId),
        createdAt: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      }
    },
    {
      $group: {
        _id: null,
        orderCount: { $sum: 1 },
        totalRevenue: { $sum: '$priceDetails.total' },
        creditCardCount: {
          $sum: {
            $cond: [{ $eq: ['$payment.method', 'creditCard'] }, 1, 0]
          }
        },
        debitCardCount: {
          $sum: {
            $cond: [{ $eq: ['$payment.method', 'debitCard'] }, 1, 0]
          }
        },
        cashCount: {
          $sum: {
            $cond: [{ $eq: ['$payment.method', 'cash'] }, 1, 0]
          }
        },
        mobilePaymentCount: {
          $sum: {
            $cond: [{ $eq: ['$payment.method', 'mobilePayment'] }, 1, 0]
          }
        }
      }
    }
  ]);

  // 计算平均订单金额
  let avgOrderValue = 0;
  if (salesData.length > 0 && salesData[0].orderCount > 0) {
    avgOrderValue = salesData[0].totalRevenue / salesData[0].orderCount;
  }

  // 获取热门菜品
  const topDishesData = await Order.aggregate([
    {
      $match: {
        merchantId: mongoose.Types.ObjectId(merchantId),
        createdAt: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      }
    },
    { $unwind: '$items' },
    {
      $group: {
        _id: '$items.dishId',
        dishName: { $first: '$items.name' },
        quantity: { $sum: '$items.quantity' },
        revenue: { $sum: { $multiply: ['$items.price', '$items.quantity'] } }
      }
    },
    { $sort: { quantity: -1 } },
    { $limit: 10 }
  ]);

  // 获取类别销售数据
  const categorySalesData = await Order.aggregate([
    {
      $match: {
        merchantId: mongoose.Types.ObjectId(merchantId),
        createdAt: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      }
    },
    { $unwind: '$items' },
    {
      $group: {
        _id: '$items.category',
        quantity: { $sum: '$items.quantity' },
        revenue: { $sum: { $multiply: ['$items.price', '$items.quantity'] } }
      }
    },
    { $sort: { revenue: -1 } }
  ]);

  // 获取客户统计
  const customerStatsData = await Order.aggregate([
    {
      $match: {
        merchantId: mongoose.Types.ObjectId(merchantId),
        createdAt: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      }
    },
    {
      $group: {
        _id: '$userId',
        orderCount: { $sum: 1 },
        avgRating: { $avg: '$rating.overall' }
      }
    }
  ]);

  // 获取AI推荐转化数据
  const aiRecommendationData = await AiRecommendation.aggregate([
    {
      $match: {
        merchantId: mongoose.Types.ObjectId(merchantId),
        createdAt: { $gte: startDate, $lte: endDate }
      }
    },
    {
      $group: {
        _id: null,
        recommendedCount: { $sum: 1 },
        followedCount: { $sum: { $cond: [{ $gt: ['$orderId', null] }, 1, 0] } }
      }
    }
  ]);

  // 统计首次购买的用户
  const previousCustomers = await Order.distinct('userId', {
    merchantId: mongoose.Types.ObjectId(merchantId),
    createdAt: { $lt: startDate }
  });

  const currentPeriodCustomers = await Order.distinct('userId', {
    merchantId: mongoose.Types.ObjectId(merchantId),
    createdAt: { $gte: startDate, $lte: endDate }
  });

  // 计算新客户数和回头客数
  const newCustomers = currentPeriodCustomers.filter(customer => 
    !previousCustomers.some(pc => pc.toString() === customer.toString())
  ).length;

  const returningCustomers = currentPeriodCustomers.length - newCustomers;

  // 构建统计对象
  const statsData = {
    merchantId,
    periodType,
    startDate,
    endDate,
    sales: {
      orderCount: salesData.length > 0 ? salesData[0].orderCount : 0,
      totalRevenue: salesData.length > 0 ? salesData[0].totalRevenue : 0,
      avgOrderValue,
      paymentMethods: {
        creditCard: salesData.length > 0 ? salesData[0].creditCardCount : 0,
        debitCard: salesData.length > 0 ? salesData[0].debitCardCount : 0,
        cash: salesData.length > 0 ? salesData[0].cashCount : 0,
        mobilePayment: salesData.length > 0 ? salesData[0].mobilePaymentCount : 0
      }
    },
    dishStats: {
      topDishes: topDishesData.map(dish => ({
        dishId: dish._id,
        dishName: dish.dishName,
        quantity: dish.quantity,
        revenue: dish.revenue
      })),
      categorySales: categorySalesData.map(category => ({
        category: category._id,
        quantity: category.quantity,
        revenue: category.revenue
      }))
    },
    customerStats: {
      newCustomers,
      returningCustomers,
      avgRating: customerStatsData.length > 0 
        ? (customerStatsData.reduce((sum, customer) => sum + (customer.avgRating || 0), 0) / customerStatsData.length)
        : 0
    },
    nutritionStats: {
      aiRecommendationConversions: {
        recommendedCount: aiRecommendationData.length > 0 ? aiRecommendationData[0].recommendedCount : 0,
        followedCount: aiRecommendationData.length > 0 ? aiRecommendationData[0].followedCount : 0,
        conversionRate: aiRecommendationData.length > 0 && aiRecommendationData[0].recommendedCount > 0
          ? (aiRecommendationData[0].followedCount / aiRecommendationData[0].recommendedCount) * 100
          : 0
      }
    }
  };

  return statsData;
};

// 注册模型
const MerchantStats = require('../modelRegistrar')('MerchantStats', merchantStatsSchema, {
  additionalIndex: [
    { fields: { merchantId: 1, periodType: 1, startDate: 1 } },
    { fields: { startDate: -1, periodType: 1 } },
    { fields: { endDate: -1, periodType: 1 } }
  ]
});

module.exports = MerchantStats; 