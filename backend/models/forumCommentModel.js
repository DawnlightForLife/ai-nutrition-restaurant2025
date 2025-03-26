const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

const forumCommentSchema = new mongoose.Schema({
  post_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumPost',
    required: true
  },
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  // 回复其他评论时使用
  parent_comment_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumComment'
  },
  content: {
    type: String,
    required: true
  },
  like_count: {
    type: Number,
    default: 0
  },
  // 评论状态
  status: {
    type: String,
    enum: ['active', 'deleted', 'pending_review', 'rejected'],
    default: 'active'
  },
  // 审核信息
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

// 创建索引用于快速查找评论
forumCommentSchema.index({ post_id: 1, created_at: -1 });
forumCommentSchema.index({ parent_comment_id: 1 });
// 添加按用户ID的索引，便于查找用户的所有评论
forumCommentSchema.index({ user_id: 1, created_at: -1 });
// 添加按状态的索引，便于查找需要审核的评论
forumCommentSchema.index({ status: 1, created_at: -1 });
// 添加按点赞数的索引，便于查找热门评论
forumCommentSchema.index({ post_id: 1, like_count: -1 });

// 更新前自动更新时间
forumCommentSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 创建评论后更新帖子评论计数的中间件
forumCommentSchema.post('save', async function(doc) {
  if (doc.status === 'active') {
    try {
      const ForumPost = ModelFactory.model('ForumPost');
      await ForumPost.findByIdAndUpdate(
        doc.post_id,
        { $inc: { comment_count: 1 } }
      );
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
});

// 使用ModelFactory创建支持读写分离的模型
const ForumComment = ModelFactory.model('ForumComment', forumCommentSchema);

// 添加分片支持的保存方法
const originalSave = ForumComment.prototype.save;
ForumComment.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.ForumComment) {
    // 使用帖子ID作为分片键，确保同一帖子的评论在同一分片
    const shardKey = this.post_id.toString();
    const shardCollection = shardingService.getShardName('ForumComment', shardKey);
    console.log(`将论坛评论保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = ForumComment; 