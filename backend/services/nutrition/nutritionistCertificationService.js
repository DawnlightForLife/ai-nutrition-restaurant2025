/**
 * 营养师认证申请服务模块
 * 提供营养师认证申请的业务逻辑处理，包括申请、审核、文档上传等功能
 * 支持分步骤申请、文档验证、审核流程管理
 * @module services/nutrition/nutritionistCertificationService
 */

const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
// const mongoose = require('mongoose'); // 暂未使用，注释掉避免警告
const logger = require('../../config/modules/logger');
const { nutritionistTypes } = require('../../constants');
const { triggerHook } = require('../../hooks');
const ResourceLock = require('../../utils/resourceLock');
const FileValidator = require('../../utils/fileValidator');

const nutritionistCertificationService = {
  /**
   * 创建营养师认证申请
   * @param {Object} data - 申请数据
   * @param {Object} user - 当前用户
   * @returns {Object} 申请结果
   */
  async createApplication(data, user) {
    try {
      logger.info('开始创建营养师认证申请', { 
        userId: user.id, 
        targetLevel: data.certificationInfo?.targetLevel
      });

      // 检查用户是否已有未完成的申请
      const existingApplication = await NutritionistCertification.findOne({
        userId: user.id,
        'review.status': { $in: ['draft', 'pending', 'under_review'] }
      }).lean();

      if (existingApplication) {
        return {
          success: false,
          error: '您已有未完成的认证申请，请先完成或取消当前申请'
        };
      }

      // 基本数据验证
      if (!data.personalInfo || !data.personalInfo.fullName || !data.personalInfo.idNumber) {
        return {
          success: false,
          error: '个人信息不完整'
        };
      }
      
      if (!data.certificationInfo || !data.certificationInfo.specializationAreas) {
        return {
          success: false,
          error: '认证信息不完整'
        };
      }

      // 创建申请记录
      const applicationData = {
        userId: user.id,
        personalInfo: data.personalInfo,
        certificationInfo: data.certificationInfo,
        documents: data.documents || [],
        review: {
          status: 'draft',
          resubmissionCount: 0
        }
      };

      const application = new NutritionistCertification(applicationData);
      await application.save();

      logger.info('营养师认证申请创建成功', { 
        applicationId: application._id,
        applicationNumber: application.applicationNumber,
        userId: user.id
      });

      return {
        success: true,
        data: application,
        message: '申请创建成功'
      };

    } catch (error) {
      logger.error('创建营养师认证申请失败', { 
        error: error.message, 
        userId: user.id,
        data 
      });
      
      return {
        success: false,
        error: '创建申请失败，请稍后重试'
      };
    }
  },

  /**
   * 更新申请信息
   * @param {String} applicationId - 申请ID
   * @param {Object} data - 更新数据
   * @param {Object} user - 当前用户
   * @returns {Object} 更新结果
   */
  async updateApplication(applicationId, data, user) {
    // 使用资源锁防止并发修改
    const lockResource = `application:${applicationId}`;
    
    return await ResourceLock.withLock(lockResource, async () => {
      try {
        logger.info('开始更新营养师认证申请', { 
          applicationId, 
          userId: user.id 
        });

        const application = await NutritionistCertification.findById(applicationId);
        if (!application) {
          return {
            success: false,
            error: '申请不存在'
          };
        }

        // 权限检查
        if (application.userId.toString() !== user.id) {
          return {
            success: false,
            error: '无权限操作此申请'
          };
        }

        // 状态检查 - 只有草稿和被拒绝的申请可以修改
        if (!['draft', 'rejected'].includes(application.review.status)) {
          return {
            success: false,
            error: '当前状态下无法修改申请'
          };
        }

        // 验证更新数据
        const validationResult = this.validateApplicationData(data);
        if (!validationResult.isValid) {
          return {
            success: false,
            error: validationResult.errors.join(', ')
          };
        }

        // 更新申请数据
        const updateData = {
          personalInfo: data.personalInfo || application.personalInfo,
          certificationInfo: data.certificationInfo || application.certificationInfo,
          documents: data.documents || application.documents
        };

        // 如果是重新提交被拒绝的申请
        if (application.review.status === 'rejected') {
          updateData['review.status'] = 'draft';
          updateData['review.rejectionReason'] = '';
          updateData['review.reviewNotes'] = '';
          updateData['review.resubmissionCount'] = application.review.resubmissionCount + 1;
          updateData['review.lastResubmissionDate'] = new Date();
          
          logger.info('重新提交被拒绝的申请', { 
            applicationId, 
            resubmissionCount: updateData['review.resubmissionCount']
          });
        }

        const updatedApplication = await NutritionistCertification.findByIdAndUpdate(
          applicationId,
          updateData,
          { new: true, runValidators: true }
        );

        logger.info('营养师认证申请更新成功', { 
          applicationId,
          userId: user.id
        });

        return {
          success: true,
          data: updatedApplication,
          message: '申请更新成功'
        };

      } catch (error) {
        logger.error('更新营养师认证申请失败', { 
          error: error.message, 
          applicationId, 
          userId: user.id 
        });
        
        return {
          success: false,
          error: '更新申请失败，请稍后重试'
        };
      }
    }, { ttl: 30, maxRetries: 5 });
  },

  /**
   * 提交申请
   * @param {String} applicationId - 申请ID
   * @param {Object} user - 当前用户
   * @returns {Object} 提交结果
   */
  async submitApplication(applicationId, user) {
    try {
      logger.info('开始提交营养师认证申请', { 
        applicationId, 
        userId: user.id 
      });

      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 权限检查
      if (application.userId.toString() !== user.id) {
        return {
          success: false,
          error: '无权限操作此申请'
        };
      }

      // 状态检查 - 只有草稿状态可以提交
      if (application.review.status !== 'draft') {
        return {
          success: false,
          error: '当前状态下无法提交申请'
        };
      }

      // 检查必需文档是否已上传
      const requiredDocTypes = Object.keys(nutritionistTypes.CERTIFICATE_TYPES)
        .filter(key => nutritionistTypes.CERTIFICATE_TYPES[key].required)
        .map(key => nutritionistTypes.CERTIFICATE_TYPES[key].value);
      
      const uploadedDocTypes = application.documents.map(doc => doc.documentType);
      const missingDocs = requiredDocTypes.filter(type => !uploadedDocTypes.includes(type));
      
      if (missingDocs.length > 0) {
        return {
          success: false,
          error: `请先上传必需文档: ${missingDocs.map(type => 
            nutritionistTypes.CERTIFICATE_TYPES[type.toUpperCase()]?.label || type
          ).join(', ')}`
        };
      }

      // 检查申请资格
      if (!application.checkEligibility()) {
        return {
          success: false,
          error: '不满足申请条件，请检查学历和工作经验要求'
        };
      }

      // 更新申请状态为待审核
      application.review.status = 'pending';
      application.review.submittedAt = new Date();
      await application.save();

      // 触发提交Hook - 发送通知等
      try {
        await triggerHook('nutritionist.certification.submitted', application);
      } catch (hookError) {
        logger.error('提交申请Hook执行失败', { hookError, applicationId });
      }

      logger.info('营养师认证申请提交成功', { 
        applicationId,
        applicationNumber: application.applicationNumber,
        userId: user.id
      });

      return {
        success: true,
        data: application,
        message: '申请提交成功，我们将在1-3个工作日内完成审核'
      };

    } catch (error) {
      logger.error('提交营养师认证申请失败', { 
        error: error.message, 
        applicationId, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '提交申请失败，请稍后重试'
      };
    }
  },

  /**
   * 获取用户的申请列表
   * @param {Object} user - 当前用户
   * @param {Object} options - 查询选项
   * @returns {Object} 申请列表
   */
  async getUserApplications(user, options = {}) {
    try {
      const { page = 1, limit = 10, status } = options;
      const query = { userId: user.id };
      
      if (status) {
        query['review.status'] = status;
      }

      const applications = await NutritionistCertification.find(query)
        .sort({ createdAt: -1 })
        .limit(limit)
        .skip((page - 1) * limit);

      const total = await NutritionistCertification.countDocuments(query);

      return {
        success: true,
        data: {
          applications,
          pagination: {
            page,
            limit,
            total,
            pages: Math.ceil(total / limit)
          }
        }
      };

    } catch (error) {
      logger.error('获取用户申请列表失败', { 
        error: error.message, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '获取申请列表失败'
      };
    }
  },

  /**
   * 获取申请详情
   * @param {String} applicationId - 申请ID
   * @param {Object} user - 当前用户
   * @returns {Object} 申请详情
   */
  async getApplicationDetail(applicationId, user) {
    try {
      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 权限检查 - 用户只能查看自己的申请，管理员可以查看所有申请
      if (application.userId.toString() !== user.id && user.role !== 'admin') {
        return {
          success: false,
          error: '无权限查看此申请'
        };
      }

      return {
        success: true,
        data: application
      };

    } catch (error) {
      logger.error('获取申请详情失败', { 
        error: error.message, 
        applicationId, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '获取申请详情失败'
      };
    }
  },

  /**
   * 上传文档
   * @param {String} applicationId - 申请ID
   * @param {Object} documentData - 文档数据
   * @param {Object} user - 当前用户
   * @returns {Object} 上传结果
   */
  async uploadDocument(applicationId, documentData, user) {
    try {
      logger.info('开始上传认证文档', { 
        applicationId, 
        documentType: documentData.documentType,
        userId: user.id 
      });

      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 权限检查
      if (application.userId.toString() !== user.id) {
        return {
          success: false,
          error: '无权限操作此申请'
        };
      }

      // 状态检查 - 只有草稿和被拒绝的申请可以上传文档
      if (!['draft', 'rejected'].includes(application.review.status)) {
        return {
          success: false,
          error: '当前状态下无法上传文档'
        };
      }

      // 验证文档类型
      const validDocTypes = Object.keys(nutritionistTypes.CERTIFICATE_TYPES)
        .map(key => nutritionistTypes.CERTIFICATE_TYPES[key].value);
      
      if (!validDocTypes.includes(documentData.documentType)) {
        return {
          success: false,
          error: '无效的文档类型'
        };
      }

      // 使用文件验证器进行安全检查
      const fileValidation = await FileValidator.validateFile({
        fileName: documentData.fileName,
        mimeType: documentData.mimeType,
        fileSize: documentData.fileSize
      });

      if (!fileValidation.isValid) {
        return {
          success: false,
          error: `文件验证失败：${fileValidation.errors.join(', ')}`
        };
      }

      // 记录警告信息（如果有）
      if (fileValidation.warnings && fileValidation.warnings.length > 0) {
        logger.warn('文件上传警告', {
          applicationId,
          documentType: documentData.documentType,
          warnings: fileValidation.warnings
        });
      }

      // 检查是否已存在相同类型的文档
      const existingDocIndex = application.documents.findIndex(
        doc => doc.documentType === documentData.documentType
      );

      const newDocument = {
        documentType: documentData.documentType,
        fileName: documentData.fileName,
        fileUrl: documentData.fileUrl,
        fileSize: documentData.fileSize,
        mimeType: documentData.mimeType,
        uploadedAt: new Date(),
        verified: false
      };

      if (existingDocIndex >= 0) {
        // 替换现有文档
        application.documents[existingDocIndex] = newDocument;
      } else {
        // 添加新文档
        application.documents.push(newDocument);
      }

      await application.save();

      logger.info('认证文档上传成功', { 
        applicationId,
        documentType: documentData.documentType,
        fileName: documentData.fileName,
        userId: user.id
      });

      return {
        success: true,
        data: newDocument,
        message: '文档上传成功'
      };

    } catch (error) {
      logger.error('上传认证文档失败', { 
        error: error.message, 
        applicationId, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '上传文档失败，请稍后重试'
      };
    }
  },

  /**
   * 删除文档
   * @param {String} applicationId - 申请ID
   * @param {String} documentType - 文档类型
   * @param {Object} user - 当前用户
   * @returns {Object} 删除结果
   */
  async deleteDocument(applicationId, documentType, user) {
    try {
      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 权限检查
      if (application.userId.toString() !== user.id) {
        return {
          success: false,
          error: '无权限操作此申请'
        };
      }

      // 状态检查
      if (!['draft', 'rejected'].includes(application.review.status)) {
        return {
          success: false,
          error: '当前状态下无法删除文档'
        };
      }

      // 删除文档
      application.documents = application.documents.filter(
        doc => doc.documentType !== documentType
      );

      await application.save();

      logger.info('认证文档删除成功', { 
        applicationId,
        documentType,
        userId: user.id
      });

      return {
        success: true,
        message: '文档删除成功'
      };

    } catch (error) {
      logger.error('删除认证文档失败', { 
        error: error.message, 
        applicationId, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '删除文档失败，请稍后重试'
      };
    }
  },

  /**
   * 重新提交被拒绝的申请
   * @param {String} applicationId - 申请ID
   * @param {Object} data - 更新的申请数据
   * @param {Object} user - 当前用户
   * @returns {Object} 重新提交结果
   */
  async resubmitApplication(applicationId, data, user) {
    try {
      logger.info('开始重新提交营养师认证申请', { 
        applicationId, 
        userId: user.id 
      });

      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 权限检查
      if (application.userId.toString() !== user.id) {
        return {
          success: false,
          error: '无权限操作此申请'
        };
      }

      // 状态检查 - 只有被拒绝的申请可以重新提交
      if (application.review.status !== 'rejected') {
        return {
          success: false,
          error: '只有被拒绝的申请才能重新提交'
        };
      }

      // 验证申请数据
      const validationResult = this.validateApplicationData(data);
      if (!validationResult.isValid) {
        return {
          success: false,
          error: validationResult.errors.join(', ')
        };
      }

      // 更新申请数据
      application.personalInfo = data.personalInfo;
      application.certificationInfo = data.certificationInfo;
      if (data.documents) {
        application.documents = data.documents;
      }
      
      // 重置审核状态
      application.review.status = 'draft';
      application.review.rejectionReason = '';
      application.review.reviewNotes = '';
      application.review.reviewedBy = null;
      application.review.reviewedAt = null;
      application.review.resubmissionCount = (application.review.resubmissionCount || 0) + 1;
      application.review.lastResubmissionDate = new Date();

      await application.save();

      logger.info('营养师认证申请重新提交成功', { 
        applicationId,
        resubmissionCount: application.review.resubmissionCount,
        userId: user.id
      });

      return {
        success: true,
        data: application,
        message: '申请重新提交成功，请完善资料后再次提交审核'
      };

    } catch (error) {
      logger.error('重新提交营养师认证申请失败', { 
        error: error.message, 
        applicationId, 
        userId: user.id 
      });
      
      return {
        success: false,
        error: '重新提交申请失败，请稍后重试'
      };
    }
  },

  /**
   * 验证申请数据
   * @param {Object} data - 申请数据
   * @returns {Object} 验证结果
   */
  validateApplicationData(data) {
    const errors = [];

    // 验证个人信息（简化版 - 仅实名认证）
    if (!data.personalInfo) {
      errors.push('缺少个人信息');
    } else {
      const { personalInfo } = data;
      if (!personalInfo.fullName || personalInfo.fullName.trim().length < 2) {
        errors.push('姓名无效');
      }
      if (!personalInfo.idNumber || !/^[1-9]\d{5}(18|19|20)\d{2}((0[1-9])|(1[0-2]))(([0-2][1-9])|10|20|30|31)\d{3}[0-9Xx]$/.test(personalInfo.idNumber)) {
        errors.push('身份证号码无效');
      }
      if (!personalInfo.phone || !/^1[3-9]\d{9}$/.test(personalInfo.phone)) {
        errors.push('手机号码无效');
      }
    }

    // 验证认证信息（简化版）
    if (!data.certificationInfo) {
      errors.push('缺少认证信息');
    } else {
      const { certificationInfo } = data;
      
      // 验证专业领域
      const validAreas = [
        'clinical_nutrition', 'sports_nutrition', 'child_nutrition', 
        'elderly_nutrition', 'weight_management', 'chronic_disease_nutrition',
        'food_safety', 'community_nutrition', 'nutrition_education', 'food_service_management'
      ];
      if (!certificationInfo.specializationAreas || !Array.isArray(certificationInfo.specializationAreas) || 
          certificationInfo.specializationAreas.length === 0 || 
          !certificationInfo.specializationAreas.every(area => validAreas.includes(area))) {
        errors.push('专业领域选择无效');
      }
      
      // 验证工作年限
      if (typeof certificationInfo.workYearsInNutrition !== 'number' || 
          certificationInfo.workYearsInNutrition < 0 || 
          certificationInfo.workYearsInNutrition > 50) {
        errors.push('营养相关工作年限无效');
      }
    }

    return {
      isValid: errors.length === 0,
      errors
    };
  }
};

module.exports = nutritionistCertificationService;