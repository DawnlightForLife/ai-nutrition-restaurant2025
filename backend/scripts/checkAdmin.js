const mongoose = require('mongoose');
const User = require('../models/userModel');

// 连接数据库
mongoose.connect('mongodb://mongo:27017/smart_nutrition_restaurant', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('成功连接到MongoDB');
  checkAdminUser();
}).catch(error => {
  console.error('MongoDB连接失败:', error);
  process.exit(1);
});

// 检查管理员账号
async function checkAdminUser() {
  try {
    const admin = await User.findOne({ role: 'admin' });
    if (admin) {
      console.log('找到管理员账号:');
      console.log('ID:', admin._id);
      console.log('手机号:', admin.phone);
      console.log('角色:', admin.role);
      console.log('昵称:', admin.nickname);
      console.log('密码哈希:', admin.password);
    } else {
      console.log('未找到管理员账号');
    }
  } catch (error) {
    console.error('检查管理员账号失败:', error);
  } finally {
    process.exit(0);
  }
} 