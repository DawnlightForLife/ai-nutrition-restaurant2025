const express = require('express');
const router = express.Router();
const { createNutritionProfile, getNutritionProfileList, getNutritionProfileById, updateNutritionProfile, deleteNutritionProfile } = require('../../controllers/health/nutritionProfileController');

/**
 * 营养档案相关路由
 */

// 创建营养档案
router.post('/', createNutritionProfile);

// 获取营养档案列表
router.get('/', getNutritionProfileList);

// 获取单个营养档案详情
router.get('/:id', getNutritionProfileById);

// 更新营养档案
router.put('/:id', updateNutritionProfile);

// 删除营养档案
router.delete('/:id', deleteNutritionProfile);

module.exports = router; 