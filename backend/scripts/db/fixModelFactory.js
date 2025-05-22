/**
 * 修复ModelFactory方法调用脚本
 * 将所有使用ModelFactory.model的地方替换为ModelFactory.createModel
 */
const fs = require('fs');
const path = require('path');
const { promisify } = require('util');

const readFileAsync = promisify(fs.readFile);
const writeFileAsync = promisify(fs.writeFile);
const readDirAsync = promisify(fs.readdir);
const statAsync = promisify(fs.stat);

/**
 * 递归获取指定目录下的所有文件
 * @param {string} dir - 目录路径
 * @param {Array} fileList - 文件列表
 * @returns {Promise<Array>} 文件路径列表
 */
async function getAllFiles(dir, fileList = []) {
  const files = await readDirAsync(dir);
  
  for (const file of files) {
    const filePath = path.join(dir, file);
    const stat = await statAsync(filePath);
    
    if (stat.isDirectory()) {
      await getAllFiles(filePath, fileList);
    } else if (file.endsWith('.js')) {
      fileList.push(filePath);
    }
  }
  
  return fileList;
}

/**
 * 修复单个文件中的ModelFactory.model调用
 * @param {string} filePath - 文件路径
 * @returns {Promise<boolean>} 是否修改了文件
 */
async function fixFile(filePath) {
  try {
    const content = await readFileAsync(filePath, 'utf8');
    
    // 检查文件中是否包含ModelFactory.model
    const pattern = /ModelFactory\.model\(/g;
    if (!pattern.test(content)) {
      return false;
    }
    
    // 替换ModelFactory.model为ModelFactory.createModel
    const updatedContent = content.replace(/ModelFactory\.model\(/g, 'ModelFactory.createModel(');
    
    // 替换modelFactory.model为modelFactory.createModel
    const finalContent = updatedContent.replace(/modelFactory\.model\(/g, 'modelFactory.createModel(');
    
    // 如果内容没有变化，则不需要写入
    if (content === finalContent) {
      return false;
    }
    
    // 写入修改后的内容
    await writeFileAsync(filePath, finalContent, 'utf8');
    console.log(`已修复文件: ${filePath}`);
    return true;
  } catch (error) {
    console.error(`处理文件 ${filePath} 时出错:`, error);
    return false;
  }
}

/**
 * 主函数
 */
async function main() {
  try {
    console.log('开始修复ModelFactory方法调用...');
    
    // 获取模型目录的所有JS文件
    const modelFiles = await getAllFiles(path.join(__dirname, '../models'));
    console.log(`找到 ${modelFiles.length} 个模型文件需要检查`);
    
    // 获取工具目录的JS文件
    const utilFiles = await getAllFiles(path.join(__dirname, '../utils'));
    console.log(`找到 ${utilFiles.length} 个工具文件需要检查`);
    
    // 合并所有需要检查的文件
    const allFiles = [...modelFiles, ...utilFiles];
    
    // 修复所有文件
    let fixedCount = 0;
    for (const file of allFiles) {
      const fixed = await fixFile(file);
      if (fixed) {
        fixedCount++;
      }
    }
    
    console.log(`修复完成，共修复了 ${fixedCount} 个文件`);
  } catch (error) {
    console.error('修复过程中出错:', error);
    process.exit(1);
  }
}

// 执行主函数
main().catch(error => {
  console.error('脚本执行失败:', error);
  process.exit(1);
}); 