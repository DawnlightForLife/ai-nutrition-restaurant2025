const express = require('express');
const cors = require('cors');

// 数据库和优化服务
const dbManager = require('./config/database');
// 先初始化数据库连接
dbManager.connect()
  .then(() => console.log('数据库连接已预先初始化'))
  .catch(err => console.error('数据库预初始化失败:', err));

// 路由和其他需要数据库连接的服务在数据库连接初始化后再导入
const userRoutes = require('./routes/userRoutes');
const profileRoutes = require('./routes/profileRoutes');
const merchantStatsRoutes = require('./routes/merchantStatsRoutes');
const ScheduledTasks = require('./services/scheduledTasks');
const cacheService = require('./services/cacheService');
const { shardingService } = require('./services/shardingService');
const shardingConfig = require('./config/shardingConfig');

const app = express();

// 中间件
app.use(cors());
app.use(express.json());

// 路由
app.use('/api/users', userRoutes);
app.use('/api/profiles', profileRoutes);
app.use('/api/merchant-stats', merchantStatsRoutes);

// 连接数据库与初始化服务
async function initializeServices() {
  try {
    // 确保数据库已连接
    if (!dbManager.isConnected) {
      await dbManager.connect();
      console.log('数据库连接已建立（读写分离模式）');
    } else {
      console.log('使用现有数据库连接');
    }
    
    // 初始化缓存服务
    if (process.env.REDIS_ENABLED === 'true') {
      await cacheService.initRedis();
      console.log('Redis缓存服务已初始化');
    }
    
    // 初始化分片服务
    shardingService.init(shardingConfig);
    if (shardingConfig.enabled) {
      console.log('数据分片服务已初始化');
    }
    
    // 初始化定时任务
    ScheduledTasks.initTasks();
    console.log('定时任务系统已初始化');
    
    // 暂时禁用性能报告生成，以防止错误
    // setTimeout(async () => {
    //   try {
    //     const DbPerformanceAnalyzer = require('./utils/dbPerformanceAnalyzer');
    //     console.log('生成初始数据库性能基准报告...');
    //     const report = await DbPerformanceAnalyzer.generateDailyReport().catch(err => {
    //       console.error('初始性能报告生成失败:', err.message);
    //       return null;
    //     });
    //     
    //     if (report) {
    //       console.log('初始数据库性能基准报告生成完成');
    //       console.log(`性能评分: ${report.performance_score}`);
    //       
    //       if (report.slow_query_stats && report.slow_query_stats.total_count > 0) {
    //         console.log(`检测到 ${report.slow_query_stats.total_count} 个慢查询`);
    //       } else {
    //         console.log('未检测到慢查询，数据库性能良好');
    //       }
    //     }
    //   } catch (error) {
    //     console.error('生成初始数据库性能报告失败:', error);
    //     // 非致命错误，允许服务继续运行
    //   }
    // }, 30000); // 增加到30秒，确保数据库连接和服务完全初始化后再执行
    
    console.log('所有服务初始化完成');
    
    return true;
  } catch (error) {
    console.error('初始化服务失败:', error);
    throw error;
  }
}

// 提供性能报告API端点
app.get('/api/admin/db-performance', async (req, res) => {
  // 暂时返回空报告，避免错误
  res.json({
    message: "性能分析功能暂时禁用",
    timestamp: new Date()
  });
  
  // try {
  //   // 需要身份验证和授权检查（此处省略）
  //   // 在实际项目中，应该添加中间件来验证用户是管理员
  //   
  //   const DbPerformanceAnalyzer = require('./utils/dbPerformanceAnalyzer');
  //   const report = await DbPerformanceAnalyzer.generateDailyReport();
  //   res.json(report);
  // } catch (error) {
  //   console.error('获取数据库性能报告失败:', error);
  //   res.status(500).json({ error: '获取性能报告时出错' });
  // }
});

// 获取缓存状态API端点
app.get('/api/admin/cache-stats', (req, res) => {
  try {
    const stats = cacheService.getStats();
    res.json(stats);
  } catch (error) {
    console.error('获取缓存统计信息失败:', error);
    res.status(500).json({ error: '获取缓存统计信息时出错' });
  }
});

// 优雅关闭处理
process.on('SIGTERM', async () => {
  console.log('接收到SIGTERM信号，准备关闭服务...');
  await shutdownServices();
  process.exit(0);
});

process.on('SIGINT', async () => {
  console.log('接收到SIGINT信号，准备关闭服务...');
  await shutdownServices();
  process.exit(0);
});

// 关闭服务函数
async function shutdownServices() {
  try {
    // 关闭数据库连接
    await dbManager.close();
    console.log('数据库连接已关闭');
    
    // 其他清理工作...
    
  } catch (error) {
    console.error('关闭服务时出错:', error);
  }
}

// 启动服务器
const PORT = process.env.PORT || 3000;

initializeServices()
  .then(() => {
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`服务器运行在端口 ${PORT}`);
    });
  })
  .catch((error) => {
    console.error('服务器启动失败:', error);
    process.exit(1);
  });
