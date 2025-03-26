/**
 * 检查分片数据库中的集合
 */

const { MongoClient } = require('mongodb');

// MongoDB连接配置
const DB_URI = 'mongodb://localhost:27017/smart_nutrition_restaurant';
const DB_NAME = 'smart_nutrition_restaurant';

async function checkShards() {
  let client;
  
  try {
    // 连接到MongoDB
    client = new MongoClient(DB_URI);
    await client.connect();
    console.log('MongoDB连接成功');
    
    const db = client.db(DB_NAME);
    
    // 获取所有集合
    const collections = await db.listCollections().toArray();
    const collectionNames = collections.map(c => c.name);
    
    console.log('数据库中的所有集合:');
    console.log(collectionNames);
    
    // 检查分片集合
    console.log('\n分片集合:');
    
    // 查找并显示分片集合
    const shardCollections = collectionNames.filter(name => 
      name.includes('_shard_') || 
      name.includes('_region_') || 
      name.includes('_user_') ||
      name.match(/_\d{4}_\d{2}$/) || // 年月格式
      name.match(/_\d{4}_q[1-4]$/)   // 年季度格式
    );
    
    if (shardCollections.length === 0) {
      console.log('未找到分片集合');
    } else {
      for (const shardName of shardCollections) {
        const count = await db.collection(shardName).countDocuments();
        console.log(`- ${shardName}: ${count} 文档`);
        
        if (count > 0) {
          const samples = await db.collection(shardName).find().limit(1).toArray();
          if (samples.length > 0) {
            console.log(`  示例文档ID: ${samples[0]._id}`);
          }
        }
      }
    }
    
    // 检查迁移状态
    const migrationStatus = await db.collection('migration_status').findOne({ _id: 'sharding_migration' });
    console.log('\n迁移状态:', migrationStatus || '未记录');
    
  } catch (error) {
    console.error('查询出错:', error);
  } finally {
    if (client) {
      await client.close();
      console.log('\n已关闭数据库连接');
    }
  }
}

// 执行检查
checkShards()
  .then(() => {
    console.log('检查完成');
    process.exit(0);
  })
  .catch(err => {
    console.error('检查失败:', err);
    process.exit(1);
  }); 