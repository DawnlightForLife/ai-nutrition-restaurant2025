const mongoose = require('mongoose');
const config = require('../config/db.config');
const dbManager = require('../config/database');
const ModelFactory = require('./modelFactory');

// 导入所有模型
const User = require('./userModel');
const UserRole = require('./userRoleModel');
const Admin = require('./adminModel');
const NutritionProfile = require('./nutritionProfileModel');
const HealthData = require('./healthDataModel');
const Nutritionist = require('./nutritionistModel');
const Merchant = require('./merchantModel');
const Dish = require('./dishModel');
const Order = require('./orderModel');
const AiRecommendation = require('./aiRecommendationModel');
const Subscription = require('./subscriptionModel');
const AuditLog = require('./auditLogModel');
const DataAccessControl = require('./dataAccessControlModel');
const ForumPost = require('./forumPostModel');
const ForumComment = require('./forumCommentModel');
const Consultation = require('./consultationModel');
const MerchantStats = require('./merchantStatsModel');
const Store = require('./storeModel');
const StoreDish = require('./storeDishModel');
const UserFavorite = require('./userFavoriteModel');
const DbMetrics = require('./dbMetricsModel');

// 连接数据库 - 使用新的数据库管理器
const connectDB = async () => {
  try {
    // 初始化并连接到数据库（读写分离）
    await dbManager.connect();
    console.log('MongoDB 连接成功（读写分离模式）');
    
    // 设置慢查询监控
    await setupMonitoring();
  } catch (err) {
    console.error('MongoDB 连接失败:', err.message);
    process.exit(1);
  }
};

// 设置慢查询监控和性能指标收集
const setupMonitoring = async () => {
  // 慢查询阈值（单位：毫秒）
  const SLOW_QUERY_THRESHOLD = 500;
  
  // 慢查询记录和性能指标集合 - 使用ModelFactory
  const DbMetrics = ModelFactory.model('DbMetrics', new mongoose.Schema({
    operation: String,
    collection: String,
    query: Object,
    duration: Number,
    timestamp: { type: Date, default: Date.now },
    slow_query: Boolean
  }));
  
  try {
    // 获取主连接
    const primaryConn = await dbManager.getPrimaryConnection();
    
    // 设置MongoDB查询监听
    primaryConn.set('debug', function(collection, method, query, doc, options) {
      const start = Date.now();
      
      // 操作完成后的回调
      const origCallback = options.callback;
      options.callback = function(err, result) {
        const duration = Date.now() - start;
        const isSlowQuery = duration >= SLOW_QUERY_THRESHOLD;
        
        // 记录慢查询和性能指标
        if (isSlowQuery || (Math.random() < 0.01)) { // 记录所有慢查询和1%的正常查询
          const metrics = new DbMetrics({
            operation: method,
            collection: collection,
            query: JSON.parse(JSON.stringify(query)), // 避免循环引用
            duration: duration,
            timestamp: new Date(),
            slow_query: isSlowQuery
          });
          
          metrics.save().catch(err => console.error('保存数据库指标失败:', err));
          
          // 慢查询警告日志
          if (isSlowQuery) {
            console.warn(`慢查询 (${duration}ms): ${collection}.${method}`, 
                         JSON.stringify(query).substring(0, 200));
          }
        }
        
        // 调用原始回调
        if (origCallback) {
          origCallback(err, result);
        }
      };
    });
    
    // 设置连接监听器
    setupConnectionListeners();
    
    console.log('数据库监控设置完成');
  } catch (error) {
    console.error('设置数据库监控失败:', error);
  }
};

// 设置数据库连接的事件监听器
const setupConnectionListeners = async () => {
  try {
    // 获取主连接
    const primaryConn = await dbManager.getPrimaryConnection();
    
    // 监听数据库错误事件
    primaryConn.on('error', (err) => {
      console.error('MongoDB 主连接错误:', err);
    });
    
    // 监听数据库断开连接事件
    primaryConn.on('disconnected', () => {
      console.warn('MongoDB 主连接断开，尝试重新连接...');
      connectDB().catch(err => console.error('重新连接失败:', err));
    });
    
    console.log('数据库连接监听器设置完成');
  } catch (error) {
    console.error('设置连接监听器失败:', error);
  }
};

// 导出所有模型和数据库连接函数
module.exports = {
  connectDB,
  dbManager, // 导出数据库管理器以便其他模块使用
  User,
  UserRole,
  Admin,
  NutritionProfile,
  HealthData,
  Nutritionist,
  Merchant,
  Dish,
  Order,
  AiRecommendation,
  Subscription,
  AuditLog,
  DataAccessControl,
  ForumPost,
  ForumComment,
  Consultation,
  MerchantStats,
  Store,
  StoreDish,
  UserFavorite,
  DbMetrics,
  
  // 便捷的数据库操作方法
  createIndexes: async () => {
    // 创建所有集合的索引（在部署时可以调用）
    await Promise.all([
      User.createIndexes(),
      UserRole.createIndexes(),
      Admin.createIndexes(),
      NutritionProfile.createIndexes(),
      HealthData.createIndexes(),
      Nutritionist.createIndexes(),
      Merchant.createIndexes(),
      Dish.createIndexes(),
      Order.createIndexes(),
      AiRecommendation.createIndexes(),
      Subscription.createIndexes(),
      AuditLog.createIndexes(),
      DataAccessControl.createIndexes(),
      ForumPost.createIndexes(),
      ForumComment.createIndexes(),
      Consultation.createIndexes(),
      MerchantStats.createIndexes(),
      Store.createIndexes(),
      StoreDish.createIndexes(),
      UserFavorite.createIndexes(),
      DbMetrics.createIndexes()
    ]);
    console.log('所有数据库索引创建完成');
  },
  
  // 数据库清理方法（测试环境使用）
  clearDatabase: async () => {
    if (process.env.NODE_ENV !== 'test') {
      throw new Error('此方法只能在测试环境中使用');
    }
    
    await Promise.all([
      User.deleteMany({}),
      UserRole.deleteMany({}),
      Admin.deleteMany({}),
      NutritionProfile.deleteMany({}),
      HealthData.deleteMany({}),
      Nutritionist.deleteMany({}),
      Merchant.deleteMany({}),
      Dish.deleteMany({}),
      Order.deleteMany({}),
      AiRecommendation.deleteMany({}),
      Subscription.deleteMany({}),
      AuditLog.deleteMany({}),
      DataAccessControl.deleteMany({}),
      ForumPost.deleteMany({}),
      ForumComment.deleteMany({}),
      Consultation.deleteMany({}),
      MerchantStats.deleteMany({}),
      Store.deleteMany({}),
      StoreDish.deleteMany({}),
      UserFavorite.deleteMany({}),
      DbMetrics.deleteMany({})
    ]);
    console.log('测试数据库已清空');
  }
}; 