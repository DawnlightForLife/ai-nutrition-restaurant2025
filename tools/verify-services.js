/**
 * 服务层结构验证脚本
 * 用于验证服务层结构是否完整，是否符合规范
 */

const fs = require('fs');
const path = require('path');

// 读取冻结标记文件
const servicesFrozenPath = path.join(__dirname, '../backend/services/.structure-frozen');
const servicesFrozen = JSON.parse(fs.readFileSync(servicesFrozenPath, 'utf8'));

// 验证服务文件
function verifyServiceFiles() {
  const services = servicesFrozen.structure;
  const missingFiles = [];
  const servicesDir = path.join(__dirname, '../backend/services');
  
  // 检查index.js
  if (!fs.existsSync(path.join(servicesDir, 'index.js'))) {
    missingFiles.push('services/index.js');
  }
  
  // 检查所有模块
  for (const module in services) {
    const moduleDir = path.join(servicesDir, module);
    
    if (!fs.existsSync(moduleDir)) {
      missingFiles.push(`services/${module}`);
      continue;
    }
    
    const serviceFiles = services[module];
    for (const file of serviceFiles) {
      const filePath = path.join(moduleDir, file);
      
      if (!fs.existsSync(filePath)) {
        missingFiles.push(`services/${module}/${file}`);
        continue;
      }
      
      // 验证服务文件内容
      const content = fs.readFileSync(filePath, 'utf8');
      if (!content.includes('module.exports')) {
        missingFiles.push(`services/${module}/${file} (没有正确导出服务)`);
      }
    }
  }
  
  return missingFiles;
}

// 验证索引文件是否正确导出所有服务
function verifyIndexExports() {
  const services = servicesFrozen.structure;
  const servicesDir = path.join(__dirname, '../backend/services');
  const indexPath = path.join(servicesDir, 'index.js');
  
  if (!fs.existsSync(indexPath)) {
    return ['services/index.js 文件不存在'];
  }
  
  const content = fs.readFileSync(indexPath, 'utf8');
  const missingExports = [];
  
  for (const module in services) {
    const serviceFiles = services[module];
    for (const file of serviceFiles) {
      const serviceName = file.replace('.js', '');
      const requirePath = `./${module}/${serviceName}`;
      
      if (!content.includes(requirePath)) {
        missingExports.push(`services/index.js 未导出 ${serviceName}`);
      }
    }
  }
  
  return missingExports;
}

// 主函数
function main() {
  const missingFiles = verifyServiceFiles();
  const missingExports = verifyIndexExports();
  
  const allIssues = [...missingFiles, ...missingExports];
  
  if (allIssues.length === 0) {
    console.log('🎉 服务层验证成功! 所有服务文件均已找到并正确导出。');
    console.log('👍 服务层结构完整，符合规范要求。');
    process.exit(0);
  } else {
    console.error('❌ 服务层验证失败! 发现以下问题:');
    allIssues.forEach(issue => console.error(`  - ${issue}`));
    console.error('\n请先解决这些问题，再重新运行验证。');
    process.exit(1);
  }
}

// 执行主函数
main(); 