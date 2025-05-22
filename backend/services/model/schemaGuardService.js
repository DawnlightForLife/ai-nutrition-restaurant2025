/**
 * Schema Guard 服务模块（SchemaGuardService）
 * 用于监控与保护 MongoDB 中的模型 Schema 结构
 * 支持结构快照、冻结、变更检测、历史追踪、安全性分析等功能
 * 与 Mongoose 集成，用于保障大型系统中模型结构的稳定性与安全性
 * @module services/core/schemaGuardService
 */
/**
 * 模式守卫服务 - 监控和保护MongoDB模式结构
 * 提供模式验证、冻结和变更检测功能
 */
const mongoose = require('mongoose');
const { EventEmitter } = require('events');
const crypto = require('crypto');
const logger = require('../../utils/logger/winstonLogger.js');

class SchemaGuardService extends EventEmitter {
  constructor(options = {}) {
    super();
    this.initialized = false;
    this.config = {
      autoFreeze: options.autoFreeze || false,
      validateOnInit: options.validateOnInit !== false,
      securityChecks: options.securityChecks !== false,
      ...options
    };
    
    this.frozenSchemas = new Map();
    this.schemaSnapshots = new Map();
    this.schemaHistory = new Map();
    this.logger = logger.child({ service: 'SchemaGuardService' });
  }

  /**
   * 初始化服务
   */
  async initialize() {
    try {
      if (this.initialized) {
        this.logger.warn('服务已经初始化');
        return true;
      }
      
      this.logger.info('初始化SchemaGuardService', { config: this.config });
      
      // 初始化模式历史集合
      await this._initSchemaHistoryCollection();
      
      // 如果需要，验证所有现有模型
      if (this.config.validateOnInit) {
        await this._validateExistingModels();
      }
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('SchemaGuardService初始化完成');
      return true;
    } catch (error) {
      this.logger.error('初始化 SchemaGuardService 失败', { error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 初始化模式历史集合
   */
  async _initSchemaHistoryCollection() {
    try {
      // 检查是否已存在模式历史集合
      const collections = await mongoose.connection.db.listCollections({ name: 'schema_history' }).toArray();
      
      if (collections.length === 0) {
        // 创建模式历史集合
        await mongoose.connection.db.createCollection('schema_history');
        
        // 创建索引
        await mongoose.connection.db.collection('schema_history').createIndex(
          { modelName: 1, timestamp: -1 },
          { name: 'idx_model_timestamp' }
        );
        
        this.logger.info('创建模式历史集合');
      }
      
      // 加载现有的模式历史
      await this._loadSchemaHistory();
      
      return true;
    } catch (error) {
      this.logger.error('初始化模式历史集合失败', { error });
      throw error;
    }
  }

  /**
   * 加载模式历史
   */
  async _loadSchemaHistory() {
    try {
      const historyRecords = await mongoose.connection.db
        .collection('schema_history')
        .find({})
        .sort({ modelName: 1, timestamp: -1 })
        .toArray();
      
      // 按模型名称分组
      for (const record of historyRecords) {
        if (!this.schemaHistory.has(record.modelName)) {
          this.schemaHistory.set(record.modelName, []);
        }
        
        this.schemaHistory.get(record.modelName).push(record);
      }
      
      this.logger.debug('加载模式历史', { 
        modelsLoaded: this.schemaHistory.size,
        totalRecords: historyRecords.length 
      });
      
      return true;
    } catch (error) {
      this.logger.error('加载模式历史失败', { error });
      throw error;
    }
  }

  /**
   * 验证所有现有模型
   */
  async _validateExistingModels() {
    try {
      const modelNames = mongoose.modelNames();
      this.logger.info('验证所有现有模型', { count: modelNames.length });
      
      const results = {
        valid: [],
        invalid: []
      };
      
      for (const modelName of modelNames) {
        try {
          const model = mongoose.model(modelName);
          
          if (!model) continue;
          
          const result = await this.validateModelStructure(modelName, model.schema);
          
          if (result.valid) {
            results.valid.push(modelName);
          } else {
            results.invalid.push({ modelName, issues: result.issues });
          }
          
          // 如果配置了自动冻结，则冻结模式
          if (this.config.autoFreeze) {
            await this.freezeSchema(modelName, model.schema);
          }
        } catch (error) {
          this.logger.error('验证模型失败', { modelName, error });
          results.invalid.push({ modelName, error: error.message });
        }
      }
      
      this.logger.info('验证所有现有模型完成', { 
        valid: results.valid.length, 
        invalid: results.invalid.length 
      });
      
      if (results.invalid.length > 0) {
        this.logger.warn('发现无效模型', { models: results.invalid });
      }
      
      return results;
    } catch (error) {
      this.logger.error('验证所有现有模型失败', { error });
      throw error;
    }
  }

  /**
   * 验证模型结构
   */
  async validateModelStructure(modelName, schema) {
    try {
      this.logger.debug('验证模型结构', { modelName });
      
      if (!schema) {
        const model = mongoose.model(modelName);
        schema = model.schema;
      }
      
      const issues = [];
      
      // 检查模式是否存在
      if (!schema) {
        issues.push({
          level: 'error',
          message: '模式不存在'
        });
        
        return { valid: false, issues };
      }
      
      // 检查基本结构
      if (!schema.paths || Object.keys(schema.paths).length === 0) {
        issues.push({
          level: 'error',
          message: '模式没有定义任何路径'
        });
      }
      
      // 检查必需字段
      if (!schema.paths._id) {
        issues.push({
          level: 'warning',
          message: '模式缺少_id字段'
        });
      }
      
      // 如果启用了安全检查，检查潜在的安全问题
      if (this.config.securityChecks) {
        const securityIssues = this._checkSchemaSecurity(schema);
        issues.push(...securityIssues);
      }
      
      // 如果是冻结模式，检查是否有变更
      if (this.frozenSchemas.has(modelName)) {
        const frozenSchema = this.frozenSchemas.get(modelName);
        const schemaChanges = this.detectSchemaChanges(modelName, frozenSchema, schema);
        
        if (schemaChanges) {
          issues.push({
            level: 'error',
            message: '模式已冻结但检测到变更',
            changes: schemaChanges
          });
        }
      }
      
      // 存储模式快照
      this._storeSchemaSnapshot(modelName, schema);
      
      return {
        valid: issues.filter(i => i.level === 'error').length === 0,
        issues: issues
      };
    } catch (error) {
      this.logger.error('验证模型结构失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 检查模式安全性
   */
  _checkSchemaSecurity(schema) {
    const issues = [];
    
    // 检查潜在的注入风险
    for (const pathKey in schema.paths) {
      const path = schema.paths[pathKey];
      
      // 检查字符串字段是否有验证
      if (path.instance === 'String' && (!path.validators || path.validators.length === 0)) {
        issues.push({
          level: 'warning',
          message: `字段 ${pathKey} 是字符串类型但没有验证器`,
          path: pathKey
        });
      }
      
      // 检查是否有JavaScript函数字符串
      if (path.instance === 'String' && pathKey.toLowerCase().includes('script')) {
        issues.push({
          level: 'warning',
          message: `字段 ${pathKey} 可能包含脚本代码`,
          path: pathKey
        });
      }
    }
    
    return issues;
  }

  /**
   * 存储模式快照
   */
  _storeSchemaSnapshot(modelName, schema) {
    try {
      // 创建模式快照
      const snapshot = this._createSchemaSnapshot(schema);
      
      // 存储快照
      this.schemaSnapshots.set(modelName, snapshot);
      
      // 添加到历史记录
      this._addToSchemaHistory(modelName, snapshot);
      
      return snapshot;
    } catch (error) {
      this.logger.error('存储模式快照失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 创建模式快照
   */
  _createSchemaSnapshot(schema) {
    // 序列化模式结构
    const paths = {};
    
    for (const pathKey in schema.paths) {
      const path = schema.paths[pathKey];
      
      paths[pathKey] = {
        instance: path.instance,
        path: path.path,
        isRequired: !!(path.isRequired && path.isRequired()),
        defaultValue: path.defaultValue,
        validators: path.validators ? path.validators.length : 0,
        options: path.options || {}
      };
      
      // 处理嵌套模式
      if (path.schema) {
        paths[pathKey].schema = this._createSchemaSnapshot(path.schema);
      }
    }
    
    // 为模式创建校验和
    const schemaString = JSON.stringify(paths);
    const checksum = crypto
      .createHash('sha256')
      .update(schemaString)
      .digest('hex');
    
    return {
      timestamp: new Date(),
      paths,
      checksum,
      options: schema.options || {}
    };
  }

  /**
   * 添加到模式历史
   */
  async _addToSchemaHistory(modelName, snapshot) {
    try {
      // 先检查内存中的历史记录
      if (!this.schemaHistory.has(modelName)) {
        this.schemaHistory.set(modelName, []);
      }
      
      const historyArray = this.schemaHistory.get(modelName);
      
      // 如果有现有记录，检查最新的校验和是否相同
      if (historyArray.length > 0 && historyArray[0].checksum === snapshot.checksum) {
        // 跳过相同的更改
        return false;
      }
      
      // 创建历史记录
      const historyRecord = {
        modelName,
        timestamp: new Date(),
        checksum: snapshot.checksum,
        pathCount: Object.keys(snapshot.paths).length,
        snapshot
      };
      
      // 添加到内存中的历史记录
      historyArray.unshift(historyRecord);
      
      // 保存到数据库
      await mongoose.connection.db.collection('schema_history').insertOne(historyRecord);
      
      this.logger.debug('添加模式快照到历史记录', { modelName });
      
      return true;
    } catch (error) {
      this.logger.error('添加模式快照到历史记录失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 冻结模式
   */
  async freezeSchema(modelName, schema) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      this.logger.info('冻结模式', { modelName });
      
      if (!schema) {
        const model = mongoose.model(modelName);
        schema = model.schema;
      }
      
      // 创建模式快照
      const snapshot = this._createSchemaSnapshot(schema);
      
      // 存储冻结的模式
      this.frozenSchemas.set(modelName, snapshot);
      
      // 记录冻结操作
      await this._recordSchemaAction(modelName, 'freeze');
      
      this.emit('schemaFrozen', { modelName });
      
      return true;
    } catch (error) {
      this.logger.error('冻结模式失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 解冻模式
   */
  async unfreezeSchema(modelName) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      this.logger.info('解冻模式', { modelName });
      
      // 检查模式是否已冻结
      if (!this.frozenSchemas.has(modelName)) {
        this.logger.warn('模式未冻结', { modelName });
        return false;
      }
      
      // 移除冻结的模式
      this.frozenSchemas.delete(modelName);
      
      // 记录解冻操作
      await this._recordSchemaAction(modelName, 'unfreeze');
      
      this.emit('schemaUnfrozen', { modelName });
      
      return true;
    } catch (error) {
      this.logger.error('解冻模式失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 记录模式操作
   */
  async _recordSchemaAction(modelName, action) {
    try {
      const actionRecord = {
        modelName,
        action,
        timestamp: new Date(),
        user: 'system' // 可以通过参数传入当前用户
      };
      
      // 保存到数据库
      await mongoose.connection.db.collection('schema_actions').insertOne(actionRecord);
      
      return true;
    } catch (error) {
      this.logger.error('记录模式操作失败', { modelName, action, error });
      // 不抛出异常，只记录错误
      return false;
    }
  }

  /**
   * 检测模式变更
   */
  detectSchemaChanges(modelName, oldSchema, newSchema) {
    try {
      this.logger.debug('检测模式变更', { modelName });
      
      // 如果传入的是快照对象，直接使用
      const oldSnapshot = oldSchema.checksum ? oldSchema : this._createSchemaSnapshot(oldSchema);
      const newSnapshot = newSchema.checksum ? newSchema : this._createSchemaSnapshot(newSchema);
      
      // 比较校验和
      if (oldSnapshot.checksum === newSnapshot.checksum) {
        return false;
      }
      
      // 有变更，返回变更详情
      return this.getSchemaChanges(modelName, oldSchema, newSchema);
    } catch (error) {
      this.logger.error('检测模式变更失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 获取模式变更
   */
  getSchemaChanges(modelName, oldSchema, newSchema) {
    try {
      // 如果传入的是快照对象，直接使用其paths属性
      const oldPaths = oldSchema.paths || oldSchema;
      const newPaths = newSchema.paths || newSchema;
      
      const changes = {
        added: [],
        removed: [],
        modified: []
      };
      
      // 检查已删除或修改的字段
      for (const pathKey in oldPaths) {
        if (!newPaths[pathKey]) {
          changes.removed.push(pathKey);
        } else if (JSON.stringify(oldPaths[pathKey]) !== JSON.stringify(newPaths[pathKey])) {
          changes.modified.push({
            path: pathKey,
            oldType: oldPaths[pathKey].instance,
            newType: newPaths[pathKey].instance,
            oldRequired: oldPaths[pathKey].isRequired,
            newRequired: newPaths[pathKey].isRequired
          });
        }
      }
      
      // 检查新增字段
      for (const pathKey in newPaths) {
        if (!oldPaths[pathKey]) {
          changes.added.push({
            path: pathKey,
            type: newPaths[pathKey].instance,
            required: newPaths[pathKey].isRequired
          });
        }
      }
      
      // 检查索引变更
      const oldOptions = oldSchema.options || {};
      const newOptions = newSchema.options || {};
      
      if (JSON.stringify(oldOptions.indexes) !== JSON.stringify(newOptions.indexes)) {
        changes.indexChanges = {
          old: oldOptions.indexes || [],
          new: newOptions.indexes || []
        };
      }
      
      return changes;
    } catch (error) {
      this.logger.error('获取模式变更失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 获取模式历史
   */
  async getSchemaHistory(modelName) {
    try {
      if (!this.initialized) {
        throw new Error('服务未初始化，请先调用initialize()');
      }
      
      this.logger.debug('获取模式历史', { modelName });
      
      // 从数据库获取最新的历史记录
      const historyRecords = await mongoose.connection.db
        .collection('schema_history')
        .find({ modelName })
        .sort({ timestamp: -1 })
        .toArray();
      
      return historyRecords;
    } catch (error) {
      this.logger.error('获取模式历史失败', { modelName, error });
      throw error;
    }
  }

  /**
   * 获取服务状态
   */
  getStatus() {
    const frozenModels = [...this.frozenSchemas.keys()];
    const snapshots = [...this.schemaSnapshots.keys()];
    
    return {
      service: 'SchemaGuardService',
      initialized: this.initialized,
      frozenModels,
      snapshotCount: snapshots.length,
      historyModels: [...this.schemaHistory.keys()],
      config: this.config
    };
  }
}

module.exports = SchemaGuardService; 