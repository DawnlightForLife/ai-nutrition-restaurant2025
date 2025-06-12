/**
 * 营养师认证功能测试用例
 * 测试营养师认证的完整流程，包括申请、更新、提交、审核等
 */

const request = require('supertest');
const mongoose = require('mongoose');
const app = require('../app');
const User = require('../models/user/userModel');
const NutritionistCertification = require('../models/nutrition/nutritionistCertificationModel');
const jwt = require('jsonwebtoken');
const config = require('../config');

// 测试数据
const testUser = {
  phone: '13800138001',
  nickname: '测试用户',
  role: 'user'
};

const testApplication = {
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
    graduationYear: 2012,
    gpa: 3.8
  },
  workExperience: {
    totalYears: 5,
    currentPosition: '营养师',
    currentEmployer: '某某医院',
    workDescription: '负责临床营养咨询和膳食指导工作，为患者制定个性化营养方案',
    previousExperiences: []
  },
  certificationInfo: {
    targetLevel: 'registered_dietitian',
    specializationAreas: ['clinical_nutrition', 'chronic_disease_nutrition'],
    motivationStatement: '我希望通过获得注册营养师认证，提升专业能力，更好地服务患者。我在临床营养领域有丰富经验，希望能够获得专业认可。',
    careerGoals: '成为一名优秀的临床营养师，帮助更多患者改善健康状况'
  }
};

let authToken;
let userId;
let applicationId;

describe('营养师认证功能测试', () => {
  
  beforeAll(async () => {
    // 连接测试数据库
    await mongoose.connect(config.db.uri + '_test', {
      useNewUrlParser: true,
      useUnifiedTopology: true
    });
    
    // 清理测试数据
    await User.deleteMany({});
    await NutritionistCertification.deleteMany({});
    
    // 创建测试用户
    const user = await User.create(testUser);
    userId = user._id.toString();
    
    // 生成认证token
    authToken = jwt.sign(
      { id: userId, phone: testUser.phone, role: testUser.role },
      config.jwt.secret,
      { expiresIn: '1d' }
    );
  });
  
  afterAll(async () => {
    // 清理测试数据
    await User.deleteMany({});
    await NutritionistCertification.deleteMany({});
    await mongoose.connection.close();
  });
  
  describe('GET /api/nutritionist-certification/constants', () => {
    it('应该返回认证相关常量', async () => {
      const response = await request(app)
        .get('/api/nutritionist-certification/constants')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('certificationLevels');
      expect(response.body.data).toHaveProperty('certificationStatus');
      expect(response.body.data).toHaveProperty('specializationAreas');
      expect(response.body.data).toHaveProperty('educationRequirements');
    });
    
    it('未登录应该返回401', async () => {
      await request(app)
        .get('/api/nutritionist-certification/constants')
        .expect(401);
    });
  });
  
  describe('POST /api/nutritionist-certification/applications', () => {
    it('应该成功创建认证申请', async () => {
      const response = await request(app)
        .post('/api/nutritionist-certification/applications')
        .set('Authorization', `Bearer ${authToken}`)
        .send(testApplication)
        .expect(201);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data).toHaveProperty('_id');
      expect(response.body.data).toHaveProperty('applicationNumber');
      expect(response.body.data.review.status).toBe('draft');
      
      applicationId = response.body.data._id;
    });
    
    it('重复创建应该返回错误', async () => {
      const response = await request(app)
        .post('/api/nutritionist-certification/applications')
        .set('Authorization', `Bearer ${authToken}`)
        .send(testApplication)
        .expect(400);
      
      expect(response.body.success).toBe(false);
      expect(response.body.error).toContain('已有未完成的认证申请');
    });
    
    it('缺少必填字段应该返回错误', async () => {
      const incompleteData = {
        personalInfo: {
          fullName: '李四'
          // 缺少其他必填字段
        }
      };
      
      const response = await request(app)
        .post('/api/nutritionist-certification/applications')
        .set('Authorization', `Bearer ${authToken}`)
        .send(incompleteData)
        .expect(400);
      
      expect(response.body.success).toBe(false);
    });
  });
  
  describe('GET /api/nutritionist-certification/applications', () => {
    it('应该返回用户的申请列表', async () => {
      const response = await request(app)
        .get('/api/nutritionist-certification/applications')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data.applications).toHaveLength(1);
      expect(response.body.data.pagination).toBeDefined();
    });
    
    it('应该支持分页查询', async () => {
      const response = await request(app)
        .get('/api/nutritionist-certification/applications?page=1&limit=5')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.data.pagination.page).toBe(1);
      expect(response.body.data.pagination.limit).toBe(5);
    });
    
    it('应该支持状态筛选', async () => {
      const response = await request(app)
        .get('/api/nutritionist-certification/applications?status=draft')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.data.applications).toHaveLength(1);
      expect(response.body.data.applications[0].review.status).toBe('draft');
    });
  });
  
  describe('GET /api/nutritionist-certification/applications/:id', () => {
    it('应该返回申请详情', async () => {
      const response = await request(app)
        .get(`/api/nutritionist-certification/applications/${applicationId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data._id).toBe(applicationId);
      expect(response.body.data.personalInfo.fullName).toBe(testApplication.personalInfo.fullName);
    });
    
    it('访问不存在的申请应该返回404', async () => {
      const fakeId = new mongoose.Types.ObjectId();
      const response = await request(app)
        .get(`/api/nutritionist-certification/applications/${fakeId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(404);
      
      expect(response.body.success).toBe(false);
      expect(response.body.error).toBe('申请不存在');
    });
  });
  
  describe('PUT /api/nutritionist-certification/applications/:id', () => {
    it('应该成功更新申请信息', async () => {
      const updateData = {
        personalInfo: {
          ...testApplication.personalInfo,
          fullName: '张三丰'
        },
        education: testApplication.education,
        workExperience: testApplication.workExperience,
        certificationInfo: testApplication.certificationInfo
      };
      
      const response = await request(app)
        .put(`/api/nutritionist-certification/applications/${applicationId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data.personalInfo.fullName).toBe('张三丰');
    });
    
    it('非草稿状态不能更新', async () => {
      // 先提交申请
      await NutritionistCertification.findByIdAndUpdate(applicationId, {
        'review.status': 'pending'
      });
      
      const response = await request(app)
        .put(`/api/nutritionist-certification/applications/${applicationId}`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(testApplication)
        .expect(400);
      
      expect(response.body.error).toContain('当前状态下无法修改申请');
      
      // 恢复状态
      await NutritionistCertification.findByIdAndUpdate(applicationId, {
        'review.status': 'draft'
      });
    });
  });
  
  describe('POST /api/nutritionist-certification/applications/:id/documents', () => {
    it('应该成功上传文档', async () => {
      const documentData = {
        documentType: 'id_card',
        fileName: 'id_card.jpg',
        fileUrl: 'https://example.com/id_card.jpg',
        fileSize: 1024000,
        mimeType: 'image/jpeg'
      };
      
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/documents`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(documentData)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.data.documentType).toBe('id_card');
    });
    
    it('文件过大应该返回错误', async () => {
      const documentData = {
        documentType: 'education_certificate',
        fileName: 'certificate.pdf',
        fileUrl: 'https://example.com/certificate.pdf',
        fileSize: 11 * 1024 * 1024, // 11MB
        mimeType: 'application/pdf'
      };
      
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/documents`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(documentData)
        .expect(400);
      
      expect(response.body.error).toContain('文件大小超过限制');
    });
  });
  
  describe('DELETE /api/nutritionist-certification/applications/:id/documents/:documentType', () => {
    it('应该成功删除文档', async () => {
      const response = await request(app)
        .delete(`/api/nutritionist-certification/applications/${applicationId}/documents/id_card`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.message).toBe('文档删除成功');
    });
  });
  
  describe('POST /api/nutritionist-certification/applications/:id/submit', () => {
    beforeAll(async () => {
      // 先上传必需文档
      const documents = [
        {
          documentType: 'id_card',
          fileName: 'id_card.jpg',
          fileUrl: 'https://example.com/id_card.jpg',
          fileSize: 1024000,
          mimeType: 'image/jpeg'
        },
        {
          documentType: 'education_certificate',
          fileName: 'certificate.pdf',
          fileUrl: 'https://example.com/certificate.pdf',
          fileSize: 2048000,
          mimeType: 'application/pdf'
        }
      ];
      
      for (const doc of documents) {
        await request(app)
          .post(`/api/nutritionist-certification/applications/${applicationId}/documents`)
          .set('Authorization', `Bearer ${authToken}`)
          .send(doc);
      }
    });
    
    it('应该成功提交申请', async () => {
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/submit`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.message).toContain('申请提交成功');
      
      // 验证状态已更新
      const application = await NutritionistCertification.findById(applicationId);
      expect(application.review.status).toBe('pending');
    });
    
    it('已提交的申请不能重复提交', async () => {
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/submit`)
        .set('Authorization', `Bearer ${authToken}`)
        .expect(400);
      
      expect(response.body.error).toContain('当前状态下无法提交申请');
    });
  });
  
  describe('POST /api/nutritionist-certification/applications/:id/resubmit', () => {
    beforeAll(async () => {
      // 模拟申请被拒绝
      await NutritionistCertification.findByIdAndUpdate(applicationId, {
        'review.status': 'rejected',
        'review.rejectionReason': '资料不完整',
        'review.reviewedAt': new Date()
      });
    });
    
    it('应该成功重新提交被拒绝的申请', async () => {
      const updateData = {
        ...testApplication,
        personalInfo: {
          ...testApplication.personalInfo,
          fullName: '张三更新'
        }
      };
      
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/resubmit`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(200);
      
      expect(response.body.success).toBe(true);
      expect(response.body.message).toContain('申请重新提交成功');
      
      // 验证状态和数据已更新
      const application = await NutritionistCertification.findById(applicationId);
      expect(application.review.status).toBe('draft');
      expect(application.review.resubmissionCount).toBe(1);
      expect(application.personalInfo.fullName).toBe('张三更新');
    });
    
    it('非被拒绝状态不能重新提交', async () => {
      // 先更新状态为草稿
      await NutritionistCertification.findByIdAndUpdate(applicationId, {
        'review.status': 'draft'
      });
      
      const response = await request(app)
        .post(`/api/nutritionist-certification/applications/${applicationId}/resubmit`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(testApplication)
        .expect(400);
      
      expect(response.body.error).toContain('只有被拒绝的申请才能重新提交');
    });
  });
  
  describe('权限测试', () => {
    let otherUserToken;
    
    beforeAll(async () => {
      // 创建另一个用户
      const otherUser = await User.create({
        phone: '13800138002',
        nickname: '其他用户',
        role: 'user'
      });
      
      otherUserToken = jwt.sign(
        { id: otherUser._id.toString(), phone: otherUser.phone, role: otherUser.role },
        config.jwt.secret,
        { expiresIn: '1d' }
      );
    });
    
    it('不能查看其他用户的申请', async () => {
      const response = await request(app)
        .get(`/api/nutritionist-certification/applications/${applicationId}`)
        .set('Authorization', `Bearer ${otherUserToken}`)
        .expect(400);
      
      expect(response.body.error).toBe('无权限查看此申请');
    });
    
    it('不能更新其他用户的申请', async () => {
      const response = await request(app)
        .put(`/api/nutritionist-certification/applications/${applicationId}`)
        .set('Authorization', `Bearer ${otherUserToken}`)
        .send(testApplication)
        .expect(400);
      
      expect(response.body.error).toBe('无权限操作此申请');
    });
  });
});

// 运行测试
if (require.main === module) {
  const { execSync } = require('child_process');
  try {
    execSync('npm test -- --testPathPattern=nutritionist-certification.test.js', { stdio: 'inherit' });
  } catch (error) {
    process.exit(1);
  }
}