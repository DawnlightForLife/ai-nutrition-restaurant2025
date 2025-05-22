const express = require('express');
const router = express.Router();
const { createSubscription, getSubscriptionList, getSubscriptionById, updateSubscription, deleteSubscription } = require('../../controllers/order/subscriptionController');

/**
 * 订阅管理路由
 * 提供创建、获取、更新、删除订阅的接口
 * @module routes/order/subscriptionRoutes
 */

// [POST] 创建订阅
router.post('/', createSubscription);

// [GET] 获取订阅列表
router.get('/', getSubscriptionList);

// [GET] 获取单个订阅详情
router.get('/:id', getSubscriptionById);

// [PUT] 更新订阅
router.put('/:id', updateSubscription);

// [DELETE] 删除订阅
router.delete('/:id', deleteSubscription);

module.exports = router;
