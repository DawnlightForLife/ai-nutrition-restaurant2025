/**
 * 断路器服务模块（Circuit Breaker）
 * 实现断路器设计模式以防止系统级级联故障
 * 支持自动故障检测、状态转换（CLOSED、OPEN、HALF_OPEN）
 * 提供事件机制通知外部系统状态变更
 * @module services/core/circuitBreakerService
 */

/**
 * 断路器服务
 * 实现断路器模式以防止级联故障和管理故障恢复
 */

const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');
const EventEmitter = require('events');

/**
 * 断路器状态枚举
 */
const CircuitState = {
  CLOSED: 'CLOSED',      // 正常状态，允许操作执行
  OPEN: 'OPEN',          // 断开状态，拒绝所有操作，等待恢复
  HALF_OPEN: 'HALF_OPEN' // 半开状态，允许有限操作以测试系统
};

/**
 * 断路器服务类
 * 管理多个断路器实例，监控操作执行并自动处理故障
 */
// 使用 EventEmitter 提供断路器状态变更事件：open、closed、half-open、rejected、success、failure
class CircuitBreakerService extends EventEmitter {
  constructor() {
    super();
    
    // 所有断路器集合
    this.breakers = new Map();
    
    // 配置
    this.config = {
      enabled: config.faultTolerance && config.faultTolerance.enabled,
      defaultThreshold: (config.faultTolerance && config.faultTolerance.failureThreshold) || 5,
      defaultTimeout: (config.faultTolerance && config.faultTolerance.resetTimeout) || 30000,
      defaultHalfOpenLimit: (config.faultTolerance && config.faultTolerance.halfOpenAttempts) || 3,
      halfOpenWait: 1000, // 半开状态下请求之间的等待时间
      monitorInterval: 10000, // 定期清理和监控频率（10秒）
    };
    
    // 启动监控
    if (this.config.enabled) {
      this._startMonitoring();
    }
  }
  
  /**
   * 开始定期监控
   * @private
   */
  _startMonitoring() {
    setInterval(() => {
      this._monitorCircuits();
    }, this.config.monitorInterval);
  }
  
  /**
   * 监控并管理所有断路器
   * @private
   */
  _monitorCircuits() {
    try {
      const now = Date.now();
      
      this.breakers.forEach((breaker, key) => {
        // 检查是否应该从OPEN状态转换为HALF_OPEN状态
        if (breaker.state === CircuitState.OPEN && 
            (now - breaker.lastStateChange) >= breaker.resetTimeout) {
          this._transitionToHalfOpen(key);
        }
        
        // 清理过期的故障记录
        breaker.failures = breaker.failures.filter(timestamp => 
          now - timestamp < 60000); // 保留最近1分钟的错误
      });
    } catch (error) {
      logger.error('监控断路器时出错', { error });
    }
  }
  
  /**
   * 创建或获取断路器
   * @param {string} name - 断路器名称
   * @param {Object} options - 配置选项
   * @returns {Object} 断路器对象
   */
  getBreaker(name, options = {}) {
    if (!this.breakers.has(name)) {
      // 创建新断路器
      this.breakers.set(name, {
        name,
        state: CircuitState.CLOSED,
        failures: [],
        successCounter: 0,
        failureThreshold: options.threshold || this.config.defaultThreshold,
        resetTimeout: options.timeout || this.config.defaultTimeout,
        halfOpenLimit: options.halfOpenLimit || this.config.defaultHalfOpenLimit,
        lastStateChange: Date.now(),
        lastAttempt: 0
      });
      
      logger.info(`创建断路器: ${name}`);
    }
    
    return this.breakers.get(name);
  }
  
  /**
   * 执行受保护的操作
   * @param {string} name - 断路器名称
   * @param {Function} operation - 要执行的操作
   * @param {Object} options - 执行选项
   * @returns {Promise} 操作结果
   */
  async execute(name, operation, options = {}) {
    if (!this.config.enabled) {
      // 断路器未启用，直接执行操作
      return operation();
    }
    
    const breaker = this.getBreaker(name, options);
    
    // 检查断路器状态
    if (breaker.state === CircuitState.OPEN) {
      this.emit('rejected', name, 'Circuit is OPEN');
      throw new Error(`操作被断路器拒绝: ${name}`);
    }
    
    // 在半开状态下，控制并发请求数量
    if (breaker.state === CircuitState.HALF_OPEN) {
      const now = Date.now();
      
      // 确保半开状态下的请求间隔足够大
      if (now - breaker.lastAttempt < this.config.halfOpenWait) {
        this.emit('rejected', name, 'Too many requests in HALF_OPEN state');
        throw new Error(`半开状态下请求过于频繁: ${name}`);
      }
      
      breaker.lastAttempt = now;
    }
    
    try {
      const result = await operation();
      
      // 操作成功
      this._handleSuccess(name);
      return result;
    } catch (error) {
      // 操作失败
      this._handleFailure(name, error);
      throw error;
    }
  }
  
  /**
   * 处理操作成功
   * @param {string} name - 断路器名称
   * @private
   */
  _handleSuccess(name) {
    const breaker = this.breakers.get(name);
    
    if (breaker.state === CircuitState.HALF_OPEN) {
      // 增加成功计数
      breaker.successCounter++;
      
      // 检查是否可以关闭断路器
      if (breaker.successCounter >= breaker.halfOpenLimit) {
        this._transitionToClosed(name);
      }
    }
    
    this.emit('success', name);
  }
  
  /**
   * 处理操作失败
   * @param {string} name - 断路器名称
   * @param {Error} error - 错误对象
   * @private
   */
  _handleFailure(name, error) {
    const breaker = this.breakers.get(name);
    const now = Date.now();
    
    // 记录失败
    breaker.failures.push(now);
    
    // 在半开状态下，任何失败都会导致回到开路状态
    if (breaker.state === CircuitState.HALF_OPEN) {
      this._transitionToOpen(name);
      this.emit('failure', name, error, 'Failure in HALF_OPEN state');
      return;
    }
    
    // 检查是否达到失败阈值
    const recentFailures = breaker.failures.filter(timestamp => 
      now - timestamp < 60000); // 最近1分钟内的失败
    
    if (recentFailures.length >= breaker.failureThreshold) {
      this._transitionToOpen(name);
      this.emit('failure', name, error, 'Failure threshold reached');
    } else {
      this.emit('failure', name, error, 'Failure recorded');
    }
  }
  
  /**
   * 转换到开路状态
   * @param {string} name - 断路器名称
   * @private
   */
  _transitionToOpen(name) {
    const breaker = this.breakers.get(name);
    
    breaker.state = CircuitState.OPEN;
    breaker.lastStateChange = Date.now();
    breaker.successCounter = 0;
    
    logger.warn(`断路器 ${name} 已开路，暂停接受新请求`);
    this.emit('open', name);
  }
  
  /**
   * 转换到半开状态
   * @param {string} name - 断路器名称
   * @private
   */
  _transitionToHalfOpen(name) {
    const breaker = this.breakers.get(name);
    
    breaker.state = CircuitState.HALF_OPEN;
    breaker.lastStateChange = Date.now();
    breaker.successCounter = 0;
    
    logger.info(`断路器 ${name} 已半开，允许有限测试请求`);
    this.emit('half-open', name);
  }
  
  /**
   * 转换到闭合状态
   * @param {string} name - 断路器名称
   * @private
   */
  _transitionToClosed(name) {
    const breaker = this.breakers.get(name);
    
    breaker.state = CircuitState.CLOSED;
    breaker.lastStateChange = Date.now();
    breaker.failures = [];
    breaker.successCounter = 0;
    
    logger.info(`断路器 ${name} 已关闭，恢复正常操作`);
    this.emit('closed', name);
  }
  
  /**
   * 手动重置断路器
   * @param {string} name - 断路器名称
   * @returns {boolean} 是否成功
   */
  resetBreaker(name) {
    if (!this.breakers.has(name)) {
      return false;
    }
    
    this._transitionToClosed(name);
    return true;
  }
  
  /**
   * 手动打开断路器
   * @param {string} name - 断路器名称
   * @returns {boolean} 是否成功
   */
  openBreaker(name) {
    if (!this.breakers.has(name)) {
      return false;
    }
    
    this._transitionToOpen(name);
    return true;
  }
  
  /**
   * 获取断路器状态
   * @param {string} name - 断路器名称
   * @returns {Object|null} 断路器状态
   */
  getBreakerStatus(name) {
    if (!this.breakers.has(name)) {
      return null;
    }
    
    const breaker = this.breakers.get(name);
    return {
      name: breaker.name,
      state: breaker.state,
      failureCount: breaker.failures.length,
      successCounter: breaker.successCounter,
      lastStateChange: breaker.lastStateChange,
      threshold: breaker.failureThreshold,
      resetTimeout: breaker.resetTimeout,
      timeSinceLastStateChange: Date.now() - breaker.lastStateChange
    };
  }
  
  /**
   * 获取所有断路器状态
   * @returns {Object} 所有断路器状态
   */
  getAllBreakerStatus() {
    const statuses = {};
    
    this.breakers.forEach((breaker, name) => {
      statuses[name] = this.getBreakerStatus(name);
    });
    
    return {
      enabled: this.config.enabled,
      breakerCount: this.breakers.size,
      breakers: statuses
    };
  }
}

// 创建单例
const circuitBreakerService = new CircuitBreakerService();

// 导出断路器服务和状态枚举
module.exports = {
  circuitBreakerService,
  CircuitState
};