const express = require('express');
const router = express.Router();
const { createAiRecommendation, getAiRecommendationList, getAiRecommendationById, updateAiRecommendation, deleteAiRecommendation } = require('../../controllers/nutrition/aiRecommendationController');

/**
 * AI 推荐管理路由
 * 提供创建、查询、更新、删除 AI 推荐的接口
 * @module routes/nutrition/aiRecommendationRoutes
 */

// [POST] 创建 AI 推荐
router.post('/', createAiRecommendation);

// [GET] 获取 AI 推荐列表
router.get('/', getAiRecommendationList);

// [GET] 获取指定 AI 推荐详情
router.get('/:id', getAiRecommendationById);

// [PUT] 更新 AI 推荐
router.put('/:id', updateAiRecommendation);

// [DELETE] 删除 AI 推荐
router.delete('/:id', deleteAiRecommendation);

module.exports = router;
