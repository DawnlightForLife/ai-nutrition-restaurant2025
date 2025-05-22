#!/usr/bin/env node

/**
 * 模式冻结验证脚本
 * 
 * 此脚本验证所有冻结的模式，确保它们未被修改
 * 在部署前运行此脚本可以防止意外的模式变更
 */

const mongoose = require('mongoose');
const fs = require('fs');
const path = require('path');
const chalk = require('chalk');
const SchemaGuardService = require('../services/core/schemaGuardService');
const config = require('../../config');

// 默认日志函数
const logger = {
  info: console.log,
  error: console.error,
  debug: console.log,
  warn: console.warn
};

// 状态计数器
const status = {
  verified: 0,
  changed: 0,
  errors: 0
};

// 变更详情
const changes = [];

/**
 * 连接数据库
 */
async function connectToDatabase() {
  try {
    logger.info(chalk.blue('🔄 连接到数据库...'));
    
    await mongoose.connect(config.mongodb.uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    logger.info(chalk.green('✅ 数据库连接成功'));
    return true;
  } catch (error) {
    logger.error(chalk.red(`❌ 数据库连接失败: ${error.message}`));
    return false;
  }
}

/**
 * 加载所有模型
 */
async function loadModels() {
  try {
    logger.info(chalk.blue('🔄 加载模型文件...'));
    
    const modelDir = path.join(__dirname, '../models');
    const modelFiles = fs.readdirSync(modelDir)
      .filter(file => file.endsWith('.js') && file !== 'index.js' && file !== 'modelFactory.js');
    
    // 加载每个模型文件
    for (const file of modelFiles) {
      require(path.join(modelDir, file));
    }
    
    logger.info(chalk.green(`✅ 已加载 ${modelFiles.length} 个模型文件`));
    return mongoose.modelNames();
  } catch (error) {
    logger.error(chalk.red(`❌ 加载模型失败: ${error.message}`));
    return [];
  }
}

/**
 * 验证所有模式
 */
async function verifyAllSchemas() {
  try {
    logger.info(chalk.blue('🔄 初始化 SchemaGuard 服务...'));
    
    // 创建服务实例
    const schemaGuard = new SchemaGuardService({
      securityChecks: true,
      autoFreeze: false
    });
    
    await schemaGuard.initialize();
    
    logger.info(chalk.green('✅ SchemaGuard 服务初始化完成'));
    
    // 获取所有冻结的模式
    const status = schemaGuard.getStatus();
    const frozenModels = status.frozenModels;
    
    if (frozenModels.length === 0) {
      logger.warn(chalk.yellow('⚠️ 没有找到任何冻结的模式'));
      return true;
    }
    
    logger.info(chalk.blue(`🔄 开始验证 ${frozenModels.length} 个冻结的模式...`));
    
    // 验证每个冻结的模式
    for (const modelName of frozenModels) {
      try {
        const model = mongoose.model(modelName);
        const result = await schemaGuard.validateModelStructure(modelName, model.schema);
        
        if (result.valid) {
          logger.info(chalk.green(`✅ 模式验证通过: ${modelName}`));
          status.verified++;
        } else {
          const errors = result.issues.filter(i => i.level === 'error');
          const warnings = result.issues.filter(i => i.level === 'warning');
          
          if (errors.length > 0) {
            logger.error(chalk.red(`❌ 模式验证失败: ${modelName}`));
            errors.forEach(e => logger.error(chalk.red(`   - ${e.message}`)));
            
            // 记录变更详情
            const changeInfo = errors.find(e => e.changes);
            if (changeInfo && changeInfo.changes) {
              changes.push({
                modelName,
                changes: changeInfo.changes
              });
            }
            
            status.changed++;
          } else {
            logger.warn(chalk.yellow(`⚠️ 模式验证有警告: ${modelName}`));
            warnings.forEach(w => logger.warn(chalk.yellow(`   - ${w.message}`)));
            status.verified++;
          }
        }
      } catch (error) {
        logger.error(chalk.red(`❌ 验证模式失败: ${modelName} - ${error.message}`));
        status.errors++;
      }
    }
    
    return status.changed === 0 && status.errors === 0;
  } catch (error) {
    logger.error(chalk.red(`❌ 验证模式过程失败: ${error.message}`));
    return false;
  }
}

/**
 * 生成验证报告
 */
function generateReport() {
  const total = status.verified + status.changed + status.errors;
  
  console.log('\n' + chalk.bold('=== 模式冻结验证报告 ==='));
  console.log(chalk.bold(`总计模式: ${total}`));
  console.log(chalk.green(`✅ 验证通过: ${status.verified}`));
  console.log(chalk.red(`❌ 发现变更: ${status.changed}`));
  console.log(chalk.yellow(`⚠️ 验证错误: ${status.errors}`));
  
  if (changes.length > 0) {
    console.log('\n' + chalk.bold('=== 模式变更详情 ==='));
    
    changes.forEach(item => {
      console.log(chalk.bold(`\n模型: ${item.modelName}`));
      
      if (item.changes.added && item.changes.added.length > 0) {
        console.log(chalk.green('新增字段:'));
        item.changes.added.forEach(field => {
          console.log(chalk.green(`  - ${field.path} (${field.type}${field.required ? ', 必需' : ''}) `));
        });
      }
      
      if (item.changes.removed && item.changes.removed.length > 0) {
        console.log(chalk.red('删除字段:'));
        item.changes.removed.forEach(field => {
          console.log(chalk.red(`  - ${field}`));
        });
      }
      
      if (item.changes.modified && item.changes.modified.length > 0) {
        console.log(chalk.yellow('修改字段:'));
        item.changes.modified.forEach(field => {
          console.log(chalk.yellow(`  - ${field.path} (${field.oldType} -> ${field.newType})`));
        });
      }
    });
  }
  
  return {
    success: status.changed === 0 && status.errors === 0,
    verified: status.verified,
    changed: status.changed,
    errors: status.errors
  };
}

/**
 * 主函数
 */
async function main() {
  try {
    // 连接数据库
    const connected = await connectToDatabase();
    if (!connected) process.exit(1);
    
    // 加载模型
    const modelNames = await loadModels();
    if (modelNames.length === 0) process.exit(1);
    
    // 验证模式
    const isValid = await verifyAllSchemas();
    
    // 生成报告
    const report = generateReport();
    
    // 断开数据库连接
    await mongoose.connection.close();
    
    // 根据验证结果返回状态码
    process.exit(report.success ? 0 : 1);
  } catch (error) {
    logger.error(chalk.red(`❌ 脚本执行失败: ${error.message}`));
    process.exit(1);
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  main();
}

module.exports = {
  verifyAllSchemas,
  generateReport
}; 