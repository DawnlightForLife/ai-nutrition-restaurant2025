/**
 * 营养师认证申请控制器
 * 处理营养师认证申请相关的HTTP请求
 * 提供RESTful API接口供前端调用
 */

const nutritionistCertificationService = require('../../services/nutrition/nutritionistCertificationService');
const logger = require('../../config/modules/logger');
const responseHelper = require('../../utils/responseHelper');

const nutritionistCertificationController = {
  /**
   * 创建营养师认证申请
   * POST /api/nutritionist-certification/applications
   */
  async createApplication(req, res) {
    const startTime = Date.now();
    try {
      logger.info('创建营养师认证申请请求', { 
        userId: req.user.id,
        requestId: req.id || `req-${Date.now()}`,
        bodySize: JSON.stringify(req.body).length
      });

      const result = await nutritionistCertificationService.createApplication(
        req.body,
        req.user
      );
      
      const duration = Date.now() - startTime;
      logger.info('申请创建处理完成', { 
        userId: req.user.id,
        duration: `${duration}ms`,
        success: result.success
      });

      if (result.success) {
        return responseHelper.success(res, result.data, result.message, 201);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      const duration = Date.now() - startTime;
      logger.error('创建营养师认证申请失败', { 
        error: error.message,
        stack: error.stack,
        userId: req.user.id,
        duration: `${duration}ms`
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 更新营养师认证申请
   * PUT /api/nutritionist-certification/applications/:id
   */
  async updateApplication(req, res) {
    try {
      const { id } = req.params;
      logger.info('更新营养师认证申请请求', { 
        applicationId: id,
        userId: req.user.id,
        body: req.body 
      });

      const result = await nutritionistCertificationService.updateApplication(
        id,
        req.body,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, result.data, result.message);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('更新营养师认证申请失败', { 
        error: error.message, 
        applicationId: req.params.id,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 提交营养师认证申请
   * POST /api/nutritionist-certification/applications/:id/submit
   */
  async submitApplication(req, res) {
    try {
      const { id } = req.params;
      logger.info('提交营养师认证申请请求', { 
        applicationId: id,
        userId: req.user.id 
      });

      const result = await nutritionistCertificationService.submitApplication(
        id,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, result.data, result.message);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('提交营养师认证申请失败', { 
        error: error.message, 
        applicationId: req.params.id,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 获取用户的申请列表
   * GET /api/nutritionist-certification/applications
   */
  async getUserApplications(req, res) {
    try {
      logger.info('获取用户申请列表请求', { 
        userId: req.user.id,
        query: req.query 
      });

      const options = {
        page: parseInt(req.query.page) || 1,
        limit: parseInt(req.query.limit) || 10,
        status: req.query.status
      };

      const result = await nutritionistCertificationService.getUserApplications(
        req.user,
        options
      );

      if (result.success) {
        return responseHelper.success(res, result.data);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('获取用户申请列表失败', { 
        error: error.message, 
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 获取申请详情
   * GET /api/nutritionist-certification/applications/:id
   */
  async getApplicationDetail(req, res) {
    try {
      const { id } = req.params;
      logger.info('获取申请详情请求', { 
        applicationId: id,
        userId: req.user.id 
      });

      const result = await nutritionistCertificationService.getApplicationDetail(
        id,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, result.data);
      } else {
        return responseHelper.error(res, result.error, result.error === '申请不存在' ? 404 : 400);
      }

    } catch (error) {
      logger.error('获取申请详情失败', { 
        error: error.message, 
        applicationId: req.params.id,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 上传文档
   * POST /api/nutritionist-certification/applications/:id/documents
   */
  async uploadDocument(req, res) {
    try {
      const { id } = req.params;
      logger.info('上传认证文档请求', { 
        applicationId: id,
        userId: req.user.id,
        documentType: req.body.documentType 
      });

      // 验证必需字段
      const { documentType, fileName, fileUrl, fileSize, mimeType } = req.body;
      if (!documentType || !fileName || !fileUrl || !fileSize || !mimeType) {
        return responseHelper.error(res, '缺少必需的文档信息', 400);
      }

      const documentData = {
        documentType,
        fileName,
        fileUrl,
        fileSize,
        mimeType
      };

      const result = await nutritionistCertificationService.uploadDocument(
        id,
        documentData,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, result.data, result.message);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('上传认证文档失败', { 
        error: error.message, 
        applicationId: req.params.id,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 删除文档
   * DELETE /api/nutritionist-certification/applications/:id/documents/:documentType
   */
  async deleteDocument(req, res) {
    try {
      const { id, documentType } = req.params;
      logger.info('删除认证文档请求', { 
        applicationId: id,
        documentType,
        userId: req.user.id 
      });

      const result = await nutritionistCertificationService.deleteDocument(
        id,
        documentType,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, null, result.message);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('删除认证文档失败', { 
        error: error.message, 
        applicationId: req.params.id,
        documentType: req.params.documentType,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 重新提交被拒绝的申请
   * POST /api/nutritionist-certification/applications/:id/resubmit
   */
  async resubmitApplication(req, res) {
    try {
      const { id } = req.params;
      logger.info('重新提交营养师认证申请请求', { 
        applicationId: id,
        userId: req.user.id,
        body: req.body 
      });

      const result = await nutritionistCertificationService.resubmitApplication(
        id,
        req.body,
        req.user
      );

      if (result.success) {
        return responseHelper.success(res, result.data, result.message);
      } else {
        return responseHelper.error(res, result.error, 400);
      }

    } catch (error) {
      logger.error('重新提交营养师认证申请失败', { 
        error: error.message, 
        applicationId: req.params.id,
        userId: req.user.id 
      });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  },

  /**
   * 获取认证常量信息
   * GET /api/nutritionist-certification/constants
   */
  async getConstants(_req, res) {
    try {
      const { nutritionistTypes } = require('../../constants');
      
      const constants = {
        certificationLevels: nutritionistTypes.CERTIFICATION_LEVELS,
        certificationStatus: nutritionistTypes.CERTIFICATION_STATUS,
        specializationAreas: nutritionistTypes.SPECIALIZATION_AREAS,
        educationRequirements: nutritionistTypes.EDUCATION_REQUIREMENTS,
        professionalBackgrounds: nutritionistTypes.PROFESSIONAL_BACKGROUNDS,
        workExperienceRequirements: nutritionistTypes.WORK_EXPERIENCE_REQUIREMENTS,
        certificateTypes: nutritionistTypes.CERTIFICATE_TYPES,
        documentRequirements: nutritionistTypes.DOCUMENT_REQUIREMENTS
      };

      return responseHelper.success(res, constants);

    } catch (error) {
      logger.error('获取认证常量失败', { error: error.message });
      return responseHelper.error(res, '服务器内部错误', 500);
    }
  }
};

module.exports = nutritionistCertificationController;