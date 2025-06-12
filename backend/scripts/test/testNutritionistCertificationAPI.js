/**
 * 营养师认证API测试脚本
 * 直接测试API端点
 */

const axios = require('axios');

const API_BASE_URL = 'http://localhost:8080/api';
let authToken = '';
let applicationId = '';

// 测试用户数据
const testPhone = '13800138011';
const testCode = '123456'; // 测试环境固定验证码

// 测试申请数据
const testApplication = {
  personalInfo: {
    fullName: '测试营养师',
    gender: 'female',
    birthDate: '1990-01-01',
    idNumber: '110101199001011234',
    phone: testPhone,
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

async function test() {
  try {
    console.log('🚀 开始测试营养师认证API...\n');

    // 1. 发送验证码
    console.log('1️⃣ 发送验证码...');
    try {
      await axios.post(`${API_BASE_URL}/auth/send-code`, {
        phone: testPhone
      });
      console.log('✅ 验证码发送成功\n');
    } catch (error) {
      console.log('❌ 发送验证码失败:', error.response?.data?.message || error.message);
    }

    // 2. 登录
    console.log('2️⃣ 用户登录...');
    try {
      const loginResponse = await axios.post(`${API_BASE_URL}/auth/login/code`, {
        phone: testPhone,
        code: testCode
      });
      console.log('登录响应:', JSON.stringify(loginResponse.data, null, 2));
      authToken = loginResponse.data.token || loginResponse.data.data?.token;
      const userId = loginResponse.data.user?._id || loginResponse.data.data?.user?._id;
      console.log('✅ 登录成功');
      console.log('👤 用户ID:', userId);
      console.log('\n');
    } catch (error) {
      console.log('❌ 登录失败:', error.response?.data?.message || error.message);
      return;
    }

    // 3. 创建认证申请
    console.log('3️⃣ 创建认证申请...');
    try {
      const createResponse = await axios.post(
        `${API_BASE_URL}/nutritionist-certification/applications`,
        testApplication,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      applicationId = createResponse.data.data._id;
      console.log('✅ 申请创建成功');
      console.log('📋 申请ID:', applicationId);
      console.log('📋 申请编号:', createResponse.data.data.applicationNumber);
      console.log('📋 当前状态:', createResponse.data.data.review.status);
      console.log('\n');
    } catch (error) {
      console.log('❌ 创建申请失败:', error.response?.data?.message || error.message);
      if (error.response?.data?.details) {
        console.log('详细错误:', JSON.stringify(error.response.data.details, null, 2));
      }
      return;
    }

    // 4. 查询申请详情
    console.log('4️⃣ 查询申请详情...');
    try {
      const detailResponse = await axios.get(
        `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}`,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      const application = detailResponse.data.data;
      console.log('✅ 查询成功');
      console.log('📋 申请编号:', application.applicationNumber);
      console.log('📋 申请状态:', application.review.status);
      console.log('📋 申请人姓名:', application.personalInfo.fullName);
      console.log('📋 身份证号(加密):', application.personalInfo.idNumber);
      console.log('\n');
    } catch (error) {
      console.log('❌ 查询失败:', error.response?.data?.message || error.message);
    }

    // 5. 查询用户所有申请
    console.log('5️⃣ 查询用户所有申请...');
    try {
      const listResponse = await axios.get(
        `${API_BASE_URL}/nutritionist-certification/applications`,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      const applications = listResponse.data.data;
      console.log('✅ 查询成功');
      console.log('📋 申请总数:', applications.length);
      applications.forEach((app, index) => {
        console.log(`  ${index + 1}. 申请编号: ${app.applicationNumber}, 状态: ${app.review.status}`);
      });
      console.log('\n');
    } catch (error) {
      console.log('❌ 查询失败:', error.response?.data?.message || error.message);
    }

    // 6. 更新申请信息
    console.log('6️⃣ 更新申请信息...');
    try {
      const updateData = {
        ...testApplication,
        personalInfo: {
          ...testApplication.personalInfo,
          fullName: '更新后的姓名'
        }
      };
      
      const updateResponse = await axios.put(
        `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}`,
        updateData,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      console.log('✅ 更新成功');
      console.log('📋 更新后姓名:', updateResponse.data.data.personalInfo.fullName);
      console.log('\n');
    } catch (error) {
      console.log('❌ 更新失败:', error.response?.data?.message || error.message);
    }

    // 7. 提交申请
    console.log('7️⃣ 提交申请进行审核...');
    try {
      const submitResponse = await axios.post(
        `${API_BASE_URL}/nutritionist-certification/applications/${applicationId}/submit`,
        {},
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      console.log('✅ 提交成功');
      console.log('📋 新状态:', submitResponse.data.data.review.status);
      console.log('📋 提交时间:', new Date(submitResponse.data.data.review.submittedAt).toLocaleString());
      console.log('\n');
    } catch (error) {
      console.log('❌ 提交失败:', error.response?.data?.message || error.message);
    }

    // 8. 测试权限控制
    console.log('8️⃣ 测试权限控制...');
    try {
      await axios.get(
        `${API_BASE_URL}/nutritionist-certification/applications/507f1f77bcf86cd799439011`,
        {
          headers: {
            'Authorization': `Bearer ${authToken}`
          }
        }
      );
      console.log('❌ 权限控制失败：能够访问其他用户的申请');
    } catch (error) {
      if (error.response?.status === 404 || error.response?.status === 403) {
        console.log('✅ 权限控制正常：无法访问其他用户的申请');
      } else {
        console.log('❌ 意外错误:', error.response?.data?.message || error.message);
      }
    }

    console.log('\n✨ 测试完成！');

  } catch (error) {
    console.error('💥 测试过程中发生错误:', error.message);
  }
}

// 运行测试
test();