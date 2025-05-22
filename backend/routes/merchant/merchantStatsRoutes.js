const express = require('express');
const router = express.Router();
const { createMerchantStats, getMerchantStatsList, getMerchantStatsById, updateMerchantStats, deleteMerchantStats } = require('../../controllers/merchant/merchantStatsController');

/**
 * 商家经营统计路由
 * 提供创建、查询、更新、删除商家统计数据的接口
 * @module routes/merchant/merchantStatsRoutes
 */

// [POST] 创建商家统计数据
router.post('/', createMerchantStats);

// [GET] 获取商家统计数据列表
router.get('/', getMerchantStatsList);

// [GET] 获取单个商家统计数据详情
router.get('/:id', getMerchantStatsById);

// [PUT] 更新商家统计数据
router.put('/:id', updateMerchantStats);

// [DELETE] 删除商家统计数据
router.delete('/:id', deleteMerchantStats);

module.exports = router;