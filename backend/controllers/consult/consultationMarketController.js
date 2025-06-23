/**
 * 咨询市场控制器
 * 处理营养师查看和接受咨询市场的请求
 * @module controllers/consult/consultationMarketController
 */

// Use optimized service if available, fallback to original
const consultationMarketService = (() => {
  try {
    return require('../../services/consult/consultationMarketServiceOptimized');
  } catch (e) {
    return require('../../services').consultationMarketService;
  }
})();
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 获取咨询市场列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含市场咨询列表的JSON响应
 */
exports.getMarketConsultations = catchAsync(async (req, res) => {
  const {
    consultationType,
    priority,
    tags,
    minBudget,
    maxBudget,
    limit = 20,
    page = 1
  } = req.query;

  // 获取当前营养师的专业领域（用于匹配）
  const nutritionistId = req.user.nutritionistId;
  let nutritionistSpecializations = [];
  
  if (nutritionistId) {
    const nutritionist = await require('../../models/nutrition/nutritionistModel').findById(nutritionistId);
    if (nutritionist) {
      nutritionistSpecializations = nutritionist.professionalInfo.specializations || [];
    }
  }

  const options = {
    nutritionistSpecializations,
    consultationType,
    priority,
    tags: tags ? tags.split(',') : [],
    minBudget: minBudget ? parseFloat(minBudget) : null,
    maxBudget: maxBudget ? parseFloat(maxBudget) : null,
    limit: parseInt(limit),
    skip: (parseInt(page) - 1) * parseInt(limit)
  };

  const result = await consultationMarketService.getMarketConsultations(options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取咨询市场列表成功',
    data: result.data.consultations,
    pagination: result.data.pagination
  });
});

/**
 * 获取咨询市场统计数据
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含市场统计的JSON响应
 */
exports.getMarketStats = catchAsync(async (req, res) => {
  const result = await consultationMarketService.getMarketStats();

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取市场统计成功',
    data: result.data
  });
});

/**
 * 营养师接受咨询
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含接受结果的JSON响应
 */
exports.acceptConsultation = catchAsync(async (req, res) => {
  const { consultationId } = req.params;
  const nutritionistId = req.user.nutritionistId;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能接受咨询'
    });
  }

  const result = await consultationMarketService.acceptConsultation(consultationId, nutritionistId);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '成功接受咨询',
    data: result.data
  });
});

/**
 * 获取营养师接受的咨询列表
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含营养师咨询列表的JSON响应
 */
exports.getNutritionistConsultations = catchAsync(async (req, res) => {
  const nutritionistId = req.user.nutritionistId;
  const {
    status,
    limit = 10,
    page = 1
  } = req.query;

  if (!nutritionistId) {
    return res.status(403).json({
      success: false,
      message: '只有认证营养师才能查看咨询列表'
    });
  }

  const options = {
    status,
    limit: parseInt(limit),
    skip: (parseInt(page) - 1) * parseInt(limit)
  };

  const result = await consultationMarketService.getNutritionistConsultations(nutritionistId, options);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取营养师咨询列表成功',
    data: result.data.consultations,
    pagination: result.data.pagination
  });
});

/**
 * 发布咨询到市场（用户操作）
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含发布结果的JSON响应
 */
exports.publishConsultationToMarket = catchAsync(async (req, res) => {
  const { consultationId } = req.params;
  const userId = req.user.id;

  const result = await consultationMarketService.publishConsultationToMarket(consultationId, userId);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '咨询已发布到市场',
    data: result.data
  });
});

/**
 * 创建咨询请求并发布到市场
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含创建结果的JSON响应
 */
exports.createMarketConsultation = catchAsync(async (req, res) => {
  const {
    topic,
    description,
    consultationType,
    priority,
    tags,
    expectedDuration,
    budget
  } = req.body;

  const consultationData = {
    userId: req.user.id,
    topic,
    description,
    consultationType,
    priority,
    tags,
    expectedDuration,
    budget,
    isMarketOpen: true,
    status: 'available',
    marketPublishedAt: new Date()
  };

  const result = await consultationMarketService.createMarketConsultation(consultationData);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(201).json({
    success: true,
    message: '咨询请求已创建并发布到市场',
    data: result.data
  });
});

/**
 * 获取咨询详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含咨询详情的JSON响应
 */
exports.getConsultationDetail = catchAsync(async (req, res) => {
  const { consultationId } = req.params;
  const userId = req.user.id;
  const nutritionistId = req.user.nutritionistId;

  const result = await consultationMarketService.getConsultationDetail(consultationId, {
    userId,
    nutritionistId
  });

  if (!result.success) {
    return res.status(404).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '获取咨询详情成功',
    data: result.data
  });
});

/**
 * 搜索咨询市场
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含搜索结果的JSON响应
 */
exports.searchMarketConsultations = catchAsync(async (req, res) => {
  const {
    keyword,
    consultationType,
    priority,
    tags,
    minBudget,
    maxBudget,
    sortBy = 'marketPublishedAt',
    sortOrder = 'desc',
    limit = 20,
    page = 1
  } = req.query;

  const nutritionistId = req.user.nutritionistId;
  let nutritionistSpecializations = [];
  
  if (nutritionistId) {
    const nutritionist = await require('../../models/nutrition/nutritionistModel').findById(nutritionistId);
    if (nutritionist) {
      nutritionistSpecializations = nutritionist.professionalInfo.specializations || [];
    }
  }

  const searchOptions = {
    keyword,
    nutritionistSpecializations,
    consultationType,
    priority,
    tags: tags ? tags.split(',') : [],
    minBudget: minBudget ? parseFloat(minBudget) : null,
    maxBudget: maxBudget ? parseFloat(maxBudget) : null,
    sortBy,
    sortOrder,
    limit: parseInt(limit),
    skip: (parseInt(page) - 1) * parseInt(limit)
  };

  const result = await consultationMarketService.searchMarketConsultations(searchOptions);

  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }

  res.status(200).json({
    success: true,
    message: '搜索咨询市场成功',
    data: result.data.consultations,
    pagination: result.data.pagination
  });
});