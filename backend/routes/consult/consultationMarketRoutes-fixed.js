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
  consultationType: Joi.string().valid('text', 'voice', 'video', 'inPerson').required(),
  priority: Joi.string().valid('low', 'normal', 'high', 'urgent').default('normal'),
  tags: Joi.array().items(Joi.string()).optional(),
  expectedDuration: Joi.number().min(15).max(240).optional(),
  budget: Joi.number().min(0).optional()
});

// 所有路由都需要用户认证
router.use(authenticateUser);

// [GET] 获取咨询市场列表
router.get('/market', getMarketConsultations);

// [GET] 获取咨询市场统计
router.get('/market/stats', getMarketStats);

// [GET] 搜索咨询市场
router.get('/market/search', searchMarketConsultations);

// [POST] 营养师接受咨询
router.post('/:consultationId/accept', acceptConsultation);

// [GET] 获取营养师的已接受咨询
router.get('/nutritionist/accepted', getNutritionistConsultations);

// [POST] 发布咨询到市场（用户操作）
router.post('/:consultationId/publish-to-market', publishConsultationToMarket);

// [POST] 创建咨询请求并发布到市场
router.post('/market', validateBody(createMarketConsultationSchema), createMarketConsultation);

// [GET] 获取咨询详情
router.get('/:consultationId', getConsultationDetail);

module.exports = router;