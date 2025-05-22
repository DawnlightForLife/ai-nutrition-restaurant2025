const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

const forumPostSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '发帖用户ID',
    sensitivityLevel: 2
  },
  title: {
    type: String,
    required: true,
    maxlength: 200,
    description: '帖子标题'
  },
  content: {
    type: String,
    required: true,
    description: '帖子内容',
    sensitivityLevel: 2
  },
  images: [{
    type: String,
    description: '帖子图片URL',
    sensitivityLevel: 2
  }],
  tags: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'ForumTag',
    description: '帖子标签ID'
  }],
  viewCount: {
    type: Number,
    default: 0,
    description: '浏览数量'
  },
  likeCount: {
    type: Number,
    default: 0,
    description: '点赞数量'
  },
  commentCount: {
    type: Number,
    default: 0,
    description: '评论数量'
  },
  isPinned: {
    type: Boolean,
    default: false,
    description: '是否置顶'
  },
  isHighlighted: {
    type: Boolean,
    default: false,
    description: '是否加精'
  },
  status: {
    type: String,
    enum: ['active', 'archived', 'deleted', 'pendingReview', 'rejected'],
    default: 'active',
    description: '帖子状态'
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
      description: '拒绝原因',
      sensitivityLevel: 2
    }
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于搜索
forumPostSchema.index({ title: 'text', content: 'text', tags: 'text' });
// 按照创建时间建立索引，便于查询最新帖子
forumPostSchema.index({ createdAt: -1 });
// 按照用户ID和创建时间建立索引，便于查询用户的帖子
forumPostSchema.index({ userId: 1, createdAt: -1 });
// 按照点赞数建立索引，便于查询热门帖子
forumPostSchema.index({ likeCount: -1 });
// 按照标签和创建时间建立索引，便于查询特定标签的帖子
forumPostSchema.index({ tags: 1, createdAt: -1 });
// 按照状态和创建时间建立索引，便于查询特定状态的帖子
forumPostSchema.index({ status: 1, createdAt: -1 });

// 添加虚拟字段
forumPostSchema.virtual('isHot').get(function() {
  // 如果浏览量超过100或点赞超过20，则认为是热门帖子
  return (this.viewCount >= 100 || this.likeCount >= 20);
});

forumPostSchema.virtual('isRecent').get(function() {
  const now = new Date();
  const threeDaysAgo = new Date(now.getTime() - (3 * 24 * 60 * 60 * 1000));
  return new Date(this.createdAt) >= threeDaysAgo;
});

forumPostSchema.virtual('engagementScore').get(function() {
  // 计算帖子参与度分数：浏览量 + 点赞*5 + 评论*10
  return this.viewCount + (this.likeCount * 5) + (this.commentCount * 10);
});

// 虚拟字段以关联评论
forumPostSchema.virtual('comments', {
  ref: 'ForumComment',
  localField: '_id',
  foreignField: 'postId'
});

// 虚拟字段以关联作者信息
forumPostSchema.virtual('author', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

// 实例方法
// 增加浏览次数
forumPostSchema.methods.incrementViewCount = async function() {
  this.viewCount += 1;
  return await this.save();
};

// 增加或减少点赞
forumPostSchema.methods.toggleLike = async function(increment = true) {
  if (increment) {
    this.likeCount += 1;
  } else {
    this.likeCount = Math.max(0, this.likeCount - 1);
  }
  return await this.save();
};

// 更新评论计数
forumPostSchema.methods.updateCommentCount = async function(increment = true) {
  if (increment) {
    this.commentCount += 1;
  } else {
    this.commentCount = Math.max(0, this.commentCount - 1);
  }
  return await this.save();
};

// 添加或移除标签
forumPostSchema.methods.updateTags = async function(tagIds) {
  const oldTags = [...this.tags];
  this.tags = [...new Set([...tagIds])]; // 使用集合去重
  const result = await this.save();
  
  try {
    // 更新标签的帖子计数
    const ForumTag = ModelFactory.createModel('ForumTag');
    
    // 增加新添加标签的帖子计数
    const addedTags = this.tags.filter(t => !oldTags.some(ot => ot.toString() === t.toString()));
    for (const tagId of addedTags) {
      await ForumTag.findByIdAndUpdate(tagId, { $inc: { postCount: 1 } });
    }
    
    // 减少已移除标签的帖子计数
    const removedTags = oldTags.filter(t => !this.tags.some(nt => nt.toString() === t.toString()));
    for (const tagId of removedTags) {
      await ForumTag.findByIdAndUpdate(tagId, { $inc: { postCount: -1 } });
    }
  } catch (err) {
    console.error('更新标签帖子计数失败:', err);
  }
  
  return result;
};

// 移除标签
forumPostSchema.methods.removeTag = async function(tagId) {
  if (this.tags.some(t => t.toString() === tagId.toString())) {
    this.tags = this.tags.filter(t => t.toString() !== tagId.toString());
    const result = await this.save();
    
    try {
      // 减少标签的帖子计数
      const ForumTag = ModelFactory.createModel('ForumTag');
      await ForumTag.findByIdAndUpdate(tagId, { $inc: { postCount: -1 } });
    } catch (err) {
      console.error('更新标签帖子计数失败:', err);
    }
    
    return result;
  }
  return this;
};

// 管理员置顶或取消置顶
forumPostSchema.methods.togglePin = async function(pin = true) {
  this.isPinned = pin;
  return await this.save();
};

// 管理员加精或取消加精
forumPostSchema.methods.toggleHighlight = async function(highlight = true) {
  this.isHighlighted = highlight;
  return await this.save();
};

// 软删除帖子
forumPostSchema.methods.softDelete = async function(adminId, reason) {
  this.status = 'deleted';
  
  if (adminId) {
    this.moderation = {
      isModerated: true,
      moderatedBy: adminId,
      moderatedAt: new Date(),
      rejectionReason: reason || '帖子已被管理员删除'
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
    createdAt: { $gte: dateThreshold },
    $or: [
      { viewCount: { $gte: minViews } },
      { likeCount: { $gte: minLikes } }
    ]
  })
  .sort({ engagementScore: -1 })
  .skip(skip)
  .limit(limit)
  .populate('author', 'username fullName profileImage');
};

// 搜索帖子
forumPostSchema.statics.searchPosts = async function(query, options = {}) {
  const { 
    limit = 20, 
    skip = 0,
    sort = { createdAt: -1 },
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
  .populate('author', 'username fullName profileImage');
  
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
    sort = { createdAt: -1 },
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
    .populate('author', 'username fullName profileImage');
  
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
    sort = { createdAt: -1 },
    includeDeleted = false
  } = options;
  
  const query = {
    userId: userId,
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
    sort = { createdAt: 1 }
  } = options;
  
  const query = { status: 'pendingReview' };
  
  const total = await this.countDocuments(query);
  
  const posts = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('author', 'username fullName profileImage');
  
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
      createdAt: { $lt: dateThreshold },
      isPinned: false, // 不归档置顶帖
      isHighlighted: false // 不归档精华帖
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
        createdAt: { $gte: dateThreshold }
      }
    },
    { $unwind: '$tags' },
    { 
      $group: {
        _id: '$tags',
        count: { $sum: 1 },
        posts: { $push: '$_id' },
        totalViews: { $sum: '$viewCount' },
        totalLikes: { $sum: '$likeCount' },
        totalComments: { $sum: '$commentCount' }
      }
    },
    {
      $project: {
        tag: '$_id',
        count: 1,
        posts: 1,
        totalViews: 1,
        totalLikes: 1,
        totalComments: 1,
        engagementScore: {
          $add: [
            '$totalViews',
            { $multiply: ['$totalLikes', 5] },
            { $multiply: ['$totalComments', 10] }
          ]
        }
      }
    },
    { $sort: { engagementScore: -1 } },
    { $limit: limit }
  ]);
};

// 中间件
forumPostSchema.pre('save', function(next) {
  // 添加自定义逻辑
  if (this.isNew && this.status === 'active') {
    // 如果平台设置了内容审核，新帖子默认为待审核状态
    if (global.contentModerationEnabled) {
      this.status = 'pendingReview';
    }
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const ForumPost = ModelFactory.createModel('ForumPost', forumPostSchema);

// 添加分片支持
ForumPost.getShardKey = function(doc) {
  const month = doc.createdAt.getMonth() + 1;
  const year = doc.createdAt.getFullYear();
  return `${year}-${month}`;
};

module.exports = ForumPost;