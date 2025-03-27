const mongoose = require('mongoose');
const ModelFactory = require('./modelFactory');
const { shardingService } = require('../services/shardingService');

// 导入所需的模型
const User = require('./userModel');
const Nutritionist = require('./nutritionistModel');
const NutritionProfile = require('./nutritionProfileModel');

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
}, {
  timestamps: { createdAt: 'created_at', updatedAt: 'updated_at' },
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
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

// 添加虚拟字段
consultationSchema.virtual('duration_minutes').get(function() {
  if (!this.start_time || !this.end_time) return 0;
  return Math.floor((this.end_time - this.start_time) / (1000 * 60));
});

consultationSchema.virtual('is_ongoing').get(function() {
  return this.status === 'in_progress';
});

consultationSchema.virtual('is_upcoming').get(function() {
  return this.status === 'scheduled' && 
         this.scheduled_time && 
         this.scheduled_time > new Date();
});

consultationSchema.virtual('is_past_due').get(function() {
  return this.status === 'scheduled' && 
         this.scheduled_time && 
         this.scheduled_time < new Date() &&
         !this.start_time;
});

consultationSchema.virtual('unread_message_count').get(function() {
  return this.messages.filter(msg => !msg.is_read).length;
});

// 用户信息的虚拟关联
consultationSchema.virtual('user', {
  ref: 'User',
  localField: 'user_id',
  foreignField: '_id',
  justOne: true
});

// 营养师信息的虚拟关联
consultationSchema.virtual('nutritionist', {
  ref: 'Nutritionist',
  localField: 'nutritionist_id',
  foreignField: '_id',
  justOne: true
});

// 实例方法：添加消息
consultationSchema.methods.addMessage = async function(senderType, senderId, content, options = {}) {
  const { messageType = 'text', mediaUrl = null } = options;
  
  this.messages.push({
    sender_type: senderType,
    sender_id: senderId,
    message_type: messageType,
    content: content,
    media_url: mediaUrl,
    sent_at: new Date(),
    is_read: false
  });
  
  // 如果状态是pending，自动更新为in_progress
  if (this.status === 'pending') {
    this.status = 'in_progress';
    this.start_time = new Date();
  }
  
  return await this.save();
};

// 实例方法：标记消息为已读
consultationSchema.methods.markMessagesAsRead = async function(receiverType, receiverId) {
  let hasUnread = false;
  
  this.messages.forEach(msg => {
    if (msg.sender_type !== receiverType && !msg.is_read) {
      msg.is_read = true;
      hasUnread = true;
    }
  });
  
  if (hasUnread) {
    return await this.save();
  }
  
  return this;
};

// 实例方法：完成咨询
consultationSchema.methods.complete = async function(feedback, recommendations, requiresFollowUp = false) {
  if (this.status !== 'in_progress') {
    throw new Error('只有正在进行中的咨询才能被标记为完成');
  }
  
  this.status = 'completed';
  this.end_time = new Date();
  this.professional_feedback = feedback;
  this.follow_up_recommendations = recommendations;
  this.requires_follow_up = requiresFollowUp;
  
  return await this.save();
};

// 实例方法：取消咨询
consultationSchema.methods.cancel = async function(cancellationReason) {
  if (['completed', 'cancelled'].includes(this.status)) {
    throw new Error('已完成或已取消的咨询无法被取消');
  }
  
  const wasInProgress = this.status === 'in_progress';
  
  this.status = 'cancelled';
  this.end_time = new Date();
  
  // 添加取消消息
  this.messages.push({
    sender_type: 'system',
    sender_id: mongoose.Types.ObjectId(),
    message_type: 'text',
    content: `咨询已取消。原因: ${cancellationReason || '无'}`,
    sent_at: new Date(),
    is_read: false
  });
  
  // 如果有支付，尝试处理退款（通过回调方式处理，避免循环依赖）
  const result = await this.save();
  
  // 触发取消事件，由外部处理退款
  if (global.eventEmitter) {
    global.eventEmitter.emit('consultation:cancelled', {
      consultationId: this._id,
      wasInProgress,
      paymentId: this.payment?.payment_id,
      status: this.payment?.status
    });
  }
  
  return result;
};

// 实例方法：提交评价
consultationSchema.methods.submitRating = async function(rating, comments) {
  if (this.status !== 'completed') {
    throw new Error('只有已完成的咨询才能被评价');
  }
  
  this.user_rating = {
    rating,
    comments,
    rated_at: new Date()
  };
  
  return await this.save();
};

// 实例方法：重新安排咨询时间
consultationSchema.methods.reschedule = async function(newScheduledTime) {
  if (['completed', 'cancelled', 'in_progress'].includes(this.status)) {
    throw new Error('已完成、正在进行或已取消的咨询无法重新安排时间');
  }
  
  // 记录原始安排的时间用于审计
  const originalTime = this.scheduled_time;
  this.scheduled_time = newScheduledTime;
  this.status = 'scheduled';
  
  // 添加系统消息
  this.messages.push({
    sender_type: 'system',
    sender_id: mongoose.Types.ObjectId(),
    message_type: 'text',
    content: `咨询时间已更改。原始时间: ${originalTime ? originalTime.toISOString() : '无'}, 新时间: ${newScheduledTime.toISOString()}`,
    sent_at: new Date(),
    is_read: false
  });
  
  return await this.save();
};

// 静态方法：获取可用的时间段
consultationSchema.statics.getAvailableTimeSlots = async function(nutritionistId, date) {
  // 获取指定日期的开始和结束时间
  const startOfDay = new Date(date);
  startOfDay.setHours(0, 0, 0, 0);
  
  const endOfDay = new Date(date);
  endOfDay.setHours(23, 59, 59, 999);
  
  // 查询营养师的工作时间
  const nutritionist = await Nutritionist.findById(nutritionistId);
  if (!nutritionist) throw new Error('未找到营养师');
  
  // 获取当天的星期几 (0-6, 从周日开始)
  const dayOfWeek = startOfDay.getDay();
  const dayNames = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
  const todaySchedule = nutritionist.availability[dayNames[dayOfWeek]];
  
  if (!todaySchedule || !todaySchedule.available) {
    return { available: false, message: '营养师今日不工作', time_slots: [] };
  }
  
  // 找到当天已经被预约的时间段
  const bookedConsultations = await this.find({
    nutritionist_id: nutritionistId,
    scheduled_time: { $gte: startOfDay, $lte: endOfDay },
    status: { $in: ['scheduled', 'in_progress'] }
  });
  
  const bookedTimeSlots = bookedConsultations.map(consultation => {
    const startTime = new Date(consultation.scheduled_time);
    const endTime = new Date(startTime);
    // 假设每次咨询为30分钟，可以从营养师配置中获取
    endTime.setMinutes(startTime.getMinutes() + 30);
    
    return {
      start: startTime,
      end: endTime
    };
  });
  
  // 生成当天的可用时间段
  const availableTimeSlots = [];
  
  if (todaySchedule.start_time && todaySchedule.end_time) {
    const [startHour, startMinute] = todaySchedule.start_time.split(':').map(Number);
    const [endHour, endMinute] = todaySchedule.end_time.split(':').map(Number);
    
    const workStart = new Date(startOfDay);
    workStart.setHours(startHour, startMinute, 0, 0);
    
    const workEnd = new Date(startOfDay);
    workEnd.setHours(endHour, endMinute, 0, 0);
    
    // 每30分钟创建一个时间段
    const slotDuration = 30; // 分钟
    let currentSlotStart = new Date(workStart);
    
    while (currentSlotStart < workEnd) {
      const currentSlotEnd = new Date(currentSlotStart);
      currentSlotEnd.setMinutes(currentSlotStart.getMinutes() + slotDuration);
      
      // 检查这个时间段是否与已预约时间冲突
      const isBooked = bookedTimeSlots.some(bookedSlot => {
        return (
          (currentSlotStart >= bookedSlot.start && currentSlotStart < bookedSlot.end) ||
          (currentSlotEnd > bookedSlot.start && currentSlotEnd <= bookedSlot.end) ||
          (currentSlotStart <= bookedSlot.start && currentSlotEnd >= bookedSlot.end)
        );
      });
      
      if (!isBooked) {
        availableTimeSlots.push({
          start: new Date(currentSlotStart),
          end: new Date(currentSlotEnd),
          formatted: `${currentSlotStart.getHours().toString().padStart(2, '0')}:${currentSlotStart.getMinutes().toString().padStart(2, '0')} - ${currentSlotEnd.getHours().toString().padStart(2, '0')}:${currentSlotEnd.getMinutes().toString().padStart(2, '0')}`
        });
      }
      
      // 移动到下一个时间段
      currentSlotStart.setMinutes(currentSlotStart.getMinutes() + slotDuration);
    }
  }
  
  return {
    available: availableTimeSlots.length > 0,
    message: availableTimeSlots.length > 0 ? '有可用的时间段' : '今日所有时间段已被预约',
    time_slots: availableTimeSlots
  };
};

// 静态方法：获取用户的咨询历史
consultationSchema.statics.getUserConsultationHistory = async function(userId, options = {}) {
  const { 
    status = null, 
    nutritionistId = null, 
    limit = 10, 
    skip = 0, 
    sort = { created_at: -1 } 
  } = options;
  
  const query = { user_id: userId };
  
  if (status) {
    query.status = status;
  }
  
  if (nutritionistId) {
    query.nutritionist_id = nutritionistId;
  }
  
  const total = await this.countDocuments(query);
  
  const consultations = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('nutritionist', 'username full_name profile_image qualifications')
    .populate('ai_recommendation_id');
  
  return {
    consultations,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 静态方法：获取营养师的咨询日程
consultationSchema.statics.getNutritionistSchedule = async function(nutritionistId, startDate, endDate) {
  const query = {
    nutritionist_id: nutritionistId,
    status: { $in: ['scheduled', 'in_progress'] }
  };
  
  if (startDate || endDate) {
    query.scheduled_time = {};
    if (startDate) query.scheduled_time.$gte = new Date(startDate);
    if (endDate) query.scheduled_time.$lte = new Date(endDate);
  }
  
  return await this.find(query)
    .sort({ scheduled_time: 1 })
    .populate('user', 'username full_name profile_image');
};

// 静态方法：创建咨询会话
consultationSchema.statics.createConsultation = async function(userId, nutritionistId, options = {}) {
  const { 
    scheduledTime, 
    consultationType = 'text',
    topic = '一般营养咨询',
    aiRecommendationId = null,
    paymentInfo = null
  } = options;
  
  // 检查营养师是否存在
  const nutritionist = await Nutritionist.findById(nutritionistId);
  if (!nutritionist) throw new Error('未找到营养师');
  
  // 检查用户是否存在
  const user = await User.findById(userId);
  if (!user) throw new Error('未找到用户');
  
  // 创建咨询记录
  const consultation = new this({
    user_id: userId,
    nutritionist_id: nutritionistId,
    consultation_type: consultationType,
    status: scheduledTime ? 'scheduled' : 'pending',
    scheduled_time: scheduledTime,
    topic,
    ai_recommendation_id: aiRecommendationId,
    messages: [{
      sender_type: 'system',
      sender_id: mongoose.Types.ObjectId(),
      message_type: 'text',
      content: `咨询已创建。类型: ${consultationType}${scheduledTime ? `, 预约时间: ${scheduledTime.toISOString()}` : ''}`,
      sent_at: new Date(),
      is_read: false
    }]
  });
  
  // 如果提供了支付信息
  if (paymentInfo) {
    consultation.payment = {
      amount: paymentInfo.amount,
      status: paymentInfo.status || 'pending',
      payment_id: paymentInfo.payment_id
    };
  }
  
  await consultation.save();
  
  // 触发咨询创建事件
  if (global.eventEmitter) {
    global.eventEmitter.emit('consultation:created', {
      consultationId: consultation._id,
      userId,
      nutritionistId,
      scheduledTime,
      consultationType
    });
  }
  
  return consultation;
};

// 静态方法：获取热门咨询主题
consultationSchema.statics.getPopularTopics = async function(limit = 10) {
  return this.aggregate([
    { $match: { status: 'completed' } },
    { $group: { 
      _id: '$topic', 
      count: { $sum: 1 },
      avg_rating: { $avg: '$user_rating.rating' }
    }},
    { $match: { count: { $gte: 3 } } }, // 至少有3次咨询
    { $sort: { count: -1 } },
    { $limit: limit }
  ]);
};

// 静态方法：根据用户健康数据推荐营养师
consultationSchema.statics.recommendNutritionists = async function(userId, healthData) {
  // 这个方法需要实现一个推荐算法，基于用户的健康数据和营养师的专业领域
  // 简单示例：根据用户的健康目标和营养师的专业领域匹配
  
  const user = await User.findById(userId);
  if (!user) throw new Error('未找到用户');
  
  const userHealthProfile = healthData || 
    await NutritionProfile.findOne({ user_id: userId });
  
  if (!userHealthProfile) {
    // 如果没有健康数据，返回评分最高的营养师
    return await Nutritionist
      .find({})
      .sort({ 'ratings.average_rating': -1 })
      .limit(3);
  }
  
  // 从用户健康档案中提取关键健康目标和需求
  const healthGoals = userHealthProfile.health_goals || [];
  const dietaryPreferences = userHealthProfile.dietary_preferences || [];
  const healthConditions = userHealthProfile.health_conditions || [];
  
  // 构建查询条件，匹配专业领域
  const matchQuery = {
    'professional_info.specializations': { 
      $in: [...healthGoals, ...dietaryPreferences, ...healthConditions]
    }
  };
  
  // 查询匹配的营养师
  const matchedNutritionists = await Nutritionist
    .find(matchQuery)
    .sort({ 'ratings.average_rating': -1 })
    .limit(5);
  
  if (matchedNutritionists.length === 0) {
    // 如果没有精确匹配，返回评分最高的营养师
    return await Nutritionist
      .find({})
      .sort({ 'ratings.average_rating': -1 })
      .limit(3);
  }
  
  return matchedNutritionists;
};

// 移除不需要的中间件，由timestamps处理
consultationSchema.pre('save', function(next) {
  // 增强的保存前钩子
  // 如果状态变为completed，自动设置end_time（如果尚未设置）
  if (this.status === 'completed' && !this.end_time) {
    this.end_time = new Date();
  }
  
  // 如果状态变为in_progress，自动设置start_time（如果尚未设置）
  if (this.status === 'in_progress' && !this.start_time) {
    this.start_time = new Date();
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Consultation = ModelFactory.model('Consultation', consultationSchema);

// 添加分片支持
Consultation.getShardKey = function(doc) {
  // 三个月前的记录按时间分片
  if (doc.created_at && doc.created_at.getTime() < Date.now() - (90 * 24 * 60 * 60 * 1000)) {
    const date = doc.created_at;
    return `archive-${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
  }
  
  // 新记录按用户分片
  return doc.user_id.toString();
};

// 获取营养师详情
const getNutritionistDetails = async (nutritionistId) => {
  try {
    const nutritionist = await Nutritionist.findById(nutritionistId);
    // ... existing code ...
  } catch (error) {
    // ... existing code ...
  }
};

// 检查用户是否有足够的健康数据
const checkUserHealthDataCompleteness = async (userId) => {
  try {
    const user = await User.findById(userId);
    const nutritionProfile = await NutritionProfile.findOne({ user_id: userId });
    // ... existing code ...
  } catch (error) {
    // ... existing code ...
  }
};

// 根据专业领域查找匹配的营养师
const findMatchingNutritionists = async (healthConcerns, specialPreferences) => {
  try {
    // 查找匹配的营养师
    const matchedNutritionists = await Nutritionist.find({
      // ... existing code ...
    });
    // ... existing code ...
  } catch (error) {
    // ... existing code ...
  }
};

module.exports = Consultation; 