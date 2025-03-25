const User = require('../models/userModel');
const jwt = require('jsonwebtoken');

// JWT密钥，在实际项目中应该存储在环境变量中
const JWT_SECRET = 'smart_nutrition_restaurant_secret';

// 常规登录
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

    // 生成JWT令牌
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '7d' });

    return res.json({ 
      success: true, 
      message: '登录成功', 
      user: {
        _id: user._id,
        phone: user.phone,
        nickname: user.nickname || '',
        hasCompletedHealthInfo: Boolean(user.height && user.weight && user.age)
      },
      token
    });
  } catch (error) {
    console.error('登录错误:', error);
    return res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 微信登录
const wechatLogin = async (req, res) => {
  const { code } = req.body;
  
  if (!code) {
    return res.status(400).json({ success: false, message: '微信授权码不能为空' });
  }
  
  try {
    // 临时模拟微信登录流程，实际项目中需要调用微信API
    // 模拟openid，实际项目中通过微信API获取
    const mockOpenId = `wx_${Date.now()}_${Math.random().toString(36).substring(2, 10)}`;
    
    // 查找或创建用户
    let user = await User.findOne({ wechatOpenId: mockOpenId });
    
    if (!user) {
      // 如果用户不存在，创建新用户
      user = new User({
        wechatOpenId: mockOpenId,
        nickname: `用户${Math.floor(Math.random() * 10000)}`,
      });
      await user.save();
    }
    
    // 生成JWT令牌
    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '7d' });
    
    return res.json({
      success: true,
      message: '微信登录成功',
      user: {
        _id: user._id,
        phone: user.phone || '',
        nickname: user.nickname || '',
        hasCompletedHealthInfo: Boolean(user.height && user.weight && user.age)
      },
      token
    });
  } catch (error) {
    console.error('微信登录错误:', error);
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
    
    // 生成JWT令牌
    const token = jwt.sign({ userId: newUser._id }, JWT_SECRET, { expiresIn: '7d' });
    
    console.log('新用户已保存:', newUser);
    res.json({ 
      success: true, 
      message: '注册成功', 
      user: {
        _id: newUser._id,
        phone: newUser.phone,
        hasCompletedHealthInfo: false
      },
      token
    });
  } catch (error) {
    console.error('注册失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 更新用户健康信息
const updateHealthInfo = async (req, res) => {
  const { 
    height, 
    weight, 
    age, 
    gender, 
    activityLevel,
    healthIssues = [],
    hasRecentMedicalReport = false
  } = req.body;
  
  try {
    const userId = req.user.userId; // 从JWT中获取
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: '用户不存在' });
    }
    
    // 更新健康信息
    user.height = height || user.height;
    user.weight = weight || user.weight;
    user.age = age || user.age;
    user.gender = gender || user.gender;
    user.activityLevel = activityLevel || user.activityLevel;
    
    // 更新健康数据
    user.healthData.healthIssues = healthIssues;
    user.healthData.hasRecentMedicalReport = hasRecentMedicalReport;
    
    await user.save();
    
    res.json({
      success: true,
      message: '健康信息更新成功',
      user: {
        _id: user._id,
        height: user.height,
        weight: user.weight,
        age: user.age,
        gender: user.gender,
        activityLevel: user.activityLevel,
        hasCompletedHealthInfo: Boolean(user.height && user.weight && user.age)
      }
    });
  } catch (error) {
    console.error('更新健康信息失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 更新用户地区与饮食偏好
const updateRegionAndPreferences = async (req, res) => {
  const {
    province,
    city,
    cuisinePreference,
    spicyPreference,
    allergies = [],
    avoidedIngredients = []
  } = req.body;
  
  try {
    const userId = req.user.userId; // 从JWT中获取
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: '用户不存在' });
    }
    
    // 更新地区信息
    if (province) user.region.province = province;
    if (city) user.region.city = city;
    
    // 更新饮食偏好
    if (cuisinePreference) user.dietaryPreferences.cuisinePreference = cuisinePreference;
    if (spicyPreference) user.dietaryPreferences.spicyPreference = spicyPreference;
    if (allergies.length > 0) user.dietaryPreferences.allergies = allergies;
    if (avoidedIngredients.length > 0) user.dietaryPreferences.avoidedIngredients = avoidedIngredients;
    
    await user.save();
    
    res.json({
      success: true,
      message: '地区和饮食偏好更新成功',
      region: user.region,
      dietaryPreferences: user.dietaryPreferences
    });
  } catch (error) {
    console.error('更新地区和饮食偏好失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 上传医疗报告
const uploadMedicalReport = async (req, res) => {
  // 此方法需要文件上传中间件，如multer
  try {
    const userId = req.user.userId;
    const reportUrl = req.file ? req.file.path : '';
    
    if (!reportUrl) {
      return res.status(400).json({ success: false, message: '未接收到文件' });
    }
    
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, message: '用户不存在' });
    }
    
    user.healthData.medicalReportUrl = reportUrl;
    user.healthData.hasRecentMedicalReport = true;
    
    await user.save();
    
    res.json({
      success: true,
      message: '医疗报告上传成功',
      reportUrl
    });
  } catch (error) {
    console.error('上传医疗报告失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

// 获取用户资料
const getUserProfile = async (req, res) => {
  try {
    const userId = req.user.userId;
    
    const user = await User.findById(userId).select('-password');
    if (!user) {
      return res.status(404).json({ success: false, message: '用户不存在' });
    }
    
    res.json({
      success: true,
      user
    });
  } catch (error) {
    console.error('获取用户资料失败:', error);
    res.status(500).json({ success: false, message: '服务器错误' });
  }
};

module.exports = {
  loginUser,
  registerUser,
  wechatLogin,
  updateHealthInfo,
  updateRegionAndPreferences,
  uploadMedicalReport,
  getUserProfile
};
