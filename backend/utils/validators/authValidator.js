/**
 * ✅ 模块名：authValidator.js
 * ✅ 功能说明：
 *   - 提供所有认证相关接口的输入验证方案（使用 Joi）
 *   - 包括登录、密码重置、设置新密码、刷新令牌、OAuth 验证等
 * ✅ 应用范围：
 *   - 所有 authController / sessionController 等调用相关中间件前处理数据验证
 */
const Joi = require('joi');

// ✅ 验证登录请求体 { username, password, remember }
const validateLogin = (loginData) => {
  const schema = Joi.object({
    username: Joi.string()
      .min(3)
      .max(50)
      .required()
      .messages({
        'string.empty': '用户名不能为空',
        'string.min': '用户名长度必须至少为3个字符',
        'string.max': '用户名长度不能超过50个字符',
        'any.required': '用户名是必填项'
      }),
    password: Joi.string()
      .min(6)
      .required()
      .messages({
        'string.empty': '密码不能为空',
        'string.min': '密码长度必须至少为6个字符',
        'any.required': '密码是必填项'
      }),
    remember: Joi.boolean()
      .default(false)
  });

  return schema.validate(loginData, { abortEarly: false });
};

// ✅ 验证找回密码请求 { email }
const validatePasswordReset = (resetData) => {
  const schema = Joi.object({
    email: Joi.string()
      .email()
      .required()
      .messages({
        'string.empty': '邮箱不能为空',
        'string.email': '请提供有效的邮箱地址',
        'any.required': '邮箱是必填项'
      })
  });

  return schema.validate(resetData, { abortEarly: false });
};

// ✅ 验证新密码设置 { token, password, confirmPassword }
const validateNewPassword = (passwordData) => {
  const schema = Joi.object({
    token: Joi.string()
      .required()
      .messages({
        'string.empty': '令牌不能为空',
        'any.required': '令牌是必填项'
      }),
    password: Joi.string()
      .min(6)
      .pattern(/^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{6,}$/)
      .required()
      .messages({
        'string.empty': '密码不能为空',
        'string.min': '密码长度必须至少为6个字符',
        'string.pattern.base': '密码必须包含至少一个字母和一个数字',
        'any.required': '密码是必填项'
      }),
    confirmPassword: Joi.string()
      .valid(Joi.ref('password'))
      .required()
      .messages({
        'string.empty': '确认密码不能为空',
        'any.only': '确认密码必须与密码相同',
        'any.required': '确认密码是必填项'
      })
  });

  return schema.validate(passwordData, { abortEarly: false });
};

// ✅ 验证刷新令牌请求 { refreshToken }
const validateRefreshToken = (refreshData) => {
  const schema = Joi.object({
    refreshToken: Joi.string()
      .required()
      .messages({
        'string.empty': '刷新令牌不能为空',
        'any.required': '刷新令牌是必填项'
      })
  });

  return schema.validate(refreshData, { abortEarly: false });
};

// ✅ 验证 OAuth 授权流程中的 code 与 redirectUri
const validateOAuthCode = (oauthData) => {
  const schema = Joi.object({
    code: Joi.string()
      .required()
      .messages({
        'string.empty': '授权码不能为空',
        'any.required': '授权码是必填项'
      }),
    redirectUri: Joi.string()
      .uri()
      .optional()
      .messages({
        'string.uri': '重定向URI格式无效'
      })
  });

  return schema.validate(oauthData, { abortEarly: false });
};

module.exports = {
  validateLogin,
  validatePasswordReset,
  validateNewPassword,
  validateRefreshToken,
  validateOAuthCode
}; 