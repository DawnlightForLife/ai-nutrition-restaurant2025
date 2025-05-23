/****
 * 商家信息管理路由
 * 包含创建、获取、更新、删除商家及资质审核的接口
 * @module routes/merchant/merchantRoutes
 */
const express = require('express');
const router = express.Router();
const { createMerchant, getMerchantList, getMerchantById, updateMerchant, deleteMerchant, verifyMerchant } = require('../../controllers/merchant/merchantController');
const authMiddleware = require('../../middleware/auth');
const auth = authMiddleware.auth || authMiddleware.authenticateUser;
const authorize = authMiddleware.authorize;

// [POST] 创建商家
router.post('/', auth(), createMerchant);

// [GET] 获取商家列表
router.get('/', getMerchantList);

// [GET] 获取指定商家详情
router.get('/:id', getMerchantById);

// [PUT] 更新商家信息
router.put('/:id', auth(), updateMerchant);

// [DELETE] 删除商家
router.delete('/:id', auth(), deleteMerchant);

// [PUT] 审核商家资质
router.put('/:id/verify', auth(), authorize('admin'), verifyMerchant);

module.exports = router;