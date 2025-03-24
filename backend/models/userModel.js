const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  phone: {
    type: String,
    required: true,
    unique: true
  },
  password: {
    type: String,
    required: true
  },
  role: {
    type: String,
    enum: ['user', 'merchant', 'nutritionist', 'admin'],
    default: 'user'
  }
});

const User = mongoose.model('User', userSchema);
module.exports = User;
