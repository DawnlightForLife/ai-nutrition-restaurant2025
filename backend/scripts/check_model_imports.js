/**
 * 脚本：检查所有模型文件是否正确导入了ModelFactory
 * 
 * 运行方式：node backend/scripts/check_model_imports.js
 */

const fs = require('fs');
const path = require('path');

// 模型文件目录
const MODELS_DIR = path.resolve(__dirname, '../models');

// 不需要检查的文件
const EXCLUDE_FILES = ['modelFactory.js', 'index.js'];

// 要添加的import语句
const MODEL_FACTORY_IMPORT = "const ModelFactory = require('./modelFactory');";

// 处理所有模型文件
async function processModelFiles() {
  console.log('检查模型文件的ModelFactory导入...');
  
  try {
    // 读取模型目录中的所有文件
    const files = fs.readdirSync(MODELS_DIR);
    
    // 遍历所有.js文件
    for (const file of files) {
      if (!file.endsWith('.js') || EXCLUDE_FILES.includes(file)) {
        continue;
      }
      
      const filePath = path.join(MODELS_DIR, file);
      const content = fs.readFileSync(filePath, 'utf8');
      
      // 检查文件是否使用了ModelFactory
      if (content.includes('ModelFactory.model(')) {
        // 检查是否已经导入了ModelFactory
        if (!content.includes("require('./modelFactory')")) {
          console.log(`需要修复: ${file}`);
          
          // 找到第一个require语句
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
        } else {
          console.log(`已经正确导入: ${file}`);
        }
      } else {
        console.log(`不需要ModelFactory: ${file}`);
      }
    }
    
    console.log('所有文件检查完成');
  } catch (error) {
    console.error('处理文件时出错:', error);
  }
}

// 执行脚本
processModelFiles().catch(console.error); 