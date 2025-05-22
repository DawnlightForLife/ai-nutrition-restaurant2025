/**
 * 营养计划路由
 * 处理用户营养计划的创建、查询、修改等功能
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/nutrition/nutritionPlanController');

/** TODO: 添加具体的路由逻辑 */
router.get('/', controller.getNutritionPlanList); // 获取营养计划列表
router.post('/', controller.createNutritionPlan); // 创建营养计划

module.exports = router;
