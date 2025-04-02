/**
 * 独立的数据库分片迁移脚本
 * 直接连接MongoDB，不依赖数据库管理器
 */

const { MongoClient } = require('mongodb');
const fs = require('fs');
const path = require('path');

// MongoDB连接配置
const DB_URI = 'mongodb://localhost:27017/ai-nutrition-restaurant';
const DB_NAME = 'ai-nutrition-restaurant';

// 分片配置
const shardingConfig = {
  strategies: {
    AuditLog: {
      enabled: true,
      type: 'time',
      timeUnit: 'month'
    },
    HealthData: {
      enabled: true,
      type: 'user',
      shards: 5
    },
    Order: {
      enabled: true,
      type: 'time',
      timeUnit: 'month'
    },
    User: {
      enabled: true,
      type: 'hash',
      shards: 3
    },
    Merchant: {
      enabled: true,
      type: 'geo'
    },
    AiRecommendation: {
      enabled: true,
      type: 'user',
      shards: 5
    },
    ForumPost: {
      enabled: true,
      type: 'time',
      timeUnit: 'quarter'
    },
    DbMetric: {
      enabled: true,
      type: 'time',
      timeUnit: 'year'
    }
  }
};

// 集合名称与策略名称的映射
const COLLECTION_TO_STRATEGY = {
  'auditlogs': 'AuditLog',
  'healthdata': 'HealthData',
  'orders': 'Order',
  'users': 'User',
  'merchants': 'Merchant',
  'airecommendations': 'AiRecommendation',
  'forumposts': 'ForumPost',
  'dbmetrics': 'DbMetric'
};

// 要迁移的集合
const COLLECTIONS_TO_MIGRATE = [
  'auditlogs',
  'healthdata',
  'orders',
  'users',
  'merchants',
  'airecommendations',
  'forumposts',
  'dbmetrics'
];

// 批次大小
const BATCH_SIZE = 500;

// 获取分片名称
function getShardName(collectionName, key, strategy) {
  const collBaseName = collectionName.endsWith('s') 
    ? collectionName.slice(0, -1) 
    : collectionName;
  
  const now = new Date();
  
  switch (strategy.type) {
    case 'time':
      const date = key instanceof Date ? key : now;
      const year = date.getFullYear();
      let timePart;
      
      if (strategy.timeUnit === 'month') {
        const month = date.getMonth() + 1;
        timePart = `${year}_${month.toString().padStart(2, '0')}`;
      } else if (strategy.timeUnit === 'quarter') {
        const quarter = Math.floor(date.getMonth() / 3) + 1;
        timePart = `${year}_q${quarter}`;
      } else if (strategy.timeUnit === 'year') {
        timePart = `${year}`;
      } else {
        // 默认按月
        const month = date.getMonth() + 1;
        timePart = `${year}_${month.toString().padStart(2, '0')}`;
      }
      
      return `${collBaseName}_${timePart}`;
      
    case 'hash':
      const hash = typeof key === 'string' ? key : String(key);
      const hashCode = hash.split('').reduce((a, b) => {
        a = ((a << 5) - a) + b.charCodeAt(0);
        return a & a;
      }, 0);
      const shardIndex = Math.abs(hashCode) % (strategy.shards || 3);
      return `${collBaseName}_shard_${shardIndex}`;
      
    case 'geo':
      if (Array.isArray(key) && key.length === 2) {
        const [longitude, latitude] = key;
        // 简化的地理区域划分
        const region = Math.floor((longitude + 180) / 90) * 4 + Math.floor((latitude + 90) / 45);
        return `${collBaseName}_region_${region}`;
      }
      return `${collBaseName}_region_default`;
      
    case 'range':
      const value = typeof key === 'number' ? key : 0;
      let rangeName = 'default';
      
      if (strategy.ranges && Array.isArray(strategy.ranges)) {
        for (let i = 0; i < strategy.ranges.length; i++) {
          const range = strategy.ranges[i];
          if (value >= range.min && value < range.max) {
            rangeName = range.name;
            break;
          }
        }
      }
      
      return `${collBaseName}_${rangeName}`;
      
    case 'user':
      const userId = typeof key === 'string' ? key : String(key);
      const userHash = userId.split('').reduce((a, b) => {
        a = ((a << 5) - a) + b.charCodeAt(0);
        return a & a;
      }, 0);
      const userShardIndex = Math.abs(userHash) % (strategy.shards || 5);
      return `${collBaseName}_user_${userShardIndex}`;
      
    default:
      return collectionName;
  }
}

/**
 * 迁移单个集合的数据
 */
async function migrateCollection(db, collectionName) {
  console.log(`开始迁移集合: ${collectionName}`);
  
  // 获取策略
  const strategyName = COLLECTION_TO_STRATEGY[collectionName];
  
  const strategy = shardingConfig.strategies[strategyName];
  if (!strategy || !strategy.enabled) {
    console.log(`- 集合 ${collectionName} 没有启用分片策略，跳过`);
    return;
  }
  
  const sourceCollection = db.collection(collectionName);
  
  // 获取数据总数
  const totalCount = await sourceCollection.countDocuments();
  console.log(`- 总记录数: ${totalCount}`);
  
  if (totalCount === 0) {
    console.log(`- 无数据需要迁移`);
    return;
  }
  
  // 按批次处理数据
  let processedCount = 0;
  let cursor = sourceCollection.find({}).batchSize(BATCH_SIZE);
  
  // 记录分片映射
  const shardCounts = {};
  
  let batch = [];
  let doc = await cursor.next();
  
  while (doc) {
    processedCount++;
    
    // 确定目标分片
    let shardKey;
    
    switch (strategy.type) {
      case 'time':
        shardKey = doc.created_at || doc.timestamp || doc.createdAt || new Date();
        break;
      case 'hash':
        shardKey = doc._id.toString();
        break;
      case 'geo':
        if (doc.location && doc.location.coordinates) {
          shardKey = doc.location.coordinates;
        } else {
          shardKey = null;
        }
        break;
      case 'range':
        shardKey = doc[strategy.field] || 0;
        break;
      case 'user':
        shardKey = doc.user_id || doc.userId || doc.ownerId || doc._id.toString();
        shardKey = shardKey.toString();
        break;
      default:
        shardKey = null;
    }
    
    // 获取分片集合名称
    const shardCollectionName = getShardName(collectionName, shardKey, strategy);
    
    // 统计分片文档数
    shardCounts[shardCollectionName] = (shardCounts[shardCollectionName] || 0) + 1;
    
    // 添加到当前批次
    batch.push({
      document: doc,
      shardCollection: shardCollectionName
    });
    
    // 处理批次
    if (batch.length >= BATCH_SIZE) {
      await processBatch(db, batch);
      batch = [];
      console.log(`- 已处理: ${processedCount}/${totalCount} 文档`);
    }
    
    // 获取下一个文档
    doc = await cursor.next();
  }
  
  // 处理剩余的批次
  if (batch.length > 0) {
    await processBatch(db, batch);
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
 */
async function processBatch(db, batch) {
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
    try {
      const collection = db.collection(shardCollection);
      
      // 确保目标集合存在
      // 使用update操作代替insert，以便处理可能的重复键问题
      const bulkOps = docs.map(doc => ({
        updateOne: {
          filter: { _id: doc._id },
          update: { $set: doc },
          upsert: true
        }
      }));
      
      if (bulkOps.length > 0) {
        await collection.bulkWrite(bulkOps);
      }
    } catch (error) {
      console.error(`- 批处理写入错误 ${shardCollection}:`, error);
    }
  });
  
  await Promise.all(operations);
}

/**
 * 主迁移函数
 */
async function migrateData() {
  let client;
  
  try {
    console.log('开始数据分片迁移流程');
    console.log(`使用连接: ${DB_URI}`);
    
    // 直接连接到MongoDB
    client = new MongoClient(DB_URI);
    await client.connect();
    console.log('MongoDB连接成功');
    
    const db = client.db(DB_NAME);
    
    // 对每个集合进行迁移
    for (const collection of COLLECTIONS_TO_MIGRATE) {
      await migrateCollection(db, collection);
    }
    
    console.log('所有集合迁移完成');
    
    // 记录迁移完成状态
    await db.collection('migration_status').updateOne(
      { _id: 'sharding_migration' },
      { 
        $set: { 
          completed: true,
          timestamp: new Date()
        } 
      },
      { upsert: true }
    );
    
  } catch (error) {
    console.error('迁移过程出错:', error);
  } finally {
    // 关闭数据库连接
    if (client) {
      await client.close();
      console.log('已关闭数据库连接');
    }
  }
}

// 执行迁移
migrateData()
  .then(() => {
    console.log('迁移脚本执行完成');
    process.exit(0);
  })
  .catch(err => {
    console.error('迁移脚本执行失败:', err);
    process.exit(1);
  }); 