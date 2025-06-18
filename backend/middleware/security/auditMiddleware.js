/**
 * 安全审计中间件
 * 记录敏感操作和权限验证失败事件
 */

const fs = require('fs').promises;
const path = require('path');

// 审计日志级别
const AUDIT_LEVELS = {
  INFO: 'INFO',
  WARNING: 'WARNING',
  ERROR: 'ERROR',
  CRITICAL: 'CRITICAL'
};

// 敏感操作类型
const SENSITIVE_OPERATIONS = {
  LOGIN: 'LOGIN',
  LOGOUT: 'LOGOUT',
  PERMISSION_DENIED: 'PERMISSION_DENIED',
  DATA_ACCESS: 'DATA_ACCESS',
  USER_MANAGEMENT: 'USER_MANAGEMENT',
  SYSTEM_CONFIG: 'SYSTEM_CONFIG',
  FINANCIAL: 'FINANCIAL'
};

class AuditLogger {
  constructor() {
    this.logDir = path.join(__dirname, '../../logs/audit');
    this.initializeLogDirectory();
  }

  async initializeLogDirectory() {
    try {
      await fs.mkdir(this.logDir, { recursive: true });
    } catch (error) {
      console.error('创建审计日志目录失败:', error);
    }
  }

  /**
   * 记录审计日志
   * @param {Object} auditData - 审计数据
   */
  async log(auditData) {
    const logEntry = {
      timestamp: new Date().toISOString(),
      ...auditData
    };

    // 生成日志文件名（按日期分割）
    const today = new Date().toISOString().split('T')[0];
    const logFile = path.join(this.logDir, `audit-${today}.log`);

    try {
      await fs.appendFile(logFile, JSON.stringify(logEntry) + '\n');
    } catch (error) {
      console.error('写入审计日志失败:', error);
    }

    // 对于严重事件，同时记录到控制台
    if (auditData.level === AUDIT_LEVELS.CRITICAL || auditData.level === AUDIT_LEVELS.ERROR) {
      console.warn('🚨 安全审计:', logEntry);
    }
  }

  /**
   * 记录权限验证失败
   */
  async logPermissionDenied(req, requiredPermissions, userPermissions) {
    await this.log({
      level: AUDIT_LEVELS.WARNING,
      operation: SENSITIVE_OPERATIONS.PERMISSION_DENIED,
      userId: req.user?._id?.toString(),
      userRole: req.user?.role,
      requiredPermissions,
      userPermissions,
      path: req.path,
      method: req.method,
      ip: req.ip || req.connection?.remoteAddress,
      userAgent: req.get('User-Agent'),
      sessionId: req.sessionID
    });
  }

  /**
   * 记录登录事件
   */
  async logLogin(userId, role, ip, userAgent, success = true) {
    await this.log({
      level: success ? AUDIT_LEVELS.INFO : AUDIT_LEVELS.WARNING,
      operation: SENSITIVE_OPERATIONS.LOGIN,
      userId: userId?.toString(),
      userRole: role,
      success,
      ip,
      userAgent
    });
  }

  /**
   * 记录数据访问
   */
  async logDataAccess(req, resourceType, resourceId, action) {
    await this.log({
      level: AUDIT_LEVELS.INFO,
      operation: SENSITIVE_OPERATIONS.DATA_ACCESS,
      userId: req.user?._id?.toString(),
      userRole: req.user?.role,
      resourceType,
      resourceId,
      action,
      path: req.path,
      method: req.method,
      ip: req.ip || req.connection?.remoteAddress
    });
  }

  /**
   * 记录用户管理操作
   */
  async logUserManagement(req, action, targetUserId, details) {
    await this.log({
      level: AUDIT_LEVELS.WARNING,
      operation: SENSITIVE_OPERATIONS.USER_MANAGEMENT,
      userId: req.user?._id?.toString(),
      userRole: req.user?.role,
      action,
      targetUserId: targetUserId?.toString(),
      details,
      ip: req.ip || req.connection?.remoteAddress
    });
  }

  /**
   * 记录系统配置变更
   */
  async logSystemConfig(req, configKey, oldValue, newValue) {
    await this.log({
      level: AUDIT_LEVELS.CRITICAL,
      operation: SENSITIVE_OPERATIONS.SYSTEM_CONFIG,
      userId: req.user?._id?.toString(),
      userRole: req.user?.role,
      configKey,
      oldValue,
      newValue,
      ip: req.ip || req.connection?.remoteAddress
    });
  }

  /**
   * 记录财务相关操作
   */
  async logFinancialOperation(req, operation, amount, orderId, details) {
    await this.log({
      level: AUDIT_LEVELS.WARNING,
      operation: SENSITIVE_OPERATIONS.FINANCIAL,
      userId: req.user?._id?.toString(),
      userRole: req.user?.role,
      financialOperation: operation,
      amount,
      orderId: orderId?.toString(),
      details,
      ip: req.ip || req.connection?.remoteAddress
    });
  }
}

// 创建审计日志实例
const auditLogger = new AuditLogger();

/**
 * 审计中间件工厂
 * @param {string} operation - 操作类型
 * @param {Object} options - 配置选项
 */
const createAuditMiddleware = (operation, options = {}) => {
  return async (req, res, next) => {
    // 记录请求开始时间
    req.auditStartTime = Date.now();
    req.auditOperation = operation;

    // 拦截响应以记录结果
    const originalSend = res.send;
    res.send = function(data) {
      // 记录响应时间
      const responseTime = Date.now() - req.auditStartTime;
      
      // 异步记录审计日志
      setImmediate(() => {
        auditLogger.logDataAccess(
          req,
          options.resourceType || 'unknown',
          req.params.id || req.params.dishId || req.params.orderId,
          operation
        );
      });

      return originalSend.call(this, data);
    };

    next();
  };
};

/**
 * 敏感路由审计中间件
 */
const sensitiveRouteAudit = (resourceType) => {
  return createAuditMiddleware('access', { resourceType });
};

/**
 * 权限验证失败审计中间件
 */
const permissionDeniedAudit = (requiredPermissions, userPermissions) => {
  return async (req, res, next) => {
    await auditLogger.logPermissionDenied(req, requiredPermissions, userPermissions);
    next();
  };
};

module.exports = {
  auditLogger,
  createAuditMiddleware,
  sensitiveRouteAudit,
  permissionDeniedAudit,
  AUDIT_LEVELS,
  SENSITIVE_OPERATIONS
};