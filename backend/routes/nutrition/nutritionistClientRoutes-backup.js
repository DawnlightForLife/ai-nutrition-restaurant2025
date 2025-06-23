const express = require('express');
const router = express.Router();
const {
  getNutritionistClients,
  getClientDetail,
  addClient,
  updateClientInfo,
  addProgressEntry,
  setClientGoal,
  updateGoalProgress,
  addClientReminder,
  completeClientReminder,
  getClientStats,
  searchPotentialClients,
  getClientNutritionPlanHistory
} = require('../../controllers/nutrition/nutritionistClientController');

const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const { validateBody } = require('../../middleware/validation/requestValidationMiddleware');
const Joi = require('joi');

/**
 * 营养师客户管理路由
 * 提供营养师管理客户的完整接口
 * @module routes/nutrition/nutritionistClientRoutes
 */

// Joi 验证模式定义
const addClientSchema = Joi.object({
  clientUserId: Joi.string().required(),
  clientTags: Joi.array().items(Joi.string()).optional(),
  nutritionistNotes: Joi.string().max(1000).optional(),
  healthOverview: Joi.object({
    primaryGoals: Joi.array().items(Joi.string()).optional(),
    currentConditions: Joi.array().items(Joi.string()).optional(),
    dietaryPreferences: Joi.array().items(Joi.string()).optional(),
    allergies: Joi.array().items(Joi.string()).optional()
  }).optional()
});

const updateClientSchema = Joi.object({
  clientTags: Joi.array().items(Joi.string()).optional(),
  nutritionistNotes: Joi.string().max(1000).optional(),
  healthOverview: Joi.object({
    primaryGoals: Joi.array().items(Joi.string()).optional(),
    currentConditions: Joi.array().items(Joi.string()).optional(),
    dietaryPreferences: Joi.array().items(Joi.string()).optional(),
    allergies: Joi.array().items(Joi.string()).optional()
  }).optional(),
  relationshipStatus: Joi.string().valid('active', 'inactive', 'completed', 'paused').optional()
});

const addProgressSchema = Joi.object({
  measurements: Joi.object({
    weight: Joi.number().min(0).optional(),
    bodyFatPercentage: Joi.number().min(0).max(100).optional(),
    muscleMass: Joi.number().min(0).optional()
  }).optional(),
  notes: Joi.string().max(500).optional(),
  mood: Joi.string().valid('excellent', 'good', 'neutral', 'poor', 'terrible').optional(),
  compliance: Joi.number().min(0).max(100).optional()
});

const setGoalSchema = Joi.object({
  type: Joi.string().valid('weight', 'bodyFat', 'muscle', 'nutrition', 'lifestyle').required(),
  target: Joi.string().required(),
  targetValue: Joi.number().optional(),
  unit: Joi.string().optional(),
  deadline: Joi.date().optional()
});

const updateGoalSchema = Joi.object({
  currentValue: Joi.number().optional(),
  notes: Joi.string().max(200).optional()
});

const addReminderSchema = Joi.object({
  type: Joi.string().valid('appointment', 'follow_up', 'goal_check', 'plan_review', 'custom').required(),
  title: Joi.string().required(),
  description: Joi.string().optional(),
  dueDate: Joi.date().required(),
  priority: Joi.string().valid('low', 'medium', 'high', 'urgent').default('medium')
});

// 所有路由都需要用户认证
router.use(authenticateUser);

// [GET] 获取营养师客户统计数据
router.get('/stats', getClientStats);

// [GET] 搜索潜在客户
router.get('/search-potential', searchPotentialClients);

// [GET] 获取营养师的客户列表
router.get('/', getNutritionistClients);

// [POST] 添加客户
router.post('/', validateBody(addClientSchema), addClient);

// [GET] 获取客户详情
router.get('/:clientUserId', getClientDetail);

// [PUT] 更新客户信息
router.put('/:clientUserId', validateBody(updateClientSchema), updateClientInfo);

// [POST] 添加客户进展记录
router.post('/:clientUserId/progress', validateBody(addProgressSchema), addProgressEntry);
  measurements: {
    type: 'object',
    required: false,
    properties: {
      weight: { type: 'number', min: 0 },
      bodyFatPercentage: { type: 'number', min: 0, max: 100 },
      muscleMass: { type: 'number', min: 0 }
    }
  },
  notes: { type: 'string', required: false, maxLength: 500 },
  mood: {
    type: 'string',
    required: false,
    enum: ['excellent', 'good', 'neutral', 'poor', 'terrible']
  },
  compliance: { type: 'number', required: false, min: 0, max: 100 }
}), addProgressEntry);

// [POST] 设置客户目标
router.post('/:clientUserId/goals', validateBody({
  type: {
    type: 'string',
    required: true,
    enum: ['weight', 'bodyFat', 'muscle', 'nutrition', 'lifestyle']
  },
  target: { type: 'string', required: true, maxLength: 200 },
  targetValue: { type: 'number', required: false },
  currentValue: { type: 'number', required: false },
  unit: { type: 'string', required: false, maxLength: 20 },
  deadline: { type: 'string', required: false, format: 'date' }
}), setClientGoal);

// [PUT] 更新目标进度
router.put('/:clientUserId/goals/:goalId', validateBody({
  currentValue: { type: 'number', required: true },
  notes: { type: 'string', required: false, maxLength: 200 }
}), updateGoalProgress);

// [POST] 添加客户提醒
router.post('/:clientUserId/reminders', validateBody({
  type: {
    type: 'string',
    required: true,
    enum: ['appointment', 'follow_up', 'goal_check', 'plan_review', 'custom']
  },
  title: { type: 'string', required: true, maxLength: 100 },
  description: { type: 'string', required: false, maxLength: 300 },
  dueDate: { type: 'string', required: true, format: 'date' },
  priority: {
    type: 'string',
    required: false,
    enum: ['low', 'medium', 'high', 'urgent'],
    default: 'medium'
  }
}), addClientReminder);

// [PUT] 完成客户提醒
router.put('/:clientUserId/reminders/:reminderId/complete', completeClientReminder);

// [GET] 获取客户营养计划历史
router.get('/:clientUserId/nutrition-plans', getClientNutritionPlanHistory);

module.exports = router;