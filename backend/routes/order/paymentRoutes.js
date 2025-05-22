/**
 * 支付路由
 * 处理支付相关操作，包括创建支付、查询支付状态等
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/order/paymentController');

/** TODO: 添加具体的路由逻辑 */
router.post('/create', controller.createPayment); // 创建支付
router.get('/status/:id', controller.getPaymentStatus); // 获取支付状态
router.post('/callback', controller.handlePaymentCallback); // 处理支付回调

module.exports = router;
