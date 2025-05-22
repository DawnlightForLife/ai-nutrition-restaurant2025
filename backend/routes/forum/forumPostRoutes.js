const express = require('express');
const router = express.Router();
const { createForumPost, getForumPostList, getForumPostById, updateForumPost, deleteForumPost } = require('../../controllers/forum/forumPostController');

/**
 * 论坛帖子路由
 * 提供创建、查询、更新和删除论坛帖子的接口
 * @module routes/forum/forumPostRoutes
 */

// [POST] 创建帖子
router.post('/', createForumPost);

// [GET] 获取帖子列表
router.get('/', getForumPostList);

// [GET] 获取帖子详情
router.get('/:id', getForumPostById);

// [PUT] 更新帖子
router.put('/:id', updateForumPost);

// [DELETE] 删除帖子
router.delete('/:id', deleteForumPost);

module.exports = router; 