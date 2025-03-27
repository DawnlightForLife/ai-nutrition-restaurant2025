/**
 * 生产环境中的模型导入修复脚本
 * 
 * 此脚本用于在容器环境中检查和修复模型文件的ModelFactory导入
 * 运行方式: node fix_model_imports_prod.js
 */

const fs = require('fs');
const path = require('path');

// 生产环境中的模型目录路径
const MODELS_DIR = '/usr/src/app/models';

// 要添加的import语句
const MODEL_FACTORY_IMPORT = "const ModelFactory = require('./modelFactory');";

console.log('开始检查生产环境模型文件的ModelFactory导入...');

// 确保目录存在
if (!fs.existsSync(MODELS_DIR)) {
  console.error(`错误: 目录不存在 ${MODELS_DIR}`);
  process.exit(1);
}

// 获取所有模型文件
const files = fs.readdirSync(MODELS_DIR).filter(f => 
  f.endsWith('.js') && f !== 'modelFactory.js' && f !== 'index.js'
);

console.log(`找到 ${files.length} 个模型文件`);

// 检查和修复每个文件
let fixedCount = 0;
let alreadyOkCount = 0;
let errorCount = 0;

for (const file of files) {
  try {
    const filePath = path.join(MODELS_DIR, file);
    console.log(`处理文件: ${filePath}`);
    
    // 读取文件内容
    const content = fs.readFileSync(filePath, 'utf8');
    
    // 检查文件是否使用ModelFactory但没有导入
    if (content.includes('ModelFactory.model(') && !content.includes("require('./modelFactory')")) {
      console.log(`修复文件: ${file}`);
      
      // 找到第一个require语句，在它后面添加ModelFactory的导入
      const lines = content.split('\n');
      let insertIndex = 0;
      
      for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes('require(')) {
          insertIndex = i + 1;
          break;
        }
      }
      
      // 添加ModelFactory导入
      lines.splice(insertIndex, 0, MODEL_FACTORY_IMPORT);
      
      // 写回文件
      fs.writeFileSync(filePath, lines.join('\n'), 'utf8');
      console.log(`已修复: ${file}`);
      fixedCount++;
    } else if (content.includes('ModelFactory.model(')) {
      console.log(`文件已正确导入ModelFactory: ${file}`);
      alreadyOkCount++;
    } else {
      console.log(`文件不需要ModelFactory: ${file}`);
    }
  } catch (error) {
    console.error(`处理文件 ${file} 时出错:`, error);
    errorCount++;
  }
}

console.log('\n修复摘要:');
console.log(`- 已修复的文件: ${fixedCount}`);
console.log(`- 已经正确的文件: ${alreadyOkCount}`);
console.log(`- 处理出错的文件: ${errorCount}`);
console.log('修复完成!'); 