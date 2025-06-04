const ContentReport = require('../../models/security/contentReportModel');
const User = require('../../models/user/userModel');
const logger = require('../../config/modules/logger');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

class ContentReportService {
  /**
   * 创建内容举报
   * @param {Object} reportData - 举报数据
   * @param {string} reporterId - 举报者ID
   * @param {Object} options - 可选参数
   * @returns {Promise<Object>} 举报结果
   */
  async createReport(reportData, reporterId, options = {}) {
    try {
      const {
        reportType,
        contentType,
        contentId,
        reason,
        description,
        severity = 'medium',
        evidence
      } = reportData;

      // 验证举报者
      const reporter = await User.findById(reporterId);
      if (!reporter) {
        throw new NotFoundError('举报者不存在');
      }

      // 检查是否已举报过相同内容
      const existingReport = await ContentReport.findOne({
        'reporter.userId': reporterId,
        'reportedContent.contentType': contentType,
        'reportedContent.contentId': contentId,
        status: { $in: ['pending', 'reviewing'] }
      });

      if (existingReport) {
        return {
          success: false,
          message: '您已举报过此内容，请等待处理结果',
          data: {
            existingReportId: existingReport._id
          }
        };
      }

      // 创建举报记录
      const report = await ContentReport.createReport({
        reportType,
        contentType,
        contentId,
        reporterId,
        reason,
        description,
        severity,
        ipAddress: options.ipAddress,
        deviceInfo: options.deviceInfo
      });

      // 如果提供了证据，更新证据信息
      if (evidence) {
        report.reportDetails.evidence = evidence;
        await report.save();
      }

      // 自动检测处理（如果启用）
      if (options.enableAutoDetection) {
        await this.runAutoDetection(report);
      }

      // 自动分配审核员（如果配置了自动分配）
      if (options.autoAssign) {
        await this.autoAssignModerator(report);
      }

      logger.info('内容举报创建成功', {
        reportId: report._id,
        reportType,
        contentType,
        contentId,
        reporterId,
        severity
      });

      return {
        success: true,
        message: '举报提交成功，我们会尽快处理',
        data: {
          reportId: report._id,
          status: report.status,
          priority: report.priority
        }
      };

    } catch (error) {
      logger.error('创建内容举报失败', { error: error.message, reporterId });
      throw error;
    }
  }

  /**
   * 获取举报列表
   * @param {Object} options - 查询选项
   * @param {string} operatorId - 操作者ID
   * @returns {Promise<Object>} 举报列表
   */
  async getReports(options = {}, operatorId) {
    try {
      // 验证操作者权限
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('admin') && !operator.roles.includes('moderator'))) {
        throw new BusinessError('无权限查看举报列表');
      }

      const {
        page = 1,
        limit = 20,
        status,
        reportType,
        priority,
        assignedTo,
        contentType,
        startDate,
        endDate,
        search
      } = options;

      const skip = (page - 1) * limit;
      const query = { isDeleted: false };

      // 构建查询条件
      if (status) query.status = status;
      if (reportType) query.reportType = reportType;
      if (priority) query.priority = priority;
      if (assignedTo) query['processing.assignedTo'] = assignedTo;
      if (contentType) query['reportedContent.contentType'] = contentType;

      if (startDate || endDate) {
        query.createdAt = {};
        if (startDate) query.createdAt.$gte = new Date(startDate);
        if (endDate) query.createdAt.$lte = new Date(endDate);
      }

      if (search) {
        query.$or = [
          { 'reportDetails.reason': { $regex: search, $options: 'i' } },
          { 'reportDetails.description': { $regex: search, $options: 'i' } },
          { 'reportedContent.contentTitle': { $regex: search, $options: 'i' } }
        ];
      }

      // 如果是审核员，只显示分配给自己的或未分配的
      if (operator.roles.includes('moderator') && !operator.roles.includes('admin')) {
        query.$or = [
          { 'processing.assignedTo': operatorId },
          { 'processing.assignedTo': { $exists: false } },
          { 'processing.assignedTo': null }
        ];
      }

      const [reports, total] = await Promise.all([
        ContentReport.find(query)
          .populate('reporter.userId', 'username email')
          .populate('reportedContent.contentAuthorId', 'username email')
          .populate('processing.assignedTo', 'username')
          .sort({ priority: -1, createdAt: -1 })
          .skip(skip)
          .limit(limit),
        ContentReport.countDocuments(query)
      ]);

      return {
        success: true,
        data: {
          reports: reports.map(report => ({
            id: report._id,
            reportType: report.reportType,
            reportedContent: report.reportedContent,
            reporter: {
              userId: report.reporter.userId?._id,
              username: report.reporter.userId?.username,
              isAnonymous: report.reporter.isAnonymous
            },
            reportDetails: report.reportDetails,
            status: report.status,
            priority: report.priority,
            processing: {
              assignedTo: report.processing.assignedTo,
              assignedAt: report.processing.assignedAt,
              result: report.processing.result
            },
            createdAt: report.createdAt,
            relatedReports: report.relatedReports.length
          })),
          pagination: {
            page,
            limit,
            total,
            pages: Math.ceil(total / limit)
          }
        }
      };

    } catch (error) {
      logger.error('获取举报列表失败', { error: error.message, operatorId });
      throw error;
    }
  }

  /**
   * 获取举报详情
   * @param {string} reportId - 举报ID
   * @param {string} operatorId - 操作者ID
   * @returns {Promise<Object>} 举报详情
   */
  async getReportDetails(reportId, operatorId) {
    try {
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('admin') && !operator.roles.includes('moderator'))) {
        throw new BusinessError('无权限查看举报详情');
      }

      const report = await ContentReport.findById(reportId)
        .populate('reporter.userId', 'username email phone')
        .populate('reportedContent.contentAuthorId', 'username email')
        .populate('processing.assignedTo', 'username email')
        .populate('relatedReports.reportId', 'reportType status createdAt');

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      // 检查权限（审核员只能查看分配给自己的）
      if (operator.roles.includes('moderator') && !operator.roles.includes('admin')) {
        if (report.processing.assignedTo?.toString() !== operatorId) {
          throw new BusinessError('无权限查看此举报');
        }
      }

      return {
        success: true,
        data: {
          id: report._id,
          reportType: report.reportType,
          reportedContent: report.reportedContent,
          reporter: report.reporter,
          reportDetails: report.reportDetails,
          status: report.status,
          priority: report.priority,
          processing: report.processing,
          autoDetection: report.autoDetection,
          relatedReports: report.relatedReports,
          history: report.history,
          location: report.location,
          createdAt: report.createdAt,
          updatedAt: report.updatedAt
        }
      };

    } catch (error) {
      logger.error('获取举报详情失败', { error: error.message, reportId, operatorId });
      throw error;
    }
  }

  /**
   * 分配举报给审核员
   * @param {string} reportId - 举报ID
   * @param {string} assigneeId - 被分配者ID
   * @param {string} assignerId - 分配者ID
   * @returns {Promise<Object>} 分配结果
   */
  async assignReport(reportId, assigneeId, assignerId) {
    try {
      const [report, assignee, assigner] = await Promise.all([
        ContentReport.findById(reportId),
        User.findById(assigneeId),
        User.findById(assignerId)
      ]);

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      if (!assignee || (!assignee.roles.includes('admin') && !assignee.roles.includes('moderator'))) {
        throw new ValidationError('被分配者必须是管理员或审核员');
      }

      if (!assigner || !assigner.roles.includes('admin')) {
        throw new BusinessError('只有管理员可以分配举报');
      }

      if (report.status !== 'pending') {
        throw new BusinessError('只能分配待处理的举报');
      }

      await report.assignTo(assigneeId, assignerId);

      logger.info('举报分配成功', {
        reportId,
        assigneeId,
        assignerId,
        reportType: report.reportType
      });

      return {
        success: true,
        message: '举报分配成功',
        data: {
          assignedTo: assignee.username,
          assignedAt: report.processing.assignedAt
        }
      };

    } catch (error) {
      logger.error('分配举报失败', { error: error.message, reportId, assigneeId, assignerId });
      throw error;
    }
  }

  /**
   * 开始处理举报
   * @param {string} reportId - 举报ID
   * @param {string} processerId - 处理者ID
   * @returns {Promise<Object>} 处理结果
   */
  async startProcessing(reportId, processerId) {
    try {
      const [report, processor] = await Promise.all([
        ContentReport.findById(reportId),
        User.findById(processerId)
      ]);

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      if (!processor || (!processor.roles.includes('admin') && !processor.roles.includes('moderator'))) {
        throw new BusinessError('只有管理员或审核员可以处理举报');
      }

      // 检查是否有权限处理此举报
      if (report.processing.assignedTo && report.processing.assignedTo.toString() !== processerId) {
        throw new BusinessError('此举报已分配给其他人处理');
      }

      if (report.status !== 'pending' && report.status !== 'reviewing') {
        throw new BusinessError('举报状态不允许开始处理');
      }

      await report.startProcessing(processerId);

      logger.info('开始处理举报', {
        reportId,
        processerId,
        reportType: report.reportType
      });

      return {
        success: true,
        message: '已开始处理举报',
        data: {
          status: report.status,
          startedAt: report.processing.startedAt
        }
      };

    } catch (error) {
      logger.error('开始处理举报失败', { error: error.message, reportId, processerId });
      throw error;
    }
  }

  /**
   * 解决举报
   * @param {string} reportId - 举报ID
   * @param {Object} resolutionData - 解决方案数据
   * @param {string} processerId - 处理者ID
   * @returns {Promise<Object>} 解决结果
   */
  async resolveReport(reportId, resolutionData, processerId) {
    try {
      const { result, resultReason, processingNotes } = resolutionData;

      const [report, processor] = await Promise.all([
        ContentReport.findById(reportId),
        User.findById(processerId)
      ]);

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      if (!processor || (!processor.roles.includes('admin') && !processor.roles.includes('moderator'))) {
        throw new BusinessError('只有管理员或审核员可以解决举报');
      }

      // 检查处理权限
      if (report.processing.assignedTo && report.processing.assignedTo.toString() !== processerId) {
        throw new BusinessError('只有分配的处理者可以解决此举报');
      }

      if (report.status !== 'reviewing') {
        throw new BusinessError('只能解决正在审核的举报');
      }

      // 验证解决结果
      const validResults = [
        'no_action', 'content_warning', 'content_hidden', 
        'content_removed', 'user_warned', 'user_suspended', 'user_banned'
      ];

      if (!validResults.includes(result)) {
        throw new ValidationError('无效的处理结果');
      }

      await report.resolve(result, resultReason, processerId, processingNotes);

      // 执行相应的内容处理操作
      await this.executeContentAction(report, result);

      logger.info('举报解决成功', {
        reportId,
        result,
        processerId,
        reportType: report.reportType
      });

      return {
        success: true,
        message: '举报处理完成',
        data: {
          result,
          resultReason,
          completedAt: report.processing.completedAt
        }
      };

    } catch (error) {
      logger.error('解决举报失败', { error: error.message, reportId, processerId });
      throw error;
    }
  }

  /**
   * 升级举报
   * @param {string} reportId - 举报ID
   * @param {string} reason - 升级原因
   * @param {string} operatorId - 操作者ID
   * @returns {Promise<Object>} 升级结果
   */
  async escalateReport(reportId, reason, operatorId) {
    try {
      const [report, operator] = await Promise.all([
        ContentReport.findById(reportId),
        User.findById(operatorId)
      ]);

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      if (!operator || (!operator.roles.includes('admin') && !operator.roles.includes('moderator'))) {
        throw new BusinessError('只有管理员或审核员可以升级举报');
      }

      if (report.status === 'resolved' || report.status === 'rejected') {
        throw new BusinessError('已处理的举报无法升级');
      }

      await report.escalate(reason, operatorId);

      logger.info('举报升级成功', {
        reportId,
        reason,
        operatorId,
        reportType: report.reportType
      });

      return {
        success: true,
        message: '举报已升级处理',
        data: {
          status: report.status,
          priority: report.priority
        }
      };

    } catch (error) {
      logger.error('升级举报失败', { error: error.message, reportId, operatorId });
      throw error;
    }
  }

  /**
   * 添加处理备注
   * @param {string} reportId - 举报ID
   * @param {string} note - 备注内容
   * @param {string} operatorId - 操作者ID
   * @returns {Promise<Object>} 添加结果
   */
  async addProcessingNote(reportId, note, operatorId) {
    try {
      const [report, operator] = await Promise.all([
        ContentReport.findById(reportId),
        User.findById(operatorId)
      ]);

      if (!report) {
        throw new NotFoundError('举报记录不存在');
      }

      if (!operator || (!operator.roles.includes('admin') && !operator.roles.includes('moderator'))) {
        throw new BusinessError('只有管理员或审核员可以添加备注');
      }

      await report.addNote(note, operatorId);

      logger.info('举报备注添加成功', {
        reportId,
        operatorId,
        noteLength: note.length
      });

      return {
        success: true,
        message: '备注添加成功'
      };

    } catch (error) {
      logger.error('添加举报备注失败', { error: error.message, reportId, operatorId });
      throw error;
    }
  }

  /**
   * 获取举报统计
   * @param {Object} options - 统计选项
   * @param {string} operatorId - 操作者ID
   * @returns {Promise<Object>} 统计数据
   */
  async getReportStats(options = {}, operatorId) {
    try {
      const operator = await User.findById(operatorId);
      if (!operator || (!operator.roles.includes('admin') && !operator.roles.includes('moderator'))) {
        throw new BusinessError('无权限查看举报统计');
      }

      const { startDate, endDate, reportType, assigneeId } = options;

      // 获取处理统计
      const processingStats = await ContentReport.getProcessingStats({
        startDate,
        endDate,
        assigneeId,
        reportType
      });

      // 获取基础统计
      const query = { isDeleted: false };
      if (startDate || endDate) {
        query.createdAt = {};
        if (startDate) query.createdAt.$gte = new Date(startDate);
        if (endDate) query.createdAt.$lte = new Date(endDate);
      }

      const [totalReports, pendingReports, reviewingReports, resolvedReports] = await Promise.all([
        ContentReport.countDocuments(query),
        ContentReport.countDocuments({ ...query, status: 'pending' }),
        ContentReport.countDocuments({ ...query, status: 'reviewing' }),
        ContentReport.countDocuments({ ...query, status: 'resolved' })
      ]);

      return {
        success: true,
        data: {
          overview: {
            total: totalReports,
            pending: pendingReports,
            reviewing: reviewingReports,
            resolved: resolvedReports,
            resolutionRate: totalReports > 0 ? ((resolvedReports / totalReports) * 100).toFixed(2) : 0
          },
          processingStats: processingStats.reduce((acc, stat) => {
            const key = `${stat._id.status}_${stat._id.result || 'none'}`;
            acc[key] = {
              count: stat.count,
              avgProcessingTime: stat.avgProcessingTime ? Math.round(stat.avgProcessingTime / (1000 * 60 * 60)) : null // 转换为小时
            };
            return acc;
          }, {})
        }
      };

    } catch (error) {
      logger.error('获取举报统计失败', { error: error.message, operatorId });
      throw error;
    }
  }

  /**
   * 自动检测内容问题
   * @private
   * @param {Object} report - 举报对象
   */
  async runAutoDetection(report) {
    try {
      // 这里可以集成AI内容检测服务
      // 示例：调用文本分析API检测不当内容

      const detectionResult = {
        isAutoDetected: true,
        detectionModel: 'content_classifier_v1',
        confidenceScore: 0.85,
        detectedIssues: ['inappropriate_language'],
        detectionDetails: {
          textAnalysis: 'detected potential inappropriate content',
          riskLevel: 'medium'
        }
      };

      report.autoDetection = detectionResult;
      await report.save();

      logger.info('自动检测完成', {
        reportId: report._id,
        confidenceScore: detectionResult.confidenceScore,
        detectedIssues: detectionResult.detectedIssues
      });

    } catch (error) {
      logger.error('自动检测失败', { error: error.message, reportId: report._id });
    }
  }

  /**
   * 自动分配审核员
   * @private
   * @param {Object} report - 举报对象
   */
  async autoAssignModerator(report) {
    try {
      // 查找可用的审核员（负载最少的）
      const moderators = await User.find({
        roles: 'moderator',
        status: 'active'
      });

      if (moderators.length === 0) {
        return;
      }

      // 简单的负载均衡：选择当前分配举报最少的审核员
      const moderatorLoads = await Promise.all(
        moderators.map(async (mod) => {
          const assignedCount = await ContentReport.countDocuments({
            'processing.assignedTo': mod._id,
            status: { $in: ['pending', 'reviewing'] }
          });
          return { moderator: mod, load: assignedCount };
        })
      );

      const selectedModerator = moderatorLoads.reduce((min, current) => 
        current.load < min.load ? current : min
      ).moderator;

      await report.assignTo(selectedModerator._id, 'system');

      logger.info('自动分配审核员成功', {
        reportId: report._id,
        assignedTo: selectedModerator._id,
        assignedToUsername: selectedModerator.username
      });

    } catch (error) {
      logger.error('自动分配审核员失败', { error: error.message, reportId: report._id });
    }
  }

  /**
   * 执行内容处理操作
   * @private
   * @param {Object} report - 举报对象
   * @param {string} action - 处理操作
   */
  async executeContentAction(report, action) {
    try {
      // 这里需要根据不同的内容类型执行相应的操作
      const { contentType, contentId } = report.reportedContent;

      switch (action) {
        case 'content_hidden':
          // 隐藏内容
          await this.hideContent(contentType, contentId);
          break;
        case 'content_removed':
          // 删除内容
          await this.removeContent(contentType, contentId);
          break;
        case 'user_warned':
          // 警告用户
          await this.warnUser(report.reportedContent.contentAuthorId);
          break;
        case 'user_suspended':
          // 暂停用户
          await this.suspendUser(report.reportedContent.contentAuthorId, 7); // 7天暂停
          break;
        case 'user_banned':
          // 封禁用户
          await this.banUser(report.reportedContent.contentAuthorId);
          break;
        default:
          // 无需额外操作
          break;
      }

      logger.info('内容处理操作执行完成', {
        reportId: report._id,
        action,
        contentType,
        contentId
      });

    } catch (error) {
      logger.error('执行内容处理操作失败', { error: error.message, reportId: report._id, action });
      // 操作失败不影响举报状态更新
    }
  }

  /**
   * 隐藏内容
   * @private
   */
  async hideContent(contentType, contentId) {
    // 根据内容类型执行隐藏操作
    // 这里需要调用相应的服务
  }

  /**
   * 删除内容
   * @private
   */
  async removeContent(contentType, contentId) {
    // 根据内容类型执行删除操作
  }

  /**
   * 警告用户
   * @private
   */
  async warnUser(userId) {
    // 发送警告通知给用户
  }

  /**
   * 暂停用户
   * @private
   */
  async suspendUser(userId, days) {
    // 暂停用户账号
  }

  /**
   * 封禁用户
   * @private
   */
  async banUser(userId) {
    // 封禁用户账号
  }
}

module.exports = new ContentReportService();