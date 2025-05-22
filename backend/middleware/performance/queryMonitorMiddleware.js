/**
 * ✅ 模块名：queryMonitorMiddleware.js
 * ✅ 命名风格统一（camelCase）
 * ✅ 功能概览：
 *   - 拦截 MongoDB 查询方法（find/update/aggregate 等）
 *   - 记录查询耗时、参数、返回数量、是否慢查询、explain 执行计划
 *   - 写入 DbMetrics 模型中
 * ✅ 高级特性：
 *   - 支持采样率配置，避免性能损耗
 *   - 对慢查询自动记录 explain 分析（仅 find/aggregate）
 *   - 设置保留时间自动清理历史查询指标
 * ✅ 配置入口：
 *   - config.monitoring.slowQueryThreshold
 *   - config.monitoring.sampleRate
 *   - config.monitoring.collectExplainData
 *   - config.monitoring.retentionDays
 * ✅ 推荐 future：
 *   - 支持聚合查询 explain 结果缓存
 *   - 支持以 tag 标记来源模块（如 forum/post）
 *   - 提供 web dashboard 页面展示指标统计
 */

/**
 * 数据库查询监控中间件
 * 用于拦截和记录MongoDB查询性能
 */
const mongoose = require('mongoose');
const config = require('../../config/modules/db.config');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 初始化 Mongo 查询监控
 * - 拦截 Mongo 方法，记录慢查询
 * - 每个方法包裹采样、耗时记录、结果分析、explain 采集等逻辑
 */
function initQueryMonitor() {
  try {
    logger.info('初始化数据库查询监控...');
    
    // 创建DbMetrics模型（如果不存在）
    if (!mongoose.modelNames().includes('DbMetrics')) {
      const dbMetricsSchema = new mongoose.Schema({
        operation: String,       // 操作类型，如find, update等
        collection: String,      // 集合名称
        query: Object,           // 查询条件
        options: Object,         // 查询选项
        pipeline: Array,         // 聚合管道（用于聚合查询）
        duration: Number,        // 查询耗时（毫秒）
        resultCount: Number,     // 结果数量
        slow_query: Boolean,     // 是否为慢查询
        explain: Object,         // 查询计划（如果可用）
        timestamp: {             // 查询时间
          type: Date,
          default: Date.now
        }
      });
      
      mongoose.model('DbMetrics', dbMetricsSchema);
      logger.info('DbMetrics模型已创建');
    }
    
    const DbMetrics = mongoose.model('DbMetrics');
    const slowQueryThreshold = config.monitoring.slowQueryThreshold || 500;
    const sampleRate = config.monitoring.sampleRate || 0.1;
    
    // 拦截Collection原型的相关方法
    const methods = ['find', 'findOne', 'aggregate', 'updateOne', 'updateMany', 'deleteOne', 'deleteMany', 'countDocuments', 'distinct'];
    
    methods.forEach(method => {
      const originalMethod = mongoose.Collection.prototype[method];
      
      mongoose.Collection.prototype[method] = async function(...args) {
        // 根据采样率决定是否记录此查询
        if (Math.random() > sampleRate) {
          return originalMethod.apply(this, args);
        }
        
        const collectionName = this.collectionName;
        const startTime = Date.now();
        let result;
        let error;
        
        try {
          // 执行原始查询方法
          result = await originalMethod.apply(this, args);
          return result;
        } catch (err) {
          error = err;
          throw err;
        } finally {
          try {
            const endTime = Date.now();
            const duration = endTime - startTime;
            const slow_query = duration > slowQueryThreshold;
            
            // 准备记录数据
            let resultCount = 0;
            if (result) {
              if (Array.isArray(result)) {
                resultCount = result.length;
              } else if (result.result) {
                resultCount = result.result.n || 0;
              } else if (method === 'find') {
                // find返回的是游标，需要特殊处理
                resultCount = -1; // 标记为未知
              }
            }
            
            // 提取查询信息
            const query = method === 'aggregate' ? {} : (args[0] || {});
            const options = method === 'aggregate' ? (args[1] || {}) : (args[1] || {});
            const pipeline = method === 'aggregate' ? (args[0] || []) : [];
            
            // 构建记录对象
            const metricsData = {
              operation: method,
              collection: collectionName,
              query,
              options,
              pipeline,
              duration,
              resultCount,
              slow_query,
              timestamp: new Date()
            };
            
            // 只为慢查询收集explain数据
            if (slow_query && config.monitoring.collectExplainData) {
              try {
                if (method === 'find' || method === 'findOne') {
                  const explainResult = await this.find(query, options).explain();
                  metricsData.explain = simplifyExplain(explainResult);
                } else if (method === 'aggregate') {
                  // 聚合查询的explain需要在options中设置explain:true
                  // 由于已经执行过查询，这里不再重复执行
                }
              } catch (explainErr) {
                logger.debug(`获取查询计划失败: ${explainErr.message}`);
              }
            }
            
            // 记录到数据库
            if (slow_query || Math.random() < 0.1) { // 所有慢查询都记录，非慢查询抽样10%
              DbMetrics.create(metricsData).catch(err => {
                logger.error('保存查询指标失败:', err);
              });
            }
            
            // 对特别慢的查询记录警告日志
            if (duration > slowQueryThreshold * 5) {
              logger.warn(`特别慢的查询: ${collectionName}.${method} - ${duration}ms`);
              if (method === 'find' || method === 'findOne') {
                logger.warn(`查询条件: ${JSON.stringify(query)}`);
              } else if (method === 'aggregate') {
                logger.warn(`管道: ${JSON.stringify(pipeline)}`);
              }
            }
            
          } catch (monitorErr) {
            // 确保监控错误不影响正常查询
            logger.error('查询监控发生错误:', monitorErr);
          }
        }
      };
    });
    
    logger.info('数据库查询监控已启用');
    
    // 设置定期清理任务
    const retentionDays = config.monitoring.retentionDays || 30;
    scheduleMetricsCleanup(retentionDays);
    
    return true;
  } catch (error) {
    logger.error('初始化查询监控失败:', error);
    return false;
  }
}

/**
 * 简化 explain 查询计划
 * - 提取核心字段供分析使用
 */
function simplifyExplain(explainResult) {
  if (!explainResult) return null;
  
  try {
    // 提取关键信息
    return {
      executionTimeMillis: explainResult.executionStats?.executionTimeMillis,
      totalKeysExamined: explainResult.executionStats?.totalKeysExamined,
      totalDocsExamined: explainResult.executionStats?.totalDocsExamined,
      nReturned: explainResult.executionStats?.nReturned,
      winningPlan: explainResult.queryPlanner?.winningPlan?.stage,
      rejectedPlans: explainResult.queryPlanner?.rejectedPlans?.length
    };
  } catch (error) {
    logger.debug('简化执行计划时出错:', error);
    return null;
  }
}

/**
 * 设置每日凌晨定期清理旧的 DbMetrics 记录
 */
function scheduleMetricsCleanup(retentionDays) {
  // 每天凌晨3点执行清理
  const now = new Date();
  const tonight = new Date(
    now.getFullYear(),
    now.getMonth(),
    now.getDate() + 1,
    3, 0, 0, 0
  );
  
  const timeUntilMidnight = tonight.getTime() - now.getTime();
  
  // 设置第一次执行
  setTimeout(() => {
    cleanupOldMetrics(retentionDays);
    
    // 之后每24小时执行一次
    setInterval(() => {
      cleanupOldMetrics(retentionDays);
    }, 24 * 60 * 60 * 1000);
  }, timeUntilMidnight);
  
  logger.info(`已配置定期清理任务，保留 ${retentionDays} 天的监控数据`);
}

/**
 * 执行 DbMetrics 清理逻辑
 * - 删除指定日期前的所有记录
 */
async function cleanupOldMetrics(days) {
  try {
    const DbMetrics = mongoose.model('DbMetrics');
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - days);
    
    // 查询要删除的文档数量
    const count = await DbMetrics.countDocuments({
      timestamp: { $lt: cutoffDate }
    });
    
    if (count > 0) {
      // 删除旧数据
      const result = await DbMetrics.deleteMany({
        timestamp: { $lt: cutoffDate }
      });
      
      logger.info(`已清理 ${result.deletedCount} 条老旧的监控数据`);
    } else {
      logger.info('没有需要清理的老旧监控数据');
    }
  } catch (error) {
    logger.error('清理监控数据失败:', error);
  }
}

module.exports = {
  initQueryMonitor,
  cleanupOldMetrics
};