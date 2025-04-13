const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/core/shardingService');

// 导入可能会用到的模型
const Dish = require('../merchant/ProductDishModel');
const ForumPost = require('../forum/forumPostModel');
const User = require('../core/userModel');
const Store = require('../merchant/storeModel');

const userFavoriteSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  itemType: {
    type: String,
    enum: ['dish', 'post', 'nutritionist', 'store'],
    required: true
  },
  itemId: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    // 根据itemType动态引用不同模型
    refPath: 'itemTypeRef'
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
    }
  },
  notes: {
    type: String,
    maxlength: 300
  },
  tags: [{
    type: String
  }],
  // 移除手动的created_at和updated_at字段，使用mongoose的timestamps
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
  
  const query = { userId: userId };
  
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
        favoriteId: favorite._id
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

// 静态方法：获取最受欢迎的收藏项目
userFavoriteSchema.statics.getMostFavorited = async function(options = {}) {
  const { 
    itemType = null, 
    limit = 10, 
    minCount = 2,
    period = 30 // 最近30天内
  } = options;
  
  const match = {};
  
  if (itemType) {
    match.itemType = itemType;
  }
  
  // 如果指定时间段，添加时间条件
  if (period > 0) {
    const periodDate = new Date();
    periodDate.setDate(periodDate.getDate() - period);
    match.createdAt = { $gte: periodDate };
  }
  
  const aggregation = [
    { $match: match },
    { 
      $group: { 
        _id: { itemType: '$itemType', itemId: '$itemId' },
        count: { $sum: 1 },
        firstFavorited: { $min: '$createdAt' },
        lastFavorited: { $max: '$createdAt' }
      } 
    },
    { $match: { count: { $gte: minCount } } },
    { $sort: { count: -1 } },
    { $limit: limit }
  ];
  
  const results = await this.aggregate(aggregation);
  
  // 对每种类型分别查询详细信息
  const detailedResults = [];
  
  for (const result of results) {
    const { itemType, itemId } = result._id;
    let itemDetails = null;
    
    // 查询项目详情
    try {
      let model;
      if (itemType === 'dish') {
        model = Dish;
      } else if (itemType === 'post') {
        model = ForumPost;
      } else if (itemType === 'nutritionist') {
        model = User;
      } else if (itemType === 'store') {
        model = Store;
      }
      
      if (model) {
        itemDetails = await model.findById(itemId);
      }
    } catch (error) {
      console.error(`Error fetching details for ${itemType} ${itemId}:`, error);
    }
    
    detailedResults.push({
      itemType,
      itemId,
      favoritesCount: result.count,
      firstFavorited: result.firstFavorited,
      lastFavorited: result.lastFavorited,
      details: itemDetails
    });
  }
  
  return detailedResults;
};

// 使用ModelFactory创建支持读写分离的模型
const UserFavorite = ModelFactory.createModel('UserFavorite', userFavoriteSchema);

// 添加分片支持
UserFavorite.getShardKey = function(doc) {
  return doc.userId.toString();
};

module.exports = UserFavorite; 