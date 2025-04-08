const express = require('express');
const router = express.Router();
const { createFavorite, getFavoriteList, getFavoriteById, updateFavorite, deleteFavorite } = require('../../controllers/nutrition/favoriteController');

/**
 * 收藏相关路由
 */

// 创建收藏
router.post('/', createFavorite);

// 获取收藏列表
router.get('/', getFavoriteList);

// 获取单个收藏详情
router.get('/:id', getFavoriteById);

// 更新收藏
router.put('/:id', updateFavorite);

// 删除收藏
router.delete('/:id', deleteFavorite);

module.exports = router;
