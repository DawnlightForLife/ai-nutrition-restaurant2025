/**
 * 结构冻结脚本
 * 此脚本用于标记项目中的关键结构已经冻结，防止意外修改
 */

const fs = require('fs');
const path = require('path');

// 定义冻结的目录结构
const FROZEN_STRUCTURE = {
  controllers: {
    core: ['authController.js', 'userController.js', 'adminController.js', 'permissionController.js'],
    forum: ['forumPostController.js', 'forumCommentController.js'],
    health: ['nutritionProfileController.js', 'healthDataController.js'],
    merchant: ['merchantController.js', 'storeController.js', 'dishController.js', 'merchantStatsController.js'],
    misc: ['notificationController.js', 'appConfigController.js'],
    nutrition: ['aiRecommendationController.js', 'nutritionistController.js', 'favoriteController.js'],
    order: ['orderController.js', 'consultationController.js', 'subscriptionController.js'],
    audit: ['auditLogController.js']
  },
  routes: {
    core: ['authRoutes.js', 'userRoutes.js', 'adminRoutes.js', 'permissionRoutes.js'],
    forum: ['forumPostRoutes.js', 'forumCommentRoutes.js'],
    health: ['nutritionProfileRoutes.js', 'healthDataRoutes.js'],
    merchant: ['merchantRoutes.js', 'storeRoutes.js', 'dishRoutes.js', 'merchantStatsRoutes.js'],
    misc: ['notificationRoutes.js', 'appConfigRoutes.js'],
    nutrition: ['aiRecommendationRoutes.js', 'nutritionistRoutes.js', 'favoriteRoutes.js'],
    order: ['orderRoutes.js', 'consultationRoutes.js', 'subscriptionRoutes.js'],
    audit: ['auditLogRoutes.js']
  }
};

// 冻结标记创建时间
const FREEZE_TIMESTAMP = new Date().toISOString();

// 创建冻结标记文件
function createFreezeMarker(directory, structure) {
  const markerPath = path.join(directory, '.structure-frozen');
  
  const markerContent = {
    timestamp: FREEZE_TIMESTAMP,
    message: '此目录结构已冻结，请勿随意修改目录结构和文件名称。添加新功能请遵循现有结构。',
    structure: structure
  };
  
  fs.writeFileSync(markerPath, JSON.stringify(markerContent, null, 2), 'utf8');
  console.log(`已创建冻结标记: ${markerPath}`);
}

// 检查目录结构
function validateStructure(baseDir, structure) {
  const issues = [];
  
  for (const module in structure) {
    const moduleDir = path.join(baseDir, module);
    
    if (!fs.existsSync(moduleDir)) {
      issues.push(`目录不存在: ${moduleDir}`);
      continue;
    }
    
    const subStructure = structure[module];
    for (const subModule in subStructure) {
      const subModuleDir = path.join(moduleDir, subModule);
      
      if (!fs.existsSync(subModuleDir)) {
        issues.push(`子目录不存在: ${subModuleDir}`);
        continue;
      }
      
      const files = subStructure[subModule];
      for (const file of files) {
        const filePath = path.join(subModuleDir, file);
        
        if (!fs.existsSync(filePath)) {
          issues.push(`文件不存在: ${filePath}`);
        }
      }
    }
  }
  
  return issues;
}

// 主函数
function main() {
  const backendDir = path.join(__dirname, '..', 'backend');
  
  // 验证控制器结构
  const controllerIssues = validateStructure(backendDir, FROZEN_STRUCTURE);
  
  if (controllerIssues.length > 0) {
    console.error('错误: 以下文件或目录不存在:');
    controllerIssues.forEach(issue => console.error(`- ${issue}`));
    console.error('请修复以上问题后再执行冻结操作。');
    process.exit(1);
  }
  
  // 创建控制器冻结标记
  createFreezeMarker(path.join(backendDir, 'controllers'), FROZEN_STRUCTURE.controllers);
  createFreezeMarker(path.join(backendDir, 'routes'), FROZEN_STRUCTURE.routes);
  
  console.log('结构冻结完成！项目的控制器和路由结构已标记为冻结状态。');
  console.log('冻结时间:', FREEZE_TIMESTAMP);
}

// 执行主函数
main(); 