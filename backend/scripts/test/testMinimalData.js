/**
 * 使用最小数据测试API
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

// 最小的测试数据
const minimalTestData = {
  personalInfo: {
    fullName: '张三',
    gender: 'male',
    birthDate: '1990-01-01',
    idNumber: '110101199001011234',
    phone: '13800138011',
    email: 'test@example.com',
    address: {
      province: '北京市',
      city: '北京市',
      district: '朝阳区',
      detailed: '测试地址详细信息'
    }
  },
  education: {
    degree: 'bachelor',
    major: '营养学',
    school: '北京大学',
    graduationYear: 2015,
    gpa: 3.8
  },
  workExperience: {
    totalYears: 5,
    currentPosition: '营养师',
    currentEmployer: '测试医院',
    workDescription: '负责营养咨询、营养评估、膳食指导等专业工作，具有丰富的临床营养工作经验',
    previousExperiences: []
  },
  certificationInfo: {
    targetLevel: 'registered_dietitian',
    specializationAreas: ['clinical_nutrition'],
    motivationStatement: '我在营养学领域已经工作多年，希望通过注册营养师认证来进一步提升自己的专业水平。我相信这个认证能帮助我更好地服务患者，提供更专业的营养指导。',
    careerGoals: '我的职业目标是成为一名优秀的临床营养师，能够为各类患者提供个性化的营养方案，特别是在慢性病营养管理方面做出贡献。'
  }
};

async function testMinimalData() {
  try {
    console.log('🚀 测试最小数据...');

    // 1. 登录
    console.log('1️⃣ 登录...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login/code`, {
      phone: '13800138011',
      code: '123456'
    });
    
    const authToken = loginResponse.data.token;
    console.log('✅ 登录成功');

    // 2. 创建申请
    console.log('\n2️⃣ 创建申请...');
    console.log('发送数据:', JSON.stringify(minimalTestData, null, 2));
    
    const createResponse = await axios.post(
      `${API_BASE_URL}/nutritionist-certification/applications`,
      minimalTestData,
      {
        headers: {
          'Authorization': `Bearer ${authToken}`,
          'Content-Type': 'application/json'
        }
      }
    );
    
    console.log('✅ 申请创建成功');
    console.log('响应:', createResponse.data);

  } catch (error) {
    console.log('❌ 错误发生:');
    console.log('状态码:', error.response?.status);
    console.log('错误信息:', error.response?.data?.message || error.message);
    if (error.response?.data?.details) {
      console.log('验证错误详情:', JSON.stringify(error.response.data.details, null, 2));
    }
  }
}

testMinimalData();