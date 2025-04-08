const express = require('express');
const router = express.Router();
const { createNutritionist, getNutritionistList, getNutritionistById, updateNutritionist, deleteNutritionist } = require('../../controllers/nutrition/nutritionistController');

/**
 * 营养师相关路由
 */

// 创建营养师
router.post('/', createNutritionist);

// 获取营养师列表
router.get('/', getNutritionistList);

// 获取单个营养师详情
router.get('/:id', getNutritionistById);

// 更新营养师
router.put('/:id', updateNutritionist);

// 删除营养师
router.delete('/:id', deleteNutritionist);

module.exports = router;
