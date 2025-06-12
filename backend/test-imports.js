// 测试文件导入
console.log('测试导入依赖...\n');

try {
  console.log('1. 测试 userPermissionModel.js...');
  const UserPermission = require('./models/user/userPermissionModel');
  console.log('✓ userPermissionModel.js 导入成功');
} catch (error) {
  console.error('✗ userPermissionModel.js 导入失败:', error.message);
}

try {
  console.log('\n2. 测试 userPermissionService.js...');
  const userPermissionService = require('./services/user/userPermissionService');
  console.log('✓ userPermissionService.js 导入成功');
} catch (error) {
  console.error('✗ userPermissionService.js 导入失败:', error.message);
}

try {
  console.log('\n3. 测试 userPermissionController.js...');
  const userPermissionController = require('./controllers/user/userPermissionController');
  console.log('✓ userPermissionController.js 导入成功');
} catch (error) {
  console.error('✗ userPermissionController.js 导入失败:', error.message);
}

try {
  console.log('\n4. 测试 userPermissionRoutes.js...');
  const userPermissionRoutes = require('./routes/user/userPermissionRoutes');
  console.log('✓ userPermissionRoutes.js 导入成功');
} catch (error) {
  console.error('✗ userPermissionRoutes.js 导入失败:', error.message);
}

try {
  console.log('\n5. 测试 legacyCertificationMiddleware.js...');
  const { legacyCertificationMiddleware, migrationNoticeMiddleware } = require('./middleware/certification/legacyCertificationMiddleware');
  console.log('✓ legacyCertificationMiddleware.js 导入成功');
} catch (error) {
  console.error('✗ legacyCertificationMiddleware.js 导入失败:', error.message);
}

console.log('\n测试完成');