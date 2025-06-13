/****
 * 商家信息管理路由（修复版）
 * 包含创建、获取、更新、删除商家及资质审核的接口
 * 新增获取当前用户商家申请的接口
 * @module routes/merchant/merchantRoutes
 */
const express = require('express');
const router = express.Router();
const { 
  createMerchant, 
  getMerchantList, 
  getMerchantById, 
  updateMerchant, 
  deleteMerchant, 
  verifyMerchant, 
  getMerchantStats,
  getCurrentUserMerchant  // 新增
} = require('../../controllers/merchant/merchantController');
const { authenticateUser, requireAdmin } = require('../../middleware/auth/authMiddleware');

// [POST] 创建商家
router.post('/', authenticateUser, createMerchant);

// [GET] 获取商家列表
router.get('/', getMerchantList);

// [GET] 获取当前用户的商家申请（必须在/:id之前）
router.get('/current', authenticateUser, getCurrentUserMerchant);

// [GET] 获取商家统计数据（管理员专用） - 必须在/:id之前
router.get('/stats', requireAdmin, getMerchantStats);

// [GET] 获取指定商家详情
router.get('/:id', getMerchantById);

// [PUT] 更新商家信息
router.put('/:id', authenticateUser, updateMerchant);

// [DELETE] 删除商家
router.delete('/:id', authenticateUser, deleteMerchant);

// [PUT] 审核商家资质
router.put('/:id/verify', requireAdmin, verifyMerchant);

module.exports = router;