const consultationService = require('../../services/consult/consultationService');
const nutritionistClientService = require('../../services/nutrition/nutritionistClientService');
const nutritionistStatsService = require('../../services/nutrition/nutritionistStatsService');
const nutritionistService = require('../../services/nutrition/nutritionistService');
const NotificationService = require('../../services/notification/notificationService');
const { 
  successResponse, 
  errorResponse, 
  notFoundResponse 
} = require('../../utils/responseHelper');
const { asyncHandler, AppError } = require('../../middleware/core/errorHandlingMiddleware');
const logger = require('../../config/modules/logger');
// const Redis = require('../../config/modules/redis'); // TODO: Implement Redis integration

const workbenchController = {
  // 获取工作台统计数据
  getDashboardStats: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    
    if (!nutritionistId) {
      return notFoundResponse(res, '未找到营养师信息');
    }

    try {
      // 获取综合统计数据
      const stats = await nutritionistStatsService.getNutritionistStats(nutritionistId);
      
      // 获取今日数据
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const todayStats = {
        consultations: 0,
        completedConsultations: 0,
        newClients: 0,
        totalIncome: 0
      };

      // 计算今日咨询数据
      const recentConsultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
        startDate: today,
        limit: 100
      });

      todayStats.consultations = recentConsultations.filter(c => 
        new Date(c.createdAt) >= today
      ).length;

      todayStats.completedConsultations = recentConsultations.filter(c => 
        c.status === 'completed' && new Date(c.updatedAt) >= today
      ).length;

      // 组合数据
      const dashboardData = {
        overall: {
          totalConsultations: stats.totalConsultations || 0,
          totalClients: stats.totalClients || 0,
          averageRating: stats.averageRating || 0,
          totalRevenue: stats.totalRevenue || 0
        },
        today: todayStats,
        recentTrends: stats.recentTrends || {},
        upcomingConsultations: await consultationService.getUpcomingConsultations(nutritionistId, 5)
      };

      successResponse(res, dashboardData);
    } catch (error) {
      logger.error('获取工作台统计数据失败:', error);
      errorResponse(res, '获取统计数据失败');
    }
  }),

  // 获取待办任务
  getTasks: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    try {
      const tasks = [];

      // 待接受的咨询
      const pendingConsultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
        status: 'pending',
        limit: 10
      });

      pendingConsultations.forEach(consultation => {
        tasks.push({
          id: `consultation-${consultation._id}`,
          type: 'consultation_pending',
          title: '待接受咨询',
          description: `来自 ${consultation.userId?.username || '用户'} 的咨询请求`,
          priority: 'high',
          createdAt: consultation.createdAt,
          data: consultation
        });
      });

      // 进行中的咨询
      const activeConsultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
        status: 'active',
        limit: 10
      });

      activeConsultations.forEach(consultation => {
        tasks.push({
          id: `consultation-${consultation._id}`,
          type: 'consultation_active',
          title: '进行中咨询',
          description: `与 ${consultation.userId?.username || '用户'} 的咨询进行中`,
          priority: 'medium',
          createdAt: consultation.createdAt,
          data: consultation
        });
      });

      // 需要更新的客户计划
      const clientsResult = await nutritionistClientService.getNutritionistClients(nutritionistId);
      const clients = clientsResult.success ? (Array.isArray(clientsResult.data) ? clientsResult.data : []) : [];
      const clientsNeedingUpdate = clients.filter(client => {
        const lastPlanUpdate = client.lastPlanUpdate || client.createdAt;
        const daysSinceUpdate = (Date.now() - new Date(lastPlanUpdate)) / (1000 * 60 * 60 * 24);
        return daysSinceUpdate > 14; // 14天未更新
      });

      clientsNeedingUpdate.forEach(client => {
        tasks.push({
          id: `client-${client._id}`,
          type: 'client_plan_update',
          title: '客户计划更新',
          description: `${client.nickname || '客户'} 的营养计划需要更新`,
          priority: 'low',
          createdAt: client.lastPlanUpdate || client.createdAt,
          data: client
        });
      });

      // 按优先级和时间排序
      const priorityOrder = { high: 0, medium: 1, low: 2 };
      tasks.sort((a, b) => {
        if (priorityOrder[a.priority] !== priorityOrder[b.priority]) {
          return priorityOrder[a.priority] - priorityOrder[b.priority];
        }
        return new Date(b.createdAt) - new Date(a.createdAt);
      });

      successResponse(res, tasks);
    } catch (error) {
      logger.error('获取待办任务失败:', error);
      errorResponse(res, '获取待办任务失败');
    }
  }),

  // 获取营养师视角的咨询列表
  getConsultations: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { status, page = 1, limit = 20 } = req.query;

    try {
      const query = { nutritionistId };
      if (status) {
        query.status = status;
      }

      const consultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
        status,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      successResponse(res, consultations);
    } catch (error) {
      logger.error('获取咨询列表失败:', error);
      errorResponse(res, '获取咨询列表失败');
    }
  }),

  // 接受咨询
  acceptConsultation: asyncHandler(async (req, res) => {
    const { id } = req.params;
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    try {
      const consultation = await consultationService.getConsultationById(id);
      
      if (!consultation) {
        return errorResponse(res, '咨询不存在', 404);
      }

      if (consultation.nutritionistId?.toString() !== nutritionistId) {
        return errorResponse(res, '无权操作此咨询', 403);
      }

      if (consultation.status !== 'pending') {
        return errorResponse(res, '咨询状态不允许接受', 400);
      }

      const updated = await consultationService.updateConsultation(id, { status: 'active' });

      // 发送通知给用户
      await NotificationService.sendNotification({
        userId: consultation.userId,
        type: 'consultation_accepted',
        title: '咨询已被接受',
        content: '您的咨询已被营养师接受，可以开始对话了',
        relatedId: id,
        relatedType: 'consultation'
      });

      successResponse(res, updated, '咨询已接受');
    } catch (error) {
      logger.error('接受咨询失败:', error);
      errorResponse(res, '接受咨询失败');
    }
  }),

  // 拒绝咨询
  rejectConsultation: asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { reason } = req.body;
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    try {
      const consultation = await consultationService.getConsultationById(id);
      
      if (!consultation) {
        return errorResponse(res, '咨询不存在', 404);
      }

      if (consultation.nutritionistId?.toString() !== nutritionistId) {
        return errorResponse(res, '无权操作此咨询', 403);
      }

      if (consultation.status !== 'pending') {
        return errorResponse(res, '咨询状态不允许拒绝', 400);
      }

      const updated = await consultationService.updateConsultation(id, { status: 'rejected', rejectReason: reason });

      // 发送通知给用户
      await NotificationService.sendNotification({
        userId: consultation.userId,
        type: 'consultation_rejected',
        title: '咨询已被拒绝',
        content: reason || '营养师暂时无法接受您的咨询',
        relatedId: id,
        relatedType: 'consultation'
      });

      successResponse(res, updated, '咨询已拒绝');
    } catch (error) {
      logger.error('拒绝咨询失败:', error);
      errorResponse(res, '拒绝咨询失败');
    }
  }),

  // 完成咨询
  completeConsultation: asyncHandler(async (req, res) => {
    const { id } = req.params;
    const { summary } = req.body;
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    try {
      const consultation = await consultationService.getConsultationById(id);
      
      if (!consultation) {
        return errorResponse(res, '咨询不存在', 404);
      }

      if (consultation.nutritionistId?.toString() !== nutritionistId) {
        return errorResponse(res, '无权操作此咨询', 403);
      }

      if (consultation.status !== 'active') {
        return errorResponse(res, '只能完成进行中的咨询', 400);
      }

      const updated = await consultationService.updateConsultation(id, { status: 'completed', summary });

      // 发送通知给用户
      await NotificationService.sendNotification({
        userId: consultation.userId,
        type: 'consultation_completed',
        title: '咨询已完成',
        content: '您的咨询已完成，请对服务进行评价',
        relatedId: id,
        relatedType: 'consultation'
      });

      successResponse(res, updated, '咨询已完成');
    } catch (error) {
      logger.error('完成咨询失败:', error);
      errorResponse(res, '完成咨询失败');
    }
  }),

  // 获取排班表
  getSchedule: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { startDate, endDate } = req.query;

    try {
      const nutritionistResult = await nutritionistService.getNutritionistByUserId(nutritionistId);
      
      if (!nutritionistResult.success || !nutritionistResult.data) {
        return errorResponse(res, nutritionistResult.message || '营养师信息不存在', 404);
      }

      const nutritionist = nutritionistResult.data;

      // 获取工作时间设置
      const schedule = {
        workingHours: nutritionist.workingHours || {},
        vacations: nutritionist.vacations || [],
        appointments: []
      };

      // 获取预约信息
      if (startDate && endDate) {
        const consultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
          startDate: new Date(startDate),
          endDate: new Date(endDate),
          status: ['pending', 'active', 'completed']
        });

        schedule.appointments = consultations.map(c => ({
          id: c._id,
          title: `咨询 - ${c.userId?.username || '用户'}`,
          start: c.appointmentTime || c.createdAt,
          end: new Date(new Date(c.appointmentTime || c.createdAt).getTime() + (c.duration || 60) * 60000),
          status: c.status,
          type: 'consultation'
        }));
      }

      successResponse(res, schedule);
    } catch (error) {
      logger.error('获取排班表失败:', error);
      errorResponse(res, '获取排班表失败');
    }
  }),

  // 更新排班
  updateSchedule: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { workingHours, vacations } = req.body;

    try {
      const updateData = {};
      
      if (workingHours) {
        updateData.workingHours = workingHours;
      }
      
      if (vacations) {
        updateData.vacations = vacations;
      }

      const updated = await nutritionistService.updateNutritionist(nutritionistId, updateData);

      successResponse(res, updated, '排班更新成功');
    } catch (error) {
      logger.error('更新排班失败:', error);
      errorResponse(res, '更新排班失败');
    }
  }),

  // 获取收入明细
  getIncomeDetails: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { startDate, endDate, page = 1, limit = 20 } = req.query;

    try {
      const incomeDetails = await nutritionistStatsService.getIncomeDetails(nutritionistId, {
        startDate: startDate ? new Date(startDate) : undefined,
        endDate: endDate ? new Date(endDate) : undefined,
        page: parseInt(page),
        limit: parseInt(limit)
      });

      successResponse(res, incomeDetails);
    } catch (error) {
      logger.error('获取收入明细失败:', error);
      errorResponse(res, '获取收入明细失败');
    }
  }),

  // 批量发送消息给客户
  sendBatchMessage: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { clientIds, message } = req.body;

    if (!clientIds || !clientIds.length || !message) {
      return errorResponse(res, '请提供客户ID列表和消息内容', 400);
    }

    try {
      // 验证客户关系
      const clients = await nutritionistClientService.getClientsByIds(clientIds, nutritionistId);
      const validClients = clients.filter(c => c.nutritionistId?.toString() === nutritionistId);

      if (validClients.length === 0) {
        return errorResponse(res, '没有有效的客户', 400);
      }

      // 发送消息
      const results = await Promise.allSettled(
        validClients.map(client => 
          NotificationService.sendNotification({
            userId: client.userId,
            type: 'nutritionist_message',
            title: '营养师消息',
            content: message,
            relatedId: nutritionistId,
            relatedType: 'nutritionist'
          })
        )
      );

      const successCount = results.filter(r => r.status === 'fulfilled').length;
      const failCount = results.filter(r => r.status === 'rejected').length;

      successResponse(res, {
        totalClients: validClients.length,
        successCount,
        failCount
      }, '批量消息发送完成');
    } catch (error) {
      logger.error('批量发送消息失败:', error);
      errorResponse(res, '批量发送消息失败');
    }
  }),

  // 切换在线状态
  toggleOnlineStatus: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    if (!nutritionistId) {
      return notFoundResponse(res, '未找到营养师信息');
    }

    try {
      const nutritionistResult = await nutritionistService.getNutritionistByUserId(nutritionistId);
      
      if (!nutritionistResult.success || !nutritionistResult.data) {
        return errorResponse(res, nutritionistResult.message || '营养师信息不存在', 404);
      }

      const nutritionist = nutritionistResult.data;

      // Toggle online status
      const newOnlineStatus = {
        isOnline: !nutritionist.onlineStatus?.isOnline,
        isAvailable: !nutritionist.onlineStatus?.isOnline, // Set availability same as online status
        lastActiveTime: new Date()
      };

      const updateResult = await nutritionistService.updateNutritionistByUserId(nutritionistId, {
        onlineStatus: newOnlineStatus
      });

      // Log status change
      logger.info('营养师在线状态已更改', {
        nutritionistId,
        oldStatus: nutritionist.onlineStatus?.isOnline,
        newStatus: newOnlineStatus.isOnline
      });

      successResponse(res, {
        isOnline: newOnlineStatus.isOnline,
        isAvailable: newOnlineStatus.isAvailable,
        nutritionist: updateResult.success ? updateResult.data : updateResult
      }, newOnlineStatus.isOnline ? '已上线' : '已下线');
    } catch (error) {
      logger.error('切换在线状态失败:', error);
      errorResponse(res, '切换状态失败');
    }
  }),

  // 更新可用状态
  updateAvailability: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;
    const { isAvailable } = req.body;

    if (!nutritionistId) {
      return notFoundResponse(res, '未找到营养师信息');
    }

    if (typeof isAvailable !== 'boolean') {
      return errorResponse(res, '请提供有效的可用状态', 400);
    }

    try {
      const nutritionistResult = await nutritionistService.getNutritionistByUserId(nutritionistId);
      
      if (!nutritionistResult.success || !nutritionistResult.data) {
        return errorResponse(res, nutritionistResult.message || '营养师信息不存在', 404);
      }

      const nutritionist = nutritionistResult.data;

      // Can only set availability if online
      if (!nutritionist.onlineStatus?.isOnline && isAvailable) {
        return errorResponse(res, '必须先上线才能设置为可用状态', 400);
      }

      const updatedOnlineStatus = {
        ...nutritionist.onlineStatus,
        isAvailable,
        lastActiveTime: new Date()
      };

      const updateResult = await nutritionistService.updateNutritionistByUserId(nutritionistId, {
        onlineStatus: updatedOnlineStatus
      });

      successResponse(res, {
        onlineStatus: updatedOnlineStatus,
        nutritionist: updateResult.success ? updateResult.data : updateResult
      }, isAvailable ? '已设为可用' : '已设为忙碌');
    } catch (error) {
      logger.error('更新可用状态失败:', error);
      errorResponse(res, '更新状态失败');
    }
  }),

  // 获取快捷操作
  getQuickActions: asyncHandler(async (req, res) => {
    const nutritionistId = req.user.nutritionistId || req.user.id || req.user.userId;

    try {
      // 获取在线状态
      const nutritionistResult = await nutritionistService.getNutritionistByUserId(nutritionistId);
      const nutritionist = nutritionistResult.success ? nutritionistResult.data : null;
      const isOnline = nutritionist?.onlineStatus?.isOnline || false;

      const quickActions = [
        {
          id: 'toggle_online',
          title: isOnline ? '下线' : '上线',
          icon: isOnline ? 'offline_pin' : 'online_prediction',
          action: 'toggle_online_status',
          color: isOnline ? '#F44336' : '#4CAF50'
        },
        {
          id: 'new_plan',
          title: '创建营养计划',
          icon: 'restaurant_menu',
          action: 'create_nutrition_plan',
          color: '#2196F3'
        },
        {
          id: 'view_appointments',
          title: '查看预约',
          icon: 'calendar_today',
          action: 'view_appointments',
          color: '#FF9800'
        },
        {
          id: 'message_clients',
          title: '群发消息',
          icon: 'message',
          action: 'batch_message',
          color: '#9C27B0'
        },
        {
          id: 'export_report',
          title: '导出报表',
          icon: 'file_download',
          action: 'export_report',
          color: '#607D8B'
        }
      ];

      // 根据当前状态添加动态操作
      const pendingConsultations = await consultationService.getConsultationsByNutritionist(nutritionistId, {
        status: 'pending',
        limit: 1
      });

      if (pendingConsultations.length > 0) {
        quickActions.unshift({
          id: 'pending_consultations',
          title: `${pendingConsultations.length} 个待处理咨询`,
          icon: 'notification_important',
          action: 'view_pending_consultations',
          color: '#E91E63',
          badge: pendingConsultations.length
        });
      }

      successResponse(res, quickActions);
    } catch (error) {
      logger.error('获取快捷操作失败:', error);
      errorResponse(res, '获取快捷操作失败');
    }
  })
};

module.exports = workbenchController;