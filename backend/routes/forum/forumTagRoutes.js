/**
 * 论坛标签路由
 * 处理论坛标签的增删改查
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/forum/forumTagController');

/** TODO: 添加中间件处理 */
router.get('/', controller.getForumTagList); // 获取论坛标签列表
router.post('/', controller.createForumTag); // 创建论坛标签

module.exports = router;
