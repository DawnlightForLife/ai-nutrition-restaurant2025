/**
 * Anti-duplicate submission middleware
 * Uses Redis caching mechanism to prevent duplicate submissions within a short time
 */

const cacheService = require('../../services/cache/cacheService');
const logger = require('../../config/modules/logger');
const crypto = require('crypto');

/**
 * Generate request unique identifier
 * @param {Object} req - Request object
 * @returns {String} Unique identifier
 */
function generateRequestKey(req) {
  const { method, path, params, body } = req;
  const userId = req.user?.id || 'anonymous';
  
  // Generate hash of request content
  const content = JSON.stringify({
    method,
    path,
    params,
    body: method === 'POST' || method === 'PUT' ? body : {}
  });
  
  const hash = crypto.createHash('md5').update(content).digest('hex');
  return `anti_duplicate:${userId}:${hash}`;
}

/**
 * Anti-duplicate submission middleware
 * @param {Object} options - Configuration options
 * @param {Number} options.windowMs - Time window (milliseconds)
 * @param {String} options.message - Error message
 */
function antiDuplicateSubmission(options = {}) {
  const {
    windowMs = 5000, // Default 5 seconds window
    message = 'Please do not submit repeatedly, try again later'
  } = options;

  return async (req, res, next) => {
    try {
      // Only check write operations for duplicates
      if (!['POST', 'PUT', 'PATCH', 'DELETE'].includes(req.method)) {
        return next();
      }

      const requestKey = generateRequestKey(req);
      
      // Check if request exists in cache
      const exists = await cacheService.get(requestKey);
      
      if (exists) {
        logger.warn('Duplicate submission detected', {
          userId: req.user?.id,
          method: req.method,
          path: req.path,
          ip: req.ip,
          userAgent: req.get('User-Agent')
        });
        
        return res.status(429).json({
          success: false,
          error: message,
          code: 'DUPLICATE_SUBMISSION'
        });
      }

      // Set request marker with expiration time
      await cacheService.set(requestKey, '1', Math.ceil(windowMs / 1000));
      
      // Clear marker on successful response
      const originalSend = res.send;
      res.send = function(data) {
        // Clear anti-duplicate marker on successful response
        if (res.statusCode >= 200 && res.statusCode < 300) {
          cacheService.del(requestKey).catch(err => {
            logger.error('Failed to clear anti-duplicate marker', { error: err.message, requestKey });
          });
        }
        return originalSend.call(this, data);
      };

      next();
      
    } catch (error) {
      logger.error('Anti-duplicate submission middleware error', {
        error: error.message,
        userId: req.user?.id,
        path: req.path
      });
      
      // Don't block normal requests if Redis fails
      next();
    }
  };
}

module.exports = {
  antiDuplicateSubmission
};