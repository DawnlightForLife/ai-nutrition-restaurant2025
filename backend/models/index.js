const mongoose = require('mongoose');
const config = require('../config/modules/db.config');
const dbManager = require('../services/database/database');
const ModelFactory = require('./modelFactory');

// 导入所有模型
const User = require('../models/user/userModel');
const UserRole = require('../models/user/userRoleModel');
const Admin = require('../models/user/adminModel');
const NutritionProfile = require('../models/nutrition/nutritionProfileModel');
const Nutritionist = require('../models/nutrition/nutritionistModel');
const Merchant = require('../models/merchant/merchantModel');
const MerchantTypes = require('../models/merchant/merchantTypeEnum');
const Dish = require('../models/merchant/productDishModel');
const Order = require('../models/order/orderModel');
const AiRecommendation = require('../models/nutrition/aiRecommendationModel');
const Subscription = require('../models/order/subscriptionModel');
const AuditLog = require('../models/core/auditLogModel');
const DataAccessControl = require('./core/dataAccessControlModel');
const ForumPost = require('./forum/forumPostModel');
const ForumComment = require('./forum/forumCommentModel');
const ForumTag = require('./forum/forumTagModel');
const Consultation = require('../models/consult/consultationModel');
const MerchantStats = require('../models/merchant/merchantStatsModel');
const Store = require('../models/merchant/storeModel');
const StoreDish = require('../models/merchant/storeDishModel');
const UserFavorite = require('../models/nutrition/FavoriteModel');
const DbMetrics = require('../models/core/dbMetricsModel');
const Notification = require('../models/notification/notificationModel');
const OAuthAccount = require('../models/user/oauthAccountModel');
const UsageLog = require('../models/analytics/usageLogModel');
const UserNotificationStatus = require('../models/notification/userNotificationStatusModel');
// 添加新位置的模型
const ExportTask = require('../models/analytics/exportTaskModel');
const FileUpload = require('../models/common/fileUploadModel');
const Session = require('../models/common/sessionModel');
// 新增或修复以下导入
const feedbackModel = require('../models/feedback/feedbackModel');
const paymentModel = require('../models/order/paymentModel');
const promotionModel = require('../models/promotion/promotionModel');
const NutritionistCertification = require('../models/nutrition/nutritionistCertificationModel');
const UserPermission = require('../models/user/userPermissionModel');
const PermissionHistory = require('../models/admin/permissionHistoryModel');

const models = {
  core: {
    User,
    UserRole,
    Admin,
    OAuthAccount,
    UserPermission,
    DataAccessControl,
    AuditLog,
    DbMetrics
  },
  admin: {
    PermissionHistory
  },
  nutrition: {
    NutritionProfile,
    Nutritionist,
    AiRecommendation,
    UserFavorite,
    NutritionistCertification
  },
  merchant: {
    Merchant,
    MerchantTypes,
    Dish,
    Store,
    StoreDish,
    MerchantStats
  },
  order: {
    Order,
    Subscription,
    Consultation
  },
  forum: {
    ForumPost,
    ForumComment,
    ForumTag
  },
  misc: {
    Notification
  },
  analytics: {
    UsageLog,
    ExportTask // 添加到 analytics 分组
  },
  notification: {
    UserNotificationStatus
  },
  common: { // 添加 common 分组
    FileUpload,
    Session
  }
};

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

// 便捷的数据库操作方法
const createIndexes = async () => {
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
      ForumTag.createIndexes(),
      Consultation.createIndexes(),
      MerchantStats.createIndexes(),
      Store.createIndexes(),
      StoreDish.createIndexes(),
      UserFavorite.createIndexes(),
      DbMetrics.createIndexes(),
      Notification.createIndexes(),
      OAuthAccount.createIndexes(),
      UsageLog.createIndexes(),
      UserNotificationStatus.createIndexes(),
      ExportTask.createIndexes(),
      FileUpload.createIndexes(),
      Session.createIndexes(),
      UserPermission.createIndexes(),
      PermissionHistory.createIndexes()
    ]);
    console.log('所有数据库索引创建完成');
  } catch (error) {
    console.error('创建索引失败:', error);
    throw error;
  }
};

// 数据库清理方法（测试环境使用）
const clearDatabase = async () => {
  if (process.env.NODE_ENV !== 'test') {
    throw new Error('此方法只能在测试环境中使用');
  }
  
  await Promise.all([
    User.deleteMany({}),
    UserRole.deleteMany({}),
    Admin.deleteMany({}),
    NutritionProfile.deleteMany({}),
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
    ForumTag.deleteMany({}),
    Consultation.deleteMany({}),
    MerchantStats.deleteMany({}),
    Store.deleteMany({}),
    StoreDish.deleteMany({}),
    UserFavorite.deleteMany({}),
    DbMetrics.deleteMany({}),
    Notification.deleteMany({}),
    OAuthAccount.deleteMany({}),
    UsageLog.deleteMany({}),
    UserNotificationStatus.deleteMany({}),
    ExportTask.deleteMany({}),
    FileUpload.deleteMany({}),
    Session.deleteMany({})
  ]);
  console.log('数据库清理完成');
};

// 导出所有模型和数据库连接函数
module.exports = {
  connectDB,
  dbManager, // 导出数据库管理器以便其他模块使用
  ...models.core,
  ...models.admin,
  ...models.nutrition,
  ...models.merchant,
  ...models.order,
  ...models.forum,
  ...models.misc,
  ...models.analytics,
  ...models.notification,
  ...models.common, // 导出新的 common 模型
  models, // 新增结构化导出（推荐使用）
  createIndexes,
  clearDatabase
};