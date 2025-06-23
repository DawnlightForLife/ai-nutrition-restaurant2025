/**
 * 营养计划路由
 * 处理用户营养计划的创建、查询、修改等功能
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/nutrition/nutritionPlanController');
const { authenticateUser } = require('../../middleware/auth/authMiddleware');

// 需要认证的路由
router.use(authenticateUser);

// 营养计划管理
router.get('/', controller.getNutritionPlanList); // 获取营养计划列表
router.post('/', controller.createNutritionPlan); // 创建营养计划
router.get('/:id', controller.getNutritionPlanDetail); // 获取营养计划详情
router.put('/:id', controller.updateNutritionPlan); // 更新营养计划
router.delete('/:id', controller.deleteNutritionPlan); // 删除营养计划

module.exports = router;
