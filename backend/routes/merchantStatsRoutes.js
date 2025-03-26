const express = require('express');
const router = express.Router();
const { MerchantStats } = require('../models');
const cacheService = require('../services/cacheService');
// 这里应该引入认证中间件，此处省略详细实现
// const authMiddleware = require('../middleware/auth');

/**
 * @route GET /api/merchant-stats/:merchant_id
 * @desc 获取指定商家的统计数据
 * @access 私有 - 仅限商家自己和管理员
 */
router.get('/:merchant_id', /* authMiddleware, */ async (req, res) => {
  try {
    const { merchant_id } = req.params;
    const { period_type = 'daily' } = req.query;
    
    // 验证周期类型
    if (!['daily', 'weekly', 'monthly'].includes(period_type)) {
      return res.status(400).json({ 
        success: false, 
        message: '无效的周期类型。允许的值：daily, weekly, monthly' 
      });
    }
    
    // 构建缓存键
    const cacheKey = `merchant_stats:${merchant_id}:${period_type}`;
    
    // 尝试从缓存获取统计数据
    const stats = await cacheService.get(cacheKey, async () => {
      return await MerchantStats.findOne({
        merchant_id,
        period_type
      }).sort({ start_date: -1 });
    }, { ttl: 300 }); // 缓存5分钟
    
    if (!stats) {
      return res.status(404).json({ 
        success: false, 
        message: '未找到商家统计数据' 
      });
    }
    
    res.json({
      success: true,
      data: stats
    });
  } catch (error) {
    console.error('获取商家统计数据时出错:', error);
    res.status(500).json({ 
      success: false, 
      message: '服务器错误，无法获取统计数据' 
    });
  }
});

/**
 * @route GET /api/merchant-stats/:merchant_id/refresh
 * @desc 刷新指定商家的统计数据
 * @access 私有 - 仅限商家自己和管理员
 */
router.get('/:merchant_id/refresh', /* authMiddleware, */ async (req, res) => {
  try {
    const { merchant_id } = req.params;
    
    // 触发统计数据重新计算
    const result = await MerchantStats.updateAllStats(merchant_id);
    
    if (!result) {
      return res.status(500).json({ 
        success: false, 
        message: '更新统计数据失败' 
      });
    }
    
    // 更新成功后清除相关缓存
    await Promise.all([
      cacheService.del(`merchant_stats:${merchant_id}:daily`),
      cacheService.del(`merchant_stats:${merchant_id}:weekly`),
      cacheService.del(`merchant_stats:${merchant_id}:monthly`),
      cacheService.del(`merchant_stats_trend:${merchant_id}:daily`),
      cacheService.del(`merchant_stats_trend:${merchant_id}:weekly`),
      cacheService.del(`merchant_stats_trend:${merchant_id}:monthly`),
      cacheService.del(`merchant_top_items:${merchant_id}:daily`),
      cacheService.del(`merchant_top_items:${merchant_id}:weekly`),
      cacheService.del(`merchant_top_items:${merchant_id}:monthly`)
    ]);
    
    res.json({
      success: true,
      message: '商家统计数据已更新',
      data: {
        daily_stats: result.daily,
        weekly_stats: result.weekly,
        monthly_stats: result.monthly
      }
    });
  } catch (error) {
    console.error('刷新商家统计数据时出错:', error);
    res.status(500).json({ 
      success: false, 
      message: '服务器错误，无法刷新统计数据' 
    });
  }
});

/**
 * @route GET /api/merchant-stats/:merchant_id/trend
 * @desc 获取指定商家的统计数据趋势
 * @access 私有 - 仅限商家自己和管理员
 */
router.get('/:merchant_id/trend', /* authMiddleware, */ async (req, res) => {
  try {
    const { merchant_id } = req.params;
    const { period_type = 'daily', days = 7 } = req.query;
    
    // 验证周期类型和天数
    if (!['daily', 'weekly', 'monthly'].includes(period_type)) {
      return res.status(400).json({ 
        success: false, 
        message: '无效的周期类型。允许的值：daily, weekly, monthly' 
      });
    }
    
    if (isNaN(days) || days < 1 || days > 90) {
      return res.status(400).json({ 
        success: false, 
        message: '无效的天数。允许范围：1-90' 
      });
    }
    
    // 构建缓存键
    const cacheKey = `merchant_stats_trend:${merchant_id}:${period_type}:${days}`;
    
    // 尝试从缓存获取趋势数据
    const trend = await cacheService.get(cacheKey, async () => {
      // 计算日期范围
      const endDate = new Date();
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - parseInt(days));
      
      // 获取日期范围内的统计数据
      const stats = await MerchantStats.find({
        merchant_id,
        period_type,
        start_date: { $gte: startDate, $lte: endDate }
      }).sort({ start_date: 1 });
      
      // 处理响应数据，提取关键指标形成趋势数据
      const result = {
        dates: [],
        sales: [],
        orders: [],
        average_order: [],
        new_customers: [],
        return_rate: []
      };
      
      stats.forEach(stat => {
        const date = stat.start_date.toISOString().split('T')[0];
        result.dates.push(date);
        result.sales.push(stat.sales.total_revenue);
        result.orders.push(stat.sales.order_count);
        result.average_order.push(stat.sales.avg_order_value);
        result.new_customers.push(stat.customer_stats.new_customers);
        
        const totalCustomers = stat.customer_stats.new_customers + stat.customer_stats.returning_customers;
        const returnRate = totalCustomers > 0 
          ? (stat.customer_stats.returning_customers / totalCustomers) * 100 
          : 0;
        
        result.return_rate.push(parseFloat(returnRate.toFixed(2)));
      });
      
      return result;
    }, { ttl: 600 }); // 缓存10分钟
    
    res.json({
      success: true,
      data: trend
    });
  } catch (error) {
    console.error('获取商家统计趋势时出错:', error);
    res.status(500).json({ 
      success: false, 
      message: '服务器错误，无法获取统计趋势' 
    });
  }
});

/**
 * @route GET /api/merchant-stats/:merchant_id/top-items
 * @desc 获取指定商家的热门菜品
 * @access 私有 - 仅限商家自己和管理员
 */
router.get('/:merchant_id/top-items', /* authMiddleware, */ async (req, res) => {
  try {
    const { merchant_id } = req.params;
    const { period_type = 'monthly' } = req.query;
    
    // 验证周期类型
    if (!['daily', 'weekly', 'monthly'].includes(period_type)) {
      return res.status(400).json({ 
        success: false, 
        message: '无效的周期类型。允许的值：daily, weekly, monthly' 
      });
    }
    
    // 构建缓存键
    const cacheKey = `merchant_top_items:${merchant_id}:${period_type}`;
    
    // 尝试从缓存获取热门菜品数据
    const topDishes = await cacheService.get(cacheKey, async () => {
      // 获取最新的统计数据
      const stats = await MerchantStats.findOne({
        merchant_id,
        period_type
      }).sort({ start_date: -1 });
      
      if (!stats || !stats.dish_stats.top_dishes) {
        return null;
      }
      
      return stats.dish_stats.top_dishes;
    }, { ttl: 600 }); // 缓存10分钟
    
    if (!topDishes) {
      return res.status(404).json({ 
        success: false, 
        message: '未找到热门菜品数据' 
      });
    }
    
    res.json({
      success: true,
      data: topDishes
    });
  } catch (error) {
    console.error('获取商家热门菜品时出错:', error);
    res.status(500).json({ 
      success: false, 
      message: '服务器错误，无法获取热门菜品数据' 
    });
  }
});

module.exports = router; 