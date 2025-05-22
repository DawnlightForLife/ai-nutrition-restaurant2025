/**
 * 论坛标签模型
 * 定义社区论坛中使用的标签数据结构
 * @module models/forum/forumTagModel
 */

const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

const forumTagSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    maxlength: 50,
    description: '标签名称'
  },
  slug: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
    description: '标签别名（URL友好）'
  },
  description: {
    type: String,
    maxlength: 500,
    description: '标签描述'
  },
  iconUrl: {
    type: String,
    description: '标签图标URL'
  },
  color: {
    type: String,
    default: '#FFFFFF',
    description: '标签颜色（十六进制）'
  },
  category: {
    type: String,
    enum: ['nutrition', 'health', 'recipe', 'experience', 'discussion', 'question', 'news', 'other'],
    default: 'other',
    description: '标签类别'
  },
  postCount: {
    type: Number,
    default: 0,
    description: '使用该标签的帖子数量'
  },
  isRecommended: {
    type: Boolean,
    default: false,
    description: '是否为推荐标签'
  },
  isSystem: {
    type: Boolean,
    default: false,
    description: '是否为系统标签（用户不可修改）'
  },
  relatedTags: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumTag',
    description: '相关标签ID'
  }],
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    refPath: 'createdByType',
    description: '创建者ID'
  },
  createdByType: {
    type: String,
    enum: ['User', 'Admin', 'System'],
    default: 'System',
    description: '创建者类型'
  },
  status: {
    type: String,
    enum: ['active', 'inactive', 'pending'],
    default: 'active',
    description: '标签状态'
  },
  moderation: {
    isModerated: {
      type: Boolean,
      default: false,
      description: '是否已审核'
    },
    moderatedBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin',
      description: '审核人ID'
    },
    moderatedAt: {
      type: Date,
      description: '审核时间'
    },
    rejectionReason: {
      type: String,
      description: '拒绝原因'
    }
  },
  metadata: {
    aiGenerated: {
      type: Boolean,
      default: false,
      description: '是否由AI生成'
    },
    aiConfidence: {
      type: Number,
      min: 0,
      max: 1,
      description: 'AI生成置信度(0-1)'
    },
    nutritionRelevance: {
      type: Number,
      min: 0,
      max: 100,
      description: '与营养相关度(0-100)'
    },
    healthRelevance: {
      type: Number,
      min: 0,
      max: 100,
      description: '与健康相关度(0-100)'
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引
forumTagSchema.index({ name: 1 }, { unique: true });
forumTagSchema.index({ slug: 1 }, { unique: true });
forumTagSchema.index({ category: 1 });
forumTagSchema.index({ postCount: -1 });
forumTagSchema.index({ isRecommended: 1 });
forumTagSchema.index({ status: 1 });
forumTagSchema.index({ 'metadata.nutritionRelevance': -1 });
forumTagSchema.index({ 'metadata.healthRelevance': -1 });
forumTagSchema.index({ createdAt: -1 });

// 全文搜索索引
forumTagSchema.index({ name: 'text', description: 'text' });

// 添加虚拟字段
forumTagSchema.virtual('isPopular').get(function() {
  // 当帖子数超过50时，认为是热门标签
  return this.postCount >= 50;
});

forumTagSchema.virtual('isNew').get(function() {
  const now = new Date();
  const sevenDaysAgo = new Date(now.getTime() - (7 * 24 * 60 * 60 * 1000));
  return new Date(this.createdAt) >= sevenDaysAgo;
});

// 虚拟字段以关联帖子
forumTagSchema.virtual('posts', {
  ref: 'ForumPost',
  localField: '_id',
  foreignField: 'tags'
});

// 实例方法
// 更新帖子计数
forumTagSchema.methods.updatePostCount = async function(increment = true) {
  if (increment) {
    this.postCount += 1;
  } else {
    this.postCount = Math.max(0, this.postCount - 1);
  }
  return await this.save();
};

// 添加相关标签
forumTagSchema.methods.addRelatedTag = async function(tagId) {
  // 检查是否已经存在
  if (!this.relatedTags.includes(tagId)) {
    this.relatedTags.push(tagId);
    return await this.save();
  }
  return this;
};

// 移除相关标签
forumTagSchema.methods.removeRelatedTag = async function(tagId) {
  this.relatedTags = this.relatedTags.filter(id => id.toString() !== tagId.toString());
  return await this.save();
};

// 设置推荐状态
forumTagSchema.methods.setRecommended = async function(isRecommended = true) {
  this.isRecommended = isRecommended;
  return await this.save();
};

// 审核标签
forumTagSchema.methods.moderate = async function(adminId, approved, reason) {
  this.moderation = {
    isModerated: true,
    moderatedBy: adminId,
    moderatedAt: new Date()
  };
  
  if (approved) {
    this.status = 'active';
  } else {
    this.status = 'inactive';
    this.moderation.rejectionReason = reason || '标签未通过审核';
  }
  
  return await this.save();
};

// 静态方法
forumTagSchema.statics.findByCategory = function(category) {
  return this.find({ category, status: 'active' })
    .sort({ postCount: -1 });
};

forumTagSchema.statics.findPopular = function(limit = 10) {
  return this.find({ status: 'active' })
    .sort({ postCount: -1 })
    .limit(limit);
};

forumTagSchema.statics.findRecommended = function() {
  return this.find({ isRecommended: true, status: 'active' })
    .sort({ postCount: -1 });
};

forumTagSchema.statics.findRelated = async function(tagId) {
  try {
    const tag = await this.findById(tagId);
    if (!tag) return [];
    
    // 查找直接关联的标签
    const directRelatedTags = await this.find({
      _id: { $in: tag.relatedTags },
      status: 'active'
    });
    
    // 如果直接关联的标签不足5个，根据类别和相关度补充
    if (directRelatedTags.length < 5) {
      const additionalTags = await this.find({
        _id: { $ne: tagId },
        _id: { $nin: tag.relatedTags },
        category: tag.category,
        status: 'active'
      })
      .sort({ postCount: -1 })
      .limit(5 - directRelatedTags.length);
      
      return [...directRelatedTags, ...additionalTags];
    }
    
    return directRelatedTags;
  } catch (err) {
    console.error('查找相关标签失败:', err);
    return [];
  }
};

// 预保存钩子 - 创建标签别名
forumTagSchema.pre('save', function(next) {
  if (this.isNew || this.isModified('name')) {
    // 生成slug，用于URL
    this.slug = this.name
      .toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^\w\-]+/g, '')
      .replace(/\-\-+/g, '-')
      .replace(/^-+/, '')
      .replace(/-+$/, '');
  }
  next();
});

// 使用ModelFactory创建模型
const ForumTag = ModelFactory.createModel('ForumTag', forumTagSchema);

// 添加分片支持的保存方法
const originalSave = ForumTag.prototype.save;
ForumTag.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.ForumTag) {
    // 使用标签类别作为分片键
    const shardKey = this.category || 'other';
    const shardCollection = shardingService.getShardName('ForumTag', shardKey);
    console.log(`将标签保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = ForumTag; 