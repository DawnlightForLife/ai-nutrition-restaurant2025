/**
 * 推荐控制器
 * 处理AI推荐相关的所有请求，包括个性化推荐、营养建议等
 * @module controllers/nutrition/aiRecommendationController
 */

// ✅ 命名统一（camelCase）
// ✅ 所有方法为 async 函数
// ✅ 返回结构统一：{ success, message, data? }
// ✅ 已实现用户权限校验（userId）
// ✅ 建议未来接入 AI 模型推理与推荐日志记录系统

const { aiRecommendationService } = require('../../services');
const catchAsync = require('../../utils/errors/catchAsync');

/**
 * 创建 AI 推荐
 * - 从 req.user 获取 userId，防止伪造
 * - 将请求体发送给推荐服务，生成个性化推荐
 * - 返回推荐创建结果
 */
exports.createAiRecommendation = catchAsync(async (req, res) => {
  const data = req.body;
  
  // 确保userId来自已认证的用户
  data.userId = req.user.id;
  
  const result = await aiRecommendationService.createRecommendation(data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(201).json({
    success: true,
    message: '推荐创建成功',
    data: result.data
  });
});

/**
 * 获取推荐列表
 * - 根据用户ID和查询参数获取推荐列表
 * - 支持分页和排序
 * - 返回推荐列表及分页信息
 */
exports.getAiRecommendationList = catchAsync(async (req, res) => {
  const userId = req.user.id;
  const { 
    recommendationType, 
    limit = 10, 
    skip = 0, 
    sortBy = 'createdAt', 
    sortOrder = -1
  } = req.query;
  
  const options = {
    recommendationType,
    limit: parseInt(limit),
    skip: parseInt(skip),
    sort: { [sortBy]: parseInt(sortOrder) }
  };
  
  const result = await aiRecommendationService.getRecommendationsByUserId(userId, options);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取推荐列表成功',
    data: result.data,
    pagination: result.pagination
  });
});

/**
 * 获取单个推荐详情
 * - 根据推荐ID获取推荐详情
 * - 验证用户权限，确保只能访问自己的推荐
 * - 返回推荐详情
 */
exports.getAiRecommendationById = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  const result = await aiRecommendationService.getRecommendationById(id);
  
  if (!result.success) {
    return res.status(404).json({
      success: false,
      message: result.message
    });
  }
  
  // 验证请求的用户是否有权访问此推荐
  if (result.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权访问此推荐'
    });
  }
  
  res.status(200).json({
    success: true,
    message: '获取推荐详情成功',
    data: result.data
  });
});

/**
 * 更新推荐
 * - 根据推荐ID更新推荐内容
 * - 验证用户权限，确保只能更新自己的推荐
 * - 保护固定字段不被修改
 * - 返回更新后的推荐
 */
// NOTE: 不允许更新以下字段（固定属性）
// - userId / createdAt / feedback[]
exports.updateAiRecommendation = catchAsync(async (req, res) => {
  const { id } = req.params;
  const data = req.body;
  
  // 获取现有推荐
  const existingRec = await aiRecommendationService.getRecommendationById(id);
  
  if (!existingRec.success) {
    return res.status(404).json({
      success: false,
      message: existingRec.message
    });
  }
  
  // 验证请求的用户是否有权更新此推荐
  if (existingRec.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权更新此推荐'
    });
  }
  
  // 不允许更新某些字段
  delete data.userId;
  delete data.createdAt;
  // feedback字段也不允许被更新
  delete data.feedback;
  
  const result = await aiRecommendationService.updateRecommendation(id, data);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '推荐更新成功',
    data: result.data
  });
});

/**
 * 删除推荐
 * - 根据推荐ID删除推荐
 * - 验证用户权限，确保只能删除自己的推荐
 * - 返回删除操作结果
 */
exports.deleteAiRecommendation = catchAsync(async (req, res) => {
  const { id } = req.params;
  
  // 获取现有推荐
  const existingRec = await aiRecommendationService.getRecommendationById(id);
  
  if (!existingRec.success) {
    return res.status(404).json({
      success: false,
      message: existingRec.message
    });
  }
  
  // 验证请求的用户是否有权删除此推荐
  if (existingRec.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权删除此推荐'
    });
  }
  
  const result = await aiRecommendationService.deleteRecommendation(id);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '推荐删除成功'
  });
});

/**
 * 提交推荐反馈
 * - 根据推荐ID提交用户反馈
 * - 验证用户权限，确保只能提交自己推荐的反馈
 * - 反馈只允许提交一次，后续覆盖更新（服务层判断）
// NOTE: 每条推荐只允许用户提交一次反馈，后续覆盖更新（由服务层判断）
 * - 返回更新后的推荐数据
 */
exports.submitFeedback = catchAsync(async (req, res) => {
  const { id } = req.params;
  const feedbackData = req.body;
  
  // 获取现有推荐
  const existingRec = await aiRecommendationService.getRecommendationById(id);
  
  if (!existingRec.success) {
    return res.status(404).json({
      success: false,
      message: existingRec.message
    });
  }
  
  // 验证请求的用户是否有权提交此推荐的反馈
  if (existingRec.data.userId.toString() !== req.user.id) {
    return res.status(403).json({
      success: false,
      message: '无权提交此推荐的反馈'
    });
  }
  
  const result = await aiRecommendationService.submitFeedback(id, feedbackData);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(200).json({
    success: true,
    message: '反馈提交成功',
    data: result.data
  });
});

/**
 * 根据营养档案ID生成AI推荐
 * - 根据营养档案ID获取用户营养信息
 * - 调用AI服务生成个性化推荐
 * - 返回生成的推荐数据
 */
exports.generateRecommendationByProfileId = catchAsync(async (req, res) => {
  const { profileId } = req.params;
  
  const result = await aiRecommendationService.generateRecommendationByProfileId(profileId);
  
  if (!result.success) {
    return res.status(400).json({
      success: false,
      message: result.message
    });
  }
  
  res.status(201).json({
    success: true,
    message: '推荐生成成功',
    data: result.data
  });
});
