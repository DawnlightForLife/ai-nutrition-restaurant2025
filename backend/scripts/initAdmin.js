const mongoose = require('mongoose');
const User = require('../models/userModel');
const bcrypt = require('bcryptjs');

// 连接数据库
mongoose.connect('mongodb://mongo:27017/smart_nutrition_restaurant', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('成功连接到MongoDB');
  createAdminUser();
}).catch(error => {
  console.error('MongoDB连接失败:', error);
  process.exit(1);
});

// 创建管理员账号
async function createAdminUser() {
  try {
    // 检查是否已存在管理员账号
    const existingAdmin = await User.findOne({ role: 'admin' });
    if (existingAdmin) {
      console.log('管理员账号已存在，正在删除旧账号...');
      await User.deleteOne({ _id: existingAdmin._id });
    }

    // 加密密码
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('admin123', salt);

    // 创建新的管理员账号
    const adminUser = new User({
      phone: '13800138000',
      password: hashedPassword,
      role: 'admin',
      nickname: '系统管理员'
    });

    await adminUser.save();
    console.log('管理员账号创建成功');
    console.log('手机号: 13800138000');
    console.log('密码: admin123');
  } catch (error) {
    console.error('创建管理员账号失败:', error);
  } finally {
    process.exit(0);
  }
} 