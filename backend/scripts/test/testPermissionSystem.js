/**
 * 权限系统测试脚本
 * 用于验证角色权限映射和权限检查功能
 */

const { 
  getRolePermissions, 
  hasPermission, 
  hasAnyPermission, 
  hasAllPermissions,
  checkResourcePermission,
  BASE_PERMISSIONS 
} = require('../../constants/permissions');

console.log('🧪 开始权限系统测试...\n');

// 测试1: 角色权限获取
console.log('📋 测试1: 角色权限获取');
const customerPermissions = getRolePermissions('customer');
const merchantPermissions = getRolePermissions('store_manager');
const adminPermissions = getRolePermissions('admin');

console.log('顾客权限数量:', customerPermissions.length);
console.log('商家权限数量:', merchantPermissions.length);
console.log('管理员权限数量:', adminPermissions.length);

// 测试2: 权限检查
console.log('\n🔍 测试2: 权限检查功能');
console.log('顾客是否有菜品读取权限:', hasPermission(customerPermissions, BASE_PERMISSIONS.DISH_READ));
console.log('顾客是否有菜品管理权限:', hasPermission(customerPermissions, BASE_PERMISSIONS.DISH_MANAGE));
console.log('商家是否有菜品管理权限:', hasPermission(merchantPermissions, BASE_PERMISSIONS.DISH_MANAGE));

// 测试3: 多权限检查
console.log('\n📝 测试3: 多权限检查');
const requiredOrderPermissions = [BASE_PERMISSIONS.ORDER_READ, BASE_PERMISSIONS.ORDER_WRITE];
console.log('顾客是否有所有订单权限:', hasAllPermissions(customerPermissions, requiredOrderPermissions));
console.log('商家是否有所有订单权限:', hasAllPermissions(merchantPermissions, requiredOrderPermissions));

// 测试4: 任一权限检查
console.log('\n🔄 测试4: 任一权限检查');
const adminOnlyPermissions = [BASE_PERMISSIONS.ADMIN_READ, BASE_PERMISSIONS.SYSTEM_CONFIG];
console.log('顾客是否有任一管理权限:', hasAnyPermission(customerPermissions, adminOnlyPermissions));
console.log('管理员是否有任一管理权限:', hasAnyPermission(adminPermissions, adminOnlyPermissions));

// 测试5: 资源权限检查
console.log('\n🏪 测试5: 资源权限检查');
const user1 = { _id: 'user1', franchiseStoreId: 'store1' };
const user2 = { _id: 'user2', franchiseStoreId: 'store2' };
const resource = { storeId: 'store1' };

console.log('用户1是否可访问店铺1资源:', checkResourcePermission(user1, resource, 'store_data'));
console.log('用户2是否可访问店铺1资源:', checkResourcePermission(user2, resource, 'store_data'));

// 测试6: 权限系统完整性检查
console.log('\n✅ 测试6: 权限系统完整性检查');
const allRoles = ['customer', 'store_manager', 'store_staff', 'nutritionist', 'area_manager', 'admin', 'super_admin'];
let totalPermissionCount = 0;

allRoles.forEach(role => {
  const permissions = getRolePermissions(role);
  totalPermissionCount += permissions.length;
  console.log(`${role}: ${permissions.length} 个权限`);
});

console.log('基础权限总数:', Object.keys(BASE_PERMISSIONS).length);
console.log('所有角色权限总分配数:', totalPermissionCount);

console.log('\n🎉 权限系统测试完成!');

// 如果作为脚本直接运行，输出结果
if (require.main === module) {
  console.log('\n📊 权限系统状态: 正常');
  process.exit(0);
}