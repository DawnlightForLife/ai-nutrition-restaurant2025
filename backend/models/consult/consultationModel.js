const mongoose = require('mongoose');
const ModelFactory = require('../modelFactory');
const { shardingService } = require('../../services/database/shardingService');

// 导入所需的模型
const User = require('../../models/user/userModel');
const Nutritionist = require('../nutrition/nutritionistModel');
const NutritionProfile = require('../nutrition/nutritionProfileModel');

const consultationSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '发起咨询的用户ID',
    sensitivityLevel: 2
  },
  nutritionistId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist',
    required: true,
    description: '被咨询的营养师ID',
    sensitivityLevel: 2
  },
  // 咨询类型
  consultationType: {
    type: String,
    enum: ['text', 'voice', 'video', 'inPerson'],
    default: 'text',
    description: '咨询类型（文字、语音、视频、面对面）'
  },
  // 咨询状态
  status: {
    type: String,
    enum: ['pending', 'available', 'assigned', 'scheduled', 'inProgress', 'completed', 'cancelled'],
    default: 'pending',
    description: '咨询状态'
  },
  // 预约时间
  scheduledTime: {
    type: Date,
    description: '预约的咨询时间'
  },
  // 实际开始时间
  startTime: {
    type: Date,
    description: '实际开始咨询时间'
  },
  // 实际结束时间
  endTime: {
    type: Date,
    description: '实际结束咨询时间'
  },
  // 咨询主题
  topic: {
    type: String,
    description: '咨询主题'
  },
  // 咨询描述
  description: {
    type: String,
    description: '详细咨询描述',
    sensitivityLevel: 2
  },
  // 优先级
  priority: {
    type: String,
    enum: ['low', 'normal', 'high', 'urgent'],
    default: 'normal',
    description: '咨询优先级'
  },
  // 标签
  tags: [{
    type: String,
    description: '咨询相关标签'
  }],
  // 期望时长（分钟）
  expectedDuration: {
    type: Number,
    default: 30,
    description: '期望咨询时长（分钟）'
  },
  // 预算（用于市场筛选）
  budget: {
    type: Number,
    description: '用户预算范围',
    sensitivityLevel: 2
  },
  // 是否对市场开放
  isMarketOpen: {
    type: Boolean,
    default: false,
    description: '是否对营养师市场开放'
  },
  // 市场发布时间
  marketPublishedAt: {
    type: Date,
    description: '发布到市场的时间'
  },
  // 分配的营养师（对于市场咨询）
  assignedNutritionistId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Nutritionist',
    description: '从市场分配的营养师ID'
  },
  // 分配时间
  assignedAt: {
    type: Date,
    description: '营养师接受咨询的时间'
  },
  // 咨询内容记录
  messages: [{
    senderType: {
      type: String,
      enum: ['user', 'nutritionist'],
      required: true,
      description: '发送者类型'
    },
    senderId: {
      type: mongoose.Schema.Types.ObjectId,
      required: true,
      description: '发送者ID'
    },
    messageType: {
      type: String,
      enum: ['text', 'image', 'document', 'audio'],
      default: 'text',
      description: '消息类型'
    },
    content: {
      type: String,
      required: true,
      description: '消息内容',
      sensitivityLevel: 2
    },
    mediaUrl: {
      type: String,
      description: '媒体文件URL',
      sensitivityLevel: 2
    },
    sentAt: {
      type: Date,
      default: Date.now,
      description: '发送时间'
    },
    isRead: {
      type: Boolean,
      default: false,
      description: '是否已读'
    }
  }],
  // 相关AI推荐
  aiRecommendationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'AiRecommendation',
    description: '关联的AI推荐ID',
    sensitivityLevel: 2
  },
  // 营养师的专业反馈
  professionalFeedback: {
    type: String,
    description: '营养师的专业反馈',
    sensitivityLevel: 2
  },
  // 后续建议
  followUpRecommendations: {
    type: String,
    description: '后续建议和推荐',
    sensitivityLevel: 2
  },
  // 是否需要后续咨询
  requiresFollowUp: {
    type: Boolean,
    default: false,
    description: '是否需要后续咨询'
  },
  // 用户评价
  userRating: {
    rating: {
      type: Number,
      min: 1,
      max: 5,
      description: '评分(1-5)'
    },
    comments: {
      type: String,
      description: '评价内容'
    },
    ratedAt: {
      type: Date,
      description: '评价时间'
    }
  },
  // 费用信息
  payment: {
    amount: {
      type: Number,
      default: 0,
      description: '咨询费用金额',
      sensitivityLevel: 2
    },
    status: {
      type: String,
      enum: ['pending', 'paid', 'refunded', 'free'],
      default: 'free',
      description: '支付状态'
    },
    paymentId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Payment',
      description: '支付记录ID',
      sensitivityLevel: 2
    }
  },
  // 敏感度级别，标记用于数据保护
  sensitivityLevel: {
    type: Number,
    default: 2, // 默认为中度敏感
    enum: [1, 2, 3], // 1: 高度敏感, 2: 中度敏感, 3: 低度敏感
    description: '数据敏感度级别：1高度、2中度、3低度'
  }
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// 创建索引用于快速查找咨询记录
consultationSchema.index({ userId: 1, createdAt: -1 });
consultationSchema.index({ nutritionistId: 1, createdAt: -1 });
consultationSchema.index({ status: 1 });
// 添加排期索引，便于查询特定时间段的咨询
consultationSchema.index({ scheduledTime: 1, status: 1 });
// 添加按评分索引，便于查询高评分咨询
consultationSchema.index({ 'userRating.rating': -1 });
// 添加按咨询类型索引，便于统计不同类型咨询
consultationSchema.index({ consultationType: 1, status: 1 });
// 添加用户和营养师复合索引，便于查询特定用户和营养师之间的咨询历史
consultationSchema.index({ userId: 1, nutritionistId: 1, createdAt: -1 });
// 添加市场相关索引
consultationSchema.index({ isMarketOpen: 1, status: 1, marketPublishedAt: -1 });
consultationSchema.index({ priority: 1, createdAt: -1 });
consultationSchema.index({ tags: 1 });
consultationSchema.index({ budget: 1 });
consultationSchema.index({ assignedNutritionistId: 1, assignedAt: -1 });

// 添加虚拟字段
consultationSchema.virtual('durationMinutes').get(function() {
  if (!this.startTime || !this.endTime) return 0;
  return Math.floor((this.endTime - this.startTime) / (1000 * 60));
});

consultationSchema.virtual('isOngoing').get(function() {
  return this.status === 'inProgress';
});

consultationSchema.virtual('isUpcoming').get(function() {
  return this.status === 'scheduled' && 
         this.scheduledTime && 
         this.scheduledTime > new Date();
});

consultationSchema.virtual('isPastDue').get(function() {
  return this.status === 'scheduled' && 
         this.scheduledTime && 
         this.scheduledTime < new Date() &&
         !this.startTime;
});

consultationSchema.virtual('unreadMessageCount').get(function() {
  return this.messages.filter(msg => !msg.isRead).length;
});

// 用户信息的虚拟关联
consultationSchema.virtual('user', {
  ref: 'User',
  localField: 'userId',
  foreignField: '_id',
  justOne: true
});

// 营养师信息的虚拟关联
consultationSchema.virtual('nutritionist', {
  ref: 'Nutritionist',
  localField: 'nutritionistId',
  foreignField: '_id',
  justOne: true
});

// 实例方法：添加消息
consultationSchema.methods.addMessage = async function(senderType, senderId, content, options = {}) {
  const { messageType = 'text', mediaUrl = null } = options;
  
  this.messages.push({
    senderType: senderType,
    senderId: senderId,
    messageType: messageType,
    content: content,
    mediaUrl: mediaUrl,
    sentAt: new Date(),
    isRead: false
  });
  
  // 如果状态是pending，自动更新为inProgress
  if (this.status === 'pending') {
    this.status = 'inProgress';
    this.startTime = new Date();
  }
  
  return await this.save();
};

// 实例方法：标记消息为已读
consultationSchema.methods.markMessagesAsRead = async function(receiverType, receiverId) {
  let hasUnread = false;
  
  this.messages.forEach(msg => {
    if (msg.senderType !== receiverType && !msg.isRead) {
      msg.isRead = true;
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
  if (this.status !== 'inProgress') {
    throw new Error('只有正在进行中的咨询才能被标记为完成');
  }
  
  this.status = 'completed';
  this.endTime = new Date();
  this.professionalFeedback = feedback;
  this.followUpRecommendations = recommendations;
  this.requiresFollowUp = requiresFollowUp;
  
  return await this.save();
};

// 实例方法：取消咨询
consultationSchema.methods.cancel = async function(cancellationReason) {
  if (['completed', 'cancelled'].includes(this.status)) {
    throw new Error('已完成或已取消的咨询无法被取消');
  }
  
  const wasInProgress = this.status === 'inProgress';
  
  this.status = 'cancelled';
  this.endTime = new Date();
  
  // 添加取消消息
  this.messages.push({
    senderType: 'system',
    senderId: mongoose.Types.ObjectId(),
    messageType: 'text',
    content: `咨询已取消。原因: ${cancellationReason || '无'}`,
    sentAt: new Date(),
    isRead: false
  });
  
  // 如果有支付，尝试处理退款（通过回调方式处理，避免循环依赖）
  const result = await this.save();
  
  // 触发取消事件，由外部处理退款
  if (global.eventEmitter) {
    global.eventEmitter.emit('consultation:cancelled', {
      consultationId: this._id,
      wasInProgress,
      paymentId: this.payment?.paymentId,
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
  
  this.userRating = {
    rating,
    comments,
    ratedAt: new Date()
  };
  
  return await this.save();
};

// 实例方法：重新安排咨询时间
consultationSchema.methods.reschedule = async function(newScheduledTime) {
  if (['completed', 'cancelled', 'inProgress'].includes(this.status)) {
    throw new Error('已完成、正在进行或已取消的咨询无法重新安排时间');
  }
  
  // 记录原始安排的时间用于审计
  const originalTime = this.scheduledTime;
  this.scheduledTime = newScheduledTime;
  this.status = 'scheduled';
  
  // 添加系统消息
  this.messages.push({
    senderType: 'system',
    senderId: mongoose.Types.ObjectId(),
    messageType: 'text',
    content: `咨询时间已更改。原始时间: ${originalTime ? originalTime.toISOString() : '无'}, 新时间: ${newScheduledTime.toISOString()}`,
    sentAt: new Date(),
    isRead: false
  });
  
  return await this.save();
};

// 实例方法：发布到市场
consultationSchema.methods.publishToMarket = async function() {
  if (this.status !== 'pending') {
    throw new Error('只有等待中的咨询才能发布到市场');
  }
  
  this.isMarketOpen = true;
  this.status = 'available';
  this.marketPublishedAt = new Date();
  
  return await this.save();
};

// 实例方法：营养师接受咨询
consultationSchema.methods.acceptByNutritionist = async function(nutritionistId) {
  if (this.status !== 'available') {
    throw new Error('只有在市场中可用的咨询才能被接受');
  }
  
  this.assignedNutritionistId = nutritionistId;
  this.nutritionistId = nutritionistId; // 更新主要营养师ID
  this.status = 'assigned';
  this.assignedAt = new Date();
  this.isMarketOpen = false; // 从市场中移除
  
  return await this.save();
};

// 实例方法：检查是否匹配营养师专业领域
consultationSchema.methods.matchesNutritionistSpecialty = function(nutritionistSpecializations) {
  if (!this.tags || this.tags.length === 0) return true; // 无特殊要求
  
  const commonTags = this.tags.filter(tag => 
    nutritionistSpecializations.some(spec => 
      spec.toLowerCase().includes(tag.toLowerCase()) ||
      tag.toLowerCase().includes(spec.toLowerCase())
    )
  );
  
  return commonTags.length > 0;
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
    return { available: false, message: '营养师今日不工作', timeSlots: [] };
  }
  
  // 找到当天已经被预约的时间段
  const bookedConsultations = await this.find({
    nutritionistId: nutritionistId,
    scheduledTime: { $gte: startOfDay, $lte: endOfDay },
    status: { $in: ['scheduled', 'inProgress'] }
  });
  
  const bookedTimeSlots = bookedConsultations.map(consultation => {
    const startTime = new Date(consultation.scheduledTime);
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
  
  if (todaySchedule.startTime && todaySchedule.endTime) {
    const [startHour, startMinute] = todaySchedule.startTime.split(':').map(Number);
    const [endHour, endMinute] = todaySchedule.endTime.split(':').map(Number);
    
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
    timeSlots: availableTimeSlots
  };
};

// 静态方法：获取用户的咨询历史
consultationSchema.statics.getUserConsultationHistory = async function(userId, options = {}) {
  const { 
    status = null, 
    nutritionistId = null, 
    limit = 10, 
    skip = 0, 
    sort = { createdAt: -1 } 
  } = options;
  
  const query = { userId: userId };
  
  if (status) {
    query.status = status;
  }
  
  if (nutritionistId) {
    query.nutritionistId = nutritionistId;
  }
  
  const total = await this.countDocuments(query);
  
  const consultations = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('nutritionist', 'username fullName profileImage qualifications')
    .populate('aiRecommendationId');
  
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
    nutritionistId: nutritionistId,
    status: { $in: ['scheduled', 'inProgress'] }
  };
  
  if (startDate || endDate) {
    query.scheduledTime = {};
    if (startDate) query.scheduledTime.$gte = new Date(startDate);
    if (endDate) query.scheduledTime.$lte = new Date(endDate);
  }
  
  return await this.find(query)
    .sort({ scheduledTime: 1 })
    .populate('user', 'username fullName profileImage');
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
    userId: userId,
    nutritionistId: nutritionistId,
    consultationType: consultationType,
    status: scheduledTime ? 'scheduled' : 'pending',
    scheduledTime: scheduledTime,
    topic,
    aiRecommendationId: aiRecommendationId,
    messages: [{
      senderType: 'system',
      senderId: mongoose.Types.ObjectId(),
      messageType: 'text',
      content: `咨询已创建。类型: ${consultationType}${scheduledTime ? `, 预约时间: ${scheduledTime.toISOString()}` : ''}`,
      sentAt: new Date(),
      isRead: false
    }]
  });
  
  // 如果提供了支付信息
  if (paymentInfo) {
    consultation.payment = {
      amount: paymentInfo.amount,
      status: paymentInfo.status || 'pending',
      paymentId: paymentInfo.paymentId
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
      avgRating: { $avg: '$userRating.rating' }
    }},
    { $match: { count: { $gte: 3 } } }, // 至少有3次咨询
    { $sort: { count: -1 } },
    { $limit: limit }
  ]);
};

// 静态方法：根据用户健康数据推荐营养师
consultationSchema.statics.recommendNutritionists = async function(userId, nutritionProfile) {
  // 这个方法需要实现一个推荐算法，基于用户的健康数据和营养师的专业领域
  // 简单示例：根据用户的健康目标和营养师的专业领域匹配
  
  const user = await User.findById(userId);
  if (!user) throw new Error('未找到用户');
  
  const userNutritionProfile = nutritionProfile || 
    await NutritionProfile.findOne({ userId: userId });
  
  if (!userNutritionProfile) {
    // 如果没有健康数据，返回评分最高的营养师
    return await Nutritionist
      .find({})
      .sort({ 'ratings.averageRating': -1 })
      .limit(3);
  }
  
  // 从用户健康档案中提取关键健康目标和需求
  const nutritionGoals = userNutritionProfile.nutritionGoals || [];
  const dietaryPreferences = userNutritionProfile.dietaryPreferences || [];
  const nutritionConditions = userNutritionProfile.nutritionConditions || [];
  
  // 构建查询条件，匹配专业领域
  const matchQuery = {
    'professionalInfo.specializations': { 
      $in: [...nutritionGoals, ...dietaryPreferences, ...nutritionConditions]
    }
  };
  
  // 查询匹配的营养师
  const matchedNutritionists = await Nutritionist
    .find(matchQuery)
    .sort({ 'ratings.averageRating': -1 })
    .limit(5);
  
  if (matchedNutritionists.length === 0) {
    // 如果没有精确匹配，返回评分最高的营养师
    return await Nutritionist
      .find({})
      .sort({ 'ratings.averageRating': -1 })
      .limit(3);
  }
  
  return matchedNutritionists;
};

// Pre-save钩子
consultationSchema.pre('save', function(next) {
  // 增强的保存前钩子
  // 如果状态变为completed，自动设置endTime（如果尚未设置）
  if (this.status === 'completed' && !this.endTime) {
    this.endTime = new Date();
  }
  
  // 如果状态变为inProgress，自动设置startTime（如果尚未设置）
  if (this.status === 'inProgress' && !this.startTime) {
    this.startTime = new Date();
  }
  
  next();
});

// 使用ModelFactory创建支持读写分离的模型
const Consultation = ModelFactory.createModel('Consultation', consultationSchema);

// 添加分片支持
Consultation.getShardKey = function(doc) {
  // 三个月前的记录按时间分片
  if (doc.createdAt && doc.createdAt.getTime() < Date.now() - (90 * 24 * 60 * 60 * 1000)) {
    const date = doc.createdAt;
    return `archive-${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}`;
  }
  
  // 新记录按用户分片
  return doc.userId.toString();
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
const checkUserNutritionDataCompleteness = async (userId) => {
  try {
    const user = await User.findById(userId);
    const nutritionProfile = await NutritionProfile.findOne({ userId: userId });
    // ... existing code ...
  } catch (error) {
    // ... existing code ...
  }
};

// 根据专业领域查找匹配的营养师
const findMatchingNutritionists = async (nutritionConcerns, specialPreferences) => {
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

// 静态方法：获取市场中的可用咨询
consultationSchema.statics.getMarketConsultations = async function(options = {}) {
  const {
    nutritionistSpecializations = [],
    consultationType = null,
    priority = null,
    tags = [],
    minBudget = null,
    maxBudget = null,
    limit = 20,
    skip = 0,
    sort = { priority: -1, marketPublishedAt: -1 }
  } = options;

  const query = {
    isMarketOpen: true,
    status: 'available'
  };

  // 咨询类型筛选
  if (consultationType) {
    query.consultationType = consultationType;
  }

  // 优先级筛选
  if (priority) {
    query.priority = priority;
  }

  // 标签筛选
  if (tags.length > 0) {
    query.tags = { $in: tags };
  }

  // 预算筛选
  if (minBudget !== null || maxBudget !== null) {
    query.budget = {};
    if (minBudget !== null) query.budget.$gte = minBudget;
    if (maxBudget !== null) query.budget.$lte = maxBudget;
  }

  const consultations = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('userId', 'username nickname avatar gender age')
    .populate('assignedNutritionistId', 'personalInfo professionalInfo');

  // 如果指定了营养师专业领域，进行匹配度筛选
  let filteredConsultations = consultations;
  if (nutritionistSpecializations.length > 0) {
    filteredConsultations = consultations.filter(consultation => 
      consultation.matchesNutritionistSpecialty(nutritionistSpecializations)
    );
  }

  const total = await this.countDocuments(query);

  return {
    consultations: filteredConsultations,
    pagination: {
      total,
      limit,
      skip,
      hasMore: total > skip + limit
    }
  };
};

// 静态方法：获取营养师接受的咨询列表
consultationSchema.statics.getNutritionistAcceptedConsultations = async function(nutritionistId, options = {}) {
  const {
    status = null,
    limit = 10,
    skip = 0,
    sort = { assignedAt: -1 }
  } = options;

  const query = {
    assignedNutritionistId: nutritionistId
  };

  if (status) {
    query.status = status;
  }

  const consultations = await this.find(query)
    .sort(sort)
    .skip(skip)
    .limit(limit)
    .populate('userId', 'username nickname avatar gender age')
    .populate('nutritionistId', 'personalInfo professionalInfo');

  const total = await this.countDocuments(query);

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

// 静态方法：统计市场咨询数据
consultationSchema.statics.getMarketStats = async function() {
  const stats = await this.aggregate([
    {
      $match: {
        isMarketOpen: true,
        status: 'available'
      }
    },
    {
      $group: {
        _id: null,
        totalAvailable: { $sum: 1 },
        urgentCount: {
          $sum: { $cond: [{ $eq: ['$priority', 'urgent'] }, 1, 0] }
        },
        highPriorityCount: {
          $sum: { $cond: [{ $eq: ['$priority', 'high'] }, 1, 0] }
        },
        averageBudget: { $avg: '$budget' },
        consultationTypes: { $push: '$consultationType' }
      }
    },
    {
      $project: {
        _id: 0,
        totalAvailable: 1,
        urgentCount: 1,
        highPriorityCount: 1,
        averageBudget: { $round: ['$averageBudget', 2] },
        consultationTypes: 1
      }
    }
  ]);

  return stats[0] || {
    totalAvailable: 0,
    urgentCount: 0,
    highPriorityCount: 0,
    averageBudget: 0,
    consultationTypes: []
  };
};

module.exports = Consultation; 