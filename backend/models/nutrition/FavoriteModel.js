const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

// 导入可能会用到的模型
const Dish = require('../../models/merchant/productDishModel');
const ForumPost = require('../../models/forum/forumPostModel');
const User = require('../../models/user/userModel');
const Store = require('../../models/merchant/storeModel');

const userFavoriteSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '收藏发起的用户ID'
  },
  itemType: {
    type: String,
    enum: ['dish', 'post', 'nutritionist', 'store'],
    required: true,
    description: '收藏项目类型'
  },
  itemId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    // 根据itemType动态引用不同模型
    refPath: 'itemTypeRef',
    description: '被收藏对象的ID'
  },
  itemTypeRef: {
    type: String,
    required: true,
    enum: ['Dish', 'ForumPost', 'User', 'Store'],
    // 根据itemType自动设置
    default: function() {
      switch(this.itemType) {
        case 'dish': return 'Dish';
        case 'post': return 'ForumPost';
        case 'nutritionist': return 'User';
        case 'store': return 'Store';
        default: return 'Dish';
      }
    },
    description: '被收藏对象的模型引用'
  },
  source: {
    type: String,
    enum: ['user', 'system', 'auto'],
    default: 'user',
    description: '收藏来源（用户主动收藏/系统推荐/自动收藏）'
  },
  isHidden: {
    type: Boolean,
    default: false,
    description: '是否隐藏该收藏项（用于软删除或用户设定）'
  },
  notes: {
    type: String,
    maxlength: 300,
    description: '收藏备注'
  },
  tags: [{
    type: String,
    description: '收藏标签'
  }]
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建复合索引确保用户对同一项目只有一条收藏记录
userFavoriteSchema.index({ userId: 1, itemType: 1, itemId: 1 }, { unique: true });
// 按照用户ID和创建时间建立索引，便于查询用户收藏列表
userFavoriteSchema.index({ userId: 1, createdAt: -1 });
// 按照内容类型和ID建立索引，便于统计某个内容的收藏数
userFavoriteSchema.index({ itemType: 1, itemId: 1 });
// 添加索引按照标签和用户ID
userFavoriteSchema.index({ userId: 1, tags: 1 });

// 添加虚拟字段
userFavoriteSchema.virtual('favoriteAge').get(function() {
  return Math.floor((Date.now() - this.createdAt) / (1000 * 60 * 60 * 24));
});

userFavoriteSchema.virtual('itemDetails', {
  refPath: 'itemTypeRef',
  localField: 'itemId',
  foreignField: '_id',
  justOne: true
});

// 实例方法：添加标签
userFavoriteSchema.methods.addTag = async function(tag) {
  if (!this.tags.includes(tag)) {
    this.tags.push(tag);
    return await this.save();
  }
  return this;
};

// 实例方法：移除标签
userFavoriteSchema.methods.removeTag = async function(tag) {
  if (this.tags.includes(tag)) {
    this.tags = this.tags.filter(t => t !== tag);
    return await this.save();
  }
  return this;
};

// 实例方法：更新笔记
userFavoriteSchema.methods.updateNotes = async function(notes) {
  this.notes = notes;
  return await this.save();
};

// 静态方法：检查是否已收藏
userFavoriteSchema.statics.isFavorited = async function(userId, itemType, itemId) {
  const count = await this.countDocuments({
    userId: userId,
    itemType: itemType,
    itemId: itemId
  });
  return count > 0;
};

// 静态方法：获取用户收藏列表
userFavoriteSchema.statics.getUserFavorites = async function(userId, options = {}) {
  const { 
    itemType = null, 
    tags = null, 
    sort = { createdAt: -1 }, 
    limit = 20, 
    skip = 0,
    populate = true 
  } = options;
  
  const query = { userId: userId, isHidden: false };
  
  if (itemType) {
    query.itemType = itemType;
  }
  
  if (tags && Array.isArray(tags) && tags.length > 0) {
    query.tags = { $in: tags };
  }
  
  let favoritesQuery = this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit);
  
  if (populate) {
    favoritesQuery = favoritesQuery.populate({
      path: 'itemDetails',
      select: function(itemType) {
        switch(itemType) {
          case 'dish':
            return 'name price images nutritionInfo merchantId';
          case 'post':
            return 'title content createdAt author tags';
          case 'nutritionist':
            return 'username fullName profileImage qualifications.specializations';
          case 'store':
            return 'name address businessHours merchantId averageRating';
          default:
            return '';
        }
      }
    });
  }
  
  const favorites = await favoritesQuery.exec();
  const total = await this.countDocuments(query);
  
  return {
    favorites,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 静态方法：切换收藏状态
userFavoriteSchema.statics.toggleFavorite = async function(userId, itemType, itemId, options = {}) {
  const { notes = '', tags = [] } = options;
  
  // 查找是否已收藏
  const existingFavorite = await this.findOne({
    userId: userId,
    itemType: itemType,
    itemId: itemId
  });
  
  // 如果已收藏，则取消收藏
  if (existingFavorite) {
    await existingFavorite.remove();
    return {
      status: 'removed',
      message: '已取消收藏',
      favorite: null
    };
  }
  
  // 如果未收藏，则添加收藏
  const favorite = new this({
    userId: userId,
    itemType: itemType,
    itemId: itemId,
    notes,
    tags
  });
  
  await favorite.save();
  
  return {
    status: 'added',
    message: '已添加收藏',
    favorite
  };
};

// 静态方法：批量添加收藏
userFavoriteSchema.statics.batchAddFavorites = async function(userId, items) {
  /*
  items格式: [
    { itemType: 'dish', itemId: '123', notes: 'yummy', tags: ['spicy', 'recommend'] },
    { itemType: 'nutritionist', itemId: '456', notes: 'professional', tags: [] },
  ]
  */
  
  const results = {
    success: [],
    failed: [],
    duplicates: []
  };
  
  for (const item of items) {
    try {
      // 检查是否已存在
      const existing = await this.findOne({
        userId: userId,
        itemType: item.itemType,
        itemId: item.itemId
      });
      
      if (existing) {
        results.duplicates.push({
          itemType: item.itemType,
          itemId: item.itemId,
          message: '已收藏此项目'
        });
        continue;
      }
      
      // 创建新收藏
      const favorite = new this({
        userId: userId,
        itemType: item.itemType,
        itemId: item.itemId,
        notes: item.notes || '',
        tags: item.tags || []
      });
      
      await favorite.save();
      results.success.push({
        itemType: item.itemType,
        itemId: item.itemId,
        favorite: favorite
      });
    } catch (error) {
      results.failed.push({
        itemType: item.itemType,
        itemId: item.itemId,
        error: error.message
      });
    }
  }
  
  return results;
};

// 静态方法：获取收藏统计
userFavoriteSchema.statics.getFavoriteStats = async function(itemType, itemId) {
  const stats = await this.aggregate([
    {
      $match: {
        itemType: itemType,
        itemId: mongoose.Types.ObjectId(itemId)
      }
    },
    {
      $group: {
        _id: null,
        count: { $sum: 1 },
        tagsArray: { $push: '$tags' },
        firstFavorited: { $min: '$createdAt' },
        lastFavorited: { $max: '$createdAt' }
      }
    }
  ]);
  
  if (stats.length === 0) {
    return {
      count: 0,
      popularTags: [],
      firstFavorited: null,
      lastFavorited: null
    };
  }
  
  // 处理标签统计
  const tagCounts = {};
  stats[0].tagsArray.forEach(tags => {
    tags.forEach(tag => {
      tagCounts[tag] = (tagCounts[tag] || 0) + 1;
    });
  });
  
  const popularTags = Object.entries(tagCounts)
    .map(([tag, count]) => ({ tag, count }))
    .sort((a, b) => b.count - a.count)
    .slice(0, 10);
  
  return {
    count: stats[0].count,
    popularTags,
    firstFavorited: stats[0].firstFavorited,
    lastFavorited: stats[0].lastFavorited
  };
};

// 静态方法：获取用户按标签分组的收藏
userFavoriteSchema.statics.getFavoritesByTags = async function(userId, limit = 20) {
  return this.aggregate([
    {
      $match: { userId: mongoose.Types.ObjectId(userId) }
    },
    {
      $unwind: '$tags'
    },
    {
      $group: {
        _id: '$tags',
        count: { $sum: 1 },
        favorites: { $push: { itemId: '$itemId', itemType: '$itemType', createdAt: '$createdAt' } }
      }
    },
    {
      $project: {
        tag: '$_id',
        count: 1,
        favorites: { $slice: ['$favorites', 5] }  // 每个标签只返回5个收藏
      }
    },
    {
      $sort: { count: -1 }
    },
    {
      $limit: limit
    }
  ]);
};

// 中间件：更新目标对象的收藏计数
userFavoriteSchema.post('save', async function(doc) {
  try {
    // 根据不同的收藏类型，更新不同对象的收藏计数
    switch(doc.itemType) {
      case 'dish':
        await Dish.findByIdAndUpdate(
          doc.itemId,
          { $inc: { favoriteCount: 1 } }
        );
        break;
      case 'post':
        await ForumPost.findByIdAndUpdate(
          doc.itemId,
          { $inc: { favoriteCount: 1 } }
        );
        break;
      case 'store':
        await Store.findByIdAndUpdate(
          doc.itemId,
          { $inc: { favoriteCount: 1 } }
        );
        break;
      // 对于营养师收藏，更新用户模型
      case 'nutritionist':
        await User.findByIdAndUpdate(
          doc.itemId,
          { $inc: { 'nutritionistProfile.favoriteCount': 1 } }
        );
        break;
    }
  } catch (err) {
    console.error('更新收藏计数失败:', err);
  }
});

// 中间件：更新目标对象的收藏计数 - 取消收藏
userFavoriteSchema.pre('remove', async function() {
  try {
    // 根据不同的收藏类型，更新不同对象的收藏计数
    switch(this.itemType) {
      case 'dish':
        await Dish.findByIdAndUpdate(
          this.itemId,
          { $inc: { favoriteCount: -1 } }
        );
        break;
      case 'post':
        await ForumPost.findByIdAndUpdate(
          this.itemId,
          { $inc: { favoriteCount: -1 } }
        );
        break;
      case 'store':
        await Store.findByIdAndUpdate(
          this.itemId,
          { $inc: { favoriteCount: -1 } }
        );
        break;
      // 对于营养师收藏，更新用户模型
      case 'nutritionist':
        await User.findByIdAndUpdate(
          this.itemId,
          { $inc: { 'nutritionistProfile.favoriteCount': -1 } }
        );
        break;
    }
  } catch (err) {
    console.error('更新收藏计数失败:', err);
  }
});

// 使用ModelFactory创建支持读写分离的模型
const UserFavorite = ModelFactory.createModel('UserFavorite', userFavoriteSchema);

// 添加分片支持
UserFavorite.getShardKey = function(doc) {
  return doc.userId.toString();
};

module.exports = UserFavorite;