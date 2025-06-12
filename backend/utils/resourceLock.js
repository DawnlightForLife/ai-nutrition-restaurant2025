/**
 * Distributed resource locking utility using cache service
 * Prevents concurrent modifications of the same resource
 */

const cacheService = require('../services/cache/cacheService');
// Graceful logger handling
let logger;
try {
  logger = require('../config/modules/logger');
} catch (err) {
  logger = {
    debug: console.log,
    info: console.log,
    warn: console.warn,
    error: console.error
  };
}

class ResourceLock {
  constructor() {
    this.lockPrefix = 'resource_lock';
    this.defaultTTL = 30; // 30 seconds default lock timeout
  }

  /**
   * Acquire a lock for a resource
   * @param {String} resourceId - Unique resource identifier
   * @param {Object} options - Lock options
   * @param {Number} options.ttl - Lock timeout in seconds
   * @param {String} options.lockId - Unique lock identifier
   * @returns {Object} Lock result with success status and lockId
   */
  async acquire(resourceId, options = {}) {
    const {
      ttl = this.defaultTTL,
      lockId = `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`
    } = options;

    try {
      const lockKey = `${this.lockPrefix}:${resourceId}`;
      
      // Check if lock already exists
      const existingLock = await cacheService.get(lockKey);
      
      if (existingLock) {
        logger.debug('Resource lock already exists', { resourceId, existingLockId: existingLock.lockId });
        return {
          success: false,
          lockId: null,
          message: 'Resource is currently locked by another process'
        };
      }

      // Acquire lock
      const lockData = {
        lockId,
        resourceId,
        acquiredAt: new Date().toISOString(),
        ttl
      };

      await cacheService.set(lockKey, lockData, ttl);
      
      logger.debug('Resource lock acquired', { resourceId, lockId, ttl });
      
      return {
        success: true,
        lockId,
        message: 'Lock acquired successfully'
      };

    } catch (error) {
      logger.error('Failed to acquire resource lock', { 
        error: error.message, 
        resourceId, 
        lockId 
      });
      
      return {
        success: false,
        lockId: null,
        message: 'Failed to acquire lock due to system error'
      };
    }
  }

  /**
   * Release a lock for a resource
   * @param {String} resourceId - Resource identifier
   * @param {String} lockId - Lock identifier to verify ownership
   * @returns {Object} Release result
   */
  async release(resourceId, lockId) {
    try {
      const lockKey = `${this.lockPrefix}:${resourceId}`;
      
      // Verify lock ownership
      const existingLock = await cacheService.get(lockKey);
      
      if (!existingLock) {
        logger.debug('Lock not found or already expired', { resourceId, lockId });
        return {
          success: true,
          message: 'Lock not found or already expired'
        };
      }

      if (existingLock.lockId !== lockId) {
        logger.warn('Lock ownership verification failed', { 
          resourceId, 
          providedLockId: lockId, 
          actualLockId: existingLock.lockId 
        });
        return {
          success: false,
          message: 'Lock ownership verification failed'
        };
      }

      // Release lock
      await cacheService.delete(lockKey);
      
      logger.debug('Resource lock released', { resourceId, lockId });
      
      return {
        success: true,
        message: 'Lock released successfully'
      };

    } catch (error) {
      logger.error('Failed to release resource lock', { 
        error: error.message, 
        resourceId, 
        lockId 
      });
      
      return {
        success: false,
        message: 'Failed to release lock due to system error'
      };
    }
  }

  /**
   * Extend lock timeout
   * @param {String} resourceId - Resource identifier
   * @param {String} lockId - Lock identifier
   * @param {Number} additionalTTL - Additional time in seconds
   * @returns {Object} Extension result
   */
  async extend(resourceId, lockId, additionalTTL = 30) {
    try {
      const lockKey = `${this.lockPrefix}:${resourceId}`;
      
      // Verify lock ownership
      const existingLock = await cacheService.get(lockKey);
      
      if (!existingLock || existingLock.lockId !== lockId) {
        return {
          success: false,
          message: 'Lock not found or ownership verification failed'
        };
      }

      // Extend lock
      const updatedLock = {
        ...existingLock,
        extendedAt: new Date().toISOString(),
        ttl: existingLock.ttl + additionalTTL
      };

      await cacheService.set(lockKey, updatedLock, updatedLock.ttl);
      
      logger.debug('Resource lock extended', { resourceId, lockId, additionalTTL });
      
      return {
        success: true,
        message: 'Lock extended successfully',
        newTTL: updatedLock.ttl
      };

    } catch (error) {
      logger.error('Failed to extend resource lock', { 
        error: error.message, 
        resourceId, 
        lockId 
      });
      
      return {
        success: false,
        message: 'Failed to extend lock due to system error'
      };
    }
  }

  /**
   * Check if a resource is locked
   * @param {String} resourceId - Resource identifier
   * @returns {Object} Lock status
   */
  async isLocked(resourceId) {
    try {
      const lockKey = `${this.lockPrefix}:${resourceId}`;
      const existingLock = await cacheService.get(lockKey);
      
      return {
        locked: !!existingLock,
        lockData: existingLock || null
      };
      
    } catch (error) {
      logger.error('Failed to check resource lock status', { 
        error: error.message, 
        resourceId 
      });
      
      return {
        locked: false,
        lockData: null
      };
    }
  }

  /**
   * Execute a function with automatic resource locking
   * @param {String} resourceId - Resource identifier
   * @param {Function} fn - Function to execute
   * @param {Object} options - Lock options
   * @returns {*} Function result
   */
  async withLock(resourceId, fn, options = {}) {
    const lockResult = await this.acquire(resourceId, options);
    
    if (!lockResult.success) {
      throw new Error(`Failed to acquire lock: ${lockResult.message}`);
    }

    try {
      const result = await fn();
      return result;
    } finally {
      await this.release(resourceId, lockResult.lockId);
    }
  }
}

// Export singleton instance
module.exports = new ResourceLock();