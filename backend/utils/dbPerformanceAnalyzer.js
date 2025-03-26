const mongoose = require('mongoose');
const ModelFactory = require('../models/modelFactory');

/**
 * 数据库性能分析工具
 * 用于分析数据库性能指标，生成性能报告
 */
class DbPerformanceAnalyzer {
  /**
   * 获取DbMetrics模型
   * @returns {Promise<Model>} Mongoose模型
   */
  static async getDbMetricsModel() {
    try {
      // 如果模型不存在，则创建
      if (!this.dbMetricsModel) {
        const dbMetricsSchema = new mongoose.Schema({
          operation: String,
          collection: String,
          query: Object,
          duration: Number,
          timestamp: { type: Date, default: Date.now },
          slow_query: Boolean
        });
        
        // 使用ModelFactory创建模型
        this.dbMetricsModel = ModelFactory.model('DbMetrics', dbMetricsSchema);
      }
      
      return this.dbMetricsModel;
    } catch (error) {
      console.error('获取DbMetrics模型失败:', error);
      throw error;
    }
  }

  /**
   * 获取慢查询统计
   * @param {Date} startDate 开始日期
   * @param {Date} endDate 结束日期
   * @returns {Promise<Object>} 慢查询统计数据
   */
  static async getSlowQueryStats(startDate = null, endDate = null) {
    // 设置默认日期范围为过去24小时
    if (!startDate) {
      startDate = new Date();
      startDate.setDate(startDate.getDate() - 1);
    }
    
    if (!endDate) {
      endDate = new Date();
    }
    
    const matchQuery = {
      timestamp: { $gte: startDate, $lte: endDate },
      slow_query: true
    };
    
    try {
      // 获取模型
      const DbMetrics = await this.getDbMetricsModel();
      
      // 获取慢查询统计
      const slowQueries = await DbMetrics.find(matchQuery).sort({ duration: -1 }).limit(100);
      
      // 按集合和操作类型进行统计
      const collectionStats = await DbMetrics.aggregate([
        { $match: matchQuery },
        { $group: {
          _id: { collection: '$collection', operation: '$operation' },
          count: { $sum: 1 },
          avg_duration: { $avg: '$duration' },
          max_duration: { $max: '$duration' },
          min_duration: { $min: '$duration' }
        }},
        { $sort: { count: -1 } }
      ]);
      
      // 每小时慢查询分布
      const hourlyDistribution = await DbMetrics.aggregate([
        { $match: matchQuery },
        { $group: {
          _id: { 
            hour: { $hour: '$timestamp' },
            date: { 
              $dateToString: { 
                format: '%Y-%m-%d', 
                date: '$timestamp' 
              } 
            }
          },
          count: { $sum: 1 },
          avg_duration: { $avg: '$duration' }
        }},
        { $sort: { '_id.date': 1, '_id.hour': 1 } }
      ]);
      
      return {
        total_slow_queries: await DbMetrics.countDocuments(matchQuery),
        top_slow_queries: slowQueries,
        collection_stats: collectionStats,
        hourly_distribution: hourlyDistribution
      };
    } catch (error) {
      console.error('分析慢查询统计时出错:', error);
      throw error;
    }
  }
  
  /**
   * 生成性能优化建议
   * @param {Object} stats 慢查询统计数据
   * @returns {Array<Object>} 优化建议列表
   */
  static generateOptimizationSuggestions(stats) {
    const suggestions = [];
    
    // 分析集合统计数据
    if (stats.collection_stats && stats.collection_stats.length > 0) {
      stats.collection_stats.forEach(stat => {
        const collection = stat._id.collection;
        const operation = stat._id.operation;
        const count = stat.count;
        const avgDuration = stat.avg_duration;
        
        // 查询频率高的集合可能需要索引优化
        if (count > 10 && avgDuration > 800) {
          suggestions.push({
            priority: 'high',
            collection,
            operation,
            problem: `集合 ${collection} 的 ${operation} 操作有 ${count} 次慢查询，平均耗时 ${avgDuration.toFixed(2)}ms`,
            suggestion: `分析这些查询的查询模式，考虑为常用字段创建索引`
          });
        }
        
        // 对于查询占比高的集合进行分片考虑
        if (count > 50) {
          suggestions.push({
            priority: 'medium',
            collection,
            operation,
            problem: `集合 ${collection} 的查询量很大 (${count} 次慢查询)`,
            suggestion: `考虑对该集合进行分片或使用读取副本分担负载`
          });
        }
      });
    }
    
    // 分析时间分布，找出高峰期
    if (stats.hourly_distribution && stats.hourly_distribution.length > 0) {
      // 按小时分组计算平均查询次数
      const hourlyAvg = {};
      
      stats.hourly_distribution.forEach(item => {
        const hour = item._id.hour;
        if (!hourlyAvg[hour]) {
          hourlyAvg[hour] = { count: 0, days: 0 };
        }
        hourlyAvg[hour].count += item.count;
        hourlyAvg[hour].days += 1;
      });
      
      // 找出查询频率最高的3个小时
      const peakHours = Object.keys(hourlyAvg)
        .map(hour => ({ 
          hour: parseInt(hour), 
          avg_count: hourlyAvg[hour].count / hourlyAvg[hour].days 
        }))
        .sort((a, b) => b.avg_count - a.avg_count)
        .slice(0, 3);
      
      if (peakHours.length > 0) {
        const peakHoursStr = peakHours
          .map(h => `${h.hour}:00-${h.hour+1}:00 (平均${h.avg_count.toFixed(1)}次)`)
          .join(', ');
        
        suggestions.push({
          priority: 'medium',
          problem: `高峰期慢查询集中在: ${peakHoursStr}`,
          suggestion: `考虑在非高峰期执行批处理任务，在高峰期增加数据库资源`
        });
      }
    }
    
    // 分析最慢的查询
    if (stats.top_slow_queries && stats.top_slow_queries.length > 0) {
      // 获取平均查询时间
      const avgQueryTime = stats.top_slow_queries.reduce((sum, q) => sum + q.duration, 0) / stats.top_slow_queries.length;
      
      // 特别关注那些明显慢于平均水平的查询
      const verySlowQueries = stats.top_slow_queries.filter(q => q.duration > avgQueryTime * 2);
      
      if (verySlowQueries.length > 0) {
        verySlowQueries.slice(0, 5).forEach(query => {
          suggestions.push({
            priority: 'high',
            collection: query.collection,
            operation: query.operation,
            problem: `特别慢的查询: ${query.operation} 在 ${query.collection}，耗时 ${query.duration}ms`,
            suggestion: `检查查询条件并考虑创建索引: ${JSON.stringify(query.query).substring(0, 100)}`
          });
        });
      }
    }
    
    return suggestions;
  }
  
  /**
   * 生成每日性能报告
   * @returns {Promise<Object>} 性能报告
   */
  static async generateDailyReport() {
    try {
      // 获取过去24小时的慢查询统计
      const startDate = new Date();
      startDate.setDate(startDate.getDate() - 1);
      const endDate = new Date();
      
      const stats = await this.getSlowQueryStats(startDate, endDate);
      const suggestions = this.generateOptimizationSuggestions(stats);
      
      // 总体性能评分 (0-100)
      let performanceScore = 100;
      
      // 根据慢查询数量、平均持续时间等因素扣分
      const slowQueryCount = stats.total_slow_queries;
      
      if (slowQueryCount > 0) {
        // 慢查询数量越多，扣分越多
        performanceScore -= Math.min(50, slowQueryCount / 10);
        
        // 慢查询平均时间越长，扣分越多
        const avgDuration = stats.top_slow_queries.reduce((sum, q) => sum + q.duration, 0) / stats.top_slow_queries.length;
        performanceScore -= Math.min(20, (avgDuration - 500) / 100);
      }
      
      // 确保评分在0-100之间
      performanceScore = Math.max(0, Math.min(100, performanceScore));
      
      return {
        generated_at: new Date(),
        time_period: {
          start: startDate,
          end: endDate
        },
        performance_score: performanceScore,
        slow_query_stats: {
          total_count: stats.total_slow_queries,
          collections_affected: stats.collection_stats ? [...new Set(stats.collection_stats.map(s => s._id.collection))].length : 0,
          worst_collection: stats.collection_stats && stats.collection_stats[0] ? stats.collection_stats[0]._id.collection : null,
          worst_operation: stats.collection_stats && stats.collection_stats[0] ? stats.collection_stats[0]._id.operation : null
        },
        optimization_suggestions: suggestions
      };
    } catch (error) {
      console.error('生成数据库性能报告时出错:', error);
      throw error;
    }
  }
  
  /**
   * 清理过期的性能指标数据
   * @param {Number} days 保留天数
   * @returns {Promise<Number>} 删除的记录数
   */
  static async cleanupOldMetrics(days = 30) {
    try {
      // 获取模型
      const DbMetrics = await this.getDbMetricsModel();
      
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - days);
      
      // 清理非慢查询的旧数据
      const result = await DbMetrics.deleteMany({
        slow_query: false,
        timestamp: { $lt: cutoffDate }
      });
      
      // 慢查询保留更长时间
      const oldCutoffDate = new Date();
      oldCutoffDate.setDate(oldCutoffDate.getDate() - days * 3);
      
      const slowResult = await DbMetrics.deleteMany({
        slow_query: true,
        timestamp: { $lt: oldCutoffDate }
      });
      
      return {
        normalDeleted: result.deletedCount,
        slowDeleted: slowResult.deletedCount
      };
    } catch (error) {
      console.error('清理旧性能指标时出错:', error);
      throw error;
    }
  }
}

// 初始化静态属性
DbPerformanceAnalyzer.dbMetricsModel = null;

module.exports = DbPerformanceAnalyzer; 