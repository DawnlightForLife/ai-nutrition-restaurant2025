const express = require('express');
const router = express.Router();
const { createForumComment, getForumCommentList, getForumCommentById, updateForumComment, deleteForumComment } = require('../../controllers/forum/forumCommentController');

/**
 * 论坛评论管理路由
 * 包含创建、查询、更新、删除评论的接口
 * @module routes/forum/forumCommentRoutes
 */

// [POST] 创建评论
router.post('/', createForumComment);

// [GET] 获取评论列表
router.get('/', getForumCommentList);

// [GET] 获取单个评论详情
router.get('/:id', getForumCommentById);

// [PUT] 更新评论
router.put('/:id', updateForumComment);

// [DELETE] 删除评论
router.delete('/:id', deleteForumComment);

module.exports = router; 