const express = require('express');
const router = express.Router();
const { createOrder, getOrderList, getOrderById, updateOrder, deleteOrder } = require('../../controllers/order/orderController');

/**
 * 订单相关路由
 */

// 创建订单
router.post('/', createOrder);

// 获取订单列表
router.get('/', getOrderList);

// 获取单个订单详情
router.get('/:id', getOrderById);

// 更新订单
router.put('/:id', updateOrder);

// 删除订单
router.delete('/:id', deleteOrder);

module.exports = router;
