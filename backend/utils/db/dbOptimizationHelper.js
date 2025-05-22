/**
 * ✅ 模块名：dbOptimizationHelper.js
 * ✅ 所属层：utils（数据库辅助工具）
 * ✅ 功能说明：
 *   - 提供 MongoDB 集合优化建议生成与自动分析功能
 *   - 支持：集合分析、索引建议、慢查询检测、索引重建、压缩、验证等
 * ✅ 适用对象：管理员后台数据库状态页面、自动健康检测任务、开发调试阶段
 */
const mongoose = require('mongoose');
const logger = require('../logger');
const dbManager = require('../../services/database/dbProxyService');

/**
 * 数据库优化助手
 * 提供数据库分析、索引管理、数据压缩等功能
 */
class DbOptimizationHelper {
  constructor() {
    this.operationsLog = [];
    this.maxLogsLength = 100;
  }
  
  /**
   * 分析集合，生成优化建议
   * @param {string} collectionName - 要分析的集合名
   * @returns {Promise<Object>} 分析结果和建议
   */
  async analyzeCollection(collectionName) {
    try {
      const db = mongoose.connection.db;
      
      if (!db) {
        throw new Error('数据库未连接');
      }
      
      const stats = await db.collection(collectionName).stats();
      const indexes = await db.collection(collectionName).indexes();
      const sample = await db.collection(collectionName).find().limit(5).toArray();
      
      // 获取索引使用情况
      const indexUsage = await db.collection('system.profile')
        .find({ ns: `${db.databaseName}.${collectionName}` })
        .sort({ ts: -1 })
        .limit(100)
        .toArray();
      
      // 检查集合大小
      const sizeInMB = stats.size / (1024 * 1024);
      
      // 获取数据库指标模型的慢查询分析
      const DbMetrics = mongoose.model('DbMetrics');
      const slowQueryAnalysis = await DbMetrics.getSlowQueryStats(collectionName, { period: 168 });
      
      // 准备优化建议
      const suggestions = [];
      
      // 检查文档大小
      if (stats.avgObjSize > 16384) { // 16KB
        suggestions.push({
          type: 'document_size',
          severity: 'warning',
          message: `平均文档大小(${Math.round(stats.avgObjSize / 1024)}KB)较大，考虑拆分或引用设计`
        });
      }
      
      // 检查集合大小
      if (sizeInMB > 1000) { // 1GB
        suggestions.push({
          type: 'collection_size',
          severity: 'warning',
          message: `集合大小(${Math.round(sizeInMB)}MB)较大，考虑分片或归档策略`
        });
      }
      
      // 检查索引使用情况
      const unusedIndexes = [];
      indexes.forEach(index => {
        if (index.name === '_id_') return; // 排除_id索引
        
        const isUsed = indexUsage.some(usage => 
          usage.indexBounds && Object.keys(usage.indexBounds).some(key => 
            key.startsWith(Object.keys(index.key)[0])
          )
        );
        
        if (!isUsed) {
          unusedIndexes.push(index.name);
        }
      });
      
      if (unusedIndexes.length > 0) {
        suggestions.push({
          type: 'unused_indexes',
          severity: 'info',
          message: `发现${unusedIndexes.length}个未使用的索引`,
          details: unusedIndexes
        });
      }
      
      // 检查索引覆盖
      if (slowQueryAnalysis.length > 0) {
        const missedIndexFields = [];
        
        slowQueryAnalysis.forEach(query => {
          if (query.sampleQuery) {
            const queryFields = Object.keys(query.sampleQuery).filter(k => !k.startsWith('$'));
            const hasIndex = indexes.some(index => 
              queryFields.every(field => Object.keys(index.key).includes(field))
            );
            
            if (!hasIndex && queryFields.length > 0) {
              missedIndexFields.push(queryFields);
            }
          }
        });
        
        if (missedIndexFields.length > 0) {
          suggestions.push({
            type: 'missing_indexes',
            severity: 'high',
            message: `发现${missedIndexFields.length}个查询模式缺少合适索引`,
            details: missedIndexFields.map(fields => ({ 
              fields,
              suggested: `{ ${fields.join(': 1, ')}: 1 }`
            }))
          });
        }
      }
      
      // 记录操作
      this._logOperation('analyze_collection', { 
        collectionName, 
        suggestionsCount: suggestions.length 
      });
      
      return {
        timestamp: new Date(),
        collectionName,
        stats: {
          documentCount: stats.count,
          sizeInMB: Math.round(sizeInMB * 100) / 100,
          avgDocumentSizeKB: Math.round(stats.avgObjSize / 1024 * 100) / 100,
          indexCount: indexes.length,
          indexSizeInMB: Math.round(stats.totalIndexSize / (1024 * 1024) * 100) / 100
        },
        indexInfo: indexes.map(idx => ({
          name: idx.name,
          fields: idx.key,
          size: idx.size,
          used: !unusedIndexes.includes(idx.name)
        })),
        slowQueries: slowQueryAnalysis,
        sample: sample,
        suggestions
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 分析集合 ${collectionName} 失败:`, error);
      throw error;
    }
  }
  
  /**
   * 创建索引
   * @param {string} collectionName - 集合名
   * @param {Object} keys - 索引键
   * @param {Object} options - 索引选项
   * @returns {Promise<Object>} 操作结果
   */
  async createIndex(collectionName, keys, options = {}) {
    try {
      const db = mongoose.connection.db;
      const result = await db.collection(collectionName).createIndex(keys, options);
      
      this._logOperation('create_index', { 
        collectionName,
        keys,
        options,
        result
      });
      
      return {
        success: true,
        indexName: result,
        message: `成功创建索引 ${result}`
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 为集合 ${collectionName} 创建索引失败:`, error);
      throw error;
    }
  }
  
  /**
   * 删除索引
   * @param {string} collectionName - 集合名
   * @param {string} indexName - 索引名
   * @returns {Promise<Object>} 操作结果
   */
  async dropIndex(collectionName, indexName) {
    try {
      const db = mongoose.connection.db;
      await db.collection(collectionName).dropIndex(indexName);
      
      this._logOperation('drop_index', { 
        collectionName,
        indexName
      });
      
      return {
        success: true,
        message: `成功删除索引 ${indexName}`
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 删除集合 ${collectionName} 的索引 ${indexName} 失败:`, error);
      throw error;
    }
  }
  
  /**
   * 重建集合
   * @param {string} collectionName - 集合名
   * @returns {Promise<Object>} 操作结果
   */
  async reIndex(collectionName) {
    try {
      const db = mongoose.connection.db;
      const result = await db.command({ reIndex: collectionName });
      
      this._logOperation('reindex', { 
        collectionName,
        result
      });
      
      return {
        success: result.ok === 1,
        message: `重建索引完成: ${collectionName}`
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 重建集合 ${collectionName} 索引失败:`, error);
      throw error;
    }
  }
  
  /**
   * 压缩集合
   * @param {string} collectionName - 集合名
   * @returns {Promise<Object>} 操作结果
   */
  async compact(collectionName) {
    try {
      const db = mongoose.connection.db;
      const result = await db.command({ compact: collectionName });
      
      this._logOperation('compact', { 
        collectionName,
        result
      });
      
      return {
        success: result.ok === 1,
        message: `集合压缩完成: ${collectionName}`
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 压缩集合 ${collectionName} 失败:`, error);
      throw error;
    }
  }
  
  /**
   * 验证集合
   * @param {string} collectionName - 集合名
   * @returns {Promise<Object>} 验证结果
   */
  async validate(collectionName) {
    try {
      const db = mongoose.connection.db;
      const result = await db.command({ validate: collectionName, full: true });
      
      this._logOperation('validate', { 
        collectionName,
        valid: result.valid
      });
      
      return {
        success: result.ok === 1,
        valid: result.valid,
        errors: result.errors || [],
        message: result.valid ? '集合验证通过' : '集合验证发现问题'
      };
    } catch (error) {
      logger.error(`[DbOptimizationHelper] 验证集合 ${collectionName} 失败:`, error);
      throw error;
    }
  }
  
  /**
   * 获取数据库状态
   * @returns {Promise<Object>} 数据库状态
   */
  async getDatabaseStatus() {
    try {
      const db = mongoose.connection.db;
      const [dbStats, serverStatus, collections] = await Promise.all([
        db.stats(),
        db.admin().serverStatus(),
        db.listCollections().toArray()
      ]);
      
      // 获取每个集合的大小
      const collectionStats = await Promise.all(
        collections.map(async coll => {
          try {
            const stats = await db.collection(coll.name).stats();
            return {
              name: coll.name,
              count: stats.count,
              size: stats.size,
              avgObjSize: stats.avgObjSize,
              storageSize: stats.storageSize,
              indexSize: stats.totalIndexSize
            };
          } catch (err) {
            return {
              name: coll.name,
              error: err.message
            };
          }
        })
      );
      
      // 获取连接池状态
      const poolStats = await dbManager.getPoolStats();
      
      return {
        timestamp: new Date(),
        database: {
          name: db.databaseName,
          collections: dbStats.collections,
          dataSize: dbStats.dataSize,
          storageSize: dbStats.storageSize,
          indexes: dbStats.indexes,
          indexSize: dbStats.indexSize
        },
        server: {
          version: serverStatus.version,
          uptime: serverStatus.uptime,
          connections: serverStatus.connections,
          memory: serverStatus.mem
        },
        connectionPool: poolStats,
        collections: collectionStats
      };
    } catch (error) {
      logger.error('[DbOptimizationHelper] 获取数据库状态失败:', error);
      throw error;
    }
  }
  
  /**
   * 查找慢查询
   * @param {Object} options - 查询选项
   * @param {string} options.collection - 集合名
   * @param {number} options.minDuration - 最小持续时间(毫秒)
   * @param {number} options.limit - 最大返回数量
   * @returns {Promise<Array>} 慢查询列表
   */
  async findSlowQueries(options = {}) {
    try {
      const { collection, minDuration = 100, limit = 20 } = options;
      
      const DbMetrics = mongoose.model('DbMetrics');
      const query = {
        slow_query: true,
        duration: { $gt: minDuration }
      };
      
      if (collection) {
        query.collection = collection;
      }
      
      const slowQueries = await DbMetrics.find(query)
        .sort({ duration: -1 })
        .limit(limit)
        .select('operation collection duration query index_used timestamp');
      
      return slowQueries;
    } catch (error) {
      logger.error('[DbOptimizationHelper] 查找慢查询失败:', error);
      throw error;
    }
  }
  
  /**
   * 生成索引优化建议
   * @returns {Promise<Object>} 索引优化建议
   */
  async generateIndexRecommendations() {
    try {
      const db = mongoose.connection.db;
      const collections = await db.listCollections().toArray();
      
      const recommendations = [];
      
      for (const coll of collections) {
        try {
          const analysis = await this.analyzeCollection(coll.name);
          
          // 提取索引建议
          const indexSuggestions = analysis.suggestions.filter(s => 
            s.type === 'missing_indexes' || s.type === 'unused_indexes'
          );
          
          if (indexSuggestions.length > 0) {
            recommendations.push({
              collection: coll.name,
              suggestions: indexSuggestions
            });
          }
        } catch (err) {
          logger.error(`[DbOptimizationHelper] 分析集合 ${coll.name} 索引失败:`, err);
        }
      }
      
      return {
        timestamp: new Date(),
        recommendations
      };
    } catch (error) {
      logger.error('[DbOptimizationHelper] 生成索引建议失败:', error);
      throw error;
    }
  }
  
  /**
   * 内部记录所有数据库优化相关操作日志（用于调试或后台展示）
   */
  _logOperation(operation, data) {
    this.operationsLog.push({
      operation,
      timestamp: new Date(),
      data
    });
    
    // 限制日志长度
    if (this.operationsLog.length > this.maxLogsLength) {
      this.operationsLog.shift();
    }
  }
  
  /**
   * 获取操作日志
   * @returns {Array} 操作日志
   */
  getOperationsLog() {
    return this.operationsLog;
  }
}

// ✅ 单例导出：供全局使用
const dbOptimizationHelper = new DbOptimizationHelper();

module.exports = dbOptimizationHelper; 