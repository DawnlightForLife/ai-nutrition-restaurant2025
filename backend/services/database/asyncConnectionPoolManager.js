/**
 * Async Connection Pool Manager
 * 异步数据库连接池管理器
 * - 支持连接池动态扩缩容
 * - 支持自适应预测机制
 * - 提供系统负载监控和自动缩放能力
 * - 提供事件驱动接口（初始化、状态变更、指标更新）
 * @module services/core/asyncConnectionPoolManager
 */

const EventEmitter = require('events');
const mongoose = require('mongoose');
const config = require('../../config');
const logger = require('../../utils/logger/winstonLogger.js');
const os = require('os');

class AsyncConnectionPoolManager extends EventEmitter {
  constructor() {
    super();
    
    // 初始配置
    this.config = {
      enableAutoScaling: config.database.enableAutoScaling || false,
      monitoringInterval: config.database.monitoringIntervalMs || 30000, // 30秒
      minPoolSize: config.database.minPoolSize || 5,
      maxPoolSize: config.database.maxPoolSize || 100,
      scaleUpThreshold: config.database.scaleUpThreshold || 0.7, // 70%使用率时扩容
      scaleDownThreshold: config.database.scaleDownThreshold || 0.3, // 30%使用率时缩容
      historyLength: config.database.metricsHistoryLength || 10,
      predictiveFactor: config.database.predictiveFactor || 0.5 // 预测因子权重
    };
    
    // 状态变量
    this.status = {
      initialized: false,
      poolSize: this.config.minPoolSize,
      activeConnections: 0,
      queryRate: 0,
      lastScaleEvent: null,
      cpuUsage: 0,
      memoryUsage: 0,
      history: []
    };
    
    // 监控定时器
    this.monitorTimer = null;
    
    // 绑定方法
    this._startMonitoring = this._startMonitoring.bind(this);
    this._updateSystemMetricsAsync = this._updateSystemMetricsAsync.bind(this);
    this._getDbStatsAsync = this._getDbStatsAsync.bind(this);
    this._evaluatePoolSizesAsync = this._evaluatePoolSizesAsync.bind(this);
    this._predictFutureLoad = this._predictFutureLoad.bind(this);
    this._applyNewPoolSizesAsync = this._applyNewPoolSizesAsync.bind(this);
    
    logger.info('异步连接池管理器已创建');
  }
  
  /**
   * 初始化连接池管理器
   * - 如果数据库连接已建立，则立即设置连接池初始大小
   * - 启动自动监控（如启用）
   * @returns {Promise<void>}
   * @throws {Error} 初始化失败时抛出异常
   */
  async initialize() {
    try {
      if (this.status.initialized) {
        logger.warn('异步连接池管理器已经初始化过了');
        return;
      }
      
      logger.info('初始化异步连接池管理器...');
      
      // 设置初始连接池大小
      if (mongoose.connection.readyState === 1) {
        await this._applyNewPoolSizesAsync(this.config.minPoolSize);
        logger.info(`初始连接池大小设置为: ${this.config.minPoolSize}`);
      } else {
        logger.warn('MongoDB连接未就绪，将在连接后设置连接池大小');
        mongoose.connection.once('connected', async () => {
          await this._applyNewPoolSizesAsync(this.config.minPoolSize);
          logger.info(`MongoDB连接就绪后设置连接池大小为: ${this.config.minPoolSize}`);
        });
      }
      
      // 开始监控
      if (this.config.enableAutoScaling) {
        this._startMonitoring();
      }
      
      this.status.initialized = true;
      this.emit('initialized', { poolSize: this.status.poolSize });
      logger.info('异步连接池管理器初始化完成');
    } catch (error) {
      logger.error('初始化异步连接池管理器时出错', { error });
      throw error;
    }
  }
  
  /**
   * 开始监控系统负载和连接池大小
   * @private
   */
  _startMonitoring() {
    if (this.monitorTimer) {
      clearInterval(this.monitorTimer);
    }
    
    logger.info(`开始连接池监控，间隔: ${this.config.monitoringInterval}ms`);
    
    // 立即执行一次
    this._updateSystemMetricsAsync().catch(error => {
      logger.error('更新系统指标时出错', { error });
    });
    
    // 设置定时器
    this.monitorTimer = setInterval(() => {
      this._updateSystemMetricsAsync().catch(error => {
        logger.error('更新系统指标时出错', { error });
      });
    }, this.config.monitoringInterval);
    
    this.emit('monitoring_started', { interval: this.config.monitoringInterval });
  }
  
  /**
   * 异步更新系统负载与数据库连接信息
   * - 获取CPU、内存、数据库连接数、查询率等
   * - 更新历史记录并触发事件
   * - 若启用自动扩缩容，将进行连接池评估
   * @private
   * @returns {Promise<void>}
   * @throws {Error} 获取指标或评估失败时抛出
   */
  async _updateSystemMetricsAsync() {
    try {
      // 获取CPU和内存使用情况
      const cpuUsage = os.loadavg()[0] / os.cpus().length; // 归一化CPU负载
      const memUsage = process.memoryUsage().heapUsed / process.memoryUsage().heapTotal;
      
      // 获取数据库统计信息
      const dbStats = await this._getDbStatsAsync();
      
      // 更新当前状态
      const now = Date.now();
      const currentMetrics = {
        timestamp: now,
        cpuUsage,
        memoryUsage: memUsage,
        activeConnections: dbStats.activeConnections,
        queryRate: dbStats.queryRate,
        poolSize: this.status.poolSize
      };
      
      // 添加到历史记录并保持固定长度
      this.status.history.push(currentMetrics);
      if (this.status.history.length > this.config.historyLength) {
        this.status.history.shift();
      }
      
      // 更新当前状态
      this.status.cpuUsage = cpuUsage;
      this.status.memoryUsage = memUsage;
      this.status.activeConnections = dbStats.activeConnections;
      this.status.queryRate = dbStats.queryRate;
      
      // 记录指标
      logger.debug('系统指标已更新', {
        cpuUsage: cpuUsage.toFixed(2),
        memoryUsage: memUsage.toFixed(2),
        activeConnections: dbStats.activeConnections,
        queryRate: dbStats.queryRate,
        poolSize: this.status.poolSize
      });
      
      // 评估是否需要调整连接池大小
      if (this.config.enableAutoScaling) {
        await this._evaluatePoolSizesAsync();
      }
      
      // 发射事件供外部系统监听
      this.emit('metrics_updated', currentMetrics);
    } catch (error) {
      logger.error('更新系统指标时出错', { error });
      throw error;
    }
  }
  
  /**
   * 异步获取数据库统计信息
   * @private
   * @returns {Promise<Object>} 数据库统计信息
   * @throws {Error} 获取数据库统计信息失败时抛出
   */
  async _getDbStatsAsync() {
    try {
      // 使用mongoose获取数据库统计信息
      const db = mongoose.connection.db;
      const adminDb = db.admin();
      
      // 获取服务器状态
      const serverStatus = await adminDb.serverStatus();
      
      // 提取连接信息
      const activeConnections = serverStatus.connections?.current || 0;
      
      // 计算查询率 (如果有上一次记录)
      let queryRate = 0;
      const prevMetrics = this.status.history[this.status.history.length - 1];
      
      if (prevMetrics && serverStatus.opcounters) {
        const totalOps = Object.values(serverStatus.opcounters).reduce((sum, val) => sum + val, 0);
        const prevTotalOps = this.status.totalOps || 0;
        const timeDiff = (Date.now() - (prevMetrics.timestamp || Date.now())) / 1000;
        
        if (timeDiff > 0) {
          queryRate = (totalOps - prevTotalOps) / timeDiff;
        }
        
        // 保存总操作数以便下次计算
        this.status.totalOps = totalOps;
      }
      
      return {
        activeConnections,
        queryRate
      };
    } catch (error) {
      logger.error('获取数据库统计信息时出错', { error });
      // 如果获取失败，返回保守估计
      return {
        activeConnections: this.status.activeConnections || 0,
        queryRate: this.status.queryRate || 0
      };
    }
  }
  
  /**
   * 根据当前与预测负载评估是否需要扩缩容
   * - 计算利用率（当前与预测加权）
   * - 判定是否需扩容或缩容
   * - 若需调整，则调用_applyNewPoolSizesAsync
   * @private
   * @returns {Promise<void>}
   */
  async _evaluatePoolSizesAsync() {
    try {
      if (!this.status.initialized || !this.config.enableAutoScaling) {
        return;
      }
      
      const currentPoolSize = this.status.poolSize;
      const activeConnections = this.status.activeConnections;
      
      // 计算当前利用率
      const utilization = activeConnections / currentPoolSize;
      
      // 预测未来负载
      const predictedLoad = this._predictFutureLoad();
      
      // 计算预测利用率
      const predictedUtilization = predictedLoad / currentPoolSize;
      
      // 根据预测利用率和当前利用率的加权平均计算目标利用率
      const targetUtilization = (utilization * (1 - this.config.predictiveFactor)) + 
                               (predictedUtilization * this.config.predictiveFactor);
      
      // 记录当前利用率
      logger.debug('连接池利用率评估', {
        currentUtilization: utilization.toFixed(2),
        predictedUtilization: predictedUtilization.toFixed(2),
        targetUtilization: targetUtilization.toFixed(2)
      });
      
      // 决定是否需要扩容或缩容
      let newPoolSize = currentPoolSize;
      
      // 避免频繁缩放：如果最后一次缩放操作发生在10分钟内，则不再调整
      const canScale = !this.status.lastScaleEvent || 
                      (Date.now() - this.status.lastScaleEvent) > 10 * 60 * 1000;
      
      if (canScale) {
        if (targetUtilization > this.config.scaleUpThreshold) {
          // 需要扩容
          newPoolSize = Math.min(
            Math.ceil(activeConnections / this.config.scaleUpThreshold),
            this.config.maxPoolSize
          );
          
          if (newPoolSize > currentPoolSize) {
            logger.info(`连接池利用率(${targetUtilization.toFixed(2)})超过扩容阈值(${this.config.scaleUpThreshold})，扩容连接池`);
            await this._applyNewPoolSizesAsync(newPoolSize);
          }
        } else if (targetUtilization < this.config.scaleDownThreshold) {
          // 需要缩容，但确保至少有最小连接数
          newPoolSize = Math.max(
            Math.ceil(activeConnections / this.config.scaleUpThreshold), // 留出余量
            this.config.minPoolSize
          );
          
          if (newPoolSize < currentPoolSize) {
            logger.info(`连接池利用率(${targetUtilization.toFixed(2)})低于缩容阈值(${this.config.scaleDownThreshold})，缩容连接池`);
            await this._applyNewPoolSizesAsync(newPoolSize);
          }
        }
      }
    } catch (error) {
      logger.error('评估连接池大小时出错', { error });
    }
  }
  
  /**
   * 预测未来的活跃连接数
   * - 基于近期查询率变化趋势进行线性预测
   * @private
   * @returns {number} 预测连接数
   */
  _predictFutureLoad() {
    if (this.status.history.length < 2) {
      return this.status.activeConnections;
    }
    
    try {
      // 使用简单线性预测
      // 计算近期查询率和连接使用趋势
      const history = this.status.history;
      
      // 计算最近三次（如果有）的查询率变化率
      const recentRates = history.slice(-3).map(h => h.queryRate);
      let queryRateChangeRatio = 1.0;
      
      // 如果有足够历史数据，计算变化率趋势
      if (recentRates.length >= 2) {
        const rateChanges = [];
        for (let i = 1; i < recentRates.length; i++) {
          const prevRate = recentRates[i-1] || 0.1; // 避免除零
          const change = recentRates[i] / prevRate;
          rateChanges.push(change);
        }
        
        // 计算平均变化率
        queryRateChangeRatio = rateChanges.reduce((sum, val) => sum + val, 0) / rateChanges.length;
      }
      
      // 预测下一个时期的负载
      const predictedLoad = this.status.activeConnections * queryRateChangeRatio;
      
      // 返回预测值，但确保它是个合理的数字
      return isNaN(predictedLoad) || predictedLoad <= 0 ? 
        this.status.activeConnections : 
        predictedLoad;
    } catch (error) {
      logger.error('预测未来负载时出错', { error });
      return this.status.activeConnections; // 出错时返回当前活跃连接数
    }
  }
  
  /**
   * 异步应用新的连接池大小
   * @private
   * @param {number} newSize 新的连接池大小
   * @returns {Promise<void>}
   * @throws {Error} 调整连接池大小失败时抛出
   */
  async _applyNewPoolSizesAsync(newSize) {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        logger.warn('MongoDB连接未就绪，无法调整连接池大小');
        return;
      }
      
      const oldSize = this.status.poolSize;
      
      // 确保大小在范围内
      newSize = Math.max(this.config.minPoolSize, 
                Math.min(newSize, this.config.maxPoolSize));
      
      // 如果大小没变，不执行操作
      if (newSize === oldSize) {
        return;
      }
      
      // 更新Mongoose连接池大小
      const db = mongoose.connection.getClient().db();
      
      // 异步执行命令
      await db.command({ 
        setConnectionPoolSize: 1, 
        size: newSize 
      });
      
      // 更新状态
      this.status.poolSize = newSize;
      this.status.lastScaleEvent = Date.now();
      
      logger.info(`连接池大小从 ${oldSize} 调整为 ${newSize}`);
      
      // 发射事件
      this.emit('pool_size_changed', {
        oldSize,
        newSize,
        timestamp: this.status.lastScaleEvent
      });
    } catch (error) {
      logger.error('应用新连接池大小时出错', { error });
      throw error;
    }
  }
  
  /**
   * 手动设置连接池大小
   * @param {number} size 新的连接池大小
   * @returns {Promise<boolean>} 操作是否成功
   */
  async setPoolSizes(size) {
    try {
      await this._applyNewPoolSizesAsync(size);
      return true;
    } catch (error) {
      logger.error('手动设置连接池大小时出错', { error });
      return false;
    }
  }
  
  /**
   * 优雅地清空连接池
   * @returns {Promise<boolean>} 操作是否成功
   */
  async drainConnections() {
    try {
      if (!mongoose.connection || mongoose.connection.readyState !== 1) {
        logger.warn('MongoDB连接未就绪，无法清空连接池');
        return false;
      }
      
      logger.info('开始清空连接池...');
      
      // 使用MongoDB命令清空连接池
      const db = mongoose.connection.getClient().db();
      await db.command({ connectionPoolClear: 1 });
      
      logger.info('连接池已清空');
      this.emit('pool_drained', { timestamp: Date.now() });
      
      return true;
    } catch (error) {
      logger.error('清空连接池时出错', { error });
      return false;
    }
  }
  
  /**
   * 获取连接池状态
   * @returns {Object} 状态信息
   */
  getStatus() {
    return {
      initialized: this.status.initialized,
      autoScaling: this.config.enableAutoScaling,
      poolSize: this.status.poolSize,
      activeConnections: this.status.activeConnections,
      utilization: this.status.poolSize > 0 ? 
        (this.status.activeConnections / this.status.poolSize).toFixed(2) : 0,
      queryRate: this.status.queryRate.toFixed(2),
      lastScaleEvent: this.status.lastScaleEvent,
      cpuUsage: this.status.cpuUsage.toFixed(2),
      memoryUsage: this.status.memoryUsage.toFixed(2),
      config: {
        minPoolSize: this.config.minPoolSize,
        maxPoolSize: this.config.maxPoolSize,
        scaleUpThreshold: this.config.scaleUpThreshold,
        scaleDownThreshold: this.config.scaleDownThreshold,
        monitoringInterval: this.config.monitoringInterval
      }
    };
  }
}

// 创建单例
const asyncConnectionPoolManager = new AsyncConnectionPoolManager();

module.exports = asyncConnectionPoolManager; 