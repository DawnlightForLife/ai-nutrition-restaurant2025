const express = require('express');
const router = express.Router();
const {
  createProfile,
  getUserProfiles,
  getProfileById,
  updateProfile,
  deleteProfile
} = require('../controllers/nutritionProfileController');

// 创建新的营养档案
router.post('/', createProfile);

// 获取用户的所有营养档案
router.get('/', getUserProfiles);

// 获取单个营养档案详情
router.get('/:profileId', getProfileById);

// 更新营养档案
router.put('/:profileId', updateProfile);

// 删除营养档案
router.delete('/:profileId', deleteProfile);

module.exports = router; 