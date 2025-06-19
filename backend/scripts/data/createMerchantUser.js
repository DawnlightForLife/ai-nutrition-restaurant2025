const mongoose = require('mongoose');
const User = require('../../models/user/userModel');
const bcrypt = require('bcryptjs');

// 连接数据库
mongoose.connect('mongodb://mongo:27017/ai-nutrition-restaurant', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('成功连接到MongoDB');
  createMerchantUser();
}).catch(error => {
  console.error('MongoDB连接失败:', error);
  process.exit(1);
});

// 创建商家管理员测试用户
async function createMerchantUser() {
  try {
    // 检查是否已存在该手机号的用户
    const phone = '18888888888';
    const existingUser = await User.findOne({ phone });
    
    if (existingUser) {
      console.log('商家测试用户已存在，正在更新角色...');
      existingUser.role = 'store_manager';
      existingUser.nickname = '商家管理员';
      existingUser.profileCompleted = true;
      await existingUser.save();
      console.log('已更新现有用户角色为 store_manager');
    } else {
      // 加密密码
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash('1234', salt);

      // 创建商家管理员测试用户
      const merchantUser = new User({
        phone: phone,
        password: hashedPassword,
        role: 'store_manager',
        nickname: '商家管理员',
        profileCompleted: true,
        // 添加一些基本信息
        height: 175,
        weight: 70,
        age: 35,
        gender: 'male',
        activityLevel: 'moderate'
      });

      await merchantUser.save();
      console.log('商家管理员测试用户创建成功');
    }
    
    console.log('=== 商家管理员登录信息 ===');
    console.log('手机号: 18888888888');
    console.log('密码: 1234');
    console.log('角色: store_manager');
    console.log('=======================');
    
  } catch (error) {
    console.error('创建商家用户失败:', error);
  } finally {
    process.exit(0);
  }
}