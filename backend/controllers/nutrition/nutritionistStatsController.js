/**
 * 营养师统计分析控制器
 * 处理营养师业绩统计、收入分析等请求
 * @module controllers/nutrition/nutritionistStatsController
 */

const nutritionistStatsService = require('../../services/nutrition/nutritionistStatsService');
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 获取营养师综合统计数据
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含统计数据的JSON响应
 */
exports.getNutritionistStats = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看统计数据'
    });
  }

  const {
    startDate,
    endDate,
    period = 'month'
  } = req.query;

  const options = {
    startDate: startDate ? new Date(startDate) : undefined,
    endDate: endDate ? new Date(endDate) : undefined,
    period
  };

  const result = await nutritionistStatsService.getNutritionistStats(nutritionistId, options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取统计数据成功',
    data: result.data
  });
});

/**
 * 获取营养师收入详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含收入详情的JSON响应
 */
exports.getNutritionistIncome = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看收入详情'
    });
  }

  const {
    startDate,
    endDate,
    groupBy = 'day'
  } = req.query;

  const options = {
    startDate: startDate ? new Date(startDate) : undefined,
    endDate: endDate ? new Date(endDate) : undefined,
    groupBy
  };

  const result = await nutritionistStatsService.getNutritionistIncome(nutritionistId, options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取收入详情成功',
    data: result.data
  });
});

/**
 * 获取营养师评价统计
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含评价统计的JSON响应
 */
exports.getNutritionistReviews = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看评价统计'
    });
  }

  const {
    limit = 20,
    page = 1,
    sortBy = 'ratedAt',
    sortOrder = 'desc',
    minRating,
    maxRating
  } = req.query;

  const options = {
    limit: parseInt(limit),
    skip: (parseInt(page) - 1) * parseInt(limit),
    sortBy,
    sortOrder: sortOrder === 'asc' ? 1 : -1,
    minRating: minRating ? parseFloat(minRating) : null,
    maxRating: maxRating ? parseFloat(maxRating) : null
  };

  const result = await nutritionistStatsService.getNutritionistReviews(nutritionistId, options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取评价统计成功',
    data: result.data.reviews,
    statistics: result.data.statistics,
    pagination: result.data.pagination
  });
});

/**
 * 获取营养师绩效概览
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含绩效概览的JSON响应
 */
exports.getNutritionistPerformanceOverview = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看绩效概览'
    });
  }

  // 获取多个时间段的数据进行对比
  const now = new Date();
  const thisMonth = new Date(now.getFullYear(), now.getMonth(), 1);
  const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
  const lastMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);

  const [thisMonthStats, lastMonthStats] = await Promise.all([
    nutritionistStatsService.getNutritionistStats(nutritionistId, {
      startDate: thisMonth,
      endDate: now,
      period: 'day'
    }),
    nutritionistStatsService.getNutritionistStats(nutritionistId, {
      startDate: lastMonth,
      endDate: lastMonthEnd,
      period: 'day'
    })
  ]);

  if (!thisMonthStats.success || !lastMonthStats.success) {
    return res.status(400).json({
      success: false,
      message: '获取绩效数据失败'
    });
  }

  // 计算变化百分比
  const calculateChange = (current, previous) => {
    if (previous === 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  };

  const thisMonth_ = thisMonthStats.data.overview;
  const lastMonth_ = lastMonthStats.data.overview;

  const performanceOverview = {
    thisMonth: thisMonth_,
    lastMonth: lastMonth_,
    changes: {
      consultations: calculateChange(thisMonth_.totalConsultations, lastMonth_.totalConsultations),
      income: calculateChange(thisMonth_.totalIncome, lastMonth_.totalIncome),
      clients: calculateChange(thisMonth_.newClients, lastMonth_.newClients),
      rating: calculateChange(thisMonth_.averageRating, lastMonth_.averageRating),
      completionRate: calculateChange(thisMonth_.completionRate, lastMonth_.completionRate)
    },
    trends: thisMonthStats.data.trends
  };

  res.status(200).json({
    success: true,
    message: '获取绩效概览成功',
    data: performanceOverview
  });
});

/**
 * 获取营养师客户分析
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含客户分析的JSON响应
 */
exports.getNutritionistClientAnalysis = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看客户分析'
    });
  }

  const {
    startDate,
    endDate
  } = req.query;

  // 这里可以调用客户分析相关的服务方法
  // 暂时返回基础统计信息
  const statsResult = await nutritionistStatsService.getNutritionistStats(nutritionistId, {
    startDate: startDate ? new Date(startDate) : undefined,
    endDate: endDate ? new Date(endDate) : undefined
  });

  if (!statsResult.success) {
    return res.status(400).json({
      success: false,
      message: statsResult.message
    });
  }

  // 提取客户相关的分析数据
  const clientAnalysis = {
    overview: {
      totalClients: statsResult.data.overview.totalClients,
      activeClients: statsResult.data.overview.activeClients,
      newClients: statsResult.data.overview.newClients,
      averageRelationshipDuration: statsResult.data.overview.averageRelationshipDuration
    },
    trends: statsResult.data.trends.map(trend => ({
      period: trend.period,
      newClients: trend.newClients || 0,
      activeConsultations: trend.consultations
    }))
  };

  res.status(200).json({
    success: true,
    message: '获取客户分析成功',
    data: clientAnalysis
  });
});

/**
 * 获取营养师工作时间分析
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含工作时间分析的JSON响应
 */
exports.getNutritionistWorkTimeAnalysis = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看工作时间分析'
    });
  }

  const {
    startDate = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 默认最近7天
    endDate = new Date()
  } = req.query;
  
  // 使用日期参数进行后续数据查询

  // 这里应该从在线状态记录或活动日志中获取工作时间数据
  // 暂时返回模拟数据
  const workTimeAnalysis = {
    totalWorkHours: 40,
    averageWorkHoursPerDay: 5.7,
    peakWorkHours: '14:00-16:00',
    workdayDistribution: [
      { day: '周一', hours: 6 },
      { day: '周二', hours: 5 },
      { day: '周三', hours: 7 },
      { day: '周四', hours: 6 },
      { day: '周五', hours: 5 },
      { day: '周六', hours: 8 },
      { day: '周日', hours: 3 }
    ],
    onlineAvailabilityRate: 85, // 在线可用率
    averageResponseTime: 15 // 平均响应时间（分钟）
  };

  res.status(200).json({
    success: true,
    message: '获取工作时间分析成功',
    data: workTimeAnalysis
  });
});

/**
 * 导出营养师统计报告
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含导出结果的JSON响应
 */
exports.exportNutritionistReport = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能导出统计报告'
    });
  }

  const {
    reportType = 'comprehensive', // 'comprehensive', 'income', 'performance', 'clients'
    format = 'pdf', // 'pdf', 'excel'
    startDate = new Date(Date.now() - 30 * 24 * 60 * 60 * 1000), // 默认最近30天
    endDate = new Date()
  } = req.query;
  
  // 使用日期参数和格式参数生成报告

  // 这里应该调用报告生成服务
  // 暂时返回任务创建成功的响应
  const reportTask = {
    taskId: `report_${nutritionistId}_${Date.now()}`,
    status: 'pending',
    reportType,
    format,
    createdAt: new Date(),
    estimatedCompletionTime: new Date(Date.now() + 5 * 60 * 1000) // 5分钟后完成
  };

  res.status(202).json({
    success: true,
    message: '报告生成任务已创建',
    data: reportTask
  });
});

/**
 * 获取报告生成状态
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含报告状态的JSON响应
 */
exports.getReportStatus = catchAsync(async (req, res) => {
  const { taskId } = req.params;
  
  // 这里应该查询实际的报告生成状态
  // 暂时返回模拟状态
  const reportStatus = {
    taskId,
    status: 'completed', // 'pending', 'processing', 'completed', 'failed'
    progress: 100,
    downloadUrl: taskId.includes('report_') ? `/api/reports/download/${taskId}` : null,
    createdAt: new Date(Date.now() - 5 * 60 * 1000),
    completedAt: new Date()
  };

  res.status(200).json({
    success: true,
    message: '获取报告状态成功',
    data: reportStatus
  });
});