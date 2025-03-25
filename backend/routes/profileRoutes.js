const express = require('express');
const router = express.Router();
const { createProfile, getUserProfiles, getProfileById, updateProfile, deleteProfile } = require('../controllers/nutritionProfileController');
const authMiddleware = require('../middleware/authMiddleware');

// 获取用户的所有档案 - 按要求实现的接口
router.get('/', getUserProfiles);

// 以下是需要验证的接口
router.use(authMiddleware);

// 创建新档案
router.post('/', createProfile);

// 获取单个档案详情
router.get('/:profileId', getProfileById);

// 更新档案
router.put('/:profileId', updateProfile);

// 删除档案
router.delete('/:profileId', deleteProfile);

module.exports = router; 