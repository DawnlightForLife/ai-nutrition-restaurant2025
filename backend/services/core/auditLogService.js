/**
 * 审计日志服务
 * 提供系统操作日志记录和查询功能
 * @module services/audit/auditLogService
 */
const AuditLog = require('../../models/core/auditLogModel');

/**
 * 记录审计日志
 * @async
 * @param {Object} logData - 日志数据
 * @param {string} logData.action - 操作类型
 * @param {string} logData.entityType - 实体类型
 * @param {string} logData.entityId - 实体ID
 * @param {string} logData.userId - 用户ID
 * @param {string} [logData.adminId] - 管理员ID（如果适用）
 * @param {Object} [logData.details] - 详细信息
 * @param {string} [logData.ip_address] - IP地址
 * @returns {Promise<Object>} 创建的日志对象
 * @throws {Error} 如果创建失败
 */
const createLog = async (logData) => {
  try {
    // 验证必填字段
    const requiredFields = ['action', 'entityType', 'entityId'];
    for (const field of requiredFields) {
      if (!logData[field]) {
        const error = new Error(`缺少必填字段: ${field}`);
        error.statusCode = 400;
        throw error;
      }
    }
    
    // 确保至少有userId或adminId
    if (!logData.userId && !logData.adminId) {
      const error = new Error('必须提供userId或adminId');
      error.statusCode = 400;
      throw error;
    }
    
    // 记录日志时间
    const now = new Date();
    
    // 创建审计日志
    const log = await AuditLog.create({
      ...logData,
      timestamp: now
    });
    
    return log;
  } catch (error) {
    if (!error.statusCode) {
      error.statusCode = 500;
      error.message = '创建审计日志失败';
    }
    throw error;
  }
};

/**
 * 获取审计日志列表
 * @async
 * @param {Object} filters - 筛选条件
 * @param {Object} pagination - 分页信息
 * @returns {Promise<Object>} 分页日志列表和总数
 * @throws {Error} 如果查询失败
 */
const getLogs = async (filters = {}, pagination = {}) => {
  try {
    const { page = 1, limit = 50 } = pagination;
    const skip = (page - 1) * limit;
    
    // 构建查询条件
    const query = {};
    
    if (filters.action) query.action = filters.action;
    if (filters.entityType) query.entityType = filters.entityType;
    if (filters.entityId) query.entityId = filters.entityId;
    if (filters.userId) query.userId = filters.userId;
    if (filters.adminId) query.adminId = filters.adminId;
    
    // 时间范围筛选
    if (filters.startDate || filters.endDate) {
      query.timestamp = {};
      if (filters.startDate) {
        query.timestamp.$gte = new Date(filters.startDate);
      }
      if (filters.endDate) {
        const endDate = new Date(filters.endDate);
        endDate.setDate(endDate.getDate() + 1); // 包含结束日期当天
        query.timestamp.$lt = endDate;
      }
    }
    
    // 执行查询
    const logs = await AuditLog.find(query)
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit)
      .populate([
        { path: 'userId', select: 'nickname phone email role' },
        { path: 'adminId', select: 'nickname phone email role' }
      ]);
    
    const total = await AuditLog.countDocuments(query);
    
    return {
      logs,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit)
      }
    };
  } catch (error) {
    const customError = new Error('获取审计日志失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 获取用户操作历史
 * @async
 * @param {string} userId - 用户ID
 * @param {Object} pagination - 分页信息
 * @returns {Promise<Object>} 用户操作日志列表
 * @throws {Error} 如果查询失败
 */
const getUserActivityHistory = async (userId, pagination = {}) => {
  try {
    const { page = 1, limit = 20 } = pagination;
    const skip = (page - 1) * limit;
    
    // 查询条件：用户ID或管理员ID匹配
    const query = {
      $or: [
        { userId: userId },
        { adminId: userId }
      ]
    };
    
    // 执行查询
    const logs = await AuditLog.find(query)
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit);
    
    const total = await AuditLog.countDocuments(query);
    
    return {
      logs,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit)
      }
    };
  } catch (error) {
    const customError = new Error('获取用户操作历史失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 获取实体操作历史
 * @async
 * @param {string} entityType - 实体类型
 * @param {string} entityId - 实体ID
 * @param {Object} pagination - 分页信息
 * @returns {Promise<Object>} 实体操作日志列表
 * @throws {Error} 如果查询失败
 */
const getEntityHistory = async (entityType, entityId, pagination = {}) => {
  try {
    const { page = 1, limit = 20 } = pagination;
    const skip = (page - 1) * limit;
    
    // 查询条件：实体类型和ID
    const query = {
      entityType: entityType,
      entityId: entityId
    };
    
    // 执行查询
    const logs = await AuditLog.find(query)
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit)
      .populate([
        { path: 'userId', select: 'nickname phone email role' },
        { path: 'adminId', select: 'nickname phone email role' }
      ]);
    
    const total = await AuditLog.countDocuments(query);
    
    return {
      logs,
      pagination: {
        total,
        page,
        limit,
        pages: Math.ceil(total / limit)
      }
    };
  } catch (error) {
    const customError = new Error('获取实体操作历史失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 删除过期日志
 * @async
 * @param {number} days - 日志保留天数
 * @returns {Promise<number>} 删除的日志数量
 * @throws {Error} 如果删除失败
 */
const cleanupOldLogs = async (days = 90) => {
  try {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);
    
    const result = await AuditLog.deleteMany({
      timestamp: { $lt: cutoffDate }
    });
    
    return result.deletedCount;
  } catch (error) {
    const customError = new Error('清理旧日志失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

/**
 * 获取操作统计信息
 * @async
 * @param {Object} filters - 筛选条件
 * @returns {Promise<Object>} 操作统计数据
 * @throws {Error} 如果查询失败
 */
const getActionStats = async (filters = {}) => {
  try {
    const matchStage = {};
    
    // 应用时间范围筛选
    if (filters.startDate || filters.endDate) {
      matchStage.timestamp = {};
      if (filters.startDate) {
        matchStage.timestamp.$gte = new Date(filters.startDate);
      }
      if (filters.endDate) {
        const endDate = new Date(filters.endDate);
        endDate.setDate(endDate.getDate() + 1);
        matchStage.timestamp.$lt = endDate;
      }
    }
    
    // 应用用户筛选
    if (filters.userId) matchStage.userId = filters.userId;
    if (filters.adminId) matchStage.adminId = filters.adminId;
    
    // 执行聚合查询
    const actionStats = await AuditLog.aggregate([
      { $match: matchStage },
      { $group: {
          _id: '$action',
          count: { $sum: 1 }
        }
      },
      { $sort: { count: -1 } }
    ]);
    
    const entityStats = await AuditLog.aggregate([
      { $match: matchStage },
      { $group: {
          _id: '$entityType',
          count: { $sum: 1 }
        }
      },
      { $sort: { count: -1 } }
    ]);
    
    // 按天统计
    const dailyStats = await AuditLog.aggregate([
      { $match: matchStage },
      { $group: {
          _id: {
            year: { $year: '$timestamp' },
            month: { $month: '$timestamp' },
            day: { $dayOfMonth: '$timestamp' }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { '_id.year': 1, '_id.month': 1, '_id.day': 1 } },
      { $project: {
          _id: 0,
          date: {
            $dateFromParts: {
              year: '$_id.year',
              month: '$_id.month',
              day: '$_id.day'
            }
          },
          count: 1
        }
      }
    ]);
    
    return {
      actions: actionStats,
      entities: entityStats,
      daily: dailyStats
    };
  } catch (error) {
    const customError = new Error('获取操作统计失败');
    customError.statusCode = 500;
    customError.originalError = error;
    throw customError;
  }
};

module.exports = {
  createLog,
  getLogs,
  getUserActivityHistory,
  getEntityHistory,
  cleanupOldLogs,
  getActionStats
}; 