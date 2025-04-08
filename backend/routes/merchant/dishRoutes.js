const express = require('express');
const router = express.Router();
const { createDish, getDishList, getDishById, updateDish, deleteDish } = require('../../controllers/merchant/dishController');

/**
 * 菜品相关路由
 */

// 创建菜品
router.post('/', createDish);

// 获取菜品列表
router.get('/', getDishList);

// 获取单个菜品详情
router.get('/:id', getDishById);

// 更新菜品
router.put('/:id', updateDish);

// 删除菜品
router.delete('/:id', deleteDish);

module.exports = router; 