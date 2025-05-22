/**
 * 营养档案枚举值标准化迁移脚本
 * 将ageGroup和nutritionGoals字段统一为标准化格式
 */

const mongoose = require('mongoose');
const dotenv = require('dotenv');
const { MongoClient } = require('mongodb');

// 加载环境变量
dotenv.config();

// 数据库连接配置
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant';

// 连接到MongoDB数据库
async function connectToDatabase() {
  console.log('正在连接到数据库...');
  try {
    const client = await MongoClient.connect(MONGODB_URI);
    console.log('数据库连接成功!');
    return client;
  } catch (error) {
    console.error('数据库连接失败:', error);
    process.exit(1);
  }
}

// 定义映射关系
const ageGroupMapping = {
  // 旧值到新值的映射
  'under18': 'under18',
  'age18to30': '18to30',
  'age31to45': '31to45',
  'age46to60': '46to60',
  'above60': 'above60',
  'under_18': 'under18',
  '18_30': '18to30',
  '31_45': '31to45',
  '46_60': '46to60',
  'above_60': 'above60',
  'child': 'under18',
  'youngAdult': '18to30',
  'middleAdult': '31to45',
  'senior': 'above60'
};

const nutritionGoalsMapping = {
  // 旧值到新值的映射
  'generalHealth': 'generalHealth',
  'weightLoss': 'weightLoss',
  'weightGain': 'weightGain',
  'muscleBuilding': 'muscleBuilding',
  'energyBoost': 'energyBoost',
  'diseaseManagement': 'generalHealth', // 将旧的疾病管理归为一般健康
  'weight_loss': 'weightLoss',
  'weight_gain': 'weightGain',
  'muscle_gain': 'muscleBuilding',
  'general_health': 'generalHealth',
  'immunity_boost': 'immunityBoost',
  'blood_sugar_control': 'bloodSugarControl',
  'blood_pressure_control': 'bloodPressureControl',
  'energy_boost': 'energyBoost'
};

// 更新营养档案的枚举值
async function migrateNutritionProfileEnums(db) {
  console.log('开始更新营养档案枚举值...');
  const profileCollection = db.collection('nutritionprofiles');
  
  // 获取所有营养档案
  const profiles = await profileCollection.find({}).toArray();
  console.log(`找到 ${profiles.length} 条营养档案记录`);
  
  let updatedCount = 0;
  
  // 遍历所有档案进行更新
  for (const profile of profiles) {
    try {
      let needsUpdate = false;
      const updates = {};
      
      // 检查并更新ageGroup
      if (profile.ageGroup && ageGroupMapping[profile.ageGroup]) {
        updates.ageGroup = ageGroupMapping[profile.ageGroup];
        needsUpdate = true;
      }
      
      // 检查并更新nutritionGoals
      if (profile.nutritionGoals && Array.isArray(profile.nutritionGoals)) {
        const updatedGoals = profile.nutritionGoals.map(goal => {
          return nutritionGoalsMapping[goal] || 'generalHealth'; // 找不到映射关系的默认为generalHealth
        });
        
        // 仅当有变化时才更新
        if (JSON.stringify(updatedGoals) !== JSON.stringify(profile.nutritionGoals)) {
          updates.nutritionGoals = updatedGoals;
          needsUpdate = true;
        }
      }
      
      // 如果需要更新，则执行更新操作
      if (needsUpdate) {
        const result = await profileCollection.updateOne(
          { _id: profile._id },
          { $set: updates }
        );
        
        if (result.modifiedCount > 0) {
          updatedCount++;
        }
      }
    } catch (error) {
      console.error(`更新营养档案 ${profile._id} 时出错:`, error);
    }
  }
  
  console.log(`成功更新 ${updatedCount} 条营养档案记录`);
}

// 添加日志记录迁移过程
async function logMigration(db) {
  try {
    const migrationCollection = db.collection('system_migrations');
    await migrationCollection.insertOne({
      migration_name: 'nutrition_profile_enum_standardization',
      executed_at: new Date(),
      status: 'success',
      details: '将ageGroup和nutritionGoals字段统一为标准化格式'
    });
    console.log('迁移记录已添加到系统迁移表');
  } catch (error) {
    console.error('记录迁移信息失败:', error);
  }
}

// 主函数
async function migrateDatabase() {
  console.log('开始执行营养档案枚举值标准化迁移');
  let client;
  
  try {
    client = await connectToDatabase();
    const db = client.db();
    
    // 执行迁移操作
    await migrateNutritionProfileEnums(db);
    
    // 记录迁移过程
    await logMigration(db);
    
    console.log('营养档案枚举值标准化迁移成功完成!');
  } catch (error) {
    console.error('迁移过程中出错:', error);
  } finally {
    if (client) {
      await client.close();
      console.log('数据库连接已关闭');
    }
  }
}

// 执行迁移
migrateDatabase(); 