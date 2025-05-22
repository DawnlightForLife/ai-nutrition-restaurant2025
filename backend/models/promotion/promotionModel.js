const mongoose = require('mongoose');

const promotionSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true,
    description: '活动标题',
    sensitivityLevel: 2
  },
  content: {
    type: String,
    required: true,
    description: '活动内容 HTML 或 Markdown',
    sensitivityLevel: 2
  },
  bannerImageUrl: {
    type: String,
    description: '活动展示图 URL',
    sensitivityLevel: 2
  },
  validFrom: {
    type: Date,
    required: true,
    description: '活动开始时间'
  },
  validUntil: {
    type: Date,
    required: true,
    description: '活动结束时间'
  },
  isActive: {
    type: Boolean,
    default: true,
    description: '是否在首页展示'
  },
  tags: [{
    type: String,
    description: '活动标签（如 每日推荐、新品特惠）',
    sensitivityLevel: 3
  }],
  promotionType: {
    type: String,
    enum: ['discount', 'announcement', 'limitedTime', 'event'],
    default: 'announcement',
    description: '活动类型（如 折扣、公告、限时、线下活动等）'
  },
  targetAudience: {
    type: [String],
    default: ['all'],
    description: '目标受众（如 all, newUsers, merchants, nutritionists）'
  },
  priority: {
    type: Number,
    default: 5,
    min: 1,
    max: 10,
    description: '活动优先级（用于首页展示排序）'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Promotion', promotionSchema);