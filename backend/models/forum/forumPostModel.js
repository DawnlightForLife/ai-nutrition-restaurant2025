const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

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
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
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

// 添加虚拟字段
forumPostSchema.virtual('is_hot').get(function() {
  // 如果浏览量超过100或点赞超过20，则认为是热门帖子
  return (this.view_count >= 100 || this.like_count >= 20);
});

forumPostSchema.virtual('is_recent').get(function() {
  const now = new Date();
  const threeDaysAgo = new Date(now.getTime() - (3 * 24 * 60 * 60 * 1000));
  return new Date(this.created_at) >= threeDaysAgo;
});

forumPostSchema.virtual('engagement_score').get(function() {
  // 计算帖子参与度分数：浏览量 + 点赞*5 + 评论*10
  return this.view_count + (this.like_count * 5) + (this.comment_count * 10);
});

// 虚拟字段以关联评论
forumPostSchema.virtual('comments', {
  ref: 'ForumComment',
  localField: '_id',
  foreignField: 'post_id'
});

// 虚拟字段以关联作者信息
forumPostSchema.virtual('author', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

// 实例方法
// 增加浏览次数
forumPostSchema.methods.incrementViewCount = async function() {
  this.view_count += 1;
  return await this.save();
};

// 增加或减少点赞
forumPostSchema.methods.toggleLike = async function(increment = true) {
  if (increment) {
    this.like_count += 1;
  } else {
    this.like_count = Math.max(0, this.like_count - 1);
  }
  return await this.save();
};

// 更新评论计数
forumPostSchema.methods.updateCommentCount = async function(increment = true) {
  if (increment) {
    this.comment_count += 1;
  } else {
    this.comment_count = Math.max(0, this.comment_count - 1);
  }
  return await this.save();
};

// 添加或移除标签
forumPostSchema.methods.updateTags = async function(tags) {
  this.tags = [...new Set([...this.tags, ...tags])]; // 使用集合去重
  return await this.save();
};

// 移除标签
forumPostSchema.methods.removeTag = async function(tag) {
  this.tags = this.tags.filter(t => t !== tag);
  return await this.save();
};

// 管理员置顶或取消置顶
forumPostSchema.methods.togglePin = async function(pin = true) {
  this.is_pinned = pin;
  return await this.save();
};

// 管理员加精或取消加精
forumPostSchema.methods.toggleHighlight = async function(highlight = true) {
  this.is_highlighted = highlight;
  return await this.save();
};

// 软删除帖子
forumPostSchema.methods.softDelete = async function(adminId, reason) {
  this.status = 'deleted';
  
  if (adminId) {
    this.moderation = {
      is_moderated: true,
      moderated_by: adminId,
      moderated_at: new Date(),
      rejection_reason: reason || '帖子已被管理员删除'
    };
  }
  
  return await this.save();
};

// 归档旧帖子
forumPostSchema.methods.archive = async function() {
  this.status = 'archived';
  return await this.save();
};

// 静态方法
// 获取热门帖子
forumPostSchema.statics.getHotPosts = async function(options = {}) {
  const { 
    limit = 10, 
    skip = 0,
    days = 7,
    minViews = 50,
    minLikes = 5
  } = options;
  
  const dateThreshold = new Date();
  dateThreshold.setDate(dateThreshold.getDate() - days);
  
  return this.find({
    status: 'active',
    created_at: { $gte: dateThreshold },
    $or: [
      { view_count: { $gte: minViews } },
      { like_count: { $gte: minLikes } }
    ]
  })
  .sort({ engagement_score: -1 })
  .skip(skip)
  .limit(limit)
  .populate('author', 'username full_name profile_image');
};

// 搜索帖子
forumPostSchema.statics.searchPosts = async function(query, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: -1 },
    includeDeleted = false
  } = options;
  
  const searchQuery = {
    $text: { $search: query },
    status: includeDeleted ? { $ne: 'deleted' } : 'active'
  };
  
  const total = await this.countDocuments(searchQuery);
  
  const posts = await this.find(searchQuery, { 
    score: { $meta: "textScore" } 
  })
  .sort({ score: { $meta: "textScore" }, ...sort })
  .skip(skip)
  .limit(limit)
  .populate('author', 'username full_name profile_image');
  
  return {
    posts,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 按标签获取帖子
forumPostSchema.statics.getPostsByTags = async function(tags, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: -1 },
    matchAll = false // 是否要匹配所有标签
  } = options;
  
  const query = {
    status: 'active',
    tags: matchAll ? { $all: tags } : { $in: tags }
  };
  
  const total = await this.countDocuments(query);
  
  const posts = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('author', 'username full_name profile_image');
  
  return {
    posts,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 获取用户的帖子
forumPostSchema.statics.getUserPosts = async function(userId, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: -1 },
    includeDeleted = false
  } = options;
  
  const query = {
    user_id: userId,
    status: includeDeleted ? { $ne: 'deleted' } : 'active'
  };
  
  const total = await this.countDocuments(query);
  
  const posts = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit);
  
  return {
    posts,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 获取等待审核的帖子
forumPostSchema.statics.getPendingPosts = async function(options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { created_at: 1 }
  } = options;
  
  const query = { status: 'pending_review' };
  
  const total = await this.countDocuments(query);
  
  const posts = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('author', 'username full_name profile_image');
  
  return {
    posts,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 批量归档老帖子
forumPostSchema.statics.archiveOldPosts = async function(ageInDays = 180) {
  const dateThreshold = new Date();
  dateThreshold.setDate(dateThreshold.getDate() - ageInDays);
  
  const result = await this.updateMany(
    { 
      status: 'active',
      created_at: { $lt: dateThreshold },
      is_pinned: false, // 不归档置顶帖
      is_highlighted: false // 不归档精华帖
    },
    { $set: { status: 'archived' } }
  );
  
  return result;
};

// 分析热门话题
forumPostSchema.statics.analyzeTrendingTopics = async function(days = 7, limit = 10) {
  const dateThreshold = new Date();
  dateThreshold.setDate(dateThreshold.getDate() - days);
  
  return this.aggregate([
    { 
      $match: { 
        status: 'active',
        created_at: { $gte: dateThreshold }
      }
    },
    { $unwind: '$tags' },
    { 
      $group: {
        _id: '$tags',
        count: { $sum: 1 },
        posts: { $push: '$_id' },
        total_views: { $sum: '$view_count' },
        total_likes: { $sum: '$like_count' },
        total_comments: { $sum: '$comment_count' }
      }
    },
    {
      $project: {
        tag: '$_id',
        count: 1,
        posts: 1,
        total_views: 1,
        total_likes: 1,
        total_comments: 1,
        engagement_score: {
          $add: [
            '$total_views',
            { $multiply: ['$total_likes', 5] },
            { $multiply: ['$total_comments', 10] }
          ]
        }
      }
    },
    { $sort: { engagement_score: -1 } },
    { $limit: limit }
  ]);
};

// 移除不需要的中间件，由timestamps处理
forumPostSchema.pre('save', function(next) {
  // 添加自定义逻辑
  if (this.isNew && this.status === 'active') {
    // 如果平台设置了内容审核，新帖子默认为待审核状态
    if (global.contentModerationEnabled) {
      this.status = 'pending_review';
    }
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const ForumPost = ModelFactory.createModel('ForumPost', forumPostSchema);

// 添加分片支持
ForumPost.getShardKey = function(doc) {
  const month = doc.created_at.getMonth() + 1;
  const year = doc.created_at.getFullYear();
  return `${year}-${month}`;
};

module.exports = ForumPost; 