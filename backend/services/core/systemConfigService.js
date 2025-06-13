const SystemConfig = require('../../models/core/systemConfigModel');
const { AppError } = require('../../utils/errors');

/**
 * 系统配置服务
 * 提供系统配置的增删改查功能
 */
class SystemConfigService {
  /**
   * 获取单个配置值
   * @param {string} key - 配置键名
   * @param {any} defaultValue - 默认值
   * @returns {Promise<any>} 配置值
   */
  async getConfigValue(key, defaultValue = null) {
    try {
      return await SystemConfig.getValue(key, defaultValue);
    } catch (error) {
      console.error(`获取配置失败: ${key}`, error);
      return defaultValue;
    }
  }

  /**
   * 设置配置值
   * @param {string} key - 配置键名
   * @param {any} value - 配置值
   * @param {string} updatedBy - 更新者ID
   * @returns {Promise<Object>} 更新后的配置
   */
  async setConfigValue(key, value, updatedBy = null) {
    try {
      const config = await SystemConfig.findOne({ key });
      
      if (!config) {
        throw new AppError(`配置项不存在: ${key}`, 404);
      }
      
      if (!config.isEditable) {
        throw new AppError(`配置项不可编辑: ${key}`, 403);
      }
      
      // 类型验证
      if (config.valueType === 'boolean' && typeof value !== 'boolean') {
        throw new AppError(`配置值类型错误，期望boolean类型`, 400);
      }
      
      if (config.valueType === 'number' && typeof value !== 'number') {
        throw new AppError(`配置值类型错误，期望number类型`, 400);
      }
      
      return await SystemConfig.setValue(key, value, updatedBy);
    } catch (error) {
      console.error(`设置配置失败: ${key}`, error);
      throw error;
    }
  }

  /**
   * 批量获取配置
   * @param {string[]} keys - 配置键名数组
   * @returns {Promise<Object>} 配置值映射
   */
  async getMultipleConfigs(keys) {
    try {
      return await SystemConfig.getMultiple(keys);
    } catch (error) {
      console.error('批量获取配置失败', error);
      throw error;
    }
  }

  /**
   * 获取分类下的所有配置
   * @param {string} category - 配置分类
   * @returns {Promise<Object>} 配置列表
   */
  async getConfigsByCategory(category) {
    try {
      return await SystemConfig.getByCategory(category);
    } catch (error) {
      console.error(`获取分类配置失败: ${category}`, error);
      throw error;
    }
  }

  /**
   * 获取所有公开配置
   * @returns {Promise<Object>} 公开配置列表
   */
  async getPublicConfigs() {
    try {
      const configs = await SystemConfig.find({ isPublic: true });
      return configs.reduce((acc, config) => {
        acc[config.key] = config.value;
        return acc;
      }, {});
    } catch (error) {
      console.error('获取公开配置失败', error);
      throw error;
    }
  }

  /**
   * 获取认证功能配置
   * @returns {Promise<Object>} 认证功能配置
   */
  async getCertificationConfigs() {
    try {
      const keys = [
        'merchant_certification_enabled',
        'nutritionist_certification_enabled',
        'merchant_certification_mode',
        'nutritionist_certification_mode'
      ];
      
      return await this.getMultipleConfigs(keys);
    } catch (error) {
      console.error('获取认证功能配置失败', error);
      throw error;
    }
  }

  /**
   * 更新认证功能配置
   * @param {Object} configs - 配置对象
   * @param {string} updatedBy - 更新者ID
   * @returns {Promise<Object>} 更新结果
   */
  async updateCertificationConfigs(configs, updatedBy) {
    try {
      const results = {};
      
      for (const [key, value] of Object.entries(configs)) {
        if (key.includes('certification')) {
          const config = await this.setConfigValue(key, value, updatedBy);
          results[key] = config.value;
        }
      }
      
      return results;
    } catch (error) {
      console.error('更新认证功能配置失败', error);
      throw error;
    }
  }

  /**
   * 创建新配置
   * @param {Object} configData - 配置数据
   * @returns {Promise<Object>} 创建的配置
   */
  async createConfig(configData) {
    try {
      const exists = await SystemConfig.findOne({ key: configData.key });
      if (exists) {
        throw new AppError(`配置项已存在: ${configData.key}`, 409);
      }
      
      const config = await SystemConfig.create(configData);
      return config;
    } catch (error) {
      console.error('创建配置失败', error);
      throw error;
    }
  }

  /**
   * 删除配置
   * @param {string} key - 配置键名
   * @returns {Promise<boolean>} 是否删除成功
   */
  async deleteConfig(key) {
    try {
      const config = await SystemConfig.findOne({ key });
      
      if (!config) {
        throw new AppError(`配置项不存在: ${key}`, 404);
      }
      
      if (!config.isEditable) {
        throw new AppError(`配置项不可删除: ${key}`, 403);
      }
      
      await SystemConfig.deleteOne({ key });
      return true;
    } catch (error) {
      console.error(`删除配置失败: ${key}`, error);
      throw error;
    }
  }

  /**
   * 获取所有配置（管理后台使用）
   * @param {Object} filter - 过滤条件
   * @returns {Promise<Array>} 配置列表
   */
  async getAllConfigs(filter = {}) {
    try {
      const query = {};
      
      if (filter.category) {
        query.category = filter.category;
      }
      
      if (filter.isPublic !== undefined) {
        query.isPublic = filter.isPublic;
      }
      
      if (filter.isEditable !== undefined) {
        query.isEditable = filter.isEditable;
      }
      
      const configs = await SystemConfig.find(query)
        .sort({ category: 1, key: 1 });
      
      return configs;
    } catch (error) {
      console.error('获取所有配置失败', error);
      throw error;
    }
  }

  /**
   * 初始化默认配置
   * @returns {Promise<void>}
   */
  async initializeDefaults() {
    try {
      await SystemConfig.initializeDefaults();
    } catch (error) {
      console.error('初始化默认配置失败', error);
      throw error;
    }
  }
}

// 导出单例
module.exports = new SystemConfigService();