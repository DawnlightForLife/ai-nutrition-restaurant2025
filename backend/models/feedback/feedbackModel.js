// backend/models/misc/feedbackModel.js
const mongoose = require('mongoose');

const feedbackSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '反馈提交的用户 ID',
    sensitivityLevel: 2
  },
  feedbackType: {
    type: String,
    enum: ['recommendation', 'forumReport', 'consultationRating', 'system'],
    required: true,
    description: '反馈类型'
  },
  targetId: {
    type: mongoose.Schema.Types.ObjectId,
    description: '相关对象 ID（如推荐、帖子、咨询）',
    // 未来可扩展字段
    // description: '相关对象 ID（如推荐、帖子、咨询）'
  },
  content: {
    type: String,
    required: true,
    maxlength: 1000,
    description: '反馈内容',
    sensitivityLevel: 2
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    description: '评分（可选）'
  },
  status: {
    type: String,
    enum: ['pending', 'reviewed', 'resolved'],
    default: 'pending',
    description: '反馈处理状态'
  },
  reviewedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Admin',
    description: '处理反馈的管理员 ID'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Feedback', feedbackSchema);