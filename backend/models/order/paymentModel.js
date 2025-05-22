// backend/models/order/paymentModel.js
const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
    description: '支付发起的用户 ID',
    sensitivityLevel: 2
  },
  orderId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Order',
    description: '对应的订单 ID',
    sensitivityLevel: 2
  },
  subscriptionId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Subscription',
    description: '对应的订阅 ID（如存在）',
    sensitivityLevel: 2
  },
  amount: {
    type: Number,
    required: true,
    description: '支付金额',
    sensitivityLevel: 2
  },
  currency: {
    type: String,
    default: 'CNY',
    description: '支付货币单位（如 CNY、USD）'
  },
  paymentMethod: {
    type: String,
    enum: ['wechat', 'alipay', 'card', 'applePay'],
    required: true,
    description: '支付方式'
  },
  transactionId: {
    type: String,
    description: '支付平台返回的交易单号'
  },
  paymentChannel: {
    type: String,
    enum: ['wechat', 'alipay', 'stripe', 'applePay', 'manual'],
    default: 'wechat',
    description: '实际支付通道（区别于表面支付方式）'
  },
  status: {
    type: String,
    enum: ['pending', 'paid', 'failed', 'refunded'],
    default: 'pending',
    description: '支付状态'
  },
  paidAt: {
    type: Date,
    description: '支付完成时间'
  },
  refundedAt: {
    type: Date,
    description: '退款时间（如有）'
  }
}, {
  timestamps: true
});

module.exports = mongoose.model('Payment', paymentSchema);