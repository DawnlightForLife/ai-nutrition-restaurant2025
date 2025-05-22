/**
 * MongoDB 连接池动态管理服务
 * 根据系统负载和连接使用情况，自动扩缩 MongoDB 的读写连接池大小
 * 支持手动调整、监控 CPU 与连接利用率、冷却期机制等
 * 本模块设计为单例，确保全局唯一连接池管理器
 * @module services/core/connectionPoolManager
 */

/**
 * 连接池管理服务
 * 根据系统负载自动调整MongoDB连接池大小
 */

const os = require('os');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

class ConnectionPoolManager {
  constructor() {
    // 连接池配置
    this.config = {
      enabled: config.database && config.database.enableAutoScaling,
      checkInterval: 60000, // 每分钟检查一次
      minPoolSize: (config.database && config.database.minPoolSize) || 5,
      maxPoolSize: (config.database && config.database.maxPoolSize) || 100,
      targetUtilization: 0.7, // 目标连接池利用率
      scaleUpThreshold: 0.8,  // 扩容阈值
      scaleDownThreshold: 0.3, // 缩容阈值
      scaleUpFactor: 1.5,     // 扩容系数
      scaleDownFactor: 0.7,   // 缩容系数
      readRatio: 0.7,         // 读连接占比
      cooldownPeriod: 300000  // 操作冷却期，5分钟
    };
    
    // 连接池状态
    this.state = {
      currentReadPoolSize: this.config.minPoolSize,
      currentWritePoolSize: this.config.minPoolSize,
      currentUtilization: 0,
      activeConnections: 0,
      lastScaleTime: 0,
      cpuUsageHistory: [],
      connectionUsageHistory: [],
      systemLoad: {
        cpu: 0,
        memory: 0,
        lastUpdate: 0
      }
    };
    
    // 初始化监控
    if (this.config.enabled) {
      this._startMonitoring();
    }
  }
  
  /**
   * 开始监控系统负载和连接池
   * @private
   */
  _startMonitoring() {
    // 定期检查系统负载和连接池状态
    setInterval(() => {
      this._updateSystemMetrics();
      this._evaluatePoolSizes();
    }, this.config.checkInterval);
    
    logger.info('连接池自动扩缩功能已启用，检查间隔：', this.config.checkInterval / 1000, '秒');
  }
  
  /**
   * 更新系统指标
   * @private
   */
  _updateSystemMetrics() {
    try {
      // 获取CPU使用率
      const cpus = os.cpus();
      const totalCpu = cpus.reduce((acc, cpu) => {
        acc.idle += cpu.times.idle;
        acc.total += Object.values(cpu.times).reduce((sum, time) => sum + time, 0);
        return acc;
      }, { idle: 0, total: 0 });
      
      let cpuUsage = 0;
      if (this.state.systemLoad.lastUpdate > 0) {
        const idleDiff = totalCpu.idle - this.state.systemLoad.prevCpuIdle;
        const totalDiff = totalCpu.total - this.state.systemLoad.prevCpuTotal;
        cpuUsage = 1 - (idleDiff / totalDiff);
      }
      
      // 保存当前值用于下次比较
      this.state.systemLoad.prevCpuIdle = totalCpu.idle;
      this.state.systemLoad.prevCpuTotal = totalCpu.total;
      
      // 获取内存使用率
      const totalMemory = os.totalmem();
      const freeMemory = os.freemem();
      const memoryUsage = (totalMemory - freeMemory) / totalMemory;
      
      // 获取活动连接数
      const activeConnections = mongoose.connections.reduce((sum, conn) => 
        sum + (conn.client && conn.client.s && conn.client.s.pool ? 
          conn.client.s.pool.totalConnectionCount : 0), 0);
      
      // 计算连接池利用率
      const totalPoolSize = this.state.currentReadPoolSize + this.state.currentWritePoolSize;
      const connectionUtilization = totalPoolSize > 0 ? activeConnections / totalPoolSize : 0;
      
      // 更新状态
      this.state.systemLoad.cpu = cpuUsage;
      this.state.systemLoad.memory = memoryUsage;
      this.state.systemLoad.lastUpdate = Date.now();
      this.state.activeConnections = activeConnections;
      this.state.currentUtilization = connectionUtilization;
      
      // 保存历史数据
      this.state.cpuUsageHistory.push({ timestamp: Date.now(), value: cpuUsage });
      this.state.connectionUsageHistory.push({ timestamp: Date.now(), value: connectionUtilization });
      
      // 限制历史数据量
      if (this.state.cpuUsageHistory.length > 60) {
        this.state.cpuUsageHistory.shift();
      }
      if (this.state.connectionUsageHistory.length > 60) {
        this.state.connectionUsageHistory.shift();
      }
      
      // 记录系统指标日志
      if (config.debug && config.debug.logSystemMetrics) {
        logger.debug('系统指标:', {
          cpu: cpuUsage.toFixed(2),
          memory: memoryUsage.toFixed(2),
          connections: activeConnections,
          utilization: connectionUtilization.toFixed(2)
        });
      }
    } catch (error) {
      logger.error('更新系统指标时出错', { error });
    }
  }
  
  /**
   * 评估并调整连接池大小
   * @private
   */
  _evaluatePoolSizes() {
    try {
      // 检查冷却期
      const now = Date.now();
      if (now - this.state.lastScaleTime < this.config.cooldownPeriod) {
        return;
      }
      
      const currentUtilization = this.state.currentUtilization;
      const currentTotalSize = this.state.currentReadPoolSize + this.state.currentWritePoolSize;
      
      let newTotalSize = currentTotalSize;
      
      // 决策逻辑
      if (currentUtilization > this.config.scaleUpThreshold) {
        // 需要扩容
        newTotalSize = Math.min(
          Math.ceil(currentTotalSize * this.config.scaleUpFactor),
          this.config.maxPoolSize * 2 // 总连接池上限
        );
        
        logger.info(`连接池利用率高 (${currentUtilization.toFixed(2)}), 扩容到 ${newTotalSize}`);
      } else if (currentUtilization < this.config.scaleDownThreshold) {
        // 需要缩容
        newTotalSize = Math.max(
          Math.floor(currentTotalSize * this.config.scaleDownFactor),
          this.config.minPoolSize * 2 // 总连接池下限
        );
        
        logger.info(`连接池利用率低 (${currentUtilization.toFixed(2)}), 缩容到 ${newTotalSize}`);
      } else {
        // 保持不变
        return;
      }
      
      // 如果尺寸有变化，计算读写连接池的分配
      if (newTotalSize !== currentTotalSize) {
        // 根据读写比例分配连接池
        const newReadPoolSize = Math.round(newTotalSize * this.config.readRatio);
        const newWritePoolSize = newTotalSize - newReadPoolSize;
        
        // 应用新的连接池大小
        this._applyNewPoolSizes(newReadPoolSize, newWritePoolSize);
        
        // 更新状态
        this.state.lastScaleTime = now;
      }
    } catch (error) {
      logger.error('评估连接池大小时出错', { error });
    }
  }
  
  /**
   * 应用新的连接池大小设置
   * @param {number} readPoolSize - 读连接池大小
   * @param {number} writePoolSize - 写连接池大小
   * @private
   */
  async _applyNewPoolSizes(readPoolSize, writePoolSize) {
    try {
      // 获取ModelFactory实例
      const ModelFactory = require('../../models/modelFactory');
      
      // 设置新的连接池大小
      await ModelFactory.adjustConnectionPoolSizes({
        readPoolSize,
        writePoolSize
      });
      
      // 更新状态
      this.state.currentReadPoolSize = readPoolSize;
      this.state.currentWritePoolSize = writePoolSize;
      
      logger.info('连接池大小已调整:', { 
        read: readPoolSize, 
        write: writePoolSize, 
        total: readPoolSize + writePoolSize 
      });
    } catch (error) {
      logger.error('应用新连接池大小时出错', { error });
    }
  }
  
  /**
   * 手动设置连接池大小
   * @param {Object} options - 包含读写连接池大小的对象
   * @returns {Promise<boolean>} 是否成功
   */
  async setPoolSizes(options = {}) {
    try {
      const { readPoolSize, writePoolSize } = options;
      
      // 验证参数
      if (!readPoolSize && !writePoolSize) {
        throw new Error('必须指定至少一个连接池大小');
      }
      
      // 应用设置
      const newReadSize = readPoolSize || this.state.currentReadPoolSize;
      const newWriteSize = writePoolSize || this.state.currentWritePoolSize;
      
      await this._applyNewPoolSizes(newReadSize, newWriteSize);
      
      // 重置缩放冷却时间
      this.state.lastScaleTime = Date.now();
      
      return true;
    } catch (error) {
      logger.error('手动设置连接池大小时出错', { error });
      return false;
    }
  }
  
  /**
   * 获取连接池状态
   * @returns {Object} 连接池状态
   */
  getStatus() {
    // 计算平均利用率
    const recentUtilization = this.state.connectionUsageHistory
      .slice(-5)
      .reduce((sum, item) => sum + item.value, 0) / 
      (this.state.connectionUsageHistory.slice(-5).length || 1);
    
    // 计算平均CPU使用率
    const recentCpuUsage = this.state.cpuUsageHistory
      .slice(-5)
      .reduce((sum, item) => sum + item.value, 0) / 
      (this.state.cpuUsageHistory.slice(-5).length || 1);
    
    return {
      enabled: this.config.enabled,
      currentSizes: {
        read: this.state.currentReadPoolSize,
        write: this.state.currentWritePoolSize,
        total: this.state.currentReadPoolSize + this.state.currentWritePoolSize
      },
      utilization: {
        current: this.state.currentUtilization,
        average5min: recentUtilization
      },
      system: {
        cpu: this.state.systemLoad.cpu,
        memory: this.state.systemLoad.memory,
        avgCpu5min: recentCpuUsage
      },
      connections: {
        active: this.state.activeConnections
      },
      limits: {
        min: this.config.minPoolSize,
        max: this.config.maxPoolSize
      },
      lastScaled: this.state.lastScaleTime,
      nextScalePossible: this.state.lastScaleTime + this.config.cooldownPeriod
    };
  }
}

// 创建单例
const connectionPoolManager = new ConnectionPoolManager();

module.exports = connectionPoolManager; 