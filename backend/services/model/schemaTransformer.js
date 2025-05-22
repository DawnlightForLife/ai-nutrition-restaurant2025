/**
 * Mongoose Schema 转换服务模块（schemaTransformer）
 * 提供以下功能：
 * - 将已注册的 Mongoose 模型转换为可视化格式（节点 + 字段 + 关系）
 * - 生成数据库结构图（图形化 + HTML）
 * - 检测模式结构缺陷（如命名不一致、字段过多、缺少索引等）
 * - 支持 SchemaGuardService 集成：冻结结构 + 模式历史
 * - 支持导出诊断报告用于数据库建模与优化
 * @module services/data/schemaTransformer
 */

const mongoose = require('mongoose');
const { logger } = require('../../utils/logger/winstonLogger.js');

class SchemaTransformer {
  constructor() {
    this.logger = logger.child({ service: 'SchemaTransformer' });
    this.logger.info('SchemaTransformer服务已初始化');
  }

  /**
   * 转换所有注册的Mongoose模型为可视化格式
   * @param {Object} options - 转换选项
   * @param {boolean} options.includeVirtuals - 是否包含虚拟字段
   * @param {boolean} options.includeIndexes - 是否包含索引信息
   * @param {boolean} options.includeHistory - 是否包含模式历史
   * @returns {Object} 转换后的模式数据
   */
  async transformAllModels(options = {}) {
    try {
      const {
        includeVirtuals = true,
        includeIndexes = true,
        includeHistory = true
      } = options;

      const result = {
        schemas: [],
        nodes: [],
        links: [],
        stats: {
          modelCount: 0,
          fieldCount: 0,
          relationCount: 0,
          indexCount: 0
        }
      };

      // 获取所有注册的模型
      const modelNames = mongoose.modelNames();
      this.logger.info(`发现${modelNames.length}个注册模型`);
      
      // 从SchemaGuardService中获取冻结的模式（如果存在）
      let frozenSchemas = [];
      try {
        const SchemaGuardService = require('./schemaGuardService');
        if (SchemaGuardService.getInstance) {
          const schemaGuard = SchemaGuardService.getInstance();
          frozenSchemas = await schemaGuard.getFrozenSchemas();
        }
      } catch (error) {
        this.logger.warn('无法获取冻结模式信息:', error.message);
      }

      // 处理每个模型
      for (const modelName of modelNames) {
        const model = mongoose.model(modelName);
        const schema = model.schema;
        
        // 跳过内部系统模型
        if (modelName.startsWith('system.') || modelName === 'schema_histories') {
          continue;
        }

        const modelInfo = this._transformModel(model, {
          includeVirtuals,
          includeIndexes,
          isFrozen: frozenSchemas.includes(modelName)
        });
        
        // 添加到结果中
        result.schemas.push(modelInfo);
        
        // 添加到图形节点中
        result.nodes.push({
          id: modelName,
          name: modelName,
          collection: model.collection.name,
          isFrozen: frozenSchemas.includes(modelName),
          fields: modelInfo.fields.map(f => ({ name: f.name, type: f.type }))
        });
        
        // 更新统计信息
        result.stats.modelCount++;
        result.stats.fieldCount += modelInfo.fields.length;
        result.stats.indexCount += modelInfo.indexes ? modelInfo.indexes.length : 0;
      }
      
      // 第二次遍历寻找关系
      for (const modelName of modelNames) {
        const model = mongoose.model(modelName);
        const schema = model.schema;
        
        // 跳过内部系统模型
        if (modelName.startsWith('system.') || modelName === 'schema_histories') {
          continue;
        }
        
        this._findRelationships(schema, modelName, result);
      }
      
      // 添加模式历史（如果请求）
      if (includeHistory) {
        await this._addSchemaHistory(result);
      }
      
      return result;
    } catch (error) {
      this.logger.error('转换模型时出错:', error);
      throw new Error(`转换模型失败: ${error.message}`);
    }
  }
  
  /**
   * 转换单个Mongoose模型为可视化格式
   * @private
   * @param {Object} model - Mongoose模型
   * @param {Object} options - 转换选项
   * @returns {Object} 转换后的模型数据
   */
  _transformModel(model, options = {}) {
    const { includeVirtuals, includeIndexes, isFrozen } = options;
    const schema = model.schema;
    const modelName = model.modelName;
    const collectionName = model.collection.name;
    
    // 创建基础模型信息
    const modelInfo = {
      modelName,
      collection: collectionName,
      isFrozen: isFrozen || false,
      fields: [],
      indexes: []
    };
    
    // 处理所有路径
    const paths = schema.paths;
    Object.keys(paths).forEach(pathName => {
      // 跳过MongoDB的内置字段
      if (pathName === '__v') return;
      
      const path = paths[pathName];
      const fieldInfo = this._transformField(path, pathName);
      modelInfo.fields.push(fieldInfo);
    });
    
    // 处理虚拟字段
    if (includeVirtuals && schema.virtuals) {
      Object.keys(schema.virtuals).forEach(virtualName => {
        // 排除mongoose内置虚拟属性
        if (['id', 'errors', 'isNew', 'populated'].includes(virtualName)) return;
        
        const virtual = schema.virtuals[virtualName];
        modelInfo.fields.push({
          name: virtualName,
          type: 'Virtual',
          isVirtual: true,
          required: false
        });
      });
    }
    
    // 处理索引
    if (includeIndexes && schema._indexes) {
      modelInfo.indexes = schema._indexes.map(([fields, options]) => {
        return {
          fields,
          name: options.name,
          unique: !!options.unique,
          sparse: !!options.sparse
        };
      });
    }
    
    return modelInfo;
  }
  
  /**
   * 转换单个字段为可视化格式
   * @private
   * @param {Object} path - Mongoose路径对象
   * @param {string} pathName - 字段路径名
   * @returns {Object} 转换后的字段数据
   */
  _transformField(path, pathName) {
    // 基础字段信息
    const fieldInfo = {
      name: pathName,
      type: this._getFieldType(path),
      required: path.isRequired || false,
      default: path.defaultValue,
      isIndexed: !!path._index,
      isUnique: !!path._index?.unique,
      isReference: false
    };
    
    // 处理引用类型
    if (path.instance === 'ObjectID' && path.options && path.options.ref) {
      fieldInfo.isReference = true;
      fieldInfo.reference = path.options.ref;
    }
    
    // 如果是数组且数组中包含引用
    if (path.instance === 'Array' && path.schema && path.schema.obj && path.schema.obj[0]) {
      const arrayItemType = path.schema.obj[0];
      if (arrayItemType.type === mongoose.Schema.Types.ObjectId && arrayItemType.ref) {
        fieldInfo.isReference = true;
        fieldInfo.reference = arrayItemType.ref;
        fieldInfo.type = `[ObjectId]`;
      }
    }
    
    return fieldInfo;
  }
  
  /**
   * 从字段路径获取字段类型
   * @private
   * @param {Object} path - Mongoose路径对象
   * @returns {string} 字段类型
   */
  _getFieldType(path) {
    let type = path.instance || 'Mixed';
    
    // 处理数组类型
    if (type === 'Array') {
      if (path.schema && path.schema.paths) {
        type = `[Object]`;
      } else if (path.caster) {
        type = `[${path.caster.instance || 'Mixed'}]`;
      }
    }
    
    // 处理嵌套文档
    if (type === 'Embedded') {
      type = 'Object';
    }
    
    // 处理枚举
    if (path.enumValues && path.enumValues.length) {
      type = `Enum(${path.enumValues.join(', ')})`;
    }
    
    return type;
  }
  
  /**
   * 查找模型间的关系并添加到links
   * @private
   * @param {Object} schema - Mongoose模式
   * @param {string} modelName - 模型名称
   * @param {Object} result - 结果对象
   */
  _findRelationships(schema, modelName, result) {
    const paths = schema.paths;
    
    Object.keys(paths).forEach(pathName => {
      const path = paths[pathName];
      
      // 检查是否为ObjectId引用
      if (path.instance === 'ObjectID' && path.options && path.options.ref) {
        const targetModel = path.options.ref;
        
        // 确保目标模型存在于nodes列表中
        if (result.nodes.some(node => node.id === targetModel)) {
          result.links.push({
            source: modelName,
            target: targetModel,
            field: pathName
          });
          result.stats.relationCount++;
        }
      }
      
      // 检查数组中的引用
      if (path.instance === 'Array' && path.schema && path.schema.obj && path.schema.obj[0]) {
        const arrayItemType = path.schema.obj[0];
        if (arrayItemType.type === mongoose.Schema.Types.ObjectId && arrayItemType.ref) {
          const targetModel = arrayItemType.ref;
          
          // 确保目标模型存在于nodes列表中
          if (result.nodes.some(node => node.id === targetModel)) {
            result.links.push({
              source: modelName,
              target: targetModel,
              field: pathName,
              isArray: true
            });
            result.stats.relationCount++;
          }
        }
      }
    });
  }
  
  /**
   * 添加模式历史信息（如果可用）
   * @private
   * @param {Object} result - 结果对象
   */
  async _addSchemaHistory(result) {
    try {
      // 尝试获取SchemaGuardService实例
      const SchemaGuardService = require('./schemaGuardService');
      if (!SchemaGuardService.getInstance) return;
      
      const schemaGuard = SchemaGuardService.getInstance();
      
      // 如果存在getSchemaHistory方法，则获取历史记录
      if (typeof schemaGuard.getSchemaHistory === 'function') {
        const history = await schemaGuard.getSchemaHistory();
        
        // 将历史记录添加到相应的模式
        if (history && Array.isArray(history)) {
          history.forEach(entry => {
            const schema = result.schemas.find(s => s.modelName === entry.modelName);
            if (schema) {
              if (!schema.history) schema.history = [];
              schema.history.push({
                timestamp: entry.timestamp,
                action: entry.action,
                details: entry.details || '无详细信息'
              });
            }
          });
        }
      }
    } catch (error) {
      this.logger.warn('获取模式历史记录时出错:', error.message);
    }
  }

  /**
   * 生成模型关系图的数据
   * @param {Object} options - 配置选项
   * @returns {Object} 关系图数据，包含节点和连接
   */
  async generateRelationshipGraph(options = {}) {
    try {
      const result = await this.transformAllModels({
        includeVirtuals: options.includeVirtuals !== false,
        includeIndexes: options.includeIndexes !== false,
        includeHistory: false
      });
      
      // 增强节点数据
      result.nodes = result.nodes.map(node => {
        const schema = result.schemas.find(s => s.modelName === node.id);
        const fieldCount = schema ? schema.fields.length : 0;
        
        return {
          ...node,
          fieldCount,
          // 基于模型字段数量动态计算节点大小
          size: Math.max(30, Math.min(100, 30 + fieldCount * 3)),
          // 颜色基于是否被冻结
          color: node.isFrozen ? '#e74c3c' : '#3498db'
        };
      });
      
      // 增强连接数据
      result.links = result.links.map(link => {
        return {
          ...link,
          // 数组引用使用虚线，普通引用使用实线
          dashed: link.isArray === true,
          // 为连接添加标签
          label: link.field,
          // 设置箭头样式
          arrows: 'to'
        };
      });
      
      return {
        nodes: result.nodes,
        links: result.links
      };
    } catch (error) {
      this.logger.error('生成关系图数据时出错:', error);
      throw new Error(`生成关系图数据失败: ${error.message}`);
    }
  }

  /**
   * 检测模式中的安全问题和设计缺陷
   * @param {Object} options - 配置选项
   * @returns {Array} 发现的问题列表
   */
  async detectSchemaIssues(options = {}) {
    try {
      const schemas = await this.transformAllModels({
        includeVirtuals: true,
        includeIndexes: true
      });
      
      const issues = [];
      
      // 检查每个模式
      for (const schema of schemas.schemas) {
        // 检查是否缺少必要的索引
        this._checkMissingIndexes(schema, issues);
        
        // 检查是否有安全隐患
        this._checkSecurityIssues(schema, issues);
        
        // 检查是否有性能隐患
        this._checkPerformanceIssues(schema, issues);
        
        // 检查模式设计问题
        this._checkDesignIssues(schema, issues);
      }
      
      // 检查整体结构问题
      this._checkStructuralIssues(schemas, issues);
      
      return issues;
    } catch (error) {
      this.logger.error('检测模式问题时出错:', error);
      throw new Error(`检测模式问题失败: ${error.message}`);
    }
  }
  
  /**
   * 检查模式中缺少的索引
   * @private
   * @param {Object} schema - 模式对象
   * @param {Array} issues - 问题列表
   */
  _checkMissingIndexes(schema, issues) {
    // 检查频繁查询但没有索引的字段
    const frequentlyQueryFields = ['createdAt', 'updatedAt', 'status', 'type', 'userId'];
    
    frequentlyQueryFields.forEach(fieldName => {
      const field = schema.fields.find(f => f.name === fieldName);
      if (field && !field.isIndexed) {
        issues.push({
          type: 'MISSING_INDEX',
          level: 'warning',
          modelName: schema.modelName,
          field: fieldName,
          message: `模型 ${schema.modelName} 的 ${fieldName} 字段可能需要索引以提高查询性能`
        });
      }
    });
    
    // 检查数组类型的引用字段，可能需要多键索引
    schema.fields.forEach(field => {
      if (field.type.startsWith('[') && field.isReference && !field.isIndexed) {
        issues.push({
          type: 'ARRAY_REFERENCE_NO_INDEX',
          level: 'warning',
          modelName: schema.modelName,
          field: field.name,
          message: `模型 ${schema.modelName} 的数组引用字段 ${field.name} 可能需要多键索引`
        });
      }
    });
  }
  
  /**
   * 检查模式中的安全问题
   * @private
   * @param {Object} schema - 模式对象
   * @param {Array} issues - 问题列表
   */
  _checkSecurityIssues(schema, issues) {
    // 检查敏感字段是否有适当的保护
    const sensitiveFields = ['password', 'token', 'secret', 'apiKey', 'creditCard', 'ssn'];
    
    schema.fields.forEach(field => {
      const fieldNameLower = field.name.toLowerCase();
      const isSensitive = sensitiveFields.some(sf => fieldNameLower.includes(sf.toLowerCase()));
      
      if (isSensitive) {
        // 检查是否有select: false选项
        if (!field.options || !field.options.select === false) {
          issues.push({
            type: 'SENSITIVE_FIELD_EXPOSURE',
            level: 'error',
            modelName: schema.modelName,
            field: field.name,
            message: `模型 ${schema.modelName} 中的敏感字段 ${field.name} 应设置 select: false 选项`
          });
        }
        
        // 检查密码字段是否有验证器
        if (fieldNameLower.includes('password') && (!field.validate || !field.validate.validator)) {
          issues.push({
            type: 'WEAK_PASSWORD_VALIDATION',
            level: 'error',
            modelName: schema.modelName,
            field: field.name,
            message: `模型 ${schema.modelName} 中的密码字段 ${field.name} 缺少密码强度验证器`
          });
        }
      }
    });
  }
  
  /**
   * 检查模式中的性能问题
   * @private
   * @param {Object} schema - 模式对象
   * @param {Array} issues - 问题列表
   */
  _checkPerformanceIssues(schema, issues) {
    // 检查过大的文档结构
    if (schema.fields.length > 30) {
      issues.push({
        type: 'LARGE_DOCUMENT_STRUCTURE',
        level: 'warning',
        modelName: schema.modelName,
        message: `模型 ${schema.modelName} 有超过30个字段，可能导致文档过大`
      });
    }
    
    // 检查嵌套深度过深的文档
    const nestedPaths = schema.fields.filter(f => f.name.includes('.'));
    const maxNestingLevel = nestedPaths.reduce((max, field) => {
      const level = field.name.split('.').length;
      return Math.max(max, level);
    }, 0);
    
    if (maxNestingLevel > 3) {
      issues.push({
        type: 'DEEP_NESTING',
        level: 'warning',
        modelName: schema.modelName,
        message: `模型 ${schema.modelName} 嵌套深度超过3层，可能影响查询性能`
      });
    }
  }
  
  /**
   * 检查模式中的设计问题
   * @private
   * @param {Object} schema - 模式对象
   * @param {Array} issues - 问题列表
   */
  _checkDesignIssues(schema, issues) {
    // 检查不一致的命名模式
    const fieldNames = schema.fields.map(f => f.name);
    
    const camelCasePattern = /^[a-z]+[A-Za-z0-9]*$/;
    const snake_case_pattern = /^[a-z]+[a-z0-9_]*$/;
    
    let camelCaseCount = 0;
    let snakeCaseCount = 0;
    
    fieldNames.forEach(name => {
      if (camelCasePattern.test(name)) camelCaseCount++;
      if (snake_case_pattern.test(name)) snakeCaseCount++;
    });
    
    if (camelCaseCount > 0 && snakeCaseCount > 0) {
      issues.push({
        type: 'INCONSISTENT_NAMING',
        level: 'warning',
        modelName: schema.modelName,
        message: `模型 ${schema.modelName} 使用了不一致的命名风格（混合了驼峰命名和蛇形命名）`
      });
    }
    
    // 检查缺少时间戳字段
    const hasCreatedAt = schema.fields.some(f => ['createdAt', 'created_at'].includes(f.name));
    const hasUpdatedAt = schema.fields.some(f => ['updatedAt', 'updated_at'].includes(f.name));
    
    if (!hasCreatedAt || !hasUpdatedAt) {
      issues.push({
        type: 'MISSING_TIMESTAMPS',
        level: 'info',
        modelName: schema.modelName,
        message: `模型 ${schema.modelName} 可能缺少时间戳字段`
      });
    }
  }
  
  /**
   * 检查整体结构问题
   * @private
   * @param {Object} schemas - 所有模式
   * @param {Array} issues - 问题列表
   */
  _checkStructuralIssues(schemas, issues) {
    // 检查循环引用
    const graph = {};
    
    // 构建引用图
    schemas.links.forEach(link => {
      if (!graph[link.source]) graph[link.source] = [];
      graph[link.source].push(link.target);
    });
    
    // 检查是否有循环引用
    const visited = new Set();
    const recursionStack = new Set();
    
    function checkCycle(node) {
      if (!graph[node]) return false;
      
      visited.add(node);
      recursionStack.add(node);
      
      for (const neighbor of graph[node]) {
        if (!visited.has(neighbor)) {
          if (checkCycle(neighbor)) return true;
        } else if (recursionStack.has(neighbor)) {
          return true;
        }
      }
      
      recursionStack.delete(node);
      return false;
    }
    
    for (const node of Object.keys(graph)) {
      if (!visited.has(node)) {
        if (checkCycle(node)) {
          issues.push({
            type: 'CIRCULAR_REFERENCE',
            level: 'warning',
            message: '数据模型中存在循环引用，可能导致无限递归问题'
          });
          break;
        }
      }
    }
  }

  /**
   * 生成模式可视化的HTML报告
   * @param {Object} options - 配置选项
   * @returns {String} HTML报告内容
   */
  async generateHTMLReport(options = {}) {
    try {
      const schemas = await this.transformAllModels({
        includeVirtuals: options.includeVirtuals !== false,
        includeIndexes: options.includeIndexes !== false,
        includeHistory: options.includeHistory !== false
      });
      
      // 检测模式问题
      const issues = options.includeIssues ? await this.detectSchemaIssues() : [];
      
      // 使用模板引擎生成HTML报告
      const fs = require('fs');
      const path = require('path');
      const handlebars = require('handlebars');
      
      // 读取HTML模板
      const templatePath = path.join(__dirname, '../../../templates/schema-visualization.hbs');
      const templateExists = fs.existsSync(templatePath);
      
      if (!templateExists) {
        throw new Error(`模板文件不存在: ${templatePath}`);
      }
      
      const templateSource = fs.readFileSync(templatePath, 'utf8');
      const template = handlebars.compile(templateSource);
      
      // 生成报告时间
      const reportTime = new Date().toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      });
      
      // 生成HTML报告
      const html = template({
        schemas: schemas.schemas,
        nodes: schemas.nodes,
        links: schemas.links,
        stats: schemas.stats,
        issues,
        reportTime,
        options: {
          title: options.title || '数据库模式可视化报告',
          includeIssues: !!options.includeIssues,
          includeHistory: !!options.includeHistory
        }
      });
      
      return html;
    } catch (error) {
      this.logger.error('生成HTML报告时出错:', error);
      throw new Error(`生成HTML报告失败: ${error.message}`);
    }
  }
}

// 创建单例实例
let instance = null;

/**
 * 获取SchemaTransformer实例
 * @returns {SchemaTransformer} SchemaTransformer实例
 */
function getInstance() {
  if (!instance) {
    instance = new SchemaTransformer();
  }
  return instance;
}

module.exports = {
  SchemaTransformer,
  getInstance
}; 