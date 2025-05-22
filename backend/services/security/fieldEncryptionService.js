/**
 * 字段级加密服务 - 实现MongoDB客户端侧字段级加密(FLE)
 * @module services/security/fieldEncryptionService
 */

const mongoose = require('mongoose');
const crypto = require('crypto');
const { ClientEncryption } = require('mongodb-client-encryption');
const { MongoClient, Binary } = require('mongodb');
const fs = require('fs');
const path = require('path');
const EventEmitter = require('events');
const logger = require('../../utils/logger/winstonLogger.js');
const createEncryptionPlugin = require('../../utils/encryption/mongooseEncryptionPlugin');

/**
 * 字段级加密服务类
 * 提供对MongoDB集合字段的客户端侧透明加密功能
 */
class FieldEncryptionService extends EventEmitter {
  /**
   * 构造函数
   * @param {Object} options - 配置选项
   * @param {String} options.kmsProvider - KMS提供商('aws'|'local'|'azure'|'gcp')
   * @param {Object} options.kmsConfig - KMS配置信息
   * @param {String} options.keyVaultNamespace - 密钥保管库命名空间
   * @param {String} options.keyVaultDbName - 密钥保管库数据库名称
   * @param {String} options.keyVaultCollName - 密钥保管库集合名称
   * @param {Object} options.encryptedFieldsMap - 加密字段映射
   * @param {String} options.masterKeyPath - 本地主密钥路径(仅local KMS时使用)
   */
  constructor(options = {}) {
    super();
    
    this.options = {
      kmsProvider: options.kmsProvider || 'local',
      keyVaultNamespace: options.keyVaultNamespace || 'encryption.__keyVault',
      keyVaultDbName: options.keyVaultDbName || 'encryption',
      keyVaultCollName: options.keyVaultCollName || '__keyVault',
      masterKeyPath: path.resolve(options.masterKeyPath || './master-key.txt'),
      encryptedFieldsMap: options.encryptedFieldsMap || {},
      ...options
    };
    
    // 解析命名空间
    const [dbName, collName] = this.options.keyVaultNamespace.split('.');
    this.options.keyVaultDbName = this.options.keyVaultDbName || dbName;
    this.options.keyVaultCollName = this.options.keyVaultCollName || collName;
    
    this.logger = logger.child({ service: 'FieldEncryption' });
    this.initialized = false;
    this.clientEncryption = null;
    this.keyMap = new Map(); // 数据加密密钥映射
    this.kmsProviders = null;
    this.encryptedFieldsMap = options.encryptedFieldsMap || {};
    
    this.logger.info('字段级加密服务已创建', {
      kmsProvider: this.options.kmsProvider,
      keyVaultNamespace: this.options.keyVaultNamespace
    });
  }
  
  /**
   * 初始化服务
   */
  async initialize() {
    if (this.initialized) {
      this.logger.warn('字段级加密服务已经初始化过');
      return;
    }
    
    this.logger.info('正在初始化字段级加密服务...');
    
    try {
      // 设置KMS提供商
      await this._setupKmsProviders();
      
      // 创建ClientEncryption实例
      await this._setupClientEncryption();
      
      // 创建或获取数据加密密钥
      await this._setupDataKeys();
      
      this.initialized = true;
      this.emit('initialized');
      this.logger.info('字段级加密服务初始化完成');
    } catch (error) {
      this.logger.error('初始化字段级加密服务失败:', error);
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
    
    if (this.clientEncryption) {
      await this.clientEncryption.close();
    }
    
    this.keyMap.clear();
    this.initialized = false;
    this.emit('shutdown');
    this.logger.info('字段级加密服务已关闭');
  }
  
  /**
   * 获取加密客户端选项
   * 用于创建支持自动加密/解密的MongoDB客户端
   * @returns {Object} MongoDB客户端加密选项
   */
  getClientEncryptionOptions() {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    return {
      keyVaultNamespace: this.options.keyVaultNamespace,
      kmsProviders: this.kmsProviders,
      schemaMap: this._generateSchemaMap()
    };
  }
  
  /**
   * 创建透明加密模型插件
   * 为Mongoose模型添加自动加密/解密功能
   * @returns {(modelName: string) => (schema: mongoose.Schema) => void}
   */
  createEncryptionPlugin() {
    this._checkInitialized();
    
    // 获取所有模型的加密配置
    const encryptedFieldsMap = this.options.encryptedFieldsMap || {};
    
    // 为每个模型创建一个插件生成器
    return (modelName) => {
      // 获取当前模型的加密配置
      const modelConfig = encryptedFieldsMap[modelName] || {};
      
      // 如果没有配置，返回空插件
      if (Object.keys(modelConfig).length === 0) {
        this.logger.warn(`模型 ${modelName} 没有字段加密配置`);
        return (schema) => {}; // 返回空插件
      }
      
      // 创建并返回插件
      return createEncryptionPlugin(this, modelConfig);
    };
  }
  
  /**
   * 为指定模型添加字段加密配置
   * @param {String} modelName - 模型名称
   * @param {Object} fieldConfig - 字段加密配置
   */
  registerEncryptedModel(modelName, fieldConfig) {
    const model = mongoose.models[modelName];
    if (!model) {
      throw new Error(`模型 ${modelName} 不存在`);
    }
    
    this.encryptedFieldsMap[modelName] = fieldConfig;
    this.logger.info(`已注册模型 ${modelName} 的字段加密配置`);
    
    // 如果已初始化，更新clientEncryption的schemaMap
    if (this.initialized && this.clientEncryption) {
      this._refreshSchemaMap();
    }
  }
  
  /**
   * 手动加密字段值
   * @param {String} value - 要加密的值
   * @param {String} algorithm - 加密算法
   * @param {String} keyId - 加密密钥ID(可选)
   * @returns {Binary} 加密后的二进制数据
   */
  async encryptField(value, algorithm = 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic', keyId = null) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    // 如果未指定keyId，使用默认密钥
    if (!keyId) {
      keyId = this.keyMap.get('default');
      if (!keyId) {
        throw new Error('未找到默认加密密钥');
      }
    }
    
    try {
      const encrypted = await this.clientEncryption.encrypt(value, {
        algorithm,
        keyId: new Binary(Buffer.from(keyId, 'base64'), 4)
      });
      
      return encrypted;
    } catch (error) {
      this.logger.error('字段加密失败:', error);
      throw new Error(`字段加密失败: ${error.message}`);
    }
  }
  
  /**
   * 手动解密字段值
   * @param {Binary} encryptedValue - 加密的字段值
   * @returns {Any} 解密后的原始值
   */
  async decryptField(encryptedValue) {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      return await this.clientEncryption.decrypt(encryptedValue);
    } catch (error) {
      this.logger.error('字段解密失败:', error);
      throw new Error(`字段解密失败: ${error.message}`);
    }
  }
  
  /**
   * 创建新的加密密钥
   * @param {String} keyAltName - 密钥别名
   * @param {String} keyType - 密钥类型
   * @returns {String} 密钥ID
   */
  async createDataKey(keyAltName, keyType = 'local') {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    try {
      const keyId = await this.clientEncryption.createDataKey(keyType, {
        keyAltNames: [keyAltName]
      });
      
      const keyIdBase64 = keyId.buffer.toString('base64');
      this.keyMap.set(keyAltName, keyIdBase64);
      
      this.logger.info(`创建数据加密密钥成功: ${keyAltName}`);
      return keyIdBase64;
    } catch (error) {
      this.logger.error(`创建数据加密密钥失败: ${keyAltName}`, error);
      throw new Error(`创建数据加密密钥失败: ${error.message}`);
    }
  }
  
  /**
   * 获取当前的字段加密配置
   * @returns {Object} 加密字段配置
   */
  getEncryptedFieldsConfig() {
    return { ...this.encryptedFieldsMap };
  }
  
  /**
   * 设置KMS提供商
   * @private
   */
  async _setupKmsProviders() {
    this.logger.debug(`设置KMS提供商: ${this.options.kmsProvider}`);
    
    switch (this.options.kmsProvider) {
      case 'aws':
        this.kmsProviders = {
          aws: {
            accessKeyId: this.options.kmsConfig?.accessKeyId || process.env.AWS_ACCESS_KEY_ID,
            secretAccessKey: this.options.kmsConfig?.secretAccessKey || process.env.AWS_SECRET_ACCESS_KEY
          }
        };
        break;
        
      case 'azure':
        this.kmsProviders = {
          azure: {
            tenantId: this.options.kmsConfig?.tenantId || process.env.AZURE_TENANT_ID,
            clientId: this.options.kmsConfig?.clientId || process.env.AZURE_CLIENT_ID,
            clientSecret: this.options.kmsConfig?.clientSecret || process.env.AZURE_CLIENT_SECRET
          }
        };
        break;
        
      case 'gcp':
        this.kmsProviders = {
          gcp: {
            email: this.options.kmsConfig?.email || process.env.GCP_EMAIL,
            privateKey: this.options.kmsConfig?.privateKey || process.env.GCP_PRIVATE_KEY
          }
        };
        break;
        
      case 'local':
      default:
        // 本地KMS - 生成本地主密钥
        let localMasterKeyBuffer;
        
        try {
          if (fs.existsSync(this.options.masterKeyPath)) {
            localMasterKeyBuffer = fs.readFileSync(this.options.masterKeyPath);
          } else {
            // 创建新的主密钥
            localMasterKeyBuffer = crypto.randomBytes(96);
            fs.writeFileSync(this.options.masterKeyPath, localMasterKeyBuffer);
            this.logger.info(`已创建新的本地主密钥: ${this.options.masterKeyPath}`);
          }
        } catch (error) {
          this.logger.error('读取或创建本地主密钥失败:', error);
          throw new Error(`读取或创建本地主密钥失败: ${error.message}`);
        }
        
        this.kmsProviders = {
          local: {
            key: localMasterKeyBuffer
          }
        };
        break;
    }
    
    this.logger.info(`已设置 ${this.options.kmsProvider} KMS提供商`);
  }
  
  /**
   * 设置ClientEncryption实例
   * @private
   */
  async _setupClientEncryption() {
    this.logger.debug('创建ClientEncryption实例...');
    
    try {
      // 确保密钥保管库集合存在
      const client = await MongoClient.connect(
        mongoose.connection.client.s.url, 
        { useNewUrlParser: true, useUnifiedTopology: true }
      );
      
      const keyVaultClient = client.db(this.options.keyVaultDbName);
      
      // 检查密钥保管库集合是否存在，不存在则创建
      try {
        const collections = await keyVaultClient.listCollections({ name: this.options.keyVaultCollName }).toArray();
        if (collections.length === 0) {
          await keyVaultClient.createCollection(this.options.keyVaultCollName);
          this.logger.info(`已创建密钥保管库集合: ${this.options.keyVaultNamespace}`);
        }
      } catch (error) {
        this.logger.error('检查或创建密钥保管库集合失败:', error);
        throw error;
      }
      
      // 创建ClientEncryption实例
      this.clientEncryption = new ClientEncryption(client, {
        keyVaultNamespace: this.options.keyVaultNamespace,
        kmsProviders: this.kmsProviders
      });
      
      this.logger.info('ClientEncryption实例创建成功');
    } catch (error) {
      this.logger.error('创建ClientEncryption实例失败:', error);
      throw error;
    }
  }
  
  /**
   * 设置数据加密密钥
   * @private
   */
  async _setupDataKeys() {
    this.logger.debug('设置数据加密密钥...');
    
    try {
      // 连接密钥保管库集合
      const client = mongoose.connection.client;
      const db = client.db(this.options.keyVaultDbName);
      const keyVaultColl = db.collection(this.options.keyVaultCollName);
      
      // 检查是否存在默认密钥
      const defaultKey = await keyVaultColl.findOne({ keyAltNames: 'default' });
      
      if (!defaultKey) {
        // 创建默认数据加密密钥
        const keyId = await this.createDataKey('default', this.options.kmsProvider);
        this.logger.info(`已创建默认数据加密密钥: ${keyId}`);
      } else {
        // 加载现有默认密钥
        const keyIdBase64 = defaultKey._id.buffer.toString('base64');
        this.keyMap.set('default', keyIdBase64);
        this.logger.info(`已加载默认数据加密密钥: ${keyIdBase64}`);
      }
      
      // 加载其他现有密钥
      const existingKeys = await keyVaultColl.find({ keyAltNames: { $exists: true, $ne: [] } }).toArray();
      
      for (const key of existingKeys) {
        if (key.keyAltNames && key.keyAltNames.length > 0) {
          const keyIdBase64 = key._id.buffer.toString('base64');
          for (const altName of key.keyAltNames) {
            if (altName !== 'default') {
              this.keyMap.set(altName, keyIdBase64);
              this.logger.debug(`已加载数据加密密钥: ${altName} -> ${keyIdBase64}`);
            }
          }
        }
      }
      
      this.logger.info(`已加载 ${this.keyMap.size} 个数据加密密钥`);
    } catch (error) {
      this.logger.error('设置数据加密密钥失败:', error);
      throw error;
    }
  }
  
  /**
   * 生成Schema映射
   * @private
   * @returns {Object} MongoDB加密Schema映射
   */
  _generateSchemaMap() {
    if (!this.initialized) {
      throw new Error('服务尚未初始化');
    }
    
    const schemaMap = {};
    const defaultKeyId = this.keyMap.get('default');
    
    if (!defaultKeyId) {
      throw new Error('默认加密密钥未找到');
    }
    
    // 使用Binary解析密钥ID
    const keyIdBinary = new Binary(Buffer.from(defaultKeyId, 'base64'), 4);
    
    // 为每个注册的模型生成加密Schema
    for (const [modelName, fieldConfig] of Object.entries(this.encryptedFieldsMap)) {
      const model = mongoose.models[modelName];
      if (!model) {
        this.logger.warn(`模型 ${modelName} 不存在，跳过生成加密Schema`);
        continue;
      }
      
      const collectionName = model.collection.name;
      const encryptedFields = {};
      
      // 处理每个需要加密的字段
      for (const [fieldPath, config] of Object.entries(fieldConfig)) {
        // 配置加密选项
        encryptedFields[fieldPath] = {
          keyId: keyIdBinary,
          algorithm: config.algorithm || 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
          bsonType: config.bsonType || 'string'
        };
      }
      
      // 生成该集合的Schema映射
      schemaMap[collectionName] = {
        bsonType: 'object',
        properties: encryptedFields,
        encryptMetadata: {
          keyId: [keyIdBinary]
        }
      };
      
      this.logger.debug(`已生成模型 ${modelName} (${collectionName}) 的加密Schema`);
    }
    
    return schemaMap;
  }
  
  /**
   * 刷新Schema映射
   * @private
   */
  // @pending: dynamic schemaMap refresh support for live model update
  _refreshSchemaMap() {
    // TODO: 实现动态更新clientEncryption的schemaMap
    this.logger.info('刷新Schema映射');
  }
  
  /**
   * 加密模型字段
   * @private
   * @param {Object} doc - Mongoose文档
   */
  async _encryptModelFields(doc) {
    if (!this.initialized || !doc) {
      return;
    }
    
    const modelName = doc.constructor.modelName;
    const fieldConfig = this.encryptedFieldsMap[modelName];
    
    if (!fieldConfig) {
      return;
    }
    
    // 处理每个需要加密的字段
    for (const [fieldPath, config] of Object.entries(fieldConfig)) {
      const value = doc.get(fieldPath);
      
      if (value !== undefined && value !== null) {
        try {
          const encrypted = await this.encryptField(
            value, 
            config.algorithm || 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic'
          );
          
          doc.set(fieldPath, encrypted);
        } catch (error) {
          this.logger.error(`加密字段 ${fieldPath} 失败:`, error);
          throw error;
        }
      }
    }
  }
  
  /**
   * 加密更新操作中的字段
   * @private
   * @param {Object} update - 更新操作对象
   * @param {Object} model - Mongoose模型
   */
  async _encryptUpdateFields(update, model) {
    if (!this.initialized || !update || !model) {
      return;
    }
    
    const modelName = model.modelName;
    const fieldConfig = this.encryptedFieldsMap[modelName];
    
    if (!fieldConfig) {
      return;
    }
    
    // 处理$set操作符中的字段
    if (update.$set) {
      for (const [fieldPath, config] of Object.entries(fieldConfig)) {
        if (update.$set[fieldPath] !== undefined && update.$set[fieldPath] !== null) {
          try {
            update.$set[fieldPath] = await this.encryptField(
              update.$set[fieldPath],
              config.algorithm || 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic'
            );
          } catch (error) {
            this.logger.error(`加密更新字段 ${fieldPath} 失败:`, error);
            throw error;
          }
        }
      }
    }
    
    // 处理直接在更新对象上的字段
    for (const [fieldPath, config] of Object.entries(fieldConfig)) {
      if (update[fieldPath] !== undefined && update[fieldPath] !== null) {
        try {
          update[fieldPath] = await this.encryptField(
            update[fieldPath],
            config.algorithm || 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic'
          );
        } catch (error) {
          this.logger.error(`加密更新字段 ${fieldPath} 失败:`, error);
          throw error;
        }
      }
    }
  }
  
  /**
   * 检查服务是否已初始化
   * @private
   */
  _checkInitialized() {
    if (!this.initialized) {
      throw new Error('字段级加密服务尚未初始化');
    }
  }
}

module.exports = FieldEncryptionService; 