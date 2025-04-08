const { body, validationResult } = require('express-validator');
const { errorResponse } = require('../../utils/responseUtils');

/**
 * 注册数据验证规则
 */
const validateRegistration = [
  // 用户名验证
  body('username')
    .trim()
    .isLength({ min: 3, max: 20 })
    .withMessage('用户名长度必须在3-20个字符之间')
    .matches(/^[a-zA-Z0-9_-]+$/)
    .withMessage('用户名只能包含字母、数字、下划线和连字符'),

  // 密码验证
  body('password')
    .isLength({ min: 8 })
    .withMessage('密码长度至少为8个字符')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/)
    .withMessage('密码必须包含大小写字母、数字和特殊字符'),

  // 邮箱验证
  body('email')
    .trim()
    .isEmail()
    .withMessage('请输入有效的邮箱地址')
    .normalizeEmail(),

  // 手机号验证
  body('phone')
    .optional()
    .trim()
    .matches(/^1[3-9]\d{9}$/)
    .withMessage('请输入有效的手机号码'),

  // 验证结果处理
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return errorResponse(res, 400, '验证失败', errors.array());
    }
    next();
  }
];

module.exports = {
  validateRegistration
}; 