const User = require('../models/userModel');

const loginUser = async (req, res) => {
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

// 注册用户

const registerUser = async (req, res) => {
  const { phone, password } = req.body;

  if (!phone || !password) {
    return res.status(400).json({ success: false, message: "手机号和密码不能为空" });
  }
  try {
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({ success: false, message: '用户已存在' });
    }

    const newUser = new User({ phone, password });
    await newUser.save();
    console.log('新用户已保存:', newUser);
    res.json({ success: true, message: '注册成功', user: newUser });
  } catch (error) {
    console.error('注册失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};


module.exports = {
  loginUser,
  registerUser,
};
