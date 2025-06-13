const express = require('express');
const router = express.Router();
const systemConfigController = require('../../controllers/core/systemConfigController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');

/**
 * 系统配置路由
 * 提供系统配置的管理接口
 */

// ============ 公开接口 ============
// 获取公开配置（无需认证）
router.get('/public', systemConfigController.getPublicConfigs);

// 获取认证功能配置（无需认证）
router.get('/certification', systemConfigController.getCertificationConfigs);

// ============ 管理后台接口 ============
// 只需要身份验证（admin backend 用户已经通过管理后台访问）
router.use(authenticateUser);

// 获取配置分类列表
router.get('/categories', systemConfigController.getCategories);

// 获取所有配置
router.get('/', systemConfigController.getAllConfigs);

// 初始化默认配置
router.post('/initialize', systemConfigController.initializeDefaults);

// 批量更新认证配置
router.put('/certification', systemConfigController.updateCertificationConfigs);

// 获取单个配置
router.get('/:key', systemConfigController.getConfig);

// 更新配置
router.put('/:key', systemConfigController.updateConfig);

// 创建配置
router.post('/', systemConfigController.createConfig);

// 删除配置
router.delete('/:key', systemConfigController.deleteConfig);

module.exports = router;