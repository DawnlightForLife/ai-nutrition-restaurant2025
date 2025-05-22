/**
 * 读取一致性服务（ReadConsistencyService）
 * 提供 MongoDB 多种读取一致性级别支持，包括 EVENTUAL、SESSION、STRONG、LINEARIZABLE
 * 支持副本延迟监控、重试机制、断路器接入、跨分片读取等高级功能
 * 用于保障系统在分布式部署下的数据读取一致性与高可用性
 * @module services/core/readConsistencyService
 */

const mongoose = require('mongoose');
const EventEmitter = require('events');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../../config');
const circuitBreakerService = require('../performance/circuitBreakerService');

/**
 * 读取一致性级别枚举
 * @enum {string}
 */
const ConsistencyLevel = {
  // 最终一致性: 可能读取到过期数据，但延迟最低
  EVENTUAL: 'EVENTUAL',
  
  // 会话一致性: 保证同一会话内的读写顺序一致
  SESSION: 'SESSION',
  
  // 强一致性: 保证读取到最新数据，但延迟较高
  STRONG: 'STRONG',
  
  // 线性一致性: 所有操作全局有序，延迟最高
  LINEARIZABLE: 'LINEARIZABLE'
};

class ReadConsistencyService extends EventEmitter {
  constructor() {
    super();
    
    // 配置
    this.config = {
      defaultConsistencyLevel: config.database?.consistencyLevel || ConsistencyLevel.SESSION,
      enableReadFromSecondary: config.database?.enableReadFromSecondary || true,
      maxStaleness: config.database?.maxStalenessMs || 60000, // 默认允许1分钟过期时间
      replicaSelectionStrategy: config.database?.replicaSelectionStrategy || 'nearest',
      enableConsistencyMonitoring: config.database?.enableConsistencyMonitoring || false,
      monitoringInterval: config.database?.consistencyMonitoringInterval || 60000, // 1分钟
      maxRetries: config.database?.maxReadRetries || 3,
      retryDelayMs: config.database?.retryDelayMs || 100,
      readPreferenceTags: config.database?.readPreferenceTags || []
    };
    
    // 状态信息
    this.stats = {
      totalReads: 0,
      eventualReads: 0,
      sessionReads: 0,
      strongReads: 0,
      linearizableReads: 0,
      retries: 0,
      failures: 0,
      averageReadLatency: 0,
      totalReadTime: 0
    };
    
    // 监控器
    this.monitor = null;
    
    // 启动监控
    if (this.config.enableConsistencyMonitoring) {
      this._startMonitoring();
    }
    
    logger.info('读取一致性服务已初始化，默认级别：', this.config.defaultConsistencyLevel);
  }
  
  /**
   * 开始监控一致性指标
   * @private
   */
  _startMonitoring() {
    this.monitor = setInterval(() => {
      this._checkReplicaLag().catch(err => {
        logger.error('检查副本延迟时出错', { error: err });
      });
    }, this.config.monitoringInterval);
    
    logger.info('一致性监控已启动，间隔:', this.config.monitoringInterval / 1000, '秒');
  }
  
  /**
   * 检查副本延迟
   * @private
   * @returns {Promise<void>}
   */
  async _checkReplicaLag() {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        return;
      }
      
      const db = mongoose.connection.db;
      const adminDb = db.admin();
      
      // 获取复制集状态
      const status = await adminDb.command({ replSetGetStatus: 1 });
      
      if (!status.members || status.members.length <= 1) {
        // 非复制集环境
        return;
      }
      
      // 找到主节点
      const primary = status.members.find(m => m.state === 1);
      if (!primary) return;
      
      // 检查每个从节点的延迟
      const lagInfo = status.members
        .filter(m => m.state === 2) // 只检查从节点
        .map(member => {
          const lagMillis = member.optimeDate 
            ? (primary.optimeDate.getTime() - member.optimeDate.getTime()) 
            : 0;
          
          return {
            host: member.name,
            lagMillis,
            health: member.health,
            state: member.stateStr
          };
        });
      
      // 检查是否有延迟过大的节点
      const laggingNodes = lagInfo.filter(n => n.lagMillis > this.config.maxStaleness);
      
      if (laggingNodes.length > 0) {
        logger.warn('检测到副本延迟过大:', laggingNodes);
        this.emit('replica_lag_detected', laggingNodes);
      }
      
      // 记录延迟信息
      this.emit('replica_lag_info', lagInfo);
      
    } catch (error) {
      logger.error('检查副本延迟时出错', { error });
      throw error;
    }
  }
  
  /**
   * 根据一致性级别获取读取首选项
   * @private
   * @param {string} consistencyLevel - 一致性级别
   * @param {mongoose.ClientSession} [session] - Mongoose会话
   * @returns {Object} 读取首选项
   */
  _getReadPreference(consistencyLevel, session) {
    // 默认使用配置的一致性级别
    const level = consistencyLevel || this.config.defaultConsistencyLevel;
    
    // 根据一致性级别设置读取首选项
    switch (level) {
      case ConsistencyLevel.EVENTUAL:
        return {
          readPreference: 'secondaryPreferred',
          readPreferenceTags: this.config.readPreferenceTags,
          maxStalenessSeconds: Math.floor(this.config.maxStaleness / 1000)
        };
        
      case ConsistencyLevel.SESSION:
        // 如果有会话，使用会话的读取首选项
        if (session) {
          return { readPreference: 'primary' };
        }
        return { readPreference: 'primaryPreferred' };
        
      case ConsistencyLevel.STRONG:
        return { readPreference: 'primary' };
        
      case ConsistencyLevel.LINEARIZABLE:
        return { 
          readPreference: 'primary',
          readConcern: { level: 'linearizable' }
        };
        
      default:
        return { readPreference: 'primary' };
    }
  }
  
  /**
   * 执行具有指定一致性级别的读取操作
   * @param {Function} operation - 读取操作函数
   * @param {Object} options - 选项
   * @param {string} options.consistencyLevel - 一致性级别
   * @param {mongoose.ClientSession} [options.session] - Mongoose会话
   * @param {string} [options.breakerName] - 断路器名称
   * @returns {Promise<any>} 读取操作结果
   */
  async readWithConsistency(operation, options = {}) {
    const startTime = Date.now();
    const consistencyLevel = options.consistencyLevel || this.config.defaultConsistencyLevel;
    let retries = 0;
    let session = options.session;
    let error = null;
    
    // 如果需要会话一致性但没有提供会话，创建一个
    if (consistencyLevel === ConsistencyLevel.SESSION && !session) {
      session = await mongoose.startSession();
    }
    
    // 获取读取首选项
    const readPreference = this._getReadPreference(consistencyLevel, session);
    
    // 更新统计信息
    this.stats.totalReads++;
    switch (consistencyLevel) {
      case ConsistencyLevel.EVENTUAL:
        this.stats.eventualReads++;
        break;
      case ConsistencyLevel.SESSION:
        this.stats.sessionReads++;
        break;
      case ConsistencyLevel.STRONG:
        this.stats.strongReads++;
        break;
      case ConsistencyLevel.LINEARIZABLE:
        this.stats.linearizableReads++;
        break;
    }
    
    // 执行读取操作，使用断路器和重试逻辑
    try {
      // 如果指定了断路器，使用断路器执行
      if (options.breakerName) {
        return await circuitBreakerService.execute(
          options.breakerName,
          () => this._executeWithRetry(operation, readPreference, session, retries),
          { timeout: options.timeout }
        );
      } else {
        // 否则直接执行带重试的操作
        return await this._executeWithRetry(operation, readPreference, session, retries);
      }
    } catch (err) {
      error = err;
      this.stats.failures++;
      throw err;
    } finally {
      // 更新统计信息
      const duration = Date.now() - startTime;
      this.stats.totalReadTime += duration;
      this.stats.averageReadLatency = this.stats.totalReadTime / this.stats.totalReads;
      
      // 如果我们创建了会话，关闭它
      if (consistencyLevel === ConsistencyLevel.SESSION && !options.session && session) {
        session.endSession();
      }
      
      // 记录读取信息
      this.emit('read_completed', {
        consistencyLevel,
        duration,
        success: !error,
        retries,
        error: error ? error.message : null
      });
    }
  }
  
  /**
   * 使用重试逻辑执行读取操作
   * @private
   * @param {Function} operation - 读取操作
   * @param {Object} readPreference - 读取首选项
   * @param {mongoose.ClientSession} session - Mongoose会话
   * @param {number} retries - 重试计数器的引用
   * @returns {Promise<any>} 操作结果
   */
  async _executeWithRetry(operation, readPreference, session, retries) {
    let lastError = null;
    let attempt = 0;
    
    while (attempt <= this.config.maxRetries) {
      try {
        // 构建操作选项
        const operationOptions = { ...readPreference };
        if (session) {
          operationOptions.session = session;
        }
        
        // 执行操作
        return await operation(operationOptions);
      } catch (error) {
        lastError = error;
        attempt++;
        retries = attempt;
        
        // 增加重试统计
        if (attempt <= this.config.maxRetries) {
          this.stats.retries++;
          
          // 检查错误是否可重试
          if (!this._isRetryableError(error)) {
            break;
          }
          
          // 指数退避策略
          const delay = this.config.retryDelayMs * Math.pow(2, attempt - 1);
          logger.debug(`读取操作失败，尝试重试 (${attempt}/${this.config.maxRetries})，延迟 ${delay}ms`, { error: error.message });
          
          // 等待后重试
          await new Promise(resolve => setTimeout(resolve, delay));
        }
      }
    }
    
    // 如果所有重试都失败，抛出最后一个错误
    throw lastError;
  }
  
  /**
   * 判断错误是否可重试
   * @private
   * @param {Error} error - 错误对象
   * @returns {boolean} 是否可重试
   */
  _isRetryableError(error) {
    // 网络错误通常可以重试
    if (error.name === 'MongoNetworkError' || 
        error.name === 'MongoTimeoutError' ||
        error.message.includes('connection') ||
        error.message.includes('timeout')) {
      return true;
    }
    
    // 特定的MongoDB错误码
    const retryableCodes = [
      6, // 主机不可达
      7, // 主机不是主节点
      89, // 网络超时
      91, // 分片不可用
      189, // 主节点步进错误
      9001, // 套接字异常
      10107, // 找不到主节点
      11600, // 副本集连接异常
      11602, // 副本集连接超时
      13436, // 找不到节点
      13435, // 不是主节点
    ];
    
    return error.code && retryableCodes.includes(error.code);
  }
  
  /**
   * 获取跨分片的读取操作
   * @param {Array<string>} shardKeys - 分片键列表
   * @param {Function} queryFn - 查询函数，接收分片集合名称
   * @param {Object} options - 选项
   * @returns {Promise<Array>} 合并后的结果
   */
  async readAcrossShards(shardKeys, queryFn, options = {}) {
    // 默认使用SESSION一致性级别
    const consistencyLevel = options.consistencyLevel || ConsistencyLevel.SESSION;
    let session = options.session;
    
    // 如果需要会话一致性但没有提供会话，创建一个
    if (consistencyLevel === ConsistencyLevel.SESSION && !session) {
      session = await mongoose.startSession();
    }
    
    try {
      // 并行查询所有分片
      const results = await Promise.all(
        shardKeys.map(shardKey => 
          this.readWithConsistency(
            readOptions => queryFn(shardKey, readOptions),
            { 
              consistencyLevel,
              session,
              breakerName: options.breakerName
            }
          )
        )
      );
      
      // 合并结果
      return results.flat();
    } finally {
      // 如果我们创建了会话，关闭它
      if (consistencyLevel === ConsistencyLevel.SESSION && !options.session && session) {
        session.endSession();
      }
    }
  }
  
  /**
   * 获取服务状态
   * @returns {Object} 服务状态
   */
  getStatus() {
    return {
      enabled: true,
      defaultConsistencyLevel: this.config.defaultConsistencyLevel,
      stats: this.stats,
      config: this.config
    };
  }
}

// 创建单例
const readConsistencyService = new ReadConsistencyService();

// 导出服务和枚举
module.exports = {
  readConsistencyService,
  ConsistencyLevel
}; 