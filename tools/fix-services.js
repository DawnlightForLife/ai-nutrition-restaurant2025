/**
 * 服务层文件修复脚本
 * 用于修复服务层文件结构
 */

const fs = require('fs');
const path = require('path');

// 读取冻结标记文件
const servicesFrozenPath = path.join(__dirname, '../backend/services/.structure-frozen');
const servicesFrozen = JSON.parse(fs.readFileSync(servicesFrozenPath, 'utf8'));

// 服务模板函数
function getServiceTemplate(serviceName, modelPath, modelName) {
  if (modelPath && modelName) {
    return `const ${modelName} = require('${modelPath}');\n\nconst ${serviceName}Service = {\n  // TODO: implement ${serviceName} logic\n};\n\nmodule.exports = ${serviceName}Service;`;
  } else {
    return `// ${serviceName} service\nconst ${serviceName}Service = {\n  // TODO: implement ${serviceName} logic\n};\n\nmodule.exports = ${serviceName}Service;`;
  }
}

// 服务映射
const serviceMapping = {
  core: {
    admin: { model: '../../models/core/adminModel', modelName: 'Admin' },
    auditLog: { model: '../../models/core/auditLogModel', modelName: 'AuditLog' },
    oauth: { model: '../../models/core/oauthAccountModel', modelName: 'OauthAccount' },
    userRole: { model: '../../models/core/userRoleModel', modelName: 'UserRole' },
    user: { model: '../../models/core/userModel', modelName: 'User' }
  },
  forum: {
    forumPost: { model: '../../models/forum/forumPostModel', modelName: 'ForumPost' },
    forumComment: { model: '../../models/forum/forumCommentModel', modelName: 'ForumComment' }
  },
  health: {
    nutritionProfile: { model: '../../models/health/nutritionProfileModel', modelName: 'NutritionProfile' },
    healthData: { model: '../../models/health/healthDataModel', modelName: 'HealthData' },
    healthMetrics: { model: null, modelName: null }
  },
  merchant: {
    merchant: { model: '../../models/merchant/merchantModel', modelName: 'Merchant' },
    store: { model: '../../models/merchant/storeModel', modelName: 'Store' },
    storeDish: { model: '../../models/merchant/storeDishModel', modelName: 'StoreDish' },
    merchantStats: { model: '../../models/merchant/merchantStatsModel', modelName: 'MerchantStats' },
    dish: { model: '../../models/merchant/dishModel', modelName: 'Dish' }
  },
  misc: {
    notification: { model: '../../models/misc/notificationModel', modelName: 'Notification' },
    appConfig: { model: null, modelName: null },
    dataAccessControl: { model: '../../models/core/dataAccessControlModel', modelName: 'DataAccessControl' }
  },
  nutrition: {
    aiRecommendation: { model: '../../models/nutrition/aiRecommendationModel', modelName: 'AIRecommendation' },
    nutritionist: { model: '../../models/nutrition/nutritionistModel', modelName: 'Nutritionist' },
    userFavorite: { model: '../../models/nutrition/userFavoriteModel', modelName: 'UserFavorite' }
  },
  order: {
    order: { model: '../../models/order/orderModel', modelName: 'Order' },
    subscription: { model: '../../models/order/subscriptionModel', modelName: 'Subscription' },
    consultation: { model: '../../models/order/consultationModel', modelName: 'Consultation' }
  }
};

// 修复服务文件
function fixServiceFiles() {
  const services = servicesFrozen.structure;
  const fixedFiles = [];
  const servicesDir = path.join(__dirname, '../backend/services');
  
  // 检查所有模块
  for (const module in services) {
    const moduleDir = path.join(servicesDir, module);
    
    if (!fs.existsSync(moduleDir)) {
      fs.mkdirSync(moduleDir, { recursive: true });
    }
    
    const serviceFiles = services[module];
    for (const file of serviceFiles) {
      const filePath = path.join(moduleDir, file);
      const serviceName = file.replace('Service.js', '');
      
      // 检查文件内容是否正确
      let needsFix = false;
      if (!fs.existsSync(filePath)) {
        needsFix = true;
      } else {
        const content = fs.readFileSync(filePath, 'utf8');
        if (!content.includes('module.exports =')) {
          needsFix = true;
        }
      }
      
      if (needsFix) {
        const mapping = serviceMapping[module][serviceName];
        const template = getServiceTemplate(serviceName, mapping?.model, mapping?.modelName);
        fs.writeFileSync(filePath, template);
        fixedFiles.push(`${module}/${file}`);
      }
    }
  }
  
  return fixedFiles;
}

// 创建索引文件
function createIndexFile() {
  const services = servicesFrozen.structure;
  const servicesDir = path.join(__dirname, '../backend/services');
  const indexPath = path.join(servicesDir, 'index.js');
  
  let indexContent = `module.exports = {\n`;
  
  // 添加所有模块
  for (const module in services) {
    indexContent += `  // ${module}\n`;
    
    const serviceFiles = services[module];
    for (const file of serviceFiles) {
      const serviceName = file.replace('.js', '');
      indexContent += `  ${serviceName}: require('./${module}/${serviceName}'),\n`;
    }
    
    indexContent += `\n`;
  }
  
  // 移除最后一个多余的换行
  indexContent = indexContent.slice(0, -1);
  indexContent += `};`;
  
  fs.writeFileSync(indexPath, indexContent);
  
  return true;
}

// 主函数
function main() {
  const fixedFiles = fixServiceFiles();
  const indexCreated = createIndexFile();
  
  console.log('服务层修复完成！');
  console.log(`修复了 ${fixedFiles.length} 个服务文件:`);
  fixedFiles.forEach(file => console.log(`  - ${file}`));
  
  if (indexCreated) {
    console.log('创建了 services/index.js 文件。');
  }
  
  console.log('\n现在所有服务文件应该符合项目规范。');
}

// 执行主函数
main(); 