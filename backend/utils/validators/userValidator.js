/**
 * ✅ 模块名：userValidator.js
 * ✅ 所属系统：用户中心
 * ✅ 功能说明：
 *   - 提供用户注册、更新、密码修改、OAuth 登录、搜索等字段验证逻辑
 *   - 所有规则基于 Joi 构建，具备详细错误提示
 * ✅ 适用范围：
 *   - 注册/登录接口、用户中心管理、用户搜索过滤等中间件调用前置验证
 */

/**
 * 用户验证器
 * 提供用户数据验证功能
 * @module utils/validators/userValidator
 */

const Joi = require('joi');

// ✅ 验证用户注册请求字段（注册接口）
/**
 * 验证用户注册数据
 * @param {Object} data - 用户注册数据
 * @returns {Object} - 验证结果
 */
const validateUserRegistration = (data) => {
  const schema = Joi.object({
    username: Joi.string().trim().min(3).max(30).required()
      .messages({
        'string.min': '用户名至少需要3个字符',
        'string.max': '用户名不能超过30个字符',
        'any.required': '用户名是必填项'
      }),
    email: Joi.string().trim().email().required()
      .messages({
        'string.email': '请提供有效的电子邮件地址',
        'any.required': '电子邮件是必填项'
      }),
    password: Joi.string().min(8).required()
      .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      .messages({
        'string.min': '密码至少需要8个字符',
        'string.pattern.base': '密码必须包含至少一个大写字母、一个小写字母和一个数字',
        'any.required': '密码是必填项'
      }),
    confirmPassword: Joi.string().valid(Joi.ref('password')).required()
      .messages({
        'any.only': '两次输入的密码不匹配',
        'any.required': '确认密码是必填项'
      }),
    phone: Joi.string().pattern(/^1[3-9]\d{9}$/).required()
      .messages({
        'string.pattern.base': '请提供有效的手机号码',
        'any.required': '手机号码是必填项'
      }),
    firstName: Joi.string().trim().allow('', null),
    lastName: Joi.string().trim().allow('', null),
    avatar: Joi.string().uri().allow('', null)
      .messages({
        'string.uri': '头像必须是有效的URL'
      }),
    bio: Joi.string().max(500).allow('', null)
      .messages({
        'string.max': '个人简介不能超过500个字符'
      }),
    role: Joi.string().valid('user', 'admin').default('user')
  });

  return schema.validate(data, { abortEarly: false });
};

// ✅ 验证用户信息更新字段（资料编辑接口）
/**
 * 验证用户更新数据
 * @param {Object} data - 用户更新数据
 * @returns {Object} - 验证结果
 */
const validateUserUpdate = (data) => {
  const schema = Joi.object({
    username: Joi.string().trim().min(3).max(30)
      .messages({
        'string.min': '用户名至少需要3个字符',
        'string.max': '用户名不能超过30个字符'
      }),
    email: Joi.string().trim().email()
      .messages({
        'string.email': '请提供有效的电子邮件地址'
      }),
    phone: Joi.string().pattern(/^1[3-9]\d{9}$/)
      .messages({
        'string.pattern.base': '请提供有效的手机号码'
      }),
    firstName: Joi.string().trim().allow('', null),
    lastName: Joi.string().trim().allow('', null),
    avatar: Joi.string().uri().allow('', null)
      .messages({
        'string.uri': '头像必须是有效的URL'
      }),
    bio: Joi.string().max(500).allow('', null)
      .messages({
        'string.max': '个人简介不能超过500个字符'
      }),
    role: Joi.string().valid('user', 'admin')
  });

  return schema.validate(data, { abortEarly: false });
};

// ✅ 验证密码修改字段（修改密码接口）
/**
 * 验证密码修改数据
 * @param {Object} data - 密码修改数据
 * @returns {Object} - 验证结果
 */
const validatePasswordChange = (data) => {
  const schema = Joi.object({
    currentPassword: Joi.string().required()
      .messages({
        'any.required': '当前密码是必填项'
      }),
    newPassword: Joi.string().min(8).required()
      .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/)
      .messages({
        'string.min': '新密码至少需要8个字符',
        'string.pattern.base': '新密码必须包含至少一个大写字母、一个小写字母和一个数字',
        'any.required': '新密码是必填项'
      }),
    confirmPassword: Joi.string().valid(Joi.ref('newPassword')).required()
      .messages({
        'any.only': '两次输入的密码不匹配',
        'any.required': '确认密码是必填项'
      })
  });

  return schema.validate(data, { abortEarly: false });
};

// ✅ 验证 OAuth 第三方登录字段（OAuth 登录接口）
/**
 * 验证OAuth登录数据
 * @param {Object} data - OAuth登录数据
 * @returns {Object} - 验证结果
 */
const validateOAuthLogin = (data) => {
  const schema = Joi.object({
    provider: Joi.string().valid('google', 'github', 'facebook', 'wechat', 'apple').required()
      .messages({
        'any.only': '不支持的OAuth提供商',
        'any.required': 'OAuth提供商是必填项'
      }),
    code: Joi.string().required()
      .messages({
        'any.required': '授权码是必填项'
      }),
    redirectUri: Joi.string().uri().optional()
      .messages({
        'string.uri': '重定向URI必须是有效的URL'
      }),
    state: Joi.string().optional()
  });

  return schema.validate(data, { abortEarly: false });
};

// ✅ 验证用户搜索查询字段（用户列表/后台管理）
/**
 * 验证用户搜索参数
 * @param {Object} data - 搜索参数
 * @returns {Object} - 验证结果
 */
const validateUserSearch = (data) => {
  const schema = Joi.object({
    keyword: Joi.string().allow('', null),
    page: Joi.number().integer().min(1).default(1)
      .messages({
        'number.base': '页码必须是数字',
        'number.integer': '页码必须是整数',
        'number.min': '页码必须大于等于1'
      }),
    limit: Joi.number().integer().min(1).max(100).default(10)
      .messages({
        'number.base': '每页数量必须是数字',
        'number.integer': '每页数量必须是整数',
        'number.min': '每页数量必须大于等于1',
        'number.max': '每页数量不能超过100'
      }),
    sortBy: Joi.string().valid('username', 'email', 'createdAt', 'updatedAt').default('createdAt'),
    order: Joi.string().valid('asc', 'desc').default('desc'),
    role: Joi.string().valid('user', 'admin', 'all').default('all'),
    status: Joi.string().valid('active', 'inactive', 'all').default('all')
  });

  return schema.validate(data, { abortEarly: false });
};

module.exports = {
  validateUserRegistration,
  validateUserUpdate,
  validatePasswordChange,
  validateOAuthLogin,
  validateUserSearch
};