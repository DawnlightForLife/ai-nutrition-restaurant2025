# AI智能营养餐厅系统 - 项目文件结构设计

## 📋 概述

基于现有的技术文档和版本配置，本文档定义了前后端项目的完整文件结构，遵循Clean Architecture和模块化设计原则。

**版本**: v3.0.0  
**最后更新**: 2025-07-23  
**基于文档**: 
- TECHNICAL_STACK_UNIFIED.md v3.0.0
- VERSIONS_CONFIG.yaml v3.0.0
- FRONTEND_ARCHITECTURE.md v3.0
- AI_SERVICE_ABSTRACTION_LAYER.md v2.0

**技术栈**:
- 前端: Flutter 3.24.3 + Riverpod 3.0.9 + Freezed 2.5.2
- 后端: Node.js 20.18.0 + NestJS 10.4.4 + TypeORM 0.3.17
- 数据库: PostgreSQL 15.4 + pgvector 0.5.0 + Redis 7.0.12

---

## 🗂️ 项目根目录结构

```
ai-nutrition-restaurant-v3/
├── README.md                           # 项目说明
├── CHANGELOG.md                        # 变更日志
├── docker-compose.yml                  # Docker编排
├── .env.example                        # 环境变量示例
├── .gitignore                          # Git忽略规则
├── 
├── docs/                               # 文档目录
│   └── ai-coding-docs/                # 现有技术文档
│
├── scripts/                           # 脚本目录
│   ├── setup.sh                      # 环境设置脚本
│   ├── build.sh                      # 构建脚本
│   ├── deploy.sh                     # 部署脚本
│   └── db-migrate.sh                 # 数据库迁移脚本
│
├── frontend/                          # Web前端 (Flutter Web)
├── mobile/                           # 移动端 (Flutter)
├── backend/                          # 后端服务
├── database/                         # 数据库脚本
├── shared/                           # 共享代码和工具
└── tests/                           # 端到端测试
```

---

## 📱 移动端项目结构 (mobile/)

基于Flutter 3.19.0 + Riverpod 3.0.0设计：

```
mobile/
├── pubspec.yaml                       # 依赖配置
├── analysis_options.yaml             # 代码分析配置
├── android/                          # Android平台配置
├── ios/                              # iOS平台配置
├── web/                              # Web平台配置
├── 
├── lib/
│   ├── main.dart                     # 应用入口
│   ├── app.dart                      # 应用配置
│   │
│   ├── core/                         # 核心模块
│   │   ├── constants/
│   │   │   ├── app_constants.dart    # 应用常量
│   │   │   ├── api_constants.dart    # API常量
│   │   │   └── storage_keys.dart     # 存储键常量
│   │   │
│   │   ├── config/
│   │   │   ├── app_config.dart       # 应用配置
│   │   │   ├── env_config.dart       # 环境配置
│   │   │   └── flavor_config.dart    # 构建变体配置
│   │   │
│   │   ├── exceptions/
│   │   │   ├── app_exceptions.dart   # 自定义异常
│   │   │   └── error_handler.dart    # 错误处理器
│   │   │
│   │   ├── network/
│   │   │   ├── dio_client.dart       # HTTP客户端
│   │   │   ├── api_client.dart       # API客户端封装
│   │   │   ├── interceptors/         # 请求拦截器
│   │   │   │   ├── auth_interceptor.dart
│   │   │   │   ├── retry_interceptor.dart
│   │   │   │   └── logging_interceptor.dart
│   │   │   └── network_info.dart     # 网络状态检查
│   │   │
│   │   ├── storage/
│   │   │   ├── hive_storage.dart     # Hive本地存储
│   │   │   ├── secure_storage.dart   # 安全存储
│   │   │   └── cache_manager.dart    # 缓存管理
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart        # 应用主题
│   │   │   ├── color_scheme.dart     # 颜色方案
│   │   │   ├── text_theme.dart       # 文字主题
│   │   │   └── theme_provider.dart   # 主题状态管理
│   │   │
│   │   ├── utils/
│   │   │   ├── logger.dart           # 日志工具
│   │   │   ├── validators.dart       # 验证工具
│   │   │   ├── formatters.dart       # 格式化工具
│   │   │   ├── date_utils.dart       # 日期工具
│   │   │   └── encryption_utils.dart # 加密工具
│   │   │
│   │   └── widgets/
│   │       ├── custom_app_bar.dart   # 自定义AppBar
│   │       ├── loading_widget.dart   # 加载组件
│   │       ├── error_widget.dart     # 错误组件
│   │       ├── empty_state_widget.dart # 空状态组件
│   │       └── custom_bottom_sheet.dart # 自定义底部表单
│   │
│   ├── features/                     # 功能模块
│   │   ├── auth/                     # 认证模块
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_local_datasource.dart
│   │   │   │   │   └── auth_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_model.dart
│   │   │   │   │   ├── token_model.dart
│   │   │   │   │   └── login_request_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       └── auth_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_entity.dart
│   │   │   │   │   └── token_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── login_usecase.dart
│   │   │   │   │   ├── logout_usecase.dart
│   │   │   │   │   ├── register_usecase.dart
│   │   │   │   │   └── refresh_token_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── auth_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── login_page.dart
│   │   │       │   ├── register_page.dart
│   │   │       │   ├── forgot_password_page.dart
│   │   │       │   └── profile_setup_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── login_form.dart
│   │   │       │   ├── register_form.dart
│   │   │       │   └── social_login_buttons.dart
│   │   │       ├── providers/
│   │   │       │   ├── auth_provider.dart
│   │   │       │   ├── login_provider.dart
│   │   │       │   └── register_provider.dart
│   │   │       └── dialogs/
│   │   │           └── logout_confirmation_dialog.dart
│   │   │
│   │   ├── nutrition/                # 营养管理模块
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── nutrition_local_datasource.dart
│   │   │   │   │   └── nutrition_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── nutrition_profile_model.dart
│   │   │   │   │   ├── nutrition_analysis_model.dart
│   │   │   │   │   ├── food_item_model.dart
│   │   │   │   │   └── dietary_recommendation_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── nutrition_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       ├── nutrition_ai_service.dart
│   │   │   │       └── nutrition_cache_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── nutrition_profile_entity.dart
│   │   │   │   │   ├── nutrition_analysis_entity.dart
│   │   │   │   │   ├── food_item_entity.dart
│   │   │   │   │   └── dietary_recommendation_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── nutrition_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── create_nutrition_profile_usecase.dart
│   │   │   │   │   ├── analyze_nutrition_usecase.dart
│   │   │   │   │   ├── get_recommendations_usecase.dart
│   │   │   │   │   └── track_food_intake_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── nutrition_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── nutrition_dashboard_page.dart
│   │   │       │   ├── nutrition_profile_page.dart
│   │   │       │   ├── food_analysis_page.dart
│   │   │       │   ├── recommendations_page.dart
│   │   │       │   └── nutrition_history_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── nutrition_profile_form.dart
│   │   │       │   ├── nutrition_chart.dart
│   │   │       │   ├── food_input_widget.dart
│   │   │       │   ├── recommendation_card.dart
│   │   │       │   └── nutrition_progress_indicator.dart
│   │   │       ├── providers/
│   │   │       │   ├── nutrition_profile_provider.dart
│   │   │       │   ├── nutrition_analysis_provider.dart
│   │   │       │   ├── recommendations_provider.dart
│   │   │       │   └── food_tracking_provider.dart
│   │   │       └── dialogs/
│   │   │           ├── add_food_dialog.dart
│   │   │           └── nutrition_goal_dialog.dart
│   │   │
│   │   ├── restaurant/               # 餐厅模块
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── restaurant_local_datasource.dart
│   │   │   │   │   └── restaurant_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── restaurant_model.dart
│   │   │   │   │   ├── menu_item_model.dart
│   │   │   │   │   ├── dish_nutrition_model.dart
│   │   │   │   │   └── restaurant_review_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── restaurant_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       └── restaurant_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── restaurant_entity.dart
│   │   │   │   │   ├── menu_item_entity.dart
│   │   │   │   │   ├── dish_nutrition_entity.dart
│   │   │   │   │   └── restaurant_review_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── restaurant_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── search_restaurants_usecase.dart
│   │   │   │   │   ├── get_menu_usecase.dart
│   │   │   │   │   ├── filter_dishes_by_nutrition_usecase.dart
│   │   │   │   │   └── get_restaurant_reviews_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── restaurant_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── restaurant_list_page.dart
│   │   │       │   ├── restaurant_detail_page.dart
│   │   │       │   ├── menu_page.dart
│   │   │       │   └── dish_detail_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── restaurant_card.dart
│   │   │       │   ├── menu_item_card.dart
│   │   │       │   ├── nutrition_info_widget.dart
│   │   │       │   ├── restaurant_filter.dart
│   │   │       │   └── review_widget.dart
│   │   │       ├── providers/
│   │   │       │   ├── restaurant_list_provider.dart
│   │   │       │   ├── restaurant_detail_provider.dart
│   │   │       │   ├── menu_provider.dart
│   │   │       │   └── restaurant_filter_provider.dart
│   │   │       └── dialogs/
│   │   │           └── restaurant_filter_dialog.dart
│   │   │
│   │   ├── order/                    # 订单模块
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── order_local_datasource.dart
│   │   │   │   │   └── order_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── order_model.dart
│   │   │   │   │   ├── order_item_model.dart
│   │   │   │   │   ├── payment_model.dart
│   │   │   │   │   └── delivery_info_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── order_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       ├── order_service.dart
│   │   │   │       └── payment_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── order_entity.dart
│   │   │   │   │   ├── order_item_entity.dart
│   │   │   │   │   ├── payment_entity.dart
│   │   │   │   │   └── delivery_info_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── order_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── create_order_usecase.dart
│   │   │   │   │   ├── update_order_usecase.dart
│   │   │   │   │   ├── cancel_order_usecase.dart
│   │   │   │   │   ├── track_order_usecase.dart
│   │   │   │   │   └── process_payment_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── order_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── cart_page.dart
│   │   │       │   ├── checkout_page.dart
│   │   │       │   ├── order_confirmation_page.dart
│   │   │       │   ├── order_tracking_page.dart
│   │   │       │   └── order_history_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── cart_item_widget.dart
│   │   │       │   ├── checkout_form.dart
│   │   │       │   ├── payment_method_selector.dart
│   │   │       │   ├── order_summary_widget.dart
│   │   │       │   └── order_status_tracker.dart
│   │   │       ├── providers/
│   │   │       │   ├── cart_provider.dart
│   │   │       │   ├── checkout_provider.dart
│   │   │       │   ├── order_tracking_provider.dart
│   │   │       │   └── order_history_provider.dart
│   │   │       └── dialogs/
│   │   │           ├── payment_confirmation_dialog.dart
│   │   │           └── order_cancellation_dialog.dart
│   │   │
│   │   ├── consultation/             # AI营养咨询模块
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── consultation_local_datasource.dart
│   │   │   │   │   └── consultation_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── consultation_session_model.dart
│   │   │   │   │   ├── chat_message_model.dart
│   │   │   │   │   └── ai_recommendation_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── consultation_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       ├── ai_chat_service.dart
│   │   │   │       └── consultation_history_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── consultation_session_entity.dart
│   │   │   │   │   ├── chat_message_entity.dart
│   │   │   │   │   └── ai_recommendation_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── consultation_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── start_consultation_usecase.dart
│   │   │   │   │   ├── send_message_usecase.dart
│   │   │   │   │   ├── get_ai_recommendation_usecase.dart
│   │   │   │   │   └── save_consultation_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── consultation_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── consultation_page.dart
│   │   │       │   ├── chat_page.dart
│   │   │       │   └── consultation_history_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── chat_message_widget.dart
│   │   │       │   ├── chat_input_widget.dart
│   │   │       │   ├── ai_recommendation_card.dart
│   │   │       │   └── consultation_summary_widget.dart
│   │   │       ├── providers/
│   │   │       │   ├── consultation_provider.dart
│   │   │       │   ├── chat_provider.dart
│   │   │       │   └── consultation_history_provider.dart
│   │   │       └── dialogs/
│   │   │           └── consultation_rating_dialog.dart
│   │   │
│   │   ├── profile/                  # 个人中心
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── profile_local_datasource.dart
│   │   │   │   │   └── profile_remote_datasource.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── user_profile_model.dart
│   │   │   │   │   ├── privacy_settings_model.dart
│   │   │   │   │   └── notification_settings_model.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── profile_repository_impl.dart
│   │   │   │   └── services/
│   │   │   │       └── profile_service.dart
│   │   │   │
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── user_profile_entity.dart
│   │   │   │   │   ├── privacy_settings_entity.dart
│   │   │   │   │   └── notification_settings_entity.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── profile_repository.dart
│   │   │   │   ├── usecases/
│   │   │   │   │   ├── update_profile_usecase.dart
│   │   │   │   │   ├── update_privacy_settings_usecase.dart
│   │   │   │   │   ├── export_user_data_usecase.dart
│   │   │   │   │   └── delete_account_usecase.dart
│   │   │   │   └── validators/
│   │   │   │       └── profile_validators.dart
│   │   │   │
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── profile_page.dart
│   │   │       │   ├── edit_profile_page.dart
│   │   │       │   ├── privacy_settings_page.dart
│   │   │       │   ├── notification_settings_page.dart
│   │   │       │   └── account_management_page.dart
│   │   │       ├── widgets/
│   │   │       │   ├── profile_header.dart
│   │   │       │   ├── profile_menu_item.dart
│   │   │       │   ├── privacy_toggle.dart
│   │   │       │   └── profile_statistics.dart
│   │   │       ├── providers/
│   │   │       │   ├── profile_provider.dart
│   │   │       │   ├── privacy_settings_provider.dart
│   │   │       │   └── notification_settings_provider.dart
│   │   │       └── dialogs/
│   │   │           ├── delete_account_dialog.dart
│   │   │           └── data_export_dialog.dart
│   │   │
│   │   └── main/                     # 主页模块
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── home_remote_datasource.dart
│   │       │   ├── models/
│   │       │   │   ├── dashboard_data_model.dart
│   │       │   │   └── featured_content_model.dart
│   │       │   ├── repositories/
│   │       │   │   └── home_repository_impl.dart
│   │       │   └── services/
│   │       │       └── home_service.dart
│   │       │
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── dashboard_data_entity.dart
│   │       │   │   └── featured_content_entity.dart
│   │       │   ├── repositories/
│   │       │   │   └── home_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_dashboard_data_usecase.dart
│   │       │       └── get_featured_content_usecase.dart
│   │       │
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── home_page.dart
│   │           │   ├── dashboard_page.dart
│   │           │   └── main_navigation_page.dart
│   │           ├── widgets/
│   │           │   ├── dashboard_summary.dart
│   │           │   ├── quick_actions.dart
│   │           │   ├── featured_restaurants.dart
│   │           │   └── nutrition_overview.dart
│   │           └── providers/
│   │               ├── home_provider.dart
│   │               ├── dashboard_provider.dart
│   │               └── navigation_provider.dart
│   │
│   ├── shared/                       # 共享模块
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── api_response_model.dart
│   │   │   │   ├── pagination_model.dart
│   │   │   │   └── error_response_model.dart
│   │   │   └── services/
│   │   │       ├── location_service.dart
│   │   │       ├── notification_service.dart
│   │   │       └── analytics_service.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── api_response_entity.dart
│   │   │   │   ├── pagination_entity.dart
│   │   │   │   └── location_entity.dart
│   │   │   └── usecases/
│   │   │       ├── get_current_location_usecase.dart
│   │   │       └── send_notification_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── widgets/
│   │       │   ├── custom_button.dart
│   │       │   ├── custom_text_field.dart
│   │       │   ├── custom_dropdown.dart
│   │       │   ├── custom_card.dart
│   │       │   ├── pagination_widget.dart
│   │       │   ├── search_bar_widget.dart
│   │       │   └── rating_widget.dart
│   │       └── providers/
│   │           ├── location_provider.dart
│   │           ├── notification_provider.dart
│   │           └── connectivity_provider.dart
│   │
│   ├── routes/                       # 路由配置
│   │   ├── app_router.dart          # 路由定义
│   │   ├── route_guards.dart        # 路由守卫
│   │   ├── route_names.dart         # 路由常量
│   │   └── route_transitions.dart   # 路由转场动画
│   │
│   └── l10n/                        # 国际化
│       ├── app_en.arb              # 英语文本
│       ├── app_zh.arb              # 中文文本
│       ├── l10n.dart               # 国际化配置
│       └── generated/              # 自动生成的国际化文件
│
├── test/                           # 测试目录
│   ├── unit/                      # 单元测试
│   ├── widget/                    # 组件测试
│   ├── integration/               # 集成测试
│   ├── mocks/                     # Mock数据
│   └── fixtures/                  # 测试fixture
│
└── assets/                        # 资源文件
    ├── images/                    # 图片资源
    ├── icons/                     # 图标资源
    ├── fonts/                     # 字体文件
    └── data/                      # 静态数据文件
```

---

## 🖥️ Web前端项目结构 (frontend/)

基于Flutter Web构建，复用移动端代码结构：

```
frontend/
├── pubspec.yaml                    # Web特定依赖配置
├── web/
│   ├── index.html                 # Web入口页面
│   ├── manifest.json              # Web应用清单
│   ├── favicon.ico                # 网站图标
│   └── icons/                     # PWA图标
│
├── lib/
│   ├── main.dart                  # Web应用入口
│   ├── web_app.dart              # Web应用配置
│   │
│   ├── web/                      # Web特定代码
│   │   ├── responsive/           # 响应式布局
│   │   │   ├── responsive_layout.dart
│   │   │   ├── desktop_layout.dart
│   │   │   ├── tablet_layout.dart
│   │   │   └── mobile_layout.dart
│   │   │
│   │   ├── widgets/              # Web特定组件
│   │   │   ├── web_navigation.dart
│   │   │   ├── breadcrumb.dart
│   │   │   ├── sidebar_menu.dart
│   │   │   └── desktop_header.dart
│   │   │
│   │   └── pages/                # Web特定页面
│   │       ├── desktop_home_page.dart
│   │       └── web_admin_panel.dart
│   │
│   └── [复用mobile的lib结构]     # 复用移动端代码
│
└── build/                        # Web构建输出
    └── web/
```

---

## 🔧 后端项目结构 (backend/)

基于NestJS 10.0.0 + TypeORM 0.3.17设计：

```
backend/
├── package.json                   # 依赖配置
├── tsconfig.json                  # TypeScript配置
├── nest-cli.json                  # NestJS CLI配置
├── .env.example                   # 环境变量示例
├── docker-compose.yml             # 本地开发环境
├── Dockerfile                     # Docker镜像配置
├── 
├── src/
│   ├── main.ts                   # 应用入口
│   ├── app.module.ts             # 根模块
│   │
│   ├── config/                   # 配置模块
│   │   ├── database.config.ts    # 数据库配置
│   │   ├── redis.config.ts       # Redis配置
│   │   ├── ai.config.ts          # AI服务配置
│   │   ├── app.config.ts         # 应用配置
│   │   └── validation.config.ts  # 验证配置
│   │
│   ├── common/                   # 公共模块
│   │   ├── decorators/           # 装饰器
│   │   │   ├── auth.decorator.ts
│   │   │   ├── roles.decorator.ts
│   │   │   ├── api-response.decorator.ts
│   │   │   └── rate-limit.decorator.ts
│   │   │
│   │   ├── guards/               # 守卫
│   │   │   ├── auth.guard.ts
│   │   │   ├── roles.guard.ts
│   │   │   ├── rate-limit.guard.ts
│   │   │   └── data-access.guard.ts
│   │   │
│   │   ├── interceptors/         # 拦截器
│   │   │   ├── logging.interceptor.ts
│   │   │   ├── timeout.interceptor.ts
│   │   │   ├── transform.interceptor.ts
│   │   │   └── cache.interceptor.ts
│   │   │
│   │   ├── filters/              # 异常过滤器
│   │   │   ├── http-exception.filter.ts
│   │   │   ├── validation-exception.filter.ts
│   │   │   └── all-exceptions.filter.ts
│   │   │
│   │   ├── pipes/                # 管道
│   │   │   ├── validation.pipe.ts
│   │   │   ├── parse-id.pipe.ts
│   │   │   └── sanitize.pipe.ts
│   │   │
│   │   ├── middleware/           # 中间件
│   │   │   ├── logger.middleware.ts
│   │   │   ├── cors.middleware.ts
│   │   │   └── security.middleware.ts
│   │   │
│   │   ├── constants/            # 常量
│   │   │   ├── app.constants.ts
│   │   │   ├── api.constants.ts
│   │   │   ├── error.constants.ts
│   │   │   └── roles.constants.ts
│   │   │
│   │   ├── enums/                # 枚举
│   │   │   ├── user-role.enum.ts
│   │   │   ├── order-status.enum.ts
│   │   │   ├── privacy-level.enum.ts
│   │   │   └── ai-service-type.enum.ts
│   │   │
│   │   ├── interfaces/           # 接口
│   │   │   ├── api-response.interface.ts
│   │   │   ├── pagination.interface.ts
│   │   │   ├── jwt-payload.interface.ts
│   │   │   └── ai-service.interface.ts
│   │   │
│   │   ├── dto/                  # 数据传输对象基类
│   │   │   ├── base.dto.ts
│   │   │   ├── pagination.dto.ts
│   │   │   └── api-response.dto.ts
│   │   │
│   │   └── utils/                # 工具类
│   │       ├── encryption.util.ts
│   │       ├── validation.util.ts
│   │       ├── date.util.ts
│   │       ├── hash.util.ts
│   │       └── string.util.ts
│   │
│   ├── database/                 # 数据库模块
│   │   ├── database.module.ts    # 数据库模块
│   │   ├── entities/             # 实体定义
│   │   │   ├── base.entity.ts    # 基础实体
│   │   │   ├── user.entity.ts    # 用户实体
│   │   │   ├── nutrition-profile.entity.ts # 营养档案
│   │   │   ├── restaurant.entity.ts # 餐厅实体
│   │   │   ├── menu-item.entity.ts # 菜单项
│   │   │   ├── order.entity.ts   # 订单实体
│   │   │   ├── order-item.entity.ts # 订单项
│   │   │   ├── consultation.entity.ts # 咨询记录
│   │   │   ├── data-access-log.entity.ts # 数据访问日志
│   │   │   └── user-consent.entity.ts # 用户同意记录
│   │   │
│   │   ├── migrations/           # 数据库迁移
│   │   │   ├── 001-initial-schema.ts
│   │   │   ├── 002-add-privacy-fields.ts
│   │   │   ├── 003-add-ai-service-tables.ts
│   │   │   └── 004-add-consultation-tables.ts
│   │   │
│   │   ├── seeders/              # 数据种子
│   │   │   ├── user.seeder.ts
│   │   │   ├── restaurant.seeder.ts
│   │   │   └── menu-item.seeder.ts
│   │   │
│   │   └── repositories/         # 自定义仓储
│   │       ├── user.repository.ts
│   │       ├── nutrition-profile.repository.ts
│   │       └── order.repository.ts
│   │
│   ├── modules/                  # 业务模块
│   │   ├── auth/                 # 认证模块
│   │   │   ├── auth.module.ts
│   │   │   ├── auth.controller.ts
│   │   │   ├── auth.service.ts
│   │   │   ├── jwt.strategy.ts
│   │   │   ├── local.strategy.ts
│   │   │   ├── dto/
│   │   │   │   ├── login.dto.ts
│   │   │   │   ├── register.dto.ts
│   │   │   │   ├── refresh-token.dto.ts
│   │   │   │   └── change-password.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── jwt-payload.interface.ts
│   │   │       └── auth-response.interface.ts
│   │   │
│   │   ├── users/                # 用户模块
│   │   │   ├── users.module.ts
│   │   │   ├── users.controller.ts
│   │   │   ├── users.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── create-user.dto.ts
│   │   │   │   ├── update-user.dto.ts
│   │   │   │   ├── user-profile.dto.ts
│   │   │   │   └── privacy-settings.dto.ts
│   │   │   └── interfaces/
│   │   │       └── user-response.interface.ts
│   │   │
│   │   ├── nutrition/            # 营养模块
│   │   │   ├── nutrition.module.ts
│   │   │   ├── nutrition.controller.ts
│   │   │   ├── nutrition.service.ts
│   │   │   ├── nutrition-ai.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── create-nutrition-profile.dto.ts
│   │   │   │   ├── update-nutrition-profile.dto.ts
│   │   │   │   ├── nutrition-analysis-request.dto.ts
│   │   │   │   ├── nutrition-analysis-response.dto.ts
│   │   │   │   └── dietary-recommendation.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── nutrition-profile.interface.ts
│   │   │       └── nutrition-analysis.interface.ts
│   │   │
│   │   ├── restaurants/          # 餐厅模块
│   │   │   ├── restaurants.module.ts
│   │   │   ├── restaurants.controller.ts
│   │   │   ├── restaurants.service.ts
│   │   │   ├── menu-items.controller.ts
│   │   │   ├── menu-items.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── create-restaurant.dto.ts
│   │   │   │   ├── update-restaurant.dto.ts
│   │   │   │   ├── create-menu-item.dto.ts
│   │   │   │   ├── update-menu-item.dto.ts
│   │   │   │   ├── restaurant-filter.dto.ts
│   │   │   │   └── menu-filter.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── restaurant.interface.ts
│   │   │       └── menu-item.interface.ts
│   │   │
│   │   ├── orders/               # 订单模块
│   │   │   ├── orders.module.ts
│   │   │   ├── orders.controller.ts
│   │   │   ├── orders.service.ts
│   │   │   ├── payment.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── create-order.dto.ts
│   │   │   │   ├── update-order.dto.ts
│   │   │   │   ├── add-order-item.dto.ts
│   │   │   │   ├── payment-request.dto.ts
│   │   │   │   └── order-filter.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── order.interface.ts
│   │   │       ├── order-item.interface.ts
│   │   │       └── payment.interface.ts
│   │   │
│   │   ├── consultation/         # AI咨询模块
│   │   │   ├── consultation.module.ts
│   │   │   ├── consultation.controller.ts
│   │   │   ├── consultation.service.ts
│   │   │   ├── ai-chat.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── start-consultation.dto.ts
│   │   │   │   ├── send-message.dto.ts
│   │   │   │   ├── consultation-response.dto.ts
│   │   │   │   └── ai-recommendation.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── consultation.interface.ts
│   │   │       ├── chat-message.interface.ts
│   │   │       └── ai-response.interface.ts
│   │   │
│   │   ├── privacy/              # 隐私合规模块
│   │   │   ├── privacy.module.ts
│   │   │   ├── privacy.controller.ts
│   │   │   ├── privacy.service.ts
│   │   │   ├── data-audit.service.ts
│   │   │   ├── data-encryption.service.ts
│   │   │   ├── dto/
│   │   │   │   ├── consent-request.dto.ts
│   │   │   │   ├── data-export-request.dto.ts
│   │   │   │   ├── data-deletion-request.dto.ts
│   │   │   │   └── privacy-settings.dto.ts
│   │   │   └── interfaces/
│   │   │       ├── consent.interface.ts
│   │   │       ├── data-audit.interface.ts
│   │   │       └── encryption.interface.ts
│   │   │
│   │   └── ai-services/          # AI服务模块
│   │       ├── ai-services.module.ts
│   │       ├── ai-service-manager.service.ts
│   │       ├── deepseek.service.ts
│   │       ├── openai.service.ts
│   │       ├── fallback.service.ts
│   │       ├── cache.service.ts
│   │       ├── dto/
│   │       │   ├── ai-request.dto.ts
│   │       │   ├── ai-response.dto.ts
│   │       │   ├── service-config.dto.ts
│   │       │   └── fallback-config.dto.ts
│   │       └── interfaces/
│   │           ├── ai-service.interface.ts
│   │           ├── service-health.interface.ts
│   │           └── fallback-strategy.interface.ts
│   │
│   ├── cache/                    # 缓存模块
│   │   ├── cache.module.ts
│   │   ├── redis.service.ts
│   │   ├── cache.service.ts
│   │   └── interfaces/
│   │       └── cache.interface.ts
│   │
│   ├── monitoring/               # 监控模块
│   │   ├── monitoring.module.ts
│   │   ├── health.controller.ts
│   │   ├── metrics.service.ts
│   │   ├── logging.service.ts
│   │   └── interfaces/
│   │       ├── health-check.interface.ts
│   │       └── metrics.interface.ts
│   │
│   └── scripts/                  # 脚本文件
│       ├── seed-database.ts      # 数据库种子脚本
│       ├── migrate-database.ts   # 数据库迁移脚本
│       └── generate-keys.ts      # 密钥生成脚本
│
├── test/                         # 测试目录
│   ├── unit/                    # 单元测试
│   ├── integration/             # 集成测试
│   ├── e2e/                     # 端到端测试
│   ├── mocks/                   # Mock数据
│   └── fixtures/                # 测试fixture
│
├── docs/                        # 接口文档
│   ├── api/                     # API文档
│   └── swagger/                 # Swagger配置
│
└── dist/                        # 编译输出目录
```

---

## 🗄️ 数据库项目结构 (database/)

```
database/
├── postgresql/                  # PostgreSQL相关
│   ├── schemas/                # 数据库schema
│   │   ├── 001-initial.sql    # 初始化schema
│   │   ├── 002-privacy.sql    # 隐私保护相关表
│   │   ├── 003-ai-services.sql # AI服务相关表
│   │   └── 004-indexes.sql    # 索引优化
│   │
│   ├── migrations/             # 数据迁移脚本
│   │   ├── up/                # 升级脚本
│   │   └── down/              # 回滚脚本
│   │
│   ├── seeds/                 # 种子数据
│   │   ├── users.sql         # 用户测试数据
│   │   ├── restaurants.sql   # 餐厅测试数据
│   │   └── menu_items.sql    # 菜单测试数据
│   │
│   ├── functions/             # 数据库函数
│   │   ├── encryption.sql    # 加密相关函数
│   │   ├── audit.sql         # 审计相关函数
│   │   └── analytics.sql     # 分析相关函数
│   │
│   └── triggers/              # 触发器
│       ├── audit_triggers.sql # 审计触发器
│       └── privacy_triggers.sql # 隐私保护触发器
│
├── redis/                     # Redis相关
│   ├── config/               # Redis配置
│   │   ├── redis.conf        # Redis配置文件
│   │   └── cluster.conf      # 集群配置
│   │
│   └── scripts/              # Redis脚本
│       ├── cache_cleanup.lua # 缓存清理脚本
│       └── session_cleanup.lua # 会话清理脚本
│
└── backups/                  # 备份脚本
    ├── backup.sh            # 备份脚本
    ├── restore.sh           # 恢复脚本
    └── schedule/            # 定时备份配置
```

---

## 🔗 共享代码结构 (shared/)

```
shared/
├── types/                    # TypeScript类型定义
│   ├── api.types.ts         # API相关类型
│   ├── user.types.ts        # 用户相关类型
│   ├── nutrition.types.ts   # 营养相关类型
│   ├── restaurant.types.ts  # 餐厅相关类型
│   ├── order.types.ts       # 订单相关类型
│   └── ai.types.ts          # AI服务相关类型
│
├── constants/               # 共享常量
│   ├── api.constants.ts    # API常量
│   ├── app.constants.ts    # 应用常量
│   ├── error.constants.ts  # 错误常量
│   └── validation.constants.ts # 验证常量
│
├── enums/                   # 共享枚举
│   ├── user-role.enum.ts   # 用户角色
│   ├── order-status.enum.ts # 订单状态
│   ├── privacy-level.enum.ts # 隐私级别
│   └── ai-service-type.enum.ts # AI服务类型
│
├── interfaces/              # 共享接口
│   ├── api-response.interface.ts # API响应接口
│   ├── pagination.interface.ts # 分页接口
│   ├── jwt-payload.interface.ts # JWT载荷接口
│   └── ai-service.interface.ts # AI服务接口
│
├── utils/                   # 共享工具
│   ├── validation.utils.ts  # 验证工具
│   ├── date.utils.ts       # 日期工具
│   ├── string.utils.ts     # 字符串工具
│   ├── encryption.utils.ts # 加密工具
│   └── formatting.utils.ts # 格式化工具
│
├── schemas/                 # 验证schema
│   ├── user.schema.ts      # 用户验证schema
│   ├── nutrition.schema.ts # 营养验证schema
│   ├── restaurant.schema.ts # 餐厅验证schema
│   └── order.schema.ts     # 订单验证schema
│
└── localization/            # 国际化文件
    ├── en/                 # 英语
    │   ├── common.json     # 通用文本
    │   ├── errors.json     # 错误信息
    │   └── validation.json # 验证信息
    └── zh/                 # 中文
        ├── common.json     # 通用文本
        ├── errors.json     # 错误信息
        └── validation.json # 验证信息
```

---

## 🧪 测试项目结构 (tests/)

```
tests/
├── e2e/                     # 端到端测试
│   ├── auth/               # 认证流程测试
│   ├── nutrition/          # 营养功能测试
│   ├── restaurant/         # 餐厅功能测试
│   ├── order/              # 订单流程测试
│   └── consultation/       # 咨询功能测试
│
├── integration/            # 集成测试
│   ├── api/               # API集成测试
│   ├── database/          # 数据库集成测试
│   └── ai-services/       # AI服务集成测试
│
├── performance/           # 性能测试
│   ├── load/             # 负载测试
│   ├── stress/           # 压力测试
│   └── benchmark/        # 基准测试
│
├── security/              # 安全测试
│   ├── auth/             # 认证安全测试
│   ├── privacy/          # 隐私保护测试
│   └── data-access/      # 数据访问安全测试
│
├── fixtures/              # 测试数据
│   ├── users.json        # 用户测试数据
│   ├── restaurants.json  # 餐厅测试数据
│   └── menu_items.json   # 菜单测试数据
│
├── mocks/                 # Mock数据
│   ├── ai-services/      # AI服务Mock
│   ├── payment/          # 支付服务Mock
│   └── external-apis/    # 外部API Mock
│
└── utils/                 # 测试工具
    ├── test-helpers.ts   # 测试帮助工具
    ├── db-setup.ts      # 数据库测试设置
    └── mock-factory.ts  # Mock工厂
```

---

## 📦 关键技术决策说明

### 状态管理选择
- **Riverpod 3.0.0**: 选择最新版本，提供更好的类型安全和性能
- **Provider模式**: 每个功能模块独立的Provider，避免全局状态污染

### 数据架构选择
- **Clean Architecture**: 清晰的分层架构，便于测试和维护
- **Feature-First**: 按功能模块组织代码，提高内聚性
- **Repository Pattern**: 抽象数据访问层，便于替换数据源

### 安全架构选择
- **渐进式加密**: MVP阶段使用基础加密，后续升级为字段级加密
- **权限控制**: 基于装饰器的权限控制，便于维护和扩展
- **审计日志**: 完整的数据访问日志，满足合规要求

### AI服务架构选择
- **服务抽象**: 统一的AI服务接口，便于切换和扩展
- **降级策略**: 多层降级机制，保证服务可用性
- **缓存优先**: Redis缓存作为主要降级策略

---

**文档维护**: 技术团队  
**最后更新**: 2025年1月  
**下次review**: 项目开始实施时