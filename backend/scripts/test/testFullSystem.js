/**
 * 完整系统测试脚本
 * 测试权限系统、业务功能、缓存和安全性
 */

require('dotenv').config();
const mongoose = require('mongoose');

// 导入服务和工具
const permissionCacheService = require('../../services/permissions/permissionCacheService');
const { auditLogger } = require('../../middleware/security/auditMiddleware');
const { 
  getRolePermissions, 
  hasPermission, 
  hasAnyPermission,
  hasAllPermissions
} = require('../../constants/permissions');

async function connectDB() {
  try {
    const mongoUri = process.env.MONGODB_URI || 'mongodb://localhost:27017/ai_nutrition_db';
    await mongoose.connect(mongoUri);
    console.log('📊 数据库连接成功');
  } catch (error) {
    console.error('❌ 数据库连接失败:', error);
    process.exit(1);
  }
}

async function testPermissionCache() {
  console.log('\n🔒 测试权限缓存功能...');
  
  try {
    const userId = 'test_user_123';
    const role = 'store_manager';
    const specialPermissions = ['special:permission'];
    
    // 测试获取权限（第一次，缓存未命中）
    console.time('首次权限获取');
    const permissions1 = permissionCacheService.getUserPermissions(userId, role, specialPermissions);
    console.timeEnd('首次权限获取');
    console.log('权限数量:', permissions1.length);
    
    // 测试获取权限（第二次，缓存命中）
    console.time('缓存权限获取');
    const permissions2 = permissionCacheService.getUserPermissions(userId, role, specialPermissions);
    console.timeEnd('缓存权限获取');
    console.log('权限数量:', permissions2.length);
    
    // 验证结果一致性
    const isConsistent = JSON.stringify(permissions1) === JSON.stringify(permissions2);
    console.log('✅ 缓存结果一致性:', isConsistent);
    
    // 测试权限检查
    const hasCreatePermission = permissionCacheService.hasPermission(
      userId, role, specialPermissions, 'dish:write'
    );
    console.log('✅ 权限检查 (dish:write):', hasCreatePermission);
    
    // 测试缓存统计
    const stats = permissionCacheService.getCacheStats();
    console.log('📊 缓存统计:', {
      keys: stats.keys,
      hits: stats.hits,
      misses: stats.misses,
      hitRate: (stats.hitRate * 100).toFixed(2) + '%'
    });
    
    // 清理测试缓存
    permissionCacheService.clearUserPermissions(userId);
    console.log('🧹 测试缓存已清理');
    
  } catch (error) {
    console.error('❌ 权限缓存测试失败:', error.message);
  }
}

async function testAuditLogging() {
  console.log('\n📝 测试审计日志功能...');
  
  try {
    // 模拟请求对象
    const mockReq = {
      user: {
        _id: new mongoose.Types.ObjectId(),
        role: 'store_manager'
      },
      path: '/api/v1/dishes',
      method: 'POST',
      ip: '127.0.0.1',
      get: (header) => header === 'User-Agent' ? 'Test-Agent/1.0' : null
    };
    
    // 测试权限拒绝日志
    await auditLogger.logPermissionDenied(
      mockReq,
      ['admin:write'],
      ['dish:read', 'dish:write']
    );
    console.log('✅ 权限拒绝日志记录成功');
    
    // 测试登录日志
    await auditLogger.logLogin(
      mockReq.user._id,
      mockReq.user.role,
      mockReq.ip,
      'Test-Agent/1.0',
      true
    );
    console.log('✅ 登录日志记录成功');
    
    // 测试数据访问日志
    await auditLogger.logDataAccess(
      mockReq,
      'dish',
      new mongoose.Types.ObjectId(),
      'create'
    );
    console.log('✅ 数据访问日志记录成功');
    
    // 测试财务操作日志
    await auditLogger.logFinancialOperation(
      mockReq,
      'payment',
      99.99,
      new mongoose.Types.ObjectId(),
      { method: 'credit_card' }
    );
    console.log('✅ 财务操作日志记录成功');
    
  } catch (error) {
    console.error('❌ 审计日志测试失败:', error.message);
  }
}

async function testPermissionSystem() {
  console.log('\n🛡️ 测试权限系统功能...');
  
  try {
    // 测试角色权限获取
    const managerPermissions = getRolePermissions('store_manager');
    const customerPermissions = getRolePermissions('customer');
    console.log('店长权限数量:', managerPermissions.length);
    console.log('顾客权限数量:', customerPermissions.length);
    
    // 测试权限检查
    const canManageMenu = hasPermission(managerPermissions, 'dish:manage');
    const canCustomerManageMenu = hasPermission(customerPermissions, 'dish:manage');
    console.log('✅ 店长可以管理菜单:', canManageMenu);
    console.log('✅ 顾客可以管理菜单:', canCustomerManageMenu);
    
    // 测试多权限检查
    const requiredOrderPermissions = ['order:read', 'order:write'];
    const canManagerHandleOrders = hasAllPermissions(managerPermissions, requiredOrderPermissions);
    const canCustomerHandleOrders = hasAllPermissions(customerPermissions, requiredOrderPermissions);
    console.log('✅ 店长可以处理订单:', canManagerHandleOrders);
    console.log('✅ 顾客可以处理订单:', canCustomerHandleOrders);
    
    // 测试任一权限检查
    const adminPermissions = ['admin:read', 'system:config'];
    const hasAnyAdminPermission = hasAnyPermission(managerPermissions, adminPermissions);
    console.log('✅ 店长有任一管理权限:', hasAnyAdminPermission);
    
  } catch (error) {
    console.error('❌ 权限系统测试失败:', error.message);
  }
}

async function testPerformance() {
  console.log('\n⚡ 测试性能...');
  
  try {
    const iterations = 1000;
    const userId = 'perf_test_user';
    const role = 'store_manager';
    
    // 测试权限获取性能（使用缓存）
    console.time('缓存权限获取性能测试');
    for (let i = 0; i < iterations; i++) {
      permissionCacheService.getUserPermissions(userId, role, []);
    }
    console.timeEnd('缓存权限获取性能测试');
    
    // 测试权限检查性能
    const userPermissions = permissionCacheService.getUserPermissions(userId, role, []);
    console.time('权限检查性能测试');
    for (let i = 0; i < iterations; i++) {
      hasPermission(userPermissions, 'dish:read');
    }
    console.timeEnd('权限检查性能测试');
    
    // 清理测试数据
    permissionCacheService.clearUserPermissions(userId);
    
  } catch (error) {
    console.error('❌ 性能测试失败:', error.message);
  }
}

async function runAllTests() {
  console.log('🚀 开始完整系统测试...\n');
  
  await connectDB();
  await testPermissionSystem();
  await testPermissionCache();
  await testAuditLogging();
  await testPerformance();
  
  console.log('\n🎉 完整系统测试完成!');
  console.log('\n📊 最终缓存统计:');
  console.log(permissionCacheService.getCacheStats());
  
  // 关闭数据库连接
  await mongoose.connection.close();
  console.log('📊 数据库连接已关闭');
}

// 如果作为脚本直接运行
if (require.main === module) {
  runAllTests().catch(error => {
    console.error('💥 系统测试执行失败:', error);
    process.exit(1);
  });
}

module.exports = { runAllTests };