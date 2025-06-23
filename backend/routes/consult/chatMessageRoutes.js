/**
 * 聊天消息路由
 * 处理咨询聊天消息的增删改查
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/consult/chatMessageController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');

// 需要认证的路由
router.use(authenticateUser);

// 聊天消息管理
router.get('/:consultationId', controller.getChatMessageList); // 获取聊天消息列表
router.post('/:consultationId', controller.sendChatMessage); // 发送聊天消息
router.put('/:consultationId/read', controller.markMessagesAsRead); // 标记已读
router.delete('/:consultationId/messages/:messageId', controller.deleteMessage); // 删除消息

module.exports = router;
