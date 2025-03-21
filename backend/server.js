const express = require('express');
const app = express(); // ✅ 这一步是关键

// 然后才能注册路由
app.get('/', (req, res) => {
  res.send('Backend is running!');
});

app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
