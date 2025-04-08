/**
 * 模板控制器
 * 此模板演示了推荐的控制器实现方式，包含标准CRUD操作和常见功能
 * @module controllers/templates/controllerTemplate
 */

const xService = require('../../services/exampleService');
const { validateObjectId } = require('../../utils/validators');
const { asyncHandler } = require('../../middleware/core/errorHandlingMiddleware');
const { AppError } = require('../../utils/appError');
const { auditLog } = require('../../utils/auditLogger');

/**
 * 创建资源
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含新创建资源的JSON响应
 */
exports.createX = asyncHandler(async (req, res) => {
  // 1. 从请求体中提取数据
  const resourceData = req.body;
  
  // 2. 添加创建者ID（如果需要）
  resourceData.createdBy = req.user.id;
  
  // 3. 调用服务层处理业务逻辑
  const newResource = await xService.create(resourceData);
  
  // 4. 记录审计日志
  auditLog({
    action: 'CREATE',
    resourceType: 'X',
    resourceId: newResource._id,
    userId: req.user.id,
    details: `创建了新的X资源: ${newResource.name || newResource._id}`
  });
  
  // 5. 返回标准成功响应
  return res.status(201).json({
    success: true,
    data: newResource,
    message: '资源创建成功'
  });
});

/**
 * 获取资源列表
 * 支持分页、排序、筛选和搜索功能
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含资源列表的JSON响应
 */
exports.getXList = asyncHandler(async (req, res) => {
  // 1. 提取查询参数
  const {
    page = 1,
    limit = 10,
    sortBy = 'createdAt',
    sortOrder = 'desc',
    keyword,
    ...filters
  } = req.query;
  
  // 2. 构建查询选项
  const options = {
    page: parseInt(page, 10),
    limit: parseInt(limit, 10),
    sort: { [sortBy]: sortOrder === 'desc' ? -1 : 1 },
    keyword,
    filters
  };
  
  // 3. 调用服务层获取分页数据
  const result = await xService.findAll(options);
  
  // 4. 返回标准分页响应
  return res.json({
    success: true,
    data: result.items,
    pagination: {
      total: result.totalItems,
      pageSize: result.limit,
      currentPage: result.currentPage,
      totalPages: result.totalPages
    },
    message: '获取资源列表成功'
  });
});

/**
 * 获取单个资源详情
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含单个资源的JSON响应
 * @throws {AppError} 当资源不存在时抛出404错误
 */
exports.getXById = asyncHandler(async (req, res) => {
  // 1. 提取并验证资源ID
  const { id } = req.params;
  
  if (!validateObjectId(id)) {
    throw new AppError('无效的资源ID', 400, 'INVALID_ID');
  }
  
  // 2. 调用服务层获取资源详情
  const resource = await xService.findById(id);
  
  // 3. 检查资源是否存在
  if (!resource) {
    throw new AppError('未找到请求的资源', 404, 'NOT_FOUND');
  }
  
  // 4. 返回标准成功响应
  return res.json({
    success: true,
    data: resource,
    message: '获取资源详情成功'
  });
});

/**
 * 更新资源
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含更新后的资源的JSON响应
 * @throws {AppError} 当资源不存在时抛出404错误
 */
exports.updateX = asyncHandler(async (req, res) => {
  // 1. 提取并验证资源ID和更新数据
  const { id } = req.params;
  const updateData = req.body;
  
  if (!validateObjectId(id)) {
    throw new AppError('无效的资源ID', 400, 'INVALID_ID');
  }
  
  // 2. 添加更新元数据
  updateData.updatedBy = req.user.id;
  updateData.updatedAt = new Date();
  
  // 3. 调用服务层更新资源
  const updatedResource = await xService.update(id, updateData);
  
  // 4. 检查资源是否存在
  if (!updatedResource) {
    throw new AppError('未找到请求的资源', 404, 'NOT_FOUND');
  }
  
  // 5. 记录审计日志
  auditLog({
    action: 'UPDATE',
    resourceType: 'X',
    resourceId: id,
    userId: req.user.id,
    details: `更新了X资源: ${updatedResource.name || id}`
  });
  
  // 6. 返回标准成功响应
  return res.json({
    success: true,
    data: updatedResource,
    message: '资源更新成功'
  });
});

/**
 * 删除资源
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含操作结果的JSON响应
 * @throws {AppError} 当资源不存在时抛出404错误
 */
exports.deleteX = asyncHandler(async (req, res) => {
  // 1. 提取并验证资源ID
  const { id } = req.params;
  
  if (!validateObjectId(id)) {
    throw new AppError('无效的资源ID', 400, 'INVALID_ID');
  }
  
  // 2. 调用服务层删除资源
  const result = await xService.remove(id);
  
  // 3. 检查资源是否存在
  if (!result) {
    throw new AppError('未找到请求的资源', 404, 'NOT_FOUND');
  }
  
  // 4. 记录审计日志
  auditLog({
    action: 'DELETE',
    resourceType: 'X',
    resourceId: id,
    userId: req.user.id,
    details: `删除了X资源: ${id}`
  });
  
  // 5. 返回标准成功响应
  return res.json({
    success: true,
    message: '资源删除成功'
  });
});

/**
 * 获取资源统计信息
 * 示例自定义控制器方法
 * @async
 * @param {Object} req - Express请求对象
 * @param {Object} res - Express响应对象
 * @returns {Object} 包含统计数据的JSON响应
 */
exports.getXStats = asyncHandler(async (req, res) => {
  // 1. 提取查询参数
  const { startDate, endDate } = req.query;
  
  // 2. 调用服务层获取统计数据
  const stats = await xService.getStats({
    startDate,
    endDate,
    userId: req.user.id
  });
  
  // 3. 返回标准成功响应
  return res.json({
    success: true,
    data: stats,
    message: '获取统计数据成功'
  });
}); 