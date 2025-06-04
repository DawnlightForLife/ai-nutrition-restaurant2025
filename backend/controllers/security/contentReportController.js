const contentReportService = require('../../services/security/contentReportService');
const { successResponse, errorResponse } = require('../../utils/responseHelper');
const { ValidationError, NotFoundError, BusinessError } = require('../../utils/errors');

/**
 * 内容举报控制器
 */
class ContentReportController {
  /**
   * 创建内容举报
   */
  async createReport(req, res) {
    try {
      const {
        reportType,
        contentType,
        contentId,
        reason,
        description,
        severity = 'medium',
        evidence
      } = req.body;
      const reporterId = req.user.id;

      // 验证必填字段
      if (!reportType || !contentType || !contentId || !reason) {
        return errorResponse(res, '举报类型、内容类型、内容ID和举报原因不能为空', 400);
      }

      const reportData = {
        reportType,
        contentType,
        contentId,
        reason,
        description,
        severity,
        evidence
      };

      const options = {
        ipAddress: req.ip,
        userAgent: req.get('User-Agent'),
        enableAutoDetection: true,
        autoAssign: true
      };

      const result = await contentReportService.createReport(
        reportData, 
        reporterId, 
        options
      );

      if (!result.success) {
        return errorResponse(res, result.message, 400, result.data);
      }

      return successResponse(res, result.data, result.message, 201);

    } catch (error) {
      if (error instanceof ValidationError) {
        return errorResponse(res, error.message, 400);
      }
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      return errorResponse(res, '提交举报失败', 500);
    }
  }

  /**
   * 获取举报列表（管理员/审核员）
   */
  async getReports(req, res) {
    try {
      const {
        page,
        limit,
        status,
        reportType,
        priority,
        assignedTo,
        contentType,
        startDate,
        endDate,
        search
      } = req.query;
      const operatorId = req.user.id;

      const options = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20,
        status,
        reportType,
        priority,
        assignedTo,
        contentType,
        startDate,
        endDate,
        search
      };

      const result = await contentReportService.getReports(options, operatorId);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '获取举报列表失败', 500);
    }
  }

  /**
   * 获取举报详情
   */
  async getReportDetails(req, res) {
    try {
      const { reportId } = req.params;
      const operatorId = req.user.id;

      const result = await contentReportService.getReportDetails(reportId, operatorId);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '获取举报详情失败', 500);
    }
  }

  /**
   * 分配举报给审核员
   */
  async assignReport(req, res) {
    try {
      const { reportId } = req.params;
      const { assigneeId } = req.body;
      const assignerId = req.user.id;

      if (!assigneeId) {
        return errorResponse(res, '被分配者ID不能为空', 400);
      }

      const result = await contentReportService.assignReport(
        reportId, 
        assigneeId, 
        assignerId
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof ValidationError || error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '分配举报失败', 500);
    }
  }

  /**
   * 开始处理举报
   */
  async startProcessing(req, res) {
    try {
      const { reportId } = req.params;
      const processerId = req.user.id;

      const result = await contentReportService.startProcessing(reportId, processerId);

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '开始处理失败', 500);
    }
  }

  /**
   * 解决举报
   */
  async resolveReport(req, res) {
    try {
      const { reportId } = req.params;
      const { result, resultReason, processingNotes } = req.body;
      const processerId = req.user.id;

      if (!result) {
        return errorResponse(res, '处理结果不能为空', 400);
      }

      if (!resultReason) {
        return errorResponse(res, '处理原因不能为空', 400);
      }

      const resolutionData = {
        result,
        resultReason,
        processingNotes
      };

      const resolveResult = await contentReportService.resolveReport(
        reportId, 
        resolutionData, 
        processerId
      );

      return successResponse(res, resolveResult.data, resolveResult.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof ValidationError || error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '解决举报失败', 500);
    }
  }

  /**
   * 升级举报
   */
  async escalateReport(req, res) {
    try {
      const { reportId } = req.params;
      const { reason } = req.body;
      const operatorId = req.user.id;

      if (!reason) {
        return errorResponse(res, '升级原因不能为空', 400);
      }

      const result = await contentReportService.escalateReport(
        reportId, 
        reason, 
        operatorId
      );

      return successResponse(res, result.data, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '升级举报失败', 500);
    }
  }

  /**
   * 添加处理备注
   */
  async addProcessingNote(req, res) {
    try {
      const { reportId } = req.params;
      const { note } = req.body;
      const operatorId = req.user.id;

      if (!note || note.trim().length === 0) {
        return errorResponse(res, '备注内容不能为空', 400);
      }

      if (note.length > 500) {
        return errorResponse(res, '备注内容不能超过500字符', 400);
      }

      const result = await contentReportService.addProcessingNote(
        reportId, 
        note.trim(), 
        operatorId
      );

      return successResponse(res, null, result.message);

    } catch (error) {
      if (error instanceof NotFoundError) {
        return errorResponse(res, error.message, 404);
      }
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 400);
      }
      return errorResponse(res, '添加备注失败', 500);
    }
  }

  /**
   * 获取举报统计
   */
  async getReportStats(req, res) {
    try {
      const { startDate, endDate, reportType, assigneeId } = req.query;
      const operatorId = req.user.id;

      const options = {
        startDate,
        endDate,
        reportType,
        assigneeId
      };

      const result = await contentReportService.getReportStats(options, operatorId);

      return successResponse(res, result.data);

    } catch (error) {
      if (error instanceof BusinessError) {
        return errorResponse(res, error.message, 403);
      }
      return errorResponse(res, '获取统计数据失败', 500);
    }
  }

  /**
   * 获取我的举报列表（用户查看自己的举报）
   */
  async getMyReports(req, res) {
    try {
      const { page, limit, status } = req.query;
      const userId = req.user.id;

      // 构建查询条件
      const options = {
        page: parseInt(page) || 1,
        limit: parseInt(limit) || 20,
        reporterId: userId
      };

      if (status) {
        options.status = status;
      }

      // 这里需要添加获取用户自己举报的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '获取我的举报失败', 500);
    }
  }

  /**
   * 批量处理举报
   */
  async batchProcessReports(req, res) {
    try {
      const { reportIds, action, actionData } = req.body;
      const operatorId = req.user.id;

      if (!Array.isArray(reportIds) || reportIds.length === 0) {
        return errorResponse(res, '举报ID列表不能为空', 400);
      }

      if (reportIds.length > 50) {
        return errorResponse(res, '单次最多处理50个举报', 400);
      }

      if (!action) {
        return errorResponse(res, '批量操作类型不能为空', 400);
      }

      const validActions = ['assign', 'resolve', 'escalate'];
      if (!validActions.includes(action)) {
        return errorResponse(res, '无效的批量操作类型', 400);
      }

      const results = [];
      for (const reportId of reportIds) {
        try {
          let result;
          switch (action) {
            case 'assign':
              result = await contentReportService.assignReport(
                reportId, 
                actionData.assigneeId, 
                operatorId
              );
              break;
            case 'resolve':
              result = await contentReportService.resolveReport(
                reportId, 
                actionData, 
                operatorId
              );
              break;
            case 'escalate':
              result = await contentReportService.escalateReport(
                reportId, 
                actionData.reason, 
                operatorId
              );
              break;
          }
          results.push({ 
            reportId, 
            success: true, 
            message: result.message 
          });
        } catch (error) {
          results.push({ 
            reportId, 
            success: false, 
            error: error.message 
          });
        }
      }

      const successCount = results.filter(r => r.success).length;

      return successResponse(res, {
        results,
        summary: {
          total: reportIds.length,
          success: successCount,
          failed: reportIds.length - successCount
        }
      }, `批量${action}完成，成功${successCount}个`);

    } catch (error) {
      return errorResponse(res, '批量处理失败', 500);
    }
  }

  /**
   * 获取举报类型统计
   */
  async getReportTypeStats(req, res) {
    try {
      const { startDate, endDate } = req.query;
      const operatorId = req.user.id;

      // 验证权限
      if (!req.user.roles.includes('admin') && !req.user.roles.includes('moderator')) {
        return errorResponse(res, '权限不足', 403);
      }

      // 这里需要添加按类型统计的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '获取类型统计失败', 500);
    }
  }

  /**
   * 导出举报数据
   */
  async exportReports(req, res) {
    try {
      const { startDate, endDate, status, format = 'json' } = req.query;
      const operatorId = req.user.id;

      if (!req.user.roles.includes('admin')) {
        return errorResponse(res, '权限不足', 403);
      }

      const options = {
        page: 1,
        limit: 1000, // 导出限制
        status,
        startDate,
        endDate
      };

      const result = await contentReportService.getReports(options, operatorId);

      if (format === 'csv') {
        res.setHeader('Content-Type', 'text/csv');
        res.setHeader('Content-Disposition', 'attachment; filename=content_reports.csv');
        
        const csvData = this.convertToCSV(result.data.reports);
        return res.send(csvData);
      }

      return successResponse(res, result.data);

    } catch (error) {
      return errorResponse(res, '导出数据失败', 500);
    }
  }

  /**
   * 获取处理进度
   */
  async getProcessingProgress(req, res) {
    try {
      const operatorId = req.user.id;

      // 验证权限
      if (!req.user.roles.includes('admin') && !req.user.roles.includes('moderator')) {
        return errorResponse(res, '权限不足', 403);
      }

      // 这里需要添加获取处理进度的服务方法
      // 暂时返回基础响应
      return errorResponse(res, '功能开发中', 501);

    } catch (error) {
      return errorResponse(res, '获取处理进度失败', 500);
    }
  }

  /**
   * 转换为CSV格式
   * @private
   */
  convertToCSV(reports) {
    const headers = [
      'id', 'reportType', 'contentType', 'reporterUsername', 
      'status', 'priority', 'reason', 'createdAt', 'assignedTo'
    ];
    
    const csvRows = [headers.join(',')];
    
    reports.forEach(report => {
      const row = [
        report.id,
        report.reportType,
        report.reportedContent.contentType,
        report.reporter.username || '匿名',
        report.status,
        report.priority,
        `"${report.reportDetails.reason}"`, // 用引号包围避免逗号问题
        report.createdAt,
        report.processing.assignedTo?.username || ''
      ];
      csvRows.push(row.join(','));
    });
    
    return csvRows.join('\n');
  }
}

module.exports = new ContentReportController();