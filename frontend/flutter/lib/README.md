# AI营养餐厅Flutter客户端

## 项目结构

```
lib/
├── main.dart                         // 根入口，负责跳转 splash_screen.dart
├── splash_screen.dart                // 启动页，判断用户/管理员跳转
├── screens/
│   ├── user/
│   │   ├── main_page.dart            // 用户端入口（登录判断切换页面）
│   │   └── home/
│   │       ├── home_page.dart        // 登录后首页
│   │       └── landing_page.dart     // 未登录欢迎页
│   └── admin/
│       ├── admin_entry.dart          // 管理后台入口
│       ├── admin_dashboard_page.dart // 管理员仪表盘页面
│       └── login/
│           └── admin_login_page.dart // 管理员登录页面
├── providers/
│   ├── auth_provider.dart            // 用户登录状态管理
│   └── admin_provider.dart           // 管理员登录状态管理
├── services/
│   └── api_service.dart              // API通用请求服务
└── README.md                         // 项目结构说明
```

## 功能模块说明

### 用户端
- **启动页 (splash_screen.dart)**: 应用启动时的加载页面，决定跳转到用户还是管理员界面
- **主页面 (main_page.dart)**: 用户端主入口，根据登录状态决定显示登录页还是首页
- **欢迎页 (landing_page.dart)**: 未登录用户看到的引导页面
- **首页 (home_page.dart)**: 登录后的主页，包含底部导航和各功能页面

### 管理员端
- **管理入口 (admin_entry.dart)**: 管理后台入口，根据登录状态决定显示登录页还是仪表盘
- **登录页 (admin_login_page.dart)**: 管理员登录界面
- **仪表盘 (admin_dashboard_page.dart)**: 管理员主界面，包含系统管理功能

### 状态管理
- **auth_provider.dart**: 用户身份验证和状态管理
- **admin_provider.dart**: 管理员身份验证和状态管理

### 服务
- **api_service.dart**: 封装API请求，提供统一的网络请求接口

## 开发约定
1. 组件化开发，将UI拆分为可复用的小组件
2. 遵循Material Design设计规范
3. 使用Provider进行状态管理
4. 网络请求统一通过api_service.dart处理
5. 代码注释清晰，命名规范
