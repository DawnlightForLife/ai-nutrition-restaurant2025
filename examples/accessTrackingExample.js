/**
 * 访问轨迹追踪与反作弊示例
 * 
 * 演示如何集成访问轨迹追踪和反作弊机制
 */

const express = require('express');
const mongoose = require('mongoose');
const session = require('express-session');
const logger = require('../backend/utils/logger/winstonLogger');

// 导入中间件
const { accessTrackingMiddleware, resourceTrackingMiddleware, resourceIdResolvers } = require('../backend/middleware/security/accessTrackingMiddleware');
const { dynamicRateLimit, resourceRateLimit } = require('../backend/middleware/security/rateLimitMiddleware');

// 创建Express应用
const app = express();

// 基本中间件
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 会话管理
app.use(session({
  secret: 'access-tracking-example-secret',
  resave: false,
  saveUninitialized: true,
  cookie: { secure: false }
}));

// 模拟认证中间件
const mockAuth = (req, res, next) => {
  // 如果请求包含用户ID，设置为已认证用户
  if (req.query.userId || req.body.userId) {
    req.user = {
      id: req.query.userId || req.body.userId,
      role: 'user'
    };
  }
  next();
};

// 初始化访问轨迹中间件
app.use(mockAuth);
app.use(accessTrackingMiddleware({
  thresholds: {
    requestsPerMinute: 60,        // 单IP每分钟最大请求数
    userRequestsPerMinute: 30,    // 单用户每分钟最大请求数
    resourceAccessCount: 20,      // 单用户访问资源ID数量阈值
    ipSwitchCount: 3,             // IP切换阈值
    detectionWindow: 300          // 检测窗口大小（秒）
  }
}));

// 全局限流中间件
app.use(dynamicRateLimit({
  windowSize: 60,         // 时间窗口（秒）
  defaultLimit: 100,      // 默认限制
  ipLimit: 60,            // IP限制
  userLimit: 30,          // 用户限制
  anonymousLimit: 20,     // 匿名用户限制
  anomalyThreshold: 30,   // 异常分数阈值
  banThreshold: 100,      // 封禁IP的请求阈值
  banDuration: 1800       // 封禁时长（秒）
}));

// 连接数据库
async function connectDB() {
  try {
    await mongoose.connect('mongodb://localhost:27017/access_tracking_example');
    logger.info('已连接到MongoDB');
  } catch (error) {
    logger.error('连接MongoDB失败:', error);
    process.exit(1);
  }
}

// 定义演示API路由

// 用户API - 带资源跟踪
app.use('/api/users',
  resourceTrackingMiddleware('user', resourceIdResolvers.fromParam('userId')),
  resourceRateLimit('user', { resourceLimit: 30 })
);

app.get('/api/users/:userId', (req, res) => {
  res.json({
    success: true,
    data: {
      id: req.params.userId,
      username: `user_${req.params.userId}`,
      email: `user_${req.params.userId}@example.com`
    }
  });
});

// 营养档案API - 带资源跟踪
app.use('/api/nutrition-profiles',
  resourceTrackingMiddleware('nutrition-profile', resourceIdResolvers.fromParam('profileId')),
  resourceRateLimit('nutrition-profile', { resourceLimit: 20 })
);

app.get('/api/nutrition-profiles/:profileId', (req, res) => {
  res.json({
    success: true,
    data: {
      id: req.params.profileId,
      userId: req.query.userId || 'unknown',
      preferences: {
        vegetarian: Boolean(Math.round(Math.random())),
        calories: 1800 + Math.floor(Math.random() * 1000)
      }
    }
  });
});

// 批量查询API - 容易受到暴力查询攻击的端点
app.get('/api/bulk-lookup', (req, res) => {
  // 解析查询参数
  const ids = req.query.ids ? req.query.ids.split(',') : [];
  
  if (ids.length > 20) {
    return res.status(400).json({
      success: false,
      error: 'too_many_ids',
      message: '一次最多查询20个ID'
    });
  }
  
  // 返回模拟数据
  const results = ids.map(id => ({
    id,
    name: `Item ${id}`,
    value: Math.random() * 100
  }));
  
  res.json({
    success: true,
    data: results
  });
});

// 访问轨迹查询API（仅限管理员）
app.get('/api/access-tracking/:userId', (req, res) => {
  if (!req.user || req.user.role !== 'admin') {
    return res.status(403).json({
      success: false,
      error: 'forbidden',
      message: '没有权限访问此资源'
    });
  }
  
  res.json({
    success: true,
    message: `查询用户 ${req.params.userId} 的访问轨迹`,
    data: {
      // 这里应该是实际的访问轨迹数据
      recent_tracks: [
        {
          timestamp: new Date(),
          ip: '192.168.1.1',
          resource: { type: 'user', id: req.params.userId },
          anomalyScore: 0
        }
      ]
    }
  });
});

// 启动服务器
async function startServer() {
  try {
    await connectDB();
    
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      logger.info(`访问轨迹追踪示例服务器已启动，监听端口: ${PORT}`);
      
      // 打印测试指令
      console.log('\n测试指令:');
      console.log('1. 正常访问用户资料:');
      console.log(`   curl http://localhost:${PORT}/api/users/123?userId=456`);
      console.log('\n2. 高频访问(可能触发限流):');
      console.log(`   for i in {1..50}; do curl http://localhost:${PORT}/api/users/$i?userId=456; done`);
      console.log('\n3. 批量查询(可能触发暴力遍历检测):');
      console.log(`   curl "http://localhost:${PORT}/api/bulk-lookup?ids=1,2,3,4,5&userId=456"`);
      console.log('\n4. 模拟IP切换(可能触发异常检测):');
      console.log(`   curl -H "X-Forwarded-For: 192.168.1.1" http://localhost:${PORT}/api/users/123?userId=456`);
      console.log(`   curl -H "X-Forwarded-For: 192.168.1.2" http://localhost:${PORT}/api/users/123?userId=456`);
      console.log(`   curl -H "X-Forwarded-For: 192.168.1.3" http://localhost:${PORT}/api/users/123?userId=456`);
      console.log(`   curl -H "X-Forwarded-For: 192.168.1.4" http://localhost:${PORT}/api/users/123?userId=456`);
    });
  } catch (error) {
    logger.error('启动服务器失败:', error);
    process.exit(1);
  }
}

// 启动应用
startServer().catch(console.error);

/**
 * 测试说明:
 * 
 * 本示例演示了如何集成访问轨迹追踪和反作弊机制，包括：
 * 
 * 1. 用户行为追踪
 *    - 记录每个HTTP请求的详细信息，包括用户ID、IP、资源类型、资源ID等
 *    - 针对资源访问单独进行追踪
 * 
 * 2. 异常模式检测
 *    - 高频请求检测（单IP或单用户在短时间内发送大量请求）
 *    - 资源暴力遍历检测（访问大量不同ID的相同类型资源）
 *    - IP切换检测（同一用户在短时间内使用多个不同IP）
 * 
 * 3. 动态限流
 *    - 基于用户异常分数动态调整限流阈值
 *    - 针对特定资源的限流
 *    - 自动封禁异常IP
 * 
 * 使用方法:
 * 1. 启动MongoDB
 * 2. 运行 `node examples/accessTrackingExample.js`
 * 3. 使用提供的测试命令测试不同场景
 */ 