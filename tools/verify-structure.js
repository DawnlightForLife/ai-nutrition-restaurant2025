/**
 * 结构验证脚本
 * 用于验证项目目录结构是否完整，检查控制器和路由文件是否存在
 */

const fs = require('fs');
const path = require('path');

// 定义应该存在的控制器和路由结构
const EXPECTED_STRUCTURE = {
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

// 特殊文件检查
const SPECIAL_FILES = {
  controllers: ['index.js'],
  routes: ['index.js']
};

// 标记缺失的文件
const missingFiles = [];

// 验证目录结构
function verifyStructure(baseDir, structure, type) {
  // 检查特殊文件
  SPECIAL_FILES[type].forEach(file => {
    const filePath = path.join(baseDir, type, file);
    if (!fs.existsSync(filePath)) {
      missingFiles.push(`${type}/${file}`);
    }
  });

  // 检查模块文件
  for (const module in structure[type]) {
    const moduleDir = path.join(baseDir, type, module);
    
    if (!fs.existsSync(moduleDir)) {
      missingFiles.push(`${type}/${module}`);
      continue;
    }
    
    const files = structure[type][module];
    for (const file of files) {
      const filePath = path.join(moduleDir, file);
      
      if (!fs.existsSync(filePath)) {
        missingFiles.push(`${type}/${module}/${file}`);
      }
    }
  }
}

// 主函数
function main() {
  const backendDir = path.join(__dirname, '..', 'backend');
  
  // 验证控制器和路由结构
  verifyStructure(backendDir, EXPECTED_STRUCTURE, 'controllers');
  verifyStructure(backendDir, EXPECTED_STRUCTURE, 'routes');
  
  // 报告结果
  if (missingFiles.length === 0) {
    console.log('🎉 验证成功! 所有控制器和路由文件均已找到。');
    console.log('👍 项目结构完整，符合规范要求。');
    process.exit(0);
  } else {
    console.error('❌ 验证失败! 以下文件未找到:');
    missingFiles.forEach(file => console.error(`  - ${file}`));
    console.error('\n请先创建这些缺失的文件，再重新运行验证。');
    process.exit(1);
  }
}

// 执行主函数
main(); 