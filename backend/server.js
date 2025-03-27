const express = require('express');
const cors = require('cors');
const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config();

// 确保默认连接已加载
require('./config/database');

// 创建Express应用
const app = express();
let databaseReady = false;

// 中间件
app.use(cors());
app.use(express.json());

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

// 确保数据库连接就绪后再绑定路由和启动服务器
const startServer = async () => {
  try {
    console.log('等待数据库连接完成...');
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/smart_nutrition_restaurant', {
      serverSelectionTimeoutMS: 30000,
      socketTimeoutMS: 30000,
      connectTimeoutMS: 30000,
      maxPoolSize: 10,
      minPoolSize: 5,
    });
    console.log('Mongoose默认连接已打开');
    console.log('数据库连接已就绪');

    // 创建默认用户
    const User = require('./models/userModel');
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
          role: 'user',
          gender: 'female',
          age: 28
        });
        
        console.log('创建默认用户成功');
      } catch (error) {
        console.error('创建默认用户失败:', error);
      }
    }
    
    // 导入路由和其他服务
    const userRoutes = require('./routes/userRoutes');
    const profileRoutes = require('./routes/profileRoutes');
    const merchantStatsRoutes = require('./routes/merchantStatsRoutes');
    const nutritionProfileRoutes = require('./routes/nutritionProfileRoutes');
    const cacheService = require('./services/cacheService');
    const { shardingService } = require('./services/shardingService');
    const shardingConfig = require('./config/shardingConfig');
    const ScheduledTasks = require('./services/scheduledTasks');

    // 设置路由
    app.use('/api/users', userRoutes);
    app.use('/api/profiles', profileRoutes);
    app.use('/api/merchant-stats', merchantStatsRoutes);
    app.use('/api/nutrition-profiles', nutritionProfileRoutes);
    
    // 初始化服务
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
    
    console.log('所有服务初始化完成');
    
    // 启动服务器
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`服务器在端口 ${PORT} 上运行`);
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
