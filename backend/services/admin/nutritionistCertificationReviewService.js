/**
 * 营养师认证审核服务模块
 * 提供管理员审核营养师认证申请的业务逻辑
 * 支持审核流程管理、状态流转、通知发送等功能
 * @module services/admin/nutritionistCertificationReviewService
 */

const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const mongoose = require('mongoose');
const logger = require('../../config/modules/logger');
const { nutritionistTypes } = require('../../constants');
const { triggerHook } = require('../../hooks');

const nutritionistCertificationReviewService = {
  /**
   * 获取待审核申请列表
   * @param {Object} options - 查询选项
   * @returns {Object} 申请列表
   */
  async getPendingApplications(options = {}) {
    try {
      const { 
        page = 1, 
        limit = 20, 
        status = 'pending',
        targetLevel,
        sortBy = 'submittedAt',
        sortOrder = 'asc' // 最早提交的优先审核
      } = options;

      logger.info('获取待审核营养师认证申请列表', { options });

      // 构建查询条件
      const query = {};
      
      if (status === 'all') {
        query['review.status'] = { $in: ['pending', 'under_review', 'approved', 'rejected'] };
      } else if (Array.isArray(status)) {
        query['review.status'] = { $in: status };
      } else {
        query['review.status'] = status;
      }

      if (targetLevel) {
        query['certificationInfo.targetLevel'] = targetLevel;
      }

      // 构建排序条件
      const sortOptions = {};
      sortOptions[`review.${sortBy}`] = sortOrder === 'desc' ? -1 : 1;

      const applications = await NutritionistCertification.find(query)
        .populate('userId', 'username phone email')
        .sort(sortOptions)
        .limit(limit)
        .skip((page - 1) * limit)
        .lean();

      const total = await NutritionistCertification.countDocuments(query);

      // 统计不同状态的申请数量
      const statusStats = await NutritionistCertification.aggregate([
        {
          $group: {
            _id: '$review.status',
            count: { $sum: 1 }
          }
        }
      ]);

      const stats = statusStats.reduce((acc, stat) => {
        acc[stat._id] = stat.count;
        return acc;
      }, {});

      return {
        success: true,
        data: {
          applications,
          pagination: {
            page,
            limit,
            total,
            pages: Math.ceil(total / limit)
          },
          stats
        }
      };

    } catch (error) {
      logger.error('获取待审核申请列表失败', { error: error.message, options });
      return {
        success: false,
        error: '获取申请列表失败'
      };
    }
  },

  /**
   * 获取申请详情（管理员视角）
   * @param {String} applicationId - 申请ID
   * @returns {Object} 申请详情
   */
  async getApplicationDetail(applicationId) {
    try {
      logger.info('获取营养师认证申请详情', { applicationId });

      const application = await NutritionistCertification.findById(applicationId)
        .populate('userId', 'username phone email createdAt')
        .populate('review.reviewedBy', 'username')
        .lean();

      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 获取用户的其他申请历史
      const userApplicationHistory = await NutritionistCertification.find({
        userId: application.userId._id,
        _id: { $ne: application._id }
      })
        .select('review.status review.submittedAt certificationInfo.targetLevel')
        .sort({ 'review.submittedAt': -1 })
        .limit(5)
        .lean();

      // 计算申请时长
      const applicationDuration = application.review.submittedAt 
        ? Math.floor((Date.now() - new Date(application.review.submittedAt).getTime()) / (1000 * 60 * 60 * 24))
        : null;

      return {
        success: true,
        data: {
          application,
          userApplicationHistory,
          applicationDuration,
          eligibilityCheck: this.checkApplicationEligibility(application)
        }
      };

    } catch (error) {
      logger.error('获取申请详情失败', { error: error.message, applicationId });
      return {
        success: false,
        error: '获取申请详情失败'
      };
    }
  },

  /**
   * 审核申请
   * @param {String} applicationId - 申请ID
   * @param {Object} reviewData - 审核数据
   * @param {Object} reviewer - 审核人员
   * @returns {Object} 审核结果
   */
  async reviewApplication(applicationId, reviewData, reviewer) {
    try {
      const { status, reviewNotes, rejectionReason } = reviewData;

      logger.info('开始审核营养师认证申请', { 
        applicationId, 
        status, 
        reviewerId: reviewer.id 
      });

      // 验证审核状态
      const validStatuses = ['under_review', 'approved', 'rejected'];
      if (!validStatuses.includes(status)) {
        return {
          success: false,
          error: '无效的审核状态'
        };
      }

      const application = await NutritionistCertification.findById(applicationId);
      if (!application) {
        return {
          success: false,
          error: '申请不存在'
        };
      }

      // 检查申请状态是否允许审核
      if (!['pending', 'under_review'].includes(application.review.status)) {
        return {
          success: false,
          error: '申请当前状态不允许审核'
        };
      }

      // 如果是拒绝，必须提供拒绝原因
      if (status === 'rejected' && !rejectionReason) {
        return {
          success: false,
          error: '拒绝申请必须提供拒绝原因'
        };
      }

      // 如果是通过，检查申请资格
      if (status === 'approved') {
        const eligibilityCheck = this.checkApplicationEligibility(application);
        if (!eligibilityCheck.eligible) {
          return {
            success: false,
            error: `申请不满足条件: ${eligibilityCheck.reasons.join(', ')}`
          };
        }
      }

      // 更新审核信息
      const updateData = {
        'review.status': status,
        'review.reviewedBy': reviewer.id,
        'review.reviewedAt': new Date(),
        'review.reviewNotes': reviewNotes || ''
      };

      if (status === 'rejected') {
        updateData['review.rejectionReason'] = rejectionReason;
      } else if (status === 'approved') {
        // 设置认证有效期（5年）
        const validUntil = new Date();
        validUntil.setFullYear(validUntil.getFullYear() + 5);
        updateData['review.approvalValidUntil'] = validUntil;
        
        // 更新认证通过时间
        updateData['review.approvedAt'] = new Date();
      }

      const updatedApplication = await NutritionistCertification.findByIdAndUpdate(
        applicationId,
        updateData,
        { new: true, runValidators: true }
      ).populate('userId', 'username phone email');

      // 如果审核通过，更新或创建营养师主模型记录
      if (status === 'approved') {
        try {
          const nutritionistData = {
            userId: application.userId,
            personalInfo: {
              realName: application.personalInfo.name,
              idCardNumber: application.personalInfo.idNumber
            },
            qualifications: {
              licenseNumber: application.certificationInfo.certificateNumber,
              professionalTitle: this._mapCertificationLevel(application.certificationInfo.targetLevel),
              certificationLevel: this._mapCertificationLevelToEnglish(application.certificationInfo.targetLevel),
              certificationImages: application.documents
                .filter(doc => doc.documentType !== 'idCard')
                .map(doc => doc.url)
            },
            specialties: application.specialization,
            experienceYears: application.workExperience.totalYears,
            isActive: true,
            verificationStatus: 'verified',
            certificationApplicationId: application._id
          };

          // 查找是否已存在营养师记录
          const existingNutritionist = await Nutritionist.findOne({ userId: application.userId });
          
          if (existingNutritionist) {
            // 更新现有记录
            await Nutritionist.findByIdAndUpdate(
              existingNutritionist._id,
              nutritionistData,
              { new: true, runValidators: true }
            );
            logger.info('更新营养师主模型记录', { userId: application.userId });
          } else {
            // 创建新记录
            await Nutritionist.create(nutritionistData);
            logger.info('创建营养师主模型记录', { userId: application.userId });
          }
        } catch (nutritionistError) {
          logger.error('更新营养师主模型失败', { 
            error: nutritionistError.message, 
            applicationId 
          });
          // 不影响主流程，继续执行
        }
      }

      // 记录审核日志
      logger.info('营养师认证申请审核完成', {
        applicationId,
        applicationNumber: updatedApplication.applicationNumber,
        status,
        reviewerId: reviewer.id,
        reviewerName: reviewer.username
      });

      // 触发审核完成Hook - 发送通知
      try {
        const reviewResult = {
          decision: status,
          reviewNotes: reviewNotes || '',
          reviewerId: reviewer.id,
          reviewerName: reviewer.username,
          reviewedAt: new Date()
        };

        if (status === 'rejected') {
          reviewResult.rejectionReason = rejectionReason;
        }

        await triggerHook('nutritionist.certification.reviewed', updatedApplication, reviewResult);
      } catch (hookError) {
        logger.error('审核完成Hook执行失败', { hookError, applicationId });
      }

      return {
        success: true,
        data: updatedApplication,
        message: `申请${status === 'approved' ? '审核通过' : status === 'rejected' ? '审核拒绝' : '状态更新'}成功`
      };

    } catch (error) {
      logger.error('审核营养师认证申请失败', { 
        error: error.message, 
        applicationId, 
        reviewerId: reviewer.id 
      });
      
      return {
        success: false,
        error: '审核申请失败，请稍后重试'
      };
    }
  },

  /**
   * 批量操作申请
   * @param {Array} applicationIds - 申请ID列表
   * @param {String} action - 操作类型
   * @param {Object} reviewer - 审核人员
   * @returns {Object} 操作结果
   */
  async batchOperateApplications(applicationIds, action, reviewer) {
    try {
      logger.info('开始批量操作营养师认证申请', { 
        applicationIds, 
        action, 
        reviewerId: reviewer.id 
      });

      const validActions = ['mark_under_review', 'bulk_reject'];
      if (!validActions.includes(action)) {
        return {
          success: false,
          error: '无效的操作类型'
        };
      }

      const applications = await NutritionistCertification.find({
        _id: { $in: applicationIds },
        'review.status': 'pending'
      });

      if (applications.length === 0) {
        return {
          success: false,
          error: '没有找到可操作的申请'
        };
      }

      let updateData = {};
      let successMessage = '';

      switch (action) {
        case 'mark_under_review':
          updateData = {
            'review.status': 'under_review',
            'review.reviewedBy': reviewer.id,
            'review.reviewedAt': new Date()
          };
          successMessage = '批量标记为审核中成功';
          break;

        case 'bulk_reject':
          updateData = {
            'review.status': 'rejected',
            'review.reviewedBy': reviewer.id,
            'review.reviewedAt': new Date(),
            'review.rejectionReason': '批量审核拒绝'
          };
          successMessage = '批量拒绝成功';
          break;
      }

      const result = await NutritionistCertification.updateMany(
        { _id: { $in: applicationIds } },
        updateData
      );

      logger.info('批量操作完成', {
        action,
        affectedCount: result.modifiedCount,
        reviewerId: reviewer.id
      });

      return {
        success: true,
        data: {
          affectedCount: result.modifiedCount,
          totalRequested: applicationIds.length
        },
        message: successMessage
      };

    } catch (error) {
      logger.error('批量操作申请失败', { 
        error: error.message, 
        applicationIds, 
        action, 
        reviewerId: reviewer.id 
      });
      
      return {
        success: false,
        error: '批量操作失败，请稍后重试'
      };
    }
  },

  /**
   * 获取审核统计数据
   * @param {Object} options - 统计选项
   * @returns {Object} 统计数据
   */
  async getReviewStatistics(options = {}) {
    try {
      const { 
        startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 默认30天前
        endDate = new Date() 
      } = options;

      logger.info('获取营养师认证审核统计数据', { startDate, endDate });

      // 总体统计
      const totalStats = await NutritionistCertification.aggregate([
        {
          $group: {
            _id: '$review.status',
            count: { $sum: 1 },
            avgProcessTime: {
              $avg: {
                $cond: {
                  if: { $ne: ['$review.reviewedAt', null] },
                  then: {
                    $divide: [
                      { $subtract: ['$review.reviewedAt', '$review.submittedAt'] },
                      1000 * 60 * 60 * 24 // 转换为天数
                    ]
                  },
                  else: null
                }
              }
            }
          }
        }
      ]);

      // 按认证等级统计
      const levelStats = await NutritionistCertification.aggregate([
        {
          $group: {
            _id: {
              level: '$certificationInfo.targetLevel',
              status: '$review.status'
            },
            count: { $sum: 1 }
          }
        },
        {
          $group: {
            _id: '$_id.level',
            statuses: {
              $push: {
                status: '$_id.status',
                count: '$count'
              }
            },
            total: { $sum: '$count' }
          }
        }
      ]);

      // 时间趋势统计
      const trendStats = await NutritionistCertification.aggregate([
        {
          $match: {
            'review.submittedAt': {
              $gte: startDate,
              $lte: endDate
            }
          }
        },
        {
          $group: {
            _id: {
              year: { $year: '$review.submittedAt' },
              month: { $month: '$review.submittedAt' },
              day: { $dayOfMonth: '$review.submittedAt' }
            },
            submitted: { $sum: 1 },
            approved: {
              $sum: {
                $cond: [{ $eq: ['$review.status', 'approved'] }, 1, 0]
              }
            },
            rejected: {
              $sum: {
                $cond: [{ $eq: ['$review.status', 'rejected'] }, 1, 0]
              }
            }
          }
        },
        {
          $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 }
        }
      ]);

      // 审核员工作量统计
      const reviewerStats = await NutritionistCertification.aggregate([
        {
          $match: {
            'review.reviewedBy': { $ne: null },
            'review.reviewedAt': {
              $gte: startDate,
              $lte: endDate
            }
          }
        },
        {
          $group: {
            _id: '$review.reviewedBy',
            reviewCount: { $sum: 1 },
            approvedCount: {
              $sum: {
                $cond: [{ $eq: ['$review.status', 'approved'] }, 1, 0]
              }
            },
            rejectedCount: {
              $sum: {
                $cond: [{ $eq: ['$review.status', 'rejected'] }, 1, 0]
              }
            },
            avgProcessTime: {
              $avg: {
                $divide: [
                  { $subtract: ['$review.reviewedAt', '$review.submittedAt'] },
                  1000 * 60 * 60 * 24
                ]
              }
            }
          }
        }
      ]);

      return {
        success: true,
        data: {
          totalStats,
          levelStats,
          trendStats,
          reviewerStats,
          period: { startDate, endDate }
        }
      };

    } catch (error) {
      logger.error('获取审核统计数据失败', { error: error.message, options });
      return {
        success: false,
        error: '获取统计数据失败'
      };
    }
  },

  /**
   * 检查申请资格
   * @param {Object} application - 申请数据
   * @returns {Object} 资格检查结果
   */
  checkApplicationEligibility(application) {
    const reasons = [];
    
    try {
      const { education, workExperience, certificationInfo, documents } = application;
      const targetLevel = certificationInfo.targetLevel;

      // 检查学历要求
      switch (targetLevel) {
        case 'registered_dietitian':
          if (!['bachelor', 'master', 'doctoral'].includes(education.degree)) {
            reasons.push('注册营养师要求本科及以上学历');
          }
          break;
        case 'dietetic_technician':
          if (!['associate', 'bachelor', 'master', 'doctoral'].includes(education.degree)) {
            reasons.push('注册营养技师要求专科及以上学历');
          }
          break;
        case 'public_nutritionist_l4':
          if (workExperience.totalYears < 1 && !['technical_secondary', 'associate', 'bachelor'].includes(education.degree)) {
            reasons.push('公共营养师四级要求1年以上工作经验或中专以上学历');
          }
          break;
        case 'public_nutritionist_l3':
          if (workExperience.totalYears < 2 && !['bachelor', 'master', 'doctoral'].includes(education.degree)) {
            reasons.push('公共营养师三级要求2年以上工作经验或本科以上学历');
          }
          break;
      }

      // 检查专业背景
      const relatedMajors = ['nutrition', 'food_science', 'clinical_medicine', 'preventive_medicine', 'nursing', 'pharmacy', 'biochemistry'];
      if (!relatedMajors.includes(education.major) && education.major !== 'other_related') {
        reasons.push('专业背景与营养学相关性不足');
      }

      // 检查必需文档
      const requiredDocTypes = Object.keys(nutritionistTypes.CERTIFICATE_TYPES)
        .filter(key => nutritionistTypes.CERTIFICATE_TYPES[key].required)
        .map(key => nutritionistTypes.CERTIFICATE_TYPES[key].value);
      
      const uploadedDocTypes = documents.map(doc => doc.documentType);
      const missingDocs = requiredDocTypes.filter(type => !uploadedDocTypes.includes(type));
      
      if (missingDocs.length > 0) {
        reasons.push(`缺少必需文档: ${missingDocs.join(', ')}`);
      }

      // 检查工作经验描述
      if (workExperience.workDescription.length < 50) {
        reasons.push('工作经验描述过于简单');
      }

      // 检查申请动机
      if (certificationInfo.motivationStatement.length < 100) {
        reasons.push('申请动机描述不够详细');
      }

      return {
        eligible: reasons.length === 0,
        reasons
      };

    } catch (error) {
      logger.error('检查申请资格失败', { error: error.message, applicationId: application._id });
      return {
        eligible: false,
        reasons: ['资格检查时出现错误']
      };
    }
  },

  /**
   * 映射认证级别到中文职称
   * @private
   */
  _mapCertificationLevel(level) {
    const levelMap = {
      'registered_dietitian': '注册营养师',
      'dietetic_technician': '注册营养技师', 
      'public_nutritionist_l4': '公共营养师四级',
      'public_nutritionist_l3': '公共营养师三级',
      'public_nutritionist_l2': '公共营养师二级',
      'public_nutritionist_l1': '公共营养师一级',
      'clinical_nutritionist': '临床营养师',
      'sports_nutritionist': '运动营养师',
      'child_nutritionist': '儿童营养师',
      'senior_nutritionist': '高级营养师'
    };
    return levelMap[level] || '营养师';
  },

  /**
   * 映射认证级别到英文等级
   * @private
   */
  _mapCertificationLevelToEnglish(level) {
    const levelMap = {
      'registered_dietitian': 'expert',
      'dietetic_technician': 'senior',
      'public_nutritionist_l4': 'junior',
      'public_nutritionist_l3': 'intermediate',
      'public_nutritionist_l2': 'senior',
      'public_nutritionist_l1': 'expert',
      'clinical_nutritionist': 'expert',
      'sports_nutritionist': 'senior',
      'child_nutritionist': 'senior',
      'senior_nutritionist': 'expert'
    };
    return levelMap[level] || 'intermediate';
  }
};

module.exports = nutritionistCertificationReviewService;