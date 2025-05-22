/**
 * 使用日志路由
 * 处理系统使用日志的查询和分析
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/analytics/usageLogController');

/** TODO: 添加中间件处理 */
router.get('/', controller.getUsageLogList); // 获取使用日志列表
router.get('/statistics', controller.getUsageStatistics); // 获取使用统计

module.exports = router;
