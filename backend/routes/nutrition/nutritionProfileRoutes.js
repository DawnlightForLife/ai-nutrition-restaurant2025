/**
 * 营养档案管理路由
 * 提供创建、获取、更新、删除营养档案的接口
 * @module routes/nutrition/nutritionProfileRoutes
 */
const express = require('express');
const router = express.Router();
const nutritionProfileController = require('../../controllers/nutrition/nutritionProfileController');
const { generateRecommendationByProfileId } = require('../../controllers/nutrition/aiRecommendationController');
const { authenticate } = require('../../middleware/auth/authMiddleware');
const { 
  validateProfileCreation, 
  validateProfileUpdate,
  validateHealthGoalDetailsUpdate 
} = require('../../middleware/validators/nutritionProfileValidator');

// [GET] 获取所有营养档案（仅管理员）
router.get('/', authenticate, nutritionProfileController.getAllProfiles);

// [GET] 获取单个营养档案
router.get('/:id', authenticate, nutritionProfileController.getProfileById);

// [GET] 获取指定用户的所有营养档案
router.get('/user/:userId', authenticate, nutritionProfileController.getProfilesByUserId);

// [POST] 创建新的营养档案
router.post('/', authenticate, validateProfileCreation, nutritionProfileController.createProfile);

// [PUT] 更新指定营养档案
router.put('/:id', authenticate, validateProfileUpdate, nutritionProfileController.updateProfile);

// [DELETE] 删除指定营养档案
router.delete('/:id', authenticate, nutritionProfileController.deleteProfile);

// [PUT] 设置指定营养档案为主档案
router.put('/:id/primary', authenticate, nutritionProfileController.setPrimaryProfile);

// [GET] 获取档案完成度统计
router.get('/stats/completion', authenticate, nutritionProfileController.getCompletionStats);

// [GET] 为AI推荐准备数据
router.get('/ai/data', authenticate, nutritionProfileController.getProfileForAI);

// [POST] 验证营养档案数据
router.post('/validate', authenticate, nutritionProfileController.validateProfile);

// [PUT] 更新健康目标详细配置
router.put('/:id/health-goals', authenticate, validateHealthGoalDetailsUpdate, nutritionProfileController.updateHealthGoalDetails);

// [GET] 获取营养档案完成度详情
router.get('/:id/completeness', authenticate, nutritionProfileController.getProfileCompleteness);

// [POST] 根据营养档案ID生成AI推荐
router.post('/:profileId/recommendations', authenticate, generateRecommendationByProfileId);

module.exports = router;