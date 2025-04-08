const express = require('express');
const router = express.Router();
const { createHealthData, getHealthDataList, getHealthDataById, updateHealthData, deleteHealthData } = require('../../controllers/health/healthDataController');

/**
 * 健康数据相关路由
 */

// 创建健康数据
router.post('/', createHealthData);

// 获取健康数据列表
router.get('/', getHealthDataList);

// 获取单个健康数据详情
router.get('/:id', getHealthDataById);

// 更新健康数据
router.put('/:id', updateHealthData);

// 删除健康数据
router.delete('/:id', deleteHealthData);

module.exports = router; 