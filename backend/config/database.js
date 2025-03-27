const mongoose = require('mongoose');
const config = require('./db.config');

// 创建一个默认连接
mongoose.connect(config.mongoURI, config.options)
  .then(() => console.log('默认Mongoose连接已建立'))
  .catch(err => console.error('连接MongoDB失败:', err));

// 当连接成功建立时
mongoose.connection.on('connected', () => {
  console.log('Mongoose默认连接已打开');
});

// 当连接发生错误时
mongoose.connection.on('error', err => {
  console.error('Mongoose连接错误:', err);
});

// 当连接断开时
mongoose.connection.on('disconnected', () => {
  console.log('Mongoose连接已断开');
});

// 当应用退出时，关闭连接
process.on('SIGINT', () => {
  mongoose.connection.close(() => {
    console.log('应用终止，Mongoose连接已关闭');
    process.exit(0);
  });
});

// 导出数据库管理器，保留以前的API以兼容现有代码
const dbManager = {
  connect: async () => mongoose.connection,
  close: async () => mongoose.connection.close(),
  isConnected: () => mongoose.connection.readyState === 1,
  getPrimaryConnection: () => mongoose.connection,
  getConnectionState: () => {
    const states = ['disconnected', 'connected', 'connecting', 'disconnecting'];
    return states[mongoose.connection.readyState];
  }
};

module.exports = dbManager; 