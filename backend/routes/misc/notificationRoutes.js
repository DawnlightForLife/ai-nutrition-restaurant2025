const express = require('express');
const router = express.Router();
const { createNotification, getNotificationList, getNotificationById, updateNotification, deleteNotification } = require('../../controllers/misc/notificationController');

/**
 * 通知相关路由
 */

// 创建通知
router.post('/', createNotification);

// 获取通知列表
router.get('/', getNotificationList);

// 获取单个通知详情
router.get('/:id', getNotificationById);

// 更新通知
router.put('/:id', updateNotification);

// 删除通知
router.delete('/:id', deleteNotification);

module.exports = router; 