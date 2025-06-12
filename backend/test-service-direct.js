/**
 * 直接测试服务层
 */

const mongoose = require('mongoose');
const nutritionistCertificationService = require('./services/nutrition/nutritionistCertificationService');

async function testService() {
  try {
    // 连接数据库
    console.log('连接数据库...');
    await mongoose.connect('mongodb://localhost:27017/ai-nutrition-restaurant', {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('数据库连接成功');
    
    // 模拟用户
    const mockUser = {
      id: new mongoose.Types.ObjectId(),
      _id: new mongoose.Types.ObjectId(),
      phone: '15112341234',
      role: 'user'
    };
    
    // 测试数据
    const testData = {
      personalInfo: {
        fullName: '测试用户Service',
        idNumber: '110101199001011235',
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
        mimeType: 'image/jpeg',
        uploadedAt: new Date().toISOString()
      }]
    };
    
    // 调用服务
    console.log('调用服务层...');
    const startTime = Date.now();
    
    const result = await nutritionistCertificationService.createApplication(testData, mockUser);
    
    const duration = Date.now() - startTime;
    console.log(`服务调用完成，耗时: ${duration}ms`);
    console.log('结果:', JSON.stringify(result, null, 2));
    
    // 关闭连接
    await mongoose.disconnect();
    console.log('数据库连接已关闭');
    
  } catch (error) {
    console.error('❌ 测试失败:', error.message);
    console.error('错误堆栈:', error.stack);
    await mongoose.disconnect();
  }
}

testService();