/**
 * 咨询服务管理路由
 * 提供创建、获取、更新和删除咨询记录的接口
 * @module routes/order/consultationRoutes
 */

const express = require('express');
const router = express.Router();
const { createConsultation, getConsultationList, getConsultationById, updateConsultation, deleteConsultation } = require('../../controllers/order/consultationOrderController');

// [POST] 创建咨询
router.post('/', createConsultation);

// [GET] 获取咨询列表
router.get('/', getConsultationList);

// [GET] 获取指定咨询详情
router.get('/:id', getConsultationById);

// [PUT] 更新指定咨询
router.put('/:id', updateConsultation);

// [DELETE] 删除指定咨询
router.delete('/:id', deleteConsultation);

module.exports = router;
