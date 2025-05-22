/**
 * 自适应分片服务（Adaptive Sharding Service）
 * 用于分析各集合的查询模式、字段使用频率、字段基数和分布情况
 * 从而推测最优的分片键及分片策略（hash/range/geo/time）
 * 可周期性分析，也可手动触发分析
 * 所有建议可通过 getStats / getShardKeyRecommendation 接口获取
 * @module services/core/adaptiveShardingService
 */

/**
 * 自适应分片策略服务
 * 分析数据库查询模式，推荐最优分片键和策略
 */

const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const config = require('../../config');

class AdaptiveShardingService {
  constructor() {
    // 查询模式分析结果
    this.queryPatterns = new Map();
    
    // 字段使用频率统计
    this.fieldUsageStats = new Map();
    
    // 集合分片键建议
    this.shardKeyRecommendations = new Map();
    
    // 配置
    this.config = {
      enabled: config.database && config.database.enableAdaptiveSharding,
      analysisPeriod: 1000 * 60 * 60 * 24, // 24小时分析一次
      minQueriesForAnalysis: 100, // 分析前最少查询数
      maxShardSizeRatio: 0.1, // 最大分片大小比例
      weightFactors: {
        frequency: 0.5,   // 字段使用频率权重
        cardinality: 0.3, // 字段基数权重
        distribution: 0.2 // 数据分布权重
      }
    };
    
    // 最近一次分析时间
    this.lastAnalysisTime = null;
    
    // 初始化定时分析任务
    if (this.config.enabled) {
      this._setupAnalysisJob();
    }
  }
  
  /**
   * 设置定时分析任务
   * @private
   */
  _setupAnalysisJob() {
    setInterval(() => {
      this.analyzeAllCollections().catch(err => {
        logger.error('分片策略分析失败:', err);
      });
    }, this.config.analysisPeriod);
  }
  
  /**
   * 记录查询模式
   * @param {string} collectionName - 集合名称
   * @param {Object} query - 查询条件
   * @param {Object} options - 查询选项
   */
  recordQuery(collectionName, query, options = {}) {
    if (!this.config.enabled) return;
    
    try {
      if (!this.queryPatterns.has(collectionName)) {
        this.queryPatterns.set(collectionName, []);
      }
      
      const queryPattern = {
        conditions: this._extractConditionFields(query),
        sort: options.sort ? Object.keys(options.sort) : [],
        projection: options.projection ? Object.keys(options.projection) : [],
        timestamp: Date.now()
      };
      
      const patterns = this.queryPatterns.get(collectionName);
      patterns.push(queryPattern);
      
      // 保持最近10000个查询模式
      if (patterns.length > 10000) {
        patterns.shift();
      }
      
      // 更新字段使用频率
      this._updateFieldUsage(collectionName, queryPattern);
    } catch (error) {
      logger.error(`记录查询模式时出错 [${collectionName}]:`, error);
    }
  }
  
  /**
   * 提取查询条件中使用的字段
   * @param {Object} query - 查询条件
   * @returns {Array} 使用的字段列表
   * @private
   */
  _extractConditionFields(query) {
    const fields = new Set();
    
    const extractFields = (obj, prefix = '') => {
      if (!obj || typeof obj !== 'object') return;
      
      for (const [key, value] of Object.entries(obj)) {
        if (key.startsWith('$')) {
          // 处理MongoDB操作符
          if (['$and', '$or', '$nor'].includes(key) && Array.isArray(value)) {
            value.forEach(subQuery => extractFields(subQuery, prefix));
          } else if (key === '$elemMatch' && typeof value === 'object') {
            extractFields(value, prefix);
          }
        } else {
          // 普通字段
          const fullPath = prefix ? `${prefix}.${key}` : key;
          fields.add(fullPath);
          
          // 递归处理嵌套对象
          if (value && typeof value === 'object' && !Array.isArray(value) && !(value instanceof mongoose.Types.ObjectId)) {
            // 检查是否是操作符对象
            const hasOperator = Object.keys(value).some(k => k.startsWith('$'));
            if (!hasOperator) {
              extractFields(value, fullPath);
            }
          }
        }
      }
    };
    
    extractFields(query);
    return Array.from(fields);
  }
  
  /**
   * 更新字段使用频率统计
   * @param {string} collectionName - 集合名称
   * @param {Object} queryPattern - 查询模式
   * @private
   */
  _updateFieldUsage(collectionName, queryPattern) {
    if (!this.fieldUsageStats.has(collectionName)) {
      this.fieldUsageStats.set(collectionName, new Map());
    }
    
    const collectionStats = this.fieldUsageStats.get(collectionName);
    
    // 更新条件字段使用频率
    queryPattern.conditions.forEach(field => {
      const count = collectionStats.get(field) || 0;
      collectionStats.set(field, count + 1);
    });
    
    // 更新排序字段使用频率
    queryPattern.sort.forEach(field => {
      const count = collectionStats.get(field) || 0;
      collectionStats.set(field, count + 0.5); // 排序字段权重较低
    });
  }
  
  /**
   * 分析集合查询模式并生成分片键建议
   * 分数计算规则基于字段使用频率、字段基数和数据分布，分别乘以配置中的权重后求和。
   * @param {string} collectionName - 集合名称
   * @returns {Promise<Object>} 分片键建议
   */
  async analyzeCollection(collectionName) {
    if (!this.config.enabled) {
      return null;
    }
    
    try {
      const patterns = this.queryPatterns.get(collectionName) || [];
      
      if (patterns.length < this.config.minQueriesForAnalysis) {
        logger.info(`集合 ${collectionName} 查询量不足，跳过分析`);
        return null;
      }
      
      const fieldStats = this.fieldUsageStats.get(collectionName) || new Map();
      const totalQueries = patterns.length;
      
      // 计算字段使用频率
      const fieldFrequency = new Map();
      fieldStats.forEach((count, field) => {
        fieldFrequency.set(field, count / totalQueries);
      });
      
      // 获取字段基数和分布信息
      const fieldMetrics = await this._getFieldMetrics(collectionName, Array.from(fieldStats.keys()));
      
      // 计算字段分片得分
      const fieldScores = new Map();
      fieldFrequency.forEach((frequency, field) => {
        const metrics = fieldMetrics.get(field) || { cardinality: 0, distribution: 0 };
        
        const score = 
          frequency * this.config.weightFactors.frequency +
          metrics.cardinality * this.config.weightFactors.cardinality +
          metrics.distribution * this.config.weightFactors.distribution;
        
        fieldScores.set(field, score);
      });
      
      // 选择最佳分片键
      let bestShardKey = null;
      let bestScore = -1;
      
      fieldScores.forEach((score, field) => {
        if (score > bestScore) {
          bestScore = score;
          bestShardKey = field;
        }
      });
      
      // 生成分片策略建议
      const recommendation = {
        collectionName,
        bestShardKey,
        score: bestScore,
        shardType: this._determineShardType(bestShardKey, fieldMetrics.get(bestShardKey)),
        fieldStats: Object.fromEntries(fieldFrequency),
        analyzedQueries: totalQueries,
        timestamp: Date.now()
      };
      
      this.shardKeyRecommendations.set(collectionName, recommendation);
      logger.info(`集合 ${collectionName} 分片键分析完成: ${bestShardKey} (得分: ${bestScore.toFixed(2)})`);
      
      return recommendation;
    } catch (error) {
      logger.error(`分析集合分片策略时出错 [${collectionName}]:`, error);
      return null;
    }
  }
  
  /**
   * 分析所有集合的查询模式，生成分片键建议
   * @returns {Promise<Object>} 所有集合的建议键映射
   */
  async analyzeAllCollections() {
    if (!this.config.enabled) {
      return {};
    }
    
    const results = {};
    const collections = Array.from(this.queryPatterns.keys());
    
    for (const collectionName of collections) {
      results[collectionName] = await this.analyzeCollection(collectionName);
    }
    
    this.lastAnalysisTime = Date.now();
    return results;
  }
  
  /**
   * 获取集合字段的统计指标
   * 返回值中 metrics 结构包含：
   *  - cardinality: 基数得分（0-1，适中越高）
   *  - distribution: 分布均匀性得分（0-1，越接近1越均匀）
   *  - raw: 原始数据，包括基数和部分分布样本
   * @param {string} collectionName - 集合名称
   * @param {Array} fields - 字段列表
   * @returns {Promise<Map>} 字段指标映射
   * @private
   */
  async _getFieldMetrics(collectionName, fields) {
    try {
      const result = new Map();
      const model = mongoose.models[collectionName];
      
      if (!model) {
        logger.warn(`获取字段指标时未找到模型: ${collectionName}`);
        return result;
      }
      
      // 使用MongoDB聚合管道获取字段指标
      for (const field of fields) {
        const cardinalityPipeline = [
          { $group: { _id: `$${field}`, count: { $sum: 1 } } },
          { $group: { _id: null, cardinality: { $sum: 1 } } }
        ];
        
        const distributionPipeline = [
          { $group: { _id: `$${field}`, count: { $sum: 1 } } },
          { $sort: { count: -1 } },
          { $limit: 100 }
        ];
        
        try {
          // 计算字段基数
          const cardinalityResult = await model.aggregate(cardinalityPipeline);
          const cardinality = cardinalityResult.length > 0 ? cardinalityResult[0].cardinality : 0;
          
          // 获取分布
          const distributionResult = await model.aggregate(distributionPipeline);
          const totalCount = distributionResult.reduce((sum, item) => sum + item.count, 0);
          
          // 计算分布均匀性 (0-1，越接近1越均匀)
          let distribution = 0;
          if (distributionResult.length > 0 && totalCount > 0) {
            // 使用基尼系数的变种来衡量分布均匀性
            const idealShare = 1 / distributionResult.length;
            const deviations = distributionResult.map(item => 
              Math.abs((item.count / totalCount) - idealShare)
            );
            
            const avgDeviation = deviations.reduce((sum, d) => sum + d, 0) / deviations.length;
            distribution = 1 - avgDeviation;
          }
          
          // 计算基数得分 (0-1，基数值越适中越好)
          let cardinalityScore = 0;
          if (cardinality > 0) {
            // 基于启发式规则：太低或太高的基数都不适合作为分片键
            const documentCount = await model.estimatedDocumentCount();
            const ratio = cardinality / documentCount;
            
            if (ratio < 0.0001) {
              cardinalityScore = 0.1; // 基数太低
            } else if (ratio > 0.5) {
              cardinalityScore = 0.5; // 基数太高
            } else {
              // 适中的基数
              cardinalityScore = 1 - Math.abs(ratio - this.config.maxShardSizeRatio) / this.config.maxShardSizeRatio;
            }
          }
          
          result.set(field, {
            cardinality: cardinalityScore,
            distribution,
            raw: {
              cardinality,
              distributionSamples: distributionResult.slice(0, 5)
            }
          });
        } catch (error) {
          logger.error(`获取字段 ${field} 指标时出错:`, error);
        }
      }
      
      return result;
    } catch (error) {
      logger.error(`获取字段指标时出错 [${collectionName}]:`, error);
      return new Map();
    }
  }
  
  /**
   * 确定适合字段的分片类型
   * 根据字段名特征和指标映射到分片类型：
   *  - 字段名包含时间相关关键字：time
   *  - 字段名包含地理位置相关关键字：geo
   *  - 字段名为_id或以Id结尾：hash
   *  - 字段名包含type/status/category：range
   *  - 指标分布均匀性高 (>0.8)：hash
   *  - 基数适中偏高 (>0.7)：hash
   *  - 基数较低 (<0.3)：range
   *  - 默认：hash
   * @param {string} field - 字段名
   * @param {Object} metrics - 字段指标
   * @returns {string} 分片类型
   * @private
   */
  _determineShardType(field, metrics) {
    if (!field || !metrics) {
      return 'hash';
    }
    
    // 根据字段名特征判断
    if (field.endsWith('At') || field.includes('date') || field.includes('time')) {
      return 'time';
    }
    
    if (field.includes('location') || field.includes('coordinate') || field.includes('position')) {
      return 'geo';
    }
    
    if (field === '_id' || field.endsWith('Id')) {
      return 'hash';
    }
    
    if (field.includes('type') || field.includes('status') || field.includes('category')) {
      return 'range';
    }
    
    // 根据指标判断
    if (metrics.distribution > 0.8) {
      return 'hash'; // 分布均匀，适合哈希分片
    }
    
    if (metrics.cardinality > 0.7) {
      return 'hash'; // 基数适中偏高，适合哈希分片
    }
    
    if (metrics.cardinality < 0.3) {
      return 'range'; // 基数较低，适合范围分片
    }
    
    // 默认使用哈希分片
    return 'hash';
  }
  
  /**
   * 获取集合的分片键建议
   * @param {string} collectionName - 集合名称
   * @returns {Object} 分片键建议
   */
  getShardKeyRecommendation(collectionName) {
    return this.shardKeyRecommendations.get(collectionName) || null;
  }
  
  /**
   * 获取所有分片键建议
   * @returns {Object} 所有分片键建议
   */
  getAllRecommendations() {
    const result = {};
    this.shardKeyRecommendations.forEach((recommendation, collectionName) => {
      result[collectionName] = recommendation;
    });
    return result;
  }
  
  /**
   * 获取分析统计信息
   * 包含每个集合的查询数量（queryCount）、最频繁字段（topFields）、分片建议（recommendation）
   * 以及总体是否启用、自上次分析时间（lastAnalysisTime）和已分析集合总数
   * @returns {Object} 统计信息
   */
  getStats() {
    const collectionStats = {};
    this.queryPatterns.forEach((patterns, collection) => {
      const fieldUsage = this.fieldUsageStats.get(collection) || new Map();
      const topFields = Array.from(fieldUsage.entries())
        .sort((a, b) => b[1] - a[1])
        .slice(0, 5)
        .map(([field, count]) => ({ field, count }));
      
      collectionStats[collection] = {
        queryCount: patterns.length,
        topFields,
        recommendation: this.shardKeyRecommendations.get(collection)
      };
    });
    
    return {
      enabled: this.config.enabled,
      collections: collectionStats,
      lastAnalysisTime: this.lastAnalysisTime,
      totalCollectionsAnalyzed: this.shardKeyRecommendations.size
    };
  }
  
  /**
   * 清除特定集合的分析数据
   * @param {string} collectionName - 集合名称
   */
  clearCollectionData(collectionName) {
    this.queryPatterns.delete(collectionName);
    this.fieldUsageStats.delete(collectionName);
    this.shardKeyRecommendations.delete(collectionName);
    logger.info(`已清除集合 ${collectionName} 的分析数据`);
  }
  
  /**
   * 清除所有分析数据
   */
  clearAllData() {
    this.queryPatterns.clear();
    this.fieldUsageStats.clear();
    this.shardKeyRecommendations.clear();
    this.lastAnalysisTime = null;
    logger.info('已清除所有分片分析数据');
  }
}

// 创建单例
const adaptiveShardingService = new AdaptiveShardingService();

module.exports = adaptiveShardingService; 