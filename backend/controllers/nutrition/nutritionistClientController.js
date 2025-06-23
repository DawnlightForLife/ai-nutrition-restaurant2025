/**
 * 营养师客户管理控制器
 * 处理营养师管理客户的所有请求
 * @module controllers/nutrition/nutritionistClientController
 */

const { nutritionistClientService } = require('../../services');
const catchAsync = require('../../utils/errors/catchAsync');
const logger = require('../../config/modules/logger');

/**
 * 获取营养师的客户列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含客户列表的JSON响应
 */
exports.getNutritionistClients = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  
  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看客户列表'
    });
  }

  const {
    status,
    tags,
    sortBy,
    sortOrder,
    limit = 20,
    page = 1,
    search
  } = req.query;

  const options = {
    status,
    tags: tags ? tags.split(',') : [],
    sortBy,
    sortOrder: sortOrder === 'asc' ? 1 : -1,
    limit: parseInt(limit),
    skip: (parseInt(page) - 1) * parseInt(limit),
    search
  };

  const result = await nutritionistClientService.getNutritionistClients(nutritionistId, options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取客户列表成功',
    data: result.data.clients,
    pagination: result.data.pagination
  });
});

/**
 * 获取客户详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含客户详情的JSON响应
 */
exports.getClientDetail = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看客户详情'
    });
  }

  const result = await nutritionistClientService.getClientDetail(nutritionistId, clientUserId);

  if (!result.success) {
    return res.status(404).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取客户详情成功',
    data: result.data
  });
});

/**
 * 添加客户
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含添加结果的JSON响应
 */
exports.addClient = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId, clientTags, nutritionistNotes, healthOverview } = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能添加客户'
    });
  }

  const clientData = {
    nutritionistId,
    clientUserId,
    clientTags,
    nutritionistNotes,
    healthOverview
  };

  const result = await nutritionistClientService.addClient(clientData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(201).json({
    success: true,
    message: '客户添加成功',
    data: result.data
  });
});

/**
 * 更新客户信息
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新结果的JSON响应
 */
exports.updateClientInfo = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;
  const updateData = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能更新客户信息'
    });
  }

  const result = await nutritionistClientService.updateClientInfo(nutritionistId, clientUserId, updateData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '客户信息更新成功',
    data: result.data
  });
});

/**
 * 添加客户进展记录
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含添加结果的JSON响应
 */
exports.addProgressEntry = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;
  const progressData = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能记录客户进展'
    });
  }

  const result = await nutritionistClientService.addProgressEntry(nutritionistId, clientUserId, progressData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(201).json({
    success: true,
    message: '进展记录添加成功',
    data: result.data
  });
});

/**
 * 设置客户目标
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含设置结果的JSON响应
 */
exports.setClientGoal = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;
  const goalData = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能设置客户目标'
    });
  }

  const result = await nutritionistClientService.setClientGoal(nutritionistId, clientUserId, goalData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(201).json({
    success: true,
    message: '客户目标设置成功',
    data: result.data
  });
});

/**
 * 更新目标进度
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新结果的JSON响应
 */
exports.updateGoalProgress = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId, goalId } = req.params;
  const { currentValue, notes } = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能更新目标进度'
    });
  }

  const result = await nutritionistClientService.updateGoalProgress(
    nutritionistId, 
    clientUserId, 
    goalId, 
    currentValue, 
    notes
  );

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '目标进度更新成功',
    data: result.data
  });
});

/**
 * 添加客户提醒
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含添加结果的JSON响应
 */
exports.addClientReminder = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;
  const reminderData = req.body;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能添加客户提醒'
    });
  }

  const result = await nutritionistClientService.addClientReminder(nutritionistId, clientUserId, reminderData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(201).json({
    success: true,
    message: '客户提醒添加成功',
    data: result.data
  });
});

/**
 * 完成客户提醒
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含完成结果的JSON响应
 */
exports.completeClientReminder = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId, reminderId } = req.params;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能完成客户提醒'
    });
  }

  const result = await nutritionistClientService.completeClientReminder(nutritionistId, clientUserId, reminderId);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '提醒完成成功',
    data: result.data
  });
});

/**
 * 获取客户统计数据
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含统计数据的JSON响应
 */
exports.getClientStats = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看客户统计'
    });
  }

  const result = await nutritionistClientService.getClientStats(nutritionistId);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取客户统计成功',
    data: result.data
  });
});

/**
 * 搜索潜在客户
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含搜索结果的JSON响应
 */
exports.searchPotentialClients = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { keyword, limit = 10 } = req.query;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能搜索潜在客户'
    });
  }

  const result = await nutritionistClientService.searchPotentialClients(nutritionistId, {
    keyword,
    limit: parseInt(limit)
  });

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '搜索潜在客户成功',
    data: result.data
  });
});

/**
 * 获取客户营养计划历史
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含营养计划历史的JSON响应
 */
exports.getClientNutritionPlanHistory = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const { clientUserId } = req.params;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看客户营养计划历史'
    });
  }

  const result = await nutritionistClientService.getClientNutritionPlanHistory(nutritionistId, clientUserId);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取营养计划历史成功',
    data: result.data
  });
});