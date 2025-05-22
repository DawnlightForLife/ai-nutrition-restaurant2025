📦 智能营养餐厅 Flutter 前端架构冻结文档（v1.5.0）

状态：✅ 已冻结
日期：2025-06-10
作者：系统架构组（助手 + Cursor）
适用平台：iOS / Android / Web / Desktop（Flutter 多端统一）

> **注释**：当前架构采用模块优先结构，不再使用 DDD。

1. 架构设计目标
 • 采用模块优先结构，精确映射业务模块和数据接口
 • 实现清晰的分层架构和高内聚低耦合的模块结构
 • 支持组件化、模块化开发，提高代码可维护性和扩展性
 • 支持离线优先原则、依赖注入和跨端部署能力
 • 实现高性能渲染和流畅用户体验，确保数据密集型交互场景的性能
 • 支持AI驱动的个性化推荐和数据分析可视化展示
 • 集成代码模板生成工具，提高开发效率和一致性
 • 提供组件预览和文档系统，促进设计与开发协作

2. 技术栈说明

分类                技术    

框架             Flutter 3.x（Stable）（目标迁移到3.19+）
状态管理          Provider / flutter_riverpod（已实现平滑过渡）
路由系统          auto_route（支持声明式路由、嵌套路由和路径参数）
本地存储          Hive / SharedPreferences / flutter_secure_storage
网络             dio + retrofit + connectivity_plus + 自定义拦截器
依赖注入          get_it + injectable（完全接入）
测试框架          flutter_test / mockito / mocktail / golden_toolkit
构建系统          flutter_flavors + fastlane（支持多环境自动打包）
性能监控          flutter_performance + custom_traces（性能关键路径监控）
UI框架           Material 3 + 自定义主题系统（支持动态主题）
动画系统          flutter_animate + rive（高级交互动画）
图表与可视化      fl_chart + syncfusion_flutter_charts（营养数据可视化）
分析与跟踪        firebase_analytics + custom_event_tracking（自定义行为分析）
AI集成            tflite_flutter + 自研AI推荐引擎桥接器
三方集成          自研Plugin适配器（标准化第三方服务集成）
组件预览系统       widgetbook + widgetbook_test（组件库与Golden测试联动）
架构模板生成器     mason + 自定义砖块模板（一致性代码生成工具）

4. 详细目录结构和职责边界（模块优先结构核心说明）

本项目当前采用“模块优先结构”为核心架构设计原则，旨在提升模块聚合能力、提升开发效率，并保持业务职责的清晰划分。每个业务模块为一个独立单元，自包含其 `models`、`providers`、`screens`、`services`、`widgets` 等核心功能目录。

所有 modules/{module}/ 下的目录结构必须保持统一，包括 models、providers、screens、services、widgets 等五大子目录，每个子目录职责如下：
- models：定义该模块核心数据结构、DTO、模型转换逻辑
- providers：封装状态管理逻辑（如 ChangeNotifier 或 riverpod）
- screens：完整页面，负责 UI 呈现和交互响应
- services：模块内服务层，调用全局或本地 API，聚合数据
- widgets：该模块的通用组件，供 screens 复用

模块结构强调模块自包含，适配多端，且与后端 API 数据结构保持一致，方便维护和扩展。

#### 📁 lib/
```
├── app/                    // 应用入口与核心配置封装
│   ├── app.dart            // 应用根组件
│   ├── main.dart           // 应用入口（main 函数）
│   ├── router.dart         // 路由声明（自动路由）
│   └── router.gr.dart      // 自动生成的路由文件
├── config/                 // 全局配置（环境、注入、国际化等）
│   ├── config.dart
│   ├── env_config.dart
│   ├── l10n_config.dart
│   ├── locator_config.dart
│   ├── route_config.dart
│   └── widgetbook_config.dart
├── common/                 // 通用基础工具与样式
│   ├── constants/          // 常量定义
│   ├── exceptions/         // 错误封装
│   ├── styles/             // 样式定义（颜色、间距、阴影）
│   ├── utils/              // 工具函数（日志、格式化、缓存）
│   └── widgets/            // 可复用组件（按钮、加载框、图片等）
├── environment/            // 不同环境变量配置（开发 / 生产）
│   ├── dev.dart
│   └── prod.dart
├── gen/                    // 自动生成文件目录（如 FlutterGen）
├── hooks/                  // 自定义 Hook 工具
├── l10n/                   // 国际化资源与生成文件（可选）
├── mason_bricks/           // Mason 模板砖配置（模块代码生成）
├── modules/                // 业务模块集合（核心结构）
│   ├── user/               // 用户模块（如注册、登录）
│   │   ├── models/
│   │   ├── providers/
│   │   ├── screens/
│   │   ├── services/
│   │   └── widgets/
│   ├── order/              // 订单模块
│   ├── nutrition/          // 营养模块
│   ├── auth/               // 鉴权模块
│   ├── forum/              // 社区模块
│   ├── consult/            // 咨询模块
│   ├── merchant/           // 商户模块
│   ├── settings/           // 设置模块（如语言/主题）
│   ├── onboarding/         // 引导模块（欢迎页、入门页）
│   ├── analytics/          // 分析模块（使用日志、统计）
│   ├── core/               // 核心模块（如 MainPage、SplashPage）
│   └── notification/       // 通知模块
├── plugins/                // 插件系统封装（如 Web 插件适配）
├── providers/              // 全局 Provider 统一注册入口
│   └── app_providers.dart
├── repositories/           // 可选的仓库层抽象封装
├── services/               // 全局服务接口与 openapi 生成文件
│   ├── generated/          // OpenAPI Generator 自动生成接口
│   │   ├── api/
│   │   ├── auth/
│   │   ├── model/
│   │   └── api_client.dart 等
│   └── api_client.dart     // 封装 API 请求客户端
```

#### 🎯 模块内部结构标准（以 user 模块为例）

```
modules/user/
├── models/           // 领域数据结构（如 User、UserRole）
├── providers/        // 状态管理类（ChangeNotifier / Riverpod）
├── screens/          // 页面组件（LoginPage、RegisterPage）
├── services/         // 与 API 的交互封装（UserService）
└── widgets/          // 模块专属可复用组件（如头像组件）
```

> 每个模块完全自包含，具备独立开发、测试、维护能力。模块中目录结构统一，方便团队协作和代码管理。

6. 后端与前端映射关系

后端模块                     前端模块
────────────────────────────────────────────────────
user/                       user/                         // 用户模块
nutrition/                  nutrition/                    // 营养模块
restaurant/                 restaurant/                   // 餐厅模块 
order/                      order/                        // 订单模块
forum/                      forum/                        // 社区模块
merchant/                   merchant/                     // 商户模块

19. 架构冻结说明与版本标记
	•	本文档标志当前前端架构已达成稳定版本
	•	当前架构版本号：v1.5.0
	•	架构变更需要提交RFC并经架构评审通过

7. 命名规范
	•	领域实体：xxx.dart
	•	接口定义：i_xxx.dart
	•	用例类：xxx_use_case.dart
	•	仓库实现：xxx_repository.dart
	•	服务实现：xxx_service.dart
	•	视图组件：xxx_screen.dart / xxx_page.dart
	•	Provider：xxx_provider.dart
	•	插件类：xxx_plugin.dart / xxx_adapter.dart

8. 状态管理说明
	•	主要使用 Provider + ChangeNotifier 管理各模块状态
	•	集成了 flutter_riverpod 的支持，新模块推荐使用
	•	所有Provider统一在 providers/ 目录下按模块分组管理
	•	提供了 Provider ↔ UseCase 的优雅集成模式
	•	Provider必须引用抽象接口（如IxxxRepository），而非具体实现类
	•	全局状态与本地状态分离，确保针对性能优化
	•	所有状态变更需通知UI刷新必须在Provider中实现
	•	复杂状态推荐使用状态机模式管理（StateMachine）

9. 路由结构说明
	•	基于auto_route实现声明式路由系统：routes/app_router.dart负责全局配置
	•	页面组件使用@RoutePage()注解，自动生成路由代码
	•	支持路径参数传递（如'/dishes/:id'）和查询参数
	•	实现嵌套路由结构，支持父子路由关系
	•	支持基于标签的导航（AutoTabsRouter实现）
	•	使用context.router接口替代Navigator，统一导航API
	•	路由拦截与守卫通过RouteGuard实现
	•	主要页面结构：
		- 闪屏页：SplashScreen (@RoutePage())
		- 登录页：LoginPage (@RoutePage())
		- 主页：HomeScreen (@RoutePage())
		- 详情页：DishDetailPage (@RoutePage())

10. 数据存储策略
	•	采用分层存储策略：
		- 敏感数据：flutter_secure_storage
		- 用户偏好：SharedPreferences
		- 结构化数据：Hive（支持加密）
		- 大型二进制文件：文件系统（App Documents）
	•	实现离线优先策略：repositories 层处理在线/离线数据协调
	•	支持缓存过期、自动更新和冲突解决机制
	•	实现自动数据同步服务，处理离线操作队列
	•	实现增量更新，优化流量和存储空间使用

11. 错误处理与日志
	•	统一的错误处理机制：Result<T> 类型封装操作结果
	•	多级日志记录：debug/info/warn/error
	•	混合日志策略：本地存储 + 远程报告
	•	全局错误处理器，捕获未处理异常
	•	基于环境的日志级别控制
	•	用户行为采集：提供用户使用情况分析
	•	错误聚合与分析：按类型和频率聚合错误

12. 测试策略
	•	单元测试：针对领域层和应用层
		- 所有用例（UseCase）必须100%测试覆盖
		- 所有领域服务必须编写单元测试
	•	组件测试：针对UI组件
		- 关键UI组件需编写Widget测试
		- 使用golden测试确保UI一致性
		- 通过widgetbook_test实现组件库与Golden测试联动
	•	集成测试：针对关键功能流程
		- 用户登录、注册流程
		- 订单创建和支付流程
		- 营养计划生成流程
	•	性能测试：针对性能关键路径
		- 首屏加载时间
		- 列表滚动性能
		- 图表渲染性能
	•	测试覆盖率报告生成：
		- 使用lcov生成覆盖率报告
		- CI环境自动发布覆盖率报告
		- 使用lcov.ignore排除生成的代码

13. 依赖注入规范
	•	所有仓库必须提供抽象接口(IxxxRepository)
	•	具体实现必须使用@injectable和@LazySingleton(as: IxxxRepository)注解
	•	Provider必须引用接口类型而非具体实现类
	•	依赖应通过构造函数注入而非直接实例化
	•	构造函数参数应使用接口类型而非具体实现类
	•	不同环境(开发/测试/生产)使用不同实现，但保持接口一致
	•	测试环境允许使用Mock实现替代真实实现
	•	依赖注入代码生成规范：
		- 所有依赖注入配置必须使用.config.dart自动生成
		- 抽象接口统一放在domain/abstractions/目录
		- 服务实现统一放在services/目录
		- 使用@Injectable()或@LazySingleton()注解标记实现类
		- 使用as参数指定实现的接口：@LazySingleton(as: IUserRepository)
		- 禁止手动注册依赖，统一使用configureDependencies()自动注册
		- core/di/injection.dart文件负责初始化依赖注入容器
		- core/di/injection.config.dart由build_runner自动生成

14. 插件系统规范
	•	所有插件必须实现领域层定义的服务接口
	•	通用插件必须提供适配器类，支持不同的外部服务实现
	•	插件配置应通过依赖注入管理，不得硬编码
	•	主要插件类必须使用@LazySingleton注解注册为接口实现
	•	第三方服务插件分类：
		- sms: 短信服务(阿里云、腾讯云)
		- payment: 支付服务(微信、支付宝、Stripe)
		- email: 邮件服务(SMTP、API)
		- storage: 文件存储(阿里云OSS、其他云存储)
		- export: 数据导出(PDF、Excel)
		- llm: AI模型(OpenAI、本地模型)
		- platform: 第三方平台(企业微信、钉钉、OAuth)

15. 性能优化策略
	•	图片优化：
		- 使用适当分辨率图片，避免过大尺寸
		- 实现图片延迟加载和预加载
		- 使用缓存减少网络请求
	•	渲染优化：
		- 使用const构造函数减少重建
		- 列表使用ListView.builder优化大量条目渲染
		- 复杂UI使用RepaintBoundary隔离重绘区域
	•	状态优化：
		- 局部状态优先于全局状态
		- 使用ValueNotifier代替整个Widget rebuild
		- 复杂Widget拆分，避免过度rebuild
	•	网络优化：
		- 批量请求合并
		- 数据缓存降低请求频率
		- 使用连接状态管理避免无效请求
	•	存储优化：
		- 使用二进制格式存储大量数据
		- 定期清理临时文件和缓存
		- 实现增量更新减少传输数据量

16. 安全实践
	•	数据安全：
		- 敏感数据加密存储
		- 网络传输使用HTTPS
		- API请求添加签名和防重放机制
	•	认证与授权：
		- 使用JWT和刷新令牌机制
		- 实现OAuth2.0授权流程
		- 敏感操作二次验证
	•	代码安全：
		- 密钥不硬编码，使用环境变量或安全存储
		- 混淆和代码保护机制
		- 依赖库安全审计

17. 与数据库模型冻结的集成关系

**用户领域映射**
| 数据库模型 | 前端领域实体 | 应用层用例 |
|----------|-------------|----------|
| User | domain/user/entities/user.dart | application/user/get_user_profile_use_case.dart |
| UserRole | domain/user/entities/user_role.dart | application/user/manage_roles_use_case.dart |

**营养领域映射**
| 数据库模型 | 前端领域实体 | 应用层用例 |
|----------|-------------|----------|
| NutritionProfile | domain/nutrition/entities/nutrition_profile.dart | application/nutrition/update_profile_use_case.dart |
| AiRecommendation | domain/nutrition/entities/ai_recommendation.dart | application/nutrition/generate_recommendation_use_case.dart |
| Nutritionist | domain/nutrition/entities/nutritionist.dart | application/nutrition/find_nutritionists_use_case.dart |

**商家领域映射**
| 数据库模型 | 前端领域实体 | 应用层用例 |
|----------|-------------|----------|
| Merchant | domain/restaurant/entities/merchant.dart | application/restaurant/get_merchant_details_use_case.dart |
| ProductDish | domain/restaurant/entities/product_dish.dart | application/restaurant/list_dishes_use_case.dart |

**订单领域映射**
| 数据库模型 | 前端领域实体 | 应用层用例 |
|----------|-------------|----------|
| Order | domain/order/entities/order.dart | application/order/create_order_use_case.dart |
| Subscription | domain/order/entities/subscription.dart | application/order/manage_subscription_use_case.dart |

**社区领域映射**
| 数据库模型 | 前端领域实体 | 应用层用例 |
|----------|-------------|----------|
| ForumPost | domain/forum/entities/forum_post.dart | application/forum/create_post_use_case.dart |
| ForumTag | domain/forum/entities/forum_tag.dart | application/forum/filter_by_tags_use_case.dart |

18. 多平台适配策略
	•	响应式布局:
		- 采用LayoutBuilder和MediaQuery自适应不同屏幕
		- 细粒度自适应组件设计
		- 断点系统定义不同屏幕布局策略
	•	平台差异化:
		- 使用Platform检测运行平台
		- 根据平台条件编译不同实现
		- 平台特定功能封装在抽象接口后
	•	输入适配:
		- 触摸、鼠标、键盘多输入模式支持
		- 快捷键系统（桌面平台）
		- 手势系统（移动平台）
	•	主题适配:
		- 暗色/亮色模式支持
		- 平台特定视觉风格（Material/Cupertino）
		- 动态颜色系统（Material You支持）

20. 组件预览系统（Widgetbook）
	•	所有UI组件必须在Widgetbook中注册并提供预览
	•	组件按功能分类：按钮、卡片、输入控件、指示器、导航
	•	每个组件必须展示所有可能的状态和变体
	•	组件预览必须支持以下功能：
		- 设备框架预览：多种设备尺寸适配
		- 主题切换：亮色/暗色主题支持
		- 文本缩放：不同文本比例展示
	•	组件必须与Golden测试联动，确保UI一致性
	•	组件文档必须包含使用说明和示例代码
	•	启动Widgetbook预览系统：
		- 使用指定入口：lib/widgetbook/widgetbook_main.dart
		- 通过脚本启动：scripts/run_widgetbook.sh

21. 架构模板系统（Mason）
	•	使用Mason模板引擎生成标准化代码结构
	•	核心模板包括：
		- 功能模块模板(feature_module)：生成完整的模块优先结构代码
		- UI组件模板(widget)：生成组件及关联测试
	•	使用预定义脚本简化模板使用：
		- scripts/init_mason.sh：初始化Mason环境
		- scripts/create_module.sh：创建新功能模块
		- scripts/create_widget.sh：创建新UI组件
	•	遵循模板生成规范：
		- 生成的代码必须符合项目架构标准
		- 必须包含必要的测试文件
		- 必须集成依赖注入系统
		- 文件位置必须符合目录结构规范
	•	详细文档参考：docs/MASON_TEMPLATES.md

22. 架构未来演进建议
• 采用更细粒度依赖注入容器分区，提升模块隔离性；
• 将 `domain/` 层实体与 API Model 显式解耦，提升复用性；
• 引入 sealed class / union 类型优化状态管理与错误处理表达；
• 引入 Freezed 等代码生成器提升模型一致性；
• 逐步整合 riverpod v3，并统一 Provider 声明规范。

变更记录:
- v1.5.0 (2025-06-10): 增加组件预览系统(Widgetbook)和架构模板系统(Mason)章节，切换至模块优先结构
- v1.4.0 (2025-06-15): 增加性能优化策略、安全实践、多平台适配和数据库模型映射
- v1.3.0 (2025-06-01): 添加插件系统架构规范，完善第三方服务集成
- v1.2.1 (2025-05-25): 更新依赖注入规范，添加Provider和仓库接口使用指南
- v1.1.0 (2025-05-20): 初始架构冻结版本