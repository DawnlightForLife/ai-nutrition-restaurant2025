const express = require('express');
const router = express.Router();
const { createNotification, getNotificationList, getNotificationById, updateNotification, deleteNotification } = require('../../controllers/misc/notificationController');

/**
 * 通知管理路由
 * 提供通知的创建、查询、更新和删除接口
 * @module routes/misc/notificationRoutes
 */

// [POST] 创建通知
router.post('/', createNotification);

// [GET] 获取通知列表
router.get('/', getNotificationList);

// [GET] 获取单个通知详情
router.get('/:id', getNotificationById);

// [PUT] 更新通知
router.put('/:id', updateNotification);

// [DELETE] 删除通知
router.delete('/:id', deleteNotification);

module.exports = router; 