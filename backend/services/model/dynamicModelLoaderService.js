/**
 * 动态模型加载服务模块
 * 支持 Mongoose 模型的热更新与动态重载
 * 提供模型沙箱隔离、灰度发布、热替换、文件监控重载等能力
 * 集成事件驱动架构，便于模块间监听模型更新
 * 用于支持运行时更新模型定义而无需重启应用
 * @module services/core/dynamicModelLoaderService
 */

/**
 * 动态模型加载服务 - 支持模型热更新
 * @module services/core/dynamicModelLoaderService
 */

const EventEmitter = require('events');
const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose');
const logger = require('../../utils/logger/winstonLogger.js');
const { SchemaJsonConverter } = require('./schemaJsonConverter');

/**
 * 动态模型加载服务类
 * 提供在不重启服务的情况下动态加载/替换模型定义
 */
class DynamicModelLoaderService extends EventEmitter {
  /**
   * 构造函数
   * @param {Object} options - 配置选项
   * @param {Boolean} options.enableSandbox - 是否启用模型沙箱隔离
   * @param {Boolean} options.enableGrayRelease - 是否启用灰度发布
   * @param {Number} options.grayReleasePercentage - 灰度比例(0-100)
   * @param {String} options.modelsDir - 模型定义文件目录
   * @param {Array} options.nodeGroups - 节点分组配置
   */
  constructor(options = {}) {
    super();
    
    this.options = {
      enableSandbox: true,
      enableGrayRelease: false,
      grayReleasePercentage: 10,
      modelsDir: path.join(process.cwd(), 'models'),
      nodeGroups: ['default'],
      watchInterval: 5000,
      ...options
    };
    
    this.logger = logger.child({ service: 'DynamicModelLoader' });
    this.modelRegistry = new Map(); // 注册表: 模型名 -> 模型配置信息
    this.proxiedModels = new Map(); // 代理模型: 模型名 -> 代理对象
    this.versionMap = new Map();    // 版本映射: 模型名 -> 版本号
    this.nodeId = process.env.NODE_ID || `node-${Math.floor(Math.random() * 10000)}`;
    this.nodeGroup = process.env.NODE_GROUP || 'default';
    this.converter = new SchemaJsonConverter();
    
    this.initialized = false;
    this.fsWatcher = null;
    
    this.logger.info('动态模型加载服务已创建', {
      enableSandbox: this.options.enableSandbox,
      enableGrayRelease: this.options.enableGrayRelease,
      grayReleasePercentage: this.options.grayReleasePercentage,
      nodeId: this.nodeId, 
      nodeGroup: this.nodeGroup
    });
  }
  
  /**
   * 初始化服务
   */
  async initialize() {
    if (this.initialized) {
      this.logger.warn('动态模型加载服务已经初始化过');
      return;
    }
    
    this.logger.info('正在初始化动态模型加载服务...');
    
    try {
      // 加载所有现有模型
      await this._loadInitialModels();
      
      // 设置文件监视器
      if (this.options.enableSandbox) {
        this._setupFileWatcher();
      }
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('动态模型加载服务初始化完成');
    } catch (error) {
      this.logger.error('初始化动态模型加载服务失败', { error });
      throw error;
    }
  }
  
  /**
   * 关闭服务
   */
  async shutdown() {
    if (!this.initialized) {
      return;
    }
    
    if (this.fsWatcher) {
      this.fsWatcher.close();
      this.fsWatcher = null;
    }
    
    // 清理资源
    this.modelRegistry.clear();
    this.proxiedModels.clear();
    this.versionMap.clear();
    
    this.initialized = false;
    this.emit('shutdown');
    this.logger.info('动态模型加载服务已关闭');
  }
  
  /**
   * 热更新指定模型
   * @param {String} modelName - 模型名称
   * @param {Object} modelDefinition - 新的模型定义
   * @param {Object} options - 更新选项
   * @param {Boolean} options.force - 是否强制更新所有节点
   * @param {Array} options.targetGroups - 目标节点组
   * @param {Number} options.percentage - 灰度比例
   * @returns {Object} 更新结果
   */
  async updateModel(modelName, modelDefinition, options = {}) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    const updateOptions = {
      force: false,
      targetGroups: ['default'],
      percentage: this.options.grayReleasePercentage,
      ...options
    };
    
    // 检查是否应该更新此节点的模型
    if (!this._shouldUpdateNode(updateOptions)) {
      this.logger.info(`节点 ${this.nodeId} 跳过更新模型 ${modelName}（灰度发布）`);
      return {
        updated: false,
        modelName,
        reason: 'GRAY_RELEASE_SKIPPED'
      };
    }
    
    try {
      // 验证模型定义
      if (!modelDefinition || !modelDefinition.schema) {
        throw new Error('无效的模型定义');
      }
      
      // 保存旧版本引用
      const oldModel = mongoose.models[modelName];
      const oldVersion = this.versionMap.get(modelName) || 1;
      const newVersion = oldVersion + 1;
      
      // 创建新的模型Schema
      const schema = new mongoose.Schema(
        modelDefinition.schema,
        modelDefinition.options || {}
      );
      
      // 添加静态方法
      if (modelDefinition.statics) {
        Object.keys(modelDefinition.statics).forEach(methodName => {
          schema.statics[methodName] = modelDefinition.statics[methodName];
        });
      }
      
      // 添加实例方法
      if (modelDefinition.methods) {
        Object.keys(modelDefinition.methods).forEach(methodName => {
          schema.methods[methodName] = modelDefinition.methods[methodName];
        });
      }
      
      // 添加虚拟字段
      if (modelDefinition.virtuals) {
        Object.keys(modelDefinition.virtuals).forEach(virtualName => {
          const virtual = modelDefinition.virtuals[virtualName];
          if (virtual.get) schema.virtual(virtualName).get(virtual.get);
          if (virtual.set) schema.virtual(virtualName).set(virtual.set);
        });
      }
      
      // 添加索引
      if (modelDefinition.indexes) {
        modelDefinition.indexes.forEach(index => {
          schema.index(index.fields, index.options || {});
        });
      }
      
      // 添加中间件
      if (modelDefinition.middleware) {
        Object.keys(modelDefinition.middleware).forEach(hook => {
          const handlers = modelDefinition.middleware[hook];
          if (Array.isArray(handlers)) {
            handlers.forEach(handler => {
              schema[hook](handler);
            });
          }
        });
      }
      
      // 移除旧的模型定义
      if (oldModel) {
        delete mongoose.models[modelName];
        delete mongoose.modelSchemas[modelName];
      }
      
      // 创建新的模型
      const newModel = mongoose.model(modelName, schema);
      
      // 更新注册表
      this.modelRegistry.set(modelName, {
        definition: modelDefinition,
        createdAt: new Date(),
        version: newVersion
      });
      
      this.versionMap.set(modelName, newVersion);
      
      // 如果启用沙箱，则创建代理
      if (this.options.enableSandbox) {
        this._createModelProxy(modelName, newModel);
      }
      
      // 记录模型更新
      this.logger.info(`成功热更新模型 ${modelName} v${oldVersion} -> v${newVersion}`, {
        modelName,
        oldVersion,
        newVersion,
        nodeId: this.nodeId
      });
      
      // 发出事件
      this.emit('modelUpdated', {
        modelName,
        oldVersion,
        newVersion,
        model: newModel
      });
      
      return {
        updated: true,
        modelName,
        oldVersion,
        newVersion
      };
    } catch (error) {
      this.logger.error(`更新模型 ${modelName} 失败`, { error });
      
      // 发出错误事件
      this.emit('updateError', {
        modelName,
        error
      });
      
      throw new Error(`更新模型 ${modelName} 失败: ${error.message}`);
    }
  }
  
  /**
   * 获取模型当前版本
   * @param {String} modelName - 模型名称
   * @returns {Number} 模型版本
   */
  getModelVersion(modelName) {
    return this.versionMap.get(modelName) || 1;
  }
  
  /**
   * 获取所有已注册模型的信息
   * @returns {Array} 模型信息列表
   */
  getRegisteredModels() {
    const result = [];
    
    this.modelRegistry.forEach((config, modelName) => {
      result.push({
        name: modelName,
        version: config.version,
        createdAt: config.createdAt
      });
    });
    
    return result;
  }
  
  /**
   * 从文件动态加载模型
   * @param {String} modelFilePath - 模型文件路径
   * @param {Object} options - 加载选项
   * @returns {Object} 加载结果
   */
  async loadModelFromFile(modelFilePath, options = {}) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      // 清除Node.js的模块缓存，确保重新加载最新定义
      delete require.cache[require.resolve(modelFilePath)];
      
      // 动态导入模型定义
      const modelDef = require(modelFilePath);
      const modelName = modelDef.modelName || path.basename(modelFilePath, '.js');
      
      // 更新模型
      return await this.updateModel(modelName, modelDef, options);
    } catch (error) {
      this.logger.error(`从文件加载模型失败: ${modelFilePath}`, { error });
      throw new Error(`从文件加载模型失败: ${error.message}`);
    }
  }
  
  /**
   * 初始化沙箱
   * @param {String} modelName - 模型名称
   * @returns {Object} 沙箱对象
   */
  _createSandbox(modelName) {
    // 创建沙箱环境
    const sandbox = {
      mongoose,
      Schema: mongoose.Schema,
      modelName,
      exports: {}
    };
    
    // 添加沙箱全局对象
    sandbox.global = sandbox;
    
    return sandbox;
  }
  
  /**
   * 创建模型代理
   * @private
   * @param {String} modelName - 模型名称
   * @param {Object} model - Mongoose模型
   */
  _createModelProxy(modelName, model) {
    // 创建一个代理对象，拦截对模型的所有操作
    const proxy = new Proxy(model, {
      get: (target, prop, receiver) => {
        // 记录访问信息
        if (typeof prop === 'string' && !['then', 'catch', 'finally'].includes(prop)) {
          this.logger.debug(`访问模型 ${modelName} 的属性: ${String(prop)}`, {
            modelName,
            property: String(prop),
            version: this.versionMap.get(modelName) || 1
          });
        }
        
        // 获取目标属性
        const value = Reflect.get(target, prop, receiver);
        
        // 如果是函数，创建函数代理
        if (typeof value === 'function' && !['constructor', 'toString', 'valueOf'].includes(prop)) {
          return (...args) => {
            this.logger.debug(`调用模型 ${modelName} 的方法: ${String(prop)}`, {
              modelName,
              method: String(prop),
              version: this.versionMap.get(modelName) || 1
            });
            
            return value.apply(target, args);
          };
        }
        
        return value;
      }
    });
    
    this.proxiedModels.set(modelName, proxy);
    return proxy;
  }
  
  /**
   * 加载初始模型
   * @private
   */
  async _loadInitialModels() {
    // 获取所有已注册的Mongoose模型
    const modelNames = mongoose.modelNames();
    
    for (const modelName of modelNames) {
      const model = mongoose.model(modelName);
      
      // 将现有模型添加到注册表
      this.modelRegistry.set(modelName, {
        definition: {
          schema: model.schema.obj,
          options: model.schema.options
        },
        createdAt: new Date(),
        version: 1
      });
      
      this.versionMap.set(modelName, 1);
      
      // 如果启用沙箱，则创建代理
      if (this.options.enableSandbox) {
        this._createModelProxy(modelName, model);
      }
      
      this.logger.debug(`初始化已存在的模型: ${modelName} v1`);
    }
    
    this.logger.info(`已初始化 ${modelNames.length} 个现有模型`);
  }
  
  /**
   * 设置文件监视器
   * @private
   */
  _setupFileWatcher() {
    const modelsDir = this.options.modelsDir;
    
    // 确保目录存在
    if (!fs.existsSync(modelsDir)) {
      this.logger.warn(`模型目录不存在: ${modelsDir}，跳过文件监视`);
      return;
    }
    
    // 定期检查文件变化
    this.watchInterval = setInterval(() => {
      this._checkModelFilesChanges();
    }, this.options.watchInterval);
    
    this.logger.info(`已设置模型文件监视器，监视目录: ${modelsDir}`);
  }
  
  /**
   * 检查模型文件变化
   * @private
   */
  async _checkModelFilesChanges() {
    try {
      const modelsDir = this.options.modelsDir;
      const modelFiles = fs.readdirSync(modelsDir)
        .filter(file => file.endsWith('.js') && !file.startsWith('index'));
      
      for (const file of modelFiles) {
        const filePath = path.join(modelsDir, file);
        const stats = fs.statSync(filePath);
        const modelName = path.basename(file, '.js');
        
        // 获取已注册的模型信息
        const registeredModel = this.modelRegistry.get(modelName);
        
        // 如果文件更新时间晚于模型注册时间，则重新加载
        if (registeredModel && stats.mtime > registeredModel.createdAt) {
          this.logger.info(`检测到模型文件变化: ${file}`);
          
          try {
            await this.loadModelFromFile(filePath);
          } catch (error) {
            this.logger.error(`自动重新加载模型失败: ${file}`, { error });
          }
        }
      }
    } catch (error) {
      this.logger.error('检查模型文件变化时出错', { error });
    }
  }
  
  /**
   * 判断当前节点是否应该应用更新
   * @private
   * @param {Object} options - 更新选项
   * @returns {Boolean} 是否应该更新
   */
  _shouldUpdateNode(options) {
    // 如果强制更新，直接返回true
    if (options.force) {
      return true;
    }
    
    // 如果未启用灰度发布，直接返回true
    if (!this.options.enableGrayRelease) {
      return true;
    }
    
    // 检查节点组是否在目标组中
    if (options.targetGroups && !options.targetGroups.includes(this.nodeGroup)) {
      return false;
    }
    
    // 基于节点ID和百分比决定是否应该更新
    const nodeId = this.nodeId;
    const hash = this._hashString(nodeId);
    const normalizedHash = hash % 100;  // 归一化到0-99
    
    return normalizedHash < options.percentage;
  }
  
  /**
   * 简单的字符串哈希函数
   * @private
   * @param {String} str - 输入字符串
   * @returns {Number} 哈希值
   */
  _hashString(str) {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash = hash & hash; // 转换为32bit整数
    }
    return Math.abs(hash);
  }
}

module.exports = DynamicModelLoaderService; 