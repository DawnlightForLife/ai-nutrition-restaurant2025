const express = require('express');
const router = express.Router();
const { 
  createNutritionist, 
  getNutritionistList, 
  getNutritionistById, 
  updateNutritionist, 
  deleteNutritionist,
  updateOnlineStatus,
  getOnlineNutritionists,
  updateAvailabilitySchedule
} = require('../../controllers/nutrition/nutritionistController');
const { authenticate } = require('../../middleware/auth/authMiddleware');
const requireRole = require('../../middleware/auth/roleMiddleware');

/**
 * 营养师管理路由
 * 提供营养师的创建、获取、更新、删除接口
 * @module routes/nutrition/nutritionistRoutes
 */

// [POST] 创建营养师 - 需要营养师角色认证
router.post('/', authenticate, requireRole(['nutritionist']), createNutritionist);

// [GET] 获取营养师列表 - 公开接口
router.get('/', getNutritionistList);

// [GET] 获取指定营养师详情 - 公开接口
router.get('/:id', getNutritionistById);

// [PUT] 更新营养师信息 - 需要本人或管理员权限
router.put('/:id', authenticate, updateNutritionist);

// [DELETE] 删除营养师 - 需要管理员权限
router.delete('/:id', authenticate, requireRole(['admin']), deleteNutritionist);

// [PUT] 更新营养师在线状态 - 需要本人或管理员权限
router.put('/:id/online-status', authenticate, updateOnlineStatus);

// [POST] 设置营养师可用时间段 - 需要本人或管理员权限
router.post('/:id/availability', authenticate, updateAvailabilitySchedule);

// [GET] 获取在线营养师列表 - 公开接口
router.get('/online', getOnlineNutritionists);

module.exports = router;
