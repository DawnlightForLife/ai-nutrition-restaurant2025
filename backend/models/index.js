const mongoose = require('mongoose');
const config = require('../config/db.config');
const dbManager = require('../config/database');
const ModelFactory = require('./modelFactory');

// 导入所有模型
const User = require('./core/userModel');
const UserRole = require('./core/userRoleModel');
const Admin = require('./core/adminModel');
const NutritionProfile = require('./health/nutritionProfileModel');
const HealthData = require('./health/healthDataModel');
const Nutritionist = require('./nutrition/nutritionistModel');
const Merchant = require('./merchant/merchantModel');
const Dish = require('./merchant/ProductDishModel');
const Order = require('./order/orderModel');
const AiRecommendation = require('./nutrition/aiRecommendationModel');
const Subscription = require('./order/subscriptionModel');
const AuditLog = require('./core/auditLogModel');
const DataAccessControl = require('./core/dataAccessControlModel');
const ForumPost = require('./forum/forumPostModel');
const ForumComment = require('./forum/forumCommentModel');
const Consultation = require('./order/consultationModel');
const MerchantStats = require('./merchant/merchantStatsModel');
const Store = require('./merchant/storeModel');
const StoreDish = require('./merchant/storeDishModel');
const UserFavorite = require('./nutrition/userFavoriteModel');
const DbMetrics = require('./core/dbMetricsModel');
const Notification = require('./misc/notificationModel');
const OAuthAccount = require('./core/oauthAccountModel');

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
  
  // 使用已导入的DbMetrics模型而不是重新创建
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
    // 获取主连接和副本连接
    const primaryConn = await dbManager.getPrimaryConnection();
    const replicaConn = await dbManager.getReplicaConnection();
    
    // 监听主连接错误事件
    primaryConn.on('error', (err) => {
      console.error('MongoDB 主连接错误:', err);
    });
    
    // 监听主连接断开连接事件
    primaryConn.on('disconnected', () => {
      console.warn('MongoDB 主连接断开，尝试重新连接...');
      dbManager.reconnectPrimary().catch(err => console.error('主连接重新连接失败:', err));
    });
    
    // 监听副本连接错误事件
    replicaConn.on('error', (err) => {
      console.error('MongoDB 副本连接错误:', err);
    });
    
    // 监听副本连接断开连接事件
    replicaConn.on('disconnected', () => {
      console.warn('MongoDB 副本连接断开，尝试重新连接...');
      dbManager.reconnectReplica().catch(err => console.error('副本连接重新连接失败:', err));
    });
    
    // 添加全局连接恢复后的模型重新初始化逻辑
    primaryConn.once('reconnected', async () => {
      console.log('MongoDB 主连接已恢复，重新初始化模型...');
      await ModelFactory.reinitializeAllModels();
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
  Notification,
  OAuthAccount,
  
  // 便捷的数据库操作方法
  createIndexes: async () => {
    try {
      console.log('开始创建数据库索引...');
      
      // 获取主连接
      const primaryConn = await dbManager.getPrimaryConnection();
      
      // 检查是否已经创建过索引
      const collections = await primaryConn.db.listCollections().toArray();
      const collectionNames = collections.map(c => c.name);
      
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
        DbMetrics.createIndexes(),
        Notification.createIndexes(),
        OAuthAccount.createIndexes()
      ]);
      console.log('所有数据库索引创建完成');
    } catch (error) {
      console.error('创建索引失败:', error);
      throw error;
    }
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
      DbMetrics.deleteMany({}),
      Notification.deleteMany({}),
      OAuthAccount.deleteMany({})
    ]);
    console.log('数据库清理完成');
  }
}; 