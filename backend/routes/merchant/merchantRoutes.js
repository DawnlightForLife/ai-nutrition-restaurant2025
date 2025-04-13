const express = require('express');
const router = express.Router();
const { createMerchant, getMerchantList, getMerchantById, updateMerchant, deleteMerchant, verifyMerchant } = require('../../controllers/merchant/merchantController');
const { auth, authorize } = require('../../middleware/auth');

/**
 * 商家相关路由
 */

// 创建商家
router.post('/', auth(), createMerchant);

// 获取商家列表
router.get('/', getMerchantList);

// 获取单个商家详情
router.get('/:id', getMerchantById);

// 更新商家
router.put('/:id', auth(), updateMerchant);

// 删除商家
router.delete('/:id', auth(), deleteMerchant);

// 审核商家资质
router.put('/:id/verify', auth(), authorize('admin'), verifyMerchant);

module.exports = router; 