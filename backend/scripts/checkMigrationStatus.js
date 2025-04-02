/**
 * 检查迁移状态
 */
const mongoose = require('mongoose');
const { MongoClient } = require('mongodb');

async function checkMigrationStatus() {
  const client = new MongoClient('mongodb://localhost:27017/ai-nutrition-restaurant');
  
  try {
    await client.connect();
    console.log('已连接到MongoDB');
    
    const db = client.db('smart_nutrition_restaurant');
    
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

checkMigrationStatus().catch(console.error); 