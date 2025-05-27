# 元气立方框架调整文档

**调整日期**：2025-01-26  
**版本**：v2.0.0  
**项目转型**：从多元化平台转向『元气立方』统一品牌连锁加盟模式

## 一、调整背景

为适应『元气立方』品牌统一运营战略，将原有的多商家类型平台模式调整为标准化连锁加盟店模式，实现：
- 统一的品牌形象和服务标准
- 标准化的菜品和营养方案
- 简化的运营管理流程
- 更好的品质控制

## 二、主要变更

### 1. 商家模型重构

#### 原模型 (已废弃)
```
models/merchant/merchantModel.js
- 支持多种商家类型（餐厅、健身房、月子中心、学校/企业）
- 复杂的商家特定设置
- 各自独立的运营模式
```

#### 新模型 (标准化)
```
models/franchise/franchiseStoreModel.js
- 统一的加盟店模型
- 标准化的运营配置
- 集中的品质管理
- 简化的员工管理
```

### 2. 角色权限体系

#### 原角色系统
```javascript
// constants/roles.js (旧)
{
  USER: '普通用户',
  ADMIN: '管理员',
  NUTRITIONIST: '营养师',
  MERCHANT: '商家'
}
```

#### 新角色系统
```javascript
// constants/roles.js (新)
{
  // 客户角色
  CUSTOMER: '顾客',
  
  // 加盟店角色
  STORE_MANAGER: '店长',
  STORE_STAFF: '店员',
  NUTRITIONIST: '营养师',
  
  // 总部角色
  ADMIN: '总部管理员',
  AREA_MANAGER: '区域经理',
  
  // 系统角色
  SYSTEM: '系统'
}
```

### 3. 菜单分类标准化

创建了统一的菜单分类体系：
```
constants/menuCategories.js
- 五大主分类：健身、孕产、学生、养生、医疗营养餐
- 详细的子分类体系
- 标准化的营养标签
- 统一的套餐类型
```

### 4. 用户模型更新

#### 新增字段
```javascript
// models/user/userModel.js
{
  profileCompleted: Boolean,      // 资料是否完成
  autoRegistered: Boolean,        // 是否自动注册
  franchiseStoreId: ObjectId,     // 所属加盟店
  managedStores: [ObjectId]       // 管理的门店（区域经理）
}
```

### 5. 认证系统优化

#### 自动注册机制
- 密码登录时，未注册用户自动创建账号
- 验证码登录继续支持自动注册
- 新用户标记为 `autoRegistered: true`
- 自动检测资料完成状态

#### 员工认证服务
```
services/franchise/staffAuthService.js
- 基于邀请码的员工注册
- 区分顾客端和员工端登录
- 自动关联到所属加盟店
```

## 三、数据结构变更

### 1. 加盟店数据结构
```javascript
FranchiseStore {
  // 基本信息
  storeCode: String,          // 门店编号
  storeName: String,          // 门店名称
  managerId: ObjectId,        // 店长ID
  
  // 加盟信息
  franchiseInfo: {
    franchiseDate: Date,
    contractStartDate: Date,
    contractEndDate: Date,
    franchiseStatus: String,
    franchiseFee: Number
  },
  
  // 服务配置
  serviceConfig: {
    supportedServices: [String],
    targetCustomers: [String],
    specialServices: Object
  },
  
  // 员工管理
  staff: [{
    userId: ObjectId,
    role: String,
    joinDate: Date,
    isActive: Boolean
  }]
}
```

### 2. 标准菜品数据结构
```javascript
StandardDish {
  // 基本信息
  dishCode: String,           // 菜品编码
  dishName: String,           // 菜品名称
  
  // 分类信息
  category: {
    main: String,             // 主分类
    sub: String               // 子分类
  },
  
  // 营养信息
  nutrition: {
    calories: Number,
    protein: Number,
    carbohydrates: Number,
    fat: Number,
    // ... 详细营养成分
  },
  
  // 适用人群
  targetAudience: [String]
}
```

## 四、API接口变更

### 1. 认证接口保持不变
- POST /api/auth/login
- POST /api/auth/login-with-code
- POST /api/auth/send-code

### 2. 新增员工接口
- POST /api/franchise/staff/register (员工注册)
- POST /api/franchise/staff/login (员工登录)

### 3. 用户接口增强
- 登录返回增加 `userType` 字段
- 个人资料更新自动检测完成状态

## 五、兼容性说明

### 1. 向后兼容
- 保留原有的 USER 和 MERCHANT 角色映射
- 现有用户数据可继续使用
- API接口保持兼容

### 2. 迁移计划
- 现有商家数据需迁移到加盟店模型
- 用户角色需要重新映射
- 菜品数据需要标准化处理

## 六、开发指南

### 1. 新增加盟店
```javascript
const store = new FranchiseStore({
  storeCode: 'YQ-BJ-001',
  storeName: '元气立方北京望京店',
  managerId: userId,
  franchiseInfo: {
    franchiseDate: new Date(),
    contractStartDate: new Date(),
    contractEndDate: new Date('2028-01-26'),
    franchiseStatus: 'active'
  }
});
```

### 2. 员工注册流程
```javascript
// 1. 生成邀请码
const inviteCode = generateInviteCode(storeCode, role);

// 2. 员工使用邀请码注册
const staff = await staffAuthService.registerStaff({
  phone: '13800138000',
  password: 'password123',
  inviteCode: 'YQ-BJ-001-MGR-A8K3',
  role: 'store_manager'
});
```

### 3. 标准菜品管理
```javascript
// 创建标准菜品
const dish = new StandardDish({
  dishCode: 'YQ-FIT-001',
  dishName: '增肌牛肉餐',
  category: {
    main: 'fitness',
    sub: 'muscle_building'
  },
  nutrition: {
    calories: 650,
    protein: 45,
    carbohydrates: 60,
    fat: 20
  }
});
```

## 七、注意事项

1. **数据迁移**：在正式上线前需要完成数据迁移脚本
2. **权限检查**：所有涉及商家的权限检查需要更新为加盟店权限
3. **前端适配**：前端需要根据 `userType` 显示不同界面
4. **测试覆盖**：所有变更的模块需要更新单元测试

## 八、下一步计划

1. 完成数据迁移脚本开发
2. 更新前端界面适配新的角色系统
3. 开发加盟店管理后台
4. 实现智能推荐系统
5. 部署测试环境验证

---

**文档维护**：架构组  
**最后更新**：2025-01-26