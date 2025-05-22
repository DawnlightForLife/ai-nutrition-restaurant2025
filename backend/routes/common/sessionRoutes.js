/**
 * 会话管理路由
 * 处理用户会话的相关操作
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/common/sessionController');

/** TODO: 添加中间件处理 */
router.get('/', controller.getSession); // 获取会话信息
router.delete('/', controller.destroySession); // 销毁会话

module.exports = router;
