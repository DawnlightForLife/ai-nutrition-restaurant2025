/**
 * 营养师认证申请路由
 * 定义营养师认证申请相关的API路由
 */

const express = require('express');
const router = express.Router();
const nutritionistCertificationController = require('../../controllers/nutrition/nutritionistCertificationController');
const { authenticateUser: authMiddleware } = require('../../middleware/auth/authMiddleware');
const { validateBody } = require('../../middleware/validation/requestValidationMiddleware');
const { antiDuplicateSubmission } = require('../../middleware/security/antiDuplicateSubmissionMiddleware');
const { auditLogMiddleware } = require('../../middleware/logging/auditLogMiddleware');
const { legacyCertificationMiddleware, migrationNoticeMiddleware } = require('../../middleware/certification/legacyCertificationMiddleware');
const Joi = require('joi');

// 营养师认证验证规则（对齐数据库设计）
// 个人信息验证规则（超简化版 - 仅实名认证）
const personalInfoSchema = Joi.object({
  fullName: Joi.string().trim().min(2).max(50).required()
    .pattern(/^[\u4e00-\u9fa5a-zA-Z·\s]+$/)
    .messages({
      'string.pattern.base': '姓名只能包含中文、英文字母、间隔号和空格',
      'string.min': '姓名至少2个字符',
      'string.max': '姓名不能超过50个字符',
      'any.required': '请填写真实姓名'
    }),
  idNumber: Joi.string().pattern(/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/)
    .required().messages({
      'string.pattern.base': '请输入有效的身份证号码',
      'any.required': '请填写身份证号码'
    }),
  phone: Joi.string().pattern(/^1[3-9]\d{9}$/).required()
    .messages({
      'string.pattern.base': '请输入有效的手机号码',
      'any.required': '请填写手机号码'
    })
});

// 认证信息验证规则（超简化版）
const certificationInfoSchema = Joi.object({
  specializationAreas: Joi.array().items(Joi.string().valid(
    'clinical_nutrition', 'sports_nutrition', 'child_nutrition', 
    'elderly_nutrition', 'weight_management', 'chronic_disease_nutrition',
    'food_safety', 'community_nutrition', 'nutrition_education', 'food_service_management'
  )).min(1).max(2).required().messages({
    'array.min': '请选择至少1个专业领域',
    'array.max': '最多选择2个专业领域',
    'any.required': '请选择专业领域'
  }),
  workYearsInNutrition: Joi.number().integer().min(0).max(50).required().messages({
    'number.min': '工作年限不能小于0',
    'number.max': '工作年限不能超过50年',
    'any.required': '请填写营养相关工作年限'
  })
});

const createCertificationSchema = Joi.object({
  personalInfo: personalInfoSchema.required(),
  certificationInfo: certificationInfoSchema.required(),
  documents: Joi.array().items(Joi.object({
    documentType: Joi.string().valid(
      'id_card', 'education_certificate', 'nutrition_certificate', 'training_certificate', 'other_materials'
    ).required(),
    fileName: Joi.string().required(),
    fileUrl: Joi.string().required(),  // 改为允许本地路径，不强制要求URI格式
    fileSize: Joi.number().integer().min(1).max(10 * 1024 * 1024).optional(),
    mimeType: Joi.string().optional(),
    uploadedAt: Joi.alternatives().try(Joi.date(), Joi.string()).optional()
  })).optional().default([])
});

const updateCertificationSchema = Joi.object({
  personalInfo: personalInfoSchema.optional(),
  certificationInfo: certificationInfoSchema.optional()
}).min(1);

const documentUploadSchema = Joi.object({
  documentType: Joi.string().valid(
    'id_card', 'education_certificate', 'nutrition_certificate',
    'work_certificate', 'training_certificate', 'other_materials'
  ).required(),
  fileName: Joi.string().min(1).max(255).required(),
  fileUrl: Joi.string().uri().required(),
  fileSize: Joi.number().integer().min(1).max(10 * 1024 * 1024).required(), // 最大10MB
  mimeType: Joi.string().valid(
    'image/jpeg', 'image/jpg', 'image/png', 'application/pdf'
  ).required()
});

/**
 * @swagger
 * components:
 *   schemas:
 *     PersonalInfo:
 *       type: object
 *       required:
 *         - fullName
 *         - gender
 *         - birthDate
 *         - idNumber
 *         - phone
 *         - email
 *         - address
 *       properties:
 *         fullName:
 *           type: string
 *           description: 真实姓名
 *         gender:
 *           type: string
 *           enum: [male, female]
 *           description: 性别
 *         birthDate:
 *           type: string
 *           format: date
 *           description: 出生日期
 *         idNumber:
 *           type: string
 *           description: 身份证号码
 *         phone:
 *           type: string
 *           description: 手机号码
 *         email:
 *           type: string
 *           format: email
 *           description: 邮箱地址
 *         address:
 *           $ref: '#/components/schemas/Address'
 *     
 *     Address:
 *       type: object
 *       required:
 *         - province
 *         - city
 *         - district
 *         - detailed
 *       properties:
 *         province:
 *           type: string
 *           description: 省份
 *         city:
 *           type: string
 *           description: 城市
 *         district:
 *           type: string
 *           description: 区县
 *         detailed:
 *           type: string
 *           description: 详细地址
 *     
 *     Education:
 *       type: object
 *       required:
 *         - degree
 *         - major
 *         - school
 *         - graduationYear
 *       properties:
 *         degree:
 *           type: string
 *           enum: [doctoral, master, bachelor, associate, technical_secondary]
 *           description: 学历水平
 *         major:
 *           type: string
 *           description: 专业背景
 *         school:
 *           type: string
 *           description: 毕业院校
 *         graduationYear:
 *           type: integer
 *           description: 毕业年份
 *         gpa:
 *           type: number
 *           description: 学习成绩(GPA)
 *     
 *     WorkExperience:
 *       type: object
 *       required:
 *         - totalYears
 *         - currentPosition
 *         - currentEmployer
 *         - workDescription
 *         - previousExperiences
 *       properties:
 *         totalYears:
 *           type: integer
 *           description: 相关工作总年限
 *         currentPosition:
 *           type: string
 *           description: 当前工作职位
 *         currentEmployer:
 *           type: string
 *           description: 当前工作单位
 *         workDescription:
 *           type: string
 *           description: 主要工作内容描述
 *         previousExperiences:
 *           type: array
 *           items:
 *             $ref: '#/components/schemas/PreviousExperience'
 *     
 *     CertificationInfo:
 *       type: object
 *       required:
 *         - targetLevel
 *         - specializationAreas
 *         - motivationStatement
 *       properties:
 *         targetLevel:
 *           type: string
 *           enum: [registered_dietitian, dietetic_technician, public_nutritionist_l4, public_nutritionist_l3, nutrition_manager]
 *           description: 申请的认证等级
 *         specializationAreas:
 *           type: array
 *           items:
 *             type: string
 *           description: 专业特长领域
 *         motivationStatement:
 *           type: string
 *           description: 申请营养师认证的动机和理由
 *         careerGoals:
 *           type: string
 *           description: 职业发展规划
 *     
 *     NutritionistCertificationRequest:
 *       type: object
 *       required:
 *         - personalInfo
 *         - education
 *         - workExperience
 *         - certificationInfo
 *       properties:
 *         personalInfo:
 *           $ref: '#/components/schemas/PersonalInfo'
 *         education:
 *           $ref: '#/components/schemas/Education'
 *         workExperience:
 *           $ref: '#/components/schemas/WorkExperience'
 *         certificationInfo:
 *           $ref: '#/components/schemas/CertificationInfo'
 */

/**
 * @swagger
 * /api/nutritionist-certification/constants:
 *   get:
 *     summary: 获取认证常量信息
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: 常量信息获取成功
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                 data:
 *                   type: object
 *                   description: 认证相关常量
 */
router.get('/constants', authMiddleware, nutritionistCertificationController.getConstants);

/**
 * @swagger
 * /api/nutritionist-certification/applications:
 *   get:
 *     summary: 获取用户的申请列表
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: page
 *         schema:
 *           type: integer
 *           default: 1
 *         description: 页码
 *       - in: query
 *         name: limit
 *         schema:
 *           type: integer
 *           default: 10
 *         description: 每页数量
 *       - in: query
 *         name: status
 *         schema:
 *           type: string
 *         description: 申请状态筛选
 *     responses:
 *       200:
 *         description: 申请列表获取成功
 *   post:
 *     summary: 创建营养师认证申请
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/NutritionistCertificationRequest'
 *     responses:
 *       201:
 *         description: 申请创建成功
 *       400:
 *         description: 请求参数错误
 */
router.get('/applications', authMiddleware, nutritionistCertificationController.getUserApplications);
router.post('/applications', 
  authMiddleware,
  legacyCertificationMiddleware, // 添加旧版认证检查
  migrationNoticeMiddleware, // 添加迁移通知
  auditLogMiddleware(),
  antiDuplicateSubmission({ windowMs: 5000 }), // 减少窗口时间，提高响应性
  validateBody(createCertificationSchema),
  nutritionistCertificationController.createApplication
);

/**
 * @swagger
 * /api/nutritionist-certification/applications/{id}:
 *   get:
 *     summary: 获取申请详情
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     responses:
 *       200:
 *         description: 申请详情获取成功
 *       404:
 *         description: 申请不存在
 *   put:
 *     summary: 更新营养师认证申请
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/NutritionistCertificationRequest'
 *     responses:
 *       200:
 *         description: 申请更新成功
 *       400:
 *         description: 请求参数错误
 */
router.get('/applications/:id', authMiddleware, nutritionistCertificationController.getApplicationDetail);
router.put('/applications/:id',
  authMiddleware,
  auditLogMiddleware(),
  antiDuplicateSubmission({ windowMs: 3000 }),
  validateBody(updateCertificationSchema),
  nutritionistCertificationController.updateApplication
);

/**
 * @swagger
 * /api/nutritionist-certification/applications/{id}/submit:
 *   post:
 *     summary: 提交营养师认证申请
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     responses:
 *       200:
 *         description: 申请提交成功
 *       400:
 *         description: 申请状态不允许提交或缺少必需文档
 */
router.post('/applications/:id/submit', 
  authMiddleware,
  auditLogMiddleware(),
  antiDuplicateSubmission({ windowMs: 30000 }),
  nutritionistCertificationController.submitApplication
);

/**
 * @swagger
 * /api/nutritionist-certification/applications/{id}/resubmit:
 *   post:
 *     summary: 重新提交被拒绝的营养师认证申请
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/NutritionistCertificationRequest'
 *     responses:
 *       200:
 *         description: 申请重新提交成功
 *       400:
 *         description: 申请状态不允许重新提交或请求参数错误
 */
router.post('/applications/:id/resubmit', 
  authMiddleware,
  auditLogMiddleware(),
  antiDuplicateSubmission({ windowMs: 10000 }),
  validateBody(createCertificationSchema),
  nutritionistCertificationController.resubmitApplication
);

/**
 * @swagger
 * /api/nutritionist-certification/applications/{id}/documents:
 *   post:
 *     summary: 上传认证文档
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - documentType
 *               - fileName
 *               - fileUrl
 *               - fileSize
 *               - mimeType
 *             properties:
 *               documentType:
 *                 type: string
 *                 description: 文档类型
 *               fileName:
 *                 type: string
 *                 description: 文件名
 *               fileUrl:
 *                 type: string
 *                 description: 文件URL
 *               fileSize:
 *                 type: integer
 *                 description: 文件大小(字节)
 *               mimeType:
 *                 type: string
 *                 description: MIME类型
 *     responses:
 *       200:
 *         description: 文档上传成功
 *       400:
 *         description: 请求参数错误
 */
router.post('/applications/:id/documents', 
  authMiddleware,
  antiDuplicateSubmission({ windowMs: 5000 }),
  validateBody(documentUploadSchema),
  nutritionistCertificationController.uploadDocument
);

/**
 * @swagger
 * /api/nutritionist-certification/applications/{id}/documents/{documentType}:
 *   delete:
 *     summary: 删除认证文档
 *     tags: [营养师认证]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: 申请ID
 *       - in: path
 *         name: documentType
 *         required: true
 *         schema:
 *           type: string
 *         description: 文档类型
 *     responses:
 *       200:
 *         description: 文档删除成功
 *       400:
 *         description: 请求参数错误
 */
router.delete('/applications/:id/documents/:documentType', 
  authMiddleware, 
  nutritionistCertificationController.deleteDocument
);

module.exports = router;