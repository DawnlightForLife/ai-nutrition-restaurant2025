const User = require('../../models/user/userModel');
const UserPermission = require('../../models/user/userPermissionModel');
const Order = require('../../models/order/orderModel');
const Store = require('../../models/merchant/storeModel');
const Merchant = require('../../models/merchant/merchantModel');
const responseHelper = require('../../utils/responseHelper');

/**
 * 加盟商统计管理控制器
 * 提供加盟商相关的统计数据和管理功能
 */

/**
 * 获取加盟商统计概览
 */
exports.getMerchantOverview = async (req, res) => {
  try {
    const today = new Date();
    const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
    const startOfLastMonth = new Date(today.getFullYear(), today.getMonth() - 1, 1);
    const endOfLastMonth = new Date(today.getFullYear(), today.getMonth(), 0);

    // 获取总体统计
    const [
      totalMerchants,
      activeMerchants,
      thisMonthNewMerchants,
      lastMonthNewMerchants,
      totalStores,
      activeStores,
      thisMonthOrders,
      lastMonthOrders,
      thisMonthRevenue,
      lastMonthRevenue
    ] = await Promise.all([
      // 总加盟商数
      User.countDocuments({ role: 'merchant' }),
      
      // 活跃加盟商数（本月有订单）
      Order.distinct('merchantId', {
        createdAt: { $gte: startOfMonth },
        status: { $in: ['completed', 'paid'] }
      }).then(ids => ids.length),
      
      // 本月新增加盟商
      User.countDocuments({
        role: 'merchant',
        createdAt: { $gte: startOfMonth }
      }),
      
      // 上月新增加盟商
      User.countDocuments({
        role: 'merchant',
        createdAt: { $gte: startOfLastMonth, $lt: endOfLastMonth }
      }),
      
      // 总门店数
      Store.countDocuments({}),
      
      // 活跃门店数（本月有订单）
      Order.distinct('storeId', {
        createdAt: { $gte: startOfMonth },
        status: { $in: ['completed', 'paid'] }
      }).then(ids => ids.length),
      
      // 本月订单数
      Order.countDocuments({
        createdAt: { $gte: startOfMonth },
        status: { $in: ['completed', 'paid'] }
      }),
      
      // 上月订单数
      Order.countDocuments({
        createdAt: { $gte: startOfLastMonth, $lt: endOfLastMonth },
        status: { $in: ['completed', 'paid'] }
      }),
      
      // 本月营收
      Order.aggregate([
        {
          $match: {
            createdAt: { $gte: startOfMonth },
            status: { $in: ['completed', 'paid'] }
          }
        },
        {
          $group: {
            _id: null,
            total: { $sum: '$totalAmount' }
          }
        }
      ]).then(result => result[0]?.total || 0),
      
      // 上月营收
      Order.aggregate([
        {
          $match: {
            createdAt: { $gte: startOfLastMonth, $lt: endOfLastMonth },
            status: { $in: ['completed', 'paid'] }
          }
        },
        {
          $group: {
            _id: null,
            total: { $sum: '$totalAmount' }
          }
        }
      ]).then(result => result[0]?.total || 0)
    ]);

    // 计算增长率
    const merchantGrowthRate = lastMonthNewMerchants > 0 
      ? ((thisMonthNewMerchants - lastMonthNewMerchants) / lastMonthNewMerchants * 100).toFixed(1)
      : (thisMonthNewMerchants > 0 ? 100 : 0);

    const orderGrowthRate = lastMonthOrders > 0 
      ? ((thisMonthOrders - lastMonthOrders) / lastMonthOrders * 100).toFixed(1)
      : (thisMonthOrders > 0 ? 100 : 0);

    const revenueGrowthRate = lastMonthRevenue > 0 
      ? ((thisMonthRevenue - lastMonthRevenue) / lastMonthRevenue * 100).toFixed(1)
      : (thisMonthRevenue > 0 ? 100 : 0);

    const overview = {
      merchants: {
        total: totalMerchants,
        active: activeMerchants,
        newThisMonth: thisMonthNewMerchants,
        growthRate: parseFloat(merchantGrowthRate)
      },
      stores: {
        total: totalStores,
        active: activeStores,
        averagePerMerchant: totalMerchants > 0 ? (totalStores / totalMerchants).toFixed(1) : 0
      },
      orders: {
        thisMonth: thisMonthOrders,
        lastMonth: lastMonthOrders,
        growthRate: parseFloat(orderGrowthRate)
      },
      revenue: {
        thisMonth: thisMonthRevenue,
        lastMonth: lastMonthRevenue,
        growthRate: parseFloat(revenueGrowthRate),
        averageOrderValue: thisMonthOrders > 0 ? (thisMonthRevenue / thisMonthOrders).toFixed(2) : 0
      }
    };

    return responseHelper.success(res, overview, '获取加盟商概览成功');
    
  } catch (error) {
    console.error('[MerchantStatsController] 获取加盟商概览失败:', error);
    return responseHelper.error(res, '获取加盟商概览失败');
  }
};

/**
 * 获取加盟商列表（带统计数据）
 */
exports.getMerchantList = async (req, res) => {
  try {
    const { page = 1, limit = 20, status, search, sortBy = 'createdAt', sortOrder = 'desc' } = req.query;
    
    // 构建查询条件
    const query = { role: 'merchant' };
    
    if (status && status !== 'all') {
      if (status === 'active') {
        // 活跃状态：近30天有订单
        const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
        const activeUserIds = await Order.distinct('merchantId', {
          createdAt: { $gte: thirtyDaysAgo },
          status: { $in: ['completed', 'paid'] }
        });
        query._id = { $in: activeUserIds };
      } else if (status === 'inactive') {
        const thirtyDaysAgo = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
        const activeUserIds = await Order.distinct('merchantId', {
          createdAt: { $gte: thirtyDaysAgo },
          status: { $in: ['completed', 'paid'] }
        });
        query._id = { $nin: activeUserIds };
      }
    }
    
    if (search) {
      query.$or = [
        { nickname: new RegExp(search, 'i') },
        { realName: new RegExp(search, 'i') },
        { phone: new RegExp(search, 'i') }
      ];
    }

    const skip = (page - 1) * limit;
    const sort = {};
    sort[sortBy] = sortOrder === 'desc' ? -1 : 1;

    // 获取加盟商列表
    const merchants = await User.find(query)
      .select('nickname realName phone createdAt lastLogin')
      .sort(sort)
      .skip(skip)
      .limit(parseInt(limit))
      .lean();

    const total = await User.countDocuments(query);

    // 为每个加盟商获取统计数据
    const merchantsWithStats = await Promise.all(
      merchants.map(async (merchant) => {
        const [storeCount, orderCount, totalRevenue, lastOrderDate] = await Promise.all([
          Store.countDocuments({ merchantId: merchant._id }),
          Order.countDocuments({ 
            merchantId: merchant._id,
            status: { $in: ['completed', 'paid'] }
          }),
          Order.aggregate([
            {
              $match: {
                merchantId: merchant._id,
                status: { $in: ['completed', 'paid'] }
              }
            },
            {
              $group: {
                _id: null,
                total: { $sum: '$totalAmount' }
              }
            }
          ]).then(result => result[0]?.total || 0),
          Order.findOne(
            { merchantId: merchant._id },
            { createdAt: 1 },
            { sort: { createdAt: -1 } }
          ).then(order => order?.createdAt || null)
        ]);

        return {
          ...merchant,
          stats: {
            storeCount,
            orderCount,
            totalRevenue,
            lastOrderDate,
            averageOrderValue: orderCount > 0 ? (totalRevenue / orderCount).toFixed(2) : 0
          }
        };
      })
    );

    return responseHelper.success(res, {
      merchants: merchantsWithStats,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        hasMore: skip + merchants.length < total
      }
    }, '获取加盟商列表成功');
    
  } catch (error) {
    console.error('[MerchantStatsController] 获取加盟商列表失败:', error);
    return responseHelper.error(res, '获取加盟商列表失败');
  }
};

/**
 * 获取加盟商详细统计
 */
exports.getMerchantStats = async (req, res) => {
  try {
    const { merchantId } = req.params;
    const { period = '30d' } = req.query;

    // 验证加盟商是否存在
    const merchant = await User.findById(merchantId);
    if (!merchant || merchant.role !== 'merchant') {
      return responseHelper.notFound(res, '加盟商不存在');
    }

    // 计算时间范围
    let startDate;
    const endDate = new Date();
    
    switch (period) {
      case '7d':
        startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
        break;
      case '30d':
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
        break;
      case '90d':
        startDate = new Date(Date.now() - 90 * 24 * 60 * 60 * 1000);
        break;
      case '1y':
        startDate = new Date(Date.now() - 365 * 24 * 60 * 60 * 1000);
        break;
      default:
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    }

    // 获取统计数据
    const [
      orderStats,
      revenueStats,
      storeList,
      orderTrend
    ] = await Promise.all([
      // 订单统计
      Order.aggregate([
        {
          $match: {
            merchantId: merchant._id,
            createdAt: { $gte: startDate, $lte: endDate }
          }
        },
        {
          $group: {
            _id: '$status',
            count: { $sum: 1 },
            revenue: { $sum: '$totalAmount' }
          }
        }
      ]),
      
      // 营收统计
      Order.aggregate([
        {
          $match: {
            merchantId: merchant._id,
            status: { $in: ['completed', 'paid'] },
            createdAt: { $gte: startDate, $lte: endDate }
          }
        },
        {
          $group: {
            _id: {
              year: { $year: '$createdAt' },
              month: { $month: '$createdAt' },
              day: { $dayOfMonth: '$createdAt' }
            },
            revenue: { $sum: '$totalAmount' },
            orderCount: { $sum: 1 }
          }
        },
        {
          $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 }
        }
      ]),
      
      // 门店列表
      Store.find({ merchantId: merchant._id })
        .select('storeName address status createdAt')
        .lean(),
      
      // 订单趋势
      Order.aggregate([
        {
          $match: {
            merchantId: merchant._id,
            createdAt: { $gte: startDate, $lte: endDate }
          }
        },
        {
          $group: {
            _id: {
              year: { $year: '$createdAt' },
              month: { $month: '$createdAt' },
              day: { $dayOfMonth: '$createdAt' }
            },
            totalOrders: { $sum: 1 },
            completedOrders: {
              $sum: {
                $cond: [{ $in: ['$status', ['completed', 'paid']] }, 1, 0]
              }
            }
          }
        },
        {
          $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 }
        }
      ])
    ]);

    // 处理订单状态统计
    const orderSummary = {
      total: 0,
      completed: 0,
      cancelled: 0,
      pending: 0,
      revenue: 0
    };

    orderStats.forEach(stat => {
      orderSummary.total += stat.count;
      if (stat._id === 'completed' || stat._id === 'paid') {
        orderSummary.completed += stat.count;
        orderSummary.revenue += stat.revenue;
      } else if (stat._id === 'cancelled') {
        orderSummary.cancelled += stat.count;
      } else if (stat._id === 'pending') {
        orderSummary.pending += stat.count;
      }
    });

    // 为门店获取统计数据
    const storesWithStats = await Promise.all(
      storeList.map(async (store) => {
        const [orderCount, revenue] = await Promise.all([
          Order.countDocuments({
            storeId: store._id,
            createdAt: { $gte: startDate, $lte: endDate },
            status: { $in: ['completed', 'paid'] }
          }),
          Order.aggregate([
            {
              $match: {
                storeId: store._id,
                createdAt: { $gte: startDate, $lte: endDate },
                status: { $in: ['completed', 'paid'] }
              }
            },
            {
              $group: {
                _id: null,
                total: { $sum: '$totalAmount' }
              }
            }
          ]).then(result => result[0]?.total || 0)
        ]);

        return {
          ...store,
          stats: {
            orderCount,
            revenue,
            averageOrderValue: orderCount > 0 ? (revenue / orderCount).toFixed(2) : 0
          }
        };
      })
    );

    const stats = {
      merchantInfo: {
        id: merchant._id,
        nickname: merchant.nickname,
        realName: merchant.realName,
        phone: merchant.phone,
        createdAt: merchant.createdAt
      },
      period: {
        start: startDate,
        end: endDate,
        label: period
      },
      orderSummary,
      revenueData: revenueStats,
      orderTrend,
      stores: storesWithStats
    };

    return responseHelper.success(res, stats, '获取加盟商统计成功');
    
  } catch (error) {
    console.error('[MerchantStatsController] 获取加盟商统计失败:', error);
    return responseHelper.error(res, '获取加盟商统计失败');
  }
};

/**
 * 获取加盟商排行榜
 */
exports.getMerchantRanking = async (req, res) => {
  try {
    const { type = 'revenue', period = '30d', limit = 10 } = req.query;

    // 计算时间范围
    let startDate;
    switch (period) {
      case '7d':
        startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000);
        break;
      case '30d':
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
        break;
      case '90d':
        startDate = new Date(Date.now() - 90 * 24 * 60 * 60 * 1000);
        break;
      default:
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000);
    }

    let aggregationPipeline;

    if (type === 'revenue') {
      // 营收排行榜
      aggregationPipeline = [
        {
          $match: {
            status: { $in: ['completed', 'paid'] },
            createdAt: { $gte: startDate }
          }
        },
        {
          $group: {
            _id: '$merchantId',
            totalRevenue: { $sum: '$totalAmount' },
            orderCount: { $sum: 1 }
          }
        },
        {
          $sort: { totalRevenue: -1 }
        },
        {
          $limit: parseInt(limit)
        }
      ];
    } else {
      // 订单量排行榜
      aggregationPipeline = [
        {
          $match: {
            status: { $in: ['completed', 'paid'] },
            createdAt: { $gte: startDate }
          }
        },
        {
          $group: {
            _id: '$merchantId',
            orderCount: { $sum: 1 },
            totalRevenue: { $sum: '$totalAmount' }
          }
        },
        {
          $sort: { orderCount: -1 }
        },
        {
          $limit: parseInt(limit)
        }
      ];
    }

    const rankings = await Order.aggregate(aggregationPipeline);

    // 获取加盟商信息
    const rankingWithMerchantInfo = await Promise.all(
      rankings.map(async (ranking, index) => {
        const merchant = await User.findById(ranking._id)
          .select('nickname realName phone')
          .lean();

        return {
          rank: index + 1,
          merchant: merchant || { nickname: '未知加盟商', realName: '', phone: '' },
          orderCount: ranking.orderCount,
          totalRevenue: ranking.totalRevenue,
          averageOrderValue: ranking.orderCount > 0 ? (ranking.totalRevenue / ranking.orderCount).toFixed(2) : 0
        };
      })
    );

    return responseHelper.success(res, {
      rankings: rankingWithMerchantInfo,
      period: {
        start: startDate,
        end: new Date(),
        label: period
      },
      type
    }, '获取加盟商排行榜成功');
    
  } catch (error) {
    console.error('[MerchantStatsController] 获取加盟商排行榜失败:', error);
    return responseHelper.error(res, '获取加盟商排行榜失败');
  }
};