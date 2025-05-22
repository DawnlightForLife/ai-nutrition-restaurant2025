/**
 * 反馈路由
 * 处理用户反馈的提交和查询
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/feedback/feedbackController');

/** TODO: 添加中间件处理 */
router.post('/', controller.submitFeedback); // 提交反馈
router.get('/', controller.getFeedbackList); // 获取反馈列表

module.exports = router;
