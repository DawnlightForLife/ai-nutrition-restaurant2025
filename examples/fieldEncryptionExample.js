/**
 * 字段级加密集成示例
 * 
 * 演示如何在应用程序中集成字段级加密功能
 */

const mongoose = require('mongoose');
const express = require('express');
const FieldEncryptionService = require('../backend/services/security/fieldEncryptionService');
const { applyFieldEncryption } = require('../backend/middleware/database/fieldEncryptionMiddleware');
const logger = require('../backend/utils/logger/winstonLogger');

// 创建示例应用
const app = express();
app.use(express.json());

// 创建用户模式（包含敏感字段）
const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true },
  phone: { type: String },
  idCard: { type: String },
  personalInfo: {
    address: { type: String },
    birthDate: { type: Date }
  },
  emergencyContact: {
    name: { type: String },
    phone: { type: String }
  },
  createdAt: { type: Date, default: Date.now }
});

// 初始化字段加密
async function initializeEncryption() {
  try {
    // 连接到MongoDB
    await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/encryption_example');
    logger.info('已连接到MongoDB');
    
    // 创建并初始化字段加密服务
    const encryptionMiddleware = await applyFieldEncryption({
      kmsProvider: 'local',
      masterKeyPath: './example-master-key.txt'
    });
    
    // 注册中间件
    app.use(encryptionMiddleware);
    
    // 注册路由
    registerRoutes();
    
    // 启动服务器
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      logger.info(`服务器已启动，监听端口 ${PORT}`);
    });
  } catch (error) {
    logger.error('初始化字段加密失败:', error);
    process.exit(1);
  }
}

// 注册API路由
function registerRoutes() {
  // 创建用户模型
  const User = mongoose.model('User', userSchema);
  
  // API路由 - 创建用户
  app.post('/api/users', async (req, res) => {
    try {
      const userData = req.body;
      
      // 创建用户（敏感字段会自动加密）
      const newUser = new User(userData);
      await newUser.save();
      
      // 返回成功响应
      res.status(201).json({
        success: true,
        message: '用户创建成功',
        data: {
          id: newUser._id,
          username: newUser.username,
          email: newUser.email
          // 不返回敏感信息
        }
      });
    } catch (error) {
      logger.error('创建用户失败:', error);
      res.status(500).json({
        success: false,
        message: '创建用户失败',
        error: error.message
      });
    }
  });
  
  // API路由 - 获取用户
  app.get('/api/users/:id', async (req, res) => {
    try {
      const userId = req.params.id;
      
      // 查找用户（加密字段会自动解密）
      const user = await User.findById(userId);
      
      if (!user) {
        return res.status(404).json({
          success: false,
          message: '找不到用户'
        });
      }
      
      // 返回用户数据
      res.json({
        success: true,
        data: user
      });
    } catch (error) {
      logger.error('获取用户失败:', error);
      res.status(500).json({
        success: false,
        message: '获取用户失败',
        error: error.message
      });
    }
  });
  
  // API路由 - 通过电话号码查询用户（演示确定性加密查询）
  app.get('/api/users/phone/:phone', async (req, res) => {
    try {
      const phone = req.params.phone;
      
      // 查询用户（电话号码字段使用确定性加密，可以用于查询）
      // 中间件会自动加密查询条件
      const user = await User.findOne({ phone });
      
      if (!user) {
        return res.status(404).json({
          success: false,
          message: '找不到用户'
        });
      }
      
      // 返回用户数据
      res.json({
        success: true,
        data: user
      });
    } catch (error) {
      logger.error('按电话查询用户失败:', error);
      res.status(500).json({
        success: false,
        message: '查询用户失败',
        error: error.message
      });
    }
  });
  
  // API路由 - 更新用户
  app.put('/api/users/:id', async (req, res) => {
    try {
      const userId = req.params.id;
      const updateData = req.body;
      
      // 更新用户数据（敏感字段会自动加密）
      const updatedUser = await User.findByIdAndUpdate(
        userId,
        updateData,
        { new: true }
      );
      
      if (!updatedUser) {
        return res.status(404).json({
          success: false,
          message: '找不到用户'
        });
      }
      
      // 返回更新后的用户数据
      res.json({
        success: true,
        message: '用户更新成功',
        data: updatedUser
      });
    } catch (error) {
      logger.error('更新用户失败:', error);
      res.status(500).json({
        success: false,
        message: '更新用户失败',
        error: error.message
      });
    }
  });
  
  // API路由 - 加密服务状态
  app.get('/api/encryption/status', async (req, res) => {
    try {
      if (!req.fieldEncryptionService) {
        return res.status(503).json({
          success: false,
          message: '字段加密服务未初始化'
        });
      }
      
      // 获取加密密钥列表
      const keys = await req.fieldEncryptionService.listKeys();
      
      // 返回加密服务状态
      res.json({
        success: true,
        data: {
          initialized: true,
          kmsProvider: req.fieldEncryptionService.options.kmsProvider,
          keyCount: keys.length,
          keys: keys.map(key => ({
            id: key.id,
            altNames: key.altNames,
            createDate: key.createDate
          }))
        }
      });
    } catch (error) {
      logger.error('获取加密服务状态失败:', error);
      res.status(500).json({
        success: false,
        message: '获取加密服务状态失败',
        error: error.message
      });
    }
  });
  
  // 错误处理中间件
  app.use((err, req, res, next) => {
    logger.error('应用错误:', err);
    res.status(500).json({
      success: false,
      message: '服务器错误',
      error: err.message
    });
  });
}

// 启动应用
initializeEncryption().catch(error => {
  logger.error('应用启动失败:', error);
  process.exit(1);
});

/**
 * 测试指南:
 * 
 * 1. 设置环境变量:
 *    - MONGODB_URI=mongodb://localhost:27017/encryption_example
 * 
 * 2. 安装依赖:
 *    - npm install mongodb-client-encryption
 * 
 * 3. 运行示例:
 *    - node examples/fieldEncryptionExample.js
 * 
 * 4. 测试API:
 *    - 创建用户: POST http://localhost:3000/api/users
 *      {
 *        "username": "test_user",
 *        "email": "test@example.com",
 *        "phone": "1234567890",
 *        "idCard": "ID12345678",
 *        "personalInfo": {
 *          "address": "123 Test Street, City",
 *          "birthDate": "1990-01-01"
 *        },
 *        "emergencyContact": {
 *          "name": "Emergency Contact",
 *          "phone": "0987654321"
 *        }
 *      }
 * 
 *    - 获取用户: GET http://localhost:3000/api/users/:id
 *    - 按电话查询: GET http://localhost:3000/api/users/phone/1234567890
 *    - 更新用户: PUT http://localhost:3000/api/users/:id
 *    - 查看加密状态: GET http://localhost:3000/api/encryption/status
 * 
 * 5. 验证:
 *    - 直接从数据库查询用户，可以看到敏感字段已加密
 *    - 通过API获取用户，敏感字段会自动解密
 */ 