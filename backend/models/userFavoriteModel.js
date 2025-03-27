const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

// 导入可能会用到的模型
const Dish = require('./dishModel');
const ForumPost = require('./forumPostModel');
const User = require('./userModel');
const Store = require('./storeModel');

const userFavoriteSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  item_type: {
    type: String,
    enum: ['dish', 'post', 'nutritionist', 'store'],
    required: true
  },
  item_id: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    // 根据item_type动态引用不同模型
    refPath: 'item_type_ref'
  },
  item_type_ref: {
    type: String,
    required: true,
    enum: ['Dish', 'ForumPost', 'User', 'Store'],
    // 根据item_type自动设置
    default: function() {
      switch(this.item_type) {
        case 'dish': return 'Dish';
        case 'post': return 'ForumPost';
        case 'nutritionist': return 'User';
        case 'store': return 'Store';
        default: return 'Dish';
      }
    }
  },
  notes: {
    type: String
  },
  tags: [{
    type: String
  }],
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

// 创建复合索引确保用户对同一项目只有一条收藏记录
userFavoriteSchema.index({ user_id: 1, item_type: 1, item_id: 1 }, { unique: true });
// 按照用户ID和创建时间建立索引，便于查询用户收藏列表
userFavoriteSchema.index({ user_id: 1, created_at: -1 });
// 按照内容类型和ID建立索引，便于统计某个内容的收藏数
userFavoriteSchema.index({ item_type: 1, item_id: 1 });

// 添加索引按照标签和用户ID
userFavoriteSchema.index({ user_id: 1, tags: 1 });

// 添加虚拟字段
userFavoriteSchema.virtual('favorite_age').get(function() {
  return Math.floor((Date.now() - this.created_at) / (1000 * 60 * 60 * 24));
});

userFavoriteSchema.virtual('item_details', {
  refPath: 'item_type_ref',
  localField: 'item_id',
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
    user_id: userId,
    item_type: itemType,
    item_id: itemId
  });
  return count > 0;
};

// 静态方法：获取用户收藏列表
userFavoriteSchema.statics.getUserFavorites = async function(userId, options = {}) {
  const { 
    itemType = null, 
    tags = null, 
    sort = { created_at: -1 }, 
    limit = 20, 
    skip = 0,
    populate = true 
  } = options;
  
  const query = { user_id: userId };
  
  if (itemType) {
    query.item_type = itemType;
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
      path: 'item_details',
      select: function(itemType) {
        switch(itemType) {
          case 'dish':
            return 'name price images nutrition_info merchant_id';
          case 'post':
            return 'title content created_at author tags';
          case 'nutritionist':
            return 'username full_name profile_image qualifications.specializations';
          case 'store':
            return 'name address business_hours merchant_id average_rating';
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
    user_id: userId,
    item_type: itemType,
    item_id: itemId
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
    user_id: userId,
    item_type: itemType,
    item_id: itemId,
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
        user_id: userId,
        item_type: item.itemType,
        item_id: item.itemId
      });
      
      if (existing) {
        results.duplicates.push({
          item_type: item.itemType,
          item_id: item.itemId,
          message: '已收藏此项目'
        });
        continue;
      }
      
      // 创建新收藏
      const favorite = new this({
        user_id: userId,
        item_type: item.itemType,
        item_id: item.itemId,
        notes: item.notes || '',
        tags: item.tags || []
      });
      
      await favorite.save();
      
      results.success.push({
        item_type: item.itemType,
        item_id: item.itemId,
        favorite_id: favorite._id
      });
    } catch (error) {
      results.failed.push({
        item_type: item.itemType,
        item_id: item.itemId,
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
    match.item_type = itemType;
  }
  
  // 如果指定时间段，添加时间条件
  if (period > 0) {
    const periodDate = new Date();
    periodDate.setDate(periodDate.getDate() - period);
    match.created_at = { $gte: periodDate };
  }
  
  const aggregation = [
    { $match: match },
    { 
      $group: { 
        _id: { item_type: '$item_type', item_id: '$item_id' },
        count: { $sum: 1 },
        first_favorited: { $min: '$created_at' },
        last_favorited: { $max: '$created_at' }
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
    const { item_type, item_id } = result._id;
    let itemDetails = null;
    
    // 查询项目详情
    try {
      let model;
      if (item_type === 'dish') {
        model = Dish;
      } else if (item_type === 'post') {
        model = ForumPost;
      } else if (item_type === 'nutritionist') {
        model = User;
      } else if (item_type === 'store') {
        model = Store;
      }
      
      if (model) {
        itemDetails = await model.findById(item_id);
      }
    } catch (error) {
      console.error(`Error fetching details for ${item_type} ${item_id}:`, error);
    }
    
    detailedResults.push({
      item_type,
      item_id,
      favorites_count: result.count,
      first_favorited: result.first_favorited,
      last_favorited: result.last_favorited,
      details: itemDetails
    });
  }
  
  return detailedResults;
};

// 移除不需要的中间件，由timestamps处理
userFavoriteSchema.pre('save', function(next) {
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const UserFavorite = ModelFactory.model('UserFavorite', userFavoriteSchema);

// 添加分片支持
UserFavorite.getShardKey = function(doc) {
  return doc.user_id.toString();
};

module.exports = UserFavorite; 