/**
 * 聊天消息路由
 * 处理咨询聊天消息的增删改查
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/consult/chatMessageController');

/** TODO: 添加中间件处理 */
router.get('/:consultationId', controller.getChatMessageList); // 获取聊天消息列表
router.post('/', controller.sendChatMessage); // 发送聊天消息

module.exports = router;
