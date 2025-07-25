# 认证系统使用指南

## 系统概述

本项目采用了灵活的认证系统，支持商家认证和营养师认证两种类型。系统特点：

1. **可配置的认证开关** - 管理员可以通过后台控制是否显示认证入口
2. **联系客服模式** - 用户通过扫码添加客服微信进行人工审核
3. **权限管理系统** - 管理员可以直接授予用户相应权限
4. **工作台切换** - 获得权限的用户可以在个人中心切换不同工作台

## 功能架构

### 1. 系统配置（后端）
- **模型**: `SystemConfig` - 存储系统级配置
- **关键配置项**:
  - `merchant_certification_enabled` - 商家认证功能开关
  - `nutritionist_certification_enabled` - 营养师认证功能开关
  - `merchant_certification_mode` - 商家认证模式（contact/auto）
  - `nutritionist_certification_mode` - 营养师认证模式（contact/auto）
  - `certification_contact_wechat` - 客服微信号
  - `certification_contact_phone` - 客服电话
  - `certification_contact_email` - 客服邮箱

### 2. 权限管理（后端）
- **模型**: `UserPermission` - 管理用户特殊权限
- **权限类型**: merchant（商家）、nutritionist（营养师）
- **权限状态**: pending（待审核）、approved（已通过）、rejected（已拒绝）、revoked（已撤销）

### 3. 前端界面
- **联系认证页面**: `ContactCertificationPage` - 显示客服二维码和联系方式
- **权限管理页面**: `PermissionManagementPage` - 管理员审核权限申请
- **工作台切换**: `WorkspaceSwitcher` - 用户切换不同工作台

## 使用流程

### 用户端流程

1. **查看认证入口**
   - 用户在个人中心可以看到认证入口（前提是管理员已开启）
   - 商家认证和营养师认证分别显示

2. **联系客服申请**
   - 点击认证按钮后进入联系客服页面
   - 显示客服微信二维码、电话、邮箱
   - 用户扫码添加客服，提交相关资质

3. **获得权限后**
   - 个人中心显示工作台切换入口
   - 可以切换到商家工作台或营养师工作台
   - 不同工作台显示对应的功能菜单

### 管理员端流程

1. **配置认证功能**
   ```javascript
   // 开启/关闭认证功能
   PUT /api/admin/system-config/certification
   {
     "merchant_certification_enabled": true,
     "nutritionist_certification_enabled": true
   }
   
   // 更新客服联系方式
   PUT /api/admin/system-config/certification_contact_wechat
   {
     "value": "新的微信号"
   }
   ```

2. **管理权限申请**
   - 访问权限管理页面查看待审核申请
   - 可以批量审核或单个审核
   - 支持添加审核意见

3. **直接授权**
   ```javascript
   // 管理员可以直接给用户授权，无需申请流程
   await userPermissionService.grantPermissionDirectly(
     userId,
     'merchant', // 或 'nutritionist'
     adminId,
     '直接授权原因'
   );
   ```

## API 接口

### 系统配置相关
- `GET /api/system-config/public` - 获取公开配置（包含认证开关和联系方式）
- `GET /api/system-config/certification` - 获取认证功能配置
- `PUT /api/admin/system-config/:key` - 更新单个配置项
- `PUT /api/admin/system-config/certification` - 批量更新认证配置

### 权限管理相关
- `POST /api/user-permissions/apply` - 申请权限
- `GET /api/user-permissions/my-permissions` - 获取我的权限
- `GET /api/admin/user-permissions/pending` - 获取待审核申请（管理员）
- `PUT /api/admin/user-permissions/:id/review` - 审核权限申请（管理员）
- `POST /api/admin/user-permissions/grant` - 直接授予权限（管理员）

## 数据结构

### 权限申请数据
```javascript
{
  userId: ObjectId,
  permissionType: 'merchant' | 'nutritionist',
  status: 'pending' | 'approved' | 'rejected' | 'revoked',
  applicationData: {
    reason: String,
    contactInfo: {
      phone: String,
      email: String,
      wechat: String
    },
    qualifications: String
  },
  reviewData: {
    reviewComment: String,
    reviewedAt: Date,
    reviewedBy: ObjectId
  }
}
```

### 系统配置数据
```javascript
{
  key: String,
  value: Mixed,
  valueType: 'boolean' | 'string' | 'number' | 'json' | 'array',
  category: 'feature' | 'system' | 'business' | 'ui' | 'security',
  description: String,
  isPublic: Boolean,
  isEditable: Boolean
}
```

## 测试方法

1. **运行测试脚本**
   ```bash
   node test-certification-flow.js
   ```

2. **初始化系统配置**
   ```bash
   node backend/scripts/db/initializeSystemConfigs.js
   ```

3. **测试权限系统**
   ```bash
   node test-permission-system.js
   ```

## 注意事项

1. **权限安全**
   - 所有权限相关的API都需要相应的认证和授权
   - 管理员操作会记录操作人和时间

2. **配置缓存**
   - 前端会缓存系统配置，更新后可能需要刷新
   - 可以调用 `refreshConfigs()` 强制刷新

3. **工作台切换**
   - 用户必须有相应权限才能切换到对应工作台
   - 工作台状态会保存在本地存储中

4. **向后兼容**
   - 系统保留了旧版认证流程的兼容性配置
   - 可以通过 `legacy_certification_enabled` 开关控制

## 常见问题

**Q: 如何完全关闭认证功能？**
A: 将 `merchant_certification_enabled` 和 `nutritionist_certification_enabled` 都设置为 false

**Q: 用户已有权限但看不到工作台切换？**
A: 检查用户的权限状态是否为 'approved'，以及是否在有效期内

**Q: 如何批量授权？**
A: 使用管理员权限调用批量审核API，或编写脚本使用 `batchGrant` 方法

**Q: 客服二维码如何更新？**
A: 更新 `certification_contact_wechat` 配置项，前端会自动生成新的二维码