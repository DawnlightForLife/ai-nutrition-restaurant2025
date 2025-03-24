const User = require('../models/userModel');

exports.loginUser = async (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ success: false, message: '手机号和密码不能为空' });
  }

  try {
    const user = await User.findOne({ phone });

    if (!user || user.password !== password) {
      return res.status(401).json({ success: false, message: '手机号或密码错误' });
    }

    return res.json({ success: true, message: '登录成功', user });
  } catch (error) {
    return res.status(500).json({ success: false, message: '服务器错误' });
  }
};
