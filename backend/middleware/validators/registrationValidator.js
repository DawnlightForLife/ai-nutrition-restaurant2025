/**
 * ✅ 模块名：registrationValidator.js
 * ✅ 命名风格统一（camelCase）
 * ✅ 功能概览：
 *   - 使用 express-validator 验证注册请求字段
 *   - 校验字段包括：username、password、email、phone（可选）
 *   - 所有错误通过统一 errorResponse 格式返回
 * ✅ 校验规则：
 *   - 用户名 3~20 字符，允许字母、数字、下划线、连字符
 *   - 密码 至少8位，包含大小写字母、数字、特殊字符
 *   - 邮箱格式正确（并自动标准化）
 *   - 手机号为中国大陆手机号（可选字段）
 * ✅ 推荐 future：
 *   - 支持国际化错误提示
 *   - 用户名支持中文名（可配置开关）
 */

const { body, validationResult } = require('express-validator');
const { errorResponse } = require('../../utils/responseUtils');

/**
 * 注册数据验证规则
 */
const validateRegistration = [
  // 用户名字段校验：必填，格式限制
  body('username')
    .trim()
    .isLength({ min: 3, max: 20 })
    .withMessage('用户名长度必须在3-20个字符之间')
    .matches(/^[a-zA-Z0-9_-]+$/)
    .withMessage('用户名只能包含字母、数字、下划线和连字符'),

  // 密码字段校验：必填，强密码规则
  body('password')
    .isLength({ min: 8 })
    .withMessage('密码长度至少为8个字符')
    .matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]+$/)
    .withMessage('密码必须包含大小写字母、数字和特殊字符'),

  // 邮箱字段校验：必填，格式 + 标准化
  body('email')
    .trim()
    .isEmail()
    .withMessage('请输入有效的邮箱地址')
    .normalizeEmail(),

  // 手机号字段校验：可选，仅当填写时验证格式
  body('phone')
    .optional()
    .trim()
    .matches(/^1[3-9]\d{9}$/)
    .withMessage('请输入有效的手机号码'),

  // 如果存在验证错误，统一返回格式化错误信息
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