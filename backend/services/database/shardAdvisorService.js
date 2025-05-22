/**
 * shardAdvisorService.js
 * 智能分片顾问服务
 * - 定期分析 MongoDB 集合的字段分布、索引和查询模式
 * - 推荐最优分片键
 * - 支持复合键推荐
 * - 支持配置项启停和重新分片选项
 */

const mongoose = require('mongoose');
const { ObjectId } = mongoose.Types;
const logger = require('../../utils/logger/winstonLogger.js');
const adaptiveShardingService = require('./adaptiveShardingService');
const config = require('../../config');

class ShardAdvisorService {
  constructor() {
    this.config = {
      enabled: config.database && config.database.enableShardAdvisor,
      scanInterval: 86400000, // 默认每24小时分析一次
      maxFieldsToAnalyze: 15, // 每个集合分析的最大字段数
      minQuerySampleSize: 1000, // 最小查询样本数量
      confidenceThreshold: 0.75, // 推荐阈值
      historySize: 5, // 保存的历史推荐数量
      adaptiveMode: true, // 是否启用自适应模式
      considerCompoundKeys: true, // 是否考虑复合键
      allowResharding: config.database && config.database.allowResharding || false, // 是否允许重新分片
    };
    
    this.recommendations = new Map();
    this.collectionStats = new Map();
    this.lastAnalysisTimes = new Map();
    this.history = new Map();
    
    if (this.config.enabled) {
      this._initAnalysisScheduler();
    }
  }
  
  /**
   * 初始化分析计划任务
   * @private
   */
  _initAnalysisScheduler() {
    setInterval(async () => {
      if (!this.config.enabled) return;
      
      try {
        // 获取所有集合
        const db = mongoose.connection.db;
        const collections = await db.listCollections().toArray();
        
        for (const collection of collections) {
          const collName = collection.name;
          const lastAnalysisTime = this.lastAnalysisTimes.get(collName) || 0;
          
          // 检查是否需要分析
          if (Date.now() - lastAnalysisTime > this.config.scanInterval) {
            logger.info(`开始分析集合 ${collName} 的分片键`);
            await this.analyzeCollection(collName);
          }
        }
      } catch (error) {
        logger.error('分片键分析计划任务出错:', error);
      }
    }, Math.max(3600000, this.config.scanInterval / 24)); // 至少每小时检查一次
  }
  
  /**
   * 分析集合并推荐分片键
   * @param {string} collectionName - 集合名称
   * @returns {Promise<Object>} 分片键推荐
   */
  async analyzeCollection(collectionName) {
    logger.debug(`[ShardAdvisor] analyzeCollection(${collectionName}) 启动`);
    if (!this.config.enabled) {
      return { error: '分片顾问服务未启用' };
    }
    
    try {
      const startTime = Date.now();
      logger.info(`开始分析集合 ${collectionName} 的分片键`);
      
      // 获取集合对象
      const db = mongoose.connection.db;
      const collection = db.collection(collectionName);
      
      // 1. 获取集合统计信息
      const stats = await collection.stats();
      const docCount = stats.count || 0;
      const avgDocSize = stats.avgObjSize || 0;
      const totalSizeBytes = stats.size || 0;
      
      // 存储基本统计信息
      this.collectionStats.set(collectionName, {
        documentCount: docCount,
        averageDocumentSize: avgDocSize,
        totalSizeBytes: totalSizeBytes,
        lastUpdated: Date.now()
      });
      
      // 如果文档太少，不进行分析
      if (docCount < 100) {
        logger.warn(`集合 ${collectionName} 文档数量太少(${docCount})，不进行分片分析`);
        return { 
          error: '文档数量不足', 
          documentCount: docCount,
          recommendation: null 
        };
      }
      
      // 2. 获取集合字段数据分布
      const fieldDistribution = await this._analyzeFieldDistribution(collection);
      
      // 3. 获取查询模式
      const queryPatterns = await adaptiveShardingService.analyzeQueryPatterns(collectionName);
      
      // 4. 获取索引信息
      const indexInfo = await collection.indexes();
      
      // 5. 生成分片键推荐
      const recommendation = this._generateShardKeyRecommendation(
        collectionName,
        fieldDistribution, 
        queryPatterns,
        indexInfo,
        stats
      );
      
      // 6. 存储推荐结果
      this.recommendations.set(collectionName, recommendation);
      this.lastAnalysisTimes.set(collectionName, Date.now());
      
      // 7. 添加到历史记录
      if (!this.history.has(collectionName)) {
        this.history.set(collectionName, []);
      }
      
      const historyList = this.history.get(collectionName);
      historyList.push({
        timestamp: Date.now(),
        recommendation: recommendation,
        appliedAt: null
      });
      
      // 限制历史记录大小
      if (historyList.length > this.config.historySize) {
        historyList.shift();
      }
      
      // 8. 记录分析完成
      const analysisTime = Date.now() - startTime;
      logger.info(`集合 ${collectionName} 分片键分析完成，耗时: ${analysisTime}ms`);
      
      recommendation.analysisDetails = {
        analysisTime,
        docCount,
        avgDocSize,
        totalSizeBytes,
        fieldsAnalyzed: fieldDistribution.length,
        queryPatternsAnalyzed: queryPatterns ? queryPatterns.length : 0
      };
      
      return recommendation;
    } catch (error) {
      logger.error(`分析集合 ${collectionName} 分片键时出错:`, error);
      return { error: error.message };
    }
  }
  
  /**
   * 分析字段数据分布
   * @param {Collection} collection - MongoDB集合
   * @returns {Promise<Array>} 字段分布信息
   * @private
   */
  async _analyzeFieldDistribution(collection) {
    logger.debug(`[ShardAdvisor] _analyzeFieldDistribution(${collection.collectionName})`);
    try {
      // 获取样本文档来确定字段
      const sampleSize = Math.min(1000, await collection.countDocuments());
      const sampleDocs = await collection.aggregate([
        { $sample: { size: sampleSize } }
      ]).toArray();
      
      if (sampleDocs.length === 0) {
        return [];
      }
      
      // 统计字段出现频率和类型
      const fieldStats = new Map();
      
      // 扁平化处理，支持嵌套字段分析
      const processDocument = (doc, prefix = '') => {
        for (const [key, value] of Object.entries(doc)) {
          if (key === '_id') continue; // 跳过_id字段
          
          const fieldPath = prefix ? `${prefix}.${key}` : key;
          
          // 初始化字段统计
          if (!fieldStats.has(fieldPath)) {
            fieldStats.set(fieldPath, {
              path: fieldPath,
              count: 0,
              types: new Map(),
              values: new Set(),
              nullCount: 0,
              cardinalityEstimate: 0
            });
          }
          
          const stats = fieldStats.get(fieldPath);
          stats.count++;
          
          // 处理空值
          if (value === null || value === undefined) {
            stats.nullCount++;
            continue;
          }
          
          // 记录类型
          const type = Array.isArray(value) ? 'array' : typeof value;
          stats.types.set(type, (stats.types.get(type) || 0) + 1);
          
          // 对于基本类型，收集值样本以估计基数
          if (type === 'string' || type === 'number' || type === 'boolean' || 
              (type === 'object' && value instanceof ObjectId)) {
            // 最多采样100个唯一值
            if (stats.values.size < 100) {
              stats.values.add(value.toString());
            }
          }
          
          // 递归处理嵌套对象
          if (type === 'object' && !(value instanceof ObjectId)) {
            processDocument(value, fieldPath);
          }
        }
      };
      
      // 处理所有样本文档
      for (const doc of sampleDocs) {
        processDocument(doc);
      }
      
      // 转换统计结果为数组
      const result = [];
      for (const [fieldPath, stats] of fieldStats.entries()) {
        // 计算覆盖率
        const coverage = stats.count / sampleDocs.length;
        
        // 确定主要类型
        let primaryType = null;
        let primaryTypeCount = 0;
        
        for (const [type, count] of stats.types.entries()) {
          if (count > primaryTypeCount) {
            primaryType = type;
            primaryTypeCount = count;
          }
        }
        
        // 估计基数 (unique值数量占比)
        const cardinalityEstimate = stats.values.size / Math.min(stats.count, 100);
        
        result.push({
          path: fieldPath,
          coverage: coverage,
          primaryType: primaryType,
          nullPercentage: stats.nullCount / stats.count,
          cardinalityEstimate: cardinalityEstimate,
          cardinalityLevel: this._categorizeCardinality(cardinalityEstimate),
          typeDistribution: Object.fromEntries(stats.types),
          depth: fieldPath.split('.').length - 1
        });
      }
      
      // 按照深度排序，优先考虑顶层字段
      result.sort((a, b) => a.depth - b.depth);
      
      // 限制分析的字段数
      return result.slice(0, this.config.maxFieldsToAnalyze);
    } catch (error) {
      logger.error('分析字段分布时出错:', error);
      return [];
    }
  }
  
  /**
   * 对基数进行分类
   * @param {number} cardinalityEstimate - 基数估计值(0-1)
   * @returns {string} 基数级别
   * @private
   */
  _categorizeCardinality(cardinalityEstimate) {
    if (cardinalityEstimate >= 0.9) return 'very_high';
    if (cardinalityEstimate >= 0.7) return 'high';
    if (cardinalityEstimate >= 0.4) return 'medium';
    if (cardinalityEstimate >= 0.1) return 'low';
    return 'very_low';
  }
  
  /**
   * 生成分片键推荐
   * @param {string} collectionName - 集合名称
   * @param {Array} fieldDistribution - 字段分布信息
   * @param {Array} queryPatterns - 查询模式信息
   * @param {Array} indexInfo - 索引信息
   * @param {Object} stats - 集合统计信息
   * @returns {Object} 分片键推荐
   * @private
   */
  _generateShardKeyRecommendation(collectionName, fieldDistribution, queryPatterns, indexInfo, stats) {
    logger.debug(`[ShardAdvisor] _generateShardKeyRecommendation for ${collectionName}`);
    // 初始化候选分片键评分
    const candidates = [];
    
    // 如果没有足够的字段信息，返回空推荐
    if (!fieldDistribution || fieldDistribution.length === 0) {
      return {
        collection: collectionName,
        recommendedShardKey: null,
        confidence: 0,
        alternatives: [],
        message: '无法获取足够的字段分布信息'
      };
    }
    
    // 评分函数 - 越高越好
    const scoreField = (field) => {
      let score = 0;
      
      // 1. 覆盖率 (字段存在于大多数文档中)
      score += field.coverage * 20;
      
      // 2. 基数评分 (基数越高，分散性越好)
      switch (field.cardinalityLevel) {
        case 'very_high': score += 25; break;
        case 'high': score += 20; break;
        case 'medium': score += 15; break;
        case 'low': score += 5; break;
        case 'very_low': score += 0; break;
      }
      
      // 3. 无空值的加分
      score += (1 - field.nullPercentage) * 10;
      
      // 4. 字段类型加分
      switch (field.primaryType) {
        case 'number': score += 15; break;
        case 'string': score += 12; break;
        case 'object': 
          if (field.path.endsWith('_id')) score += 20; // ObjectId很可能是好的分片键
          else score += 8;
          break;
        case 'date': score += 14; break;
        case 'boolean': score -= 10; break; // 布尔值不适合分片键
        case 'array': score -= 15; break;   // 数组通常不适合分片键
      }
      
      // 5. 嵌套深度降分 (越深越不好)
      score -= field.depth * 5;
      
      // 6. 从查询模式加分 (如果字段经常用于查询)
      if (queryPatterns) {
        const fieldPattern = queryPatterns.find(p => p.field === field.path);
        if (fieldPattern) {
          // 查询频率加分
          score += fieldPattern.frequency * 15;
          
          // 查询选择性加分
          if (fieldPattern.selectivity > 0.8) score += 10;
          else if (fieldPattern.selectivity > 0.5) score += 5;
          
          // 如果字段在很多查询条件中被使用，加分
          if (fieldPattern.usageInQueries > 0.4) score += 10;
        }
      }
      
      // 7. 已存在索引加分
      const fieldHasIndex = indexInfo.some(idx => 
        idx.key && Object.keys(idx.key).includes(field.path)
      );
      if (fieldHasIndex) score += 8;
      
      // 8. 可能是ID类字段加分
      if (field.path.toLowerCase().includes('id') && 
          !field.path.endsWith('_ids') && 
          field.cardinalityEstimate > 0.5) {
        score += 10;
      }
      
      return Math.max(0, score);
    };
    
    // 为每个字段评分
    for (const field of fieldDistribution) {
      // 不考虑数组和布尔值作为唯一分片键
      if (field.primaryType === 'array' || field.primaryType === 'boolean') {
        continue;
      }
      
      // 不考虑超低基数字段
      if (field.cardinalityLevel === 'very_low' && field.primaryType !== 'object') {
        continue;
      }
      
      const score = scoreField(field);
      
      candidates.push({
        field: field.path,
        score,
        type: field.primaryType,
        cardinality: field.cardinalityEstimate,
        cardinalityLevel: field.cardinalityLevel,
        coverage: field.coverage,
        hasIndex: indexInfo.some(idx => idx.key && Object.keys(idx.key).includes(field.path))
      });
    }
    
    // 如果启用了复合键分析，生成可能的复合键组合
    if (this.config.considerCompoundKeys && candidates.length >= 2) {
      // 选择前5个得分最高的字段
      const topFields = candidates
        .sort((a, b) => b.score - a.score)
        .slice(0, 5);
      
      // 生成2字段组合
      for (let i = 0; i < topFields.length; i++) {
        for (let j = i + 1; j < topFields.length; j++) {
          const field1 = topFields[i];
          const field2 = topFields[j];
          
          // 计算复合键分数
          // 复合键分数略低于单字段，除非它们互补性很强
          let compoundScore = (field1.score * 0.7 + field2.score * 0.5);
          
          // 互补性加分: 如果一个高基数一个低基数
          if (
            (field1.cardinalityLevel === 'high' && field2.cardinalityLevel === 'low') ||
            (field1.cardinalityLevel === 'low' && field2.cardinalityLevel === 'high')
          ) {
            compoundScore += 10;
          }
          
          // 查询模式支持复合键
          if (queryPatterns) {
            const patternHasBoth = queryPatterns.some(p => 
              p.queryFields && p.queryFields.includes(field1.field) && p.queryFields.includes(field2.field)
            );
            if (patternHasBoth) compoundScore += 15;
          }
          
          // 复合索引加分
          const hasCompoundIndex = indexInfo.some(idx => {
            const keys = Object.keys(idx.key || {});
            return keys.includes(field1.field) && keys.includes(field2.field);
          });
          if (hasCompoundIndex) compoundScore += 12;
          
          candidates.push({
            field: `${field1.field},${field2.field}`,
            score: compoundScore,
            type: 'compound',
            components: [field1, field2],
            hasIndex: hasCompoundIndex
          });
        }
      }
    }
    
    // 排序候选分片键
    candidates.sort((a, b) => b.score - a.score);
    
    // 推荐最高分的分片键
    const recommended = candidates.length > 0 ? candidates[0] : null;
    
    // 计算推荐置信度 (最高100分)
    const confidence = recommended ? Math.min(recommended.score / 100, 1) : 0;
    
    // 获取替代选项 (排除推荐选项)
    const alternatives = candidates.slice(1, 4);
    
    // 生成最终推荐结果
    return {
      collection: collectionName,
      recommendedShardKey: recommended ? recommended.field : null,
      confidence,
      confidencePercentage: `${Math.round(confidence * 100)}%`,
      documentCount: stats.count,
      avgDocSize: stats.avgObjSize,
      totalSizeGB: (stats.size / (1024 * 1024 * 1024)).toFixed(2),
      alternatives: alternatives.map(alt => ({
        field: alt.field,
        score: alt.score,
        type: alt.type,
        confidence: Math.min(alt.score / 100, 1)
      })),
      reasoning: this._generateReasoning(recommended, queryPatterns),
      timestamp: Date.now()
    };
  }
  
  /**
   * 生成推荐理由
   * @param {Object} recommended - 推荐的分片键
   * @param {Array} queryPatterns - 查询模式
   * @returns {string} 推荐理由
   * @private
   */
  _generateReasoning(recommended, queryPatterns) {
    if (!recommended) {
      return '没有找到合适的分片键。建议手动选择。';
    }
    
    const reasons = [];
    
    // 添加基础理由
    if (recommended.type === 'compound') {
      reasons.push(`复合键 "${recommended.field}" 提供了良好的数据分布平衡。`);
      
      // 添加各组成部分的理由
      for (const component of recommended.components) {
        if (component.cardinalityLevel === 'high' || component.cardinalityLevel === 'very_high') {
          reasons.push(`字段 "${component.field}" 具有高基数，确保数据良好分布。`);
        }
        
        if (component.hasIndex) {
          reasons.push(`字段 "${component.field}" 已有索引支持。`);
        }
      }
    } else {
      // 单字段理由
      if (recommended.cardinalityLevel === 'high' || recommended.cardinalityLevel === 'very_high') {
        reasons.push(`字段 "${recommended.field}" 具有高基数(${Math.round(recommended.cardinality * 100)}%)，确保数据良好分布。`);
      } else if (recommended.cardinalityLevel === 'medium') {
        reasons.push(`字段 "${recommended.field}" 具有中等基数，提供适中的数据分布。`);
      }
      
      if (recommended.coverage > 0.95) {
        reasons.push(`字段 "${recommended.field}" 在所有文档中均存在，覆盖率高。`);
      }
      
      if (recommended.hasIndex) {
        reasons.push(`字段 "${recommended.field}" 已有索引支持，可优化查询性能。`);
      }
    }
    
    // 添加基于查询模式的理由
    if (queryPatterns && recommended.type !== 'compound') {
      const fieldPattern = queryPatterns.find(p => p.field === recommended.field);
      if (fieldPattern) {
        if (fieldPattern.frequency > 0.5) {
          reasons.push(`该字段在查询中使用频率高，频率为 ${Math.round(fieldPattern.frequency * 100)}%。`);
        }
        
        if (fieldPattern.selectivity > 0.7) {
          reasons.push(`该字段查询具有高选择性，有助于定位特定文档。`);
        }
      }
    }
    
    // 如果是ID类字段
    if (recommended.field.toLowerCase().includes('id') && recommended.type !== 'compound') {
      reasons.push(`"${recommended.field}" 是ID类字段，通常具有良好的唯一性和分布性。`);
    }
    
    // 如果没有找到理由，添加默认理由
    if (reasons.length === 0) {
      reasons.push(`该字段在多项评估标准中得分最高，包括基数、覆盖率和类型适合性。`);
    }
    
    return reasons.join(' ');
  }
  
  /**
   * 获取指定集合的分片键推荐
   * @param {string} collectionName - 集合名称
   * @param {boolean} forceRefresh - 是否强制刷新分析
   * @returns {Promise<Object>} 分片键推荐
   */
  async getRecommendation(collectionName, forceRefresh = false) {
    logger.debug(`[ShardAdvisor] getRecommendation(${collectionName}, force=${forceRefresh})`);
    // 如果强制刷新或者没有推荐，则重新分析
    if (forceRefresh || !this.recommendations.has(collectionName)) {
      return await this.analyzeCollection(collectionName);
    }
    
    return this.recommendations.get(collectionName);
  }
  
  /**
   * 获取所有集合的分片键推荐
   * @returns {Promise<Array>} 所有分片键推荐
   */
  async getAllRecommendations() {
    logger.debug(`[ShardAdvisor] getAllRecommendations()`);
    const result = [];
    
    for (const [collectionName, recommendation] of this.recommendations.entries()) {
      result.push({
        collection: collectionName,
        recommendation,
        lastAnalyzed: this.lastAnalysisTimes.get(collectionName),
        stats: this.collectionStats.get(collectionName) || {}
      });
    }
    
    return result;
  }
  
  /**
   * 应用分片键推荐
   * @param {string} collectionName - 集合名称
   * @param {string} shardKey - 要应用的分片键，如不提供则使用推荐的
   * @returns {Promise<Object>} 应用结果
   */
  async applyShardKey(collectionName, shardKey = null) {
    try {
      logger.debug(`[ShardAdvisor] applyShardKey(${collectionName}) -> ${shardKey}`);
      // 如果没有提供分片键，使用推荐的
      const keyToApply = shardKey || 
        (this.recommendations.has(collectionName) ? 
          this.recommendations.get(collectionName).recommendedShardKey : null);
      
      if (!keyToApply) {
        return { error: '没有可用的分片键推荐' };
      }
      
      // 获取数据库连接
      const db = mongoose.connection.db;
      
      // 检查集合是否已经分片
      const adminDb = db.admin();
      const shardStatus = await adminDb.command({ listShards: 1 });
      
      if (!shardStatus.shards || shardStatus.shards.length < 2) {
        return { error: '系统未配置分片集群' };
      }
      
      // 获取数据库名
      const dbName = mongoose.connection.name;
      
      // 检查集合是否已分片
      const nsInfo = await adminDb.command({ listShards: 1, full: true });
      const isSharded = nsInfo.sharded && nsInfo.sharded.includes(`${dbName}.${collectionName}`);
      
      // 如果集合已分片且不允许重新分片，返回错误
      if (isSharded && !this.config.allowResharding) {
        return { error: '集合已分片，且系统不允许重新分片' };
      }
      
      // 解析分片键
      let shardKeyObj = {};
      
      if (keyToApply.includes(',')) {
        // 处理复合键
        const fields = keyToApply.split(',');
        for (const field of fields) {
          shardKeyObj[field.trim()] = 1;
        }
      } else {
        // 单个键
        shardKeyObj[keyToApply] = 1;
      }
      
      // 开始应用分片
      // 1. 确保有适当的索引
      await db.collection(collectionName).createIndex(shardKeyObj);
      
      // 2. 启用分片
      let result;
      if (isSharded) {
        // 对于已分片的集合，需要迁移
        result = await adminDb.command({
          reshardCollection: `${dbName}.${collectionName}`,
          key: shardKeyObj
        });
      } else {
        // 对于未分片的集合
        // 先启用数据库分片
        await adminDb.command({ enableSharding: dbName });
        
        // 然后启用集合分片
        result = await adminDb.command({
          shardCollection: `${dbName}.${collectionName}`,
          key: shardKeyObj
        });
      }
      
      // 更新分片键应用历史
      if (this.history.has(collectionName)) {
        const historyList = this.history.get(collectionName);
        const lastRec = historyList[historyList.length - 1];
        if (lastRec) {
          lastRec.appliedAt = Date.now();
        }
      }
      
      logger.info(`成功为集合 ${collectionName} 应用分片键: ${JSON.stringify(shardKeyObj)}`);
      
      return {
        success: true,
        appliedShardKey: keyToApply,
        message: `成功为集合 ${collectionName} 应用分片键`,
        result
      };
    } catch (error) {
      logger.error(`应用分片键到集合 ${collectionName} 时出错:`, error);
      return { error: error.message };
    }
  }
  
  /**
   * 获取集合分片历史
   * @param {string} collectionName - 集合名称
   * @returns {Array} 分片历史
   */
  getShardHistory(collectionName) {
    return this.history.has(collectionName) ? 
      this.history.get(collectionName) : [];
  }
  
  /**
   * 获取服务状态
   * @returns {Object} 服务状态
   */
  getStatus() {
    logger.debug('[ShardAdvisor] getStatus()');
    return {
      enabled: this.config.enabled,
      collectionsAnalyzed: this.recommendations.size,
      lastAnalysisTimes: Object.fromEntries(this.lastAnalysisTimes),
      config: this.config,
      recommendations: Array.from(this.recommendations.entries()).map(([collection, rec]) => ({
        collection,
        recommendedKey: rec.recommendedShardKey,
        confidence: rec.confidence
      }))
    };
  }
}

// 创建单例
const shardAdvisorService = new ShardAdvisorService();

module.exports = shardAdvisorService; 