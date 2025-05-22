/**
 * 促销活动路由
 * 处理商家促销活动的创建、查询等功能
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/merchant/promotionController');

/** TODO: 添加具体的路由逻辑 */
router.get('/', controller.getPromotionList); // 获取促销活动列表
router.post('/', controller.createPromotion); // 创建促销活动
router.get('/:id', controller.getPromotionDetail); // 获取促销活动详情

module.exports = router;
