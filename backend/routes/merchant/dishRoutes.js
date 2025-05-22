/**
 * 商家菜品管理路由
 * 包含创建、获取、更新、删除菜品的接口
 * @module routes/merchant/dishRoutes
 */

const express = require('express');
const router = express.Router();
const { createDish, getDishList, getDishById, updateDish, deleteDish } = require('../../controllers/merchant/dishController');

// [POST] 创建菜品
router.post('/', createDish);

// [GET] 获取菜品列表
router.get('/', getDishList);

// [GET] 获取指定菜品详情
router.get('/:id', getDishById);

// [PUT] 更新指定菜品
router.put('/:id', updateDish);

// [DELETE] 删除指定菜品
router.delete('/:id', deleteDish);

module.exports = router;