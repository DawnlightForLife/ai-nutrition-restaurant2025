# 📚 Flutter项目文档中心

欢迎来到智能营养餐厅Flutter前端项目文档中心。本目录包含了项目的所有技术文档、指南和参考资料。

## 🗂️ 文档目录结构

### 📐 架构文档 (`architecture/`)
- [架构冻结文档 v1.8.0](./architecture/ARCHITECTURE_FREEZE.md) - 核心架构设计和技术栈
- [架构优化总结](./architecture/ARCHITECTURE_OPTIMIZATION_SUMMARY.md) - 架构优化历程
- [框架完成总结](./architecture/FRAMEWORK_COMPLETION_SUMMARY.md) - 框架实施细节
- [模块边界约束](./architecture/MODULE_BOUNDARIES_ENFORCEMENT.md) - 模块间依赖规则
- [共享与全局页面边界](./architecture/SHARED_VS_GLOBAL_PAGES_BOUNDARY.md) - 组件归属指南

### 📖 开发指南 (`guides/`)
- [开发指南](./guides/DEVELOPMENT_GUIDE.md) - 完整的开发流程和规范
- [AI开发规则](./guides/ai_development_rules.md) ⭐ - AI工具使用规范
- [团队协作指南](./guides/team_collaboration.md) - 团队工作流程
- [API集成指南](./guides/API_INTEGRATION_GUIDE.md) - 后端API对接
- [Riverpod迁移指南](./guides/RIVERPOD_MIGRATION_GUIDE.md) - 状态管理迁移
- [部署指南](./guides/DEPLOYMENT_GUIDE.md) - 应用部署流程
- [协调器与门面模式](./guides/COORDINATOR_FACADE_GUIDE.md) - 设计模式使用
- [图表组件指南](./guides/CHART_COMPONENTS_GUIDE.md) - 数据可视化
- [验证策略](./guides/validation_strategy.md) - 数据验证规范
- [离线优先设计](./guides/offline_first.md) - 离线功能实现

### 🧪 测试文档 (`testing/`)
- [测试架构](./testing/testing_architecture.md) - 测试策略和结构
- [第一阶段测试指南](./testing/phase1_test_guide.md) - 初期测试计划
- [营养档案测试指南](./testing/nutrition_profile_test_guide.md) - 功能测试示例

### 🔧 故障排除 (`troubleshooting/`)
- [构建问题](./troubleshooting/build_issues.md) - Flutter构建错误解决
- [常见问题](./troubleshooting/common_issues.md) - 开发中的常见问题

### 📦 模块文档 (`modules/`)
- [模块索引](./modules/INDEX.md) - 所有功能模块概览
- [认证模块](./modules/auth.md)
- [用户模块](./modules/user.md)
- [营养模块](./modules/nutrition.md)
- [订单模块](./modules/order.md)
- [推荐模块](./modules/recommendation.md)
- [咨询模块](./modules/consultation.md)
- [论坛模块](./modules/forum.md)
- [商家模块](./modules/merchant.md)
- [管理员模块](./modules/admin.md)
- [全局页面](./modules/global_pages.md)

### 🔗 API文档 (`api/`)
- API接口定义和示例

### 📝 其他资源
- [代码模板](./code_templates.md) - 常用代码片段
- [文件夹结构](./folder_structure.md) - 项目目录说明
- [功能模块模板](./FEATURE_MODULE_TEMPLATE.md) - 新模块创建模板

## 🚀 快速开始

1. **新成员入门**：先阅读 [开发指南](./guides/DEVELOPMENT_GUIDE.md)
2. **了解架构**：查看 [架构冻结文档](./architecture/ARCHITECTURE_FREEZE.md)
3. **AI工具使用**：必读 [AI开发规则](./guides/ai_development_rules.md)
4. **遇到问题**：查看 [故障排除](./troubleshooting/)

## 📋 文档维护

- 文档应与代码同步更新
- 重大变更需要更新相关文档
- 使用Markdown格式，保持格式一致
- 添加日期和版本信息

## 🔍 搜索提示

使用以下关键词快速找到需要的内容：
- `架构`、`architecture` - 系统设计相关
- `指南`、`guide` - 操作指导
- `规范`、`standard` - 编码规范
- `问题`、`issue` - 故障排除
- `模块`、`module` - 功能模块文档

---

最后更新：2024-01-XX
维护者：架构团队