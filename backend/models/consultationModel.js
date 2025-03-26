const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

const consultationSchema = new mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  nutritionist_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist',
    required: true
  },
  // 咨询类型
  consultation_type: {
    type: String,
    enum: ['text', 'voice', 'video', 'in_person'],
    default: 'text'
  },
  // 咨询状态
  status: {
    type: String,
    enum: ['pending', 'scheduled', 'in_progress', 'completed', 'cancelled'],
    default: 'pending'
  },
  // 预约时间
  scheduled_time: {
    type: Date
  },
  // 实际开始时间
  start_time: {
    type: Date
  },
  // 实际结束时间
  end_time: {
    type: Date
  },
  // 咨询主题
  topic: {
    type: String
  },
  // 咨询内容记录
  messages: [{
    sender_type: {
      type: String,
      enum: ['user', 'nutritionist'],
      required: true
    },
    sender_id: {
      type: mongoose.Schema.Types.ObjectId,
      required: true
    },
    message_type: {
      type: String,
      enum: ['text', 'image', 'document', 'audio'],
      default: 'text'
    },
    content: {
      type: String,
      required: true
    },
    media_url: {
      type: String
    },
    sent_at: {
      type: Date,
      default: Date.now
    },
    is_read: {
      type: Boolean,
      default: false
    }
  }],
  // 相关AI推荐
  ai_recommendation_id: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation'
  },
  // 营养师的专业反馈
  professional_feedback: {
    type: String
  },
  // 后续建议
  follow_up_recommendations: {
    type: String
  },
  // 是否需要后续咨询
  requires_follow_up: {
    type: Boolean,
    default: false
  },
  // 用户评价
  user_rating: {
    rating: {
      type: Number,
      min: 1,
      max: 5
    },
    comments: {
      type: String
    },
    rated_at: {
      type: Date
    }
  },
  // 费用信息
  payment: {
    amount: {
      type: Number,
      default: 0
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'refunded', 'free'],
      default: 'free'
    },
    payment_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Payment'
    }
  },
  created_at: {
    type: Date,
    default: Date.now
  },
  updated_at: {
    type: Date,
    default: Date.now
  },
  // 敏感度级别，标记用于数据保护
  sensitivity_level: {
    type: Number,
    default: 2, // 默认为中度敏感
    enum: [1, 2, 3] // 1: 高度敏感, 2: 中度敏感, 3: 低度敏感
  }
});

// 创建索引用于快速查找咨询记录
consultationSchema.index({ user_id: 1, created_at: -1 });
consultationSchema.index({ nutritionist_id: 1, created_at: -1 });
consultationSchema.index({ status: 1 });
// 添加排期索引，便于查询特定时间段的咨询
consultationSchema.index({ scheduled_time: 1, status: 1 });
// 添加按评分索引，便于查询高评分咨询
consultationSchema.index({ 'user_rating.rating': -1 });
// 添加按咨询类型索引，便于统计不同类型咨询
consultationSchema.index({ consultation_type: 1, status: 1 });
// 添加用户和营养师复合索引，便于查询特定用户和营养师之间的咨询历史
consultationSchema.index({ user_id: 1, nutritionist_id: 1, created_at: -1 });

// 更新前自动更新时间
consultationSchema.pre('save', function(next) {
  this.updated_at = Date.now();
  next();
});

/**
 * 获取咨询记录的敏感级别
 * 由于咨询涉及营养健康信息，大部分属于中度敏感数据
 */
consultationSchema.methods.getSensitivityLevel = function() {
  // 检查是否包含高敏感信息
  const hasHighSensitiveContent = this.messages.some(msg => 
    msg.content.includes('病历') || 
    msg.content.includes('疾病') || 
    msg.content.includes('过敏') ||
    msg.content.includes('药物')
  );
  
  return hasHighSensitiveContent ? 1 : this.sensitivity_level;
};

// 使用ModelFactory创建支持读写分离的模型
const Consultation = ModelFactory.model('Consultation', consultationSchema);

// 添加分片支持的保存方法
const originalSave = Consultation.prototype.save;
Consultation.prototype.save = async function(options) {
  if (shardingService.config && shardingService.config.enabled && 
      shardingService.config.strategies.Consultation) {
    // 使用用户ID作为分片键，确保同一用户的咨询记录在同一分片
    // 或者使用时间进行分片，便于历史记录存档
    const shardKey = this.created_at && 
                   this.created_at.getTime() < Date.now() - (90 * 24 * 60 * 60 * 1000) ?
                   this.created_at : // 三个月前的记录按时间分片
                   this.user_id.toString(); // 新记录按用户分片
    
    const shardCollection = shardingService.getShardName('Consultation', shardKey);
    console.log(`将咨询记录保存到分片: ${shardCollection}`);
  }
  return originalSave.call(this, options);
};

module.exports = Consultation; 