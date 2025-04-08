const express = require('express');
const router = express.Router();
const { createAiRecommendation, getAiRecommendationList, getAiRecommendationById, updateAiRecommendation, deleteAiRecommendation } = require('../../controllers/nutrition/aiRecommendationController');

/**
 * AI推荐相关路由
 */

// 创建AI推荐
router.post('/', createAiRecommendation);

// 获取AI推荐列表
router.get('/', getAiRecommendationList);

// 获取单个AI推荐详情
router.get('/:id', getAiRecommendationById);

// 更新AI推荐
router.put('/:id', updateAiRecommendation);

// 删除AI推荐
router.delete('/:id', deleteAiRecommendation);

module.exports = router;
