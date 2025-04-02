const User = require('../models/userModel');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const cacheService = require('../services/cacheService');
const AuditLog = require('../models/auditLogModel');
const { shardingConfig, getShardName } = require('../utils/shardingConfig');
const { getDb } = require('../utils/db');
const dbManager = require('../config/database');
const mongoose = require('mongoose');
const userService = require('../services/userService');
require('dotenv').config();

// JWT密钥，优先使用环境变量
const JWT_SECRET = process.env.JWT_SECRET || 'smart_nutrition_restaurant_secret';

// 常规登录
const loginUser = async (req, res) => {
  try {
    const { phone, password } = req.body;
    console.log('[LOGIN] 尝试登录，手机号:', phone);
    
    // 使用userService查询用户
    const user = await userService.findUserByPhone(phone);
    
    if (!user) {
      console.log('[LOGIN] 登录失败：用户不存在, 手机号:', phone);
      return res.status(401).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 验证密码
    console.log('[DEBUG] 数据库中加密密码:', user.password);
    const isValidPassword = await userService.verifyPassword(user, password);
    
    if (!isValidPassword) {
      console.log('[LOGIN] 登录失败：密码错误, 手机号:', user.phone);
      return res.status(401).json({
        success: false,
        message: '密码错误'
      });
    }
    
    // 生成JWT token
    console.log('[LOGIN] 密码验证成功，正在生成令牌, 用户ID:', user._id);
    const token = userService.generateToken({ 
      userId: user._id, 
      role: user.role 
    });
    
    // 记录成功的登录尝试
    console.log('[LOGIN] 登录成功, 用户ID:', user._id, ", 手机号:", user.phone);
    
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
    
    // 响应给客户端
    const userIdStr = user._id.toString();
    return res.json({
      success: true,
      message: '登录成功',
      token,
      user: {
        id: userIdStr,
        _id: userIdStr, // 保留 _id 以兼容旧代码
        nickname: user.nickname || '',
        phone: user.phone || '',
        role: user.role || 'user',
        avatar: user.avatar || ''
      }
    });
  } catch (error) {
    console.error('[LOGIN] 登录过程中出错:', error);
    return res.status(500).json({
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
    const token = userService.generateToken({
      userId: user._id,
      role: user.role
    });
    
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
    
    // 添加密码调试日志
    console.log('[REGISTER] 注册尝试，手机号:', phone);
    console.log('[REGISTER] 原始密码长度:', password.length);
    
    // 使用userService检查用户是否已存在
    const existingUser = await userService.findUserByPhone(phone);
    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: '该手机号已注册'
      });
    }
    
    // 使用userService创建用户
    const user = await userService.createUser({ phone, password, nickname });
    
    // 生成JWT token
    const token = userService.generateToken({
      userId: user._id,
      role: user.role
    });
    
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
    
    // 确保有 id 字段
    const userIdStr = user._id.toString();
    
    res.status(201).json({
      success: true,
      token,
      user: {
        id: userIdStr,
        _id: userIdStr, // 保留 _id 以兼容旧代码
        nickname: user.nickname || '',
        phone: user.phone || '',
        role: user.role || 'user',
        avatar: user.avatar || ''
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

// 获取用户信息的处理器 - 用于API
const getUserInfo = async (req, res) => {
  try {
    // 从令牌中获取用户ID
    const userId = req.user.id || req.user.userId;
    
    if (!userId) {
      return res.status(400).json({
        success: false,
        message: '令牌中未包含有效的用户ID'
      });
    }
    
    // 使用userService查找用户
    const user = await userService.findUserAcrossShards({ _id: userId });
    if (!user) {
      return res.status(404).json({
        success: false,
        message: '用户不存在'
      });
    }
    
    // 获取健康数据
    let healthData = user.healthData || {};
    
    // 如果用户文档中没有健康数据，尝试查询健康数据集合
    if (!healthData || Object.keys(healthData).length === 0) {
      try {
        // 基于用户所在分片构建健康数据分片名
        const userShard = userService.getUserShardName(user.phone);
        const healthDataShard = userShard.replace('user_shard_', 'healthdata_user_');
        
        // 查询健康数据
        const db = await dbManager.getPrimaryConnection();
        const healthDataDoc = await db.collection(healthDataShard).findOne({ userId: user._id.toString() });
        
        if (healthDataDoc) {
          healthData = healthDataDoc;
        }
      } catch (err) {
        console.error('查询健康数据失败:', err);
        // 继续使用用户文档中的健康数据
      }
    }
    
    // 确保有 id 字段，即使已经有 _id
    const userIdStr = user._id.toString();
    
    // 标准化响应，确保所有字段都有默认值
    res.status(200).json({
      success: true,
      user: {
        id: userIdStr,
        _id: userIdStr, // 保留 _id 以兼容旧代码
        nickname: user.nickname || '',
        phone: user.phone || '',
        age: user.age || 0,
        gender: user.gender || '',
        height: user.height || 0,
        weight: user.weight || 0,
        activityLevel: user.activityLevel || 'moderate',
        region: user.region || '',
        dietaryPreferences: user.dietaryPreferences || {},
        healthData: healthData || {},
        role: user.role || 'user',
        avatar: user.avatar || '',
        created_at: user.createdAt?.toISOString() || new Date().toISOString(),
        createdAt: user.createdAt || new Date(),
        updatedAt: user.updatedAt || new Date()
      }
    });
  } catch (error) {
    console.error('获取用户信息失败:', error);
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
    
    // 使用userService更新用户信息
    await userService.updateUser(userId, { nickname, phone });
    
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
    
    // 使用userService更新用户健康信息
    await userService.updateUser(userId, { 
      healthData: healthInfo 
    });
    
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
    
    // 使用userService更新用户信息
    await userService.updateUser(userId, { 
      region, 
      dietaryPreferences 
    });
    
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
    
    // 使用userService更新用户信息
    await userService.updateUser(userId, {
      healthData: {
        ...((await userService.findUserAcrossShards({ _id: userId }))?.healthData || {}),
        medicalReportUrl: reportUrl,
        hasRecentMedicalReport: true
      }
    });
    
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

module.exports = {
  loginUser,
  registerUser,
  wechatLogin,
  updateHealthInfo,
  updateRegionAndPreferences,
  uploadMedicalReport,
  getUserInfo,
  updateUserInfo
};
