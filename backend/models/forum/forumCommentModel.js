const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

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
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
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

// 添加虚拟字段
forumCommentSchema.virtual('is_reply').get(function() {
  return !!this.parent_comment_id;
});

forumCommentSchema.virtual('is_popular').get(function() {
  return this.like_count >= 5;
});

forumCommentSchema.virtual('is_recent').get(function() {
  const now = new Date();
  const oneDayAgo = new Date(now.getTime() - (24 * 60 * 60 * 1000));
  return new Date(this.created_at) >= oneDayAgo;
});

// 虚拟字段以关联用户信息
forumCommentSchema.virtual('author', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

// 虚拟字段以关联回复的评论
forumCommentSchema.virtual('parent_comment', {
  ref: 'ForumComment',
  localField: 'parent_comment_id',
  foreignField: '_id',
  justOne: true
});

// 虚拟字段以关联子评论
forumCommentSchema.virtual('replies', {
  ref: 'ForumComment',
  localField: '_id',
  foreignField: 'parent_comment_id'
});

// 实例方法
// 增加点赞
forumCommentSchema.methods.like = async function() {
  this.like_count += 1;
  return await this.save();
};

// 取消点赞
forumCommentSchema.methods.unlike = async function() {
  if (this.like_count > 0) {
    this.like_count -= 1;
    return await this.save();
  }
  return this;
};

// 软删除评论
forumCommentSchema.methods.softDelete = async function(adminId, reason) {
  // 保存原始状态用于更新帖子计数
  const wasActive = this.status === 'active';
  
  this.status = 'deleted';
  
  if (adminId) {
    this.moderation = {
      is_moderated: true,
      moderated_by: adminId,
      moderated_at: new Date(),
      rejection_reason: reason || '评论已被删除'
    };
  }
  
  await this.save();
  
  // 如果评论之前是活跃的，更新帖子评论计数
  if (wasActive) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        this.post_id,
        { $inc: { comment_count: -1 } }
      );
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
  
  return this;
};

// 审核评论
forumCommentSchema.methods.moderate = async function(adminId, approved, reason) {
  this.moderation = {
    is_moderated: true,
    moderated_by: adminId,
    moderated_at: new Date()
  };
  
  if (approved) {
    this.status = 'active';
  } else {
    this.status = 'rejected';
    this.moderation.rejection_reason = reason || '评论未通过审核';
  }
  
  await this.save();
  
  // 如果评论被批准，更新帖子评论计数
  if (approved) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        this.post_id,
        { $inc: { comment_count: 1 } }
      );
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
  
  return this;
};

// 创建回复
forumCommentSchema.methods.createReply = async function(userId, content) {
  const reply = new this.constructor({
    post_id: this.post_id,
    user_id: userId,
    parent_comment_id: this._id,
    content: content,
    status: global.contentModerationEnabled ? 'pending_review' : 'active'
  });
  
  await reply.save();
  return reply;
};

// 静态方法
// 获取帖子的评论
forumCommentSchema.statics.getPostComments = async function(postId, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: -1 },
    includeReplies = true,
    populateAuthor = true,
    populateReplies = true
  } = options;
  
  const query = {
    post_id: postId,
    status: 'active'
  };
  
  // 如果不包含回复，只获取顶级评论
  if (!includeReplies) {
    query.parent_comment_id = { $exists: false };
  }
  
  const total = await this.countDocuments(query);
  
  let commentsQuery = this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit);
  
  // 关联数据
  if (populateAuthor) {
    commentsQuery = commentsQuery.populate('author', 'username full_name profile_image');
  }
  
  if (includeReplies && populateReplies) {
    commentsQuery = commentsQuery.populate({
      path: 'replies',
      match: { status: 'active' },
      options: { sort: { created_at: 1 } },
      populate: populateAuthor ? { 
        path: 'author', 
        select: 'username full_name profile_image' 
      } : null
    });
  }
  
  const comments = await commentsQuery.exec();
  
  return {
    comments,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 获取用户的评论
forumCommentSchema.statics.getUserComments = async function(userId, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: -1 },
    includeDeleted = false
  } = options;
  
  const query = {
    user_id: userId,
    status: includeDeleted ? { $ne: 'pending_review' } : 'active'
  };
  
  const total = await this.countDocuments(query);
  
  const comments = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('post_id', 'title');
  
  return {
    comments,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 获取热门评论
forumCommentSchema.statics.getPopularComments = async function(postId, limit = 5) {
  return this.find({
    post_id: postId,
    status: 'active',
    like_count: { $gt: 0 }
  })
  .sort({ like_count: -1 })
  .limit(limit)
  .populate('author', 'username full_name profile_image');
};

// 获取等待审核的评论
forumCommentSchema.statics.getPendingComments = async function(options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: 1 }
  } = options;
  
  const query = { 
    status: 'pending_review' 
  };
  
  const total = await this.countDocuments(query);
  
  const comments = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('author', 'username full_name profile_image')
    .populate('post_id', 'title');
  
  return {
    comments,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 批量审核评论
forumCommentSchema.statics.bulkModerate = async function(commentIds, adminId, approved, reason) {
  const result = {
    success: [],
    failed: []
  };
  
  for (const commentId of commentIds) {
    try {
      const comment = await this.findById(commentId);
      if (!comment) {
        result.failed.push({
          id: commentId,
          error: '评论不存在'
        });
        continue;
      }
      
      if (comment.status !== 'pending_review') {
        result.failed.push({
          id: commentId,
          error: '评论已经被审核'
        });
        continue;
      }
      
      await comment.moderate(adminId, approved, reason);
      
      result.success.push({
        id: commentId,
        status: approved ? 'active' : 'rejected'
      });
    } catch (error) {
      result.failed.push({
        id: commentId,
        error: error.message
      });
    }
  }
  
  return result;
};

// 查找并计数帖子的顶级评论和回复
forumCommentSchema.statics.countTopLevelAndReplies = async function(postId) {
  const [topLevelResult, repliesResult] = await Promise.all([
    this.countDocuments({
      post_id: postId,
      status: 'active',
      parent_comment_id: { $exists: false }
    }),
    this.countDocuments({
      post_id: postId,
      status: 'active',
      parent_comment_id: { $exists: true, $ne: null }
    })
  ]);
  
  return {
    topLevelCount: topLevelResult,
    repliesCount: repliesResult,
    totalCount: topLevelResult + repliesResult
  };
};

// 移除旧的创建后更新帖子评论计数的中间件，改进版本
forumCommentSchema.post('save', async function(doc) {
  if (doc.isNew && doc.status === 'active') {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        doc.post_id,
        { $inc: { comment_count: 1 } }
      );
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
});

// 添加删除评论时更新帖子评论计数的中间件
forumCommentSchema.post('findOneAndUpdate', async function(doc) {
  if (doc && doc.status === 'deleted') {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        doc.post_id,
        { $inc: { comment_count: -1 } }
      );
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
});

// 移除不需要的中间件，由timestamps处理
forumCommentSchema.pre('save', function(next) {
  // 添加自定义逻辑
  if (this.isNew && this.status === 'active') {
    // 如果平台设置了内容审核，新评论默认为待审核状态
    if (global.contentModerationEnabled) {
      this.status = 'pending_review';
    }
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const ForumComment = ModelFactory.createModel('ForumComment', forumCommentSchema);

// 添加分片支持
ForumComment.getShardKey = function(doc) {
  return doc.post_id.toString();
};

module.exports = ForumComment; 