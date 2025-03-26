/**
 * 数据库分片迁移脚本
 * 将现有数据迁移到新的分片结构
 */

require('dotenv').config({ path: process.env.NODE_ENV === 'production' ? '../.env' : './.env.local' });
const mongoose = require('mongoose');
const dbManager = require('../config/database');
const shardingConfig = require('../config/shardingConfig');
const { shardingService } = require('../services/shardingService');

// 输出环境变量以进行调试
console.log('数据库连接信息:');
console.log(`- MONGO_PRIMARY_URI: ${process.env.MONGO_PRIMARY_URI}`);
console.log(`- MONGO_REPLICA_1_URI: ${process.env.MONGO_REPLICA_1_URI}`);
console.log(`- ENABLE_SHARDING: ${process.env.ENABLE_SHARDING}`);

// 要迁移的集合
const COLLECTIONS_TO_MIGRATE = [
  { name: 'AuditLog', model: require('../models/auditLogModel') },
  { name: 'HealthData', model: require('../models/healthDataModel') },
  { name: 'Order', model: require('../models/orderModel') },
  { name: 'User', model: require('../models/userModel') },
  { name: 'Merchant', model: require('../models/merchantModel') },
  { name: 'AiRecommendation', model: require('../models/aiRecommendationModel') },
  { name: 'ForumPost', model: require('../models/forumPostModel') },
  { name: 'DbMetrics', model: require('../models/modelFactory').model('DbMetrics') }
];

// 批次大小
const BATCH_SIZE = 500;

// 初始化分片服务
shardingService.init(shardingConfig);

/**
 * 迁移单个集合的数据
 * @param {String} collectionName 集合名称
 * @param {Model} model Mongoose模型
 */
async function migrateCollection(collectionName, model) {
  console.log(`开始迁移集合: ${collectionName}`);
  
  // 获取数据总数
  const totalCount = await model.countDocuments({});
  console.log(`- 总记录数: ${totalCount}`);
  
  if (totalCount === 0) {
    console.log(`- 无数据需要迁移`);
    return;
  }
  
  // 准备分片策略
  const strategy = shardingConfig.strategies[collectionName];
  if (!strategy) {
    console.log(`- 集合 ${collectionName} 没有定义分片策略，跳过`);
    return;
  }
  
  // 获取主连接和主集合
  const primaryConn = dbManager.getPrimaryConnection();
  const sourceCollection = primaryConn.collection(collectionName.toLowerCase());
  
  // 按批次处理数据
  let processedCount = 0;
  let cursor = sourceCollection.find({}).batchSize(BATCH_SIZE);
  
  // 记录分片映射 - 追踪每个分片有多少文档
  const shardCounts = {};
  
  // 迁移一批数据
  let batch = [];
  let doc = await cursor.next();
  
  while (doc) {
    processedCount++;
    
    // 根据分片策略确定目标分片
    let shardKey;
    
    switch (strategy.type) {
      case 'time':
        shardKey = doc.created_at || doc.timestamp || new Date();
        break;
      case 'hash':
        shardKey = doc._id.toString();
        break;
      case 'geo':
        if (doc.location && doc.location.coordinates) {
          shardKey = doc.location.coordinates;
        } else {
          shardKey = null; // 使用默认分片
        }
        break;
      case 'range':
        shardKey = doc[strategy.field] || 0;
        break;
      case 'user':
        shardKey = doc.user_id ? doc.user_id.toString() : doc._id.toString();
        break;
      default:
        shardKey = null;
    }
    
    // 获取分片集合名称
    const shardCollectionName = shardingService.getShardName(collectionName, shardKey);
    
    // 统计分片文档数
    shardCounts[shardCollectionName] = (shardCounts[shardCollectionName] || 0) + 1;
    
    // 添加到当前批次
    batch.push({
      document: doc,
      shardCollection: shardCollectionName
    });
    
    // 处理批次
    if (batch.length >= BATCH_SIZE) {
      await processBatch(batch, primaryConn);
      batch = [];
      console.log(`- 已处理: ${processedCount}/${totalCount} 文档`);
    }
    
    // 获取下一个文档
    doc = await cursor.next();
  }
  
  // 处理剩余的批次
  if (batch.length > 0) {
    await processBatch(batch, primaryConn);
  }
  
  // 输出分片统计信息
  console.log(`- 迁移完成，共处理 ${processedCount} 文档`);
  console.log('- 分片分布:');
  for (const [shard, count] of Object.entries(shardCounts)) {
    console.log(`  - ${shard}: ${count} 文档`);
  }
}

/**
 * 处理一批文档
 * @param {Array} batch 文档批次
 * @param {Connection} conn Mongoose连接
 */
async function processBatch(batch, conn) {
  // 按分片分组
  const shardGroups = {};
  
  for (const item of batch) {
    if (!shardGroups[item.shardCollection]) {
      shardGroups[item.shardCollection] = [];
    }
    shardGroups[item.shardCollection].push(item.document);
  }
  
  // 并行写入各个分片
  const operations = Object.entries(shardGroups).map(async ([shardCollection, docs]) => {
    const collection = conn.collection(shardCollection);
    if (docs.length > 0) {
      try {
        await collection.insertMany(docs, { ordered: false });
      } catch (error) {
        // 处理可能的重复键错误
        if (error.code === 11000) {
          console.log(`- 忽略重复键错误: ${error.message.substring(0, 100)}...`);
        } else {
          throw error;
        }
      }
    }
  });
  
  await Promise.all(operations);
}

/**
 * 主迁移函数
 */
async function migrateData() {
  try {
    console.log('开始数据迁移流程');
    
    // 连接数据库
    console.log('尝试连接到数据库...');
    try {
      await dbManager.connect();
      console.log('数据库连接成功');
    } catch (connError) {
      console.error('数据库连接失败，尝试直接连接MongoDB:', connError);
      
      // 尝试直接使用mongoose连接
      try {
        await mongoose.connect(process.env.MONGO_PRIMARY_URI, {
          useNewUrlParser: true,
          useUnifiedTopology: true
        });
        console.log('使用直接连接成功');
        
        // 手动设置dbManager的连接状态
        dbManager.primaryConnection = mongoose.connection;
        dbManager.isConnected = true;
      } catch (directConnError) {
        console.error('直接连接也失败:', directConnError);
        throw directConnError;
      }
    }
    
    // 对每个集合进行迁移
    for (const collection of COLLECTIONS_TO_MIGRATE) {
      await migrateCollection(collection.name, collection.model);
    }
    
    console.log('所有集合迁移完成');
  } catch (error) {
    console.error('迁移过程出错:', error);
  } finally {
    // 关闭数据库连接
    await dbManager.close();
    console.log('已关闭数据库连接');
    process.exit(0);
  }
}

// 执行迁移
migrateData(); 