const express = require('express');
const router = express.Router();
const { createConsultation, getConsultationList, getConsultationById, updateConsultation, deleteConsultation } = require('../../controllers/order/consultationController');

/**
 * 咨询相关路由
 */

// 创建咨询
router.post('/', createConsultation);

// 获取咨询列表
router.get('/', getConsultationList);

// 获取单个咨询详情
router.get('/:id', getConsultationById);

// 更新咨询
router.put('/:id', updateConsultation);

// 删除咨询
router.delete('/:id', deleteConsultation);

module.exports = router;
