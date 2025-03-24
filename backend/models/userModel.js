const mongoose = require('mongoose');

// 定义用户模型的结构
const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true // 手机号唯一
  },
  password: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// 导出模型
const User = mongoose.model('User', userSchema);

module.exports = User;