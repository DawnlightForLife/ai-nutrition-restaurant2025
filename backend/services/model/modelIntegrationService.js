/**
 * 模型集成服务（ModelIntegrationService）
 * 用于统一管理 Mongoose 模型的注册、验证、冻结与迁移
 * 集成 SchemaGuardService 与 MigrationManagerService 以支持自动化模型变更处理
 * 提供模型变更检测、迁移生成与应用、历史记录查询等能力
 * 使用事件机制广播模型变更，支持热更新和运行时控制
 * @module services/core/modelIntegrationService
 */
/**
 * 模型集成服务 - 为模型变更管理提供统一界面
 * 集成了SchemaGuardService和MigrationManagerService的功能
 */
const mongoose = require('mongoose');
const { EventEmitter } = require('events');
const SchemaGuardService = require('./schemaGuardService');
const MigrationManagerService = require('./migrationManagerService');
const logger = require('../../utils/logger/winstonLogger.js');

class ModelIntegrationService extends EventEmitter {
  constructor(options = {}) {
    super();
    this.initialized = false;
    this.config = {
      autoMigrate: options.autoMigrate || false,
      trackHistory: options.trackHistory !== false,
      validateOnInit: options.validateOnInit !== false,
      autoFreeze: options.autoFreeze || false,
      migrationPath: options.migrationPath || './migrations',
      enableRollback: options.enableRollback !== false,
      securityChecks: options.securityChecks !== false,
      ...options
    };
    
    this.registeredModels = new Map();
    this.schemaGuardService = null;
    this.migrationManagerService = null;
    this.logger = logger.child({ service: 'ModelIntegrationService' });
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
      
      this.logger.info('初始化ModelIntegrationService', { config: this.config });
      
      // 初始化SchemaGuardService
      this.schemaGuardService = new SchemaGuardService({
        autoFreeze: this.config.autoFreeze,
        validateOnInit: this.config.validateOnInit,
        securityChecks: this.config.securityChecks
      });
      await this.schemaGuardService.initialize();
      
      // 初始化MigrationManagerService
      this.migrationManagerService = new MigrationManagerService({
        migrationPath: this.config.migrationPath,
        enableRollback: this.config.enableRollback,
        trackHistory: this.config.trackHistory
      });
      await this.migrationManagerService.initialize();
      
      // 设置Mongoose钩子来拦截模型创建
      this._setupMongooseHooks();
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('ModelIntegrationService初始化完成');
      return true;
    } catch (error) {
      this.logger.error('初始化ModelIntegrationService失败', { error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 设置Mongoose钩子
   */
  _setupMongooseHooks() {
    // 拦截模型创建操作
    const originalCreateModel = mongoose.model;
    mongoose.model = (name, schema, collection, skipInit) => {
      // 捕获模型创建
      const model = originalCreateModel.call(mongoose, name, schema, collection, skipInit);
      // 自动注册模型
      this._automodelRegistrar(name, model, schema);
      return model;
    };
    
    this.logger.debug('设置Mongoose钩子完成');
  }

  /**
   * 自动注册模型
   */
  _automodelRegistrar(modelName, modelInstance, schema) {
    if (!this.initialized) {
      this.logger.warn('服务未初始化，无法自动注册模型', { modelName });
      return;
    }
    
    this.logger.debug('自动注册模型', { modelName });
    
    const existingModel = this.registeredModels.get(modelName);
    if (existingModel) {
      // 检测模式变更
      const hasChanges = this.schemaGuardService.detectSchemaChanges(
        modelName, 
        existingModel.schema, 
        schema
      );
      
      if (hasChanges && this.config.autoMigrate) {
        this.logger.info('检测到模式变更，自动创建迁移', { modelName });
        this._createMigrationForChanges(modelName, existingModel.schema, schema);
      }
    }
    
    // 更新注册的模型
    this.registeredModels.set(modelName, {
      name: modelName,
      instance: modelInstance,
      schema: schema,
      registeredAt: new Date()
    });
    
    this.emit('modelRegistered', { modelName, automatic: true });
  }

  /**
   * 注册模型
   */
  async modelRegistrar(modelName, validate = true) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      const modelInstance = mongoose.model(modelName);
      
      if (!modelInstance) {
        throw new Error(`未找到模型: ${modelName}`);
      }
      
      this.logger.info('注册模型', { modelName, validate });
      
      // 验证模型结构
      if (validate) {
        await this.schemaGuardService.validateModelStructure(modelName, modelInstance.schema);
      }
      
      const existingModel = this.registeredModels.get(modelName);
      
      // 如果已注册并启用了自动迁移，检查变更
      if (existingModel && this.config.autoMigrate) {
        const hasChanges = this.schemaGuardService.detectSchemaChanges(
          modelName, 
          existingModel.schema, 
          modelInstance.schema
        );
        
        if (hasChanges) {
          this.logger.info('检测到模式变更，创建迁移', { modelName });
          await this._createMigrationForChanges(modelName, existingModel.schema, modelInstance.schema);
        }
      }
      
      // 更新注册表
      this.registeredModels.set(modelName, {
        name: modelName,
        instance: modelInstance,
        schema: modelInstance.schema,
        registeredAt: new Date()
      });
      
      this.emit('modelRegistered', { modelName, automatic: false });
      
      return true;
    } catch (error) {
      this.logger.error('注册模型失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 为模式变更创建迁移
   */
  async _createMigrationForChanges(modelName, oldSchema, newSchema) {
    try {
      // 获取变更摘要
      const changes = this.schemaGuardService.getSchemaChanges(modelName, oldSchema, newSchema);
      
      // 创建迁移脚本
      const migrationName = `${modelName}_${Date.now()}`;
      const migrationScript = await this.migrationManagerService.createMigration(
        migrationName,
        modelName,
        changes
      );
      
      this.logger.info('为模式变更创建迁移脚本', { 
        modelName, 
        migrationName,
        changes: JSON.stringify(changes)
      });
      
      // 如果配置了自动迁移，则应用迁移
      if (this.config.autoMigrate) {
        await this.migrationManagerService.applyMigration(migrationName);
      }
      
      this.emit('migrationCreated', { modelName, migrationName, changes });
      
      return migrationScript;
    } catch (error) {
      this.logger.error('创建迁移失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 冻结模型
   */
  async freezeModel(modelName) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      this.logger.info('冻结模型', { modelName });
      
      const result = await this.schemaGuardService.freezeSchema(modelName);
      this.emit('modelFrozen', { modelName });
      
      return result;
    } catch (error) {
      this.logger.error('冻结模型失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 解冻模型
   */
  async unfreezeModel(modelName) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      this.logger.info('解冻模型', { modelName });
      
      const result = await this.schemaGuardService.unfreezeSchema(modelName);
      this.emit('modelUnfrozen', { modelName });
      
      return result;
    } catch (error) {
      this.logger.error('解冻模型失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 验证模型结构
   */
  async validateModel(modelName) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      this.logger.info('验证模型结构', { modelName });
      
      const model = mongoose.model(modelName);
      const result = await this.schemaGuardService.validateModelStructure(modelName, model.schema);
      
      this.emit('modelValidated', { modelName, valid: result.valid });
      
      return result;
    } catch (error) {
      this.logger.error('验证模型结构失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 创建迁移脚本
   */
  async createMigration(migrationName, modelName, changes) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      this.logger.info('创建迁移脚本', { migrationName, modelName });
      
      const result = await this.migrationManagerService.createMigration(
        migrationName, 
        modelName, 
        changes
      );
      
      this.emit('migrationCreated', { migrationName, modelName, changes });
      
      return result;
    } catch (error) {
      this.logger.error('创建迁移脚本失败', { migrationName, modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 应用迁移
   */
  async applyMigration(migrationName, options = {}) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    try {
      this.logger.info('应用迁移', { migrationName, options });
      
      const result = await this.migrationManagerService.applyMigration(migrationName, options);
      
      this.emit('migrationApplied', { migrationName, result });
      
      return result;
    } catch (error) {
      this.logger.error('应用迁移失败', { migrationName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 回滚迁移
   */
  async rollbackMigration(migrationName) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    if (!this.config.enableRollback) {
      throw new Error('迁移回滚功能未启用');
    }
    
    try {
      this.logger.info('回滚迁移', { migrationName });
      
      const result = await this.migrationManagerService.rollbackMigration(migrationName);
      
      this.emit('migrationRolledBack', { migrationName, result });
      
      return result;
    } catch (error) {
      this.logger.error('回滚迁移失败', { migrationName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 获取模型变更历史
   */
  async getModelChangeHistory(modelName) {
    if (!this.initialized) {
      throw new Error('服务未初始化，请先调用initialize()');
    }
    
    if (!this.config.trackHistory) {
      throw new Error('模型历史跟踪功能未启用');
    }
    
    try {
      this.logger.info('获取模型变更历史', { modelName });
      
      const migrations = await this.migrationManagerService.getMigrationsByModel(modelName);
      const schemaHistory = await this.schemaGuardService.getSchemaHistory(modelName);
      
      return {
        modelName,
        migrations,
        schemaHistory
      };
    } catch (error) {
      this.logger.error('获取模型变更历史失败', { modelName, error });
      this.emit('error', error);
      throw error;
    }
  }

  /**
   * 获取服务状态
   */
  getStatus() {
    const status = {
      service: 'ModelIntegrationService',
      initialized: this.initialized,
      registeredModels: [...this.registeredModels.keys()],
      schemaGuardStatus: this.schemaGuardService ? this.schemaGuardService.getStatus() : null,
      migrationManagerStatus: this.migrationManagerService ? this.migrationManagerService.getStatus() : null,
      config: this.config
    };
    
    return status;
  }
}

// 创建单例
const modelIntegrationService = new ModelIntegrationService();

module.exports = modelIntegrationService; 