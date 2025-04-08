const mongoose = require('mongoose');
const User = require('../../models/core/userModel');
const bcrypt = require('bcryptjs');

// 连接数据库
mongoose.connect('mongodb://mongo:27017/ai-nutrition-restaurant', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('成功连接到MongoDB');
  createTestUser();
}).catch(error => {
  console.error('MongoDB连接失败:', error);
  process.exit(1);
});

// 创建测试用户账号
async function createTestUser() {
  try {
    // 检查是否已存在该手机号的用户
    const phone = '18582658187';
    const existingUser = await User.findOne({ phone });
    
    if (existingUser) {
      console.log('测试用户账号已存在，正在删除旧账号...');
      await User.deleteOne({ _id: existingUser._id });
    }

    // 加密密码
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('1234', salt);

    // 创建测试用户账号
    const testUser = new User({
      phone: phone,
      password: hashedPassword,
      role: 'user',
      nickname: '测试用户',
      // 添加一些测试数据
      height: 175,
      weight: 70,
      age: 30,
      gender: 'male',
      activityLevel: 'moderate'
    });

    await testUser.save();
    console.log('测试用户账号创建成功');
    console.log('手机号: 18582658187');
    console.log('密码: 1234');
  } catch (error) {
    console.error('创建测试用户账号失败:', error);
  } finally {
    process.exit(0);
  }
} 