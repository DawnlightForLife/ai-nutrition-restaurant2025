/**
 * 快速测试businessType枚举值
 */

const { merchantTypeValues, isValidMerchantType } = require('../../models/merchant/merchantTypeEnum');

console.log('=== 商家类型枚举值测试 ===\n');

console.log('1. 有效的商家类型值:');
merchantTypeValues.forEach(type => {
  console.log(`   ✅ ${type}`);
});

console.log('\n2. 测试前端可能发送的值:');
const testValues = ['maternityCenter', 'gym', 'school', 'company', 'schoolCompany', 'restaurant', 'other'];

testValues.forEach(value => {
  const isValid = isValidMerchantType(value);
  const status = isValid ? '✅' : '❌';
  console.log(`   ${status} ${value} - ${isValid ? '有效' : '无效'}`);
});

console.log('\n3. 前端修复建议:');
console.log('   ❌ company -> ✅ schoolCompany');
console.log('   ❌ school -> ✅ schoolCompany');
console.log('   ❌ other -> 请选择具体类型');

console.log('\n=== 测试完成 ===');