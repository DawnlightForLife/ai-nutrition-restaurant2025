/**
 * 直接测试模型保存
 */

const mongoose = require('mongoose');
const NutritionistCertification = require('./models/nutrition/nutritionistCertificationModel');

async function testModelSave() {
  try {
    // 连接数据库
    console.log('连接数据库...');
    await mongoose.connect('mongodb://localhost:27017/ai-nutrition-restaurant', {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('数据库连接成功');
    
    // 创建测试数据
    console.log('创建测试数据...');
    const testData = {
      userId: new mongoose.Types.ObjectId(),
      personalInfo: {
        fullName: '测试用户',
        idNumber: '110101199001011234',
        phone: '15112341234'
      },
      certificationInfo: {
        specializationAreas: ['sports_nutrition'],
        workYearsInNutrition: 1
      },
      documents: [{
        documentType: 'nutrition_certificate',
        fileName: 'test.jpg',
        fileUrl: 'http://example.com/test.jpg',
        fileSize: 50000,
        mimeType: 'image/jpeg'
      }],
      review: {
        status: 'draft',
        resubmissionCount: 0
      }
    };
    
    // 保存数据
    console.log('开始保存数据...');
    const startTime = Date.now();
    
    const application = new NutritionistCertification(testData);
    await application.save();
    
    const duration = Date.now() - startTime;
    console.log(`✅ 保存成功，耗时: ${duration}ms`);
    console.log('申请编号:', application.applicationNumber);
    console.log('申请ID:', application._id);
    
    // 关闭连接
    await mongoose.disconnect();
    console.log('数据库连接已关闭');
    
  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    console.error('错误堆栈:', error.stack);
    await mongoose.disconnect();
  }
}

testModelSave();