const express = require('express');
const router = express.Router();
const { createOrder, getOrderList, getOrderById, updateOrder, deleteOrder } = require('../../controllers/order/orderController');

/**
 * 订单管理路由
 * 提供创建、获取、更新、删除订单的接口
 * @module routes/order/orderRoutes
 */

// [POST] 创建订单
router.post('/', createOrder);

// [GET] 获取订单列表
router.get('/', getOrderList);

// [GET] 获取指定订单详情
router.get('/:id', getOrderById);

// [PUT] 更新订单
router.put('/:id', updateOrder);

// [DELETE] 删除订单
router.delete('/:id', deleteOrder);

module.exports = router;
