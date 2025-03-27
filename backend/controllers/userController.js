const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cacheService = require('../services/cacheService');
const AuditLog = require('../models/auditLogModel');
const { shardingConfig, getShardName } = require('../utils/shardingConfig');
const { getDb } = require('../utils/db');
require('dotenv').config();

// JWT密钥，优先使用环境变量
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

// 常规登录
const loginUser = async (req, res) => {
  try {
    const { phone, password } = req.body;
    console.log('[LOGIN] 尝试登录，手机号:', phone);
    
    // 使用Mongoose模型直接查询，不依赖于外部的db.js
    const user = await User.findOne({ phone });
    
    if (!user) {
      console.log('[LOGIN] 登录失败：用户不存在, 手机号:', phone);
      return res.status(401).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 验证密码
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      console.log('[LOGIN] 登录失败：密码错误, 手机号:', phone);
      return res.status(401).json({
        success: false,
        message: '密码错误'
      });
    }
    
    // 生成JWT token
    console.log('[LOGIN] 密码验证成功，正在生成令牌, 用户ID:', user._id);
    const token = jwt.sign(
      { userId: user._id, role: user.role },
      JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    console.log('[LOGIN] 令牌生成成功，长度:', token.length);
    
    // 记录登录审计日志
    try {
      await AuditLog.create({
        action: 'user_login',
        description: '用户登录系统',
        actor: {
          type: 'user',
          id: user._id,
          model: 'User',
          name: user.nickname || user.phone
        },
        resource: {
          type: 'user',
          id: user._id,
          name: user.nickname || user.phone
        },
        result: {
          status: 'success',
          message: '登录成功'
        },
        context: {
          ip_address: req.ip || '未知',
          user_agent: req.headers['user-agent'] || '未知'
        },
        sensitivity_level: 3 // 低敏感度
      });
    } catch (logError) {
      console.error('记录审计日志失败:', logError);
      // 不阻止登录流程继续
    }
    
    // 返回用户信息和token
    res.json({
      success: true,
      token,
      user: {
        id: user._id,
        nickname: user.nickname,
        phone: user.phone,
        role: user.role,
        dietaryPreferences: user.dietaryPreferences
      }
    });
    
  } catch (error) {
    console.error('[LOGIN] 登录错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
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
        role: user.role || 'user',
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
  try {
    const { phone, password, nickname } = req.body;
    
    // 使用Mongoose模型检查用户是否已存在
    const existingUser = await User.findOne({ phone });
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: '该手机号已注册'
      });
    }
    
    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // 创建新用户
    const user = new User({
      phone,
      password: hashedPassword,
      nickname,
      role: 'user'
    });
    
    // 保存用户
    await user.save();
    
    // 生成JWT token
    const token = jwt.sign(
      { userId: user._id, role: user.role },
      JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN || '7d' }
    );
    
    // 记录审计日志
    try {
      await AuditLog.create({
        action: 'user_register',
        description: '用户注册系统',
        actor: {
          type: 'user',
          id: user._id,
          model: 'User',
          name: user.nickname || user.phone
        },
        resource: {
          type: 'user',
          id: user._id,
          name: user.nickname || user.phone
        },
        result: {
          status: 'success',
          message: '注册成功'
        },
        context: {
          ip_address: req.ip || '未知',
          user_agent: req.headers['user-agent'] || '未知'
        },
        sensitivity_level: 2 // 中敏感度
      });
    } catch (logError) {
      console.error('记录审计日志失败:', logError);
      // 继续注册流程
    }
    
    res.status(201).json({
      success: true,
      token,
      user: {
        id: user._id,
        nickname: user.nickname,
        phone: user.phone,
        role: user.role
      }
    });
    
  } catch (error) {
    console.error('注册错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 获取用户资料
const getUserProfile = async (req, res) => {
  try {
    const userId = req.user.userId;
    const db = await getDb();
    
    // 获取用户所在的分片
    const user = await db.collection('users').findOne({ _id: userId });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 获取用户的健康数据
    const healthData = await db.collection('healthData').findOne({ userId });
    
    res.json({
      success: true,
      user: {
        id: user._id,
        nickname: user.nickname,
        phone: user.phone,
        role: user.role,
        healthData: healthData || {}
      }
    });
    
  } catch (error) {
    console.error('获取用户资料错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 更新用户信息
const updateUserInfo = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { nickname, phone } = req.body;
    const db = await getDb();
    
    // 获取用户所在的分片
    const shardName = getShardName('user', { phone });
    
    // 更新用户信息
    await db.collection(shardName).updateOne(
      { _id: userId },
      { 
        $set: { 
          nickname,
          phone,
          updatedAt: new Date()
        } 
      }
    );
    
    res.json({
      success: true,
      message: '用户信息更新成功'
    });
    
  } catch (error) {
    console.error('更新用户信息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 更新健康信息
const updateHealthInfo = async (req, res) => {
  try {
    const userId = req.user.userId;
    const healthInfo = req.body;
    const db = await getDb();
    
    // 获取健康数据分片名称
    const shardName = getShardName('healthData', { userId });
    
    // 更新健康信息
    await db.collection(shardName).updateOne(
      { userId },
      { 
        $set: { 
          ...healthInfo,
          updatedAt: new Date()
        }
      },
      { upsert: true }
    );
    
    res.json({
      success: true,
      message: '健康信息更新成功'
    });
    
  } catch (error) {
    console.error('更新健康信息错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 更新地区和饮食偏好
const updateRegionAndPreferences = async (req, res) => {
  try {
    const userId = req.user.userId;
    const { region, dietaryPreferences } = req.body;
    const db = await getDb();
    
    // 获取用户所在的分片
    const user = await db.collection('users').findOne({ _id: userId });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    const shardName = getShardName('user', { phone: user.phone });
    
    // 更新用户信息
    await db.collection(shardName).updateOne(
      { _id: userId },
      { 
        $set: { 
          region,
          dietaryPreferences,
          updatedAt: new Date()
        } 
      }
    );
    
    res.json({
      success: true,
      message: '地区和饮食偏好更新成功'
    });
    
  } catch (error) {
    console.error('更新地区和饮食偏好错误:', error);
    res.status(500).json({
      success: false,
      message: '服务器错误'
    });
  }
};

// 上传医疗报告
const uploadMedicalReport = async (req, res) => {
  try {
    const userId = req.user.userId;
    const reportUrl = req.file ? req.file.path : '';
    
    if (!reportUrl) {
      return res.status(400).json({ success: false, message: '未接收到文件' });
    }
    
    const db = await getDb();
    
    // 使用分片策略查找用户
    const shardKey = userId;
    const strategy = shardingConfig.strategies.User;
    const shardCollectionName = getShardName('users', shardKey, strategy);
    
    // 从分片中查找用户
    const user = await db.collection(shardCollectionName).findOne({ _id: userId });
    if (!user) {
      return res.status(404).json({ success: false, message: '用户不存在' });
    }
    
    // 更新医疗报告信息
    const updateData = {
      'healthData.medicalReportUrl': reportUrl,
      'healthData.hasRecentMedicalReport': true,
      updatedAt: new Date()
    };
    
    // 更新分片中的数据
    await db.collection(shardCollectionName).updateOne(
      { _id: userId },
      { $set: updateData }
    );
    
    // 同时更新原始集合
    await db.collection('users').updateOne(
      { _id: userId },
      { $set: updateData }
    );
    
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

// 获取用户信息的处理器
const getUserInfo = async (req, res) => {
  try {
    const userId = req.user.id;
    
    // 使用分片感知的方法查找用户
    const user = await User.findByIdFromShards(userId);
    if (!user) {
      return res.status(404).json({ message: '用户不存在' });
    }
    
    res.status(200).json({
      user: {
        id: user._id,
        nickname: user.nickname,
        phone: user.phone,
        age: user.age,
        gender: user.gender,
        height: user.height,
        weight: user.weight,
        activityLevel: user.activityLevel,
        region: user.region,
        dietaryPreferences: user.dietaryPreferences,
        healthData: user.healthData,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
      }
    });
  } catch (error) {
    console.error('获取用户信息失败:', error);
    res.status(500).json({ message: '服务器错误' });
  }
};

module.exports = {
  loginUser,
  registerUser,
  wechatLogin,
  updateHealthInfo,
  updateRegionAndPreferences,
  uploadMedicalReport,
  getUserProfile,
  updateUserInfo,
  getUserInfo
};
