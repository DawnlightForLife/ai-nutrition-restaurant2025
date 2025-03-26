const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

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
});

// 创建复合索引确保用户对同一项目只有一条收藏记录
userFavoriteSchema.index({ user_id: 1, item_type: 1, item_id: 1 }, { unique: true });
// 按照用户ID和创建时间建立索引，便于查询用户收藏列表
userFavoriteSchema.index({ user_id: 1, created_at: -1 });
// 按照内容类型和ID建立索引，便于统计某个内容的收藏数
userFavoriteSchema.index({ item_type: 1, item_id: 1 });

// 更新前自动更新时间
userFavoriteSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const UserFavorite = ModelFactory.model('UserFavorite', userFavoriteSchema);

// 添加分片支持的保存方法
const originalSave = UserFavorite.prototype.save;
UserFavorite.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.UserFavorite) {
    // 应用用户分片策略，使用user_id作为分片键
    const shardKey = this.user_id.toString();
    const shardCollection = shardingService.getShardName('UserFavorite', shardKey);
    console.log(`将用户收藏保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = UserFavorite; 