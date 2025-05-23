# 离线优先架构设计

本文档描述了AI营养餐厅应用中的离线优先架构设计，包括核心组件、工作流程和最佳实践。

## 目录

- [概述](#概述)
- [架构组件](#架构组件)
- [数据流](#数据流)
- [使用示例](#使用示例)
- [最佳实践](#最佳实践)
- [常见问题](#常见问题)

## 概述

离线优先架构是一种设计理念，它将应用设计为首先考虑离线状态，然后再考虑在线状态。这种方法确保用户即使在没有网络连接的情况下也能使用应用程序的核心功能，从而提供更好的用户体验。

离线优先架构的核心原则：

1. **本地数据优先**：应用程序首先尝试使用本地数据，而不是立即请求网络资源
2. **队列化操作**：当用户进行操作时，系统会将这些操作存储在本地队列中
3. **后台同步**：当网络恢复时，系统会在后台自动同步这些操作
4. **冲突解决**：当本地更改与服务器上的更改冲突时，系统会提供解决方案
5. **乐观UI更新**：系统会立即更新用户界面，假设操作最终会成功

## 架构组件

### 1. 离线同步服务 (OfflineSyncService)

负责管理离线操作队列、执行同步、监控网络状态等核心功能。

**主要功能**:
- 队列化离线操作
- 自动重试和同步
- 处理冲突解决
- 优化性能与电池使用
- 提供操作状态更新

**位置**: `lib/services/cache/offline_sync_service.dart`

### 2. 待处理操作模型 (PendingOperation)

定义了离线操作的数据结构，包括操作类型、状态、优先级等。

**主要字段**:
- `id`: 操作唯一标识符
- `entityType`: 实体类型（如：user, order等）
- `operation`: 操作类型（CREATE, UPDATE, DELETE）
- `entityId`: 实体ID
- `data`: 操作数据
- `endpoint`: API端点
- `status`: 操作状态（pending, success, failed）
- `priority`: 优先级
- `retries`: 重试次数

**位置**: `lib/models/sync/pending_operation_model.dart`

### 3. 增强型HTTP客户端 (EnhancedHttpClient)

对标准HTTP客户端的封装，增加了离线支持功能。

**主要功能**:
- 自动将离线请求转换为队列操作
- 提供乐观UI更新支持
- 在网络恢复后自动同步
- 监控同步状态

**位置**: `lib/services/api/enhanced_http_client.dart`

### 4. 离线同步指示器 (OfflineSyncIndicator)

UI组件，用于显示当前同步状态和待处理操作数量。

**主要功能**:
- 显示同步状态
- 显示待处理操作数量
- 提供手动同步功能

**位置**: `lib/components/common/offline_sync_indicator.dart`

## 数据流

下面的流程图描述了应用中数据的流动方式：

```
┌───────────┐     ┌────────────┐     ┌──────────────┐
│           │     │            │     │              │
│  用户操作  ├────►│ 乐观UI更新  ├────►│ EnhancedHTTP │
│           │     │            │     │    Client    │
└───────────┘     └────────────┘     └──────┬───────┘
                                            │
                      ┌───────────────┐     │
                      │               │     │  在线  
                 否    │ 是否有网络连接 │◄────┘
              ┌───────┤               │
              │       └───────┬───────┘
              │               │ 是
              ▼               ▼
┌─────────────────────┐   ┌───────────────────┐
│                     │   │                   │
│ OfflineSyncService  │   │  正常API请求       │
│ 添加到待处理操作队列   │   │                   │
│                     │   └────────┬──────────┘
└──────────┬──────────┘            │
           │                       │
           │  网络恢复              │
           │                       │
           ▼                       ▼
┌─────────────────────┐   ┌───────────────────┐
│                     │   │                   │
│ 后台自动同步队列      │   │  更新本地缓存      │
│                     │   │                   │
└─────────────────────┘   └───────────────────┘
```

## 使用示例

### 基本用法

```dart
// 初始化
final httpClient = EnhancedHttpClient(standardHttpClient, offlineSyncService);

// GET请求（带缓存）
final response = await httpClient.get('/api/products');

// POST请求（支持离线）
final result = await httpClient.post(
  '/api/orders',
  data: orderData,
  entityType: 'order',
  entityId: tempOrderId,
);

// 判断是否为离线操作
if (result != null && result['offline'] == true) {
  // 显示"已加入离线队列"提示
  print('操作ID: ${result['operationId']}');
}

// 添加实体变更监听（用于乐观UI更新）
httpClient.addEntityChangeListener((entityType, change) {
  if (entityType == 'order') {
    // 处理订单变更通知
  }
});

// 获取同步状态
final stats = httpClient.getSyncStats();
print('待处理操作: ${stats['pendingOperations']}');

// 手动触发同步
await httpClient.syncPendingOperations();
```

### 在Widget中使用离线同步指示器

```dart
Scaffold(
  appBar: AppBar(
    title: const Text('我的应用'),
    actions: const [
      // 显示同步状态指示器
      Padding(
        padding: EdgeInsets.only(right: 16.0),
        child: OfflineSyncIndicator(),
      ),
    ],
  ),
  body: // 页面内容
);
```

## 最佳实践

### 1. 乐观UI更新

应立即更新UI，假设操作最终会成功，同时提供视觉指示器（如半透明状态）表明操作尚未完成同步。

```dart
void _handleEntityChange(String entityType, dynamic change) {
  if (entityType != 'product') return;
  
  final operation = change['operation'];
  final status = change['status'];
  
  setState(() {
    if (operation == 'CREATE' && status == 'pending') {
      // 添加新项目到列表，但标记为"待处理"
      _items.add({...change['data'], 'isPending': true});
    } else if (status == 'success') {
      // 更新项目状态为已同步
      final index = _findItemIndex(change['entityId']);
      if (index >= 0) {
        _items[index]['isPending'] = false;
      }
    }
  });
}
```

### 2. 优先级管理

为不同类型的操作设置适当的优先级，确保重要操作优先同步。

```dart
// 高优先级操作（如付款）
await offlineSyncService.queueOperation(
  entityType: 'payment',
  operation: OfflineSyncService.CREATE,
  entityId: paymentId,
  data: paymentData,
  endpoint: '/api/payments',
  priority: 5, // 最高优先级
);

// 低优先级操作（如更新个人资料）
await offlineSyncService.queueOperation(
  entityType: 'profile',
  operation: OfflineSyncService.UPDATE,
  entityId: userId,
  data: profileData,
  endpoint: '/api/users/$userId',
  priority: 2, // 较低优先级
);
```

### 3. 冲突解决策略

制定明确的冲突解决策略，处理本地更改与服务器更改的冲突。

- **服务器优先**：丢弃本地更改，使用服务器数据
- **客户端优先**：覆盖服务器数据
- **合并策略**：智能合并两种更改
- **用户决策**：让用户选择保留哪个版本

### 4. 数据一致性保障

确保关键业务操作的数据一致性，可以使用以下策略：

- **事务日志**：记录所有操作历史
- **幂等操作**：确保同一操作多次执行的结果相同
- **版本控制**：使用版本号或时间戳跟踪数据变更

## 常见问题

### Q: 如何处理长时间离线的数据同步？

A: 对于长时间离线的情况，系统会保持操作队列直到网络恢复。为了优化性能，可以：
- 设置最大队列长度限制
- 合并相同资源的多次操作
- 定期清理过期的低优先级操作

### Q: 如何确保敏感操作（如支付）的安全性？

A: 对于敏感操作：
- 可以设置为"仅在线模式"，不允许离线执行
- 在同步前添加额外的验证步骤
- 使用加密存储离线数据
- 实现两阶段提交模式

### Q: 如何监控同步状态？

A: 系统提供了多种监控方式：
- 使用`OfflineSyncIndicator`组件直观显示
- 通过`httpClient.getSyncStats()`获取统计数据
- 添加`httpClient.addSyncStateListener()`监听状态变化

### Q: 如何在多设备间保持数据一致性？

A: 多设备同步可以通过以下方式实现：
- 使用服务器时间戳确定最新版本
- 实现设备间的冲突解决策略
- 使用推送通知通知其他设备数据变更 