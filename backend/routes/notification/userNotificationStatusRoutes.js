/**
 * 用户通知状态路由
 * 处理用户通知设置和状态的查询与更新
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/notification/userNotificationStatusController');

/** TODO: 添加中间件处理 */
router.get('/', controller.getUserNotificationSettings); // 获取用户通知设置
router.put('/', controller.updateUserNotificationSettings); // 更新用户通知设置

module.exports = router;
