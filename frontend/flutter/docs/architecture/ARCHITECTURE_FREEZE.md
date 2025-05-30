📦 智能营养餐厅 Flutter 前端架构冻结文档（v1.8.0）

状态：✅ 已冻结 - 基础设施完成阶段
日期：2025-05-27
作者：系统架构组（助手 + Cursor）
适用平台：iOS / Android / Web / Desktop（Flutter 多端统一）

1. 架构设计目标
	•	采用领域驱动设计(DDD)架构，精确映射业务领域模型
	•	实现清晰的分层架构和高内聚低耦合的模块结构
	•	支持组件化、模块化开发，提高代码可维护性和扩展性
	•	支持离线优先原则、依赖注入和跨端部署能力
	•	实现高性能渲染和流畅用户体验，确保数据密集型交互场景的性能
	•	支持AI驱动的个性化推荐和数据分析可视化展示
	•	集成代码模板生成工具，提高开发效率和一致性
	•	提供组件预览和文档系统，促进设计与开发协作

⸻

2. 技术栈说明

分类                技术    

框架             Flutter 3.x（Stable）（目标迁移到3.19+）
状态管理          Provider / flutter_riverpod（已实现平滑过渡）
路由系统          auto_route（支持声明式路由、嵌套路由和路径参数）
本地存储          Hive / SharedPreferences / flutter_secure_storage
网络             dio + retrofit + connectivity_plus + 自定义拦截器 + OpenAPI Generator
依赖注入          get_it + injectable（完全接入）
测试框架          flutter_test / mockito / mocktail / golden_toolkit
构建系统          flutter_flavors + fastlane（支持多环境自动打包）
性能监控          flutter_performance + custom_traces（性能关键路径监控）
UI框架           Material 3 + 自定义主题系统（支持动态主题）
动画系统          flutter_animate + rive（高级交互动画）
图表与可视化      fl_chart + syncfusion_flutter_charts（营养数据可视化）
分析与跟踪        firebase_analytics + custom_event_tracking（自定义行为分析）
AI集成            tflite_flutter + 自研AI推荐引擎桥接器
                  （当前阶段仅提供AI模型测试占位接口，正式AI模型将在后续训练完成后集成。）
三方集成          自研Plugin适配器（标准化第三方服务集成）
组件预览系统       widgetbook + widgetbook_test（组件库与Golden测试联动）
架构模板生成器     mason + 自定义砖块模板（一致性代码生成工具）
事件驱动架构      领域事件总线（EventBus）+ 跨模块通信机制
API同步          OpenAPI Generator + 前后端模型自动同步
代码生成         build_runner + freezed + json_serializable + 自定义Mapper生成器


3. 项目架构分层（Clean Architecture + DDD）

📁 lib/
├── domain/               // 领域层：实体、接口和业务规则（核心业务模型）
│   ├── abstractions/     // 抽象接口定义（仓库、服务接口）
│   ├── common/           // 领域通用组件（基类、枚举、常量）
│   └── {module}/         // 按模块分组的领域模型（实体、值对象、聚合）
├── application/          // 应用层：用例实现和业务流程协调
│   ├── core/             // 用例基础类（基类、执行器）
│   └── {module}/         // 按模块分组的用例（业务操作封装）
├── infrastructure/       // 基础设施层：技术实现和外部资源访问
│   ├── repositories/     // 仓库实现（数据访问控制）
│   ├── services/         // 服务实现（API、本地服务）
│   ├── datasources/      // 数据源实现（远程、本地）
│   ├── mappers/          // 数据转换和映射（DTO-Entity转换）
│   │   ├── base_mapper.dart  // Mapper基类
│   │   └── generated/    // 自动生成的Mapper
│   ├── dtos/             // 数据传输对象
│   │   ├── base_dto.dart     // DTO基类
│   │   └── generated/    // OpenAPI生成的DTO
│   └── api/              // API相关
│       ├── error_handler.dart // 统一错误处理
│       └── generated/    // OpenAPI生成的客户端
├── presentation/         // 表现层：UI组件和用户交互
│   ├── screens/          // 页面组件（完整页面）
│   ├── components/       // UI组件（可复用组件）
│   ├── viewmodels/       // 视图模型（状态和UI逻辑）
│   ├── providers/        // 状态提供者（状态管理）
│   └── utils/            // UI辅助工具（格式化、验证）
├── core/                 // 核心组件：DI容器、基础类、工具函数
│   ├── plugins/          // 插件系统
│   │   ├── plugin_manager.dart  // 插件管理器
│   │   └── plugin.dart   // 插件接口
├── common/               // 通用组件：常量、工具、主题
├── widgetbook/           // 组件预览和文档系统

4. 详细目录结构和职责边界

📁 lib/
├── app.dart              // 应用根组件
├── main.dart             // 应用入口和初始化
├── common/               // 通用组件和工具
├── components/           // 可复用UI组件库
├── config/               // 全局配置（环境、路由等）
├── core/                 // 核心功能
│   └── di/               // 依赖注入相关
├── domain/               // 领域层
│   ├── abstractions/     // 接口定义
│   ├── common/           // 领域共享组件
│   │   ├── failures/     // 失败类型定义
│   │   ├── facade/       // 模块Facade接口
│   │   └── value_objects/ // 通用值对象
│   ├── events/           // 领域事件
│   ├── user/             // 用户领域
│   ├── restaurant/       // 餐厅领域
│   ├── order/            // 订单领域
│   └── nutrition/        // 营养领域
├── application/          // 应用层用例
│   ├── core/             // 用例基础类
│   ├── facades/          // 模块Facade实现
│   ├── services/         // 应用服务
│   │   └── event_bus.dart // 事件总线
│   ├── event_handlers/   // 事件处理器
│   ├── user/             // 用户相关用例
│   ├── auth/             // 认证相关用例
│   ├── nutrition/        // 营养相关用例
│   └── order/            // 订单相关用例
├── models/               // 数据模型（视图模型）
├── presentation/         // 表现层
│   ├── providers/        // 状态管理
│   │   ├── {module}/     // Provider模式
│   │   └── riverpod/     // Riverpod模式
│   └── components/       // UI组件
│       └── charts/       // 图表组件
├── repositories/         // 数据仓库实现
├── routes/               // 路由定义和配置
├── screens/              // UI页面组件
├── services/             // 服务实现层
│   ├── core/             // 核心服务
│   ├── api/              // API服务
│   └── plugins/          // 插件服务
│       ├── sms/          // 短信服务
│       ├── payment/      // 支付服务
│       ├── email/        // 邮件服务
│       ├── storage/      // 文件存储
│       ├── export/       // 数据导出
│       ├── llm/          // AI模型
│       ├── platform/     // 第三方平台
│       └── share/        // 分享服务
├── storage/              // 存储相关服务
├── extensions/           // 扩展方法
├── hooks/                // 自定义Hooks
│   ├── app_hooks.dart    // 应用生命周期钩子
│   └── hook_manager.dart // 钩子管理器
├── l10n/                 // 国际化资源
├── widgetbook/           // 组件预览系统
│   ├── widgetbook_main.dart // 预览系统入口
│   ├── app_widgetbook.dart  // 组件注册中心
│   └── categories/          // 组件分类

5. 模块映射关系（DDD ↔ 项目结构）

DDD层                    项目目录
实体 (Entity)           domain/{module}/entities/
值对象 (Value Object)    domain/{module}/value_objects/
聚合 (Aggregate)        domain/{module}/aggregates/
聚合根 (Root)           domain/{module}/aggregates/{name}_root.dart
仓库接口 (Repository)    domain/abstractions/repositories/
服务接口 (Service)       domain/abstractions/services/
领域事件 (Domain Event)  domain/events/
领域服务 (Domain Service) domain/{module}/services/
用例 (Use Case)         application/{module}/
DTO (数据传输对象)       infrastructure/dtos/
仓库实现                repositories/
服务实现                services/
UI控制器                screens/
视图模型                viewmodels/ 和 providers/

6. 后端与前端映射关系

后端（Node.js + DDD）        前端（Flutter + DDD）
────────────────────────────────────────────────────

后端 domain/                 前端 domain/                    // 领域模型映射
后端 application/            前端 application/               // 应用层用例映射
后端 models/                 前端 models/                    // 数据模型定义
后端 controllers/            前端 screens/                   // 控制器与UI映射
后端 services/               前端 services/                  // 服务层实现
后端 repositories/           前端 repositories/              // 存储库实现
后端 routes/                 前端 routes/                    // 路由结构映射
后端 middleware/             前端 core/di/ + services/       // 中间件功能映射
后端 plugins/                前端 services/plugins/          // 三方服务映射
后端 hooks/                  前端 hooks/                     // 钩子系统映射
后端 constants/              前端 common/constants/          // 常量定义映射
后端 types/                  前端 domain/ + models/          // 类型系统映射
后端 utils/                  前端 common/utils/              // 工具函数映射
后端 config/                 前端 config/                    // 配置文件映射
后端 jobs/                   前端 services/background/       // 后台任务映射

业务模块映射（按领域划分）:

后端模块                     前端模块
────────────────────────────────────────────────────
user/                       user/                         // 用户模块
nutrition/                  nutrition/                    // 营养模块
restaurant/                 restaurant/                   // 餐厅模块 
order/                      order/                        // 订单模块
forum/                      forum/                        // 社区模块
merchant/                   merchant/                     // 商户模块

7. 命名规范
	•	领域实体：xxx.dart
	•	值对象：xxx.dart (在value_objects目录下)
	•	接口定义：i_xxx.dart
	•	用例类：xxx_use_case.dart
	•	仓库实现：xxx_repository.dart
	•	服务实现：xxx_service.dart
	•	DTO对象：xxx_dto.dart
	•	视图组件：xxx_screen.dart / xxx_page.dart
	•	Provider：xxx_provider.dart
	•	插件类：xxx_plugin.dart / xxx_adapter.dart

8. 状态管理说明
	•	最终统一使用Riverpod进行状态管理，逐步完成Provider迁移，新的模块开发需使用Riverpod。
	•	主要使用 Provider + ChangeNotifier 管理各模块状态（历史模块）
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
	•	详细的离线数据同步机制与冲突解决策略（如Last-Write-Wins、版本冲突检测等）。

11. 错误处理与日志
	•	统一的错误处理机制：Result<T> 类型封装操作结果
	•	多级日志记录：debug/info/warn/error
	•	混合日志策略：本地存储 + 远程报告
	•	全局错误处理器，捕获未处理异常
	•	基于环境的日志级别控制
	•	用户行为采集：提供用户使用情况分析
	•	错误聚合与分析：按类型和频率聚合错误
	•	明确日志聚合与分析工具（推荐Firebase Crashlytics/Sentry），明确报警阈值、报警渠道（如企业微信、钉钉）和自动响应机制。

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
	•	测试覆盖率要求：
		- 核心业务逻辑单元测试覆盖率必须≥90%
		- UI组件测试覆盖率必须≥70%
		- 关键业务流程必须实现100%集成测试覆盖
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
	•	明确插件生命周期管理细节与插件失败回退策略，需定义版本控制和回滚方案。
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

19. 冻结说明与版本标记
	•	本文档标志当前前端架构已达成稳定版本
	•	当前架构版本号：v1.5.0
	•	架构冻结标识文件：.architecture-frozen 和 .structure-frozen
	•	架构变更需要提交RFC并经架构评审通过

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
		- 功能模块模板(feature_module)：生成完整的Clean Architecture + DDD结构
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

22. API集成与模型同步系统
	•	基于OpenAPI Generator实现前后端模型自动同步
	•	配置文件：openapi-generator-config.yaml定义生成策略
	•	生成内容包括：
		- DTO模型：lib/infrastructure/dtos/generated/
		- API客户端：lib/infrastructure/api_client/generated/
		- 支持Freezed不可变模型和JSON序列化
	•	自动化同步流程：
		- 执行脚本：scripts/generate-openapi-models.sh
		- CI/CD集成：.github/workflows/sync-models.yml
		- 变更检测：自动识别后端API变更并生成PR
	•	Mapper自动生成系统：
		- 基类定义：BaseMapper<DTO, Entity>
		- 生成脚本：scripts/generate-mappers.sh
		- 输出目录：lib/infrastructure/mappers/generated/
	•	统一错误处理：
		- ApiErrorHandler处理所有API错误
		- 错误类型映射到领域失败类型
		- 支持网络错误、验证错误、认证错误等

23. 模块化Facade架构
	•	每个业务模块通过Facade提供统一对外接口
	•	基础接口：ModuleFacade定义标准生命周期
	•	实现示例：
		- UserFacade：用户模块所有操作入口
		- NutritionFacade：营养模块所有操作入口
		- OrderFacade：订单模块所有操作入口
	•	模块注册器：ModuleRegistry统一管理所有模块
	•	优势：
		- 明确的模块边界，避免跨模块直接调用
		- 统一的初始化和销毁机制
		- 便于模块级别的测试和模拟
		- 支持模块懒加载和按需初始化

24. Riverpod状态管理迁移
	•	保持与Provider的兼容性，支持渐进式迁移
	•	新功能优先使用Riverpod，旧功能逐步迁移
	•	AsyncNotifier模式处理异步状态：
		- 自动处理loading/data/error状态
		- 内置缓存和依赖追踪
		- 支持状态持久化
	•	Provider组织结构：
		- lib/presentation/providers/riverpod/
		- 按模块分组管理
		- 支持代码生成(@riverpod注解)
	•	最佳实践：
		- 使用AsyncValue.guard处理异步操作
		- 使用ref.invalidate刷新数据
		- 避免在build方法中执行副作用

25. 领域事件总线系统
	•	实现基于发布-订阅模式的事件驱动架构
	•	核心组件：
		- DomainEvent：所有事件的基类
		- EventBus：事件发布和订阅中心
		- EventHandler：事件处理器类型定义
	•	事件类型示例：
		- UserLoggedInEvent：用户登录事件
		- NutritionProfileUpdatedEvent：营养档案更新事件
		- OrderCompletedEvent：订单完成事件
	•	跨模块通信：
		- 模块间通过事件解耦，避免直接依赖
		- 支持异步事件处理
		- 事件可携带领域数据
	•	使用方式：
		- 发布：event.publish() 或 EventBus().publish(event)
		- 订阅：EventBus().on<EventType>(handler)
		- 取消订阅：subscription.cancel()

26. 数据可视化组件系统
	•	统一的图表组件架构，支持多种图表库
	•	基础配置：ChartConfig定义通用配置
	•	主题系统：ChartTheme支持明暗主题
	•	组件类型：
		- NutritionPieChart：营养成分饼图
		- NutritionTrendChart：营养趋势折线图
		- 更多图表类型持续添加中
	•	状态处理：
		- BaseChart.loading()：加载状态
		- BaseChart.error()：错误状态
		- BaseChart.empty()：空数据状态
	•	Widgetbook集成：
		- 所有图表组件必须注册到Widgetbook
		- 提供不同状态和配置的预览
		- 支持Golden测试验证UI一致性

27. 测试架构增强
	•	模块化测试套件：test/modules/{module}/
	•	Mock数据生成器：test/fixtures/mock_generator.dart
	•	Golden测试支持：test/golden/
	•	测试运行脚本：scripts/run-tests.sh
	•	测试类型：
		- 单元测试：业务逻辑测试
		- 组件测试：UI组件测试
		- 集成测试：模块间协作测试
		- Golden测试：UI一致性测试
	•	覆盖率目标：
		- 核心业务逻辑 > 80%
		- UI组件 > 60%
		- 关键流程100%覆盖

28. 值对象（Value Objects）系统
	•	实现领域驱动设计中的值对象概念
	•	提供不可变性和业务规则验证
	•	主要值对象：
		- PhoneNumber：电话号码验证和格式化
		- Email：邮箱地址验证
		- Money：金额处理（待实现）
		- Address：地址信息（待实现）
	•	使用Either<Failure, ValueObject>处理创建失败
	•	自动格式化和标准化输入数据

29. DTO层架构
	•	实现前后端数据传输的标准化
	•	BaseDto提供通用响应结构：
		- ApiResponse<T>：标准API响应包装
		- PaginatedResponse<T>：分页数据响应
		- ErrorResponse：错误响应格式
	•	支持JSON序列化和类型安全
	•	与领域实体完全解耦

30. 插件系统架构
	•	提供可扩展的第三方服务集成框架
	•	核心接口：
		- Plugin：插件基础接口
		- PluginManager：插件生命周期管理
	•	插件类型：
		- PaymentPlugin：支付插件（支付宝、微信支付等）
		- StoragePlugin：存储插件（OSS、本地存储等）
		- SharePlugin：分享插件（微信、系统分享等）
	•	插件注册和配置机制
	•	插件失败回退和错误处理

31. 生命周期钩子系统
	•	提供应用级别的生命周期事件钩子
	•	钩子类型：
		- beforeUserLogin/afterUserLogin：用户登录钩子
		- beforeUserLogout/afterUserLogout：用户登出钩子
		- beforeDataCreate/afterDataCreate：数据创建钩子
		- beforeDataUpdate/afterDataUpdate：数据更新钩子
		- beforeDataDelete/afterDataDelete：数据删除钩子
		- beforeApiCall/afterApiCall：API调用钩子
		- onNetworkStatusChange：网络状态变化钩子
		- onAppLifecycleChange：应用生命周期变化钩子
	•	支持异步钩子处理
	•	钩子执行顺序管理
	•	错误隔离机制

变更记录:
- v1.9.0 (2025-05-29): 架构完善和优化
  * ✅ 实现值对象系统 - PhoneNumber、Email等值对象
  * ✅ 创建DTO层架构 - 标准化API数据传输
  * ✅ 实现插件系统 - 可扩展的第三方服务集成
  * ✅ 创建生命周期钩子系统 - 应用级别事件钩子
  * ✅ 完成前后端架构对齐 - DDD模式完全实现
- v1.8.0 (2025-05-27): 基础设施完成阶段
  * ✅ 完成Flutter Flavors多环境配置 - 支持dev/staging/prod环境
  * ✅ 集成Fastlane自动化打包 - Android/iOS双平台自动化构建
  * ✅ 实现性能监控系统 - Performance Monitor + Analytics Mixins
  * ✅ 创建用户行为分析系统 - 全面的用户行为追踪和事件上报
  * ✅ 配置Golden测试框架 - UI视觉回归测试支持
  * ✅ 集成Widgetbook 3.x - 组件预览和文档系统
  * ✅ 升级NDK到27.0.12077973 - 解决rive/tflite兼容性问题
  * ✅ 修复登录响应解析问题 - UserModel字段映射和默认值处理
  * ✅ 创建统一构建脚本 - 简化多环境构建流程
  * ✅ 实现测试覆盖率脚本 - 自动生成覆盖率报告
- v1.7.0 (2025-01-24): 基础架构完善阶段
  * ✅ 实现auto_route路由系统 - 支持声明式路由、路由守卫和错误页面
  * ✅ 完善全局错误处理机制 - 统一异常类型、错误边界和错误展示
  * ✅ 添加网络连接监测 - 实时网络状态监控、连接类型检测和网络可达性测试
  * ✅ 实现离线模式支持 - 离线操作队列、数据缓存和自动同步机制
  * ✅ 集成错误边界组件 - 全局错误捕获、错误展示和错误恢复
  * ✅ 创建网络状态指示器 - 网络状态横幅、同步状态显示和连接类型指示
- v1.6.0 (2025-01-24): 重大架构升级
  * 集成OpenAPI Generator实现API模型自动化
  * 引入模块Facade架构模式
  * 添加Riverpod状态管理支持
  * 实现领域事件总线系统
  * 创建统一数据可视化组件
  * 增强测试架构和自动化
- v1.5.0 (2025-06-10): 增加组件预览系统(Widgetbook)和架构模板系统(Mason)章节
- v1.4.0 (2025-06-15): 增加性能优化策略、安全实践、多平台适配和数据库模型映射
- v1.3.0 (2025-06-01): 添加插件系统架构规范，完善第三方服务集成
- v1.2.1 (2025-05-25): 更新依赖注入规范，添加Provider和仓库接口使用指南
- v1.1.0 (2025-05-20): 初始架构冻结版本