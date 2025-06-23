const express = require('express');
const router = express.Router();
const {
  getMarketConsultations,
  getMarketStats,
  acceptConsultation,
  getNutritionistConsultations,
  publishConsultationToMarket,
  createMarketConsultation,
  getConsultationDetail,
  searchMarketConsultations
} = require('../../controllers/consult/consultationMarketController');

const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const { validateBody } = require('../../middleware/validation/requestValidationMiddleware');
const Joi = require('joi');

/**
 * 咨询市场路由
 * 提供营养师查看和接受咨询市场的接口
 * @module routes/consult/consultationMarketRoutes
 */

// 定义验证模式
const createMarketConsultationSchema = Joi.object({
  topic: Joi.string().min(1).max(200).required(),
  description: Joi.string().max(1000).optional(),
  consultationType: Joi.string().valid('text', 'voice', 'video', 'offline').required(),
  priority: Joi.string().valid('normal', 'urgent').default('normal'),
  tags: Joi.array().items(Joi.string()).optional(),
  budget: Joi.object({
    min: Joi.number().min(0).optional(),
    max: Joi.number().min(0).optional()
  }).optional()
});

// 所有路由都需要用户认证
router.use(authenticateUser);

// [GET] 获取咨询市场列表
router.get('/market', getMarketConsultations);

// [GET] 搜索咨询市场
router.get('/market/search', searchMarketConsultations);

// [GET] 获取咨询市场统计数据
router.get('/market/stats', getMarketStats);

// [POST] 营养师接受咨询
router.post('/market/:consultationId/accept', acceptConsultation);

// [GET] 获取营养师接受的咨询列表
router.get('/nutritionist/consultations', getNutritionistConsultations);

// [POST] 发布咨询到市场（用户操作）
router.post('/:consultationId/publish-to-market', publishConsultationToMarket);

// [POST] 创建咨询请求并发布到市场
router.post('/market', validateBody({
  topic: { type: 'string', required: true, minLength: 1, maxLength: 200 },
  description: { type: 'string', required: false, maxLength: 1000 },
  consultationType: { 
    type: 'string', 
    required: true, 
    enum: ['text', 'voice', 'video', 'inPerson'] 
  },
  priority: { 
    type: 'string', 
    required: false, 
    enum: ['low', 'normal', 'high', 'urgent'],
    default: 'normal'
  },
  tags: { type: 'array', required: false, items: { type: 'string' } },
  expectedDuration: { type: 'number', required: false, min: 15, max: 240 },
  budget: { type: 'number', required: false, min: 0 }
}), createMarketConsultation);

// [GET] 获取咨询详情
router.get('/:consultationId', getConsultationDetail);

module.exports = router;