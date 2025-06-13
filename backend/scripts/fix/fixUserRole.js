/**
 * 修复用户角色的脚本
 * 将 role 为 'user' 的用户修复为 'customer'
 */

const mongoose = require('mongoose');
const User = require('../../models/user/userModel');
require('dotenv').config();

async function fixUserRole() {
  try {
    // 连接数据库
    await mongoose.connect(process.env.MONGO_URI || 'mongodb://localhost:27017/ai-nutrition-restaurant');
    console.log('已连接到数据库');

    // 查找role为user的用户
    const usersNeedFix = await User.find({
      role: 'user'
    }).select('phone nickname role');

    console.log(`\n找到需要修复角色的用户: ${usersNeedFix.length} 个\n`);

    if (usersNeedFix.length === 0) {
      console.log('没有需要修复的用户');
      return;
    }

    // 修复每个用户
    for (const user of usersNeedFix) {
      console.log(`修复用户: ${user.nickname} (${user.phone})`);
      console.log(`  原角色: ${user.role}`);
      
      // 更新角色
      await User.updateOne(
        { _id: user._id },
        { $set: { role: 'customer' } }
      );
      
      console.log(`  新角色: customer`);
      console.log(`  ✅ 修复完成\n`);
    }

    console.log(`总共修复了 ${usersNeedFix.length} 个用户的角色`);

  } catch (error) {
    console.error('修复失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('\n已断开数据库连接');
  }
}

// 如果直接运行此脚本
if (require.main === module) {
  fixUserRole();
}

module.exports = fixUserRole;