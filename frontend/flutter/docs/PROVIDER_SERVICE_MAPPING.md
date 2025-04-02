# Provider-Service-Repository 映射关系

本文档列出智慧AI营养餐厅Flutter项目中各模块的Provider（状态管理）、Service（业务逻辑）和Repository（数据访问）之间的映射关系，便于开发者理解数据流动路径和各层职责。

## 架构层次说明

项目采用分层架构模式，主要包含以下几层：

1. **UI层**：页面和组件
2. **状态管理层**：Provider 负责管理状态和连接UI与业务逻辑
3. **业务逻辑层**：Service 负责处理业务逻辑
4. **数据访问层**：Repository 负责数据获取和持久化

数据流路径：
```
UI <--> Provider <--> Service <--> Repository <--> 外部数据源（API/本地存储）
```

## 核心模块映射

### 用户认证模块

| Provider | Service | Repository |
|----------|---------|------------|
| `AuthProvider` | `AuthService` | `UserRepository` |
| 管理用户认证状态、登录状态、令牌 | 处理登录、注册、令牌更新等业务逻辑 | 与API交互获取用户数据、存储认证信息 |
| 提供的状态: `isLoggedIn`, `currentUser`, `userRole`, `authToken` | 提供的方法: `login()`, `register()`, `logout()`, `verifyToken()` | 提供的方法: `fetchUser()`, `saveToken()`, `saveUser()` |

### 用户模块

| Provider | Service | Repository |
|----------|---------|------------|
| `UserProfileProvider` | `UserProfileService` | `UserRepository` |
| 管理用户信息和配置文件 | 处理用户资料更新、权限校验等 | 获取和保存用户信息 |
| 提供的状态: `userProfile`, `isProfileComplete`, `userPreferences` | 提供的方法: `updateProfile()`, `changePassword()`, `updatePreferences()` | 提供的方法: `fetchUserProfile()`, `updateUserProfile()`, `savePreferences()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `UserAddressProvider` | `UserAddressService` | `UserAddressRepository` |
| 管理用户地址信息 | 处理地址添加、删除、设为默认 | 与地址相关API交互 |
| 提供的状态: `addresses`, `defaultAddress` | 提供的方法: `addAddress()`, `removeAddress()`, `setDefaultAddress()` | 提供的方法: `fetchAddresses()`, `createAddress()`, `deleteAddress()` |

## 营养与健康模块

### 营养档案模块

| Provider | Service | Repository |
|----------|---------|------------|
| `NutritionProfileProvider` | `NutritionProfileService` | `NutritionProfileRepository` |
| 管理用户营养档案 | 处理档案创建、更新、验证 | 获取和保存营养档案数据 |
| 提供的状态: `nutritionProfiles`, `activeProfile`, `profilesLoading` | 提供的方法: `createProfile()`, `updateProfile()`, `setActiveProfile()` | 提供的方法: `fetchProfiles()`, `saveProfile()`, `deleteProfile()` |

### 健康数据模块

| Provider | Service | Repository |
|----------|---------|------------|
| `HealthDataProvider` | `HealthDataService` | `HealthDataRepository` |
| 管理用户健康数据 | 处理健康数据记录、分析 | 获取和同步健康数据 |
| 提供的状态: `healthMetrics`, `healthHistory`, `dataLoading` | 提供的方法: `recordMetric()`, `calculateBMI()`, `analyzeHealthTrend()` | 提供的方法: `fetchHealthData()`, `saveHealthMetric()`, `syncWithHealthKit()` |

### AI推荐模块

| Provider | Service | Repository |
|----------|---------|------------|
| `RecommendationProvider` | `RecommendationService` | `RecommendationRepository` |
| 管理AI推荐结果 | 处理推荐请求、过滤 | 获取推荐数据 |
| 提供的状态: `recommendations`, `recommendationFilters`, `isLoading` | 提供的方法: `getRecommendations()`, `filterRecommendations()`, `savePreference()` | 提供的方法: `fetchRecommendations()`, `saveUserPreference()`, `rateRecommendation()` |

## 商家与菜品模块

### 商家模块

| Provider | Service | Repository |
|----------|---------|------------|
| `MerchantProvider` | `MerchantService` | `MerchantRepository` |
| 管理商家信息与状态 | 处理商家数据逻辑 | 获取商家数据 |
| 提供的状态: `merchants`, `featuredMerchants`, `merchantFilters` | 提供的方法: `fetchMerchants()`, `filterMerchants()`, `getMerchantDetail()` | 提供的方法: `fetchAllMerchants()`, `fetchMerchantById()`, `searchMerchants()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `MerchantDashboardProvider` | `MerchantDashboardService` | `MerchantStatsRepository` |
| 管理商家仪表盘数据 | 处理数据分析和统计 | 获取销售和顾客数据 |
| 提供的状态: `salesStats`, `customerStats`, `businessInsights` | 提供的方法: `analyzeSales()`, `generateReport()`, `getCustomerActivity()` | 提供的方法: `fetchSalesData()`, `fetchCustomerData()`, `fetchBusinessMetrics()` |

### 菜品模块

| Provider | Service | Repository |
|----------|---------|------------|
| `DishProvider` | `DishService` | `DishRepository` |
| 管理菜品信息 | 处理菜品数据逻辑 | 获取菜品数据 |
| 提供的状态: `dishes`, `popularDishes`, `dishFilters` | 提供的方法: `fetchDishes()`, `filterDishes()`, `getDishDetail()` | 提供的方法: `fetchAllDishes()`, `fetchDishById()`, `searchDishes()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `MenuProvider` | `MenuService` | `MenuRepository` |
| 管理商家菜单 | 处理菜单相关业务逻辑 | 获取和更新菜单数据 |
| 提供的状态: `menu`, `menuCategories`, `specialOffers` | 提供的方法: `updateMenu()`, `createMenuItem()`, `setSpecialOffer()` | 提供的方法: `fetchMenu()`, `saveMenuItem()`, `updateMenuStructure()` |

## 订单模块

| Provider | Service | Repository |
|----------|---------|------------|
| `CartProvider` | `CartService` | `CartRepository` |
| 管理购物车 | 处理购物车业务逻辑 | 保存购物车数据 |
| 提供的状态: `cartItems`, `cartTotal`, `cartCount` | 提供的方法: `addToCart()`, `removeFromCart()`, `clearCart()` | 提供的方法: `saveCart()`, `fetchSavedCart()`, `mergeLocalAndRemoteCart()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `OrderProvider` | `OrderService` | `OrderRepository` |
| 管理订单状态 | 处理订单业务逻辑 | 获取和提交订单数据 |
| 提供的状态: `orders`, `currentOrder`, `orderStatus` | 提供的方法: `placeOrder()`, `cancelOrder()`, `trackOrder()` | 提供的方法: `fetchOrders()`, `createOrder()`, `updateOrderStatus()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `PaymentProvider` | `PaymentService` | `PaymentRepository` |
| 管理支付状态 | 处理支付业务逻辑 | 处理支付请求和结果 |
| 提供的状态: `paymentMethods`, `currentPayment`, `paymentStatus` | 提供的方法: `processPayment()`, `addPaymentMethod()`, `requestRefund()` | 提供的方法: `fetchPaymentMethods()`, `submitPaymentRequest()`, `verifyPaymentStatus()` |

## 咨询模块

| Provider | Service | Repository |
|----------|---------|------------|
| `ConsultationProvider` | `ConsultationService` | `ConsultationRepository` |
| 管理咨询会话状态 | 处理咨询业务逻辑 | 获取和提交咨询数据 |
| 提供的状态: `consultations`, `activeConsultation`, `consultationStatus` | 提供的方法: `scheduleConsultation()`, `cancelConsultation()`, `rateConsultation()` | 提供的方法: `fetchConsultations()`, `createConsultation()`, `updateConsultationStatus()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `NutritionistProvider` | `NutritionistService` | `NutritionistRepository` |
| 管理营养师信息 | 处理营养师数据逻辑 | 获取营养师数据 |
| 提供的状态: `nutritionists`, `featuredNutritionists`, `nutritionistFilters` | 提供的方法: `fetchNutritionists()`, `filterNutritionists()`, `getNutritionistDetail()` | 提供的方法: `fetchAllNutritionists()`, `fetchNutritionistById()`, `searchNutritionists()` |

## 论坛模块

| Provider | Service | Repository |
|----------|---------|------------|
| `ForumProvider` | `ForumService` | `ForumRepository` |
| 管理论坛状态 | 处理论坛业务逻辑 | 获取和提交帖子、评论数据 |
| 提供的状态: `posts`, `popularTopics`, `userPosts` | 提供的方法: `createPost()`, `deletePost()`, `likePost()` | 提供的方法: `fetchPosts()`, `submitPost()`, `updatePost()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `CommentProvider` | `CommentService` | `CommentRepository` |
| 管理评论状态 | 处理评论业务逻辑 | 获取和提交评论数据 |
| 提供的状态: `comments`, `userComments`, `commentCount` | 提供的方法: `addComment()`, `deleteComment()`, `likeComment()` | 提供的方法: `fetchComments()`, `submitComment()`, `updateComment()` |

## 订阅模块

| Provider | Service | Repository |
|----------|---------|------------|
| `SubscriptionProvider` | `SubscriptionService` | `SubscriptionRepository` |
| 管理用户订阅状态 | 处理订阅业务逻辑 | 获取和更新订阅数据 |
| 提供的状态: `subscriptionPlans`, `userSubscription`, `subscriptionStatus` | 提供的方法: `subscribe()`, `cancelSubscription()`, `upgradeSubscription()` | 提供的方法: `fetchSubscriptionPlans()`, `updateSubscription()`, `verifySubscriptionStatus()` |

## 杂项服务

| Provider | Service | Repository |
|----------|---------|------------|
| `NotificationProvider` | `NotificationService` | `NotificationRepository` |
| 管理通知状态 | 处理通知业务逻辑 | 获取和更新通知数据 |
| 提供的状态: `notifications`, `unreadCount`, `notificationSettings` | 提供的方法: `markAsRead()`, `updateSettings()`, `clearNotifications()` | 提供的方法: `fetchNotifications()`, `updateNotificationStatus()`, `saveNotificationSettings()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `SettingsProvider` | `SettingsService` | `SettingsRepository` |
| 管理应用设置 | 处理设置业务逻辑 | 获取和保存设置数据 |
| 提供的状态: `appSettings`, `themeMode`, `languageCode` | 提供的方法: `updateTheme()`, `updateLanguage()`, `resetSettings()` | 提供的方法: `fetchSettings()`, `saveSettings()`, `clearSettings()` |

## 管理员模块

| Provider | Service | Repository |
|----------|---------|------------|
| `AdminDashboardProvider` | `AdminDashboardService` | `AdminRepository` |
| 管理管理员仪表盘状态 | 处理管理员业务逻辑 | 获取管理数据 |
| 提供的状态: `systemStats`, `userAnalytics`, `activityLogs` | 提供的方法: `fetchStats()`, `generateReport()`, `viewUserActivity()` | 提供的方法: `fetchSystemStats()`, `fetchUserAnalytics()`, `fetchActivityLogs()` |

| Provider | Service | Repository |
|----------|---------|------------|
| `UserManagementProvider` | `UserManagementService` | `AdminUserRepository` |
| 管理用户管理功能 | 处理用户管理业务逻辑 | 获取和更新用户管理数据 |
| 提供的状态: `users`, `userFilters`, `selectedUser` | 提供的方法: `searchUsers()`, `updateUserStatus()`, `resetUserPassword()` | 提供的方法: `fetchUsers()`, `updateUser()`, `deleteUser()` |

## 最佳实践

### 1. Provider 实现原则

- 每个Provider只关注特定功能模块
- 状态尽量细分，避免过大的Provider
- 利用Provider依赖注入其他Provider，而不是直接访问
- 良好命名反映管理的状态

```dart
class DishProvider extends ChangeNotifier {
  final DishService _dishService;
  List<Dish> _dishes = [];
  bool _isLoading = false;
  
  // 状态暴露
  List<Dish> get dishes => _dishes;
  bool get isLoading => _isLoading;
  
  // 方法封装业务逻辑调用
  Future<void> fetchDishes() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _dishes = await _dishService.getDishes();
    } catch (error) {
      // 错误处理
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### 2. Service 实现原则

- 业务逻辑集中在Service中
- Service不持有状态
- 负责数据转换和验证
- 可以组合多个Repository调用

```dart
class OrderService {
  final OrderRepository _orderRepository;
  final UserRepository _userRepository;
  final PaymentRepository _paymentRepository;
  
  Future<Order> placeOrder(Cart cart, Address address, PaymentMethod paymentMethod) async {
    // 验证购物车
    if (cart.items.isEmpty) {
      throw Exception('购物车为空');
    }
    
    // 验证地址
    if (!address.isValid) {
      throw Exception('地址无效');
    }
    
    // 创建订单
    final order = await _orderRepository.createOrder(
      userId: await _userRepository.getCurrentUserId(),
      items: cart.items,
      address: address,
    );
    
    // 处理支付
    final paymentResult = await _paymentRepository.processPayment(
      orderId: order.id,
      amount: order.total,
      method: paymentMethod,
    );
    
    // 更新订单状态
    return _orderRepository.updateOrderStatus(
      orderId: order.id,
      status: paymentResult.success ? OrderStatus.paid : OrderStatus.paymentFailed,
    );
  }
}
```

### 3. Repository 实现原则

- 负责数据获取和持久化
- 抽象化数据源（API、本地数据库等）
- 提供统一的数据访问接口
- 处理数据缓存策略

```dart
class UserRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;
  
  Future<User> getCurrentUser() async {
    // 尝试从本地缓存获取
    final cachedUser = await _localStorage.getUser();
    if (cachedUser != null) {
      return cachedUser;
    }
    
    // 从API获取
    final user = await _apiClient.get('/user/profile');
    
    // 缓存结果
    await _localStorage.saveUser(user);
    
    return user;
  }
  
  Future<void> updateUserProfile(UserProfile profile) async {
    // 更新远程数据
    await _apiClient.put('/user/profile', data: profile.toJson());
    
    // 更新本地缓存
    final cachedUser = await _localStorage.getUser();
    if (cachedUser != null) {
      cachedUser.profile = profile;
      await _localStorage.saveUser(cachedUser);
    }
  }
}
```

## 依赖注入

项目使用Provider包的ChangeNotifierProvider进行依赖注入，确保各层组件正确获取依赖：

```dart
MultiProvider(
  providers: [
    // 核心服务
    Provider<ApiClient>(
      create: (_) => ApiClient(),
    ),
    Provider<LocalStorage>(
      create: (_) => LocalStorage(),
    ),
    
    // Repositories
    Provider<UserRepository>(
      create: (context) => UserRepository(
        context.read<ApiClient>(),
        context.read<LocalStorage>(),
      ),
    ),
    
    // Services
    Provider<AuthService>(
      create: (context) => AuthService(
        context.read<UserRepository>(),
      ),
    ),
    
    // Providers
    ChangeNotifierProvider<AuthProvider>(
      create: (context) => AuthProvider(
        context.read<AuthService>(),
      ),
    ),
    
    // 依赖其他Provider的Provider
    ChangeNotifierProxyProvider<AuthProvider, UserProfileProvider>(
      create: (context) => UserProfileProvider(
        context.read<UserProfileService>(),
      ),
      update: (context, authProvider, userProfileProvider) => 
        userProfileProvider!..updateWithAuth(authProvider),
    ),
  ],
  child: MyApp(),
)
```

## 总结

遵循上述映射关系和实现原则，有助于保持代码的清晰结构和关注点分离。这种分层架构使得：

1. **UI层**专注于展示
2. **Provider层**专注于状态管理
3. **Service层**专注于业务逻辑
4. **Repository层**专注于数据操作

随着项目的发展，本文档将持续更新以反映最新的结构和最佳实践。 