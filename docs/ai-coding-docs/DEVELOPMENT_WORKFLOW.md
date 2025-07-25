# AI智能营养餐厅系统 - 完整开发流程文档

> **文档版本**: 2.0.0 - 文档串联版  
> **创建日期**: 2025-07-12  
> **更新日期**: 2025-07-12  
> **文档状态**: ✅ 文档体系串联完成  
> **目标受众**: 项目经理、技术负责人、开发团队、测试团队
> 
> 🎆 **新增特性**: 所有开发模块均已与相关文档完全串联，实现文档体系一体化指导

## 📚 文档串联体系

本开发流程文档已与ai-coding-docs中的所有相关文档完全串联，形成了一个统一的文档体系。每个开发阶段都明确指出了需要参考的具体文档，确保开发团队能够快速定位到所需的技术规范和设计指导。

### 🔗 核心文档引用统计

- **业务需求文档**: 8次引用
- **技术架构文档**: 12次引用  
- **API接口规范**: 15次引用
- **UI/UX设计文档**: 18次引用
- **团队协作文档**: 6次引用
- **测试策略文档**: 10次引用

## 📋 目录

- [1. 开发流程概述](#1-开发流程概述)
- [2. 模块开发顺序](#2-模块开发顺序)
- [3. 开发阶段详解](#3-开发阶段详解)
- [4. 测试策略](#4-测试策略)
- [5. 质量控制流程](#5-质量控制流程)
- [6. 代码审查规范](#6-代码审查规范)
- [7. 持续集成/持续部署](#7-持续集成持续部署)
- [8. 项目管理](#8-项目管理)
- [9. 风险管理](#9-风险管理)
- [10. 发布管理](#10-发布管理)
- [11. 文档引用索引](#11-文档引用索引)

---

## 1. 开发流程概述

### 1.1 项目架构分析

> 📚 **参考文档**: [TECHNICAL_STACK_UNIFIED.md](./technical/TECHNICAL_STACK_UNIFIED.md)
> 📚 **架构设计**: [FRONTEND_ARCHITECTURE.md](./technical/FRONTEND_ARCHITECTURE.md)

```yaml
技术架构分层:
  前端层:
    - Flutter移动应用 (用户端)
    - React管理后台 (商家/营养师/管理员)
    
  后端层:
    - NestJS API服务
    - PostgreSQL + pgvector数据库
    - Redis缓存
    - WebSocket实时通信
    
  AI服务层:
    - LangChain + DeepSeek API
    - 向量搜索服务
    - 营养分析引擎
    
  基础设施层:
    - Docker容器化
    - 云托管服务
    - 监控和日志系统
```

### 1.2 开发方法论

> 📚 **团队协作**: [TEAM_COLLABORATION_GUIDE.md](./TEAM_COLLABORATION_GUIDE.md)
> 📚 **环境配置**: [DEVELOPMENT_SETUP_GUIDE.md](./DEVELOPMENT_SETUP_GUIDE.md)

```yaml
开发模式:
  主要方法: Agile + TDD (测试驱动开发)
  迭代周期: 2周一个Sprint
  代码管理: GitFlow工作流
  部署策略: 蓝绿部署 + 金丝雀发布
  
核心原则:
  - 先写测试，再写代码
  - 持续集成，频繁部署
  - 代码覆盖率 ≥ 85%
  - 自动化测试 + 手动测试
  - 文档同步更新
```

---

## 2. 模块开发顺序

### 2.1 第一阶段：基础架构 (Week 1-2)

> 📚 **技术栈规范**: [TECHNICAL_STACK_UNIFIED.md](./technical/TECHNICAL_STACK_UNIFIED.md)
> 📚 **API接口设计**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml)
> 📚 **环境配置指南**: [DEVELOPMENT_SETUP_GUIDE.md](./DEVELOPMENT_SETUP_GUIDE.md)

```yaml
优先级: P0 (必须完成)
目标: 建立项目骨架和核心基础设施

后端基础模块:
  1. 项目脚手架搭建:
    - NestJS项目初始化
    - 目录结构创建
    - 基础配置文件
    - Docker环境配置
    📚 参考: DEVELOPMENT_SETUP_GUIDE.md 第2节
    
  2. 数据库架构:
    - PostgreSQL数据库设计
    - pgvector扩展安装
    - 数据库迁移脚本
    - 连接池配置
    📚 参考: DEVELOPMENT_SETUP_GUIDE.md 第4节
    
  3. 认证授权系统:
    - JWT Token管理
    - 用户角色权限
    - 中间件设计
    - 安全配置
    📚 参考: COMPLETE_API_SPEC.yaml Authentication部分
    
  4. 核心中间件:
    - 日志中间件
    - 错误处理中间件
    - 限流中间件
    - CORS配置
    📚 参考: TECHNICAL_STACK_UNIFIED.md 第6节

前端基础模块:
  1. Flutter项目初始化:
    - 项目脚手架
    - 目录结构
    - 依赖包配置
    - 构建配置
    📚 参考: FRONTEND_ARCHITECTURE.md 第2节 + DEVELOPMENT_SETUP_GUIDE.md 第3节
    
  2. 状态管理基础:
    - Riverpod 3.0 配置
    - Provider架构
    - 状态持久化
    - 异常处理
    📚 参考: FRONTEND_ARCHITECTURE.md 第3节 + TECHNICAL_STACK_UNIFIED.md 第4节
    
  3. 路由导航:
    - 页面路由配置
    - 导航守卫
    - 深度链接
    - 页面转场动画
    📚 参考: FRONTEND_ARCHITECTURE.md 第4节
    
  4. 网络请求层:
    - Dio HTTP客户端
    - 请求拦截器
    - 错误处理
    - 缓存策略
    📚 参考: FRONTEND_ARCHITECTURE.md 第5节 + COMPLETE_API_SPEC.yaml

测试要求:
  - 单元测试覆盖率 ≥ 90%
  - 集成测试核心路径
  - 端到端测试主要功能
  - 性能基准测试
```

### 2.2 第二阶段：用户管理 (Week 3-4)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第3.1节
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) User Management部分
> 📚 **UI设计**: [UI_PAGE_DESIGN_COMPLETE.md](./frontend/UI_PAGE_DESIGN_COMPLETE.md) 用户模块

```yaml
优先级: P0 (必须完成)
目标: 实现用户注册、登录、个人资料管理

后端模块:
  1. 用户认证API:
    - 手机验证码登录
    - JWT Token刷新
    - 用户会话管理
    - 多端登录控制
    📚 参考: COMPLETE_API_SPEC.yaml Authentication部分
    📚 参考: BUSINESS_REQUIREMENTS.md 智能用户认证章节
    
  2. 用户档案管理:
    - 用户信息CRUD
    - 头像上传
    - 个人偏好设置
    - 数据验证
    📚 参考: COMPLETE_API_SPEC.yaml User Management部分
    📚 参考: BUSINESS_REQUIREMENTS.md 第4.1节
    
  3. 权限控制:
    - 基于角色的访问控制(RBAC)
    - 权限中间件
    - 资源授权
    - 操作审计日志
    📚 参考: COMPLETE_API_SPEC.yaml Authorization部分

前端模块:
  1. 认证流程:
    - 登录页面
    - 验证码输入
    - 自动登录
    - 登出功能
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 认证页面设计
    📚 参考: FRONTEND_ARCHITECTURE.md 第7.1节认证模块
    📚 参考: AUTHENTICATION_FLOW_DESIGN.md
    
  2. 用户资料:
    - 个人信息页面
    - 头像上传组件
    - 设置页面
    - 偏好配置
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 用户中心设计
    📚 参考: COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md 用户组件
    📚 参考: FILE_UPLOAD_HANDLING_GUIDE.md
    
  3. 权限管理:
    - 路由权限控制
    - 组件权限显示
    - 操作权限检查
    - 权限异常处理
    📚 参考: FRONTEND_ARCHITECTURE.md 第9节权限控制
    📚 参考: ERROR_HANDLING_UI_GUIDE.md

测试用例:
  - 用户注册流程测试
  - 登录/登出功能测试
  - Token刷新机制测试
  - 权限控制测试
  - 用户信息更新测试
  - 并发登录测试
  - 安全漏洞测试
```

### 2.3 第三阶段：营养档案系统 (Week 5-6)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.2节
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Nutrition Profile部分
> 📚 **UI设计**: [UI_PAGE_DESIGN_COMPLETE.md](./frontend/UI_PAGE_DESIGN_COMPLETE.md) 营养档案模块
> 📚 **数据模型**: [DATA_MODEL_DESIGN.md](./technical/DATA_MODEL_DESIGN.md)

```yaml
优先级: P0 (必须完成)
目标: 实现用户营养档案的创建、管理和分析

后端模块:
  1. 营养档案数据模型:
    - 用户基础信息
    - 健康指标数据
    - 饮食偏好设置
    - 健康目标配置
    📚 参考: BUSINESS_REQUIREMENTS.md 灵活营养档案管理章节
    📚 参考: DATA_MODEL_DESIGN.md 营养档案模型
    
  2. 营养档案API:
    - 档案CRUD操作
    - 数据验证规则
    - 档案查询接口
    - 批量操作支持
    
  3. 健康数据分析:
    - BMI计算
    - 基础代谢率计算
    - 营养需求分析
    - 健康风险评估

前端模块:
  1. 档案创建向导:
    - 分步表单设计
    - 数据输入验证
    - 进度指示器
    - 数据本地暂存
    
  2. 档案管理界面:
    - 档案列表展示
    - 档案详情页面
    - 编辑功能
    - 删除确认
    
  3. 健康分析展示:
    - 健康指标图表
    - 营养需求展示
    - 目标进度追踪
    - 建议提示

测试策略:
  - 数据模型验证测试
  - API接口功能测试
  - 表单验证测试
  - 数据计算准确性测试
  - UI响应式测试
  - 数据同步测试
```

### 2.4 第四阶段：AI营养推荐 (Week 7-9)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.3节 AI分析引擎
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) AI Services部分
> 📚 **技术架构**: [TECHNICAL_STACK_UNIFIED.md](./technical/TECHNICAL_STACK_UNIFIED.md) 第8节 AI服务
> 📚 **AI集成**: [AI_SERVICE_INTEGRATION.md](./technical/AI_SERVICE_INTEGRATION.md) 完整配置指南
> 📚 **降级监控**: [AI_SERVICE_FALLBACK_MONITORING.md](./technical/AI_SERVICE_FALLBACK_MONITORING.md) 高可用保障
> 📚 **UI设计**: [AI_INTERACTION_DESIGN.md](./frontend/AI_INTERACTION_DESIGN.md)

```yaml
优先级: P0 (必须完成)
目标: 集成AI服务，实现个性化营养推荐

后端模块:
  1. AI服务集成:
    - LangChain框架配置
    - DeepSeek API接入
    - 向量数据库集成
    - 提示词工程
    📚 参考: TECHNICAL_STACK_UNIFIED.md AI服务配置
    📚 参考: BUSINESS_REQUIREMENTS.md AI集成架构
    
  2. 推荐算法:
    - 用户画像分析
    - 营养需求计算
    - 菜品匹配算法
    - 推荐结果排序
    📚 参考: COMPLETE_API_SPEC.yaml AI推荐接口
    
  3. 推荐API:
    - 实时推荐接口
    - 推荐历史记录
    - 推荐反馈收集
    - 推荐效果分析
    📚 参考: COMPLETE_API_SPEC.yaml Recommendation部分

前端模块:
  1. 推荐请求界面:
    - 推荐参数设置
    - 偏好选择器
    - 位置服务集成
    - 实时推荐触发
    📚 参考: AI_INTERACTION_DESIGN.md 推荐交互流程
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md AI推荐页面
    
  2. 推荐结果展示:
    - 推荐卡片设计
    - 营养信息展示
    - 推荐理由说明
    - 操作按钮组
    📚 参考: COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md 推荐组件
    📚 参考: DATA_VISUALIZATION_DESIGN.md 营养数据展示
    
  3. 交互反馈:
    - 喜欢/不喜欢反馈
    - 推荐理由查看
    - 分享功能
    - 收藏功能
    📚 参考: AI_INTERACTION_DESIGN.md 反馈机制设计
    📚 参考: MICRO_INTERACTION_DESIGN.md 微交互效果

AI服务测试:
  - API响应时间测试
  - 推荐准确性测试
  - 大并发推荐测试
  - 推荐多样性测试
  - A/B测试框架
  - 推荐效果监控
```

### 2.5 第五阶段：商家与菜品管理 (Week 10-12)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.6节 商家智能管理
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Merchant Management部分
> 📚 **UI设计**: [MERCHANT_BACKEND_DESIGN.md](./frontend/MERCHANT_BACKEND_DESIGN.md)
> 📚 **权限设计**: [USER_PERMISSION_SYSTEM_DESIGN.md](./frontend/USER_PERMISSION_SYSTEM_DESIGN.md)

```yaml
优先级: P1 (重要功能)
目标: 实现商家入驻、菜品管理、库存管理

后端模块:
  1. 商家管理系统:
    - 商家注册审核
    - 商家信息管理
    - 营业状态控制
    - 商家评级系统
    📚 参考: BUSINESS_REQUIREMENTS.md 商家管理规则
    📚 参考: COMPLETE_API_SPEC.yaml Merchant Registration
    
  2. 菜品管理:
    - 菜品信息CRUD
    - 营养成分录入
    - 图片上传管理
    - 价格策略设置
    📚 参考: COMPLETE_API_SPEC.yaml Dish Management部分
    📚 参考: BUSINESS_REQUIREMENTS.md 菜品管理规则
    
  3. 库存管理:
    - 实时库存更新
    - 库存预警系统
    - 自动下架机制
    - 库存历史记录
    📚 参考: BUSINESS_REQUIREMENTS.md AI库存管理章节

前端模块:
  1. 商家后台(React):
    - 商家注册流程
    - 商家信息管理
    - 经营数据看板
    - 订单管理中心
    📚 参考: MERCHANT_BACKEND_DESIGN.md 商家后台设计
    📚 参考: USER_PERMISSION_SYSTEM_DESIGN.md 商家权限
    
  2. 菜品管理界面:
    - 菜品录入表单
    - 营养成分计算器
    - 图片批量上传
    - 菜品状态管理
    📚 参考: COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md 表单组件
    📚 参考: FILE_UPLOAD_HANDLING_GUIDE.md 文件上传
    
  3. 用户端展示:
    - 商家列表页面
    - 商家详情页面
    - 菜品浏览界面
    - 搜索筛选功能
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 商家页面设计
    📚 参考: SEARCH_FILTER_DESIGN.md 搜索筛选功能

测试重点:
  - 商家注册流程测试
  - 菜品信息准确性测试
  - 库存同步测试
  - 图片上传性能测试
  - 搜索功能测试
  - 多商家并发测试
```

### 2.6 第六阶段：订单与支付 (Week 13-15)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.4节 智能点餐
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Order & Payment部分
> 📚 **UI设计**: [ORDER_FLOW_DESIGN.md](./frontend/ORDER_FLOW_DESIGN.md)
> 📚 **支付集成**: [PAYMENT_INTEGRATION_GUIDE.md](./technical/PAYMENT_INTEGRATION_GUIDE.md)

```yaml
优先级: P1 (重要功能)
目标: 实现完整的订单流程和支付系统

后端模块:
  1. 订单管理:
    - 订单创建流程
    - 订单状态管理
    - 订单修改取消
    - 订单历史查询
    📚 参考: BUSINESS_REQUIREMENTS.md 订单系统规则
    📚 参考: COMPLETE_API_SPEC.yaml Order Management
    
  2. 购物车系统:
    - 购物车CRUD
    - 商品数量控制
    - 价格计算
    - 优惠券应用
    📚 参考: COMPLETE_API_SPEC.yaml Shopping Cart
    
  3. 支付集成:
    - 第三方支付接入
    - 支付状态回调
    - 退款处理
    - 支付安全控制
    📚 参考: BUSINESS_REQUIREMENTS.md 第三方支付集成
    📚 参考: PAYMENT_INTEGRATION_GUIDE.md

前端模块:
  1. 购物车功能:
    - 商品添加删除
    - 数量调整
    - 价格实时计算
    - 清空购物车
    📚 参考: ORDER_FLOW_DESIGN.md 购物车交互设计
    📚 参考: COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md 购物车组件
    
  2. 订单流程:
    - 订单确认页面
    - 配送信息填写
    - 支付方式选择
    - 订单提交
    📚 参考: ORDER_FLOW_DESIGN.md 订单流程设计
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 订单页面
    
  3. 订单管理:
    - 订单列表展示
    - 订单详情查看
    - 订单状态跟踪
    - 评价系统
    📚 参考: ORDER_TRACKING_DESIGN.md 订单跟踪设计
    📚 参考: DATA_SYNC_STATUS_DISPLAY_GUIDE.md 状态显示

支付安全测试:
  - 支付流程完整性测试
  - 支付安全性测试
  - 异常情况处理测试
  - 并发支付测试
  - 退款流程测试
  - 财务对账测试
```

### 2.7 第七阶段：营养师咨询 (Week 16-18)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.5节 营养师AI辅助
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Nutritionist Service部分
> 📚 **UI设计**: [NUTRITIONIST_WORKSTATION_DESIGN.md](./frontend/NUTRITIONIST_WORKSTATION_DESIGN.md)
> 📚 **实时通信**: [WEBSOCKET_IMPLEMENTATION_GUIDE.md](./technical/WEBSOCKET_IMPLEMENTATION_GUIDE.md)

```yaml
优先级: P1 (重要功能)
目标: 实现营养师在线咨询服务

后端模块:
  1. 营养师管理:
    - 营养师认证
    - 资质审核
    - 服务价格设置
    - 工作时间管理
    📚 参考: BUSINESS_REQUIREMENTS.md 营养师管理规则
    📚 参考: USER_PERMISSION_SYSTEM_DESIGN.md 营养师权限
    
  2. 咨询预约系统:
    - 预约时间管理
    - 冲突检测
    - 预约状态控制
    - 自动提醒功能
    📚 参考: COMPLETE_API_SPEC.yaml Appointment System
    
  3. 实时通信:
    - WebSocket消息服务
    - 聊天记录存储
    - 文件传输支持
    - 音视频通话
    📚 参考: WEBSOCKET_IMPLEMENTATION_GUIDE.md
    📚 参考: FRONTEND_ARCHITECTURE.md 第12节 WebSocket实时通信

前端模块:
  1. 营养师平台:
    - 营养师注册
    - 个人资料管理
    - 咨询记录管理
    - 收入统计
    📚 参考: NUTRITIONIST_WORKSTATION_DESIGN.md 工作台设计
    📚 参考: USER_PERMISSION_SYSTEM_DESIGN.md 营养师权限
    
  2. 用户咨询界面:
    - 营养师选择
    - 预约时间选择
    - 实时聊天界面
    - 咨询历史记录
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 咨询页面设计
    📚 参考: REAL_TIME_COMMUNICATION_DESIGN.md
    
  3. 实时通信功能:
    - 消息发送接收
    - 图片文件发送
    - 在线状态显示
    - 消息已读状态
    📚 参考: WEBSOCKET_IMPLEMENTATION_GUIDE.md 客户端实现
    📚 参考: REAL_TIME_COMMUNICATION_DESIGN.md

实时通信测试:
  - WebSocket连接稳定性测试
  - 消息传输可靠性测试
  - 大并发通信测试
  - 断线重连测试
  - 消息同步测试
  - 音视频质量测试
```

### 2.8 第八阶段：社区论坛 (Week 19-20)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 第4.7节 社区交流
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Community Forum部分
> 📚 **UI设计**: [COMMUNITY_FORUM_DESIGN.md](./frontend/COMMUNITY_FORUM_DESIGN.md)
> 📚 **内容审核**: [CONTENT_MODERATION_GUIDE.md](./technical/CONTENT_MODERATION_GUIDE.md)

```yaml
优先级: P2 (可选功能)
目标: 实现用户互动社区

后端模块:
  1. 论坛系统:
    - 帖子发布管理
    - 评论回复系统
    - 点赞收藏功能
    - 内容审核机制
    📚 参考: BUSINESS_REQUIREMENTS.md 社区功能规则
    📚 参考: CONTENT_MODERATION_GUIDE.md
    
  2. 用户互动:
    - 关注功能
    - 私信系统
    - 积分体系
    - 等级系统
    📚 参考: COMPLETE_API_SPEC.yaml User Interaction

前端模块:
  1. 论坛界面:
    - 帖子列表
    - 帖子详情
    - 发布编辑
    - 搜索功能
    📚 参考: COMMUNITY_FORUM_DESIGN.md 论坛界面设计
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 社区页面
    
  2. 用户互动:
    - 评论区域
    - 点赞按钮
    - 分享功能
    - 举报功能
    📚 参考: MICRO_INTERACTION_DESIGN.md 互动效果
    📚 参考: COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md 互动组件

测试策略:
  - 内容发布测试
  - 用户互动测试
  - 内容审核测试
  - 大并发访问测试
```

### 2.9 第九阶段：通知与消息 (Week 21-22)

> 📚 **业务需求**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md) 消息通知需求
> 📚 **API接口**: [COMPLETE_API_SPEC.yaml](./technical/COMPLETE_API_SPEC.yaml) Notification部分
> 📚 **UI设计**: [NOTIFICATION_SYSTEM_DESIGN.md](./frontend/NOTIFICATION_SYSTEM_DESIGN.md)
> 📚 **推送服务**: [PUSH_NOTIFICATION_GUIDE.md](./technical/PUSH_NOTIFICATION_GUIDE.md)

```yaml
优先级: P1 (重要功能)
目标: 实现完整的消息通知系统

后端模块:
  1. 消息推送:
    - 推送服务配置
    - 消息模板管理
    - 推送策略控制
    - 送达率统计
    📚 参考: PUSH_NOTIFICATION_GUIDE.md
    📚 参考: COMPLETE_API_SPEC.yaml Push Service
    
  2. 站内消息:
    - 消息分类管理
    - 消息状态控制
    - 消息历史记录
    - 批量操作
    📚 参考: COMPLETE_API_SPEC.yaml Message System

前端模块:
  1. 通知中心:
    - 消息列表
    - 消息详情
    - 消息标记
    - 消息设置
    📚 参考: NOTIFICATION_SYSTEM_DESIGN.md 通知中心设计
    📚 参考: UI_PAGE_DESIGN_COMPLETE.md 消息页面
    
  2. 推送功能:
    - 推送权限请求
    - 推送接收处理
    - 推送点击响应
    - 推送设置管理
    📚 参考: PUSH_NOTIFICATION_GUIDE.md 客户端实现
    📚 参考: FRONTEND_ARCHITECTURE.md 消息状态管理

通知测试:
  - 推送到达率测试
  - 推送时效性测试
  - 推送内容准确性测试
  - 推送权限测试
```

---

---

## 3. 开发阶段详解

### 3.1 需求分析阶段

> 📚 **参考文档**: [BUSINESS_REQUIREMENTS.md](./business/BUSINESS_REQUIREMENTS.md)
> 📚 **用户研究**: [USER_RESEARCH_ANALYSIS.md](./business/USER_RESEARCH_ANALYSIS.md)
> 📚 **竞品分析**: [COMPETITOR_ANALYSIS.md](./business/COMPETITOR_ANALYSIS.md)

```yaml
时间安排: 每个模块开发前1-2天
输出物:
  - 详细需求文档
  - API接口设计
  - 数据库设计
  - UI/UX设计稿
  - 测试用例设计

工作流程:
  1. 需求梳理:
    - 业务需求分析
    - 功能点拆解
    - 用户故事编写
    - 验收标准定义
    
  2. 技术设计:
    - 架构设计评审
    - API接口设计
    - 数据模型设计
    - 技术方案选型
    
  3. UI/UX设计:
    - 原型图设计
    - 交互流程设计
    - 视觉设计稿
    - 设计规范检查
    
  4. 测试计划:
    - 测试用例编写
    - 测试数据准备
    - 测试环境准备
    - 自动化测试设计
```

### 3.2 开发实施阶段

> 📚 **团队协作**: [TEAM_COLLABORATION_GUIDE.md](./TEAM_COLLABORATION_GUIDE.md) 第4节
> 📚 **代码规范**: [FRONTEND_ARCHITECTURE.md](./technical/FRONTEND_ARCHITECTURE.md) 第13节
> 📚 **Git工作流**: [TEAM_COLLABORATION_GUIDE.md](./TEAM_COLLABORATION_GUIDE.md) 第3节

```yaml
开发模式: TDD (测试驱动开发)

工作流程:
  1. 红灯阶段 (Red):
    - 编写失败的测试用例
    - 明确功能期望行为
    - 确保测试用例有效
    
  2. 绿灯阶段 (Green):
    - 编写最小可用代码
    - 使测试用例通过
    - 不过度设计
    
  3. 重构阶段 (Refactor):
    - 优化代码结构
    - 消除重复代码
    - 提高代码质量
    - 保持测试通过

代码提交规范:
  - 提交信息格式: type(scope): description
  - 提交类型: feat, fix, docs, style, refactor, test, chore
  - 每次提交保持原子性
  - 提交前运行完整测试套件
  📚 参考: TEAM_COLLABORATION_GUIDE.md 第4节 代码提交规范
```

### 3.3 代码审查阶段

> 📚 **审查流程**: [TEAM_COLLABORATION_GUIDE.md](./TEAM_COLLABORATION_GUIDE.md) 第5节
> 📚 **质量标准**: [CODE_QUALITY_STANDARDS.md](./technical/CODE_QUALITY_STANDARDS.md)
> 📚 **安全检查**: [SECURITY_REVIEW_CHECKLIST.md](./technical/SECURITY_REVIEW_CHECKLIST.md)

```yaml
审查要求:
  - 所有代码必须经过代码审查
  - 至少需要2名审查者同意
  - 审查者不能是代码作者
  - 必须通过自动化检查
  📚 参考: TEAM_COLLABORATION_GUIDE.md 代码审查流程

审查检查点:
  功能正确性:
    - 是否满足需求规格
    - 边界条件处理
    - 异常情况处理
    - 业务逻辑正确性
    
  代码质量:
    - 代码可读性
    - 命名规范
    - 注释完整性
    - 代码复杂度
    
  架构设计:
    - 模块职责清晰
    - 依赖关系合理
    - 接口设计合理
    - 扩展性考虑
    
  安全性:
    - 输入验证
    - 权限检查
    - 敏感信息保护
    - SQL注入防护
    
  性能:
    - 算法复杂度
    - 数据库查询优化
    - 内存使用
    - 并发处理
```

### 3.4 测试验证阶段

> 📚 **测试策略**: [TESTING_STRATEGY_GUIDE.md](./technical/TESTING_STRATEGY_GUIDE.md)
> 📚 **测试框架**: [FRONTEND_ARCHITECTURE.md](./technical/FRONTEND_ARCHITECTURE.md) 第10节
> 📚 **API测试**: [API_TESTING_GUIDE.md](./technical/API_TESTING_GUIDE.md)

```yaml
测试层次:
  1. 单元测试:
    - 覆盖率要求: ≥85%
    - 测试框架: Jest (后端), Flutter Test (前端)
    - 测试内容: 函数、方法、组件
    - 执行频率: 每次代码提交
    📚 参考: TESTING_STRATEGY_GUIDE.md 单元测试章节
    
  2. 集成测试:
    - 测试模块间交互
    - API接口测试
    - 数据库操作测试
    - 第三方服务集成测试
    
  3. 端到端测试:
    - 用户场景测试
    - 关键路径测试
    - 跨平台兼容性测试
    - 性能基准测试
    
  4. 用户验收测试:
    - 业务场景验证
    - 用户体验测试
    - 可用性测试
    - 兼容性测试

自动化测试策略:
  - 单元测试: 100% 自动化
  - 集成测试: 80% 自动化
  - 端到端测试: 60% 自动化
  - 回归测试: 100% 自动化
```

---

## 4. 测试策略

> 📚 **测试策略指南**: [TESTING_STRATEGY_GUIDE.md](./technical/TESTING_STRATEGY_GUIDE.md)
> 📚 **自动化测试**: [AUTOMATED_TESTING_SETUP.md](./technical/AUTOMATED_TESTING_SETUP.md)
> 📚 **性能测试**: [PERFORMANCE_TESTING_GUIDE.md](./technical/PERFORMANCE_TESTING_GUIDE.md)

### 4.1 测试金字塔

```yaml
测试比例分配:
  单元测试: 70%
    - 快速执行
    - 低成本维护
    - 高覆盖率
    - 快速反馈
    📚 参考: TESTING_STRATEGY_GUIDE.md 测试金字塔理论
    
  集成测试: 20%
    - 模块交互验证
    - API接口测试
    - 数据库集成
    - 外部服务集成
    📚 参考: TESTING_STRATEGY_GUIDE.md 集成测试章节
    
  端到端测试: 10%
    - 用户场景验证
    - 关键路径测试
    - 跨系统集成
    - 用户体验验证
    📚 参考: E2E_TESTING_GUIDE.md 端到端测试
```

### 4.2 后端测试策略

> 📚 **NestJS测试**: [NESTJS_TESTING_GUIDE.md](./technical/NESTJS_TESTING_GUIDE.md)
> 📚 **数据库测试**: [DATABASE_TESTING_GUIDE.md](./technical/DATABASE_TESTING_GUIDE.md)
> 📚 **API测试**: [API_TESTING_GUIDE.md](./technical/API_TESTING_GUIDE.md)

```typescript
// 单元测试示例
// 📚 参考: NESTJS_TESTING_GUIDE.md 服务测试章节
describe('UserService', () => {
  let service: UserService;
  let repository: MockUserRepository;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useClass: MockUserRepository,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    repository = module.get<MockUserRepository>(UserRepository);
  });

  describe('createUser', () => {
    it('should create user successfully', async () => {
      // Arrange
      const userData = {
        phone: '13800138000',
        nickname: 'testuser',
      };
      
      repository.save.mockResolvedValue({ id: '1', ...userData });

      // Act
      const result = await service.createUser(userData);

      // Assert
      expect(result).toMatchObject({
        id: '1',
        phone: '13800138000',
        nickname: 'testuser',
      });
      expect(repository.save).toHaveBeenCalledWith(userData);
    });

    it('should throw error when phone already exists', async () => {
      // Arrange
      const userData = {
        phone: '13800138000',
        nickname: 'testuser',
      };
      
      repository.findByPhone.mockResolvedValue({ id: '2', phone: '13800138000' });

      // Act & Assert
      await expect(service.createUser(userData)).rejects.toThrow(
        ConflictException
      );
    });
  });
});

// 集成测试示例
describe('UserController (Integration)', () => {
  let app: INestApplication;
  let userRepository: Repository<User>;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    userRepository = moduleFixture.get<Repository<User>>(getRepositoryToken(User));
    
    await app.init();
  });

  beforeEach(async () => {
    await userRepository.clear();
  });

  describe('POST /auth/register', () => {
    it('should register user successfully', async () => {
      const userData = {
        phone: '13800138000',
        password: 'password123',
        nickname: 'testuser',
      };

      const response = await request(app.getHttpServer())
        .post('/auth/register')
        .send(userData)
        .expect(201);

      expect(response.body).toMatchObject({
        success: true,
        data: {
          user: {
            phone: '13800138000',
            nickname: 'testuser',
          },
          tokens: {
            accessToken: expect.any(String),
            refreshToken: expect.any(String),
          },
        },
      });

      // 验证数据库中确实创建了用户
      const user = await userRepository.findOne({
        where: { phone: '13800138000' },
      });
      expect(user).toBeDefined();
      expect(user.nickname).toBe('testuser');
    });

    it('should return error for duplicate phone', async () => {
      // 先创建一个用户
      await userRepository.save({
        phone: '13800138000',
        passwordHash: 'hashedpassword',
        nickname: 'existing',
      });

      const userData = {
        phone: '13800138000',
        password: 'password123',
        nickname: 'testuser',
      };

      const response = await request(app.getHttpServer())
        .post('/auth/register')
        .send(userData)
        .expect(409);

      expect(response.body).toMatchObject({
        success: false,
        error: {
          code: 'CONFLICT',
          message: '手机号已存在',
        },
      });
    });
  });
});
```

### 4.3 前端测试策略

```dart
// Flutter单元测试示例
void main() {
  group('NutritionNotifier', () {
    late NutritionNotifier notifier;
    late MockNutritionRepository mockRepository;
    late ProviderContainer container;

    setUp(() {
      mockRepository = MockNutritionRepository();
      container = ProviderContainer(
        overrides: [
          nutritionRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      notifier = container.read(nutritionNotifierProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('should load nutrition records successfully', () async {
      // Arrange
      final mockRecords = [
        NutritionRecord((b) => b
          ..id = '1'
          ..foodName = 'Apple'
          ..calories = 52),
      ];
      
      when(() => mockRepository.getRecords())
          .thenAnswer((_) async => mockRecords);

      // Act
      await notifier.loadRecords();

      // Assert
      final state = container.read(nutritionNotifierProvider);
      expect(state.isLoading, false);
      expect(state.records.length, 1);
      expect(state.records.first.foodName, 'Apple');
      verify(() => mockRepository.getRecords()).called(1);
    });

    test('should handle load error', () async {
      // Arrange
      when(() => mockRepository.getRecords())
          .thenThrow(Exception('Network error'));

      // Act
      await notifier.loadRecords();

      // Assert
      final state = container.read(nutritionNotifierProvider);
      expect(state.isLoading, false);
      expect(state.error, isNotNull);
      expect(state.error, contains('Network error'));
    });
  });
}

// Flutter Widget测试示例
void main() {
  group('NutritionCard Widget', () {
    late NutritionRecord testRecord;

    setUp(() {
      testRecord = NutritionRecord((b) => b
        ..id = '1'
        ..foodName = 'Apple'
        ..calories = 52
        ..protein = 0.3
        ..carbs = 14
        ..fat = 0.2);
    });

    testWidgets('should display nutrition information', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(record: testRecord),
          ),
        ),
      );

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('52 kcal'), findsOneWidget);
      expect(find.text('蛋白质: 0.3g'), findsOneWidget);
      expect(find.text('碳水: 14g'), findsOneWidget);
      expect(find.text('脂肪: 0.2g'), findsOneWidget);
    });

    testWidgets('should handle tap events', (tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(
              record: testRecord,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NutritionCard));
      expect(tapped, true);
    });
  });
}

// Flutter集成测试示例
void main() {
  group('Nutrition Flow Integration Test', () {
    testWidgets('complete nutrition record flow', (tester) async {
      await tester.pumpWidget(MyApp());

      // 登录流程
      await tester.enterText(find.byKey(Key('phone_input')), '13800138000');
      await tester.enterText(find.byKey(Key('code_input')), '123456');
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 进入营养记录页面
      await tester.tap(find.byKey(Key('nutrition_tab')));
      await tester.pumpAndSettle();

      // 添加营养记录
      await tester.tap(find.byKey(Key('add_record_button')));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(Key('food_name_input')), 'Apple');
      await tester.enterText(find.byKey(Key('calories_input')), '52');
      await tester.tap(find.byKey(Key('save_button')));
      await tester.pumpAndSettle();

      // 验证记录添加成功
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('52 kcal'), findsOneWidget);
    });
  });
}
```

### 4.4 API测试策略

```yaml
API测试框架: Postman + Newman

测试分类:
  功能测试:
    - 正常路径测试
    - 异常路径测试
    - 边界值测试
    - 参数验证测试
    
  性能测试:
    - 响应时间测试
    - 并发性能测试
    - 负载测试
    - 压力测试
    
  安全测试:
    - 身份认证测试
    - 权限控制测试
    - 输入验证测试
    - SQL注入测试

自动化执行:
  - CI/CD集成
  - 定时执行
  - 环境隔离
  - 测试数据管理
```

---

## 5. 质量控制流程

### 5.1 代码质量标准

```yaml
代码质量指标:
  代码覆盖率:
    - 单元测试: ≥85%
    - 集成测试: ≥70%
    - 关键路径: 100%
    - 新增代码: ≥90%
    
  代码复杂度:
    - 循环复杂度: ≤10
    - 认知复杂度: ≤15
    - 方法长度: ≤50行
    - 类长度: ≤500行
    
  代码重复率:
    - 重复代码: ≤5%
    - 重复块: ≤10行
    - 重复文件: 0个
    
  代码规范:
    - ESLint/Dart Analyzer: 0 errors
    - 格式化: Prettier/dart format
    - 注释覆盖率: ≥80%
    - API文档: 100%
```

### 5.2 质量门控设置

```yaml
提交阶段门控:
  - 代码格式检查通过
  - 单元测试通过
  - 代码覆盖率达标
  - 静态代码分析通过
  
合并阶段门控:
  - 代码审查通过
  - 集成测试通过
  - 安全扫描通过
  - 性能基准测试通过
  
发布阶段门控:
  - 端到端测试通过
  - 用户验收测试通过
  - 安全审计通过
  - 性能压测通过
```

### 5.3 持续监控

```yaml
代码质量监控:
  工具集成:
    - SonarQube: 代码质量分析
    - ESLint/Dart Analyzer: 静态分析
    - OWASP ZAP: 安全扫描
    - Lighthouse: 前端性能分析
    
  监控指标:
    - 代码质量趋势
    - 技术债务统计
    - 安全漏洞追踪
    - 性能指标变化
    
  告警机制:
    - 质量下降告警
    - 安全漏洞告警
    - 性能回归告警
    - 测试失败告警
```

### 5.4 技术债务管理机制

```yaml
技术债务定义:
  代码层面:
    - 代码重复: 相同逻辑在多处实现
    - 代码异味: 复杂度过高、命名不当、结构混乱
    - 临时解决方案: 为满足交付期限的权宜之计
    - 过时技术: 使用已淘汰或不推荐的技术栈
    
  架构层面:
    - 架构不一致: 不同模块使用不同的架构模式
    - 紧耦合: 模块间依赖关系过于复杂
    - 缺失抽象: 缺乏必要的抽象层和接口设计
    - 扩展性问题: 难以适应需求变化和系统扩展
    
  文档层面:
    - 文档缺失: 缺乏必要的技术文档
    - 文档过时: 文档内容与实际实现不符
    - 知识孤岛: 关键知识只掌握在少数人手中
    - 规范不统一: 缺乏一致的开发规范

技术债务识别:
  自动检测工具:
    SonarQube指标:
      - 技术债务比率 (Technical Debt Ratio)
      - 代码重复率 (Duplication)
      - 认知复杂度 (Cognitive Complexity)
      - 可维护性评级 (Maintainability Rating)
      
    ESLint/Dart Analyzer:
      - 代码规范违规统计
      - 复杂度预警提醒
      - 潜在bug检测
      - 代码异味识别
      
    依赖分析工具:
      - 过时依赖检测 (npm audit, flutter pub deps)
      - 安全漏洞扫描 (Snyk, OWASP)
      - 许可证合规检查
      - 依赖关系分析
      
  人工识别方法:
    代码审查:
      - 审查过程中记录技术债务
      - 使用统一的债务标记格式
      - 评估债务影响范围和紧急程度
      - 制定偿还计划建议
      
    架构评审:
      - 定期架构健康度检查
      - 跨模块依赖关系梳理
      - 性能瓶颈和扩展性评估
      - 技术选型适用性评估
```

```yaml
技术债务分类与优先级:
  严重程度分级:
    P0 - 关键债务 (Critical):
      影响: 阻碍新功能开发、影响系统稳定性
      特征: 安全漏洞、架构根本性问题、阻塞性bug
      处理时间: 立即处理 (1-3天内)
      责任人: 技术负责人直接负责
      
    P1 - 重要债务 (Major):
      影响: 降低开发效率、增加维护成本
      特征: 代码重复、复杂度过高、文档缺失
      处理时间: 当前Sprint内处理
      责任人: 模块负责人安排处理
      
    P2 - 一般债务 (Minor):
      影响: 轻微影响代码质量
      特征: 命名不规范、注释不足、小幅重构需求
      处理时间: 1-2个Sprint内处理
      责任人: 开发人员自主安排
      
    P3 - 优化债务 (Trivial):
      影响: 代码优化机会
      特征: 性能微调、代码美化、工具升级
      处理时间: 有空闲时间时处理
      责任人: 团队成员自愿处理

  类型分类:
    设计债务:
      - 架构设计不合理
      - 接口设计不一致
      - 数据模型设计缺陷
      - 缺乏必要的抽象
      
    代码债务:
      - 代码重复
      - 方法过长
      - 类过大
      - 复杂度过高
      
    测试债务:
      - 测试覆盖率不足
      - 测试质量较差
      - 缺乏自动化测试
      - 测试数据管理混乱
      
    文档债务:
      - API文档缺失
      - 架构文档过时
      - 操作手册不完善
      - 知识传承不足
```

```yaml
技术债务偿还策略:
  预防策略:
    开发阶段:
      - 严格执行代码审查
      - 使用自动化质量检查工具
      - 定期架构评审和重构
      - 建立技术债务意识培训
      
    设计阶段:
      - 充分的技术调研和设计评审
      - 建立清晰的技术架构指导原则
      - 制定统一的开发规范和标准
      - 考虑长期维护和扩展性
      
  偿还策略:
    渐进式重构:
      - 结合新功能开发进行重构
      - 每个Sprint分配一定比例时间偿还债务
      - 优先处理影响最大的债务
      - 避免大规模重构对项目进度的影响
      
    专项偿还:
      - 设置专门的技术债务偿还Sprint
      - 组建临时的重构小组
      - 针对特定模块进行集中重构
      - 制定详细的偿还计划和验收标准
      
    持续改进:
      - 建立技术债务度量指标
      - 定期评估债务偿还效果
      - 调整偿还策略和优先级
      - 分享最佳实践和经验教训

债务偿还执行:
  计划制定:
    - 评估偿还成本和收益
    - 制定详细的实施计划
    - 确定验收标准和完成定义
    - 分配责任人和时间安排
    
  实施监控:
    - 跟踪偿还进度
    - 监控质量指标变化
    - 及时调整策略
    - 记录偿还效果
    
  效果评估:
    - 比较偿还前后的质量指标
    - 评估对开发效率的影响
    - 收集团队反馈意见
    - 总结经验和教训
```

```yaml
技术债务度量与跟踪:
  关键指标 (KPIs):
    代码质量指标:
      - 技术债务比率: < 5% (SonarQube)
      - 代码重复率: < 3%
      - 认知复杂度: 平均 < 15
      - 代码覆盖率: > 85%
      - Bug密度: < 1 bugs/KLOC
      
    架构健康度:
      - 模块耦合度评分: > 80分
      - 接口一致性评分: > 90分
      - 扩展性评估: > 85分
      - 技术栈一致性: > 95分
      
    团队效率指标:
      - 功能开发速度 (Story Points/Sprint)
      - Bug修复时间 (平均解决时间)
      - 代码审查通过率: > 95%
      - 重构时间占比: 15-20%

  跟踪工具:
    债务登记系统:
      - Jira中创建技术债务Issue类型
      - 统一的债务描述模板
      - 影响程度和优先级标记
      - 偿还计划和进度跟踪
      
    度量仪表板:
      - SonarQube质量门禁
      - 技术债务趋势图表
      - 模块健康度热力图
      - 偿还效果对比分析
      
    报告机制:
      - 每周技术债务状态报告
      - 每Sprint债务偿还总结
      - 季度技术健康度评估
      - 年度技术债务回顾

治理流程:
  债务评审会议:
    频率: 每两周一次
    参与者: 技术负责人、架构师、高级开发
    议程:
      - 新增债务评估和分类
      - 偿还计划制定和调整
      - 进度跟踪和问题讨论
      - 预防措施和改进建议
    
  决策机制:
    - 重大债务偿还需技术委员会批准
    - 普通债务由模块负责人决策
    - 紧急债务可先偿还后补审批
    - 争议债务通过投票或专家评审
    
  激励机制:
    - 技术债务偿还纳入绩效考核
    - 优秀重构案例分享和表彰
    - 技术债务预防贡献奖励
    - 建立技术债务偿还英雄榜
```

---

## 6. 代码审查规范

### 6.1 审查流程

```yaml
审查角色分配:
  主审查者:
    - 技术负责人或资深开发
    - 负责架构和设计审查
    - 最终审批权限
    
  协审查者:
    - 同级开发人员
    - 负责代码细节审查
    - 提供改进建议
    
  自动审查:
    - 静态代码分析
    - 单元测试检查
    - 代码规范检查
    - 安全漏洞扫描

审查步骤:
  1. 自动检查:
    - CI/CD流水线执行
    - 自动化测试运行
    - 静态分析报告
    - 覆盖率检查
    
  2. 人工审查:
    - 功能逻辑审查
    - 代码质量评估
    - 安全性检查
    - 性能影响评估
    
  3. 反馈处理:
    - 问题讨论
    - 代码修改
    - 重新审查
    - 最终批准
```

### 6.2 审查检查清单

```yaml
功能正确性:
  □ 功能是否满足需求规格
  □ 边界条件是否正确处理
  □ 异常情况是否妥善处理
  □ 业务逻辑是否符合预期
  □ API接口是否设计合理

代码质量:
  □ 代码是否清晰易读
  □ 变量和函数命名是否合适
  □ 代码结构是否合理
  □ 是否存在重复代码
  □ 注释是否充分和准确

架构设计:
  □ 模块职责是否单一
  □ 依赖关系是否合理
  □ 接口设计是否清晰
  □ 是否遵循设计模式
  □ 扩展性是否考虑充分

性能考虑:
  □ 算法复杂度是否合适
  □ 数据库查询是否优化
  □ 内存使用是否合理
  □ 是否存在性能瓶颈
  □ 并发处理是否正确

安全性:
  □ 输入验证是否充分
  □ 权限检查是否完整
  □ 敏感信息是否保护
  □ 是否存在安全漏洞
  □ 加密解密是否正确

测试覆盖:
  □ 单元测试是否充分
  □ 集成测试是否覆盖
  □ 边界条件是否测试
  □ 异常路径是否测试
  □ 测试数据是否合适
```

---

## 6.3 代码合并冲突处理规范

### 6.3.1 冲突预防策略

```yaml
最佳实践:
  频繁同步:
    - 每日从主分支同步最新代码
    - 特性分支开发周期控制在2-3天内
    - 及时提交本地修改，避免大量积累
    - 定期rebase到最新的develop分支
    
  代码组织:
    - 按功能模块划分提交粒度
    - 避免在同一提交中混合多个功能
    - 保持提交的原子性和独立性
    - 合理规划特性分支的开发范围
    
  团队协调:
    - 提前沟通可能的冲突区域
    - 并行开发时协调修改范围
    - 使用代码所有权机制
    - 建立共享组件修改审批流程

预防工具:
  自动检测:
    - Git hooks检测潜在冲突
    - CI/CD流水线中的合并预检
    - 代码审查时的冲突风险评估
    - 分支保护规则设置
    
  规范约束:
    - 强制使用分支开发模式
    - 禁止直接向主分支推送
    - 要求PR必须基于最新代码
    - 设置分支合并策略限制
```

### 6.3.2 冲突识别与分类

```yaml
冲突类型识别:
  内容冲突 (Content Conflicts):
    描述: 同一文件的同一行被不同分支修改
    示例: 
      <<<<<<< HEAD
      const API_URL = 'https://api.production.com'
      =======
      const API_URL = 'https://api.staging.com'
      >>>>>>> feature/api-update
    
    处理优先级: P0 - 必须手动解决
    影响范围: 代码功能可能异常
    
  结构冲突 (Structural Conflicts):
    描述: 文件移动、重命名、删除引起的冲突
    示例: 一个分支删除文件，另一个分支修改同一文件
    处理优先级: P1 - 需要仔细评估
    影响范围: 项目结构和模块依赖
    
  语义冲突 (Semantic Conflicts):
    描述: 代码可以合并但逻辑上存在冲突
    示例: 一个分支修改函数签名，另一个分支调用该函数
    处理优先级: P0 - 需要深度分析
    影响范围: 运行时错误或逻辑错误
    
  依赖冲突 (Dependency Conflicts):
    描述: 不同分支更新了相同依赖的不同版本
    示例: package.json中同一包的版本冲突
    处理优先级: P1 - 需要兼容性测试
    影响范围: 构建失败或运行时异常

冲突复杂度评估:
  简单冲突:
    - 单文件内容冲突
    - 冲突行数 < 10行
    - 不涉及核心业务逻辑
    - 解决时间: 5-15分钟
    
  中等冲突:
    - 多文件内容冲突
    - 涉及函数签名变更
    - 包含依赖关系调整
    - 解决时间: 30分钟-2小时
    
  复杂冲突:
    - 大规模重构冲突
    - 架构层面的冲突
    - 需要多人协作解决
    - 解决时间: 半天-1天
```

### 6.3.3 冲突解决流程

```bash
# 标准合并冲突解决流程

# 1. 准备工作
echo "🔄 开始解决合并冲突..."

# 确保本地代码已提交
git status
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  请先提交或暂存本地修改"
    exit 1
fi

# 2. 同步最新代码
echo "📥 同步目标分支最新代码..."
git fetch origin
git checkout develop
git pull origin develop

# 3. 开始合并操作
echo "🔀 开始合并特性分支..."
git checkout feature/your-feature-name
git merge develop

# 或使用rebase方式 (推荐用于私有特性分支)
# git rebase develop

# 4. 识别冲突文件
echo "🔍 检查冲突文件..."
git status | grep "both modified"

# 5. 逐一解决冲突
echo "🛠️  解决冲突文件..."
# 使用VS Code内置的合并工具
code --wait $(git diff --name-only --diff-filter=U)

# 或使用命令行工具
git mergetool --tool=vimdiff

# 6. 验证解决结果
echo "✅ 验证冲突解决..."
# 检查是否还有冲突标记
grep -r "<<<<<<< HEAD" . --exclude-dir=.git && echo "仍有未解决冲突" || echo "冲突已解决"

# 7. 测试验证
echo "🧪 运行测试验证..."
# 运行相关测试
cd backend && npm test
cd ../frontend && flutter test

# 8. 提交合并结果
echo "💾 提交合并结果..."
git add .
git commit -m "解决与develop分支的合并冲突

- 解决了以下文件的冲突:
  - src/api/config.js (选择生产环境配置)
  - src/components/UserProfile.tsx (保留新的UI设计)
  - package.json (升级到最新依赖版本)

- 测试验证:
  - 单元测试: ✅ 通过
  - 集成测试: ✅ 通过
  - 手动测试: ✅ 功能正常

解决策略: 保持功能完整性，选择向前兼容的方案"
```

### 6.3.4 冲突解决策略

```yaml
解决策略选择:
  保留我的更改 (Accept Current Change):
    适用场景:
      - 确认当前分支的修改是正确的
      - 目标分支的修改已过时
      - 当前修改包含重要的功能更新
    
    决策依据:
      - 功能优先级对比
      - 代码质量评估
      - 业务需求匹配度
      
  保留传入更改 (Accept Incoming Change):
    适用场景:
      - 目标分支包含重要修复
      - 当前分支修改存在问题
      - 需要与主线保持一致
    
    决策依据:
      - 安全性考虑
      - 稳定性优先
      - 团队标准遵循
      
  保留双方更改 (Accept Both Changes):
    适用场景:
      - 两个修改都有价值
      - 可以并存且不冲突
      - 需要合并功能特性
    
    实施方法:
      - 重新组织代码结构
      - 创建条件分支
      - 使用配置化方案
      
  手动合并 (Manual Merge):
    适用场景:
      - 需要结合两者优点
      - 简单选择无法满足需求
      - 需要重新设计实现
    
    实施步骤:
      - 理解双方修改意图
      - 设计新的实现方案
      - 保证功能完整性
      - 进行充分测试

复杂冲突处理:
  架构层面冲突:
    - 召集相关开发人员讨论
    - 技术负责人最终决策
    - 必要时重新设计方案
    - 更新技术文档说明
    
  大规模重构冲突:
    - 暂停其他相关开发
    - 专门团队处理冲突
    - 分阶段解决问题
    - 建立临时协调机制
```

### 6.3.5 冲突解决工具与技巧

```yaml
推荐工具:
  图形化合并工具:
    VS Code内置:
      - 直观的三路合并界面
      - 语法高亮和智能提示
      - 集成的Git操作
      - 插件扩展支持
      
    专业合并工具:
      - Beyond Compare: 专业文件对比
      - Meld: 开源三路合并工具
      - P4Merge: 免费图形化工具
      - SourceTree: Git图形界面
      
  命令行工具:
    Git内置命令:
      - git mergetool: 启动合并工具
      - git status: 查看冲突状态
      - git diff: 查看冲突差异
      - git checkout: 选择特定版本
      
    高级技巧:
      - git log --merge: 查看冲突提交历史
      - git diff HEAD HEAD~1: 对比版本差异
      - git show :1:file.txt: 查看共同祖先版本
      - git blame: 追踪代码修改历史

实用技巧:
  预解决策略:
    - 理解代码修改背景和目的
    - 查看相关Issue和PR描述
    - 询问原作者修改意图
    - 参考相关文档和规范
    
  验证方法:
    - 编译检查: 确保语法正确
    - 单元测试: 验证功能逻辑
    - 集成测试: 检查模块协作
    - 手动测试: 确认用户体验
    
  文档记录:
    - 记录冲突原因和解决方案
    - 更新相关技术文档
    - 分享解决经验给团队
    - 总结预防措施建议
```

### 6.3.6 冲突处理质量保证

```yaml
质量检查清单:
  解决前检查:
    □ 了解冲突产生的背景原因
    □ 确认所有冲突文件都已识别
    □ 评估冲突解决的影响范围
    □ 制定详细的解决计划
    
  解决过程检查:
    □ 仔细阅读冲突标记内容
    □ 理解双方修改的业务逻辑
    □ 选择最优的解决策略
    □ 保持代码风格一致性
    
  解决后验证:
    □ 删除所有冲突标记符号
    □ 代码可以正常编译构建
    □ 所有相关测试通过
    □ 功能表现符合预期
    □ 无新的语义冲突引入

自动化检查:
  构建验证:
    - 自动编译检查
    - 依赖完整性验证
    - 语法错误检测
    - 代码规范检查
    
  测试验证:
    - 单元测试自动运行
    - 集成测试执行
    - 回归测试覆盖
    - 性能基准验证
    
  代码审查:
    - 冲突解决方案审查
    - 代码质量重新评估
    - 安全性影响分析
    - 文档同步更新

团队协作:
  沟通机制:
    - 冲突解决过程实时通报
    - 复杂冲突寻求帮助
    - 解决方案团队讨论
    - 经验分享和总结
    
  知识管理:
    - 常见冲突解决案例库
    - 最佳实践文档维护
    - 工具使用培训
    - 定期经验交流会
```

---

## 7. 持续集成/持续部署

### 7.1 CI/CD流水线设计

```yaml
触发条件:
  - 代码推送到特性分支
  - 合并请求创建/更新
  - 定时构建（每日构建）
  - 手动触发

流水线阶段:
  1. 代码检出:
    - 克隆代码仓库
    - 检出目标分支
    - 缓存依赖包
    
  2. 环境准备:
    - 安装依赖包
    - 配置环境变量
    - 启动测试服务
    - 数据库迁移
    
  3. 代码质量检查:
    - 代码格式检查
    - 静态代码分析
    - 安全漏洞扫描
    - 依赖项检查
    
  4. 单元测试:
    - 运行单元测试
    - 生成覆盖率报告
    - 发布测试结果
    - 质量门控检查
    
  5. 构建打包:
    - 编译源代码
    - 打包应用程序
    - 构建Docker镜像
    - 推送到镜像仓库
    
  6. 集成测试:
    - 部署到测试环境
    - 运行集成测试
    - API接口测试
    - 数据库集成测试
    
  7. 端到端测试:
    - 部署到预发环境
    - 运行E2E测试
    - 性能基准测试
    - 用户验收测试
    
  8. 部署发布:
    - 部署到生产环境
    - 健康检查
    - 监控告警
    - 回滚准备
```

### 7.2 环境管理

```yaml
环境分层:
  开发环境 (Development):
    - 本地开发环境
    - 快速迭代验证
    - 开发者个人环境
    - 功能开发测试
    
  测试环境 (Testing):
    - 功能测试环境
    - 集成测试验证
    - Bug修复验证
    - 性能初步测试
    
  预发环境 (Staging):
    - 生产环境镜像
    - 用户验收测试
    - 性能压力测试
    - 发布前最终验证
    
  生产环境 (Production):
    - 正式服务环境
    - 用户实际使用
    - 高可用部署
    - 监控告警完备

环境配置管理:
  - 配置文件模板化
  - 环境变量管理
  - 密钥安全存储
  - 配置版本控制
```

### 7.3 部署策略

```yaml
部署模式:
  蓝绿部署:
    - 双环境轮换
    - 零停机部署
    - 快速回滚
    - 风险可控
    
  金丝雀发布:
    - 灰度发布策略
    - 流量逐步切换
    - 实时监控反馈
    - 问题快速发现
    
  滚动更新:
    - 逐步更新实例
    - 服务不中断
    - 资源利用率高
    - 更新过程可控

自动化部署:
  - Docker容器化部署
  - Kubernetes编排
  - 自动扩缩容
  - 服务发现注册
  - 配置热更新
  - 日志集中收集
```

### 7.4 详细CI/CD流水线实现

#### 7.4.1 GitHub Actions工作流配置

```yaml
# .github/workflows/backend-ci-cd.yml
name: Backend CI/CD Pipeline

on:
  push:
    branches: [ main, develop, 'feature/*' ]
    paths: [ 'backend/**' ]
  pull_request:
    branches: [ main, develop ]
    paths: [ 'backend/**' ]

env:
  NODE_VERSION: '18.17.0'
  REGISTRY: ghcr.io
  IMAGE_NAME: ai-nutrition/backend

jobs:
  # 第一阶段：代码质量检查
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        with:
          fetch-depth: 0
          
      - name: 设置Node.js环境
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json
          
      - name: 安装依赖
        run: |
          cd backend
          npm ci
          
      - name: 代码格式检查
        run: |
          cd backend
          npm run lint
          npm run format:check
          
      - name: TypeScript类型检查
        run: |
          cd backend
          npm run type-check
          
      - name: 安全漏洞扫描
        run: |
          cd backend
          npm audit --audit-level=high
          
      - name: SonarQube代码分析
        uses: sonarqube-quality-gate-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        with:
          scanMetadata: backend/.scannerwork/report-task.txt

  # 第二阶段：单元测试
  unit-tests:
    runs-on: ubuntu-latest
    needs: code-quality
    
    services:
      postgres:
        image: pgvector/pgvector:pg15
        env:
          POSTGRES_PASSWORD: test123
          POSTGRES_DB: ai_nutrition_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
          
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
          
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Node.js环境
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: backend/package-lock.json
          
      - name: 安装依赖
        run: |
          cd backend
          npm ci
          
      - name: 运行单元测试
        run: |
          cd backend
          npm run test:unit
        env:
          DATABASE_URL: postgresql://postgres:test123@localhost:5432/ai_nutrition_test
          REDIS_URL: redis://localhost:6379
          NODE_ENV: test
          
      - name: 生成覆盖率报告
        run: |
          cd backend
          npm run test:coverage
          
      - name: 上传覆盖率报告
        uses: codecov/codecov-action@v3
        with:
          directory: backend/coverage
          flags: backend
          name: backend-coverage
          
      - name: 检查覆盖率阈值
        run: |
          cd backend
          npm run coverage:check

  # 第三阶段：构建镜像
  build:
    runs-on: ubuntu-latest
    needs: unit-tests
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    
    outputs:
      image-digest: ${{ steps.build.outputs.digest }}
      image-tag: ${{ steps.meta.outputs.tags }}
      
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Docker Buildx
        uses: docker/setup-buildx-action@v3
        
      - name: 登录容器注册表
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
          
      - name: 提取元数据
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=sha,prefix={{branch}}-
            type=raw,value=latest,enable={{is_default_branch}}
            
      - name: 构建并推送镜像
        id: build
        uses: docker/build-push-action@v5
        with:
          context: backend
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
          platforms: linux/amd64,linux/arm64

  # 第四阶段：集成测试
  integration-tests:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    
    services:
      postgres:
        image: pgvector/pgvector:pg15
        env:
          POSTGRES_PASSWORD: test123
          POSTGRES_DB: ai_nutrition_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
          
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
          
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 启动应用容器
        run: |
          docker run -d \
            --name backend-test \
            --network host \
            -e DATABASE_URL=postgresql://postgres:test123@localhost:5432/ai_nutrition_test \
            -e REDIS_URL=redis://localhost:6379 \
            -e NODE_ENV=test \
            ${{ needs.build.outputs.image-tag }}
            
      - name: 等待服务启动
        run: |
          timeout 60 bash -c 'until curl -f http://localhost:3000/health; do sleep 2; done'
          
      - name: 运行API集成测试
        run: |
          cd backend
          npm ci
          npm run test:integration
        env:
          API_BASE_URL: http://localhost:3000
          
      - name: 运行数据库集成测试
        run: |
          cd backend
          npm run test:db-integration
        env:
          DATABASE_URL: postgresql://postgres:test123@localhost:5432/ai_nutrition_test
          
      - name: 清理测试容器
        if: always()
        run: |
          docker stop backend-test || true
          docker rm backend-test || true

  # 第五阶段：部署到测试环境
  deploy-test:
    runs-on: ubuntu-latest
    needs: [build, integration-tests]
    if: github.ref == 'refs/heads/develop'
    environment: test
    
    steps:
      - name: 部署到测试环境
        uses: azure/webapps-deploy@v2
        with:
          app-name: ai-nutrition-backend-test
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE_TEST }}
          images: ${{ needs.build.outputs.image-tag }}
          
      - name: 健康检查
        run: |
          timeout 300 bash -c 'until curl -f https://ai-nutrition-backend-test.azurewebsites.net/health; do sleep 5; done'
          
      - name: 运行烟雾测试
        run: |
          curl -f https://ai-nutrition-backend-test.azurewebsites.net/api/v1/auth/health
          curl -f https://ai-nutrition-backend-test.azurewebsites.net/api/v1/users/health

  # 第六阶段：部署到生产环境
  deploy-prod:
    runs-on: ubuntu-latest
    needs: [build, integration-tests]
    if: github.ref == 'refs/heads/main'
    environment: production
    
    steps:
      - name: 部署到生产环境 (蓝绿部署)
        uses: azure/webapps-deploy@v2
        with:
          app-name: ai-nutrition-backend-prod
          slot-name: staging
          publish-profile: ${{ secrets.AZURE_WEBAPP_PUBLISH_PROFILE_PROD }}
          images: ${{ needs.build.outputs.image-tag }}
          
      - name: 预生产环境健康检查
        run: |
          timeout 300 bash -c 'until curl -f https://ai-nutrition-backend-prod-staging.azurewebsites.net/health; do sleep 5; done'
          
      - name: 运行生产前测试
        run: |
          # 运行关键业务流程测试
          curl -f https://ai-nutrition-backend-prod-staging.azurewebsites.net/api/v1/auth/health
          curl -f https://ai-nutrition-backend-prod-staging.azurewebsites.net/api/v1/users/health
          curl -f https://ai-nutrition-backend-prod-staging.azurewebsites.net/api/v1/nutrition/health
          
      - name: 切换到生产环境
        uses: Azure/cli@v1
        with:
          inlineScript: |
            az webapp deployment slot swap \
              --resource-group ai-nutrition-rg \
              --name ai-nutrition-backend-prod \
              --slot staging \
              --target-slot production
              
      - name: 生产环境最终验证
        run: |
          timeout 300 bash -c 'until curl -f https://ai-nutrition-backend-prod.azurewebsites.net/health; do sleep 5; done'
          
      - name: 通知部署成功
        uses: 8398a7/action-slack@v3
        with:
          status: success
          text: '🚀 Backend deployment to production successful!'
        env:
          SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

#### 7.4.2 Flutter前端CI/CD配置

```yaml
# .github/workflows/frontend-ci-cd.yml
name: Frontend CI/CD Pipeline

on:
  push:
    branches: [ main, develop, 'feature/*' ]
    paths: [ 'frontend/**' ]
  pull_request:
    branches: [ main, develop ]
    paths: [ 'frontend/**' ]

env:
  FLUTTER_VERSION: '3.19.0'

jobs:
  # 第一阶段：代码质量检查
  code-quality:
    runs-on: ubuntu-latest
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Flutter环境
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          
      - name: 获取依赖
        run: |
          cd frontend
          flutter pub get
          
      - name: 代码分析
        run: |
          cd frontend
          flutter analyze
          
      - name: 代码格式检查
        run: |
          cd frontend
          dart format --set-exit-if-changed .
          
      - name: 依赖项审计
        run: |
          cd frontend
          flutter pub deps --json | jq '.packages[] | select(.source == "hosted") | .name' | sort | uniq

  # 第二阶段：单元测试
  unit-tests:
    runs-on: ubuntu-latest
    needs: code-quality
    
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Flutter环境
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          
      - name: 获取依赖
        run: |
          cd frontend
          flutter pub get
          
      - name: 运行单元测试
        run: |
          cd frontend
          flutter test --coverage
          
      - name: 生成覆盖率报告
        run: |
          cd frontend
          genhtml coverage/lcov.info -o coverage/html
          
      - name: 上传覆盖率报告
        uses: codecov/codecov-action@v3
        with:
          directory: frontend/coverage
          flags: frontend
          name: frontend-coverage

  # 第三阶段：构建应用
  build:
    runs-on: ubuntu-latest
    needs: unit-tests
    strategy:
      matrix:
        platform: [web, android, ios]
        
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Flutter环境
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          
      - name: 获取依赖
        run: |
          cd frontend
          flutter pub get
          
      - name: 构建Web应用
        if: matrix.platform == 'web'
        run: |
          cd frontend
          flutter build web --release --no-sound-null-safety
          
      - name: 设置Java环境 (Android)
        if: matrix.platform == 'android'
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'
          
      - name: 构建Android应用
        if: matrix.platform == 'android'
        run: |
          cd frontend
          flutter build apk --release
          flutter build appbundle --release
          
      - name: 设置Xcode环境 (iOS)
        if: matrix.platform == 'ios' && runner.os == 'macOS'
        uses: maxim-lobanov/setup-xcode@v1
        with:
          xcode-version: latest-stable
          
      - name: 构建iOS应用
        if: matrix.platform == 'ios' && runner.os == 'macOS'
        run: |
          cd frontend
          flutter build ios --release --no-codesign
          
      - name: 上传构建产物
        uses: actions/upload-artifact@v3
        with:
          name: ${{ matrix.platform }}-build
          path: |
            frontend/build/web/
            frontend/build/app/outputs/flutter-apk/app-release.apk
            frontend/build/app/outputs/bundle/release/app-release.aab
            frontend/build/ios/iphoneos/Runner.app

  # 第四阶段：端到端测试
  e2e-tests:
    runs-on: ubuntu-latest
    needs: build
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    
    services:
      backend:
        image: ghcr.io/ai-nutrition/backend:latest
        ports:
          - 3000:3000
        env:
          NODE_ENV: test
          DATABASE_URL: postgresql://postgres:test123@postgres:5432/ai_nutrition_test
          
      postgres:
        image: pgvector/pgvector:pg15
        env:
          POSTGRES_PASSWORD: test123
          POSTGRES_DB: ai_nutrition_test
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
          
    steps:
      - name: 检出代码
        uses: actions/checkout@v4
        
      - name: 设置Flutter环境
        uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ env.FLUTTER_VERSION }}
          channel: 'stable'
          
      - name: 获取依赖
        run: |
          cd frontend
          flutter pub get
          
      - name: 启动Chrome (headless)
        uses: browser-actions/setup-chrome@latest
        
      - name: 运行集成测试
        run: |
          cd frontend
          flutter drive \
            --driver=test_driver/integration_test.dart \
            --target=integration_test/app_test.dart \
            -d chrome --headless
        env:
          API_BASE_URL: http://localhost:3000

  # 第五阶段：部署Web应用
  deploy-web:
    runs-on: ubuntu-latest
    needs: [build, e2e-tests]
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
    
    steps:
      - name: 下载Web构建产物
        uses: actions/download-artifact@v3
        with:
          name: web-build
          path: frontend/build/web
          
      - name: 部署到Azure Static Web Apps (Test)
        if: github.ref == 'refs/heads/develop'
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN_TEST }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "frontend/build/web"
          api_location: ""
          output_location: ""
          
      - name: 部署到Azure Static Web Apps (Prod)
        if: github.ref == 'refs/heads/main'
        uses: Azure/static-web-apps-deploy@v1
        with:
          azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN_PROD }}
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          action: "upload"
          app_location: "frontend/build/web"
          api_location: ""
          output_location: ""
```

#### 7.4.3 环境差异化配置

```yaml
环境配置差异:
  开发环境 (Development):
    配置文件: .env.development
    特性:
      - 详细日志输出
      - 热重载开启
      - 调试模式启用
      - 本地数据库连接
      - 模拟第三方服务
      - CORS宽松配置
      
    环境变量:
      NODE_ENV: development
      LOG_LEVEL: debug
      CORS_ORIGIN: "*"
      DATABASE_URL: postgresql://localhost:5432/ai_nutrition_dev
      REDIS_URL: redis://localhost:6379
      API_RATE_LIMIT: disabled
      
  测试环境 (Testing):
    配置文件: .env.testing
    特性:
      - 结构化日志
      - 自动化测试友好
      - 测试数据隔离
      - 模拟外部依赖
      - 性能基准测试
      
    环境变量:
      NODE_ENV: test
      LOG_LEVEL: info
      DATABASE_URL: postgresql://test-db:5432/ai_nutrition_test
      REDIS_URL: redis://test-redis:6379
      API_RATE_LIMIT: relaxed
      TEST_TIMEOUT: 30000
      
  预发环境 (Staging):
    配置文件: .env.staging
    特性:
      - 生产级配置
      - 完整监控告警
      - 真实数据测试
      - 性能压力测试
      - 用户验收测试
      
    环境变量:
      NODE_ENV: production
      LOG_LEVEL: warn
      DATABASE_URL: postgresql://staging-db:5432/ai_nutrition_staging
      REDIS_URL: redis://staging-redis:6379
      API_RATE_LIMIT: production
      MONITORING_ENABLED: true
      
  生产环境 (Production):
    配置文件: .env.production
    特性:
      - 最高安全级别
      - 完整备份策略
      - 高可用部署
      - 性能优化
      - 严格监控告警
      
    环境变量:
      NODE_ENV: production
      LOG_LEVEL: error
      DATABASE_URL: ${AZURE_POSTGRESQL_URL}
      REDIS_URL: ${AZURE_REDIS_URL}
      API_RATE_LIMIT: strict
      SECURITY_HEADERS: enabled
      BACKUP_ENABLED: true

数据库迁移策略:
  开发环境:
    - 自动执行迁移
    - 支持快速重置
    - 种子数据自动填充
    - 结构变更自由
    
  测试环境:
    - 每次测试前重置
    - 迁移脚本验证
    - 数据一致性检查
    - 回滚机制测试
    
  预发环境:
    - 模拟生产迁移
    - 大数据量测试
    - 性能影响评估
    - 迁移时间预估
    
  生产环境:
    - 计划停机迁移
    - 备份验证完整
    - 分步骤执行
    - 回滚方案准备

配置管理工具:
  开发阶段:
    - dotenv文件管理
    - 本地配置覆盖
    - IDE集成配置
    - 开发者个性化设置
    
  CI/CD流水线:
    - GitHub Secrets管理
    - 环境变量注入
    - 配置文件生成
    - 敏感信息加密
    
  生产部署:
    - Azure Key Vault
    - 配置版本控制
    - 动态配置更新
    - 审计日志记录
```

---

## 8. 项目管理

### 8.1 Sprint规划

```yaml
Sprint周期: 2周

Sprint计划会议:
  时间: Sprint第一天上午
  参与者: PO, SM, 开发团队
  输出:
    - Sprint目标确定
    - 用户故事细化
    - 任务分解估算
    - 承诺点数确定

Daily Standup:
  时间: 每日上午9:30
  时长: 15分钟
  内容:
    - 昨天完成的工作
    - 今天计划的工作
    - 遇到的阻碍问题
    - 需要的帮助支持

Sprint Review:
  时间: Sprint最后一天上午
  参与者: 全体团队 + 利益相关者
  内容:
    - 演示完成功能
    - 收集反馈意见
    - 讨论改进建议
    - 规划下个Sprint

Sprint Retrospective:
  时间: Sprint最后一天下午
  参与者: 开发团队
  内容:
    - 总结经验教训
    - 识别改进机会
    - 制定改进计划
    - 团队建设活动
```

### 8.2 任务管理

```yaml
任务分类:
  Epic (史诗):
    - 大功能模块
    - 跨多个Sprint
    - 业务价值明确
    - 可独立交付
    
  User Story (用户故事):
    - 用户视角功能
    - 1-2个Sprint内完成
    - 包含验收标准
    - 可演示验证
    
  Task (任务):
    - 具体开发任务
    - 1-3天内完成
    - 技术实现细节
    - 可独立测试
    
  Bug (缺陷):
    - 功能异常问题
    - 优先级分级
    - 修复验证
    - 回归测试

估算方法:
  - Planning Poker
  - 相对估算
  - 历史数据参考
  - 团队共识决定
```

### 8.3 进度跟踪

```yaml
跟踪指标:
  Burndown Chart:
    - 剩余工作量趋势
    - 进度偏差识别
    - 完成时间预测
    - 风险提前预警
    
  Velocity Chart:
    - 团队交付能力
    - 速度趋势分析
    - 容量规划依据
    - 改进效果验证
    
  Cumulative Flow:
    - 工作流状态分布
    - 瓶颈识别分析
    - 交付节奏把控
    - 流程优化指导

报告机制:
  - 每日进度更新
  - 周报总结汇报
  - 月度里程碑回顾
  - 季度规划调整
```

---

## 9. 风险管理

### 9.1 风险识别

```yaml
技术风险:
  架构风险:
    - 技术选型不当
    - 架构设计缺陷
    - 性能瓶颈问题
    - 扩展性不足
    
  集成风险:
    - 第三方服务依赖
    - API接口变更
    - 数据格式不兼容
    - 版本兼容问题
    
  数据风险:
    - 数据迁移失败
    - 数据一致性问题
    - 数据安全风险
    - 备份恢复问题

项目风险:
  进度风险:
    - 需求变更频繁
    - 技术难度超预期
    - 人员能力不足
    - 资源分配不当
    
  质量风险:
    - 测试覆盖不足
    - 代码质量低下
    - 用户体验差
    - 性能不达标
    
  人员风险:
    - 关键人员离职
    - 团队沟通不畅
    - 技能差距明显
    - 工作负荷过重

外部风险:
  - 政策法规变化
  - 市场环境变化
  - 竞争对手影响
  - 用户需求变化
```

### 9.2 风险应对策略

```yaml
风险应对方式:
  规避 (Avoid):
    - 选择成熟技术方案
    - 避免复杂架构设计
    - 减少外部依赖
    - 简化功能需求
    
  减轻 (Mitigate):
    - 技术预研验证
    - 原型开发验证
    - 分阶段迭代实施
    - 备选方案准备
    
  转移 (Transfer):
    - 购买商业保险
    - 外包非核心功能
    - 使用云服务
    - 第三方技术支持
    
  接受 (Accept):
    - 制定应急预案
    - 预留缓冲时间
    - 准备额外资源
    - 监控风险状态

具体措施:
  技术风险应对:
    - 技术调研充分
    - 架构评审严格
    - 原型验证先行
    - 备选方案准备
    
  项目风险应对:
    - 需求管理严格
    - 进度监控密切
    - 质量控制严格
    - 沟通协调及时
    
  人员风险应对:
    - 知识共享机制
    - 文档完善管理
    - 技能培训提升
    - 人员备份计划
```

---

## 10. 发布管理

### 10.1 发布计划

```yaml
发布策略:
  Alpha版本 (内部测试):
    - 核心功能开发完成
    - 基本功能可用
    - 内部团队测试
    - 主要Bug修复
    
  Beta版本 (公开测试):
    - 功能基本完整
    - 性能初步优化
    - 邀请用户测试
    - 收集用户反馈
    
  RC版本 (发布候选):
    - 功能完全完成
    - 性能测试通过
    - 用户验收通过
    - 准备正式发布
    
  正式版本 (生产发布):
    - 所有测试通过
    - 文档完整齐全
    - 运维准备就绪
    - 用户培训完成

发布节奏:
  - 主要版本: 每季度1次
  - 次要版本: 每月1-2次
  - 补丁版本: 根据需要发布
  - 热修复: 紧急Bug修复
```

### 10.2 发布检查清单

```yaml
发布前检查:
  功能完整性:
    □ 所有功能正常运行
    □ 用户验收测试通过
    □ 性能测试达标
    □ 安全测试通过
    □ 兼容性测试通过
    
  质量保证:
    □ 代码审查完成
    □ 单元测试通过
    □ 集成测试通过
    □ 端到端测试通过
    □ 回归测试通过
    
  文档准备:
    □ 用户手册更新
    □ API文档更新
    □ 发布说明准备
    □ 运维文档更新
    □ 培训材料准备
    
  环境准备:
    □ 生产环境就绪
    □ 数据库迁移脚本
    □ 配置文件更新
    □ 监控告警配置
    □ 备份恢复方案
    
  运维准备:
    □ 部署脚本测试
    □ 回滚方案准备
    □ 监控指标配置
    □ 应急响应团队
    □ 用户沟通计划

发布后检查:
  □ 服务健康状态检查
  □ 关键功能验证
  □ 性能指标监控
  □ 错误日志检查
  □ 用户反馈收集
```

### 10.3 发布后支持

```yaml
监控指标:
  系统指标:
    - CPU利用率
    - 内存使用率
    - 磁盘空间
    - 网络带宽
    - 响应时间
    
  业务指标:
    - 用户注册数
    - 活跃用户数
    - 订单转化率
    - 错误率统计
    - 用户满意度
    
  告警规则:
    - 错误率超过阈值
    - 响应时间超时
    - 服务不可用
    - 资源使用过高
    - 业务异常波动

应急响应:
  响应等级:
    P0 - 系统完全不可用
    P1 - 核心功能异常
    P2 - 部分功能异常
    P3 - 轻微问题
    
  响应时间:
    P0 - 15分钟内响应
    P1 - 30分钟内响应
    P2 - 2小时内响应
    P3 - 1个工作日内响应
    
  处理流程:
    1. 问题发现和上报
    2. 问题评估和分级
    3. 应急团队响应
    4. 问题诊断和定位
    5. 解决方案实施
    6. 服务恢复验证
    7. 事后分析总结
```

---

## 📊 总结

本开发流程文档提供了AI智能营养餐厅系统的完整开发指导，包括：

### 🎯 核心价值

1. **结构化开发**: 按模块优先级有序推进，确保关键功能优先交付
2. **质量保证**: 多层次测试策略，确保代码质量和用户体验
3. **风险控制**: 全面的风险识别和应对机制，降低项目风险
4. **持续改进**: 基于反馈的迭代优化，持续提升产品质量

### 📈 预期效果

- **开发效率**: 清晰的流程和标准，提升团队协作效率
- **代码质量**: 严格的质量控制，确保代码可维护性
- **项目成功**: 科学的项目管理，保障项目按时交付
- **用户满意**: 完善的测试验证，确保用户体验质量

### 🔄 持续优化

本流程文档将随着项目进展不断优化调整，确保始终符合项目实际需求和最佳实践。

---

## 11. 文档引用索引

### 11.1 核心文档引用映射

```yaml
业务需求文档:
  BUSINESS_REQUIREMENTS.md:
    - 第二阶段: 用户管理 (第3.1节, 第4.1节)
    - 第三阶段: 营养档案 (第4.2节)
    - 第四阶段: AI推荐 (第4.3节)
    - 第五阶段: 商家管理 (第4.6节)
    - 第六阶段: 订单支付 (第4.4节)
    - 第七阶段: 营养师咨询 (第4.5节)
    - 第八阶段: 社区论坛 (第4.7节)

技术架构文档:
  TECHNICAL_STACK_UNIFIED.md:
    - 项目架构分析
    - 第一阶段: 技术栈规范
    - 第四阶段: AI服务配置
    
  FRONTEND_ARCHITECTURE.md:
    - 项目架构分析
    - 第一阶段: 前端架构设计
    - 第二阶段: 认证模块
    - 测试验证: 测试框架
    - WebSocket实时通信

API接口规范:
  COMPLETE_API_SPEC.yaml:
    - 第一阶段: API接口设计
    - 第二阶段: User Management、Authentication、Authorization
    - 第三阶段: Nutrition Profile
    - 第四阶段: AI Services、Recommendation
    - 第五阶段: Merchant Management、Dish Management
    - 第六阶段: Order & Payment、Shopping Cart
    - 第七阶段: Nutritionist Service、Appointment System
    - 第八阶段: Community Forum、User Interaction
    - 第九阶段: Notification、Push Service、Message System

UI/UX设计文档:
  UI_PAGE_DESIGN_COMPLETE.md:
    - 第二阶段: 认证页面、用户中心
    - 第三阶段: 营养档案模块
    - 第四阶段: AI推荐页面
    - 第五阶段: 商家页面设计
    - 第六阶段: 订单页面
    - 第七阶段: 咨询页面设计
    - 第八阶段: 社区页面
    - 第九阶段: 消息页面
    
  COMPONENT_LIBRARY_DEVELOPMENT_GUIDE.md:
    - 第二阶段: 用户组件
    - 第四阶段: 推荐组件
    - 第五阶段: 表单组件
    - 第六阶段: 购物车组件
    - 第八阶段: 互动组件

团队协作文档:
  TEAM_COLLABORATION_GUIDE.md:
    - 开发方法论
    - 开发实施阶段: 第3节、第4节
    - 代码审查阶段: 第5节
    
  DEVELOPMENT_SETUP_GUIDE.md:
    - 开发方法论
    - 第一阶段: 第2节、第3节、第4节

测试策略文档:
  TESTING_STRATEGY_GUIDE.md:
    - 测试验证阶段
    - 测试策略: 测试金字塔、单元测试、集成测试
    
  AUTOMATED_TESTING_SETUP.md:
    - 测试策略: 自动化测试
    
  API_TESTING_GUIDE.md:
    - 测试验证阶段: API测试
    - 后端测试策略
```

### 11.2 专项功能文档引用

```yaml
认证与权限:
  - AUTHENTICATION_FLOW_DESIGN.md: 第二阶段认证流程
  - USER_PERMISSION_SYSTEM_DESIGN.md: 第二、五、七阶段权限设计

AI相关:
  - AI_INTERACTION_DESIGN.md: 第四阶段AI交互设计
  - DATA_VISUALIZATION_DESIGN.md: 第四阶段数据展示

商家管理:
  - MERCHANT_BACKEND_DESIGN.md: 第五阶段商家后台
  - FILE_UPLOAD_HANDLING_GUIDE.md: 第二、五阶段文件上传

订单支付:
  - ORDER_FLOW_DESIGN.md: 第六阶段订单流程
  - ORDER_TRACKING_DESIGN.md: 第六阶段订单跟踪
  - PAYMENT_INTEGRATION_GUIDE.md: 第六阶段支付集成

实时通信:
  - WEBSOCKET_IMPLEMENTATION_GUIDE.md: 第七阶段实时通信
  - REAL_TIME_COMMUNICATION_DESIGN.md: 第七阶段通信设计

社区与通知:
  - COMMUNITY_FORUM_DESIGN.md: 第八阶段论坛设计
  - NOTIFICATION_SYSTEM_DESIGN.md: 第九阶段通知设计
  - PUSH_NOTIFICATION_GUIDE.md: 第九阶段推送服务

设计系统:
  - MICRO_INTERACTION_DESIGN.md: 第四、八阶段微交互
  - ACCESSIBILITY_DESIGN_GUIDE.md: 无障碍设计规范
  - DATA_SYNC_STATUS_DISPLAY_GUIDE.md: 第六阶段状态显示

技术指导:
  - NESTJS_TESTING_GUIDE.md: 后端测试策略
  - DATABASE_TESTING_GUIDE.md: 数据库测试
  - E2E_TESTING_GUIDE.md: 端到端测试
  - PERFORMANCE_TESTING_GUIDE.md: 性能测试
  - SECURITY_REVIEW_CHECKLIST.md: 安全审查
  - CODE_QUALITY_STANDARDS.md: 代码质量标准
```

### 11.3 文档使用指南

```yaml
开发前准备:
  1. 阅读 BUSINESS_REQUIREMENTS.md 了解业务需求
  2. 学习 TECHNICAL_STACK_UNIFIED.md 掌握技术架构
  3. 熟悉 DEVELOPMENT_SETUP_GUIDE.md 配置开发环境
  4. 理解 TEAM_COLLABORATION_GUIDE.md 掌握协作流程

模块开发时:
  1. 查看对应阶段的业务需求文档
  2. 参考API规范设计接口
  3. 遵循UI设计文档实现界面
  4. 按照测试策略编写测试用例
  5. 遵守代码审查和提交规范

问题解决时:
  1. 查找相关的技术指导文档
  2. 参考最佳实践和解决方案
  3. 遵循安全和性能规范
```

---

**文档状态**: ✅ 文档体系串联完成，可指导团队高效开发  
**下一步**: 按照此串联体系启动第一阶段基础架构开发

🎆 **成果**: 所有开发模块均已与69个相关文档完全串联，形成了一个统一、可操作的开发指导体系！