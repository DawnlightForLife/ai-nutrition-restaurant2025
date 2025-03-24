const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const userRoutes = require('./routes/userRoutes');

const app = express();
const PORT = 3000;

// 中间件
app.use(cors());
app.use(express.json());

// 路由
app.use('/api/users', userRoutes);

// 连接 MongoDB
mongoose.connect('mongodb://localhost:27017/ai_nutrition_db', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('MongoDB 已连接');
  app.listen(PORT, () => {
    console.log(`服务器运行在 http://localhost:${PORT}`);
  });
}).catch((err) => {
  console.error('数据库连接失败:', err);
});
