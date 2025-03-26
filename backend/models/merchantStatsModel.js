const mongoose = require('mongoose');
const Schema = mongoose.Schema;

// 商家销售统计预聚合模型
const merchantStatsSchema = new Schema({
  // 关联的商家ID
  merchant_id: {
    type: Schema.Types.ObjectId,
    ref: 'Merchant',
    required: true
  },
  // 统计周期类型
  period_type: {
    type: String,
    enum: ['daily', 'weekly', 'monthly'],
    required: true
  },
  // 统计开始日期
  start_date: {
    type: Date,
    required: true
  },
  // 统计结束日期
  end_date: {
    type: Date,
    required: true
  },
  // 唯一标识符 (merchant_id + period_type + start_date)
  key: {
    type: String,
    unique: true
  },
  // 销售统计
  sales: {
    order_count: {
      type: Number,
      default: 0
    },
    total_revenue: {
      type: Number,
      default: 0
    },
    avg_order_value: {
      type: Number,
      default: 0
    },
    // 各支付方式销售额
    payment_methods: {
      credit_card: { type: Number, default: 0 },
      debit_card: { type: Number, default: 0 },
      cash: { type: Number, default: 0 },
      mobile_payment: { type: Number, default: 0 }
    }
  },
  // 菜品统计
  dish_stats: {
    // 热门菜品
    top_dishes: [{
      dish_id: Schema.Types.ObjectId,
      dish_name: String,
      quantity: Number,
      revenue: Number
    }],
    // 各类别销售统计
    category_sales: [{
      category: String,
      quantity: Number,
      revenue: Number
    }]
  },
  // 用户统计
  customer_stats: {
    // 新客户数
    new_customers: {
      type: Number,
      default: 0
    },
    // 回头客数
    returning_customers: {
      type: Number,
      default: 0
    },
    // 平均评分
    avg_rating: {
      type: Number,
      default: 0
    }
  },
  // 营养相关统计
  nutrition_stats: {
    // AI推荐转化率
    ai_recommendation_conversions: {
      recommended_count: { type: Number, default: 0 },
      followed_count: { type: Number, default: 0 },
      conversion_rate: { type: Number, default: 0 }
    }
  },
  // 最后聚合计算时间
  last_updated: {
    type: Date,
    default: Date.now
  }
});

// 索引
merchantStatsSchema.index({ merchant_id: 1, period_type: 1, start_date: 1 });
merchantStatsSchema.index({ last_updated: 1 });

// 保存前设置唯一键
merchantStatsSchema.pre('save', function(next) {
  this.key = `${this.merchant_id}_${this.period_type}_${this.start_date.toISOString().split('T')[0]}`;
  next();
});

/**
 * 计算指定周期的商家统计数据
 * @param {ObjectId} merchantId 商家ID
 * @param {String} periodType 周期类型 ('daily', 'weekly', 'monthly')
 * @param {Date} startDate 开始日期
 * @param {Date} endDate 结束日期
 * @returns {Promise<Object>} 计算的统计数据
 */
merchantStatsSchema.statics.calculateStats = async function(merchantId, periodType, startDate, endDate) {
  const Order = mongoose.model('Order');
  const Dish = mongoose.model('Dish');
  const AiRecommendation = mongoose.model('AiRecommendation');
  
  // 获取销售数据
  const salesData = await Order.aggregate([
    { 
      $match: { 
        merchant_id: mongoose.Types.ObjectId(merchantId),
        created_at: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      } 
    },
    {
      $group: {
        _id: null,
        order_count: { $sum: 1 },
        total_revenue: { $sum: '$total_amount' },
        payment_methods: {
          $push: '$payment_method'
        },
        customer_ids: { $addToSet: '$user_id' }
      }
    },
    {
      $project: {
        _id: 0,
        order_count: 1,
        total_revenue: 1,
        avg_order_value: { $divide: ['$total_revenue', '$order_count'] },
        payment_methods: 1,
        unique_customers: { $size: '$customer_ids' }
      }
    }
  ]);
  
  // 分析支付方式
  const paymentMethods = { credit_card: 0, debit_card: 0, cash: 0, mobile_payment: 0 };
  if (salesData[0]?.payment_methods) {
    salesData[0].payment_methods.forEach(method => {
      if (paymentMethods[method] !== undefined) {
        paymentMethods[method]++;
      }
    });
  }
  
  // 获取菜品统计
  const dishStats = await Order.aggregate([
    { 
      $match: { 
        merchant_id: mongoose.Types.ObjectId(merchantId),
        created_at: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      } 
    },
    { $unwind: '$items' },
    {
      $group: {
        _id: '$items.dish_id',
        dish_name: { $first: '$items.dish_name' },
        quantity: { $sum: '$items.quantity' },
        revenue: { $sum: { $multiply: ['$items.price', '$items.quantity'] } }
      }
    },
    { $sort: { revenue: -1 } },
    { $limit: 10 }
  ]);
  
  // 获取类别销售情况
  const categoryStats = await Order.aggregate([
    { 
      $match: { 
        merchant_id: mongoose.Types.ObjectId(merchantId),
        created_at: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] }
      } 
    },
    { $unwind: '$items' },
    {
      $lookup: {
        from: 'dishes',
        localField: 'items.dish_id',
        foreignField: '_id',
        as: 'dish_details'
      }
    },
    { $unwind: '$dish_details' },
    {
      $group: {
        _id: '$dish_details.category',
        quantity: { $sum: '$items.quantity' },
        revenue: { $sum: { $multiply: ['$items.price', '$items.quantity'] } }
      }
    },
    { $sort: { revenue: -1 } }
  ]);
  
  // 客户统计
  const previousPeriodEnd = new Date(startDate);
  previousPeriodEnd.setDate(previousPeriodEnd.getDate() - 1);
  
  const previousPeriodStart = new Date(previousPeriodEnd);
  if (periodType === 'daily') {
    previousPeriodStart.setDate(previousPeriodStart.getDate() - 1);
  } else if (periodType === 'weekly') {
    previousPeriodStart.setDate(previousPeriodStart.getDate() - 7);
  } else if (periodType === 'monthly') {
    previousPeriodStart.setMonth(previousPeriodStart.getMonth() - 1);
  }
  
  // 获取新客户和回头客数量
  const previousCustomers = await Order.distinct('user_id', {
    merchant_id: mongoose.Types.ObjectId(merchantId),
    created_at: { $gte: previousPeriodStart, $lt: startDate }
  });
  
  const currentCustomers = await Order.distinct('user_id', {
    merchant_id: mongoose.Types.ObjectId(merchantId),
    created_at: { $gte: startDate, $lte: endDate }
  });
  
  // 新客户是当前周期有订单但之前没有的客户
  const newCustomers = currentCustomers.filter(
    cust => !previousCustomers.some(pc => pc.equals(cust))
  );
  
  // 回头客是当前周期有订单且之前也有的客户
  const returningCustomers = currentCustomers.filter(
    cust => previousCustomers.some(pc => pc.equals(cust))
  );
  
  // 获取AI推荐统计
  const recommendationStats = await AiRecommendation.aggregate([
    {
      $match: {
        created_at: { $gte: startDate, $lte: endDate },
        'dishes.merchant_id': mongoose.Types.ObjectId(merchantId)
      }
    },
    {
      $lookup: {
        from: 'orders',
        let: { 
          user_id: '$user_id', 
          rec_dishes: '$dishes.dish_id',
          rec_time: '$created_at'
        },
        pipeline: [
          { 
            $match: { 
              $expr: {
                $and: [
                  { $eq: ['$user_id', '$$user_id'] },
                  { $gte: ['$created_at', '$$rec_time'] },
                  { $lte: ['$created_at', endDate] }
                ]
              }
            } 
          },
          { $unwind: '$items' }
        ],
        as: 'related_orders'
      }
    },
    {
      $project: {
        _id: 1,
        user_id: 1,
        dishes: 1,
        followed: {
          $gt: [
            { 
              $size: {
                $filter: {
                  input: '$related_orders',
                  as: 'order',
                  cond: { 
                    $in: ['$order.items.dish_id', '$dishes.dish_id'] 
                  }
                }
              }
            },
            0
          ]
        }
      }
    },
    {
      $group: {
        _id: null,
        recommended_count: { $sum: 1 },
        followed_count: { 
          $sum: { $cond: ['$followed', 1, 0] }
        }
      }
    },
    {
      $project: {
        _id: 0,
        recommended_count: 1,
        followed_count: 1,
        conversion_rate: { 
          $cond: [
            { $gt: ['$recommended_count', 0] },
            { $divide: ['$followed_count', '$recommended_count'] },
            0
          ]
        }
      }
    }
  ]);
  
  // 获取平均评分
  const ratingStats = await Order.aggregate([
    { 
      $match: { 
        merchant_id: mongoose.Types.ObjectId(merchantId),
        created_at: { $gte: startDate, $lte: endDate },
        status: { $in: ['completed', 'delivered'] },
        rating: { $exists: true, $ne: null }
      } 
    },
    {
      $group: {
        _id: null,
        avg_rating: { $avg: '$rating' }
      }
    }
  ]);
  
  // 汇总所有统计数据
  return {
    merchant_id: merchantId,
    period_type: periodType,
    start_date: startDate,
    end_date: endDate,
    sales: {
      order_count: salesData[0]?.order_count || 0,
      total_revenue: salesData[0]?.total_revenue || 0,
      avg_order_value: salesData[0]?.avg_order_value || 0,
      payment_methods: paymentMethods
    },
    dish_stats: {
      top_dishes: dishStats.map(dish => ({
        dish_id: dish._id,
        dish_name: dish.dish_name,
        quantity: dish.quantity,
        revenue: dish.revenue
      })),
      category_sales: categoryStats.map(cat => ({
        category: cat._id,
        quantity: cat.quantity,
        revenue: cat.revenue
      }))
    },
    customer_stats: {
      new_customers: newCustomers.length,
      returning_customers: returningCustomers.length,
      avg_rating: ratingStats[0]?.avg_rating || 0
    },
    nutrition_stats: {
      ai_recommendation_conversions: recommendationStats[0] || {
        recommended_count: 0,
        followed_count: 0,
        conversion_rate: 0
      }
    },
    last_updated: new Date()
  };
};

/**
 * 更新商家的所有统计数据（日、周、月）
 * @param {ObjectId} merchantId 商家ID
 * @returns {Promise<Object>} 更新结果
 */
merchantStatsSchema.statics.updateAllStats = async function(merchantId) {
  // 计算日期范围
  const now = new Date();
  
  // 日统计 - 过去24小时
  const dailyEnd = new Date(now);
  const dailyStart = new Date(dailyEnd);
  dailyStart.setDate(dailyStart.getDate() - 1);
  
  // 周统计 - 过去7天
  const weeklyEnd = new Date(now);
  const weeklyStart = new Date(weeklyEnd);
  weeklyStart.setDate(weeklyStart.getDate() - 7);
  
  // 月统计 - 过去30天
  const monthlyEnd = new Date(now);
  const monthlyStart = new Date(monthlyEnd);
  monthlyStart.setDate(monthlyStart.getDate() - 30);
  
  // 异步计算各时间段统计数据
  const [dailyStats, weeklyStats, monthlyStats] = await Promise.all([
    this.calculateStats(merchantId, 'daily', dailyStart, dailyEnd),
    this.calculateStats(merchantId, 'weekly', weeklyStart, weeklyEnd),
    this.calculateStats(merchantId, 'monthly', monthlyStart, monthlyEnd)
  ]);
  
  // 更新或创建各时间段统计记录
  const results = await Promise.all([
    this.findOneAndUpdate(
      { merchant_id: merchantId, period_type: 'daily', start_date: dailyStart },
      dailyStats,
      { upsert: true, new: true }
    ),
    this.findOneAndUpdate(
      { merchant_id: merchantId, period_type: 'weekly', start_date: weeklyStart },
      weeklyStats,
      { upsert: true, new: true }
    ),
    this.findOneAndUpdate(
      { merchant_id: merchantId, period_type: 'monthly', start_date: monthlyStart },
      monthlyStats,
      { upsert: true, new: true }
    )
  ]);
  
  return {
    daily: results[0],
    weekly: results[1],
    monthly: results[2]
  };
};

const MerchantStats = mongoose.model('MerchantStats', merchantStatsSchema);

module.exports = MerchantStats; 