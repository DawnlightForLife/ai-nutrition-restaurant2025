const express = require('express');
const router = express.Router();
const { createNutritionist, getNutritionistList, getNutritionistById, updateNutritionist, deleteNutritionist } = require('../../controllers/nutrition/nutritionistController');

/**
 * 营养师管理路由
 * 提供营养师的创建、获取、更新、删除接口
 * @module routes/nutrition/nutritionistRoutes
 */

// [POST] 创建营养师
router.post('/', createNutritionist);

// [GET] 获取营养师列表
router.get('/', getNutritionistList);

// [GET] 获取指定营养师详情
router.get('/:id', getNutritionistById);

// [PUT] 更新营养师信息
router.put('/:id', updateNutritionist);

// [DELETE] 删除营养师
router.delete('/:id', deleteNutritionist);

module.exports = router;
