
# 智慧AI营养餐厅 - Flutter 客户端

本项目为“智慧AI营养餐厅”多端应用的 Flutter 实现，支持用户端、商家端、营养师端和管理后台端，已完成三端联动结构设计与架构冻结。

---

## 📦 目录结构说明

```
lib/
 ┣ common/           # 通用功能与工具（样式、常量、异常处理、工具函数等）
 ┣ components/       # 可复用 UI 组件（按钮、弹窗、表单控件等）
 ┣ initializers/     # 应用初始化模块（配置加载、日志系统、设备信息等）
 ┣ middleware/       # 中间件机制（登录守卫、权限控制、路由监听等）
 ┣ models/           # 按模块划分的数据模型（与后端结构完全对齐）
 ┣ providers/        # Provider 状态管理（每个模块一个）
 ┣ repositories/     # Repository 层，封装 service + mock 数据切换
 ┣ router/           # 路由管理与守卫规则（guards、routes、路由配置）
 ┣ screens/          # 页面目录，已按四个角色（user/merchant/nutritionist/admin）细分
 ┣ services/         # API 请求服务封装（按模块划分）
 ┣ l10n/             # 国际化资源
 ┣ main.dart         # 应用入口
 ┣ splash_screen.dart# 启动页
 ┗ README.md         # 本说明文档
```

---

## 🔧 项目状态

| 模块            | 状态       | 说明                                     |
|-----------------|------------|------------------------------------------|
| 页面结构         | ✅ 已完成   | 全模块页面文件均已就绪，按角色划分       |
| 模型结构         | ✅ 已完成   | 前端与后端模型结构严格对应，均已冻结     |
| 状态管理 Provider| ✅ 已补全   | 各模块 Provider 均已创建，支持扩展       |
| 服务 Service     | ✅ 已补全   | 所有模块服务已完成模块化封装             |
| Repository       | ✅ 已补全   | 所有模块已创建 Repository 供逻辑解耦     |
| 初始化机制       | ✅ 已建立   | 配置初始化、SharedPrefs、日志、服务注入  |
| UI组件结构       | ✅ 完善中   | 通用组件与业务组件分离，目录清晰         |
| 中间件机制       | ✅ 已构建   | 路由守卫/权限控制/路由监听均已就位       |

---

## 🧩 已冻结机制

- ✅ Flutter 项目整体结构
- ✅ 全模块页面入口与分类
- ✅ Provider、Service、Repository 三层结构映射关系
- ✅ 初始中间件机制
- ✅ 初始组件分类与复用标准

---

## 📚 开发规范指引

> 文档位于 `docs/` 目录，供团队参考使用：

- [`FLUTTER_ARCHITECTURE_FROZEN.md`](docs/FLUTTER_ARCHITECTURE_FROZEN.md)
- [`COMPONENTS_GUIDELINES.md`](docs/COMPONENTS_GUIDELINES.md)
- [`ROUTER_STRUCTURE.md`](docs/ROUTER_STRUCTURE.md)
- [`PROVIDER_SERVICE_MAPPING.md`](docs/PROVIDER_SERVICE_MAPPING.md)
- [`REPOSITORY_LAYER_GUIDELINES.md`](docs/REPOSITORY_LAYER_GUIDELINES.md)

---

## ✨ 后续建议开发顺序

1. 填充组件内容（如按钮、卡片、加载提示等）
2. 按角色完善页面交互与功能
3. 与后端接口联调（基于已冻结数据库模型）
4. 集成异常处理、日志、埋点、空状态等机制
5. 国际化扩展（若有需求）

---

## 📌 技术栈

- Flutter 3.x（多端适配）
- Provider 状态管理
- Dio/Http（请求库）
- SharedPreferences（本地持久化）
- 国际化支持：Flutter Intl
- 状态组件封装、统一 Loading/Empty/Error 状态展示

---

如需继续开发，请确保遵循架构冻结文档中定义的原则。如需结构性调整，请提交架构变更申请。
