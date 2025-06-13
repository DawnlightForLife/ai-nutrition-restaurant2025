/**
 * 检查用户密码状态的脚本
 */

const mongoose = require('mongoose');
const User = require('../../models/user/userModel');
require('dotenv').config();

async function checkUserPassword() {
  try {
    // 连接数据库
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant');
    console.log('已连接到数据库');

    // 查找所有用户
    const users = await User.find({}).select('phone nickname authType password');
    
    console.log('\n=== 用户密码状态检查 ===');
    console.log(`总用户数: ${users.length}\n`);

    users.forEach((user, index) => {
      console.log(`${index + 1}. 用户: ${user.nickname || '未设置昵称'}`);
      console.log(`   手机号: ${user.phone}`);
      console.log(`   认证类型: ${user.authType || '未设置'}`);
      console.log(`   是否有密码: ${user.password ? '是' : '否'}`);
      console.log(`   密码长度: ${user.password ? user.password.length : 0}`);
      console.log(`   ------------------`);
    });

    // 统计信息
    const withPassword = users.filter(u => u.password && u.password.length > 0);
    const withPasswordAuth = users.filter(u => u.authType === 'password');
    const withCodeAuth = users.filter(u => u.authType === 'code');

    console.log('\n=== 统计信息 ===');
    console.log(`有密码的用户: ${withPassword.length}`);
    console.log(`认证类型为password的用户: ${withPasswordAuth.length}`);
    console.log(`认证类型为code的用户: ${withCodeAuth.length}`);

  } catch (error) {
    console.error('检查失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('\n已断开数据库连接');
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  checkUserPassword();
}

module.exports = checkUserPassword;