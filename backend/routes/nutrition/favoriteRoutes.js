const express = require('express');
const router = express.Router();
const { createFavorite, getFavoriteList, getFavoriteById, updateFavorite, deleteFavorite } = require('../../controllers/nutrition/favoriteController');

/**
 * 收藏管理路由
 * 提供创建、获取、更新、删除收藏的接口
 * @module routes/nutrition/favoriteRoutes
 */

// [POST] 创建收藏
router.post('/', createFavorite);

// [GET] 获取收藏列表
router.get('/', getFavoriteList);

// [GET] 获取指定收藏详情
router.get('/:id', getFavoriteById);

// [PUT] 更新收藏
router.put('/:id', updateFavorite);

// [DELETE] 删除收藏
router.delete('/:id', deleteFavorite);

module.exports = router;
