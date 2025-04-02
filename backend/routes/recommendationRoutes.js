const express = require('express');
const router = express.Router();
const { 
  getRecommendationPreview, 
  generateRecommendation, 
  getRecommendationHistory,
  getAllRecommendations,
  getRecommendationsByProfileId,
  getRecommendationDetail
} = require('../controllers/recommendationController');
const { protect } = require('../middleware/authMiddleware');

// 获取推荐预览 - GET /api/recommendation/preview 或 /recommendation/preview
router.get('/preview', protect, getRecommendationPreview);

// 生成推荐 - POST /api/recommendation/generate 或 /recommendation/generate
router.post('/generate', protect, generateRecommendation);

// 获取推荐历史记录 - GET /api/recommendation/history 或 /recommendation/history
router.get('/history', protect, getRecommendationHistory);

// 获取所有推荐记录列表 - GET /api/recommendation 或 /api/recommendations 
router.get('/', protect, getAllRecommendations);

// 按档案ID查询推荐记录 - GET /api/recommendation?profileId=xxx 或 /api/recommendations?profileId=xxx
router.get('/', protect, getRecommendationsByProfileId);

// 获取单个推荐详情 - GET /api/recommendation/:id 或 /api/recommendations/:id
router.get('/:id', protect, getRecommendationDetail);

module.exports = router; 