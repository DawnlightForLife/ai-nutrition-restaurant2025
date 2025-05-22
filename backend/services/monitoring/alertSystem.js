/**
 * 实时告警系统服务模块
 * 用于监控数据库查询性能、系统资源、连接和复制延迟等问题
 * 支持基于规则和统计模型的异常检测，提供多种告警级别
 * 可扩展通知通道，供管理后台使用
 * @module services/core/alertSystem
 */

const EventEmitter = require('events');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../../config');

/**
 * 告警级别枚举
 * @enum {string}
 */
const AlertLevel = {
  INFO: 'INFO',         // 信息性提示
  WARNING: 'WARNING',   // 警告
  ERROR: 'ERROR',       // 错误
  CRITICAL: 'CRITICAL'  // 严重错误
};

/**
 * 告警类型枚举
 * @enum {string}
 */
const AlertType = {
  QUERY_PERFORMANCE: 'QUERY_PERFORMANCE',   // 查询性能问题
  SYSTEM_RESOURCE: 'SYSTEM_RESOURCE',       // 系统资源问题
  SECURITY: 'SECURITY',                     // 安全问题
  DATA_CONSISTENCY: 'DATA_CONSISTENCY',     // 数据一致性问题
  CONNECTION: 'CONNECTION',                 // 连接问题
  REPLICA_SYNC: 'REPLICA_SYNC'              // 副本同步问题
};

class AlertSystem extends EventEmitter {
  constructor() {
    super();
    
    // 配置
    this.config = {
      enabled: config.monitoring?.enableAlerts || true,
      alertsHistorySize: config.monitoring?.alertsHistorySize || 100,
      checkIntervalMs: config.monitoring?.alertCheckIntervalMs || 60000, // 1分钟
      queryPerformanceThresholds: {
        slowQueryMs: config.monitoring?.slowQueryThresholdMs || 500,
        verySlowQueryMs: config.monitoring?.verySlowQueryThresholdMs || 2000,
        criticalQueryMs: config.monitoring?.criticalQueryThresholdMs || 10000
      },
      resourceThresholds: {
        cpuWarning: config.monitoring?.cpuWarningThreshold || 0.7, // 70%
        cpuCritical: config.monitoring?.cpuCriticalThreshold || 0.9, // 90%
        memoryWarning: config.monitoring?.memoryWarningThreshold || 0.7,
        memoryCritical: config.monitoring?.memoryCriticalThreshold || 0.9,
        diskWarning: config.monitoring?.diskWarningThreshold || 0.8,
        diskCritical: config.monitoring?.diskCriticalThreshold || 0.95
      },
      enableNotifications: config.monitoring?.enableNotifications || false,
      notificationChannels: config.monitoring?.notificationChannels || ['log'],
      ruleBasedDetection: config.monitoring?.enableRuleBasedDetection || true,
      anomalyDetection: config.monitoring?.enableAnomalyDetection || false
    };
    
    // 告警历史
    this.alertHistory = [];
    
    // 查询性能记录
    this.queryStats = {
      totalQueries: 0,
      slowQueries: 0,
      verySlowQueries: 0,
      criticalQueries: 0,
      recentQueries: [], // 最近的查询样本
      queryPatterns: new Map(), // 查询模式统计
      avgQueryTime: 0
    };
    
    // 系统资源监控
    this.systemStats = {
      cpu: 0,
      memory: 0,
      disk: 0,
      connections: 0,
      history: []
    };
    
    // 异常检测状态
    this.anomalyState = {
      baselineEstablished: false,
      queryTimeBaseline: null,
      stdDeviation: null,
      lastModelUpdate: null
    };
    
    // 检查定时器
    this.checkTimer = null;
    
    // 初始化
    if (this.config.enabled) {
      this._startMonitoring();
      logger.info('实时告警系统已初始化');
    }
  }
  
  /**
   * 开始监控
   * @private
   */
  _startMonitoring() {
    // 开始定期检查
    this.checkTimer = setInterval(() => {
      this._checkThresholds();
    }, this.config.checkIntervalMs);
    
    // MongoDB命令监听器
    if (mongoose.connection.readyState === 1) {
      this._setupMongoCommandMonitor();
    } else {
      mongoose.connection.once('connected', () => {
        this._setupMongoCommandMonitor();
      });
    }
    
    logger.info('告警系统监控已启动');
  }
  
  /**
   * 设置MongoDB命令监控
   * @private
   * @throws {Error} 当MongoDB连接失败或状态不可用时抛出
   */
  _setupMongoCommandMonitor() {
    try {
      const db = mongoose.connection.db;
      
      // 监听数据库命令
      mongoose.connection.on('commandStarted', (event) => {
        const command = event.commandName;
        const startTime = Date.now();
        
        // 存储命令开始时间
        event._alertSysStartTime = startTime;
      });
      
      mongoose.connection.on('commandSucceeded', (event) => {
        if (!event._alertSysStartTime) return;
        
        const endTime = Date.now();
        const duration = endTime - event._alertSysStartTime;
        const command = event.commandName;
        
        // 分析查询性能
        if (['find', 'aggregate', 'count', 'distinct'].includes(command)) {
          this._analyzeQueryPerformance(command, duration, event.command);
        }
      });
      
      mongoose.connection.on('commandFailed', (event) => {
        // 记录失败的命令
        const command = event.commandName;
        const error = event.failure;
        
        this.triggerAlert({
          type: AlertType.QUERY_PERFORMANCE,
          level: AlertLevel.ERROR,
          message: `数据库命令 ${command} 执行失败`,
          details: {
            command: command,
            error: error.message,
            code: error.code
          }
        });
      });
    } catch (error) {
      logger.error('设置MongoDB命令监控时出错', { error });
    }
  }
  
  /**
   * 分析查询性能
   * @private
   * @param {string} command - 命令名称
   * @param {number} duration - 执行时间(毫秒)
   * @param {Object} commandObj - 命令对象
   * @throws {Error} 当分析查询性能时发生错误
   */
  _analyzeQueryPerformance(command, duration, commandObj) {
    // 更新统计信息
    this.queryStats.totalQueries++;
    this.queryStats.avgQueryTime = (this.queryStats.avgQueryTime * (this.queryStats.totalQueries - 1) + duration) / this.queryStats.totalQueries;
    
    // 生成查询指纹
    const fingerprint = this._generateQueryFingerprint(command, commandObj);
    
    // 更新查询模式统计
    if (!this.queryStats.queryPatterns.has(fingerprint)) {
      this.queryStats.queryPatterns.set(fingerprint, {
        count: 0,
        totalDuration: 0,
        avgDuration: 0,
        maxDuration: 0,
        minDuration: Infinity,
        lastSeen: null
      });
    }
    
    const patternStats = this.queryStats.queryPatterns.get(fingerprint);
    patternStats.count++;
    patternStats.totalDuration += duration;
    patternStats.avgDuration = patternStats.totalDuration / patternStats.count;
    patternStats.maxDuration = Math.max(patternStats.maxDuration, duration);
    patternStats.minDuration = Math.min(patternStats.minDuration, duration);
    patternStats.lastSeen = new Date();
    
    // 保存最近查询
    this.queryStats.recentQueries.push({
      command,
      fingerprint,
      duration,
      timestamp: new Date()
    });
    
    // 限制最近查询列表大小
    if (this.queryStats.recentQueries.length > 100) {
      this.queryStats.recentQueries.shift();
    }
    
    // 根据持续时间检查是否为慢查询
    if (duration >= this.config.queryPerformanceThresholds.criticalQueryMs) {
      this.queryStats.criticalQueries++;
      this.triggerAlert({
        type: AlertType.QUERY_PERFORMANCE,
        level: AlertLevel.CRITICAL,
        message: `检测到严重慢查询: ${command} (${duration}ms)`,
        details: {
          command,
          fingerprint,
          duration,
          threshold: this.config.queryPerformanceThresholds.criticalQueryMs
        }
      });
    } else if (duration >= this.config.queryPerformanceThresholds.verySlowQueryMs) {
      this.queryStats.verySlowQueries++;
      this.triggerAlert({
        type: AlertType.QUERY_PERFORMANCE,
        level: AlertLevel.ERROR,
        message: `检测到非常慢的查询: ${command} (${duration}ms)`,
        details: {
          command,
          fingerprint,
          duration,
          threshold: this.config.queryPerformanceThresholds.verySlowQueryMs
        }
      });
    } else if (duration >= this.config.queryPerformanceThresholds.slowQueryMs) {
      this.queryStats.slowQueries++;
      this.triggerAlert({
        type: AlertType.QUERY_PERFORMANCE,
        level: AlertLevel.WARNING,
        message: `检测到慢查询: ${command} (${duration}ms)`,
        details: {
          command,
          fingerprint,
          duration,
          threshold: this.config.queryPerformanceThresholds.slowQueryMs
        }
      });
    }
    
    // 执行异常检测（如果启用）
    if (this.config.anomalyDetection) {
      this._detectQueryAnomalies(command, fingerprint, duration);
    }
  }
  
  /**
   * 生成查询指纹（用于标识相似查询）
   * @private
   * @param {string} command - 命令名称
   * @param {Object} commandObj - 命令对象
   * @returns {string} 查询指纹
   * @throws {Error} 当生成指纹时发生错误
   */
  _generateQueryFingerprint(command, commandObj) {
    try {
      // 简化版，实际中需要更复杂的逻辑来处理各种查询模式
      let fingerprint = command;
      
      // 处理查询对象
      if (command === 'find' && commandObj.filter) {
        // 提取查询的字段名但忽略值
        const fields = Object.keys(commandObj.filter).sort();
        fingerprint += `:${fields.join(',')}`;
      } else if (command === 'aggregate' && Array.isArray(commandObj.pipeline)) {
        // 提取聚合管道的操作符
        const stages = commandObj.pipeline.map(stage => {
          const opName = Object.keys(stage)[0];
          return opName;
        });
        fingerprint += `:${stages.join(',')}`;
      }
      
      return fingerprint;
    } catch (error) {
      logger.error('生成查询指纹时出错', { error });
      return `${command}:unknown`;
    }
  }
  
  /**
   * 检测查询异常
   * @private
   * @param {string} command - 命令名称
   * @param {string} fingerprint - 查询指纹
   * @param {number} duration - 执行时间(毫秒)
   * @throws {Error} 当检测查询异常时发生错误
   */
  _detectQueryAnomalies(command, fingerprint, duration) {
    // 如果还没有足够的数据建立基线，直接返回
    if (this.queryStats.totalQueries < 50) {
      return;
    }
    
    // 更新或建立基线
    if (!this.anomalyState.baselineEstablished || 
        !this.anomalyState.lastModelUpdate || 
        Date.now() - this.anomalyState.lastModelUpdate > 3600000) { // 1小时更新一次
      this._updateAnomalyBaseline();
    }
    
    // 如果已经建立基线，检查是否异常
    if (this.anomalyState.baselineEstablished) {
      const patternStats = this.queryStats.queryPatterns.get(fingerprint);
      
      // 如果这是一个新的查询模式，还没有足够的数据分析
      if (patternStats.count < 5) {
        return;
      }
      
      // 使用Z分数检测异常
      const zScore = (duration - patternStats.avgDuration) / this.anomalyState.stdDeviation;
      
      // Z分数超过3被认为是异常
      if (zScore > 3) {
        this.triggerAlert({
          type: AlertType.QUERY_PERFORMANCE,
          level: AlertLevel.WARNING,
          message: `检测到查询性能异常: ${command} (${duration}ms, Z分数: ${zScore.toFixed(2)})`,
          details: {
            command,
            fingerprint,
            duration,
            avgDuration: patternStats.avgDuration,
            zScore,
            anomalyScore: zScore
          }
        });
      }
    }
  }
  
  /**
   * 更新异常检测基线
   * @private
   * @throws {Error} 当更新异常检测基线时发生错误
   */
  _updateAnomalyBaseline() {
    try {
      // 计算所有查询的标准偏差
      const durations = this.queryStats.recentQueries.map(q => q.duration);
      const mean = durations.reduce((sum, val) => sum + val, 0) / durations.length;
      const squareDiffs = durations.map(val => Math.pow(val - mean, 2));
      const variance = squareDiffs.reduce((sum, val) => sum + val, 0) / squareDiffs.length;
      const stdDeviation = Math.sqrt(variance);
      
      this.anomalyState.queryTimeBaseline = mean;
      this.anomalyState.stdDeviation = stdDeviation;
      this.anomalyState.baselineEstablished = true;
      this.anomalyState.lastModelUpdate = Date.now();
      
      logger.debug('更新查询性能异常检测基线', {
        mean,
        stdDeviation,
        sampleSize: durations.length
      });
    } catch (error) {
      logger.error('更新异常检测基线时出错', { error });
    }
  }
  
  /**
   * 检查阈值
   * @private
   * @throws {Error} 当检查阈值时发生错误
   */
  _checkThresholds() {
    try {
      // 系统资源检查
      this._checkSystemResources();
      
      // 数据库连接检查
      this._checkDatabaseConnections();
      
      // 副本集延迟检查
      this._checkReplicaSetLag();
      
      // 检查查询模式
      this._checkQueryPatterns();
    } catch (error) {
      logger.error('检查阈值时出错', { error });
    }
  }
  
  /**
   * 检查系统资源
   * @private
   * @throws {Error} 当检查系统资源时发生错误
   */
  async _checkSystemResources() {
    // 此处实现系统资源监控逻辑
    // 例如，检查CPU、内存、磁盘使用情况
    // 这里只是一个模拟实现
    const cpuUsage = Math.random(); // 模拟值
    const memoryUsage = Math.random(); // 模拟值
    const diskUsage = Math.random() * 0.7; // 模拟值
    
    this.systemStats.cpu = cpuUsage;
    this.systemStats.memory = memoryUsage;
    this.systemStats.disk = diskUsage;
    
    // 保存历史记录
    this.systemStats.history.push({
      timestamp: new Date(),
      cpu: cpuUsage,
      memory: memoryUsage,
      disk: diskUsage
    });
    
    // 限制历史记录数量
    if (this.systemStats.history.length > 100) {
      this.systemStats.history.shift();
    }
    
    // 检查阈值
    if (cpuUsage >= this.config.resourceThresholds.cpuCritical) {
      this.triggerAlert({
        type: AlertType.SYSTEM_RESOURCE,
        level: AlertLevel.CRITICAL,
        message: `CPU使用率严重超标: ${(cpuUsage * 100).toFixed(1)}%`,
        details: {
          metric: 'cpu',
          value: cpuUsage,
          threshold: this.config.resourceThresholds.cpuCritical
        }
      });
    } else if (cpuUsage >= this.config.resourceThresholds.cpuWarning) {
      this.triggerAlert({
        type: AlertType.SYSTEM_RESOURCE,
        level: AlertLevel.WARNING,
        message: `CPU使用率过高: ${(cpuUsage * 100).toFixed(1)}%`,
        details: {
          metric: 'cpu',
          value: cpuUsage,
          threshold: this.config.resourceThresholds.cpuWarning
        }
      });
    }
    
    // 内存和磁盘检查也类似...
  }
  
  /**
   * 检查数据库连接
   * @private
   * @throws {Error} 当检查数据库连接时发生错误
   */
  async _checkDatabaseConnections() {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        return;
      }
      
      const db = mongoose.connection.db;
      const adminDb = db.admin();
      
      // 获取服务器状态
      const status = await adminDb.serverStatus();
      
      if (status.connections) {
        const { current, available, totalCreated } = status.connections;
        const connectionUtilization = available > 0 ? current / (current + available) : 0;
        
        this.systemStats.connections = current;
        
        // 检查连接数是否过高
        if (connectionUtilization > 0.8) {
          this.triggerAlert({
            type: AlertType.CONNECTION,
            level: AlertLevel.WARNING,
            message: `数据库连接使用率过高: ${(connectionUtilization * 100).toFixed(1)}%`,
            details: {
              current,
              available,
              utilization: connectionUtilization
            }
          });
        }
      }
    } catch (error) {
      logger.error('检查数据库连接时出错', { error });
    }
  }
  
  /**
   * 检查副本集延迟
   * @private
   * @throws {Error} 当检查副本集延迟时发生错误
   */
  async _checkReplicaSetLag() {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        return;
      }
      
      const db = mongoose.connection.db;
      const adminDb = db.admin();
      
      // 获取复制集状态
      const status = await adminDb.command({ replSetGetStatus: 1 }).catch(() => null);
      
      if (!status || !status.members || status.members.length <= 1) {
        // 非复制集环境
        return;
      }
      
      // 找到主节点
      const primary = status.members.find(m => m.state === 1);
      if (!primary) return;
      
      // 检查每个从节点的延迟
      for (const member of status.members) {
        if (member.state !== 2) continue; // 只检查从节点
        
        const lagMillis = member.optimeDate 
          ? (primary.optimeDate.getTime() - member.optimeDate.getTime()) 
          : 0;
          
        // 检查延迟是否过大
        if (lagMillis > 60000) { // 1分钟
          this.triggerAlert({
            type: AlertType.REPLICA_SYNC,
            level: AlertLevel.ERROR,
            message: `副本节点 ${member.name} 同步延迟过大: ${Math.round(lagMillis / 1000)}秒`,
            details: {
              host: member.name,
              lagMillis,
              primaryHost: primary.name
            }
          });
        } else if (lagMillis > 10000) { // 10秒
          this.triggerAlert({
            type: AlertType.REPLICA_SYNC,
            level: AlertLevel.WARNING,
            message: `副本节点 ${member.name} 同步延迟: ${Math.round(lagMillis / 1000)}秒`,
            details: {
              host: member.name,
              lagMillis,
              primaryHost: primary.name
            }
          });
        }
      }
    } catch (error) {
      logger.error('检查副本集延迟时出错', { error });
    }
  }
  
  /**
   * 检查查询模式
   * @private
   * @throws {Error} 当检查查询模式时发生错误
   */
  _checkQueryPatterns() {
    // 查找最频繁但很慢的查询模式
    const problematicPatterns = [];
    
    for (const [fingerprint, stats] of this.queryStats.queryPatterns.entries()) {
      // 查询次数足够多，且平均执行时间较慢
      if (stats.count > 50 && stats.avgDuration > this.config.queryPerformanceThresholds.slowQueryMs) {
        problematicPatterns.push({
          fingerprint,
          count: stats.count,
          avgDuration: stats.avgDuration,
          totalDuration: stats.totalDuration
        });
      }
    }
    
    // 按总耗时排序
    problematicPatterns.sort((a, b) => b.totalDuration - a.totalDuration);
    
    // 为最严重的前3个模式触发告警
    for (let i = 0; i < Math.min(3, problematicPatterns.length); i++) {
      const pattern = problematicPatterns[i];
      
      this.triggerAlert({
        type: AlertType.QUERY_PERFORMANCE,
        level: AlertLevel.WARNING,
        message: `发现性能问题查询模式: ${pattern.fingerprint}`,
        details: {
          fingerprint: pattern.fingerprint,
          executionCount: pattern.count,
          avgDuration: pattern.avgDuration,
          totalDuration: pattern.totalDuration,
          recommendation: '考虑为此查询模式创建索引或优化查询'
        }
      });
    }
  }
  
  /**
   * 触发告警
   * @param {Object} alert - 告警信息
   * @param {string} alert.type - 告警类型
   * @param {string} alert.level - 告警级别
   * @param {string} alert.message - 告警消息
   * @param {Object} alert.details - 告警详情
   * @throws {Error} 当触发告警时发生错误
   */
  triggerAlert(alert) {
    if (!this.config.enabled) return;
    
    const fullAlert = {
      ...alert,
      timestamp: new Date(),
      id: `alert_${Date.now()}_${Math.random().toString(36).substring(2, 10)}`
    };
    
    // 记录到历史
    this.alertHistory.unshift(fullAlert);
    
    // 限制历史大小
    if (this.alertHistory.length > this.config.alertsHistorySize) {
      this.alertHistory.pop();
    }
    
    // 记录到日志
    const logMethod = 
      fullAlert.level === AlertLevel.CRITICAL ? 'error' :
      fullAlert.level === AlertLevel.ERROR ? 'error' :
      fullAlert.level === AlertLevel.WARNING ? 'warn' : 'info';
    
    logger[logMethod](`[告警] ${fullAlert.message}`, fullAlert.details);
    
    // 发送事件
    this.emit('alert', fullAlert);
    this.emit(`alert:${fullAlert.type}`, fullAlert);
    this.emit(`alert:${fullAlert.level}`, fullAlert);
    
    // 发送通知（如果启用）
    if (this.config.enableNotifications) {
      this._sendNotification(fullAlert);
    }
  }
  
  /**
   * 发送通知
   * @private
   * @param {Object} alert - 告警信息
   * @throws {Error} 当发送通知时发生错误
   */
  _sendNotification(alert) {
    // 这里实现通知逻辑
    // 可以发送邮件、短信、推送等
    // 这个示例只记录日志
    logger.info(`[通知] 告警: ${alert.message}`);
  }
  
  /**
   * 获取告警历史
   * @param {Object} filter - 筛选条件
   * @returns {Array} 告警历史
   * @throws {Error} 当获取告警历史时发生错误
   */
  getAlertHistory(filter = {}) {
    let result = [...this.alertHistory];
    
    if (filter.level) {
      result = result.filter(alert => alert.level === filter.level);
    }
    
    if (filter.type) {
      result = result.filter(alert => alert.type === filter.type);
    }
    
    if (filter.startDate) {
      const startDate = new Date(filter.startDate);
      result = result.filter(alert => alert.timestamp >= startDate);
    }
    
    if (filter.endDate) {
      const endDate = new Date(filter.endDate);
      result = result.filter(alert => alert.timestamp <= endDate);
    }
    
    if (filter.limit) {
      result = result.slice(0, filter.limit);
    }
    
    return result;
  }
  
  /**
   * 获取查询性能统计
   * @returns {Object} 查询性能统计
   * @throws {Error} 当获取查询性能统计时发生错误
   */
  getQueryStats() {
    // 计算慢查询百分比
    const slowQueryPercentage = this.queryStats.totalQueries > 0 ? 
      ((this.queryStats.slowQueries + this.queryStats.verySlowQueries + this.queryStats.criticalQueries) / this.queryStats.totalQueries) * 100 : 0;
    
    // 获取最慢的查询模式
    const slowestPatterns = [];
    for (const [fingerprint, stats] of this.queryStats.queryPatterns.entries()) {
      if (stats.count >= 5) { // 只考虑执行次数足够多的查询
        slowestPatterns.push({
          fingerprint,
          avgDuration: stats.avgDuration,
          count: stats.count,
          maxDuration: stats.maxDuration,
          lastSeen: stats.lastSeen
        });
      }
    }
    
    // 按平均执行时间排序
    slowestPatterns.sort((a, b) => b.avgDuration - a.avgDuration);
    
    return {
      totalQueries: this.queryStats.totalQueries,
      slowQueries: this.queryStats.slowQueries,
      verySlowQueries: this.queryStats.verySlowQueries,
      criticalQueries: this.queryStats.criticalQueries,
      avgQueryTime: this.queryStats.avgQueryTime,
      slowQueryPercentage: slowQueryPercentage.toFixed(2),
      patternCount: this.queryStats.queryPatterns.size,
      slowestPatterns: slowestPatterns.slice(0, 10) // 前10个最慢的查询模式
    };
  }
  
  /**
   * 获取系统资源统计
   * @returns {Object} 系统资源统计
   * @throws {Error} 当获取系统资源统计时发生错误
   */
  getSystemStats() {
    return {
      currentStats: {
        cpu: this.systemStats.cpu,
        memory: this.systemStats.memory,
        disk: this.systemStats.disk,
        connections: this.systemStats.connections
      },
      history: this.systemStats.history.slice(-20) // 最近20条记录
    };
  }
  
  /**
   * 获取服务状态
   * @returns {Object} 服务状态
   * @throws {Error} 当获取服务状态时发生错误
   */
  getStatus() {
    return {
      enabled: this.config.enabled,
      alertCount: this.alertHistory.length,
      recentAlerts: this.alertHistory.slice(0, 5),
      queryStats: {
        totalQueries: this.queryStats.totalQueries,
        slowQueries: this.queryStats.slowQueries,
        verySlowQueries: this.queryStats.verySlowQueries,
        criticalQueries: this.queryStats.criticalQueries,
        avgQueryTime: this.queryStats.avgQueryTime
      },
      systemStats: {
        cpu: this.systemStats.cpu,
        memory: this.systemStats.memory,
        disk: this.systemStats.disk,
        connections: this.systemStats.connections
      },
      anomalyDetection: {
        enabled: this.config.anomalyDetection,
        baselineEstablished: this.anomalyState.baselineEstablished
      }
    };
  }
}

// 创建单例
const alertSystem = new AlertSystem();

// 导出服务和告警枚举类型，供外部模块使用
module.exports = {
  alertSystem,
  AlertLevel,
  AlertType
};