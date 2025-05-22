/**
 * 应用启动前检查脚本
 * 
 * 确保所有必要的依赖和配置都正确设置
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

console.log('执行启动前检查...');

// 检查模型导入
function checkModelImports() {
  console.log('检查模型导入...');
  
  // 检查是否在生产环境
  const inProduction = process.env.NODE_ENV === 'production';
  const modelsDir = inProduction ? '/usr/src/app/models' : path.join(__dirname, '../models');
  
  if (!fs.existsSync(modelsDir)) {
    console.error(`错误: 模型目录不存在 (${modelsDir})`);
    return false;
  }
  
  try {
    // 根据环境运行不同的修复脚本
    if (inProduction) {
      const fixScript = path.join(__dirname, 'fix_model_imports_prod.js');
      if (fs.existsSync(fixScript)) {
        console.log('运行生产环境模型导入修复脚本...');
        execSync(`node ${fixScript}`, { stdio: 'inherit' });
      } else {
        console.error('错误: 生产环境修复脚本不存在');
        return false;
      }
    } else {
      const fixScript = path.join(__dirname, 'check_model_imports.js');
      if (fs.existsSync(fixScript)) {
        console.log('运行开发环境模型导入检查脚本...');
        execSync(`node ${fixScript}`, { stdio: 'inherit' });
      } else {
        console.error('错误: 开发环境检查脚本不存在');
        return false;
      }
    }
    
    return true;
  } catch (error) {
    console.error('检查模型导入时出错:', error);
    return false;
  }
}

// 检查数据库连接配置
function checkDbConfig() {
  console.log('检查数据库配置...');
  
  try {
    // 确保数据库配置存在
    const dbConfigPath = path.join(__dirname, '../config/modules/db.config');
    if (!fs.existsSync(dbConfigPath)) {
      console.error('错误: 数据库配置不存在');
      return false;
    }
    
    return true;
  } catch (error) {
    console.error('检查数据库配置时出错:', error);
    return false;
  }
}

// 运行所有检查
function runAllChecks() {
  const checks = [
    { name: '模型导入检查', func: checkModelImports },
    { name: '数据库配置检查', func: checkDbConfig }
  ];
  
  let allPassed = true;
  
  for (const check of checks) {
    console.log(`\n执行检查: ${check.name}`);
    const passed = check.func();
    console.log(`${check.name}: ${passed ? '通过' : '失败'}`);
    
    if (!passed) {
      allPassed = false;
    }
  }
  
  return allPassed;
}

// 执行所有检查并输出结果
const checksPassed = runAllChecks();
console.log(`\n启动前检查 ${checksPassed ? '全部通过' : '存在问题'}`);

// 如果是作为独立脚本执行的，则根据检查结果设置退出码
if (require.main === module) {
  process.exit(checksPassed ? 0 : 1);
}

// 导出检查结果，以便其他模块可以使用
module.exports = {
  checksPassed
}; 