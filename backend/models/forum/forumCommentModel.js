const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

const forumCommentSchema = new mongoose.Schema({
  postId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumPost',
    required: true,
    description: '所属帖子ID',
    sensitivityLevel: 2
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '评论用户ID',
    sensitivityLevel: 2
  },
  parentCommentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumComment',
    description: '父级评论ID（如果是回复）',
    sensitivityLevel: 2
  },
  content: {
    type: String,
    required: true,
    description: '评论内容',
    sensitivityLevel: 2
  },
  likeCount: {
    type: Number,
    default: 0,
    description: '点赞数量'
  },
  status: {
    type: String,
    enum: ['active', 'deleted', 'pendingReview', 'rejected'],
    default: 'active',
    description: '评论状态'
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
      description: '审核管理员ID'
    },
    moderatedAt: {
      type: Date,
      description: '审核时间'
    },
    rejectionReason: {
      type: String,
      description: '驳回原因',
      sensitivityLevel: 2
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于快速查找评论
forumCommentSchema.index({ postId: 1, createdAt: -1 });
forumCommentSchema.index({ parentCommentId: 1 });
// 添加按用户ID的索引，便于查找用户的所有评论
forumCommentSchema.index({ userId: 1, createdAt: -1 });
// 添加按状态的索引，便于查找需要审核的评论
forumCommentSchema.index({ status: 1, createdAt: -1 });
// 添加按点赞数的索引，便于查找热门评论
forumCommentSchema.index({ postId: 1, likeCount: -1 });

// 添加虚拟字段
forumCommentSchema.virtual('isReply').get(function() {
  return !!this.parentCommentId;
});

forumCommentSchema.virtual('isPopular').get(function() {
  return this.likeCount >= 5;
});

forumCommentSchema.virtual('isRecent').get(function() {
  const now = new Date();
  const oneDayAgo = new Date(now.getTime() - (24 * 60 * 60 * 1000));
  return new Date(this.createdAt) >= oneDayAgo;
});

// 虚拟字段以关联用户信息
forumCommentSchema.virtual('author', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

// 虚拟字段以关联回复的评论
forumCommentSchema.virtual('parentComment', {
  ref: 'ForumComment',
  localField: 'parentCommentId',
  foreignField: '_id',
  justOne: true
});

// 虚拟字段以关联子评论
forumCommentSchema.virtual('replies', {
  ref: 'ForumComment',
  localField: '_id',
  foreignField: 'parentCommentId'
});

// 实例方法
// 增加点赞
forumCommentSchema.methods.like = async function() {
  this.likeCount += 1;
  return await this.save();
};

// 取消点赞
forumCommentSchema.methods.unlike = async function() {
  if (this.likeCount > 0) {
    this.likeCount -= 1;
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
      isModerated: true,
      moderatedBy: adminId,
      moderatedAt: new Date(),
      rejectionReason: reason || '评论已被删除'
    };
  }
  
  await this.save();
  
  // 如果评论之前是活跃的，更新帖子评论计数
  if (wasActive) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        this.postId,
        { $inc: { commentCount: -1 } }
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
    isModerated: true,
    moderatedBy: adminId,
    moderatedAt: new Date()
  };
  
  if (approved) {
    this.status = 'active';
  } else {
    this.status = 'rejected';
    this.moderation.rejectionReason = reason || '评论未通过审核';
  }
  
  await this.save();
  
  // 如果评论被批准，更新帖子评论计数
  if (approved) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        this.postId,
        { $inc: { commentCount: 1 } }
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
    postId: this.postId,
    userId: userId,
    parentCommentId: this._id,
    content: content,
    status: global.contentModerationEnabled ? 'pendingReview' : 'active'
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
    sort = { createdAt: -1 },
    includeReplies = true,
    populateAuthor = true,
    populateReplies = true
  } = options;
  
  const query = {
    postId: postId,
    status: 'active'
  };
  
  // 如果不包含回复，只获取顶级评论
  if (!includeReplies) {
    query.parentCommentId = { $exists: false };
  }
  
  const total = await this.countDocuments(query);
  
  let commentsQuery = this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit);
  
  // 关联数据
  if (populateAuthor) {
    commentsQuery = commentsQuery.populate('author', 'username fullName profileImage');
  }
  
  if (includeReplies && populateReplies) {
    commentsQuery = commentsQuery.populate({
      path: 'replies',
      match: { status: 'active' },
      options: { sort: { createdAt: 1 } },
      populate: populateAuthor ? { 
        path: 'author', 
        select: 'username fullName profileImage' 
      } : undefined
    });
  }
  
  const comments = await commentsQuery;
  
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

// 获取用户评论
forumCommentSchema.statics.getUserComments = async function(userId, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { createdAt: -1 }
  } = options;
  
  const query = {
    userId: userId,
    status: 'active'
  };
  
  const total = await this.countDocuments(query);
  
  const comments = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate({
      path: 'postId',
      select: 'title'
    });
  
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
    postId: postId,
    status: 'active',
    likeCount: { $gte: 3 }
  })
  .sort({ likeCount: -1 })
  .limit(limit)
  .populate('author', 'username fullName profileImage');
};

// 获取待审核评论
forumCommentSchema.statics.getPendingComments = async function(options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { createdAt: 1 }
  } = options;
  
  const query = { status: 'pendingReview' };
  
  const total = await this.countDocuments(query);
  
  const comments = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('author', 'username fullName profileImage')
    .populate({
      path: 'postId',
      select: 'title'
    });
  
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

// 中间件
// 更新帖子评论计数
forumCommentSchema.post('save', async function(doc) {
  if (doc.status === 'active' && !doc._forumPostUpdated) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        doc.postId,
        { $inc: { commentCount: 1 } }
      );
      
      doc._forumPostUpdated = true;
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
});

// 防止重复计数
forumCommentSchema.post('findOneAndUpdate', async function(doc) {
  if (doc && doc.status === 'active' && !doc._forumPostUpdated) {
    try {
      const ForumPost = ModelFactory.createModel('ForumPost');
      await ForumPost.findByIdAndUpdate(
        doc.postId,
        { $inc: { commentCount: 1 } }
      );
      
      doc._forumPostUpdated = true;
    } catch (err) {
      console.error('更新帖子评论计数失败:', err);
    }
  }
});

// 内容审核
forumCommentSchema.pre('save', function(next) {
  if (this.isNew && this.status === 'active') {
    // 如果平台设置了内容审核，新评论默认为待审核状态
    if (global.contentModerationEnabled) {
      this.status = 'pendingReview';
    }
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const ForumComment = ModelFactory.createModel('ForumComment', forumCommentSchema);

// 添加分片支持
ForumComment.getShardKey = function(doc) {
  const month = doc.createdAt.getMonth() + 1;
  const year = doc.createdAt.getFullYear();
  return `${year}-${month}`;
};

module.exports = ForumComment;