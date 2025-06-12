# 营养师认证功能 - 重构版本

## 概述

本模块实现了全新的营养师认证功能，采用Material 3设计规范，提供完整的5步认证申请流程。

## 主要特性

### 🎨 现代化设计
- 采用Material 3设计语言
- 响应式步骤指示器
- 优雅的动画效果和视觉反馈

### 📋 完整的申请流程
1. **个人信息** - 基本信息和地址选择
2. **教育背景** - 学历和专业信息
3. **工作经验** - 支持多段工作经历管理
4. **认证信息** - 目标等级和专长领域选择
5. **文档上传** - 多文件上传和预览

### 🔒 数据安全
- 身份证号自动加密
- 文件安全上传
- 完整的数据验证

## 文件结构

```
lib/features/nutritionist/
├── README.md                                    # 本文档
├── presentation/
│   ├── pages/
│   │   ├── nutritionist_certification_application_page.dart   # 主要认证申请页面
│   │   └── nutritionist_certification_status_page.dart        # 认证状态查看页面
│   └── widgets/
│       ├── certification_step_indicator.dart                  # 认证步骤指示器
│       ├── steps/
│       │   ├── personal_info_step.dart                       # 步骤1：个人信息
│       │   ├── education_step.dart                           # 步骤2：教育背景
│       │   ├── work_experience_step.dart                     # 步骤3：工作经验
│       │   ├── certification_info_step.dart                  # 步骤4：认证信息
│       │   └── document_upload_step.dart                     # 步骤5：文档上传
│       └── form_widgets/
│           └── address_selector.dart                         # 地址选择器
├── data/
│   └── services/
│       └── nutritionist_certification_service.dart           # API服务
└── domain/
    └── entities/
        └── nutritionist_certification.dart                   # 数据实体
```

## 使用方式

### 基础导航

```dart
// 新建认证申请
AppNavigator.toNutritionistCertification(context);

// 编辑现有申请
AppNavigator.toNutritionistCertificationEdit(
  context,
  applicationId: 'existing_id',
  initialData: existingData,
);

// 查看申请状态
AppNavigator.toNutritionistCertificationStatus(
  context,
  applicationId: 'application_id',
);
```

### 路由配置

路由已集成到应用的路由系统中：

- `/nutritionist/certification` - 新建/编辑认证申请
- `/nutritionist/certification/status` - 查看申请状态
- `/nutritionist/certification/edit` - 编辑申请（同certification）

## 数据结构

### 表单数据结构

```dart
Map<String, dynamic> formData = {
  'personalInfo': {
    'fullName': '',
    'idNumber': '',
    'phone': '',
    'email': '',
    'gender': 'female', // 'male' | 'female'
    'birthDate': '',
    'address': {
      'province': '',
      'city': '',
      'district': '',
      'detailed': '',
    },
  },
  'education': {
    'degree': '',      // 学历等级
    'major': '',       // 专业
    'school': '',      // 学校名称
    'graduationYear': 0,
  },
  'workExperience': {
    'totalYears': 0,
    'currentPosition': '',
    'currentEmployer': '',
    'workDescription': '',
    'previousExperiences': [
      {
        'position': '',
        'company': '',
        'startYear': 0,
        'endYear': 0,
        'description': '',
      }
    ],
  },
  'certificationInfo': {
    'targetLevel': '',           // 目标认证等级
    'specializationAreas': [],   // 专长领域（1-2个）
    'workYearsInNutrition': 0,   // 营养工作年限
    'motivationStatement': '',   // 申请动机
  },
  'documents': [
    {
      'documentType': '',
      'fileName': '',
      'fileUrl': '',
      'fileSize': 0,
      'mimeType': '',
      'uploadedAt': '',
    }
  ],
};
```

### 枚举值

#### 认证等级 (targetLevel)
- `public_nutritionist_l4` - 四级公共营养师
- `public_nutritionist_l3` - 三级公共营养师
- `clinical_nutritionist` - 临床营养师
- `sports_nutritionist` - 运动营养师

#### 专长领域 (specializationAreas)
- `clinical_nutrition` - 临床营养
- `sports_nutrition` - 运动营养
- `child_nutrition` - 儿童营养
- `elderly_nutrition` - 老年营养
- `weight_management` - 体重管理
- `chronic_disease_nutrition` - 慢性病营养
- `food_safety` - 食品安全
- `community_nutrition` - 社区营养
- `nutrition_education` - 营养教育
- `food_service_management` - 餐饮管理

#### 文档类型 (documentType)
- `nutrition_certificate` - 营养师资格证书（必需）
- `id_card` - 身份证
- `education_certificate` - 学历证书
- `training_certificate` - 培训证书
- `work_certificate` - 工作证明
- `other_materials` - 其他材料

## 与后端对接

### API端点
- `POST /api/nutritionist-certification/applications` - 创建申请
- `PUT /api/nutritionist-certification/applications/:id` - 更新申请
- `POST /api/nutritionist-certification/applications/:id/submit` - 提交申请
- `GET /api/nutritionist-certification/constants` - 获取常量数据

### 数据验证
前端实现了完整的数据验证：
- 必填字段检查
- 格式验证（身份证、手机号、邮箱等）
- 业务规则验证（专长领域数量、文档要求等）

## 开发说明

### 代码架构
- 使用现代化的Material 3设计语言
- 服务层和数据模型与后端完全兼容
- 采用模块化的步骤组件设计，便于维护和扩展

### 扩展说明
- 地址选择器支持省市区三级联动
- 工作经验支持无限添加历史经历
- 文档上传支持图片预览功能
- 所有组件都实现了状态保持（AutomaticKeepAliveClientMixin）

### 注意事项
1. 文件上传需要后端文件服务支持
2. 身份证号在前端明文传输，后端负责加密
3. 专长领域限制选择1-2个
4. 营养师资格证书为必需文档

## 测试建议

### 功能测试
1. 测试完整的5步申请流程
2. 测试表单验证规则
3. 测试文件上传功能
4. 测试数据保存和恢复

### UI测试
1. 测试在不同屏幕尺寸下的表现
2. 测试Material 3主题适配
3. 测试动画效果
4. 测试错误状态显示

### 集成测试
1. 测试与后端API的集成
2. 测试路由导航
3. 测试状态管理
4. 测试错误处理

## 更新日志

### v2.0.0 (当前版本)
- 全新的Material 3设计
- 5步完整申请流程
- 增强的表单验证
- 支持多文件上传
- 完整的路由集成
- 精简代码结构，移除冗余组件