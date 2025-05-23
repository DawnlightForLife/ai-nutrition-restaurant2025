/**
 * Schema 分析服务模块（SchemaAnalysisService）
 * 分析 MongoDB 所有 Mongoose 模型结构，识别潜在问题，生成优化建议并输出指标数据
 * 检测内容包括结构冗余、复合索引机会、安全性、孤立模型、重复集合名、性能瓶颈等
 * 自动集成性能指标采集与建议排序逻辑，支持定时分析与事件通知
 * @module services/core/schemaAnalysisService
 */

const mongoose = require('mongoose');
const { logger } = require('../../utils/logger/winstonLogger.js');
const schemaTransformer = require('../../utils/schema/schemaTransformer');
const EventEmitter = require('events');

/**
 * Schema分析服务 - 分析MongoDB模式并提供优化建议
 */
class SchemaAnalysisService extends EventEmitter {
  /**
   * 创建SchemaAnalysisService实例
   * @param {Object} options - 配置选项
   * @param {Boolean} options.autoAnalyze - 是否在初始化时自动分析
   * @param {Number} options.analyzeInterval - 自动分析间隔（毫秒）
   * @param {Boolean} options.enablePerformanceMetrics - 是否收集性能指标
   */
  constructor(options = {}) {
    super();
    
    this.options = {
      autoAnalyze: options.autoAnalyze !== false,
      analyzeInterval: options.analyzeInterval || 24 * 60 * 60 * 1000, // 默认每24小时
      enablePerformanceMetrics: options.enablePerformanceMetrics !== false
    };
    
    this.logger = logger.child({ service: 'SchemaAnalysisService' });
    this.initialized = false;
    this.analyzing = false;
    this.lastAnalysisTime = null;
    this.analysisResults = {
      schemas: {},
      issues: [],
      recommendations: [],
      performanceMetrics: {}
    };
    
    this.logger.info('SchemaAnalysisService实例已创建');
  }
  
  /**
   * 初始化服务
   * @returns {Promise<void>}
   */
  async initialize() {
    try {
      this.logger.info('正在初始化SchemaAnalysisService...');
      
      // 确保SchemaTransformer可用
      if (!schemaTransformer) {
        throw new Error('SchemaTransformer服务不可用');
      }
      
      // 如果启用自动分析，设置定时任务
      if (this.options.autoAnalyze) {
        this._setupAutoAnalysis();
        
        // 初始分析
        await this.analyzeAllSchemas();
      }
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('SchemaAnalysisService初始化完成');
    } catch (error) {
      this.logger.error('初始化 SchemaAnalysisService 失败', { error });
      throw error;
    }
  }
  
  /**
   * 设置自动分析任务
   * @private
   */
  _setupAutoAnalysis() {
    this.logger.info(`设置自动分析任务，间隔: ${this.options.analyzeInterval}ms`);
    
    // 清除已有的定时器
    if (this.analysisTimer) {
      clearInterval(this.analysisTimer);
    }
    
    // 设置新的定时器
    this.analysisTimer = setInterval(async () => {
      try {
        this.logger.info('执行定时Schema分析...');
        await this.analyzeAllSchemas();
      } catch (error) {
        this.logger.error('定时Schema分析失败:', error);
      }
    }, this.options.analyzeInterval);
  }
  
  /**
   * 分析所有模式
   * @returns {Promise<Object>} 分析结果
   */
  async analyzeAllSchemas() {
    if (!this.initialized && !this.options.autoAnalyze) {
      await this.initialize();
    }
    
    if (this.analyzing) {
      this.logger.warn('分析已在进行中，请稍后再试');
      return this.analysisResults;
    }
    
    try {
      this.analyzing = true;
      this.emit('analysis:start');
      
      this.logger.info('开始分析所有Schema...');
      
      // 重置分析结果
      this.analysisResults = {
        schemas: {},
        issues: [],
        recommendations: [],
        performanceMetrics: {}
      };
      
      // 获取所有模型数据
      const schemaData = await schemaTransformer.transformAllModels({
        includeVirtuals: true,
        includeIndexes: true,
        includeHistory: true
      });
      
      // 存储基础模式信息
      this.analysisResults.schemas = schemaData.schemas.reduce((acc, schema) => {
        acc[schema.modelName] = schema;
        return acc;
      }, {});
      
      // 分析结构问题
      await this._analyzeStructuralIssues(schemaData);
      
      // 分析性能问题
      await this._analyzePerformanceIssues(schemaData);
      
      // 分析安全问题
      await this._analyzeSecurityIssues(schemaData);
      
      // 生成优化建议
      this._generateRecommendations();
      
      // 如果启用了性能指标，收集指标
      if (this.options.enablePerformanceMetrics) {
        await this._collectPerformanceMetrics();
      }
      
      // 更新分析时间
      this.lastAnalysisTime = new Date();
      
      this.logger.info('Schema分析完成', {
        issueCount: this.analysisResults.issues.length,
        recommendationCount: this.analysisResults.recommendations.length
      });
      
      this.emit('analysis:complete', this.analysisResults);
      return this.analysisResults;
    } catch (error) {
      this.logger.error('分析 Schema 时出错', { error });
      this.emit('analysis:error', error);
      throw error;
    } finally {
      this.analyzing = false;
    }
  }
  
  /**
   * 分析结构问题
   * @private
   * @param {Object} schemaData - 模式数据
   */
  async _analyzeStructuralIssues(schemaData) {
    this.logger.info('分析模式结构问题...');
    
    // 使用schemaTransformer的检测功能
    const structuralIssues = await schemaTransformer.detectSchemaIssues();
    
    // 添加到结果中
    this.analysisResults.issues.push(...structuralIssues);
    
    // 检查额外的结构问题
    
    // 1. 检查重复的集合名
    const collectionNames = {};
    schemaData.schemas.forEach(schema => {
      if (!collectionNames[schema.collection]) {
        collectionNames[schema.collection] = [];
      }
      collectionNames[schema.collection].push(schema.modelName);
    });
    
    Object.entries(collectionNames).forEach(([collection, models]) => {
      if (models.length > 1) {
        this.analysisResults.issues.push({
          type: 'DUPLICATE_COLLECTION',
          level: 'warning',
          collection,
          models,
          message: `多个模型(${models.join(', ')})使用同一个集合(${collection})`
        });
      }
    });
    
    // 2. 检查孤立模型（没有关联到其他模型）
    schemaData.schemas.forEach(schema => {
      const hasOutgoingLinks = schemaData.links.some(link => link.source === schema.modelName);
      const hasIncomingLinks = schemaData.links.some(link => link.target === schema.modelName);
      
      if (!hasOutgoingLinks && !hasIncomingLinks) {
        this.analysisResults.issues.push({
          type: 'ISOLATED_MODEL',
          level: 'info',
          modelName: schema.modelName,
          message: `模型 ${schema.modelName} 没有与其他模型的关联`
        });
      }
    });
  }
  
  /**
   * 分析性能问题
   * @private
   * @param {Object} schemaData - 模式数据
   */
  async _analyzePerformanceIssues(schemaData) {
    this.logger.info('分析性能问题...');
    
    // 检查索引问题
    schemaData.schemas.forEach(schema => {
      // 检查是否有过多的索引
      if (schema.indexes && schema.indexes.length > 5) {
        this.analysisResults.issues.push({
          type: 'TOO_MANY_INDEXES',
          level: 'warning',
          modelName: schema.modelName,
          indexCount: schema.indexes.length,
          message: `模型 ${schema.modelName} 有 ${schema.indexes.length} 个索引，可能会影响写入性能`
        });
      }
      
      // 检查可能的复合索引机会
      const singleFieldIndexes = {};
      
      if (schema.indexes) {
        schema.indexes.forEach(index => {
          const fieldKeys = Object.keys(index.fields);
          
          if (fieldKeys.length === 1) {
            const field = fieldKeys[0];
            if (!singleFieldIndexes[field]) {
              singleFieldIndexes[field] = [];
            }
            singleFieldIndexes[field].push(index);
          }
        });
      }
      
      // 查找频繁同时查询的字段
      const frequentlyQueriedTogether = [
        ['createdAt', 'userId'],
        ['status', 'type'],
        ['updatedAt', 'status']
      ];
      
      frequentlyQueriedTogether.forEach(fields => {
        // 检查这些字段是否都有单独的索引
        const allHaveSingleIndex = fields.every(field => singleFieldIndexes[field]);
        
        // 检查是否已经有复合索引
        const hasCompoundIndex = schema.indexes ? schema.indexes.some(index => {
          const indexFields = Object.keys(index.fields);
          return fields.every(field => indexFields.includes(field));
        }) : false;
        
        if (allHaveSingleIndex && !hasCompoundIndex) {
          this.analysisResults.issues.push({
            type: 'COMPOUND_INDEX_OPPORTUNITY',
            level: 'info',
            modelName: schema.modelName,
            fields,
            message: `模型 ${schema.modelName} 上字段 ${fields.join(', ')} 有单独索引但可能受益于复合索引`
          });
        }
      });
    });
  }
  
  /**
   * 分析安全问题
   * @private
   * @param {Object} schemaData - 模式数据
   */
  async _analyzeSecurityIssues(schemaData) {
    this.logger.info('分析安全问题...');
    
    // 检查缺少验证的敏感字段
    const sensitiveFieldPatterns = [
      { pattern: /password/i, validator: true, select: false },
      { pattern: /token/i, select: false },
      { pattern: /api[_-]?key/i, select: false },
      { pattern: /secret/i, select: false },
      { pattern: /credit[_-]?card/i, validator: true, select: false },
      { pattern: /ssn|social[_-]?security/i, validator: true, select: false },
      { pattern: /phone/i, validator: true }
    ];
    
    schemaData.schemas.forEach(schema => {
      schema.fields.forEach(field => {
        sensitiveFieldPatterns.forEach(pattern => {
          if (pattern.pattern.test(field.name)) {
            // 检查是否有必要的安全设置
            const issues = [];
            
            if (pattern.validator && (!field.validate || !field.validate.validator)) {
              issues.push('缺少验证器');
            }
            
            if (pattern.select !== undefined && field.select !== pattern.select) {
              issues.push(`应设置 select: ${pattern.select}`);
            }
            
            if (issues.length > 0) {
              this.analysisResults.issues.push({
                type: 'SENSITIVE_FIELD_SECURITY',
                level: 'error',
                modelName: schema.modelName,
                field: field.name,
                issues,
                message: `模型 ${schema.modelName} 中的敏感字段 ${field.name} 存在安全问题: ${issues.join(', ')}`
              });
            }
          }
        });
      });
    });
  }
  
  /**
   * 收集性能指标
   * @private
   */
  async _collectPerformanceMetrics() {
    try {
      this.logger.info('收集数据库性能指标...');
      
      // 获取数据库状态
      const dbStatus = await mongoose.connection.db.stats();
      
      // 获取集合统计信息
      const collections = await mongoose.connection.db.listCollections().toArray();
      const collectionStats = [];
      
      for (const collection of collections) {
        if (!collection.name.startsWith('system.')) {
          const stats = await mongoose.connection.db.collection(collection.name).stats();
          collectionStats.push({
            name: collection.name,
            count: stats.count,
            size: stats.size,
            avgDocSize: stats.avgObjSize,
            storageSize: stats.storageSize,
            indexes: stats.nindexes,
            indexSize: stats.totalIndexSize
          });
        }
      }
      
      // 保存指标
      this.analysisResults.performanceMetrics = {
        timestamp: new Date(),
        databaseSize: dbStatus.dataSize,
        storageSize: dbStatus.storageSize,
        indexes: dbStatus.indexes,
        indexSize: dbStatus.indexSize,
        collections: collectionStats
      };
      
      this.logger.info('性能指标收集完成');
    } catch (error) {
      this.logger.error('收集性能指标失败', { error });
    }
  }
  
  /**
   * 生成优化建议
   * @private
   */
  _generateRecommendations() {
    this.logger.info('基于分析结果生成优化建议...');
    
    // 根据问题类型生成建议
    const recommendations = [];
    
    // 映射问题类型到建议
    const recommendationMap = {
      'MISSING_INDEX': (issue) => ({
        type: 'ADD_INDEX',
        priority: 'high',
        modelName: issue.modelName,
        field: issue.field,
        message: `为模型 ${issue.modelName} 的 ${issue.field} 字段添加索引以提高查询性能`
      }),
      'SENSITIVE_FIELD_SECURITY': (issue) => ({
        type: 'ENHANCE_SECURITY',
        priority: 'critical',
        modelName: issue.modelName,
        field: issue.field,
        message: `增强模型 ${issue.modelName} 中敏感字段 ${issue.field} 的安全性: ${issue.issues.join(', ')}`
      }),
      'LARGE_DOCUMENT_STRUCTURE': (issue) => ({
        type: 'REFACTOR_MODEL',
        priority: 'medium',
        modelName: issue.modelName,
        message: `考虑拆分模型 ${issue.modelName}，可能的方法包括：使用子文档、引用或创建单独的集合`
      }),
      'COMPOUND_INDEX_OPPORTUNITY': (issue) => ({
        type: 'OPTIMIZE_INDEXES',
        priority: 'medium',
        modelName: issue.modelName,
        fields: issue.fields,
        message: `考虑为模型 ${issue.modelName} 的字段 ${issue.fields.join(', ')} 创建复合索引以优化查询性能`
      }),
      'TOO_MANY_INDEXES': (issue) => ({
        type: 'REVIEW_INDEXES',
        priority: 'medium',
        modelName: issue.modelName,
        message: `审查模型 ${issue.modelName} 的索引使用情况，考虑移除不常用的索引以提高写入性能`
      }),
      'DUPLICATE_COLLECTION': (issue) => ({
        type: 'COLLECTION_NAMING',
        priority: 'low',
        collection: issue.collection,
        models: issue.models,
        message: `检查使用同一集合(${issue.collection})的多个模型设计，确认这是有意为之`
      }),
      'CIRCULAR_REFERENCE': (issue) => ({
        type: 'REFACTOR_RELATIONSHIPS',
        priority: 'high',
        message: '重构模型关系以消除循环引用，可能的方法包括：使用单向引用或中间集合'
      })
    };
    
    // 为每个问题生成建议
    this.analysisResults.issues.forEach(issue => {
      const recommendationGenerator = recommendationMap[issue.type];
      
      if (recommendationGenerator) {
        const recommendation = recommendationGenerator(issue);
        
        // 添加问题参考
        recommendation.relatedIssue = issue;
        
        // 添加到建议列表
        recommendations.push(recommendation);
      }
    });
    
    // 如果没有基于问题的建议，添加默认建议
    if (recommendations.length === 0) {
      recommendations.push({
        type: 'GENERAL_HEALTH',
        priority: 'low',
        message: '数据库模式结构良好，继续监控性能和使用模式以确定将来的优化机会'
      });
    }
    
    // 排序建议（按优先级）
    const priorityMap = { 'critical': 0, 'high': 1, 'medium': 2, 'low': 3 };
    
    recommendations.sort((a, b) => {
      return priorityMap[a.priority] - priorityMap[b.priority];
    });
    
    this.analysisResults.recommendations = recommendations;
    this.logger.info(`生成了 ${recommendations.length} 条优化建议`);
  }
  
  /**
   * 获取最新的分析结果
   * @returns {Object} 分析结果
   */
  getAnalysisResults() {
    if (!this.lastAnalysisTime) {
      return { error: '尚未执行分析' };
    }
    
    return {
      ...this.analysisResults,
      lastAnalysisTime: this.lastAnalysisTime
    };
  }
  
  /**
   * 获取特定模型的分析结果
   * @param {String} modelName - 模型名称
   * @returns {Object} 特定模型的分析结果
   */
  getModelAnalysis(modelName) {
    if (!this.lastAnalysisTime) {
      return { error: '尚未执行分析' };
    }
    
    const modelSchema = this.analysisResults.schemas[modelName];
    
    if (!modelSchema) {
      return { error: `未找到模型: ${modelName}` };
    }
    
    // 筛选出与此模型相关的问题和建议
    const issues = this.analysisResults.issues.filter(issue => 
      issue.modelName === modelName
    );
    
    const recommendations = this.analysisResults.recommendations.filter(rec => 
      rec.modelName === modelName
    );
    
    return {
      modelName,
      schema: modelSchema,
      issues,
      recommendations,
      lastAnalysisTime: this.lastAnalysisTime
    };
  }
  
  /**
   * 获取数据库性能指标
   * @returns {Object} 性能指标
   */
  getPerformanceMetrics() {
    if (!this.options.enablePerformanceMetrics) {
      return { error: '性能指标收集未启用' };
    }
    
    if (!this.analysisResults.performanceMetrics || !this.analysisResults.performanceMetrics.timestamp) {
      return { error: '尚未收集性能指标' };
    }
    
    return this.analysisResults.performanceMetrics;
  }
  
  /**
   * 停止服务
   * @returns {Promise<void>}
   */
  async stop() {
    this.logger.info('正在停止SchemaAnalysisService...');
    
    if (this.analysisTimer) {
      clearInterval(this.analysisTimer);
      this.analysisTimer = null;
    }
    
    this.initialized = false;
    this.emit('stopped');
    
    this.logger.info('SchemaAnalysisService已停止');
  }
}

// 创建单例实例
let instance = null;

/**
 * 获取SchemaAnalysisService实例
 * @param {Object} options - 配置选项
 * @returns {SchemaAnalysisService} SchemaAnalysisService实例
 */
function getInstance(options = {}) {
  if (!instance) {
    instance = new SchemaAnalysisService(options);
  }
  return instance;
}

module.exports = {
  SchemaAnalysisService,
  getInstance
}; 