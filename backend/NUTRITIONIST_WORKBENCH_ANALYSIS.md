# 营养师工作台需求分析报告

## 一、现有功能模块分析

### 1. 后端功能模块

#### 1.1 营养师认证系统
- **模型**: `nutritionistCertificationModel.js`
  - 个人信息管理（加密存储）
  - 资质证书上传与验证
  - 多级审核流程（草稿、待审核、通过、拒绝）
  - 认证历史记录
  - 专业领域选择

- **服务**: `nutritionistCertificationService.js`
  - 认证申请的创建、更新、提交
  - 审核状态管理
  - 证书文件管理

#### 1.2 营养师基础信息管理
- **模型**: `nutritionistModel.js`
  - 个人资料（姓名、身份证、联系方式）
  - 专业资质（证书编号、等级、有效期）
  - 专业信息（擅长领域、从业年限、教育背景）
  - 服务信息（咨询费用、时长、线上/线下支持）
  - 在线状态管理
  - 评价评分系统
  - 工作时间安排

#### 1.3 咨询管理系统
- **模型**: `consultationModel.js`
  - 咨询会话管理（创建、状态跟踪）
  - 预约时间管理
  - 消息记录（支持文字、图片、文档、音频）
  - 咨询评价系统
  - 费用管理
  - 市场化咨询（可公开、可接单）

- **服务**: `consultationService.js`
  - 咨询的创建与管理
  - 时间段可用性检查
  - 咨询历史查询
  - 推荐营养师匹配

#### 1.4 客户关系管理
- **模型**: `nutritionistClientModel.js`
  - 客户档案管理
  - 健康概况记录
  - 咨询历史统计
  - 进展跟踪（体重、体脂等指标）
  - 目标设定与管理
  - 营养计划历史
  - 重要提醒设置

- **服务**: `nutritionistClientService.js`
  - 客户列表查询
  - 客户详情管理
  - 进展更新
  - 提醒管理

#### 1.5 统计分析服务
- **服务**: `nutritionistStatsService.js`
  - 综合统计数据（咨询量、客户数、收入等）
  - 收入详情分析
  - 评价统计
  - 趋势数据生成
  - 绩效指标计算

#### 1.6 营养计划管理
- **模型**: `nutritionPlanModel.js`
  - 计划基本信息
  - 目标设定
  - 每日饮食安排
  - 进度跟踪
  - 反馈评价

### 2. 前端功能模块（Flutter）

#### 2.1 已实现页面
- **营养师工作台首页** (`dashboard_page.dart`)
  - 欢迎信息展示
  - 今日工作概况（待处理咨询、已完成推荐、评分、服务时长）
  - 快捷操作入口
  - 待处理任务列表
  - 最近咨询记录

- **营养师认证相关页面**
  - 认证申请页面
  - 认证状态查看页面
  - 多步骤表单（个人信息、教育背景、工作经历、证书上传）

- **营养师列表与详情**
  - 营养师列表展示
  - 筛选功能
  - 详情页面
  - 在线状态指示器

## 二、核心功能需求分析

### 1. 咨询管理（已有基础，需增强）
**现状**：
- ✅ 后端：完整的咨询模型和服务
- ✅ 后端：支持多种消息类型
- ✅ 后端：预约时间管理
- ❌ 前端：缺少咨询管理界面
- ❌ 前端：缺少实时聊天界面

**需要新增**：
- 前端咨询列表页面（按状态筛选）
- 前端咨询详情与聊天界面
- WebSocket实时消息支持
- 咨询状态管理（接受、拒绝、完成）

### 2. 客户管理（已有模型，缺少界面）
**现状**：
- ✅ 后端：完整的客户关系模型
- ✅ 后端：健康档案管理
- ✅ 后端：进展跟踪功能
- ❌ 前端：缺少客户列表界面
- ❌ 前端：缺少客户详情界面

**需要新增**：
- 前端客户列表页面（支持搜索、标签筛选）
- 前端客户详情页面（健康档案、历史记录）
- 客户标签管理功能
- 批量消息发送功能

### 3. 营养计划管理（已有模型，需要完善）
**现状**：
- ✅ 后端：营养计划模型
- ✅ 后端：计划进度跟踪
- ❌ 前端：缺少计划创建界面
- ❌ 前端：缺少计划管理界面
- ❌ 后端：缺少计划模板功能

**需要新增**：
- 后端API：营养计划的CRUD接口
- 后端功能：计划模板管理
- 前端计划创建向导
- 前端计划列表与详情页面
- 计划分享功能

### 4. 预约管理（部分实现）
**现状**：
- ✅ 后端：咨询预约时间管理
- ✅ 后端：时间段可用性检查
- ❌ 前端：缺少预约日历界面
- ❌ 前端：缺少时间设置界面

**需要新增**：
- 前端预约日历组件
- 前端工作时间设置界面
- 预约提醒功能
- 预约冲突检测

### 5. 统计分析（已有服务，缺少界面）
**现状**：
- ✅ 后端：完整的统计服务
- ✅ 后端：收入分析功能
- ✅ 后端：趋势数据生成
- ❌ 前端：缺少统计图表界面
- ❌ 前端：缺少数据导出功能

**需要新增**：
- 前端统计概览页面
- 图表组件（折线图、柱状图、饼图）
- 数据导出功能（Excel/PDF）
- 自定义报表功能

## 三、需要新增的后端API

### 1. 营养计划相关API
```javascript
// routes/nutrition/nutritionPlanRoutes.js
GET    /api/nutrition-plans              // 获取营养计划列表
POST   /api/nutrition-plans              // 创建营养计划
GET    /api/nutrition-plans/:id          // 获取计划详情
PUT    /api/nutrition-plans/:id          // 更新计划
DELETE /api/nutrition-plans/:id          // 删除计划
POST   /api/nutrition-plans/:id/share    // 分享计划
GET    /api/nutrition-plans/templates    // 获取计划模板
POST   /api/nutrition-plans/from-template // 从模板创建计划
```

### 2. 营养师工作台专用API
```javascript
// routes/nutritionist/workbenchRoutes.js
GET    /api/nutritionist/dashboard/stats     // 获取工作台统计数据
GET    /api/nutritionist/dashboard/tasks     // 获取待办任务
GET    /api/nutritionist/consultations       // 营养师视角的咨询列表
PUT    /api/nutritionist/consultations/:id/accept  // 接受咨询
PUT    /api/nutritionist/consultations/:id/reject  // 拒绝咨询
GET    /api/nutritionist/schedule            // 获取排班表
PUT    /api/nutritionist/schedule            // 更新排班
GET    /api/nutritionist/income/details      // 收入明细
POST   /api/nutritionist/clients/batch-message // 批量发送消息
```

### 3. 客户管理增强API
```javascript
// 扩展 nutritionistClientRoutes.js
GET    /api/nutritionist/clients/tags        // 获取所有客户标签
POST   /api/nutritionist/clients/:id/tags    // 添加客户标签
DELETE /api/nutritionist/clients/:id/tags/:tag // 删除客户标签
GET    /api/nutritionist/clients/:id/health-records // 获取健康记录历史
POST   /api/nutritionist/clients/:id/notes   // 添加营养师备注
```

### 4. 报表与导出API
```javascript
// routes/nutritionist/reportsRoutes.js
GET    /api/nutritionist/reports/monthly     // 月度报表
GET    /api/nutritionist/reports/clients     // 客户分析报表
GET    /api/nutritionist/reports/income      // 收入分析报表
POST   /api/nutritionist/reports/export      // 导出报表（Excel/PDF）
```

## 四、需要优化的前端页面

### 1. 新增页面

#### 1.1 咨询管理模块
- `consultation_list_page.dart` - 咨询列表页面
- `consultation_detail_page.dart` - 咨询详情与聊天页面
- `consultation_calendar_page.dart` - 预约日历页面

#### 1.2 客户管理模块
- `client_list_page.dart` - 客户列表页面
- `client_detail_page.dart` - 客户详情页面
- `client_health_record_page.dart` - 健康档案页面
- `client_progress_page.dart` - 进展跟踪页面

#### 1.3 营养计划模块
- `nutrition_plan_list_page.dart` - 计划列表页面
- `nutrition_plan_create_page.dart` - 计划创建向导
- `nutrition_plan_detail_page.dart` - 计划详情页面
- `nutrition_plan_templates_page.dart` - 计划模板库

#### 1.4 统计分析模块
- `statistics_overview_page.dart` - 统计概览页面
- `income_analysis_page.dart` - 收入分析页面
- `client_analysis_page.dart` - 客户分析页面
- `performance_report_page.dart` - 绩效报表页面

#### 1.5 设置管理模块
- `work_schedule_page.dart` - 工作时间设置
- `service_price_page.dart` - 服务价格设置
- `notification_settings_page.dart` - 通知设置

### 2. 优化现有页面

#### 2.1 工作台首页优化
- 添加实时数据刷新
- 优化任务卡片交互
- 添加快捷操作的实际功能
- 集成通知中心

#### 2.2 导航结构优化
- 实现底部导航栏（工作台、咨询、客户、计划、我的）
- 添加侧边栏快捷菜单
- 实现全局搜索功能

### 3. 通用组件开发

#### 3.1 业务组件
- `ConsultationCard` - 咨询卡片组件
- `ClientCard` - 客户卡片组件
- `NutritionPlanCard` - 营养计划卡片组件
- `StatisticsChart` - 统计图表组件
- `CalendarScheduler` - 日历排班组件

#### 3.2 功能组件
- `ChatBubble` - 聊天气泡组件
- `HealthMetricInput` - 健康指标输入组件
- `FoodSelector` - 食物选择器组件
- `TagSelector` - 标签选择器组件
- `ExportButton` - 导出按钮组件

## 五、技术实现要点

### 1. 实时通信
- 使用WebSocket实现咨询聊天
- 实现消息推送通知
- 在线状态实时更新

### 2. 数据缓存
- 客户列表本地缓存
- 聊天记录离线存储
- 统计数据定时更新

### 3. 性能优化
- 列表虚拟滚动
- 图片懒加载
- 分页加载

### 4. 用户体验
- 手势操作支持
- 动画过渡效果
- 错误处理与提示
- 加载状态显示

## 六、实施计划建议

### 第一阶段（核心功能）
1. 完成咨询管理界面开发
2. 实现客户列表与详情页面
3. 开发基础统计页面

### 第二阶段（增强功能）
1. 营养计划管理功能
2. 预约日历系统
3. 实时聊天功能

### 第三阶段（高级功能）
1. 完整的统计分析系统
2. 报表导出功能
3. 批量操作功能
4. 高级筛选与搜索

## 七、总结

营养师工作台的后端基础设施已经相当完善，主要缺失的是前端界面和部分API接口。建议优先实现核心的咨询管理和客户管理功能，这将立即提升营养师的工作效率。随后逐步完善统计分析、营养计划等高级功能，最终形成一个功能完整、体验优秀的营养师工作台系统。