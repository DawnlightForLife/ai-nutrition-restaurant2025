const express = require('express');
const router = express.Router();
const { createSubscription, getSubscriptionList, getSubscriptionById, updateSubscription, deleteSubscription } = require('../../controllers/order/subscriptionController');

/**
 * 订阅相关路由
 */

// 创建订阅
router.post('/', createSubscription);

// 获取订阅列表
router.get('/', getSubscriptionList);

// 获取单个订阅详情
router.get('/:id', getSubscriptionById);

// 更新订阅
router.put('/:id', updateSubscription);

// 删除订阅
router.delete('/:id', deleteSubscription);

module.exports = router;
