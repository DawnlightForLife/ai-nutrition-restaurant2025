/**
 * Audit logging middleware for security-sensitive operations
 * Logs detailed information about user actions for compliance and security monitoring
 */

const cacheService = require('../../services/cache/cacheService');
const logger = require('../../config/modules/logger');
const AuditLogModel = require('../../models/core/auditLogModel');

/**
 * Audit log middleware
 * @param {Object} options - Configuration options
 * @param {Array} options.sensitiveFields - Fields to mask in logs
 * @param {Boolean} options.logRequestBody - Whether to log request body
 * @param {Boolean} options.logResponseBody - Whether to log response body
 */
function auditLogMiddleware(options = {}) {
  const {
    sensitiveFields = ['password', 'token', 'idNumber', 'phone'],
    logRequestBody = true,
    logResponseBody = false
  } = options;

  return async (req, res, next) => {
    const startTime = Date.now();
    
    // Extract user information
    const userId = req.user?.id || req.user?._id;
    const userRole = req.user?.role;
    
    // Prepare audit data
    const auditData = {
      userId,
      userRole,
      action: `${req.method} ${req.path}`,
      resource: req.path,
      timestamp: new Date(),
      ip: req.ip || req.connection.remoteAddress,
      userAgent: req.get('User-Agent'),
      sessionId: req.session?.id,
      requestId: req.id || `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    };

    // Mask sensitive data in request body
    if (logRequestBody && req.body) {
      auditData.requestData = maskSensitiveData(req.body, sensitiveFields);
    }

    // Capture response data
    const originalSend = res.send;
    res.send = function(data) {
      const duration = Date.now() - startTime;
      
      // Complete audit log
      auditData.statusCode = res.statusCode;
      auditData.duration = duration;
      auditData.success = res.statusCode >= 200 && res.statusCode < 400;
      
      if (logResponseBody && data) {
        try {
          const responseData = typeof data === 'string' ? JSON.parse(data) : data;
          auditData.responseData = maskSensitiveData(responseData, sensitiveFields);
        } catch (err) {
          // If response is not JSON, just log the type
          auditData.responseType = typeof data;
        }
      }

      // Log to database asynchronously
      saveAuditLog(auditData).catch(err => {
        logger.error('Failed to save audit log', { error: err.message, auditData });
      });

      return originalSend.call(this, data);
    };

    next();
  };
}

/**
 * Mask sensitive data in objects
 * @param {Object} data - Data to mask
 * @param {Array} sensitiveFields - Fields to mask
 * @returns {Object} Masked data
 */
function maskSensitiveData(data, sensitiveFields) {
  if (!data || typeof data !== 'object') {
    return data;
  }

  const masked = JSON.parse(JSON.stringify(data));
  
  function maskRecursive(obj) {
    for (const key in obj) {
      if (obj.hasOwnProperty(key)) {
        if (sensitiveFields.some(field => key.toLowerCase().includes(field.toLowerCase()))) {
          if (typeof obj[key] === 'string') {
            obj[key] = '*'.repeat(Math.min(obj[key].length, 8));
          } else {
            obj[key] = '[MASKED]';
          }
        } else if (typeof obj[key] === 'object' && obj[key] !== null) {
          maskRecursive(obj[key]);
        }
      }
    }
  }

  maskRecursive(masked);
  return masked;
}

/**
 * Save audit log to database
 * @param {Object} auditData - Audit data to save
 */
async function saveAuditLog(auditData) {
  try {
    // Try to save to database
    await AuditLogModel.create(auditData);
    
    // Also cache critical audit events for quick access
    if (auditData.action.includes('certification') || 
        auditData.action.includes('approval') ||
        auditData.statusCode >= 400) {
      
      const cacheKey = `audit:critical:${auditData.requestId}`;
      await cacheService.set(cacheKey, auditData, 3600); // Cache for 1 hour
    }
    
  } catch (error) {
    logger.error('Failed to save audit log', { 
      error: error.message, 
      auditData: {
        ...auditData,
        requestData: '[TRUNCATED]',
        responseData: '[TRUNCATED]'
      }
    });
    
    // Fallback: at least log to file
    logger.info('Audit event', auditData);
  }
}

/**
 * Get recent audit logs for a user
 * @param {String} userId - User ID
 * @param {Number} limit - Number of logs to retrieve
 * @returns {Array} Recent audit logs
 */
async function getRecentAuditLogs(userId, limit = 10) {
  try {
    // Try cache first
    const cacheKey = `audit:recent:${userId}`;
    let logs = await cacheService.get(cacheKey);
    
    if (!logs) {
      // Fetch from database
      logs = await AuditLogModel.find({ userId })
        .sort({ timestamp: -1 })
        .limit(limit)
        .lean();
      
      // Cache for 5 minutes
      await cacheService.set(cacheKey, logs, 300);
    }
    
    return logs;
  } catch (error) {
    logger.error('Failed to get recent audit logs', { error: error.message, userId });
    return [];
  }
}

module.exports = {
  auditLogMiddleware,
  getRecentAuditLogs,
  maskSensitiveData
};