const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

const forumPostSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  title: {
    type: String,
    required: true,
    maxlength: 200
  },
  content: {
    type: String,
    required: true
  },
  images: [{
    type: String
  }],
  tags: [{
    type: String
  }],
  view_count: {
    type: Number,
    default: 0
  },
  like_count: {
    type: Number,
    default: 0
  },
  comment_count: {
    type: Number,
    default: 0
  },
  is_pinned: {
    type: Boolean,
    default: false
  },
  is_highlighted: {
    type: Boolean,
    default: false
  },
  status: {
    type: String,
    enum: ['active', 'archived', 'deleted', 'pending_review', 'rejected'],
    default: 'active'
  },
  moderation: {
    is_moderated: {
      type: Boolean,
      default: false
    },
    moderated_by: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Admin'
    },
    moderated_at: {
      type: Date
    },
    rejection_reason: {
      type: String
    }
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  }
});

// 创建索引用于搜索
forumPostSchema.index({ title: 'text', content: 'text', tags: 'text' });
// 按照创建时间建立索引，便于查询最新帖子
forumPostSchema.index({ created_at: -1 });
// 按照用户ID和创建时间建立索引，便于查询用户的帖子
forumPostSchema.index({ user_id: 1, created_at: -1 });
// 按照点赞数建立索引，便于查询热门帖子
forumPostSchema.index({ like_count: -1 });
// 按照标签和创建时间建立索引，便于查询特定标签的帖子
forumPostSchema.index({ tags: 1, created_at: -1 });
// 按照状态和创建时间建立索引，便于查询特定状态的帖子
forumPostSchema.index({ status: 1, created_at: -1 });

// 更新前自动更新时间
forumPostSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const ForumPost = ModelFactory.model('ForumPost', forumPostSchema);

// 添加分片支持的保存方法
const originalSave = ForumPost.prototype.save;
ForumPost.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.ForumPost) {
    // 应用时间分片策略，使用created_at作为分片键
    const shardKey = this.created_at || new Date();
    const shardCollection = shardingService.getShardName('ForumPost', shardKey);
    console.log(`将论坛帖子保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = ForumPost; 