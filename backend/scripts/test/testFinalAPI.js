/**
 * 最终的营养师认证API测试
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';

const testData = {
  personalInfo: {
    fullName: '张营养师',
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

async function testFinalAPI() {
  try {
    console.log('🚀 营养师认证功能最终测试\n');

    // 1. 登录
    console.log('1️⃣ 用户登录...');
    const loginResponse = await axios.post(`${API_BASE_URL}/auth/login/code`, {
      phone: '13800138011',
      code: '123456'
    });
    
    const authToken = loginResponse.data.token;
    console.log('✅ 登录成功\n');

    // 2. 创建认证申请
    console.log('2️⃣ 创建认证申请...');
    const createResponse = await axios.post(
      `${API_BASE_URL}/nutritionist-certification/applications`,
      testData,
      {
        headers: { 'Authorization': `Bearer ${authToken}` }
      }
    );
    
    const applicationId = createResponse.data.data._id;
    console.log('✅ 申请创建成功');
    console.log('📋 申请ID:', applicationId);
    console.log('📋 申请编号:', createResponse.data.data.applicationNumber);
    console.log('📋 状态:', createResponse.data.data.review.status);
    console.log('');

    // 3. 查询申请详情  
    console.log('3️⃣ 查询申请详情...');
    const detailResponse = await axios.get(
      `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}`,
      { headers: { 'Authorization': `Bearer ${authToken}` } }
    );
    console.log('✅ 查询成功');
    console.log('📋 申请人:', detailResponse.data.data.personalInfo.fullName);
    console.log('📋 目标等级:', detailResponse.data.data.certificationInfo.targetLevel);
    console.log('');

    // 4. 查询用户所有申请
    console.log('4️⃣ 查询用户所有申请...');
    const listResponse = await axios.get(
      `${API_BASE_URL}/nutritionist-certification/applications`,
      { headers: { 'Authorization': `Bearer ${authToken}` } }
    );
    console.log('✅ 查询成功');
    console.log('📋 申请总数:', listResponse.data.data.length);
    console.log('');

    // 5. 提交申请
    console.log('5️⃣ 提交申请进行审核...');
    const submitResponse = await axios.post(
      `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}/submit`,
      {},
      { headers: { 'Authorization': `Bearer ${authToken}` } }
    );
    console.log('✅ 提交成功');
    console.log('📋 新状态:', submitResponse.data.data.review.status);
    console.log('');

    console.log('🎉 营养师认证功能测试完成！');
    console.log('🎯 所有核心功能均正常工作');

  } catch (error) {
    console.log('❌ 测试失败:');
    console.log('状态码:', error.response?.status);
    console.log('错误信息:', error.response?.data?.message || error.message);
    
    if (error.response?.data?.details) {
      console.log('详细错误:', JSON.stringify(error.response.data.details, null, 2));
    }
  }
}

testFinalAPI();