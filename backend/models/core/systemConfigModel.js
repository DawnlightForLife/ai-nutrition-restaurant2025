const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');

/**
 * 系统配置模型
 * 用于存储系统级别的配置项，如功能开关、全局设置等
 */
const systemConfigSchema = new mongoose.Schema({
  // 配置键名，唯一标识
  key: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    index: true
  },
  
  // 配置值，支持多种类型
  value: {
    type: mongoose.Schema.Types.Mixed,
    required: true
  },
  
  // 配置类型，用于前端解析
  valueType: {
    type: String,
    enum: ['boolean', 'number', 'string', 'json', 'array'],
    default: 'string'
  },
  
  // 配置分类
  category: {
    type: String,
    enum: ['feature', 'system', 'business', 'ui', 'security'],
    default: 'system'
  },
  
  // 配置描述
  description: {
    type: String,
    required: true
  },
  
  // 是否公开（是否可以通过公开API获取）
  isPublic: {
    type: Boolean,
    default: false
  },
  
  // 是否可编辑
  isEditable: {
    type: Boolean,
    default: true
  },
  
  // 更新信息
  updatedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin'
  },
  
  // 备注
  remark: String
}, {
  timestamps: true
});

// 索引
systemConfigSchema.index({ category: 1, key: 1 });

// 静态方法：获取配置值
systemConfigSchema.statics.getValue = async function(key, defaultValue = null) {
  try {
    const config = await this.findOne({ key });
    return config ? config.value : defaultValue;
  } catch (error) {
    console.error(`获取系统配置失败: ${key}`, error);
    return defaultValue;
  }
};

// 静态方法：设置配置值
systemConfigSchema.statics.setValue = async function(key, value, updatedBy = null) {
  try {
    const config = await this.findOneAndUpdate(
      { key },
      { 
        value,
        updatedBy,
        updatedAt: new Date()
      },
      { 
        new: true,
        runValidators: true
      }
    );
    return config;
  } catch (error) {
    console.error(`设置系统配置失败: ${key}`, error);
    throw error;
  }
};

// 静态方法：批量获取配置
systemConfigSchema.statics.getMultiple = async function(keys) {
  try {
    const configs = await this.find({ key: { $in: keys } });
    const result = {};
    
    configs.forEach(config => {
      result[config.key] = config.value;
    });
    
    // 对于未找到的配置，返回null
    keys.forEach(key => {
      if (!(key in result)) {
        result[key] = null;
      }
    });
    
    return result;
  } catch (error) {
    console.error('批量获取系统配置失败', error);
    throw error;
  }
};

// 静态方法：获取分类下的所有配置
systemConfigSchema.statics.getByCategory = async function(category) {
  try {
    const configs = await this.find({ category });
    return configs.reduce((acc, config) => {
      acc[config.key] = {
        value: config.value,
        description: config.description,
        valueType: config.valueType,
        isEditable: config.isEditable
      };
      return acc;
    }, {});
  } catch (error) {
    console.error(`获取分类配置失败: ${category}`, error);
    throw error;
  }
};

// 预设的默认配置
const defaultConfigs = [
  {
    key: 'merchant_certification_enabled',
    value: false,
    valueType: 'boolean',
    category: 'feature',
    description: '商家认证功能开关',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'nutritionist_certification_enabled',
    value: false,
    valueType: 'boolean',
    category: 'feature',
    description: '营养师认证功能开关',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'merchant_certification_mode',
    value: 'contact', // 'contact' | 'auto'
    valueType: 'string',
    category: 'feature',
    description: '商家认证模式：contact-联系客服，auto-自动认证',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'nutritionist_certification_mode',
    value: 'contact', // 'contact' | 'auto'
    valueType: 'string',
    category: 'feature',
    description: '营养师认证模式：contact-联系客服，auto-自动认证',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'certification_contact_wechat',
    value: 'AIHealth2025',
    valueType: 'string',
    category: 'business',
    description: '认证客服微信号',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'certification_contact_phone',
    value: '400-123-4567',
    valueType: 'string',
    category: 'business',
    description: '认证客服电话',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'certification_contact_email',
    value: 'cert@aihealth.com',
    valueType: 'string',
    category: 'business',
    description: '认证客服邮箱',
    isPublic: true,
    isEditable: true
  },
  {
    key: 'legacy_certification_enabled',
    value: false,
    valueType: 'boolean',
    category: 'feature',
    description: '是否启用旧版认证流程（用于向后兼容）',
    isPublic: false,
    isEditable: true
  },
  {
    key: 'show_certification_migration_notice',
    value: true,
    valueType: 'boolean',
    category: 'feature',
    description: '是否显示认证流程迁移通知',
    isPublic: true,
    isEditable: true
  }
];

// 静态方法：初始化默认配置
systemConfigSchema.statics.initializeDefaults = async function() {
  try {
    for (const config of defaultConfigs) {
      const exists = await this.findOne({ key: config.key });
      if (!exists) {
        await this.create(config);
        console.log(`初始化系统配置: ${config.key}`);
      }
    }
    console.log('系统配置初始化完成');
  } catch (error) {
    console.error('初始化系统配置失败', error);
    throw error;
  }
};

// 使用ModelFactory创建模型
const SystemConfig = ModelFactory.createModel('SystemConfig', systemConfigSchema);

module.exports = SystemConfig;