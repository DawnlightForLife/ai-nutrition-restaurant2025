/**
 * ✅ 模块名：nutritionProfileValidator.js
 * ✅ 所属系统：营养管理模块
 * ✅ 功能说明：
 *   - 提供营养档案创建、更新、搜索等字段验证逻辑
 *   - 所有规则基于 Joi 构建，具备详细错误提示
 * ✅ 适用范围：
 *   - 营养档案创建/更新接口、档案查询过滤等前置验证
 */

/**
 * 营养档案验证器
 * 提供营养档案数据验证功能
 * @module utils/validators/nutritionProfileValidator
 */

const Joi = require('joi');

/**
 * 验证营养档案创建数据
 * @param {Object} data - 营养档案创建数据
 * @returns {Object} - 验证结果
 */
const validateProfileCreation = (data) => {
  const schema = Joi.object({
    name: Joi.string().trim().min(2).max(50).required()
      .messages({
        'string.min': '档案名称至少需要2个字符',
        'string.max': '档案名称不能超过50个字符',
        'any.required': '档案名称是必填项'
      }),
    gender: Joi.string().valid('male', 'female', 'other').required()
      .messages({
        'any.only': '性别必须是 male、female 或 other',
        'any.required': '性别是必填项'
      }),
    birthDate: Joi.date().iso().max('now').required()
      .messages({
        'date.base': '出生日期必须是有效的日期',
        'date.max': '出生日期不能超过当前日期',
        'any.required': '出生日期是必填项'
      }),
    height: Joi.number().min(50).max(250).required()
      .messages({
        'number.base': '身高必须是数字',
        'number.min': '身高不能小于50厘米',
        'number.max': '身高不能大于250厘米',
        'any.required': '身高是必填项'
      }),
    weight: Joi.number().min(2).max(500).required()
      .messages({
        'number.base': '体重必须是数字',
        'number.min': '体重不能小于2公斤',
        'number.max': '体重不能大于500公斤',
        'any.required': '体重是必填项'
      }),
    activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active').required()
      .messages({
        'any.only': '活动水平必须是有效值',
        'any.required': '活动水平是必填项'
      }),
    goal: Joi.string().valid('weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement').required()
      .messages({
        'any.only': '健康目标必须是有效值',
        'any.required': '健康目标是必填项'
      }),
    dietaryRestrictions: Joi.array().items(
      Joi.string().valid(
        'vegetarian', 'vegan', 'pescatarian', 'keto', 'paleo', 
        'gluten_free', 'dairy_free', 'nut_free', 'halal', 'kosher', 'none'
      )
    ).default(['none'])
      .messages({
        'array.base': '饮食限制必须是数组'
      }),
    healthConditions: Joi.array().items(
      Joi.string().valid(
        'diabetes', 'hypertension', 'heart_disease', 'kidney_disease',
        'celiac', 'lactose_intolerance', 'none'
      )
    ).default(['none'])
      .messages({
        'array.base': '健康状况必须是数组'
      }),
    allergies: Joi.array().items(Joi.string().min(2).max(50)).default([])
      .messages({
        'array.base': '过敏原必须是数组'
      }),
    preferredCuisines: Joi.array().items(Joi.string().min(2).max(50)).default([])
      .messages({
        'array.base': '喜好的菜系必须是数组'
      }),
    mealPlanType: Joi.string().valid('balanced', 'low_carb', 'high_protein', 'vegetarian', 'keto').default('balanced')
      .messages({
        'any.only': '膳食计划类型必须是有效值'
      }),
    dailyMeals: Joi.number().integer().min(2).max(6).default(3)
      .messages({
        'number.base': '每日餐次必须是数字',
        'number.integer': '每日餐次必须是整数',
        'number.min': '每日餐次不能少于2次',
        'number.max': '每日餐次不能多于6次'
      }),
    isPrimary: Joi.boolean().default(false),
    notes: Joi.string().max(500).allow('', null)
      .messages({
        'string.max': '备注不能超过500个字符'
      })
  });

  return schema.validate(data, { abortEarly: false });
};

/**
 * 验证营养档案更新数据
 * @param {Object} data - 营养档案更新数据
 * @returns {Object} - 验证结果
 */
const validateProfileUpdate = (data) => {
  const schema = Joi.object({
    name: Joi.string().trim().min(2).max(50)
      .messages({
        'string.min': '档案名称至少需要2个字符',
        'string.max': '档案名称不能超过50个字符'
      }),
    gender: Joi.string().valid('male', 'female', 'other')
      .messages({
        'any.only': '性别必须是 male、female 或 other'
      }),
    birthDate: Joi.date().iso().max('now')
      .messages({
        'date.base': '出生日期必须是有效的日期',
        'date.max': '出生日期不能超过当前日期'
      }),
    height: Joi.number().min(50).max(250)
      .messages({
        'number.base': '身高必须是数字',
        'number.min': '身高不能小于50厘米',
        'number.max': '身高不能大于250厘米'
      }),
    weight: Joi.number().min(2).max(500)
      .messages({
        'number.base': '体重必须是数字',
        'number.min': '体重不能小于2公斤',
        'number.max': '体重不能大于500公斤'
      }),
    activityLevel: Joi.string().valid('sedentary', 'light', 'moderate', 'active', 'very_active')
      .messages({
        'any.only': '活动水平必须是有效值'
      }),
    goal: Joi.string().valid('weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement')
      .messages({
        'any.only': '健康目标必须是有效值'
      }),
    dietaryRestrictions: Joi.array().items(
      Joi.string().valid(
        'vegetarian', 'vegan', 'pescatarian', 'keto', 'paleo', 
        'gluten_free', 'dairy_free', 'nut_free', 'halal', 'kosher', 'none'
      )
    )
      .messages({
        'array.base': '饮食限制必须是数组'
      }),
    healthConditions: Joi.array().items(
      Joi.string().valid(
        'diabetes', 'hypertension', 'heart_disease', 'kidney_disease',
        'celiac', 'lactose_intolerance', 'none'
      )
    )
      .messages({
        'array.base': '健康状况必须是数组'
      }),
    allergies: Joi.array().items(Joi.string().min(2).max(50))
      .messages({
        'array.base': '过敏原必须是数组'
      }),
    preferredCuisines: Joi.array().items(Joi.string().min(2).max(50))
      .messages({
        'array.base': '喜好的菜系必须是数组'
      }),
    mealPlanType: Joi.string().valid('balanced', 'low_carb', 'high_protein', 'vegetarian', 'keto')
      .messages({
        'any.only': '膳食计划类型必须是有效值'
      }),
    dailyMeals: Joi.number().integer().min(2).max(6)
      .messages({
        'number.base': '每日餐次必须是数字',
        'number.integer': '每日餐次必须是整数',
        'number.min': '每日餐次不能少于2次',
        'number.max': '每日餐次不能多于6次'
      }),
    isPrimary: Joi.boolean(),
    notes: Joi.string().max(500).allow('', null)
      .messages({
        'string.max': '备注不能超过500个字符'
      })
  });

  return schema.validate(data, { abortEarly: false });
};

/**
 * 验证营养档案查询参数
 * @param {Object} params - 查询参数
 * @returns {Object} - 验证结果
 */
const validateProfileQuery = (params) => {
  const schema = Joi.object({
    userId: Joi.string().pattern(/^[0-9a-fA-F]{24}$/).messages({
      'string.pattern.base': '用户ID格式不正确'
    }),
    name: Joi.string().trim(),
    gender: Joi.string().valid('male', 'female', 'other'),
    ageMin: Joi.number().integer().min(0).max(120),
    ageMax: Joi.number().integer().min(0).max(120).greater(Joi.ref('ageMin')),
    isPrimary: Joi.boolean(),
    goal: Joi.string().valid('weight_loss', 'weight_gain', 'maintenance', 'muscle_gain', 'health_improvement'),
    dietaryRestriction: Joi.string(),
    healthCondition: Joi.string(),
    page: Joi.number().integer().min(1).default(1),
    limit: Joi.number().integer().min(1).max(100).default(10),
    sortBy: Joi.string().valid('name', 'createdAt', 'updatedAt').default('createdAt'),
    order: Joi.string().valid('asc', 'desc').default('desc')
  });

  return schema.validate(params, { abortEarly: false });
};

module.exports = {
  validateProfileCreation,
  validateProfileUpdate,
  validateProfileQuery
};
