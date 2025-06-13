/**
 * 修复用户认证类型的脚本
 * 将有密码但authType不是password的用户修复为password类型
 */

const mongoose = require('mongoose');
const User = require('../../models/user/userModel');
require('dotenv').config();

async function fixUserAuthType() {
  try {
    // 连接数据库
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant');
    console.log('已连接到数据库');

    // 查找有密码但authType不是password的用户
    const usersNeedFix = await User.find({
      password: { $exists: true, $ne: null, $ne: '' },
      authType: { $ne: 'password' }
    }).select('phone nickname authType password');

    console.log(`\n找到需要修复的用户: ${usersNeedFix.length} 个\n`);

    if (usersNeedFix.length === 0) {
      console.log('没有需要修复的用户');
      return;
    }

    // 修复每个用户
    for (const user of usersNeedFix) {
      console.log(`修复用户: ${user.nickname} (${user.phone})`);
      console.log(`  原认证类型: ${user.authType}`);
      
      // 更新认证类型
      user.authType = 'password';
      await user.save();
      
      console.log(`  新认证类型: ${user.authType}`);
      console.log(`  ✅ 修复完成\n`);
    }

    console.log(`总共修复了 ${usersNeedFix.length} 个用户的认证类型`);

  } catch (error) {
    console.error('修复失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('\n已断开数据库连接');
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  fixUserAuthType();
}

module.exports = fixUserAuthType;