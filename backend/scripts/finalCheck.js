/**
 * 最终检查脚本
 */
const { MongoClient } = require('mongodb');

async function finalCheck() {
  const client = new MongoClient('mongodb://localhost:27017/smart_nutrition_restaurant');
  
  try {
    await client.connect();
    console.log('已连接到MongoDB');
    
    const db = client.db('smart_nutrition_restaurant');
    
    // 列出所有集合
    const collections = await db.listCollections().toArray();
    console.log('\n所有集合:');
    console.log(collections.map(c => c.name));
    
    // 检查分片集合内容
    console.log('\n分片内容:');
    
    const user_shard_0 = await db.collection('user_shard_0').find().toArray();
    console.log('\nuser_shard_0:', JSON.stringify(user_shard_0, null, 2));
    
    const user_shard_1 = await db.collection('user_shard_1').find().toArray();
    console.log('\nuser_shard_1:', JSON.stringify(user_shard_1, null, 2));
    
    // 检查迁移状态
    const migrationStatus = await db.collection('migration_status').findOne({ _id: 'sharding_migration' });
    console.log('\n迁移状态:', JSON.stringify(migrationStatus, null, 2));
    
  } catch (error) {
    console.error('检查出错:', error);
  } finally {
    await client.close();
    console.log('\n已关闭数据库连接');
  }
}

finalCheck().catch(console.error); 