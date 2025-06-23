/**
 * 初始化咨询测试数据
 * 创建测试用的咨询记录
 */

const mongoose = require('mongoose');
const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../.env') });

// 导入模型
const User = require('../../models/user/userModel');
const Nutritionist = require('../../models/nutrition/nutritionistModel');
const Consultation = require('../../models/consult/consultationModel');

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/nutrition-platform';

async function initConsultationTestData() {
  try {
    // 连接数据库
    await mongoose.connect(MONGODB_URI);
    console.log('数据库连接成功');

    // 查找测试用户
    const testUser = await User.findOne({ phone: '13800138000' });
    if (!testUser) {
      console.error('未找到测试用户，请先运行 initTestUser.js');
      return;
    }

    // 查找测试营养师
    const testNutritionist = await Nutritionist.findOne({}).populate('userId');
    if (!testNutritionist) {
      console.error('未找到营养师，请先创建营养师账号');
      return;
    }

    console.log('找到测试用户:', testUser.username);
    console.log('找到测试营养师:', testNutritionist.name || testNutritionist.userId?.username);

    // 删除现有的测试咨询记录
    await Consultation.deleteMany({ userId: testUser._id });
    console.log('已清理现有测试咨询记录');

    // 创建测试咨询记录
    const consultations = [
      {
        userId: testUser._id,
        nutritionistId: testNutritionist._id,
        consultationType: 'text',
        status: 'completed',
        topic: '减重饮食方案咨询',
        startTime: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7天前
        endTime: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000 + 30 * 60 * 1000), // 30分钟后
        messages: [
          {
            senderType: 'user',
            senderId: testUser._id,
            messageType: 'text',
            content: '你好，我想咨询一下减重饮食方案',
            sentAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000),
            isRead: true
          },
          {
            senderType: 'nutritionist',
            senderId: testNutritionist.userId._id,
            messageType: 'text',
            content: '您好！很高兴为您服务。请问您目前的身高体重是多少？有什么特殊的饮食习惯或过敏食物吗？',
            sentAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000 + 2 * 60 * 1000),
            isRead: true
          },
          {
            senderType: 'user',
            senderId: testUser._id,
            messageType: 'text',
            content: '我身高170cm，体重80kg。没有过敏食物，但不太喜欢吃海鲜。',
            sentAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000 + 5 * 60 * 1000),
            isRead: true
          },
          {
            senderType: 'nutritionist',
            senderId: testNutritionist.userId._id,
            messageType: 'text',
            content: '根据您的情况，我为您制定了一个循序渐进的减重饮食方案。建议每天热量控制在1500-1800千卡，采用高蛋白、低碳水的饮食结构...',
            sentAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000 + 10 * 60 * 1000),
            isRead: true
          }
        ],
        professionalFeedback: '用户BMI为27.7，属于超重范围。建议通过调整饮食结构和适量运动来达到健康减重的目的。',
        followUpRecommendations: '建议2周后进行复诊，评估减重效果并调整饮食方案。',
        userRating: {
          rating: 5,
          comments: '非常专业的建议，营养师很耐心',
          ratedAt: new Date(Date.now() - 6 * 24 * 60 * 60 * 1000)
        }
      },
      {
        userId: testUser._id,
        nutritionistId: testNutritionist._id,
        consultationType: 'text',
        status: 'scheduled',
        scheduledTime: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000), // 2天后
        topic: '运动营养补充咨询',
        messages: [
          {
            senderType: 'system',
            senderId: new mongoose.Types.ObjectId(),
            messageType: 'text',
            content: '咨询已创建。类型: text, 预约时间: ' + new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(),
            sentAt: new Date(),
            isRead: false
          }
        ]
      },
      {
        userId: testUser._id,
        nutritionistId: testNutritionist._id,
        consultationType: 'text',
        status: 'inProgress',
        startTime: new Date(Date.now() - 10 * 60 * 1000), // 10分钟前开始
        topic: '素食营养搭配',
        messages: [
          {
            senderType: 'user',
            senderId: testUser._id,
            messageType: 'text',
            content: '我最近想尝试素食，但担心营养不够全面',
            sentAt: new Date(Date.now() - 10 * 60 * 1000),
            isRead: true
          },
          {
            senderType: 'nutritionist',
            senderId: testNutritionist.userId._id,
            messageType: 'text',
            content: '素食确实需要注意营养搭配。让我为您介绍一些关键营养素的植物来源...',
            sentAt: new Date(Date.now() - 5 * 60 * 1000),
            isRead: false
          }
        ]
      },
      {
        userId: testUser._id,
        nutritionistId: testNutritionist._id,
        consultationType: 'text',
        status: 'pending',
        topic: '儿童营养咨询',
        messages: [
          {
            senderType: 'user',
            senderId: testUser._id,
            messageType: 'text',
            content: '想咨询一下6岁儿童的营养需求',
            sentAt: new Date(),
            isRead: false
          }
        ]
      }
    ];

    // 创建咨询记录
    for (const consultationData of consultations) {
      const consultation = new Consultation(consultationData);
      await consultation.save();
      console.log(`创建咨询记录: ${consultation.topic} - 状态: ${consultation.status}`);
    }

    console.log('\n咨询测试数据初始化完成！');
    console.log(`创建了 ${consultations.length} 条咨询记录`);

    // 显示统计信息
    const stats = await Consultation.aggregate([
      { $match: { userId: testUser._id } },
      { $group: { _id: '$status', count: { $sum: 1 } } }
    ]);

    console.log('\n咨询状态统计:');
    stats.forEach(stat => {
      console.log(`  ${stat._id}: ${stat.count} 条`);
    });

  } catch (error) {
    console.error('初始化失败:', error);
  } finally {
    await mongoose.disconnect();
    console.log('\n数据库连接已关闭');
  }
}

// 执行初始化
initConsultationTestData();