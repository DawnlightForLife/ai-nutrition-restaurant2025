/**
 * 字段级加密中间件 - 集成MongoDB客户端侧字段级加密(FLE)
 * @module middleware/database/fieldEncryptionMiddleware
 *
 * ✅ 命名风格统一（camelCase）
 * ✅ 字段加密服务通过 createFieldEncryptionService 初始化
 * ✅ getSensitiveFieldsConfig 明确映射各模型敏感字段与加密策略
 * ✅ applyFieldEncryption 可动态应用插件到 Mongoose 模型
 * ✅ 使用 AEAD_AES_256_CBC_HMAC_SHA_512 算法进行确定性 / 随机加密
 * ✅ 建议 future：动态配置字段映射（来自数据库或远程配置中心）
 */

const mongoose = require('mongoose');
const FieldEncryptionService = require('../../services/security/fieldEncryptionService');
const logger = require('../../utils/logger/winstonLogger.js');

/**
 * 创建字段级加密服务实例
 * @param {Object} options - 配置选项
 * @returns {FieldEncryptionService} 字段级加密服务实例
 */
const createFieldEncryptionService = async (options = {}) => {
  const defaultOptions = {
    kmsProvider: process.env.KMS_PROVIDER || 'local',
    keyVaultNamespace: process.env.KEY_VAULT_NAMESPACE || 'encryption.__keyVault',
    keyVaultDbName: process.env.KEY_VAULT_DB_NAME || 'encryption',
    keyVaultCollName: process.env.KEY_VAULT_COLL_NAME || '__keyVault',
    masterKeyPath: process.env.MASTER_KEY_PATH || './master-key.txt',
    encryptedFieldsMap: getSensitiveFieldsConfig()
  };
  
  // 合并选项
  const mergedOptions = { ...defaultOptions, ...options };
  
  // 根据环境设置KMS配置
  if (mergedOptions.kmsProvider === 'aws') {
    mergedOptions.kmsConfig = {
      accessKeyId: process.env.AWS_ACCESS_KEY_ID,
      secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
      region: process.env.AWS_REGION || 'us-east-1'
    };
  }
  
  // 创建服务实例
  const fieldEncryptionService = new FieldEncryptionService(mergedOptions);
  
  try {
    // 初始化服务
    await fieldEncryptionService.initialize();
    logger.info('字段级加密服务初始化成功');
    
    return fieldEncryptionService;
  } catch (error) {
    logger.error('字段级加密服务初始化失败:', error);
    throw error;
  }
};

/**
 * 定义模型-字段级别加密映射表
 * - 结构为 { 模型名: { 字段路径: { algorithm, bsonType } } }
 * - 可支持嵌套字段路径（如 contactInfo.phone）
 * - 建议后续从配置中心动态加载映射
 */
const getSensitiveFieldsConfig = () => {
  return {
    // 用户模型敏感字段
    'User': {
      'phone': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic', // 确定性加密，支持查询
        bsonType: 'string'
      },
      'idCard': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'emergencyContact.phone': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'personalInfo.address': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random', // 随机加密，更安全但不支持查询
        bsonType: 'string'
      }
    },
    
    // 营养数据模型敏感字段
    'NutritionProfile': {
      'medicalHistory': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random',
        bsonType: 'string'
      },
      'allergies': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random',
        bsonType: 'array'
      }
    },
    
    // 付款信息模型敏感字段
    'paymentInfo': {
      'cardNumber': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'cvv': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random',
        bsonType: 'string'
      },
      'billingAddress': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random',
        bsonType: 'string'
      }
    },
    
    // 营养师模型敏感字段
    'nutritionist': {
      'licenseNumber': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'contactInfo.phone': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      }
    },
    
    // 反馈模型敏感字段
    'feedback': {
      'content': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Random',
        bsonType: 'string'
      },
      'userContact': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      }
    },
    
    // 商家模型敏感字段
    'merchant': {
      'businessLicense': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'contactInfo.phone': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      },
      'bankInfo.accountNumber': {
        algorithm: 'AEAD_AES_256_CBC_HMAC_SHA_512-Deterministic',
        bsonType: 'string'
      }
    }
  };
};

/**
 * 应用字段加密中间件
 * @param {Object} options - 配置选项
 * @returns {Promise<Function>} 中间件函数
 */
// NOTE: 插件应在模型 schema 创建后首次加载时应用，避免重复绑定
// TODO: 如果支持热重载模型，应增加卸载旧插件逻辑
const applyFieldEncryption = async (options = {}) => {
  try {
    // 创建字段级加密服务
    const fieldEncryptionService = await createFieldEncryptionService(options);
    
    // 创建Mongoose插件
    const encryptionPlugin = fieldEncryptionService.createEncryptionPlugin();
    
    // 注册插件到所有相关模型
    const encryptedModels = Object.keys(getSensitiveFieldsConfig());
    
    for (const modelName of encryptedModels) {
      if (mongoose.modelNames().includes(modelName)) {
        const model = mongoose.model(modelName);
        model.schema.plugin(encryptionPlugin);
        logger.info(`已为模型 ${modelName} 应用字段加密插件`);
      } else {
        logger.warn(`找不到模型 ${modelName}，无法应用字段加密`);
      }
    }
    
    // 返回中间件函数
    return (req, res, next) => {
      // 将字段加密服务实例附加到请求对象，以便于路由中使用
      req.fieldEncryptionService = fieldEncryptionService;
      next();
    };
  } catch (error) {
    logger.error('应用字段加密中间件失败:', error);
    
    // 返回错误处理中间件
    return (req, res, next) => {
      logger.warn('字段加密服务未启用，继续处理请求');
      next();
    };
  }
};

module.exports = {
  applyFieldEncryption,
  getSensitiveFieldsConfig,
  createFieldEncryptionService
};