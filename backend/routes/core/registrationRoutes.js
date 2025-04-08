const express = require('express');
const router = express.Router();
const { validateRegistrationData, registerUser, completeRegistration } = require('../../controllers/core/registrationController');
const { validateRegistration } = require('../../middleware/validators/registrationValidator');
const { authenticateToken } = require('../../middleware/auth/authMiddleware');

/**
 * @route POST /api/registration/validate
 * @desc 验证注册数据
 * @access Public
 */
router.post('/validate', validateRegistration, validateRegistrationData);

/**
 * @route POST /api/registration/register
 * @desc 创建新用户
 * @access Public
 */
router.post('/register', validateRegistration, registerUser);

/**
 * @route POST /api/registration/complete/:userId
 * @desc 完成注册流程
 * @access Private
 */
router.post('/complete/:userId', authenticateToken, completeRegistration);

module.exports = router; 