/**
 * 营养师认证功能测试脚本
 * 用于测试营养师认证的核心功能
 */

require('dotenv').config();
const mongoose = require('mongoose');
const config = require('../../config');
const User = require('../../models/user/userModel');
const NutritionistCertification = require('../../models/nutrition/nutritionistCertificationModel');
const nutritionistCertificationService = require('../../services/nutrition/nutritionistCertificationService');

// 测试数据
const testUserData = {
  phone: '13800138000',
  nickname: '测试营养师',
  role: 'user',
  password: '123456'
};

const testApplicationData = {
  personalInfo: {
    fullName: '测试用户',
    gender: 'female',
    birthDate: '1990-05-15',
    idNumber: '110101199005151234',
    phone: '13800138000',
    email: 'test@example.com',
    address: {
      province: '北京市',
      city: '北京市',
      district: '朝阳区',
      detailed: '测试地址123号'
    }
  },
  education: {
    degree: 'master',
    major: '营养与食品卫生学',
    school: '北京大学医学部',
    graduationYear: 2015,
    gpa: 3.9
  },
  workExperience: {
    totalYears: 8,
    currentPosition: '高级营养师',
    currentEmployer: '北京协和医院',
    workDescription: '负责临床营养咨询、营养评估、膳食指导等工作，擅长慢性病营养管理',
    previousExperiences: []
  },
  certificationInfo: {
    targetLevel: 'registered_dietitian',
    specializationAreas: ['clinical_nutrition', 'chronic_disease_nutrition'],
    motivationStatement: '本人在营养领域深耕多年，希望通过注册营养师认证进一步提升专业水平，为更多患者提供专业的营养指导服务。',
    careerGoals: '成为国内顶尖的临床营养专家，推动营养治疗在慢性病管理中的应用'
  }
};

async function runTests() {
  console.log('🚀 开始营养师认证功能测试...\n');
  
  try {
    // 连接数据库
    await mongoose.connect(config.db.uri, {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    console.log('✅ 数据库连接成功');
    
    // 清理测试数据
    await User.deleteOne({ phone: testUserData.phone });
    await NutritionistCertification.deleteMany({ 'personalInfo.phone': testUserData.phone });
    console.log('✅ 清理测试数据完成');
    
    // 创建测试用户
    const user = await User.create(testUserData);
    console.log('✅ 创建测试用户成功:', user.phone);
    
    // 测试1: 创建认证申请
    console.log('\n📋 测试1: 创建认证申请');
    const createResult = await nutritionistCertificationService.createApplication(
      testApplicationData,
      { id: user._id.toString() }
    );
    
    if (createResult.success) {
      console.log('✅ 创建申请成功');
      console.log('  - 申请ID:', createResult.data._id);
      console.log('  - 申请编号:', createResult.data.applicationNumber);
      console.log('  - 当前状态:', createResult.data.review.status);
    } else {
      console.log('❌ 创建申请失败:', createResult.error);
      return;
    }
    
    const applicationId = createResult.data._id;
    
    // 测试2: 获取申请列表
    console.log('\n📋 测试2: 获取申请列表');
    const listResult = await nutritionistCertificationService.getUserApplications(
      { id: user._id.toString() },
      { page: 1, limit: 10 }
    );
    
    if (listResult.success) {
      console.log('✅ 获取申请列表成功');
      console.log('  - 申请数量:', listResult.data.applications.length);
      console.log('  - 第一个申请状态:', listResult.data.applications[0]?.review.status);
    } else {
      console.log('❌ 获取申请列表失败:', listResult.error);
    }
    
    // 测试3: 更新申请信息
    console.log('\n📋 测试3: 更新申请信息');
    const updateData = {
      ...testApplicationData,
      personalInfo: {
        ...testApplicationData.personalInfo,
        fullName: '更新后的姓名'
      }
    };
    
    const updateResult = await nutritionistCertificationService.updateApplication(
      applicationId,
      updateData,
      { id: user._id.toString() }
    );
    
    if (updateResult.success) {
      console.log('✅ 更新申请成功');
      console.log('  - 更新后姓名:', updateResult.data.personalInfo.fullName);
    } else {
      console.log('❌ 更新申请失败:', updateResult.error);
    }
    
    // 测试4: 上传文档
    console.log('\n📋 测试4: 上传文档');
    const documents = [
      {
        documentType: 'id_card',
        fileName: 'id_card.jpg',
        fileUrl: 'https://example.com/test/id_card.jpg',
        fileSize: 1024000,
        mimeType: 'image/jpeg'
      },
      {
        documentType: 'education_certificate',
        fileName: 'diploma.pdf',
        fileUrl: 'https://example.com/test/diploma.pdf',
        fileSize: 2048000,
        mimeType: 'application/pdf'
      }
    ];
    
    for (const doc of documents) {
      const uploadResult = await nutritionistCertificationService.uploadDocument(
        applicationId,
        doc,
        { id: user._id.toString() }
      );
      
      if (uploadResult.success) {
        console.log(`✅ 上传${doc.documentType}成功`);
      } else {
        console.log(`❌ 上传${doc.documentType}失败:`, uploadResult.error);
      }
    }
    
    // 测试5: 提交申请
    console.log('\n📋 测试5: 提交申请');
    const submitResult = await nutritionistCertificationService.submitApplication(
      applicationId,
      { id: user._id.toString() }
    );
    
    if (submitResult.success) {
      console.log('✅ 提交申请成功');
      console.log('  - 提交后状态:', submitResult.data.review.status);
      console.log('  - 提示信息:', submitResult.message);
    } else {
      console.log('❌ 提交申请失败:', submitResult.error);
    }
    
    // 测试6: 模拟审核拒绝后重新提交
    console.log('\n📋 测试6: 测试重新提交功能');
    
    // 先模拟审核拒绝
    await NutritionistCertification.findByIdAndUpdate(applicationId, {
      'review.status': 'rejected',
      'review.rejectionReason': '资料不完整，请补充工作证明',
      'review.reviewedAt': new Date()
    });
    console.log('  - 模拟审核拒绝完成');
    
    // 重新提交
    const resubmitData = {
      ...testApplicationData,
      personalInfo: {
        ...testApplicationData.personalInfo,
        fullName: '重新提交的姓名'
      }
    };
    
    const resubmitResult = await nutritionistCertificationService.resubmitApplication(
      applicationId,
      resubmitData,
      { id: user._id.toString() }
    );
    
    if (resubmitResult.success) {
      console.log('✅ 重新提交成功');
      console.log('  - 重新提交后状态:', resubmitResult.data.review.status);
      console.log('  - 重新提交次数:', resubmitResult.data.review.resubmissionCount);
    } else {
      console.log('❌ 重新提交失败:', resubmitResult.error);
    }
    
    // 测试7: 权限测试
    console.log('\n📋 测试7: 权限测试');
    
    // 创建另一个用户
    const otherUser = await User.create({
      phone: '13900139000',
      nickname: '其他用户',
      role: 'user',
      password: '123456'
    });
    
    // 尝试访问其他用户的申请
    const unauthorizedResult = await nutritionistCertificationService.getApplicationDetail(
      applicationId,
      { id: otherUser._id.toString() }
    );
    
    if (!unauthorizedResult.success && unauthorizedResult.error.includes('无权限')) {
      console.log('✅ 权限控制正常：其他用户无法访问');
    } else {
      console.log('❌ 权限控制异常：其他用户可以访问');
    }
    
    // 清理其他用户
    await User.deleteOne({ _id: otherUser._id });
    
    console.log('\n🎉 所有测试完成！');
    
    // 显示最终申请状态
    const finalApplication = await NutritionistCertification.findById(applicationId);
    console.log('\n📊 最终申请状态:');
    console.log('  - 申请编号:', finalApplication.applicationNumber);
    console.log('  - 当前状态:', finalApplication.review.status);
    console.log('  - 文档数量:', finalApplication.documents.length);
    console.log('  - 重新提交次数:', finalApplication.review.resubmissionCount);
    
  } catch (error) {
    console.error('❌ 测试过程中发生错误:', error);
  } finally {
    // 清理测试数据
    await User.deleteOne({ phone: testUserData.phone });
    await User.deleteOne({ phone: '13900139000' });
    await NutritionistCertification.deleteMany({ 'personalInfo.phone': testUserData.phone });
    
    // 断开数据库连接
    await mongoose.connection.close();
    console.log('\n✅ 测试数据清理完成，数据库连接已关闭');
  }
}

// 运行测试
runTests().catch(console.error);