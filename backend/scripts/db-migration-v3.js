/**
 * 数据库迁移脚本 - 版本3.0
 * 用于更新HealthData模型结构，增加新字段并保持与NutritionProfile模型的同步
 */

const mongoose = require('mongoose');
const dotenv = require('dotenv');
const { MongoClient, ObjectId } = require('mongodb');

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

// 升级HealthData集合的文档结构
async function upgradeHealthDataSchema(db) {
  console.log('开始升级HealthData集合...');
  const healthDataCollection = db.collection('healthdata');

  // 获取所有健康数据文档
  const healthDataDocs = await healthDataCollection.find({}).toArray();
  console.log(`找到 ${healthDataDocs.length} 条健康数据记录`);

  // 更新计数器
  let updatedCount = 0;

  // 遍历并更新每个文档
  for (const doc of healthDataDocs) {
    try {
      // 1. 添加字符串格式的ID字段
      const updates = {
        userId: doc.user_id ? doc.user_id.toString() : null,
        nutritionProfileId: doc.nutrition_profile_id ? doc.nutrition_profile_id.toString() : null,
      };

      // 2. 添加新的健康建议字段
      if (!doc.health_advice) {
        updates.health_advice = {
          nutrition_suggestions: [],
          lifestyle_changes: [],
          exercise_plan: '',
          diet_restrictions: [],
          recommended_supplements: [],
          monitoring_plan: ''
        };
      }

      // 3. 添加分析历史
      if (!doc.analysis_history) {
        updates.analysis_history = [];
      }

      // 4. 添加同步历史
      if (!doc.sync_history) {
        updates.sync_history = [];
        
        // 如果之前已同步过，添加一条同步记录
        if (doc.synced_to_profile) {
          updates.sync_history.push({
            synced_at: doc.updated_at || new Date(),
            profile_id: doc.nutrition_profile_id,
            sync_type: 'legacy',
            sync_status: 'success',
            sync_details: '系统迁移自动添加的同步记录'
          });
        }
      }

      // 5. 添加数据来源信息
      if (!doc.data_source) {
        updates.data_source = {
          source_type: 'manual',
          device_info: '',
          app_version: '',
          import_file: ''
        };
      }

      // 6. 添加验证信息
      if (!doc.validation) {
        updates.validation = {
          is_validated: false,
          validated_by: '',
          validation_date: null,
          validation_method: ''
        };
      }

      // 执行更新
      const result = await healthDataCollection.updateOne(
        { _id: doc._id },
        { $set: updates }
      );

      if (result.modifiedCount > 0) {
        updatedCount++;
      }
    } catch (error) {
      console.error(`更新文档 ${doc._id} 时出错:`, error);
    }
  }

  console.log(`成功更新 ${updatedCount} 条健康数据记录`);
}

// 更新NutritionProfile和HealthData之间的关联
async function updateProfileHealthDataRelations(db) {
  console.log('开始更新NutritionProfile和HealthData之间的关联...');
  
  const profileCollection = db.collection('nutritionprofiles');
  const healthDataCollection = db.collection('healthdata');

  // 获取所有营养档案
  const profiles = await profileCollection.find({}).toArray();
  console.log(`找到 ${profiles.length} 条营养档案记录`);

  let updatedCount = 0;

  // 遍历营养档案
  for (const profile of profiles) {
    try {
      // 查找与此档案关联的健康数据
      const relatedHealthData = await healthDataCollection.find({
        nutrition_profile_id: profile._id
      }).toArray();

      // 更新profile中的related_health_data字段
      if (relatedHealthData.length > 0) {
        const healthDataIds = relatedHealthData.map(data => data._id);
        
        // 执行更新
        const result = await profileCollection.updateOne(
          { _id: profile._id },
          { $set: { related_health_data: healthDataIds } }
        );

        if (result.modifiedCount > 0) {
          updatedCount++;
        }

        // 更新每个健康数据的同步状态
        for (const data of relatedHealthData) {
          if (!data.sync_history || data.sync_history.length === 0) {
            await healthDataCollection.updateOne(
              { _id: data._id },
              { 
                $set: { 
                  synced_to_profile: true 
                },
                $push: { 
                  sync_history: {
                    synced_at: new Date(),
                    profile_id: profile._id,
                    sync_type: 'migration',
                    sync_status: 'success',
                    sync_details: '通过迁移脚本自动关联'
                  }
                }
              }
            );
          }
        }
      }
    } catch (error) {
      console.error(`更新营养档案 ${profile._id} 关联时出错:`, error);
    }
  }

  console.log(`成功更新 ${updatedCount} 条营养档案与健康数据的关联`);
}

// 主函数
async function migrateDatabase() {
  console.log('开始数据库迁移 - 版本3.0');
  let client;

  try {
    client = await connectToDatabase();
    const db = client.db();

    // 执行迁移操作
    await upgradeHealthDataSchema(db);
    await updateProfileHealthDataRelations(db);

    console.log('数据库迁移成功完成!');
  } catch (error) {
    console.error('数据库迁移失败:', error);
  } finally {
    if (client) {
      await client.close();
      console.log('数据库连接已关闭');
    }
  }
}

// 执行迁移
migrateDatabase(); 