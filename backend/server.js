const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const path = require('path');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./docs/swagger');
const http = require('http');
const { Server } = require('socket.io');
require('dotenv').config();

// 确保默认连接已加载
require('./services/database/database');

// 创建Express应用
const app = express();
const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

let databaseReady = false;

// 中间件
app.use(cors());
app.use(express.json());

// 静态文件服务 - 为上传的文件提供访问
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// 全局错误处理
app.use((err, req, res, next) => {
  console.error('全局错误处理捕获到错误:', err);
  res.status(500).json({
    success: false,
    message: '服务器错误',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// 定义状态路由
app.get('/api/status', (req, res) => {
  res.json({
    status: mongoose.connection.readyState === 1 ? 'ready' : 'initializing',
    ready: mongoose.connection.readyState === 1,
    uptime: process.uptime(),
    timestamp: new Date()
  });
});

// 添加健康检查ping接口
app.get('/api/ping', (req, res) => {
  res.status(200).json({
    message: 'pong',
    timestamp: new Date(),
    uptime: process.uptime(),
    db_connected: mongoose.connection.readyState === 1
  });
});

// 确保数据库连接就绪后再绑定路由和启动服务器
const startServer = async () => {
  try {
    console.log('等待数据库连接完成...');
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant', {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('Mongoose默认连接已打开');
    console.log('数据库连接已就绪');

    // 加载所有模型，确保它们被正确注册
    const models = require('./models/index');
    
    // 创建默认用户
    const User = models.User;
    const bcrypt = require('bcryptjs');
    
    // 检查是否已有用户
    const count = await User.countDocuments();
    if (count === 0) {
      console.log('创建默认用户...');
      try {
        const salt = await bcrypt.genSalt(10);
        
        // 创建默认管理员
        const adminPass = await bcrypt.hash('admin123', salt);
        await User.create({
          phone: '13800000000',
          email: 'admin@example.com',
          password: adminPass,
          nickname: '系统管理员',
          role: 'admin',
          gender: 'male',
          age: 35
        });
        
        // 创建默认用户
        const userPass = await bcrypt.hash('user123', salt);
        await User.create({
          phone: '13900000000',
          email: 'user@example.com',
          password: userPass,
          nickname: '测试用户',
          role: 'customer',
          gender: 'female',
          age: 28
        });
        
        console.log('创建默认用户成功');
      } catch (error) {
        console.error('创建默认用户失败:', error);
      }
    }
    
    // 导入主路由文件，此文件包含所有子路由的注册
    const allRoutes = require('./routes/index');
    
    // 注册主路由
    app.use('/api', allRoutes);
    
    // 导入其他需要单独注册的路由和服务
    const userRoutes = require('./routes/user/userRoutes');
    const authRoutes = require('./routes/user/authRoutes');
    const adminRoutes = require('./routes/user/adminRoutes');
    const auditLogRoutes = require('./routes/core/auditLogRoutes');
    const merchantRoutes = require('./routes/merchant/merchantRoutes');
    const storeRoutes = require('./routes/merchant/storeRoutes');
    const dishRoutes = require('./routes/merchant/dishRoutes');
    const orderRoutes = require('./routes/order/orderRoutes');
    
    // 导入服务
    const { appConfigService } = require('./services/core/appConfigService');
    const { dataAccessControlService } = require('./services/security/dataAccessControlService');
    const { shardingConfig, shardingService } = require('./config/modules/shardingConfig');
    const ScheduledTasks = require('./utils/scheduler/scheduledTasks');
    
    // 导入数据库优化服务
    const dbOptimizationManager = require('./services/performance/dbOptimizationManager');
    const ModelFactory = require('./models/modelFactory');
    const { circuitBreakerService } = require('./services/performance/circuitBreakerService');

    // 设置其他路由（可选，因为大部分路由已经通过routes/index.js注册）
    // 如果这些路由在index.js中已注册，则可以考虑移除这些冗余项
    app.use('/api/users', userRoutes);
    app.use('/api/auth', authRoutes);
    app.use('/api/admin', adminRoutes);
    app.use('/api/audit', auditLogRoutes);
    app.use('/api/merchants', merchantRoutes);
    app.use('/api/stores', storeRoutes);
    app.use('/api/dishes', dishRoutes);
    app.use('/api/orders', orderRoutes);
    
    // 添加Swagger UI
    app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));
    app.get('/api-docs.json', (req, res) => {
      res.setHeader('Content-Type', 'application/json');
      res.send(swaggerSpec);
    });
    
    // 添加数据库优化API路由
    app.get('/api/admin/db/status', async (req, res) => {
      res.json(dbOptimizationManager.getStatus());
    });
    
    app.post('/api/admin/db/optimize', async (req, res) => {
      try {
        const result = await dbOptimizationManager.runAutoOptimization();
        res.json({ success: true, result });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });
    
    app.post('/api/admin/db/cache/clear', async (req, res) => {
      try {
        const result = await dbOptimizationManager.clearAllCaches();
        res.json({ success: true, cleared: result });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });
    
    app.post('/api/admin/db/batch/flush', async (req, res) => {
      try {
        const result = await dbOptimizationManager.flushAllBatches();
        res.json({ success: true, flushed: result });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });
    
    app.post('/api/admin/db/circuit-breakers/reset', async (req, res) => {
      try {
        const result = await dbOptimizationManager.resetAllCircuitBreakers();
        res.json({ success: true, reset: result });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });
    
    // 添加健康检查端点
    app.get('/api/admin/db/health', async (req, res) => {
      try {
        const healthStatus = await dbOptimizationManager.runHealthCheck();
        res.json({ success: true, status: healthStatus });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });
    
    // 初始化缓存服务
    const cacheService = require('./services/cache/cacheService');
    await cacheService.initialize();
    console.log('缓存服务已初始化');
    
    // 初始化其他Redis服务（如果需要）
    const redisEnabled = process.env.REDIS_ENABLED === 'true';
    if (redisEnabled) {
      const { initRedisCache } = require('./utils/cache');
      await initRedisCache();
      console.log('额外Redis缓存服务已初始化');
    }
    
    // 初始化分片服务
    if (shardingConfig.enabled) {
      await shardingService.init(shardingConfig);
      console.log('数据分片服务已初始化');
    }
    
    // 初始化ModelFactory与相关服务
    await ModelFactory.initConnections();
    console.log('数据库连接池已初始化');
    
    // 初始化数据库优化管理器
    await dbOptimizationManager.initialize();
    console.log('数据库优化服务已初始化');
    
    // 创建通用的数据库断路器
    circuitBreakerService.getBreaker('db-operations', {
      threshold: 5,
      timeout: 30000,
      halfOpenLimit: 3
    });
    
    // 初始化定时任务
    if (ScheduledTasks && ScheduledTasks.initTasks) {
      ScheduledTasks.initTasks();
      console.log('定时任务系统已初始化');
    }
    
    console.log('所有服务初始化完成');
    
    // 初始化WebSocket服务
    const inventoryWebSocketService = require('./services/websocket/inventoryWebSocketService');
    inventoryWebSocketService.initialize(io);
    
    const orderTrackingWebSocketService = require('./services/websocket/orderTrackingWebSocketService');
    orderTrackingWebSocketService.initialize(io);
    
    console.log('WebSocket服务已初始化');
    
    // 启动服务器
    const PORT = process.env.PORT || 3000;
    // 监听所有网络接口，以便 Android 模拟器可以访问
    server.listen(PORT, '0.0.0.0', () => {
      console.log(`服务器在端口 ${PORT} 上运行 (监听所有接口)`);
      databaseReady = true;
    });
    
    // 处理程序终止信号
    process.on('SIGINT', gracefulShutdown);
    process.on('SIGTERM', gracefulShutdown);
  } catch (error) {
    console.error('启动服务器失败:', error);
  }
};

// 优雅关闭处理
const gracefulShutdown = async () => {
  console.log('正在关闭服务器...');
  try {
    // 关闭数据库连接
    await mongoose.connection.close();
    console.log('Mongoose连接已关闭');
    
    // 关闭缓存服务
    const cacheService = require('./services/cache/cacheService');
    if (cacheService.initialized) {
      await cacheService.close();
      console.log('缓存服务已关闭');
    }
    
    // 关闭ModelFactory连接
    const ModelFactory = require('./models/modelFactory');
    await ModelFactory.closeConnections();
    console.log('ModelFactory连接已关闭');
    
    // 刷新所有批处理操作
    const batchProcessService = require('./services/core/batchProcessService');
    await batchProcessService.flushAll();
    console.log('批处理操作已刷新');
    
    process.exit(0);
  } catch (err) {
    console.error('关闭过程中出错:', err);
    process.exit(1);
  }
};

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
    await mongoose.connection.close();
    console.log('数据库连接已关闭');
    
    // 其他清理工作...
    
  } catch (error) {
    console.error('关闭服务时出错:', error);
  }
}

// 启动服务器
startServer();
