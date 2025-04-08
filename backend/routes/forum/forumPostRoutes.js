const express = require('express');
const router = express.Router();
const { createForumPost, getForumPostList, getForumPostById, updateForumPost, deleteForumPost } = require('../../controllers/forum/forumPostController');

/**
 * 论坛帖子相关路由
 */

// 创建帖子
router.post('/', createForumPost);

// 获取帖子列表
router.get('/', getForumPostList);

// 获取单个帖子详情
router.get('/:id', getForumPostById);

// 更新帖子
router.put('/:id', updateForumPost);

// 删除帖子
router.delete('/:id', deleteForumPost);

module.exports = router; 