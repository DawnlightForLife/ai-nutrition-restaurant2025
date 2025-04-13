/**
 * 营养档案控制器
 * 处理与用户营养档案相关的HTTP请求
 * @module controllers/health/nutritionProfileController
 */
const nutritionProfileService = require('../../services/health/nutritionProfileService');
const AppError = require('../../utils/appError');
const catchAsync = require('../../utils/catchAsync');

/**
 * 创建新的营养档案
 * @route POST /api/health/nutrition-profiles
 */
const createProfile = catchAsync(async (req, res) => {
  // 确保设置用户ID
  req.body.userId = req.user.id;
  
  const newProfile = await nutritionProfileService.createProfile(req.body);
  
  res.status(201).json({
    status: 'success',
    data: {
      profile: newProfile
    }
  });
});

/**
 * 获取当前用户的所有营养档案
 * @route GET /api/health/nutrition-profiles
 */
const getUserProfiles = catchAsync(async (req, res) => {
  const options = {
    limit: req.query.limit ? parseInt(req.query.limit) : undefined,
    page: req.query.page ? parseInt(req.query.page) : undefined,
    include_archived: req.query.include_archived === 'true',
    sort: req.query.sort_by ? getSortObject(req.query.sort_by) : undefined
  };
  
  const result = await nutritionProfileService.getUserProfiles(req.user.id, options);
  
  res.status(200).json({
    status: 'success',
    data: {
      profiles: result.profiles,
      pagination: result.pagination
    }
  });
});

/**
 * 获取当前用户的主营养档案
 * @route GET /api/health/nutrition-profiles/primary
 */
const getPrimaryProfile = catchAsync(async (req, res) => {
  const profile = await nutritionProfileService.getPrimaryProfile(req.user.id);
  
  if (!profile) {
    return res.status(204).send();
  }
  
  res.status(200).json({
    status: 'success',
    data: {
      profile
    }
  });
});

/**
 * 获取指定ID的营养档案
 * @route GET /api/health/nutrition-profiles/:id
 */
const getProfileById = catchAsync(async (req, res) => {
  const userId = req.headers['x-user-id'] || req.user?.id;
  const profileId = req.params.profileId;
  
  if (!userId) {
    throw new AppError('缺少用户ID', 400);
  }
  
  if (!profileId) {
    throw new AppError('缺少档案ID', 400);
  }
  
  const profile = await nutritionProfileService.getProfileById(profileId, userId);
  
  if (!profile) {
    throw new AppError('未找到指定的营养档案', 404);
  }
  
  // 检查是否有权访问该档案
  if (profile.userId.toString() !== userId) {
    throw new AppError('您无权访问此营养档案', 403);
  }
  
  res.status(200).json({
    status: 'success',
    data: profile
  });
});

/**
 * 更新营养档案
 * @route PUT /api/health/nutrition-profiles/:id
 */
const updateProfile = catchAsync(async (req, res) => {
  const userId = req.headers['x-user-id'] || req.user?.id;
  const profileId = req.params.profileId;
  
  if (!userId) {
    throw new AppError('缺少用户ID', 400);
  }
  
  if (!profileId) {
    throw new AppError('缺少档案ID', 400);
  }
  
  // 首先检查档案是否属于当前用户
  const existingProfile = await nutritionProfileService.getProfileById(profileId, userId);
  
  if (!existingProfile) {
    throw new AppError('未找到指定的营养档案', 404);
  }
  
  if (existingProfile.userId.toString() !== userId) {
    throw new AppError('您无权更新此营养档案', 403);
  }
  
  const updatedProfile = await nutritionProfileService.updateProfile(
    profileId,
    req.body
  );
  
  res.status(200).json({
    status: 'success',
    data: {
      profile: updatedProfile
    }
  });
});

/**
 * 删除指定ID的营养档案
 * @route DELETE /api/health/nutrition-profiles/:profileId
 */
const deleteProfile = catchAsync(async (req, res) => {
  const userId = req.headers['x-user-id'] || req.user?.id;
  const profileId = req.params.profileId;
  
  if (!userId) {
    throw new AppError('缺少用户ID', 400);
  }
  
  if (!profileId) {
    throw new AppError('缺少档案ID', 400);
  }
  
  try {
    // 直接调用服务方法删除档案，传入profileId和userId
    await nutritionProfileService.deleteProfile(profileId, userId);
    
    // 返回204状态码表示成功但无内容返回
    res.status(204).send();
  } catch (error) {
    // 如果是自定义AppError则直接抛出，让全局错误处理器处理
    if (error instanceof AppError) {
      throw error;
    }
    
    // MongoDB Cast错误，通常是ID格式不正确
    if (error.name === 'CastError') {
      throw new AppError('档案ID格式无效', 400);
    }
    
    // 其他错误
    throw new AppError(`删除档案失败: ${error.message}`, 500);
  }
});

/**
 * 归档指定ID的营养档案（软删除）
 * @route PATCH /api/health/nutrition-profiles/:id/archive
 */
const archiveProfile = catchAsync(async (req, res) => {
  const userId = req.headers['x-user-id'] || req.user?.id;
  const profileId = req.params.profileId;
  
  if (!userId) {
    throw new AppError('缺少用户ID', 400);
  }
  
  if (!profileId) {
    throw new AppError('缺少档案ID', 400);
  }
  
  // 首先检查档案是否属于当前用户
  const existingProfile = await nutritionProfileService.getProfileById(profileId, userId);
  
  if (!existingProfile) {
    throw new AppError('未找到指定的营养档案', 404);
  }
  
  if (existingProfile.userId.toString() !== userId) {
    throw new AppError('您无权归档此营养档案', 403);
  }
  
  const archivedProfile = await nutritionProfileService.archiveProfile(profileId);
  
  res.status(200).json({
    status: 'success',
    data: {
      profile: archivedProfile
    }
  });
});

/**
 * 恢复指定ID的已归档营养档案
 * @route PATCH /api/health/nutrition-profiles/:id/restore
 */
const restoreProfile = catchAsync(async (req, res) => {
  const userId = req.headers['x-user-id'] || req.user?.id;
  const profileId = req.params.profileId;
  
  if (!userId) {
    throw new AppError('缺少用户ID', 400);
  }
  
  if (!profileId) {
    throw new AppError('缺少档案ID', 400);
  }
  
  // 首先检查档案是否属于当前用户
  const existingProfile = await nutritionProfileService.getProfileById(profileId, userId);
  
  if (!existingProfile) {
    throw new AppError('未找到指定的营养档案', 404);
  }
  
  if (existingProfile.userId.toString() !== userId) {
    throw new AppError('您无权恢复此营养档案', 403);
  }
  
  const restoredProfile = await nutritionProfileService.restoreProfile(profileId);
  
  res.status(200).json({
    status: 'success',
    data: {
      profile: restoredProfile
    }
  });
});

/**
 * 将排序字符串转换为排序对象
 * @param {String} sortString - 排序字符串，例如：'createdAt:desc'
 * @returns {Object} 排序对象，例如：{ createdAt: -1 }
 */
const getSortObject = (sortString) => {
  const [field, order] = sortString.split(':');
  const sortOrder = order && order.toLowerCase() === 'desc' ? -1 : 1;
  return { [field]: sortOrder };
};

module.exports = {
  createProfile,
  getUserProfiles,
  getPrimaryProfile,
  getProfileById,
  updateProfile,
  deleteProfile,
  archiveProfile,
  restoreProfile
};
