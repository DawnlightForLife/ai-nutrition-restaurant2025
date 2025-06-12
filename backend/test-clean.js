/**
 * 清理已存在的测试数据
 */

const mongoose = require('mongoose');
const NutritionistCertification = require('./models/nutrition/nutritionistCertificationModel');

async function cleanTestData() {
  try {
    await mongoose.connect('mongodb://localhost:27017/ai-nutrition-restaurant', {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    // 删除所有测试用户的申请
    const result = await NutritionistCertification.deleteMany({
      'personalInfo.fullName': { $regex: '^测试用户' }
    });
    
    console.log(`已删除 ${result.deletedCount} 条测试数据`);
    
    await mongoose.disconnect();
  } catch (error) {
    console.error('清理失败:', error.message);
    await mongoose.disconnect();
  }
}

cleanTestData();