/**
 * 营养档案路由
 * 处理营养档案相关的API路由
 * @module routes/health/nutritionProfileRoutes
 */
const express = require('express');
const router = express.Router();
const nutritionProfileController = require('../../controllers/health/nutritionProfileController');
const authMiddleware = require('../../middleware/auth/authMiddleware');

// 所有路由都需要用户验证
router.use(authMiddleware.authenticateUser);

// 创建营养档案
router.post('/', nutritionProfileController.createProfile);

// 获取用户的所有营养档案
router.get('/', nutritionProfileController.getUserProfiles);

// 获取用户的主营养档案
router.get('/primary', nutritionProfileController.getPrimaryProfile);

// 获取指定营养档案详情
router.get('/:profileId', nutritionProfileController.getProfileById);

// 更新营养档案
router.put('/:profileId', nutritionProfileController.updateProfile);

// 删除营养档案
router.delete('/:profileId', nutritionProfileController.deleteProfile);

// 归档营养档案
router.patch('/:profileId/archive', nutritionProfileController.archiveProfile);

// 恢复已归档的营养档案
router.patch('/:profileId/restore', nutritionProfileController.restoreProfile);

module.exports = router; 