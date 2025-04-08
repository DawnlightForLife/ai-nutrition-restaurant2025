const express = require('express');
const router = express.Router();
const { createForumComment, getForumCommentList, getForumCommentById, updateForumComment, deleteForumComment } = require('../../controllers/forum/forumCommentController');

/**
 * 论坛评论相关路由
 */

// 创建评论
router.post('/', createForumComment);

// 获取评论列表
router.get('/', getForumCommentList);

// 获取单个评论详情
router.get('/:id', getForumCommentById);

// 更新评论
router.put('/:id', updateForumComment);

// 删除评论
router.delete('/:id', deleteForumComment);

module.exports = router; 