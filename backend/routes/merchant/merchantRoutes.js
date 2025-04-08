const express = require('express');
const router = express.Router();
const { createMerchant, getMerchantList, getMerchantById, updateMerchant, deleteMerchant } = require('../../controllers/merchant/merchantController');

/**
 * 商家相关路由
 */

// 创建商家
router.post('/', createMerchant);

// 获取商家列表
router.get('/', getMerchantList);

// 获取单个商家详情
router.get('/:id', getMerchantById);

// 更新商家
router.put('/:id', updateMerchant);

// 删除商家
router.delete('/:id', deleteMerchant);

module.exports = router; 