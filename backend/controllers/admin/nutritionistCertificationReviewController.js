const nutritionistCertificationReviewService = require('../../services/admin/nutritionistCertificationReviewService');
const responseHelper = require('../../utils/responseHelper');
const logger = require('../../config/modules/logger');

const nutritionistCertificationReviewController = {
  async getPendingApplications(req, res) {
    try {
      const { page = 1, limit = 20, status, certificationLevel, specialization, sort } = req.query;
      
      const filters = {};
      if (status) filters.status = status;
      if (certificationLevel) filters.certificationLevel = certificationLevel;
      if (specialization) filters.specialization = specialization;

      const result = await nutritionistCertificationReviewService.getPendingApplications({
        page: parseInt(page),
        limit: parseInt(limit),
        filters,
        sort
      });

      return responseHelper.success(res, result, '获取待审核申请列表成功');
    } catch (error) {
      logger.error('获取待审核申请列表失败:', error);
      return responseHelper.error(res, '获取待审核申请列表失败', 500);
    }
  },

  async getApplicationDetail(req, res) {
    try {
      const { applicationId } = req.params;
      
      if (!applicationId) {
        return responseHelper.error(res, '申请ID不能为空', 400);
      }

      const application = await nutritionistCertificationReviewService.getApplicationDetail(applicationId);
      
      if (!application) {
        return responseHelper.error(res, '申请不存在', 404);
      }

      return responseHelper.success(res, application, '获取申请详情成功');
    } catch (error) {
      logger.error('获取申请详情失败:', error);
      return responseHelper.error(res, '获取申请详情失败', 500);
    }
  },

  async reviewApplication(req, res) {
    try {
      const { applicationId } = req.params;
      const { decision, reviewNotes, reviewerId } = req.body;
      
      if (!applicationId || !decision || !reviewerId) {
        return responseHelper.error(res, '申请ID、审核决定和审核员ID不能为空', 400);
      }

      if (!['approved', 'rejected', 'needsRevision'].includes(decision)) {
        return responseHelper.error(res, '无效的审核决定', 400);
      }

      const reviewData = {
        decision,
        reviewNotes,
        reviewerId,
        reviewedAt: new Date()
      };

      const result = await nutritionistCertificationReviewService.reviewApplication(applicationId, reviewData);
      
      return responseHelper.success(res, result, '审核申请成功');
    } catch (error) {
      logger.error('审核申请失败:', error);
      return responseHelper.error(res, error.message || '审核申请失败', 500);
    }
  },

  async batchReview(req, res) {
    try {
      const { applicationIds, decision, reviewNotes, reviewerId } = req.body;
      
      if (!applicationIds || !Array.isArray(applicationIds) || applicationIds.length === 0) {
        return responseHelper.error(res, '申请ID列表不能为空', 400);
      }

      if (!decision || !reviewerId) {
        return responseHelper.error(res, '审核决定和审核员ID不能为空', 400);
      }

      if (!['approved', 'rejected', 'needsRevision'].includes(decision)) {
        return responseHelper.error(res, '无效的审核决定', 400);
      }

      const reviewData = {
        decision,
        reviewNotes,
        reviewerId,
        reviewedAt: new Date()
      };

      const result = await nutritionistCertificationReviewService.batchReview(applicationIds, reviewData);
      
      return responseHelper.success(res, result, '批量审核成功');
    } catch (error) {
      logger.error('批量审核失败:', error);
      return responseHelper.error(res, error.message || '批量审核失败', 500);
    }
  },

  async getReviewStatistics(req, res) {
    try {
      const { dateFrom, dateTo, reviewerId } = req.query;
      
      const filters = {};
      if (dateFrom && dateTo) {
        filters.dateRange = { from: new Date(dateFrom), to: new Date(dateTo) };
      }
      if (reviewerId) {
        filters.reviewerId = reviewerId;
      }

      const statistics = await nutritionistCertificationReviewService.getReviewStatistics(filters);
      
      return responseHelper.success(res, statistics, '获取审核统计成功');
    } catch (error) {
      logger.error('获取审核统计失败:', error);
      return responseHelper.error(res, '获取审核统计失败', 500);
    }
  },

  async getReviewHistory(req, res) {
    try {
      const { applicationId } = req.params;
      
      if (!applicationId) {
        return responseHelper.error(res, '申请ID不能为空', 400);
      }

      const history = await nutritionistCertificationReviewService.getReviewHistory(applicationId);
      
      return responseHelper.success(res, history, '获取审核历史成功');
    } catch (error) {
      logger.error('获取审核历史失败:', error);
      return responseHelper.error(res, '获取审核历史失败', 500);
    }
  },

  async updateApplicationPriority(req, res) {
    try {
      const { applicationId } = req.params;
      const { priority } = req.body;
      
      if (!applicationId || priority === undefined) {
        return responseHelper.error(res, '申请ID和优先级不能为空', 400);
      }

      if (!['low', 'normal', 'high', 'urgent'].includes(priority)) {
        return responseHelper.error(res, '无效的优先级', 400);
      }

      const result = await nutritionistCertificationReviewService.updateApplicationPriority(applicationId, priority);
      
      return responseHelper.success(res, result, '更新申请优先级成功');
    } catch (error) {
      logger.error('更新申请优先级失败:', error);
      return responseHelper.error(res, '更新申请优先级失败', 500);
    }
  },

  async assignReviewer(req, res) {
    try {
      const { applicationId } = req.params;
      const { reviewerId } = req.body;
      
      if (!applicationId || !reviewerId) {
        return responseHelper.error(res, '申请ID和审核员ID不能为空', 400);
      }

      const result = await nutritionistCertificationReviewService.assignReviewer(applicationId, reviewerId);
      
      return responseHelper.success(res, result, '分配审核员成功');
    } catch (error) {
      logger.error('分配审核员失败:', error);
      return responseHelper.error(res, '分配审核员失败', 500);
    }
  }
};

module.exports = nutritionistCertificationReviewController;