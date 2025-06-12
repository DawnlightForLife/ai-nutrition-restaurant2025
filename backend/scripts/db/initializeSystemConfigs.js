/**
 * 初始化系统配置脚本
 * 用于在应用启动时初始化默认的系统配置
 */

const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

const SystemConfig = require('../../models/core/systemConfigModel');
const systemConfigService = require('../../services/core/systemConfigService');

async function initializeSystemConfigs() {
  try {
    console.log('开始初始化系统配置...');
    
    // 连接数据库
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/nutrition_restaurant', {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    console.log('数据库连接成功');
    
    // 初始化默认配置
    await systemConfigService.initializeDefaults();
    
    // 验证配置是否正确初始化
    const certConfigs = await systemConfigService.getCertificationConfigs();
    console.log('认证功能配置:', certConfigs);
    
    console.log('系统配置初始化完成');
    
  } catch (error) {
    console.error('系统配置初始化失败:', error);
    process.exit(1);
  } finally {
    await mongoose.connection.close();
    console.log('数据库连接已关闭');
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  initializeSystemConfigs()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });
}

module.exports = { initializeSystemConfigs };