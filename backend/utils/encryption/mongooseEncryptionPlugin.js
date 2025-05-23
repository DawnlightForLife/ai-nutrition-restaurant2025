/**
 * Mongoose字段加密插件 - 为Mongoose模型提供字段级加密功能
 * 使用方式：schema.plugin(createEncryptionPlugin(encryptionService, config))
 * 插件自动处理字段加密/解密、查询条件/更新语句中加密字段的转换
 * 支持确定性加密（用于查询）与随机加密（仅用于保存）
 * @module utils/encryption/mongooseEncryptionPlugin
 */

const logger = require('../logger/winstonLogger');

/**
 * 创建字段加密Mongoose插件
 * @param {FieldEncryptionService} encryptionService - 字段加密服务实例
 * @param {Object} modelEncryptionConfig - 当前模型的加密配置
 * @returns {Function} Mongoose插件
 */
function createEncryptionPlugin(encryptionService, modelEncryptionConfig) {
  if (!encryptionService) {
    throw new Error('加密服务实例必须提供');
  }
  
  if (!modelEncryptionConfig || Object.keys(modelEncryptionConfig).length === 0) {
    logger.warn('没有提供加密字段配置，插件将不会加密任何字段');
    return schema => {}; // 返回空插件
  }
  
  /**
   * Mongoose字段加密插件
   * @param {Schema} schema - Mongoose模式
   * @param {Object} options - 插件选项
   */
  return function(schema, options = {}) {
    // 为需要加密的字段添加标记以便识别
    const encryptedPaths = new Set(Object.keys(modelEncryptionConfig));
    
    // 保存原始字段类型信息，加密后都变为二进制类型
    const originalTypes = {};
    
    // 遍历所有需要加密的字段
    encryptedPaths.forEach(path => {
      const pathConfig = schema.path(path);
      
      if (!pathConfig) {
        logger.warn(`模式中找不到路径 ${path}，无法应用加密`);
        return;
      }
      
      // 保存原始类型
      originalTypes[path] = pathConfig.instance;
      
      // 标记字段为加密字段
      pathConfig.options.encrypted = true;
      pathConfig.options.encryptionConfig = modelEncryptionConfig[path];
    });
    
    /**
     * 预保存钩子 - 加密文档中的指定字段
     */
    schema.pre('save', async function(next) {
      try {
        // 遍历所有需要加密的字段
        for (const path of encryptedPaths) {
          const value = this.get(path);
          
          // 跳过未定义的值或已经是二进制类型的值（可能已经加密）
          if (value === undefined || value === null || Buffer.isBuffer(value)) {
            continue;
          }
          
          // 获取字段的加密配置
          const config = modelEncryptionConfig[path];
          
          // 加密字段
          const encryptedValue = await encryptionService.encryptField(
            value, 
            config.algorithm, 
            config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
          );
          
          // 设置加密后的值
          this.set(path, encryptedValue);
        }
        
        next();
      } catch (error) {
        logger.error('save 操作加密字段失败:', error);
        next(error);
      }
    });
    
    /**
     * 文档初始化钩子 - 解密从数据库获取的加密字段
     */
    schema.post('init', async function() {
      try {
        // 遍历所有加密字段
        for (const path of encryptedPaths) {
          const value = this.get(path);
          
          // 跳过未定义的值或非Buffer类型的值（未加密）
          if (value === undefined || value === null || !Buffer.isBuffer(value)) {
            continue;
          }
          
          // 解密字段
          const decryptedValue = await encryptionService.decryptField(value);
          
          // 设置解密后的值
          this.set(path, decryptedValue, { _skipEncryption: true });
        }
      } catch (error) {
        logger.error('init 钩子解密字段失败，已跳过该字段解密，可能导致数据展示异常:', error);
        // 解密失败不阻止后续操作，避免影响业务流程
      }
    });
    
    // 查询钩子：find、findOne等场景处理查询条件中加密字段
    schema.pre('find', encryptQueryHook);
    schema.pre('findOne', encryptQueryHook);
    schema.pre('findOneAndUpdate', encryptQueryHook);
    schema.pre('findOneAndDelete', encryptQueryHook);
    schema.pre('update', encryptQueryHook);
    schema.pre('updateOne', encryptQueryHook);
    schema.pre('updateMany', encryptQueryHook);
    
    /**
     * 查询钩子 - 处理查询条件中的加密字段
     */
    async function encryptQueryHook() {
      try {
        // 获取查询条件
        const conditions = this.getQuery();
        
        // 遍历所有加密字段
        for (const path of encryptedPaths) {
          // 检查查询条件中是否包含该字段
          if (conditions[path] !== undefined && conditions[path] !== null) {
            const config = modelEncryptionConfig[path];
            
            // 只有使用确定性加密的字段才能用于查询
            if (config.algorithm.includes('Deterministic')) {
              // 加密查询条件中的值
              conditions[path] = await encryptionService.encryptField(
                conditions[path],
                config.algorithm,
                config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
              );
            } else {
              // 随机加密的字段不能直接用于查询，需要特殊处理或提示
              logger.warn(`字段 ${path} 使用随机加密，不能直接用于查询条件。请考虑使用确定性加密或其他查询方法。`);
              // 删除不能用于查询的字段
              delete conditions[path];
            }
          }
          
          // 处理嵌套在$和操作符中的字段条件
          if (conditions.$or || conditions.$and) {
            const clauses = conditions.$or || conditions.$and;
            if (Array.isArray(clauses)) {
              for (const clause of clauses) {
                if (clause[path] !== undefined && clause[path] !== null) {
                  const config = modelEncryptionConfig[path];
                  if (config.algorithm.includes('Deterministic')) {
                    clause[path] = await encryptionService.encryptField(
                      clause[path],
                      config.algorithm,
                      config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
                    );
                  } else {
                    delete clause[path];
                  }
                }
              }
            }
          }
        }
      } catch (error) {
        logger.error('处理加密查询条件失败:', error);
        // 不阻止查询，但记录错误
      }
    }
    
    /**
     * 更新操作钩子 - 处理 updateOne 操作中的加密字段
     */
    schema.pre('updateOne', async function (next) {
      try {
        const update = this.getUpdate();
        if (!update) return next();

        // 处理$set操作符中的字段
        if (update.$set) {
          for (const path of encryptedPaths) {
            if (update.$set[path] !== undefined && update.$set[path] !== null && !Buffer.isBuffer(update.$set[path])) {
              const config = modelEncryptionConfig[path];
              update.$set[path] = await encryptionService.encryptField(
                update.$set[path],
                config.algorithm,
                config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
              );
            }
          }
        }

        // 处理直接更新字段
        for (const path of encryptedPaths) {
          if (update[path] !== undefined && update[path] !== null && !Buffer.isBuffer(update[path])) {
            const config = modelEncryptionConfig[path];
            update[path] = await encryptionService.encryptField(
              update[path],
              config.algorithm,
              config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
            );
          }
        }

        next();
      } catch (error) {
        logger.error('updateOne 操作加密字段失败:', error);
        next(error);
      }
    });

    /**
     * 更新操作钩子 - 处理 updateMany 操作中的加密字段
     */
    schema.pre('updateMany', async function (next) {
      try {
        const update = this.getUpdate();
        if (!update) return next();

        // 处理$set操作符中的字段
        if (update.$set) {
          for (const path of encryptedPaths) {
            if (update.$set[path] !== undefined && update.$set[path] !== null && !Buffer.isBuffer(update.$set[path])) {
              const config = modelEncryptionConfig[path];
              update.$set[path] = await encryptionService.encryptField(
                update.$set[path],
                config.algorithm,
                config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
              );
            }
          }
        }

        // 处理直接更新字段
        for (const path of encryptedPaths) {
          if (update[path] !== undefined && update[path] !== null && !Buffer.isBuffer(update[path])) {
            const config = modelEncryptionConfig[path];
            update[path] = await encryptionService.encryptField(
              update[path],
              config.algorithm,
              config.keyId || process.env.DEFAULT_ENCRYPTION_KEY_ID
            );
          }
        }

        next();
      } catch (error) {
        logger.error('updateMany 操作加密字段失败:', error);
        next(error);
      }
    });
    
    logger.info(`为模式应用了字段加密插件，加密字段: ${Array.from(encryptedPaths).join(', ')}`);
  };
}

module.exports = createEncryptionPlugin; 