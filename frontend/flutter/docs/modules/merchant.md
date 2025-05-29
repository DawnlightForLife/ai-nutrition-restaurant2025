# 商家模块 (Merchant)

## 📋 模块概述

商家模块为餐饮商户提供店铺管理、菜品发布、营养标注、订单处理等功能，支持商家参与智能营养推荐体系。

### 核心功能
- 🏪 店铺信息管理
- 🍽️ 菜品发布与维护
- 📊 营养成分标注
- 📦 订单处理系统
- 📈 经营数据分析

## 🎯 主要功能

### 1. 商家服务体系
- **店铺管理**：基本信息、营业时间、配送范围
- **菜品管理**：发布、编辑、上下架操作
- **营养标注**：详细营养成分录入
- **订单处理**：接单、备餐、配送管理
- **数据分析**：销售统计、用户偏好分析

### 2. 商家类型
- `restaurant` - 餐厅
- `cafe` - 咖啡店
- `health_food` - 健康食品店
- `meal_prep` - 预制餐品
- `bakery` - 烘焙店

## 🔌 状态管理

```dart
@riverpod
class MerchantController extends _$MerchantController {
  @override
  Future<MerchantDashboard> build() async {
    final useCase = ref.read(getMerchantDashboardUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (dashboard) => dashboard,
    );
  }

  Future<void> updateStoreInfo(StoreInfo info) async { /* ... */ }
  Future<void> publishDish(DishRequest request) async { /* ... */ }
  Future<void> processOrder(String orderId, OrderAction action) async { /* ... */ }
  Future<void> updateInventory(String dishId, int quantity) async { /* ... */ }
}
```

## 📱 核心组件

- **MerchantDashboard**: 商家控制台
- **DishEditor**: 菜品编辑器
- **NutritionInput**: 营养成分录入
- **OrderQueue**: 订单队列管理
- **SalesChart**: 销售数据图表

## 🚀 使用示例

```dart
class MerchantDashboardPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(merchantControllerProvider);
    
    return AsyncView<MerchantDashboard>(
      value: dashboardState,
      data: (dashboard) => MerchantDashboardView(
        storeInfo: dashboard.storeInfo,
        todayOrders: dashboard.todayOrders,
        popularDishes: dashboard.popularDishes,
        onManageDishes: () => context.go('/merchant/dishes'),
      ),
    );
  }
}
```

---

**📚 相关文档**
- [商家入驻指南](./docs/MERCHANT_ONBOARDING.md)
- [营养标注规范](./docs/NUTRITION_LABELING.md)
