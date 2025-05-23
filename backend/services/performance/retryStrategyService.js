/**
 * 请求重试服务模块（RetryStrategyService）
 * 提供支持多种退避策略的可配置请求重试机制
 * 内置多种策略：固定、线性、指数、随机、装饰器抖动
 * 集成操作统计、事件通知、失败记录等功能，适用于数据库、HTTP 请求、服务间通信等场景
 * 可通过 executeWithRetry / executeDbRead / executeHttpRequest / executeServiceCall 选择合适策略
 * @module services/core/retryStrategyService
 */

const EventEmitter = require('events');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

/**
 * 退避策略枚举
 * @enum {string}
 */
const BackoffStrategy = {
  // 固定延迟
  FIXED: 'FIXED',
  
  // 线性递增延迟
  LINEAR: 'LINEAR',
  
  // 指数递增延迟
  EXPONENTIAL: 'EXPONENTIAL',
  
  // 随机递增延迟
  RANDOM: 'RANDOM',
  
  // 装饰器随机指数递增（推荐用于并发场景）
  DECORRELATED_JITTER: 'DECORRELATED_JITTER'
};

class RetryStrategyService extends EventEmitter {
  constructor() {
    super();
    
    // 默认配置
    this.config = {
      enabled: config.network?.enableRetryStrategy || true,
      defaultMaxRetries: config.network?.defaultMaxRetries || 3,
      defaultBackoffStrategy: config.network?.defaultBackoffStrategy || BackoffStrategy.EXPONENTIAL,
      defaultInitialDelayMs: config.network?.defaultInitialDelayMs || 100,
      defaultMaxDelayMs: config.network?.defaultMaxDelayMs || 10000,
      defaultBackoffFactor: config.network?.defaultBackoffFactor || 2,
      defaultJitterFactor: config.network?.defaultJitterFactor || 0.25
    };
    
    // 统计数据
    this.stats = {
      totalRetries: 0,
      totalOperations: 0,
      totalFailures: 0,
      totalSuccesses: 0,
      operationsByResult: new Map() // 每个操作ID的成功/失败次数
    };
    
    logger.info('请求重试服务已初始化');
  }
  
  /**
   * 执行带重试逻辑的操作
   * @param {Function} operation - 要执行的操作函数
   * @param {Object} options - 重试选项
   * @param {string} options.operationId - 操作标识符，用于统计和日志
   * @param {number} options.maxRetries - 最大重试次数
   * @param {string} options.backoffStrategy - 退避策略
   * @param {number} options.initialDelayMs - 初始延迟毫秒数
   * @param {number} options.maxDelayMs - 最大延迟毫秒数
   * @param {number} options.backoffFactor - 退避因子
   * @param {Function} options.retryCondition - 判断是否应该重试的函数
   * @returns {Promise<any>} 操作结果
   */
  async executeWithRetry(operation, options = {}) {
    if (!this.config.enabled) {
      return operation();
    }
    
    const operationId = options.operationId || `op_${Date.now()}_${Math.random().toString(36).substring(2, 5)}`;
    const maxRetries = options.maxRetries || this.config.defaultMaxRetries;
    const backoffStrategy = options.backoffStrategy || this.config.defaultBackoffStrategy;
    const initialDelayMs = options.initialDelayMs || this.config.defaultInitialDelayMs;
    const maxDelayMs = options.maxDelayMs || this.config.defaultMaxDelayMs;
    const backoffFactor = options.backoffFactor || this.config.defaultBackoffFactor;
    const retryCondition = options.retryCondition || this._defaultRetryCondition;
    
    // 统计信息
    if (!this.stats.operationsByResult.has(operationId)) {
      this.stats.operationsByResult.set(operationId, { success: 0, failure: 0, retries: 0 });
    }
    
    this.stats.totalOperations++;
    
    let attempt = 0;
    let lastError = null;
    
    while (attempt <= maxRetries) {
      try {
        const result = await operation();
        
        if (attempt > 0) {
          this.stats.operationsByResult.get(operationId).success++;
          this.stats.totalSuccesses++;
          
          // 发出成功重试的事件
          this.emit('retry_success', {
            operationId,
            attempt,
            totalAttempts: attempt + 1
          });
        }
        
        return result;
      } catch (error) {
        lastError = error;
        attempt++;
        
        this.stats.operationsByResult.get(operationId).failure++;
        
        // 如果不应该重试或已达到最大重试次数，则抛出错误
        if (attempt > maxRetries || !retryCondition(error, attempt)) {
          this.stats.totalFailures++;
          
          // 发出重试失败的事件
          this.emit('retry_failed', {
            operationId,
            attempt,
            error: error.message,
            maxRetries
          });
          
          throw error;
        }
        
        // 计算退避延迟时间
        const delayMs = this._calculateBackoffDelay(
          attempt,
          backoffStrategy,
          initialDelayMs,
          maxDelayMs,
          backoffFactor
        );
        
        // 更新统计信息
        this.stats.totalRetries++;
        this.stats.operationsByResult.get(operationId).retries++;
        
        // 发出重试事件
        this.emit('retry_attempt', {
          operationId,
          attempt,
          delayMs,
          error: error.message
        });
        
        logger.debug(`操作 ${operationId} 失败，尝试重试 (${attempt}/${maxRetries})，延迟 ${delayMs}ms`, error.message);
        
        // 等待退避时间后重试
        logger.debug(`操作 ${operationId} 失败，尝试重试 (${attempt}/${maxRetries})，延迟 ${delayMs}ms`, { error });
        await new Promise(resolve => setTimeout(resolve, delayMs));
      }
    }
    
    // 理论上不会执行到这里，因为最后一次失败应该抛出异常
    throw lastError;
  }
  
  /**
   * 默认的重试条件判断
   * @private
   * @param {Error} error - 错误对象
   * @param {number} attempt - 当前尝试次数
   * @returns {boolean} 是否应该重试
   */
  _defaultRetryCondition(error, attempt) {
    // 网络错误、超时错误和5xx服务器错误通常可以重试
    if (
      error.name === 'NetworkError' || 
      error.name === 'TimeoutError' ||
      error.message.includes('timeout') ||
      error.message.includes('network') ||
      error.code === 'ECONNRESET' ||
      error.code === 'ETIMEDOUT' ||
      error.code === 'ECONNREFUSED' ||
      error.status >= 500 ||
      (error.response && error.response.status >= 500)
    ) {
      return true;
    }
    
    // 特定的自定义错误
    if (error.isRetryable === true) {
      return true;
    }
    
    // 默认不重试
    return false;
  }
  
  /**
   * 计算退避延迟时间
   * @private
   * @param {number} attempt - 当前尝试次数
   * @param {string} strategy - 退避策略
   * @param {number} initialDelayMs - 初始延迟毫秒数
   * @param {number} maxDelayMs - 最大延迟毫秒数
   * @param {number} backoffFactor - 退避因子
   * @returns {number} 延迟毫秒数
   */
  _calculateBackoffDelay(attempt, strategy, initialDelayMs, maxDelayMs, backoffFactor) {
    let delay = 0;
    
    switch (strategy) {
      case BackoffStrategy.FIXED:
        delay = initialDelayMs;
        break;
        
      case BackoffStrategy.LINEAR:
        delay = initialDelayMs * attempt;
        break;
        
      case BackoffStrategy.EXPONENTIAL:
        delay = initialDelayMs * Math.pow(backoffFactor, attempt - 1);
        break;
        
      case BackoffStrategy.RANDOM:
        const min = initialDelayMs;
        const max = initialDelayMs * Math.pow(backoffFactor, attempt - 1);
        delay = Math.floor(Math.random() * (max - min + 1)) + min;
        break;
        
      case BackoffStrategy.DECORRELATED_JITTER:
        // 装饰器抖动算法: temp = min(maxDelay, random(base, base * 3))
        const base = attempt === 1 ? initialDelayMs : this._prevDelay || initialDelayMs;
        const temp = Math.min(maxDelayMs, Math.random() * base * 3);
        delay = temp;
        this._prevDelay = temp;
        break;
        
      default:
        delay = initialDelayMs * Math.pow(backoffFactor, attempt - 1);
    }
    
    // 添加小的随机抖动，避免雷鸣效应
    const jitter = this.config.defaultJitterFactor; // 抖动因子
    const randomFactor = 1 - jitter + (Math.random() * jitter * 2);
    delay = Math.floor(delay * randomFactor);
    
    // 确保不超过最大延迟
    return Math.min(delay, maxDelayMs);
  }
  
  /**
   * 为数据库读取优化的重试策略
   * @param {Function} operation - 要执行的操作函数
   * @param {Object} options - 重试选项
   * @returns {Promise<any>} 操作结果
   */
  async executeDbRead(operation, options = {}) {
    return this.executeWithRetry(operation, {
      operationId: options.operationId || 'db_read',
      maxRetries: options.maxRetries || 3,
      backoffStrategy: BackoffStrategy.EXPONENTIAL,
      initialDelayMs: 50, // 数据库读取通常比较快，使用较短的初始延迟
      maxDelayMs: 2000,
      retryCondition: (error) => {
        // 数据库读取错误通常需要重试的情况
        return error.name === 'MongoNetworkError' || 
               error.name === 'MongoTimeoutError' ||
               error.message.includes('timeout') ||
               error.code === 11600 || // 副本集连接异常
               error.code === 13436 || // 找不到节点
               error.code === 13435;   // 不是主节点
      },
      ...options
    });
  }
  
  /**
   * 为HTTP API调用优化的重试策略
   * @param {Function} operation - 要执行的操作函数
   * @param {Object} options - 重试选项
   * @returns {Promise<any>} 操作结果
   */
  async executeHttpRequest(operation, options = {}) {
    return this.executeWithRetry(operation, {
      operationId: options.operationId || 'http_request',
      maxRetries: options.maxRetries || 3,
      backoffStrategy: BackoffStrategy.DECORRELATED_JITTER, // HTTP请求适合使用装饰器抖动策略
      initialDelayMs: 200,
      maxDelayMs: 5000,
      ...options
    });
  }
  
  /**
   * 为可能遇到高并发的服务调用优化的重试策略
   * @param {Function} operation - 要执行的操作函数
   * @param {Object} options - 重试选项
   * @returns {Promise<any>} 操作结果
   */
  async executeServiceCall(operation, options = {}) {
    return this.executeWithRetry(operation, {
      operationId: options.operationId || 'service_call',
      maxRetries: options.maxRetries || 5,
      backoffStrategy: BackoffStrategy.EXPONENTIAL,
      initialDelayMs: 100,
      maxDelayMs: 30000, // 更长的最大延迟
      backoffFactor: 3, // 更快的退避速度
      ...options
    });
  }
  
  /**
   * 获取指定操作的统计信息
   * @param {string} operationId - 操作ID
   * @returns {Object|null} 统计信息
   */
  getOperationStats(operationId) {
    if (!this.stats.operationsByResult.has(operationId)) {
      return null;
    }
    
    const stats = this.stats.operationsByResult.get(operationId);
    return {
      operationId,
      retries: stats.retries,
      successes: stats.success,
      failures: stats.failure,
      successRate: stats.success > 0 ? 
        stats.success / (stats.success + stats.failure) : 0
    };
  }
  
  /**
   * 获取服务统计信息
   * @returns {Object} 统计信息
   */
  getStats() {
    return {
      totalOperations: this.stats.totalOperations,
      totalRetries: this.stats.totalRetries,
      totalSuccesses: this.stats.totalSuccesses,
      totalFailures: this.stats.totalFailures,
      retryRate: this.stats.totalOperations > 0 ? 
        this.stats.totalRetries / this.stats.totalOperations : 0,
      successRate: (this.stats.totalSuccesses + this.stats.totalFailures) > 0 ?
        this.stats.totalSuccesses / (this.stats.totalSuccesses + this.stats.totalFailures) : 0
    };
  }
  
  /**
   * 获取服务状态
   * @returns {Object} 服务状态
   */
  getStatus() {
    return {
      enabled: this.config.enabled,
      config: this.config,
      stats: this.getStats()
    };
  }
}

// 创建单例
const retryStrategyService = new RetryStrategyService();

// 导出服务和枚举
module.exports = {
  retryStrategyService,
  BackoffStrategy
}; 