/**
 * 营养元素路由
 * 定义营养元素相关的API路由
 * @module routes/nutrition/nutritionElementRoutes
 */

const express = require('express');
const router = express.Router();

const {
  getNutritionElements,
  getNutritionElementById,
  createNutritionElement,
  updateNutritionElement,
  deleteNutritionElement,
  getNutritionElementsByCategory,
  getNutritionElementsByFunction,
  getRecommendedIntake,
  getNutritionConstants,
  batchImportNutritionElements
} = require('../../controllers/nutrition/nutritionElementController');

const { authenticateUser } = require('../../middleware/auth/authMiddleware');
const roleMiddleware = require('../../middleware/auth/roleMiddleware');
const { validate, Joi } = require('../../middleware/validation/validationMiddleware');

// 营养元素验证Schema
const nutritionElementValidation = {
  create: Joi.object({
    name: Joi.string().min(2).max(100).required(),
    chineseName: Joi.string().min(1).max(50).required(),
    scientificName: Joi.string().max(100).optional(),
    aliases: Joi.array().items(Joi.string()).optional(),
    category: Joi.string().valid('macronutrients', 'vitamins', 'minerals', 'amino_acids', 'fatty_acids', 'antioxidants', 'phytonutrients', 'probiotics', 'fiber', 'water').required(),
    subCategory: Joi.string().max(50).optional(),
    unit: Joi.string().valid('g', 'mg', 'mcg', 'IU', 'mEq', 'ml', 'l', 'kcal', 'kJ', '%').required(),
    importance: Joi.string().valid('essential', 'important', 'beneficial', 'optional').default('beneficial'),
    functions: Joi.array().items(Joi.string()).optional(),
    healthBenefits: Joi.array().items(Joi.string()).optional(),
    deficiencySymptoms: Joi.array().items(Joi.string()).optional(),
    overdoseRisks: Joi.array().items(Joi.string()).optional()
  }),
  update: Joi.object({
    name: Joi.string().min(2).max(100).optional(),
    chineseName: Joi.string().min(1).max(50).optional(),
    scientificName: Joi.string().max(100).optional(),
    aliases: Joi.array().items(Joi.string()).optional(),
    category: Joi.string().valid('macronutrients', 'vitamins', 'minerals', 'amino_acids', 'fatty_acids', 'antioxidants', 'phytonutrients', 'probiotics', 'fiber', 'water').optional(),
    subCategory: Joi.string().max(50).optional(),
    unit: Joi.string().valid('g', 'mg', 'mcg', 'IU', 'mEq', 'ml', 'l', 'kcal', 'kJ', '%').optional(),
    importance: Joi.string().valid('essential', 'important', 'beneficial', 'optional').optional(),
    functions: Joi.array().items(Joi.string()).optional(),
    healthBenefits: Joi.array().items(Joi.string()).optional(),
    deficiencySymptoms: Joi.array().items(Joi.string()).optional(),
    overdoseRisks: Joi.array().items(Joi.string()).optional()
  })
};

// 公开路由 - 无需认证
router.get('/constants', getNutritionConstants);
router.get('/', getNutritionElements);
router.get('/category/:category', getNutritionElementsByCategory);
router.get('/function/:functionCategory', getNutritionElementsByFunction);
router.get('/:id', getNutritionElementById);
router.get('/:id/recommended-intake', getRecommendedIntake);

// 需要认证的路由
router.use(authenticateUser);

// 管理员路由 - 需要管理员权限
router.post('/', 
  roleMiddleware(['admin', 'nutritionist']),
  validate(nutritionElementValidation.create),
  createNutritionElement
);

router.put('/:id', 
  roleMiddleware(['admin', 'nutritionist']),
  validate(nutritionElementValidation.update),
  updateNutritionElement
);

router.delete('/:id', 
  roleMiddleware(['admin']),
  deleteNutritionElement
);

router.post('/batch-import', 
  roleMiddleware(['admin']),
  batchImportNutritionElements
);

module.exports = router;