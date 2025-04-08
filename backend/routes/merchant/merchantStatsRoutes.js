const express = require('express');
const router = express.Router();
const { createMerchantStats, getMerchantStatsList, getMerchantStatsById, updateMerchantStats, deleteMerchantStats } = require('../../controllers/merchant/merchantStatsController');

/**
 * 商家统计相关路由
 */

// 创建商家统计
router.post('/', createMerchantStats);

// 获取商家统计列表
router.get('/', getMerchantStatsList);

// 获取单个商家统计详情
router.get('/:id', getMerchantStatsById);

// 更新商家统计
router.put('/:id', updateMerchantStats);

// 删除商家统计
router.delete('/:id', deleteMerchantStats);

module.exports = router;