/**
 * 审计日志服务
 * 提供系统操作日志记录和查询功能
 * @module services/audit/auditLogService
 */
const AuditLog = require('../../models/misc/auditLogModel');

/**
 * 记录审计日志
 * @async
 * @param {Object} logData - 日志数据
 * @param {string} logData.action - 操作类型
 * @param {string} logData.entity_type - 实体类型
 * @param {string} logData.entity_id - 实体ID
 * @param {string} logData.user_id - 用户ID
 * @param {string} [logData.admin_id] - 管理员ID（如果适用）
 * @param {Object} [logData.details] - 详细信息
 * @param {string} [logData.ip_address] - IP地址
 * @returns {Promise<Object>} 创建的日志对象
 * @throws {Error} 如果创建失败
 */
const createLog = async (logData) => {
  try {
    // 验证必填字段
    const requiredFields = ['action', 'entity_type', 'entity_id'];
    for (const field of requiredFields) {
      if (!logData[field]) {
        const error = new Error(`缺少必填字段: ${field}`);
        error.statusCode = 400;
        throw error;
      }
    }
    
    // 确保至少有user_id或admin_id
    if (!logData.user_id && !logData.admin_id) {
      const error = new Error('必须提供user_id或admin_id');
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
    if (filters.entity_type) query.entity_type = filters.entity_type;
    if (filters.entity_id) query.entity_id = filters.entity_id;
    if (filters.user_id) query.user_id = filters.user_id;
    if (filters.admin_id) query.admin_id = filters.admin_id;
    
    // 时间范围筛选
    if (filters.start_date || filters.end_date) {
      query.timestamp = {};
      if (filters.start_date) {
        query.timestamp.$gte = new Date(filters.start_date);
      }
      if (filters.end_date) {
        const endDate = new Date(filters.end_date);
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
        { path: 'user_id', select: 'nickname phone email role' },
        { path: 'admin_id', select: 'nickname phone email role' }
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
        { user_id: userId },
        { admin_id: userId }
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
      entity_type: entityType,
      entity_id: entityId
    };
    
    // 执行查询
    const logs = await AuditLog.find(query)
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit)
      .populate([
        { path: 'user_id', select: 'nickname phone email role' },
        { path: 'admin_id', select: 'nickname phone email role' }
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
    if (filters.start_date || filters.end_date) {
      matchStage.timestamp = {};
      if (filters.start_date) {
        matchStage.timestamp.$gte = new Date(filters.start_date);
      }
      if (filters.end_date) {
        const endDate = new Date(filters.end_date);
        endDate.setDate(endDate.getDate() + 1);
        matchStage.timestamp.$lt = endDate;
      }
    }
    
    // 应用用户筛选
    if (filters.user_id) matchStage.user_id = filters.user_id;
    if (filters.admin_id) matchStage.admin_id = filters.admin_id;
    
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
          _id: '$entity_type',
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