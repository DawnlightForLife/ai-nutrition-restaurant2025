const express = require('express');
const router = express.Router();
const { createAppConfig, getAppConfigList, getAppConfigById, updateAppConfig, deleteAppConfig } = require('../../controllers/misc/appConfigController');

/**
 * 应用配置相关路由
 */

// 创建应用配置
router.post('/', createAppConfig);

// 获取应用配置列表
router.get('/', getAppConfigList);

// 获取单个应用配置详情
router.get('/:id', getAppConfigById);

// 更新应用配置
router.put('/:id', updateAppConfig);

// 删除应用配置
router.delete('/:id', deleteAppConfig);

module.exports = router;
