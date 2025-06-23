/**
 * 咨询管理路由
 * 处理营养咨询的增删改查
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/consult/consultationController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');

// 需要认证的路由
router.use(authenticateUser);

// 咨询管理
router.get('/', controller.getConsultationList); // 获取咨询列表
router.post('/', controller.createConsultation); // 创建咨询
router.get('/market', controller.getConsultationMarket); // 获取咨询市场
router.get('/:id', controller.getConsultationDetail); // 获取咨询详情
router.put('/:id/status', controller.updateConsultationStatus); // 更新咨询状态

module.exports = router;
