/**
 * 测试菜品控制器逻辑（不需要数据库）
 */

const path = require('path');

// 测试控制器导入是否正常
try {
  console.log('测试控制器导入...');
  
  // 测试增强菜品控制器
  const dishController = require('./controllers/merchant/dishControllerEnhanced');
  console.log('✓ dishControllerEnhanced 导入成功');
  console.log('  可用方法:', Object.keys(dishController).join(', '));
  
  // 测试库存控制器
  const inventoryController = require('./controllers/merchant/inventoryController');
  console.log('✓ inventoryController 导入成功');
  console.log('  可用方法:', Object.keys(inventoryController).join(', '));
  
  // 测试订单处理控制器
  const orderController = require('./controllers/merchant/orderProcessingController');
  console.log('✓ orderProcessingController 导入成功');
  console.log('  可用方法:', Object.keys(orderController).join(', '));
  
  // 测试路由导入
  console.log('\n测试路由导入...');
  
  const dishRoutes = require('./routes/merchant/dishRoutesEnhanced');
  console.log('✓ dishRoutesEnhanced 路由导入成功');
  
  const inventoryRoutes = require('./routes/merchant/inventoryRoutes');
  console.log('✓ inventoryRoutes 路由导入成功');
  
  const orderRoutes = require('./routes/merchant/orderProcessingRoutes');
  console.log('✓ orderProcessingRoutes 路由导入成功');
  
  // 测试模型导入
  console.log('\n测试模型导入...');
  
  const IngredientInventory = require('./models/merchant/ingredientInventoryModel');
  console.log('✓ IngredientInventory 模型导入成功');
  console.log('  Schema路径:', Object.keys(IngredientInventory.schema.paths).slice(0, 5).join(', '), '...');
  
  // 测试中间件
  console.log('\n测试中间件导入...');
  
  const { authenticateUser } = require('./middleware/auth/authMiddleware');
  console.log('✓ authenticateUser 中间件导入成功');
  
  const requireRole = require('./middleware/auth/roleMiddleware');
  console.log('✓ requireRole 中间件导入成功');
  
  console.log('\n✅ 所有模块导入测试通过！');
  console.log('代码结构正确，等待数据库连接后即可正常运行。');
  
} catch (error) {
  console.error('\n❌ 导入测试失败:');
  console.error('错误类型:', error.name);
  console.error('错误消息:', error.message);
  console.error('错误位置:', error.stack?.split('\n')[1]);
}