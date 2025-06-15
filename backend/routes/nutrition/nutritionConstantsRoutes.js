/**
 * 营养档案常量路由
 * 提供营养档案相关枚举常量的API接口
 * @module routes/nutrition/nutritionConstantsRoutes
 */
const express = require('express');
const router = express.Router();
const nutritionConstantsController = require('../../controllers/nutrition/nutritionConstantsController');

// [GET] 获取所有营养档案相关常量
router.get('/', nutritionConstantsController.getAllConstants);

module.exports = router;