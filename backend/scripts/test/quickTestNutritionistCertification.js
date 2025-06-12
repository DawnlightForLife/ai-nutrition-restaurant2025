/**
 * 快速测试营养师认证功能
 * 直接测试服务层功能
 */

const mongoose = require('mongoose');

// 直接设置数据库连接
const DB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/smart_nutrition_test';

async function quickTest() {
  console.log('🚀 开始快速测试营养师认证功能...\n');
  
  try {
    // 连接数据库
    await mongoose.connect(DB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('✅ 数据库连接成功');
    
    // 加载模型和服务
    const User = require('../../models/user/userModel');
    const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
    const service = require('../../services/nutrition/nutritionistCertificationService');
    
    // 创建测试用户
    const testUser = await User.create({
      phone: '13800138001',
      nickname: '测试用户',
      role: 'user'
    });
    console.log('✅ 创建测试用户成功');
    
    // 测试创建申请
    const applicationData = {
      personalInfo: {
        fullName: '张三',
        gender: 'male',
        birthDate: '1990-01-01',
        idNumber: '110101199001011234',
        phone: '13800138001',
        email: 'test@example.com',
        address: {
          province: '北京市',
          city: '北京市',
          district: '朝阳区',
          detailed: '某某街道123号'
        }
      },
      education: {
        degree: 'bachelor',
        major: '营养学',
        school: '北京大学',
        graduationYear: 2012
      },
      workExperience: {
        totalYears: 5,
        currentPosition: '营养师',
        currentEmployer: '某某医院',
        workDescription: '负责临床营养咨询工作',
        previousExperiences: []
      },
      certificationInfo: {
        targetLevel: 'registered_dietitian',
        specializationAreas: ['clinical_nutrition'],
        motivationStatement: '我希望通过获得注册营养师认证，提升专业能力，更好地服务患者。'
      }
    };
    
    const createResult = await service.createApplication(applicationData, { id: testUser._id.toString() });
    
    if (createResult.success) {
      console.log('✅ 创建申请成功');
      console.log('  - 申请ID:', createResult.data._id);
      console.log('  - 申请编号:', createResult.data.applicationNumber);
      console.log('  - 状态:', createResult.data.review.status);
      
      // 测试重新提交功能
      const applicationId = createResult.data._id;
      
      // 先设置为被拒绝状态
      await NutritionistCertification.findByIdAndUpdate(applicationId, {
        'review.status': 'rejected',
        'review.rejectionReason': '测试拒绝'
      });
      console.log('\n✅ 模拟审核拒绝完成');
      
      // 重新提交
      const resubmitResult = await service.resubmitApplication(
        applicationId,
        applicationData,
        { id: testUser._id.toString() }
      );
      
      if (resubmitResult.success) {
        console.log('✅ 重新提交功能正常');
        console.log('  - 新状态:', resubmitResult.data.review.status);
        console.log('  - 重新提交次数:', resubmitResult.data.review.resubmissionCount);
      }
      
    } else {
      console.log('❌ 创建申请失败:', createResult.error);
    }
    
    // 清理测试数据
    await User.deleteOne({ _id: testUser._id });
    await NutritionistCertification.deleteMany({ userId: testUser._id });
    console.log('\n✅ 测试完成，数据已清理');
    
  } catch (error) {
    console.error('❌ 测试失败:', error.message);
  } finally {
    await mongoose.connection.close();
    console.log('✅ 数据库连接已关闭');
  }
}

// 运行测试
quickTest();