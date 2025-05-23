/**
 * 性能监控服务
 * 负责记录数据库操作、API调用及应用事件的性能数据
 * 支持性能统计、阈值告警及性能报告生成
 * @module services/performance/performanceMonitoringService
 */

const { EventEmitter } = require('events');
const logger = require('../../utils/logger/winstonLogger');
const config = require('../../config');
const alertSystem = require('../monitoring/alertSystem');

class PerformanceMonitoringService extends EventEmitter {
  constructor() {
    super();
    this.initialized = false;
    this.metricsEnabled = config.performance?.metrics?.enabled ?? true;
    this.alertingEnabled = config.performance?.alerting?.enabled ?? true;
    this.samplingRate = config.performance?.samplingRate ?? 1.0; // 1.0 = 100% 采样
    
    // 性能数据存储
    this.metrics = {
      db: {
        operations: [],
        averages: {}
      },
      api: {
        calls: [],
        averages: {}
      },
      system: {
        events: [],
        averages: {}
      }
    };
    
    // 性能阈值配置
    this.thresholds = {
      db: config.performance?.thresholds?.db ?? {
        warning: 500, // ms
        critical: 1000 // ms
      },
      api: config.performance?.thresholds?.api ?? {
        warning: 1000, // ms
        critical: 3000 // ms
      }
    };
    
    // 每分钟清理一次过期指标
    this.cleanupInterval = setInterval(() => {
      this._cleanupOldMetrics();
    }, 60000);
  }
  
  /**
   * 初始化性能监控服务
   */
  initialize() {
    if (this.initialized) return;
    
    try {
      logger.info('初始化性能监控服务...');
      
      // 注册系统事件以捕获性能数据
      process.on('warning', (warning) => {
        this.recordSystemEvent('warning', warning);
      });
      
      this.initialized = true;
      logger.info('性能监控服务初始化完成');
    } catch (error) {
      logger.error('初始化性能监控服务失败', { error });
    }
  }
  
  /**
   * 记录数据库操作性能
   * @param {Object} data - 操作数据
   */
  recordDbOperation(data) {
    if (!this.metricsEnabled || Math.random() > this.samplingRate) return;
    
    try {
      // 添加时间戳
      const timestamp = Date.now();
      const metric = {
        ...data,
        timestamp
      };
      
      // 将指标添加到集合中
      this.metrics.db.operations.push(metric);
      
      // 更新平均值
      this._updateAverages('db', data.operation, data.duration);
      
      // 发出事件
      this.emit('db-operation', metric);
      
      // 检查阈值
      this._checkThresholds('db', data);
      
      // 修剪集合以避免内存泄漏
      if (this.metrics.db.operations.length > 1000) {
        this.metrics.db.operations = this.metrics.db.operations.slice(-1000);
      }
    } catch (error) {
      logger.error('记录数据库操作性能失败', { error });
    }
  }
  
  /**
   * 记录API调用性能
   * @param {Object} data - 调用数据
   */
  recordApiCall(data) {
    if (!this.metricsEnabled || Math.random() > this.samplingRate) return;
    
    try {
      // 添加时间戳
      const timestamp = Date.now();
      const metric = {
        ...data,
        timestamp
      };
      
      // 将指标添加到集合中
      this.metrics.api.calls.push(metric);
      
      // 更新平均值
      this._updateAverages('api', data.endpoint, data.duration);
      
      // 发出事件
      this.emit('api-call', metric);
      
      // 检查阈值
      this._checkThresholds('api', data);
      
      // 修剪集合以避免内存泄漏
      if (this.metrics.api.calls.length > 1000) {
        this.metrics.api.calls = this.metrics.api.calls.slice(-1000);
      }
    } catch (error) {
      logger.error('记录API调用性能失败', { error });
    }
  }
  
  /**
   * 记录系统事件
   * @param {string} eventType - 事件类型
   * @param {Object} data - 事件数据
   */
  recordSystemEvent(eventType, data) {
    if (!this.metricsEnabled) return;
    
    try {
      const timestamp = Date.now();
      const event = {
        type: eventType,
        data,
        timestamp
      };
      
      this.metrics.system.events.push(event);
      this.emit('system-event', event);
      
      // 修剪集合以避免内存泄漏
      if (this.metrics.system.events.length > 500) {
        this.metrics.system.events = this.metrics.system.events.slice(-500);
      }
    } catch (error) {
      logger.error('记录系统事件失败', { error });
    }
  }
  
  /**
   * 获取性能统计数据
   * @param {string} type - 指标类型 (db, api, system)
   * @param {Object} options - 查询选项
   * @returns {Object} - 统计数据
   */
  getStats(type, options = {}) {
    const { timeRange, operation, limit } = options;
    const now = Date.now();
    
    let data = [];
    
    // 根据类型选择数据
    switch (type) {
      case 'db':
        data = this.metrics.db.operations;
        break;
      case 'api':
        data = this.metrics.api.calls;
        break;
      case 'system':
        data = this.metrics.system.events;
        break;
      default:
        return { error: '未知指标类型' };
    }
    
    // 应用时间范围过滤器
    if (timeRange) {
      data = data.filter(item => {
        return (now - item.timestamp) <= timeRange;
      });
    }
    
    // 应用操作过滤器
    if (operation) {
      data = data.filter(item => {
        return item.operation === operation || item.endpoint === operation;
      });
    }
    
    // 应用限制
    if (limit && data.length > limit) {
      data = data.slice(-limit);
    }
    
    // 如果是db或api类型，计算统计信息
    if (type === 'db' || type === 'api') {
      const durations = data.map(item => item.duration);
      
      return {
        count: data.length,
        data: data,
        stats: this._calculateStats(durations),
        averages: this.metrics[type].averages
      };
    }
    
    return {
      count: data.length,
      data: data
    };
  }
  
  /**
   * 更新平均值
   * @private
   * @param {string} type - 指标类型
   * @param {string} operation - 操作名称
   * @param {number} duration - 操作持续时间
   */
  _updateAverages(type, operation, duration) {
    const averages = this.metrics[type].averages;
    
    if (!averages[operation]) {
      averages[operation] = {
        count: 1,
        total: duration,
        average: duration
      };
    } else {
      averages[operation].count++;
      averages[operation].total += duration;
      averages[operation].average = averages[operation].total / averages[operation].count;
    }
  }
  
  /**
   * 检查性能阈值
   * @private
   * @param {string} type - 指标类型
   * @param {Object} data - 性能数据
   */
  _checkThresholds(type, data) {
    if (!this.alertingEnabled) return;
    
    const thresholds = this.thresholds[type];
    const duration = data.duration;
    
    if (duration >= thresholds.critical) {
      alertSystem.sendAlert({
        level: 'critical',
        type: 'performance',
        source: `${type}:${data.operation || data.endpoint}`,
        message: `性能临界：${type}操作超过${thresholds.critical}ms (${duration}ms)`,
        data
      });
    } else if (duration >= thresholds.warning) {
      alertSystem.sendAlert({
        level: 'warning',
        type: 'performance',
        source: `${type}:${data.operation || data.endpoint}`,
        message: `性能警告：${type}操作超过${thresholds.warning}ms (${duration}ms)`,
        data
      });
    }
  }
  
  /**
   * 计算统计信息
   * @private
   * @param {Array<number>} durations - 持续时间数组
   * @returns {Object} - 统计信息
   */
  _calculateStats(durations) {
    if (durations.length === 0) {
      return {
        min: 0,
        max: 0,
        avg: 0,
        median: 0,
        p95: 0,
        p99: 0
      };
    }
    
    // 排序用于计算分位数
    const sorted = [...durations].sort((a, b) => a - b);
    
    return {
      min: sorted[0],
      max: sorted[sorted.length - 1],
      avg: sorted.reduce((sum, val) => sum + val, 0) / sorted.length,
      median: sorted[Math.floor(sorted.length / 2)],
      p95: sorted[Math.floor(sorted.length * 0.95)],
      p99: sorted[Math.floor(sorted.length * 0.99)]
    };
  }
  
  /**
   * 清理旧指标
   * @private
   */
  _cleanupOldMetrics() {
    const now = Date.now();
    const DAY_MS = 24 * 60 * 60 * 1000;
    
    // 保留最近24小时的数据
    this.metrics.db.operations = this.metrics.db.operations.filter(
      op => (now - op.timestamp) < DAY_MS
    );
    
    this.metrics.api.calls = this.metrics.api.calls.filter(
      call => (now - call.timestamp) < DAY_MS
    );
    
    // 系统事件保留3天
    this.metrics.system.events = this.metrics.system.events.filter(
      event => (now - event.timestamp) < (3 * DAY_MS)
    );
  }
  
  /**
   * 停止服务
   */
  shutdown() {
    clearInterval(this.cleanupInterval);
    logger.info('性能监控服务已关闭');
  }
}

// 导出单例
const performanceMonitoringService = new PerformanceMonitoringService();
module.exports = performanceMonitoringService; 