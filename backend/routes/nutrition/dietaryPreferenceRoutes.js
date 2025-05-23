/**
 * 饮食偏好路由
 * 处理用户饮食偏好的设置与获取
 */

const express = require('express');
const router = express.Router();
const controller = require('../../controllers/nutrition/dietaryPreferenceController');

/** TODO: 添加具体的路由逻辑 */
router.get('/', controller.getDietaryPreferenceList); // 获取用户饮食偏好
router.post('/', controller.createDietaryPreference); // 更新用户饮食偏好

module.exports = router;
