const mongoose = require('mongoose');
const Schema = mongoose.Schema;
const ModelFactory = require('../modelFactory');

// 导入需要的模型
const Order = require('../orderModel');
const Dish = require('./dishModel');
const AiRecommendation = require('./aiRecommendationModel');

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
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'last_updated' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 索引
merchantStatsSchema.index({ merchant_id: 1, period_type: 1, start_date: 1 });
merchantStatsSchema.index({ last_updated: 1 });

// 添加复合索引以加速按日期检索
merchantStatsSchema.index({ start_date: -1, period_type: 1 });
merchantStatsSchema.index({ end_date: -1, period_type: 1 });

// 添加虚拟字段
merchantStatsSchema.virtual('period_label').get(function() {
  // 根据周期类型生成人类可读的标签
  const start = new Date(this.start_date);
  const end = new Date(this.end_date);
  
  if (this.period_type === 'daily') {
    return start.toISOString().split('T')[0];
  } else if (this.period_type === 'weekly') {
    return `${start.toISOString().split('T')[0]} 至 ${end.toISOString().split('T')[0]}`;
  } else if (this.period_type === 'monthly') {
    return `${start.getFullYear()}年${start.getMonth() + 1}月`;
  }
  
  return 'Unknown period';
});

merchantStatsSchema.virtual('days_count').get(function() {
  // 计算统计周期包含多少天
  const start = new Date(this.start_date);
  const end = new Date(this.end_date);
  const diffTime = Math.abs(end - start);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1; // +1 包含开始和结束当天
});

merchantStatsSchema.virtual('sale_growth_rate').get(function() {
  // 如果有上一期数据，可以计算环比增长率
  if (this._previousPeriodStats && this._previousPeriodStats.sales && 
      this._previousPeriodStats.sales.total_revenue > 0) {
    const currentRevenue = this.sales.total_revenue;
    const previousRevenue = this._previousPeriodStats.sales.total_revenue;
    return ((currentRevenue - previousRevenue) / previousRevenue) * 100;
  }
  return null;
});

merchantStatsSchema.virtual('conversion_rate').get(function() {
  // AI推荐转化率
  if (this.nutrition_stats && 
      this.nutrition_stats.ai_recommendation_conversions && 
      this.nutrition_stats.ai_recommendation_conversions.recommended_count > 0) {
    return (this.nutrition_stats.ai_recommendation_conversions.followed_count / 
            this.nutrition_stats.ai_recommendation_conversions.recommended_count) * 100;
  }
  return 0;
});

// 保存前设置唯一键
merchantStatsSchema.pre('save', function(next) {
  this.key = `${this.merchant_id}_${this.period_type}_${this.start_date.toISOString().split('T')[0]}`;
  
  // 如果是新记录，确保所有数值字段有合法默认值
  if (this.isNew) {
    // 确保销售数据有默认值
    if (!this.sales) {
      this.sales = {
        order_count: 0,
        total_revenue: 0,
        avg_order_value: 0,
        payment_methods: {
          credit_card: 0,
          debit_card: 0,
          cash: 0,
          mobile_payment: 0
        }
      };
    }
    
    // 确保菜品统计有默认值
    if (!this.dish_stats) {
      this.dish_stats = {
        top_dishes: [],
        category_sales: []
      };
    }
    
    // 确保用户统计有默认值
    if (!this.customer_stats) {
      this.customer_stats = {
        new_customers: 0,
        returning_customers: 0,
        avg_rating: 0
      };
    }
    
    // 确保营养统计有默认值
    if (!this.nutrition_stats) {
      this.nutrition_stats = {
        ai_recommendation_conversions: {
          recommended_count: 0,
          followed_count: 0,
          conversion_rate: 0
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
 * 获取或创建指定周期的统计记录
 * @param {ObjectId} merchantId 商家ID
 * @param {String} periodType 周期类型 ('daily', 'weekly', 'monthly')
 * @param {Date} date 日期（将自动计算对应周期的开始和结束日期）
 * @returns {Promise<Object>} 统计记录
 */
merchantStatsSchema.statics.getOrCreatePeriodStats = async function(merchantId, periodType, date) {
  const { startDate, endDate } = this.getPeriodDateRange(periodType, date);
  
  // 尝试查找已有记录
  let stats = await this.findOne({
    merchant_id: merchantId,
    period_type: periodType,
    start_date: startDate
  });
  
  // 如果不存在则创建新记录
  if (!stats) {
    stats = new this({
      merchant_id: merchantId,
      period_type: periodType,
      start_date: startDate,
      end_date: endDate
    });
    
    // 计算并填充统计数据
    const calculatedStats = await this.calculateStats(merchantId, periodType, startDate, endDate);
    
    // 合并计算的数据到新记录
    if (calculatedStats) {
      if (calculatedStats.sales) stats.sales = calculatedStats.sales;
      if (calculatedStats.dish_stats) stats.dish_stats = calculatedStats.dish_stats;
      if (calculatedStats.customer_stats) stats.customer_stats = calculatedStats.customer_stats;
      if (calculatedStats.nutrition_stats) stats.nutrition_stats = calculatedStats.nutrition_stats;
    }
    
    await stats.save();
  }
  
  return stats;
};

/**
 * 计算指定周期的日期范围
 * @param {String} periodType 周期类型 ('daily', 'weekly', 'monthly')
 * @param {Date} date 参考日期
 * @returns {Object} 包含开始日期和结束日期的对象
 */
merchantStatsSchema.statics.getPeriodDateRange = function(periodType, date) {
  const refDate = new Date(date);
  let startDate, endDate;
  
  if (periodType === 'daily') {
    // 日期范围为当天的0点到23:59:59
    startDate = new Date(refDate);
    startDate.setHours(0, 0, 0, 0);
    
    endDate = new Date(refDate);
    endDate.setHours(23, 59, 59, 999);
  } else if (periodType === 'weekly') {
    // 获取本周的周一和周日
    const day = refDate.getDay();
    const diff = refDate.getDate() - day + (day === 0 ? -6 : 1); // 将周日调整为-6，使周一为第一天
    
    startDate = new Date(refDate);
    startDate.setDate(diff);
    startDate.setHours(0, 0, 0, 0);
    
    endDate = new Date(startDate);
    endDate.setDate(startDate.getDate() + 6);
    endDate.setHours(23, 59, 59, 999);
  } else if (periodType === 'monthly') {
    // 获取本月第一天和最后一天
    startDate = new Date(refDate.getFullYear(), refDate.getMonth(), 1);
    startDate.setHours(0, 0, 0, 0);
    
    endDate = new Date(refDate.getFullYear(), refDate.getMonth() + 1, 0);
    endDate.setHours(23, 59, 59, 999);
  } else {
    throw new Error('不支持的周期类型: ' + periodType);
  }
  
  return { startDate, endDate };
};

/**
 * 更新统计数据（基于新的交易/订单）
 * @param {ObjectId} merchantId 商家ID
 * @param {Object} order 订单数据
 * @returns {Promise<void>}
 */
merchantStatsSchema.statics.updateStatsFromOrder = async function(merchantId, order) {
  // 获取订单创建日期
  const orderDate = order.created_at ? new Date(order.created_at) : new Date();
  
  // 只处理已完成或已交付的订单
  if (!['completed', 'delivered'].includes(order.status)) {
    return;
  }
  
  // 更新所有周期的统计
  const updatePromises = ['daily', 'weekly', 'monthly'].map(async (periodType) => {
    try {
      // 获取或创建对应周期的统计记录
      const stats = await this.getOrCreatePeriodStats(merchantId, periodType, orderDate);
      
      // 更新销售数据
      stats.sales.order_count += 1;
      stats.sales.total_revenue += order.total_amount || 0;
      
      // 更新平均订单金额
      if (stats.sales.order_count > 0) {
        stats.sales.avg_order_value = stats.sales.total_revenue / stats.sales.order_count;
      }
      
      // 更新支付方式
      if (order.payment_method && stats.sales.payment_methods[order.payment_method] !== undefined) {
        stats.sales.payment_methods[order.payment_method] += 1;
      }
      
      // 更新菜品销售数据
      if (order.items && Array.isArray(order.items)) {
        for (const item of order.items) {
          // 更新热门菜品
          const existing = stats.dish_stats.top_dishes.find(
            d => d.dish_id && d.dish_id.toString() === item.dish_id.toString()
          );
          
          if (existing) {
            existing.quantity += item.quantity || 1;
            existing.revenue += (item.price * item.quantity) || 0;
          } else {
            stats.dish_stats.top_dishes.push({
              dish_id: item.dish_id,
              dish_name: item.dish_name,
              quantity: item.quantity || 1,
              revenue: (item.price * item.quantity) || 0
            });
          }
          
          // 限制仅保留前10个热门菜品
          if (stats.dish_stats.top_dishes.length > 10) {
            stats.dish_stats.top_dishes.sort((a, b) => b.revenue - a.revenue);
            stats.dish_stats.top_dishes = stats.dish_stats.top_dishes.slice(0, 10);
          }
        }
      }
      
      // 更新AI推荐转化率
      if (order.ai_recommendation_id) {
        stats.nutrition_stats.ai_recommendation_conversions.followed_count += 1;
        
        // 重新计算转化率
        if (stats.nutrition_stats.ai_recommendation_conversions.recommended_count > 0) {
          stats.nutrition_stats.ai_recommendation_conversions.conversion_rate = 
            (stats.nutrition_stats.ai_recommendation_conversions.followed_count / 
             stats.nutrition_stats.ai_recommendation_conversions.recommended_count) * 100;
        }
      }
      
      // 保存更新后的统计
      await stats.save();
    } catch (error) {
      console.error(`更新${periodType}统计失败:`, error);
    }
  });
  
  await Promise.all(updatePromises);
};

/**
 * 获取商家增长趋势数据
 * @param {ObjectId} merchantId 商家ID
 * @param {String} periodType 周期类型 ('daily', 'weekly', 'monthly')
 * @param {Number} limit 获取的周期数量
 * @returns {Promise<Array>} 趋势数据
 */
merchantStatsSchema.statics.getGrowthTrend = async function(merchantId, periodType = 'daily', limit = 30) {
  // 查询最近的统计记录
  const stats = await this.find({
    merchant_id: merchantId,
    period_type: periodType
  })
  .sort({ start_date: -1 })
  .limit(limit);
  
  // 反转以按时间升序
  stats.reverse();
  
  // 计算环比增长率
  for (let i = 1; i < stats.length; i++) {
    const current = stats[i];
    const previous = stats[i - 1];
    
    // 存储前一期数据以计算虚拟字段
    current._previousPeriodStats = previous;
    
    // 计算环比增长
    if (previous.sales && previous.sales.total_revenue > 0) {
      const growth = ((current.sales.total_revenue - previous.sales.total_revenue) / 
                    previous.sales.total_revenue) * 100;
      
      // 添加到结果中
      current.growth = {
        revenue_growth: growth,
        order_count_growth: previous.sales.order_count > 0 ? 
          ((current.sales.order_count - previous.sales.order_count) / 
           previous.sales.order_count) * 100 : 0
      };
    }
  }
  
  return stats;
};

/**
 * 汇总多个商家的统计数据
 * @param {Array} merchantIds 商家ID数组
 * @param {String} periodType 周期类型
 * @param {Date} startDate 开始日期
 * @param {Date} endDate 结束日期
 * @returns {Promise<Object>} 汇总数据
 */
merchantStatsSchema.statics.getAggregatedStats = async function(merchantIds, periodType, startDate, endDate) {
  const query = {
    merchant_id: { $in: merchantIds },
    period_type: periodType
  };
  
  if (startDate) {
    query.start_date = { $gte: startDate };
  }
  
  if (endDate) {
    query.end_date = { $lte: endDate };
  }
  
  const stats = await this.find(query);
  
  // 初始化汇总结果
  const aggregated = {
    total_merchants: merchantIds.length,
    period_type: periodType,
    start_date: startDate,
    end_date: endDate,
    sales: {
      order_count: 0,
      total_revenue: 0,
      avg_order_value: 0,
      payment_methods: {
        credit_card: 0,
        debit_card: 0,
        cash: 0,
        mobile_payment: 0
      }
    },
    customer_stats: {
      new_customers: 0,
      returning_customers: 0
    },
    nutrition_stats: {
      ai_recommendation_conversions: {
        recommended_count: 0,
        followed_count: 0,
        conversion_rate: 0
      }
    }
  };
  
  // 汇总数据
  for (const stat of stats) {
    // 汇总销售数据
    aggregated.sales.order_count += stat.sales.order_count || 0;
    aggregated.sales.total_revenue += stat.sales.total_revenue || 0;
    
    // 汇总支付方式
    if (stat.sales.payment_methods) {
      Object.keys(stat.sales.payment_methods).forEach(method => {
        aggregated.sales.payment_methods[method] += stat.sales.payment_methods[method] || 0;
      });
    }
    
    // 汇总客户统计
    aggregated.customer_stats.new_customers += stat.customer_stats.new_customers || 0;
    aggregated.customer_stats.returning_customers += stat.customer_stats.returning_customers || 0;
    
    // 汇总营养统计
    if (stat.nutrition_stats && stat.nutrition_stats.ai_recommendation_conversions) {
      aggregated.nutrition_stats.ai_recommendation_conversions.recommended_count += 
        stat.nutrition_stats.ai_recommendation_conversions.recommended_count || 0;
      aggregated.nutrition_stats.ai_recommendation_conversions.followed_count += 
        stat.nutrition_stats.ai_recommendation_conversions.followed_count || 0;
    }
  }
  
  // 计算平均订单金额
  if (aggregated.sales.order_count > 0) {
    aggregated.sales.avg_order_value = aggregated.sales.total_revenue / aggregated.sales.order_count;
  }
  
  // 计算AI推荐转化率
  if (aggregated.nutrition_stats.ai_recommendation_conversions.recommended_count > 0) {
    aggregated.nutrition_stats.ai_recommendation_conversions.conversion_rate = 
      (aggregated.nutrition_stats.ai_recommendation_conversions.followed_count / 
       aggregated.nutrition_stats.ai_recommendation_conversions.recommended_count) * 100;
  }
  
  return aggregated;
};

const MerchantStats = ModelFactory.model('MerchantStats', merchantStatsSchema);

module.exports = MerchantStats; 