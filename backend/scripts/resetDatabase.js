/**
 * 数据库重置脚本
 * 清空所有集合并重新初始化
 */

const mongoose = require('mongoose');
const { exec } = require('child_process');
require('dotenv').config();

// 导入所有模型
const {
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
  DbMetrics
} = require('../models');

// 数据库连接URI
const DB_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant';

/**
 * 重置数据库
 */
const resetDatabase = async () => {
  try {
    // 连接到数据库
    console.log(`正在连接到数据库: ${DB_URI}`);
    await mongoose.connect(DB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('数据库连接成功');

    // 清空所有集合
    console.log('正在清空所有集合...');
    await clearAllCollections();
    
    // 断开连接
    await mongoose.disconnect();
    console.log('数据库连接已断开');
    
    // 运行初始化脚本
    console.log('运行数据库初始化脚本...');
    await runScript('node backend/scripts/initializeDatabase.js');
    
    // 运行示例数据生成脚本
    console.log('运行示例数据生成脚本...');
    await runScript('node backend/scripts/generateSampleData.js');
    
    console.log('数据库重置和初始化完成');
  } catch (error) {
    console.error('数据库重置失败:', error);
    process.exit(1);
  }
};

/**
 * 清空所有集合
 */
const clearAllCollections = async () => {
  const collections = [
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
    DbMetrics
  ];
  
  for (const model of collections) {
    await model.deleteMany({});
    console.log(`已清空 ${model.collection.collectionName} 集合`);
  }
  
  console.log('所有集合已清空');
};

/**
 * 运行脚本
 */
const runScript = (scriptPath) => {
  return new Promise((resolve, reject) => {
    console.log(`执行脚本: ${scriptPath}`);
    
    const process = exec(scriptPath, (error, stdout, stderr) => {
      if (error) {
        console.error(`执行错误: ${error}`);
        return reject(error);
      }
      
      console.log(stdout);
      if (stderr) console.error(stderr);
      
      resolve();
    });
  });
};

// 执行重置
resetDatabase()
  .then(() => {
    console.log('数据库重置脚本执行完成');
    process.exit(0);
  })
  .catch(error => {
    console.error('重置脚本执行失败:', error);
    process.exit(1);
  }); 