# Flutter前端与后端API集成指南

## 概述

本文档说明了Flutter前端如何与后端API进行联调。前端已经实现了完整的API服务架构，包括认证、请求拦截、错误处理等功能。

## 项目结构

```
lib/
├── services/           # API服务层
│   ├── api/           # API客户端
│   │   └── api_client.dart
│   ├── auth/          # 认证服务
│   │   └── auth_service.dart
│   ├── nutrition/     # 营养服务
│   │   └── nutrition_service.dart
│   ├── merchant/      # 商家服务
│   │   └── merchant_service.dart
│   └── order/         # 订单服务
│       └── order_service.dart
├── models/            # 数据模型
│   ├── user.dart
│   ├── nutrition_profile.dart
│   ├── merchant.dart
│   ├── dish.dart
│   └── order.dart
├── modules/           # 功能模块
│   ├── user/          # 用户模块
│   │   └── providers/auth_provider.dart
│   ├── nutrition/     # 营养模块
│   │   └── providers/nutrition_provider.dart
│   ├── merchant/      # 商家模块
│   │   └── providers/merchant_provider.dart
│   └── order/         # 订单模块
│       └── providers/order_provider.dart
└── config/            # 配置文件
    └── env_config.dart # 环境配置
```

## 配置说明

### 1. 环境配置

在 `lib/config/env_config.dart` 中配置API地址：

```dart
// 开发环境
static String get apiBaseUrl {
  if (kIsWeb) {
    return 'http://localhost:3000/api';
  } else {
    // 真机测试时，需要使用电脑的IP地址
    return 'http://192.168.1.100:3000/api'; // 替换为你的电脑IP
  }
}
```

### 2. 启动后端服务

```bash
cd backend
npm install
npm run dev
```

后端默认运行在 http://localhost:3000

### 3. 运行Flutter应用

```bash
cd frontend/flutter
flutter pub get
flutter run
```

## API使用示例

### 1. 用户认证

```dart
// 在Widget中使用
import 'package:provider/provider.dart';

// 登录
final authProvider = context.read<AuthProvider>();
final success = await authProvider.login(
  username: 'testuser',
  password: 'password123',
);

// 获取当前用户
final user = authProvider.currentUser;

// 监听认证状态
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.isAuthenticated) {
      return Text('Welcome ${authProvider.currentUser?.displayName}');
    }
    return Text('Please login');
  },
)
```

### 2. 营养档案管理

```dart
// 加载营养档案
final nutritionProvider = context.read<NutritionProvider>();
await nutritionProvider.loadProfile();

// 获取AI推荐
await nutritionProvider.getAIRecommendation(
  mealType: 'lunch',
  preferences: {
    'maxCalories': 600,
    'dietType': 'low-carb',
  },
);

// 使用推荐数据
if (nutritionProvider.currentRecommendation != null) {
  // 显示推荐的菜品
  final dishes = nutritionProvider.currentRecommendation!.dishes;
}
```

### 3. 商家和菜品

```dart
// 加载商家列表
final merchantProvider = context.read<MerchantProvider>();
await merchantProvider.loadMerchants(
  merchantType: 'restaurant',
  latitude: 31.2304,
  longitude: 121.4737,
);

// 搜索菜品
await merchantProvider.searchDishes(
  keyword: '沙拉',
  minCalories: 200,
  maxCalories: 500,
);

// 获取菜品详情
await merchantProvider.loadDishDetail('dish_id_123');
```

### 4. 订单管理

```dart
// 添加到购物车
final orderProvider = context.read<OrderProvider>();
orderProvider.addToCart(dish, quantity: 2);

// 创建订单
final success = await orderProvider.createOrder(
  deliveryAddress: '上海市浦东新区...',
  contactName: '张三',
  contactPhone: '13800138000',
  note: '少放辣',
);

// 支付订单
final paymentResult = await orderProvider.payOrder(
  orderId: order.id,
  paymentMethod: 'alipay',
);
```

## 错误处理

所有API错误都会被自动捕获并显示给用户：

```dart
// Provider中的错误处理
if (authProvider.error != null) {
  // 显示错误信息
  Text(authProvider.error!)
}

// Toast提示
ToastUtils.showError('操作失败');
ToastUtils.showSuccess('操作成功');
```

## 测试API连接

运行测试脚本验证API连接：

```bash
flutter test test/api_test.dart
```

## 注意事项

1. **真机调试**：需要将 `localhost` 替换为电脑的实际IP地址
2. **跨域问题**：Web端可能需要配置CORS
3. **认证Token**：所有需要认证的API会自动带上JWT token
4. **错误重试**：网络错误会自动重试（最多3次）
5. **缓存策略**：部分数据会缓存到本地以提升性能

## 常见问题

### Q: 连接不上后端？
A: 检查：
- 后端是否已启动
- IP地址是否正确（真机测试）
- 防火墙是否阻止了端口

### Q: 登录后token失效？
A: Token会自动刷新，如果失效会跳转到登录页

### Q: 如何调试API请求？
A: 在debug模式下，所有请求和响应都会打印到控制台

## 后续开发

1. 实现剩余的业务页面UI
2. 添加离线缓存功能
3. 实现推送通知
4. 添加单元测试和集成测试
5. 优化性能和用户体验