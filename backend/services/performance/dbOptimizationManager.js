/**
 * 数据库优化管理器模块
 * 协调所有数据库优化服务，包括缓存、连接池、批处理、断路器和智能分片等
 * 提供统一接口用于健康检查、自动优化、缓存清理和状态监控
 * 作为单例使用，贯穿整个系统生命周期
 * @module services/core/dbOptimizationManager
 */

const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

// 导入优化服务
const cacheService = require('./cacheService');
const batchProcessService = require('./batchProcessService');
const adaptiveShardingService = require('./adaptiveShardingService');
const connectionPoolManager = require('./connectionPoolManager');
const { circuitBreakerService } = require('../core/circuitBreakerService');

// 导入模型工厂
const ModelFactory = require('../../models/modelFactory');

class DbOptimizationManager {
  constructor() {
    this.services = {
      cache: cacheService,
      batch: batchProcessService,
      sharding: adaptiveShardingService,
      connectionPool: connectionPoolManager,
      circuitBreaker: circuitBreakerService
    };
    
    this.config = {
      enabled: true,
      healthCheckInterval: 5 * 60 * 1000, // 5分钟
      autoOptimize: config.database && config.database.autoOptimize
    };
    
    // 记录状态
    this.status = {
      initialized: false,
      lastHealthCheck: null,
      serviceStatus: {},
      optimization: {
        lastRun: null,
        recommendations: null
      }
    };
  }
  
  /**
   * 初始化所有优化服务
   * @returns {Promise<boolean>} 是否成功初始化
   */
  async initialize() {
    try {
      logger.info('初始化数据库优化管理器...');
      
      // 初始化缓存服务
      if (config.cache && config.cache.enabled) {
        await cacheService.initialize();
        logger.info('缓存服务已初始化');
      }
      
      // 设置定期健康检查
      setInterval(() => {
        this.runHealthCheck().catch(err =>
          logger.error('健康检查失败', { error: err })
        );
      }, this.config.healthCheckInterval);
      
      // 设置定期优化
      if (this.config.autoOptimize) {
        setInterval(() => {
          this.runAutoOptimization().catch(err =>
            logger.error('自动优化失败', { error: err })
          );
        }, 24 * 60 * 60 * 1000); // 每天运行一次
      }
      
      this.status.initialized = true;
      logger.info('数据库优化管理器初始化完成');
      
      // 运行初始健康检查
      await this.runHealthCheck();
      
      return true;
    } catch (error) {
      logger.error('初始化数据库优化管理器失败', { error });
      return false;
    }
  }
  
  /**
   * 运行健康检查
   * @returns {Promise<Object>} 健康状态
   */
  async runHealthCheck() {
    try {
      const now = Date.now();
      logger.info('开始数据库优化服务健康检查...');
      
      // 检查缓存服务
      const cacheStatus = cacheService.enabled ? {
        healthy: cacheService.initialized,
        stats: cacheService.getStats()
      } : { enabled: false };
      
      // 检查批处理服务
      const batchStatus = {
        healthy: true,
        stats: batchProcessService.getStats()
      };
      
      // 检查分片服务
      const shardingStatus = config.database.enableAdaptiveSharding ? {
        healthy: true,
        stats: adaptiveShardingService.getStats()
      } : { enabled: false };
      
      // 检查连接池管理
      const connectionPoolStatus = config.database.enableAutoScaling ? {
        healthy: true,
        stats: connectionPoolManager.getStatus()
      } : { enabled: false };
      
      // 检查断路器服务
      const circuitBreakerStatus = config.faultTolerance && config.faultTolerance.enabled ? {
        healthy: true,
        stats: circuitBreakerService.getAllBreakerStatus()
      } : { enabled: false };
      
      // 更新状态
      this.status.lastHealthCheck = now;
      this.status.serviceStatus = {
        cache: cacheStatus,
        batch: batchStatus,
        sharding: shardingStatus,
        connectionPool: connectionPoolStatus,
        circuitBreaker: circuitBreakerStatus
      };
      
      // 记录健康检查结果
      logger.info('数据库优化服务健康检查完成');
      
      return this.status.serviceStatus;
    } catch (error) {
      logger.error('健康检查出错', { error });
      throw error;
    }
  }
  
  /**
   * 运行自动优化
   * @returns {Promise<Object>} 优化结果
   */
  async runAutoOptimization() {
    try {
      const now = Date.now();
      logger.info('开始数据库自动优化...');
      
      // 1. 运行分片键分析
      let shardingRecommendations = null;
      if (config.database.enableAdaptiveSharding) {
        shardingRecommendations = await adaptiveShardingService.analyzeAllCollections();
        logger.info('分片键分析完成');
      }
      
      // 2. 优化连接池大小
      if (config.database.enableAutoScaling) {
        await connectionPoolManager._evaluatePoolSizes();
        logger.info('连接池大小优化完成');
      }
      
      // 3. 清理过期缓存
      if (config.cache && config.cache.enabled) {
        // 暂无自动清理逻辑，依赖Redis TTL
        logger.info('缓存清理依赖Redis TTL机制');
      }
      
      // 4. 刷新所有批处理操作
      await batchProcessService.flushAll();
      logger.info('批处理操作刷新完成');
      
      // 更新状态
      this.status.optimization = {
        lastRun: now,
        recommendations: {
          sharding: shardingRecommendations
        }
      };
      
      logger.info('数据库自动优化完成');
      
      return this.status.optimization;
    } catch (error) {
      logger.error('自动优化出错', { error });
      throw error;
    }
  }
  
  /**
   * 获取管理器状态
   * @returns {Object} 状态信息
   */
  getStatus() {
    return {
      initialized: this.status.initialized,
      lastHealthCheck: this.status.lastHealthCheck,
      services: {
        cache: {
          enabled: config.cache && config.cache.enabled,
          initialized: cacheService.initialized
        },
        batch: {
          enabled: config.database && config.database.enableBatchProcessing,
          queues: batchProcessService.getStats().currentQueueCount
        },
        sharding: {
          enabled: config.database && config.database.enableAdaptiveSharding,
          analyzed: adaptiveShardingService.getStats().totalCollectionsAnalyzed
        },
        connectionPool: {
          enabled: config.database && config.database.enableAutoScaling
        },
        circuitBreaker: {
          enabled: config.faultTolerance && config.faultTolerance.enabled,
          breakerCount: circuitBreakerService.getAllBreakerStatus().breakerCount
        }
      },
      modelStats: ModelFactory.getModelStats(),
      optimization: this.status.optimization
    };
  }
  
  /**
   * 强制刷新所有批处理操作
   * @returns {Promise<boolean>} 是否成功
   */
  async flushAllBatches() {
    try {
      await batchProcessService.flushAll();
      logger.info('所有批处理操作已强制执行');
      return true;
    } catch (error) {
      logger.error('强制执行批处理操作时出错', { error });
      return false;
    }
  }
  
  /**
   * 清除所有缓存
   * @returns {Promise<boolean>} 是否成功
   */
  async clearAllCaches() {
    try {
      if (!cacheService.enabled || !cacheService.initialized) {
        return false;
      }
      
      await cacheService.clearPattern('*');
      await ModelFactory.clearAllModelCaches();
      
      logger.info('所有缓存已清除');
      return true;
    } catch (error) {
      logger.error('清除所有缓存时出错', { error });
      return false;
    }
  }
  
  /**
   * 重置所有断路器
   * @returns {Promise<boolean>} 是否成功
   */
  async resetAllCircuitBreakers() {
    try {
      if (!config.faultTolerance || !config.faultTolerance.enabled) {
        return false;
      }
      
      const status = circuitBreakerService.getAllBreakerStatus();
      const breakerNames = Object.keys(status.breakers || {});
      
      for (const name of breakerNames) {
        circuitBreakerService.resetBreaker(name);
      }
      
      logger.info(`已重置 ${breakerNames.length} 个断路器`);
      return true;
    } catch (error) {
      logger.error('重置断路器时出错', { error });
      return false;
    }
  }
}

// 创建单例
const dbOptimizationManager = new DbOptimizationManager();

module.exports = dbOptimizationManager; 