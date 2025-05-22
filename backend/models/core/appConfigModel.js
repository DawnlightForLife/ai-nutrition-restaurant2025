/**
 * 应用配置模型
 * 用于存储系统全局配置项
 * @module models/core/appConfigModel
 */

const mongoose = require('mongoose');

/**
 * @swagger
 * components:
 *   schemas:
 *     AppConfig:
 *       type: object
 *       required:
 *         - key
 *         - value
 *       properties:
 *         _id:
 *           type: string
 *           description: 配置唯一ID
 *         key:
 *           type: string
 *           description: 配置键名
 *         value:
 *           type: string
 *           description: 配置值
 *         description:
 *           type: string
 *           description: 配置说明
 *         isSystem:
 *           type: boolean
 *           description: 是否系统配置（系统配置不可删除）
 *         createdAt:
 *           type: string
 *           format: date-time
 *           description: 创建时间
 *         updatedAt:
 *           type: string
 *           format: date-time
 *           description: 更新时间
 */

/**
 * 应用配置模式
 * 每个配置项由key-value结构组成
 */
const appConfigSchema = new mongoose.Schema({
  // 配置键名，作为唯一标识
  key: {
    type: String,
    required: [true, '配置键名不能为空'],
    unique: true,
    trim: true,
    description: '配置键名'
  },
  
  // 配置值，使用Mixed类型存储任意数据类型
  value: {
    type: String,
    required: [true, '配置值不能为空'],
    description: '配置值'
  },
  
  // 配置分组，用于组织配置
  group: {
    type: String,
    default: 'general',
    description: '配置分组'
  },
  
  // 配置描述
  description: {
    type: String,
    default: '',
    description: '配置描述信息'
  },
  
  // 是否可见
  visible: {
    type: Boolean,
    default: true,
    description: '是否在管理界面可见'
  },
  
  // 可编辑级别
  editLevel: {
    type: String,
    enum: ['none', 'admin', 'superadmin'],
    default: 'admin',
    description: '配置可编辑级别'
  },
  
  // 敏感级别
  sensitivityLevel: {
    type: Number,
    min: 0,
    max: 3,
    default: 0,
    description: '敏感级别：0-无敏感，1-低敏感，2-中敏感，3-高敏感'
  },
  
  // 审计记录
  createdAt: {
    type: Date,
    default: Date.now,
    description: '创建时间'
  },
  
  updatedAt: {
    type: Date,
    default: Date.now,
    description: '最后更新时间'
  },
  
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    description: '创建者ID'
  },
  
  updatedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    description: '最后更新者ID'
  },
  
  isSystem: {
    type: Boolean,
    default: false
  }
}, {
  timestamps: true
});

// 创建索引
appConfigSchema.index({ key: 1 }, { unique: true });

// 更新前自动更新更新时间
appConfigSchema.pre('save', function(next) {
  if (this.isModified()) {
    this.updatedAt = new Date();
  }
  // 系统配置标记逻辑
  if (this.key.startsWith('system.')) {
    this.isSystem = true;
  }
  next();
});

/**
 * 通过键名获取配置
 * @param {string} key - 配置键名
 * @returns {Promise<Object>} 配置对象
 */
appConfigSchema.statics.getByKey = async function(key) {
  return this.findOne({ key });
};

/**
 * 通过分组获取配置
 * @param {string} group - 配置分组
 * @returns {Promise<Array>} 配置数组
 */
appConfigSchema.statics.getByGroup = async function(group) {
  return this.find({ group });
};

/**
 * 获取所有可见配置（排除敏感配置）
 * @returns {Promise<Array>} 配置数组
 */
appConfigSchema.statics.getVisibleConfigs = async function() {
  return this.find({ visible: true, sensitivityLevel: { $lt: 2 } });
};

/**
 * 设置配置值
 * @param {string} key - 配置键名
 * @param {*} value - 配置值
 * @param {string} [adminId] - 管理员ID
 * @returns {Promise<Object>} 更新后的配置对象
 */
appConfigSchema.statics.setConfig = async function(key, value, adminId) {
  const config = await this.findOne({ key });
  
  if (config) {
    config.value = value;
    if (adminId) {
      config.updatedBy = adminId;
    }
    return config.save();
  } else {
    return this.create({
      key,
      value,
      createdAt: new Date(),
      updatedAt: new Date(),
      createdBy: adminId,
      updatedBy: adminId
    });
  }
};

// 创建并导出模型
const AppConfig = mongoose.model('AppConfig', appConfigSchema);
module.exports = AppConfig; 