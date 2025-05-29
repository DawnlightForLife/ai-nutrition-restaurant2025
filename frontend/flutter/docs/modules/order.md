# 订单模块 (Order)

## 📋 模块概述

订单模块负责处理用户的餐品订购、支付、配送跟踪等电商相关功能，与营养推荐系统深度集成。

### 核心功能
- 🛒 智能购物车管理
- 💳 多种支付方式支持
- 🚚 实时配送跟踪
- 📋 订单历史管理
- 🎯 基于营养需求的商品推荐

## 🎯 主要功能

### 1. 订单创建流程
- **商品选择**：从推荐列表或搜索选择
- **数量调整**：支持批量操作
- **营养计算**：实时显示营养成分
- **地址选择**：收货地址管理
- **支付确认**：多种支付方式

### 2. 订单状态管理
- `pending` - 待支付
- `paid` - 已支付
- `preparing` - 商家备餐中
- `delivering` - 配送中
- `completed` - 已完成
- `cancelled` - 已取消

## 🔌 状态管理

```dart
@riverpod
class OrderController extends _$OrderController {
  @override
  Future<List<Order>> build() async {
    final useCase = ref.read(getOrdersUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (orders) => orders,
    );
  }

  Future<void> createOrder(OrderRequest request) async { /* ... */ }
  Future<void> updateOrderStatus(String orderId, String status) async { /* ... */ }
  Future<void> cancelOrder(String orderId) async { /* ... */ }
}
```

## 📱 核心组件

- **OrderList**: 订单列表展示
- **OrderDetail**: 订单详情页面
- **ShoppingCart**: 购物车组件
- **PaymentMethods**: 支付方式选择
- **DeliveryTracker**: 配送跟踪组件

## 🚀 使用示例

```dart
class OrderPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(orderControllerProvider);
    
    return AsyncView<List<Order>>(
      value: ordersState,
      data: (orders) => OrderList(orders: orders),
    );
  }
}
```

---

**📚 相关文档**
- [支付集成指南](./docs/PAYMENT_INTEGRATION.md)
- [配送API文档](./docs/DELIVERY_API.md)