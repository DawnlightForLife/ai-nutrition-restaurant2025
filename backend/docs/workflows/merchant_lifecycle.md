# 商户生命周期

## 概述

本文档描述了商户从注册到运营全生命周期的业务流程，包括注册、审核、运营和管理各个阶段。

## 1. 商户注册阶段

### 1.1 用户注册
- 用户通过 `/api/auth/register` 接口注册账号
- 验证用户身份和邮箱
- 生成用户ID作为商户关联身份

### 1.2 商户信息申请
**接口** `POST /api/merchants`

**必填信息**
- 商户名称 (businessName)
- 商户类型 (businessType): 月子中心、健身房、学校公司等
- 注册号 (registrationNumber)
- 税务号 (taxId)
- 联系信息 (contact)
  - 邮箱 (email)
  - 电话 (phone)
- 地址信息 (address)
  - 省 (province)
  - 市 (city)
  - 区 (district)
  - 详细地址 (line1)
  - 邮编 (postalCode)

**可选信息**
- 商户简介 (businessProfile.description)
- 营养特色 (nutritionFeatures)
- 商户设置 (merchantSettings)
- 支付设置 (paymentSettings)

### 1.3 初始状态
- `verification.verificationStatus = 'pending'`
- `verification.isVerified = false`
- `accountStatus.isActive = false`
- `accountStatus.isPaused = false`

## 2. 审核阶段

### 2.1 审核流程
- 管理员通过 `/api/merchants?verificationStatus=pending` 获取待审核商户列表
- 查看商户详细信息
- 审核申请资料的真实性

### 2.2 审核决定
**接口** `PUT /api/merchants/:id/verify`

**审核结果**

#### 2.2.1 通过审核
```json
{
  "verificationStatus": "approved",
  "verifiedBy": "管理员ID",
  "verifiedAt": "审核时间"
}
```

**状态变更**
- `verification.isVerified = true`
- `accountStatus.isActive = true`
- 触发 `onMerchantApproved` Hook

#### 2.2.2 拒绝申请
```json
{
  "verificationStatus": "rejected",
  "rejectionReason": "拒绝原因说明",
  "verifiedBy": "管理员ID",
  "verifiedAt": "审核时间"
}
```

**状态变更**
- `verification.isVerified = false`
- `accountStatus.isActive = false`
- 商户可重新申请

### 2.3 审核要点
- 营养资质检查
- 地址信息验证
- 联系方式确认
- 商户类型与营养服务匹配度
- 证照真实性

## 3. 商户运营阶段

### 3.1 账户激活
- 审核通过后激活
- 商户可登录系统
- 开始配置运营信息

### 3.2 基础配置
- 完善商户资料
- 设置营养服务
- 配置营养师
- 设置菜品

### 3.3 服务提供
- 发布营养信息
- 配置营养方案
- 菜品营养标注
- 对接AI营养推荐

## 4. 运营数据

### 4.1 订单数据
- 服务订单
- 用户评价
- 营养订单统计
- 收入数据

### 4.2 用户数据
- 注册用户数
- 活跃用户量
- 营养咨询量
- 用户反馈

### 4.3 服务数据
- 服务完成率
- 菜品点击率
- 用户满意度
- 营养师评分

## 5. 账户管理

### 5.1 暂停账户
**触发条件**
- 违规经营
- 用户投诉
- 服务质量下降
- 活跃度长期低下

**操作** `accountStatus.isPaused = true`

### 5.2 恢复账户
**条件**
- 整改完成
- 重新审核
- 确认符合规范

**操作** `accountStatus.isPaused = false`

### 5.3 关闭账户
**触发条件**
- 营养违规
- 商户主动申请
- 活跃度为零

**操作** `accountStatus.isActive = false`

## 6. 订单与数据

### 6.1 订单状态跟踪
- 服务订单数据7天
- 用户订单数据30天
- 月度订单数据10个月
- 营养订单数据5年

### 6.2 订单导出
- 商户申请导出订单数据
- 支持JSON、CSV、Excel格式
- 定期备份

## 7. Hook事件系统

### 7.1 生命周期事件
- `onMerchantRegistered`: 商户注册完成
- `onMerchantApproved`: 审核通过完成
- `onMerchantRejected`: 审核拒绝完成
- `onMerchantActivated`: 账户激活完成
- `onMerchantSuspended`: 账户暂停完成
- `onMerchantClosed`: 账户关闭完成

### 7.2 事件处理
- 发送通知
- 记录日志
- 更新相关信息
- 触发其他业务流程

## 8. API接口列表

| 功能 | 方法 | 路径 | 权限 |
|------|------|------|------|
| 注册商户 | POST | `/api/merchants` | 用户 |
| 获取商户列表 | GET | `/api/merchants` | 管理员 |
| 获取商户详情 | GET | `/api/merchants/:id` | 管理员 |
| 更新商户信息 | PUT | `/api/merchants/:id` | 商户自己 |
| 审核商户 | PUT | `/api/merchants/:id/verify` | 管理员 |
| 删除商户 | DELETE | `/api/merchants/:id` | 管理员 |
| 获取当前商户 | GET | `/api/merchants/current` | 商户 |
| 获取统计数据 | GET | `/api/merchants/stats` | 管理员 |

## 9. 异常处理

### 9.1 审核异常
- 资料不真实
- 联系方式无效
- 重复申请

### 9.2 账户异常
- 联系方式变更
- 经营范围变化
- 申请恢复

### 9.3 订单异常
- 数据统计异常
- 联系方式无效
- 经营状态异常

## 10. 文档版本信息

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| 1.0 | 2025-01-09 | 初始版本，完善商户生命周期流程 |

---

**创建者** 系统  
**创建时间** 2025年1月9日  
**审核者** 系统管理