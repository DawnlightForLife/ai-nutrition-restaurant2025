/**
 * 咨询管理路由
 * 处理营养咨询的增删改查
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/consult/consultationController');

/** TODO: 添加中间件处理 */
router.get('/', controller.getConsultationList); // 获取咨询列表
router.post('/', controller.createConsultation); // 创建咨询

module.exports = router;
