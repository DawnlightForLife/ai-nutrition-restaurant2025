/**
 * 导出任务路由
 * 处理数据导出任务的创建和状态查询
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/analytics/exportTaskController');

/** TODO: 添加中间件处理 */
router.post('/', controller.createExportTask); // 创建导出任务
router.get('/:id/status', controller.getExportTaskStatus); // 获取导出任务状态

module.exports = router;
