/**
 * 快速路由测试
 */

console.log('🛣️  快速路由测试...');

try {
  const nutritionElementRoutes = require('../../routes/nutrition/nutritionElementRoutes');
  console.log('✅ nutritionElementRoutes路由导入成功');
} catch (error) {
  console.log('❌ 路由导入失败:', error.message);
  console.log('错误详情:', error.stack);
}

console.log('测试完成。');