const mongoose = require('mongoose');
const { MongoClient } = require('mongodb');

// MongoDB连接配置
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/smart_nutrition_restaurant';

// MongoDB连接选项
const options = {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 30000, // 服务器选择超时时间
  socketTimeoutMS: 30000, // Socket超时时间
  connectTimeoutMS: 30000, // 连接超时时间
  maxPoolSize: 10, // 连接池大小
  minPoolSize: 5, // 最小连接池大小
  retryWrites: true, // 启用重试写入
  w: 'majority', // 写入确认级别
  readPreference: 'secondaryPreferred' // 读取偏好
};

// 创建MongoDB客户端
const client = new MongoClient(MONGO_URI, options);

// 数据库连接
const connect = async () => {
  try {
    await client.connect();
    console.log('MongoDB连接成功');
    
    // 获取数据库实例
    const db = client.db();
    
    // 初始化分片集合索引
    if (process.env.ENABLE_SHARDING === 'true') {
      await initShardCollectionIndexes(db);
    }
    
    return db;
  } catch (error) {
    console.error('MongoDB连接失败:', error);
    throw error;
  }
};

// 初始化分片集合索引
const initShardCollectionIndexes = async (db) => {
  try {
    // 用户分片索引
    const userShardCollections = await db.listCollections({ name: /^user_shard_/ }).toArray();
    for (const collection of userShardCollections) {
      await db.collection(collection.name).createIndex({ phone: 1 }, { unique: true });
    }
    
    // 健康数据分片索引
    const healthDataCollections = await db.listCollections({ name: /^healthdata_user_/ }).toArray();
    for (const collection of healthDataCollections) {
      await db.collection(collection.name).createIndex({ userId: 1 });
    }
    
    // 订单分片索引
    const orderCollections = await db.listCollections({ name: /^order_/ }).toArray();
    for (const collection of orderCollections) {
      await db.collection(collection.name).createIndex({ userId: 1 });
      await db.collection(collection.name).createIndex({ createdAt: 1 });
    }
    
    // 商家分片索引
    const merchantCollections = await db.listCollections({ name: /^merchant_region_/ }).toArray();
    for (const collection of merchantCollections) {
      await db.collection(collection.name).createIndex({ region: 1 });
    }
    
    console.log('分片集合索引初始化完成');
  } catch (error) {
    console.error('初始化分片集合索引失败:', error);
    throw error;
  }
};

// 关闭数据库连接
const close = async () => {
  try {
    await client.close();
    console.log('MongoDB连接已关闭');
  } catch (error) {
    console.error('关闭MongoDB连接失败:', error);
    throw error;
  }
};

module.exports = {
  connect,
  close,
  client
}; 