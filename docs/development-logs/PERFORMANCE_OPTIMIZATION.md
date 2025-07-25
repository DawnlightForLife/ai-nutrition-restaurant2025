# C.3 性能优化建议

## 🚀 后端性能优化

### 1. 数据库优化
```javascript
// 索引优化
// models/merchant/dishModel.js
dishSchema.index({ merchantId: 1, name: 'text' });
dishSchema.index({ merchantId: 1, isAvailable: 1 });
dishSchema.index({ createdAt: -1 });

// models/merchant/inventoryModel.js
inventorySchema.index({ merchantId: 1, name: 'text' });
inventorySchema.index({ merchantId: 1, 'stockBatches.expiryDate': 1 });

// models/order/orderModel.js
orderSchema.index({ merchantId: 1, status: 1 });
orderSchema.index({ createdAt: -1 });
orderSchema.index({ orderNumber: 1 });
```

### 2. 缓存策略
```javascript
// 菜品列表缓存
const redis = require('redis');
const client = redis.createClient();

// controllers/merchant/dishControllerEnhanced.js
exports.getDishList = async (req, res) => {
  const cacheKey = `dishes:${req.query.merchantId}`;
  
  // 尝试从缓存获取
  const cached = await client.get(cacheKey);
  if (cached) {
    return res.json(JSON.parse(cached));
  }
  
  // 查询数据库
  const dishes = await Dish.find({ merchantId });
  
  // 缓存结果（5分钟）
  await client.setex(cacheKey, 300, JSON.stringify(dishes));
  
  res.json(dishes);
};
```

### 3. API响应优化
```javascript
// 分页查询
exports.getDishList = async (req, res) => {
  const { page = 1, limit = 20, merchantId } = req.query;
  
  const options = {
    page: parseInt(page),
    limit: parseInt(limit),
    sort: { createdAt: -1 }
  };
  
  const result = await Dish.paginate(
    { merchantId }, 
    options
  );
  
  res.json({
    success: true,
    data: result.docs,
    pagination: {
      currentPage: result.page,
      totalPages: result.totalPages,
      totalItems: result.totalDocs
    }
  });
};
```

### 4. 批量操作优化
```javascript
// 批量更新订单状态
exports.batchUpdateOrderStatus = async (req, res) => {
  const { orderIds, newStatus } = req.body;
  
  // 使用 bulkWrite 提高性能
  const bulkOps = orderIds.map(id => ({
    updateOne: {
      filter: { _id: id },
      update: { 
        status: newStatus, 
        updatedAt: new Date() 
      }
    }
  }));
  
  const result = await Order.bulkWrite(bulkOps);
  
  res.json({
    success: true,
    data: {
      modifiedCount: result.modifiedCount
    }
  });
};
```

## 📱 前端性能优化

### 1. 状态管理优化
```dart
// providers/dish_provider.dart
// 使用autoDispose避免内存泄漏
final dishesProvider = StateNotifierProvider.autoDispose
    .family<DishesNotifier, AsyncValue<List<DishEntity>>, String>(
  (ref, merchantId) {
    ref.keepAlive(); // 保持状态直到主动释放
    return DishesNotifier(ref.watch(dishRepositoryProvider), merchantId);
  },
);

// 添加缓存时间控制
class DishesNotifier extends StateNotifier<AsyncValue<List<DishEntity>>> {
  DateTime? _lastFetch;
  static const _cacheTime = Duration(minutes: 5);
  
  Future<void> loadDishes() async {
    // 缓存有效期内不重新请求
    if (_lastFetch != null && 
        DateTime.now().difference(_lastFetch!) < _cacheTime) {
      return;
    }
    
    state = const AsyncValue.loading();
    final result = await _repository.getDishes(merchantId);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (dishes) {
        state = AsyncValue.data(dishes);
        _lastFetch = DateTime.now();
      },
    );
  }
}
```

### 2. UI优化
```dart
// widgets/order_card.dart
// 使用懒加载和回收机制
class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      // 添加key提高重建性能
      key: ValueKey(order.id),
      child: Column(
        // 使用mainAxisSize优化布局
        mainAxisSize: MainAxisSize.min,
        children: [
          // 图片懒加载
          if (order.items.isNotEmpty)
            LazyLoadingImage(
              imageUrl: order.items.first.imageUrl,
              placeholder: const ShimmerPlaceholder(),
            ),
          
          // 文本优化
          Text(
            order.customerName,
            // 限制重建范围
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
```

### 3. 列表性能优化
```dart
// pages/order_list_page.dart
// 使用 ListView.builder 而不是 ListView
ListView.builder(
  // 添加缓存范围
  cacheExtent: 500,
  itemCount: filteredOrders.length,
  itemBuilder: (context, index) {
    final order = filteredOrders[index];
    
    // 使用 RepaintBoundary 隔离重绘
    return RepaintBoundary(
      child: OrderCard(
        key: ValueKey(order.id),
        order: order,
        onTap: () => _navigateToOrderDetail(order.id),
      ),
    );
  },
);
```

### 4. 网络请求优化
```dart
// data/repositories/dish_repository.dart
class DishRepositoryImpl implements DishRepository {
  final Dio _dio;
  final Map<String, CancelToken> _cancelTokens = {};
  
  @override
  Future<Either<Failure, List<DishEntity>>> getDishes(String merchantId) async {
    // 取消之前的请求
    _cancelTokens['getDishes']?.cancel();
    
    final cancelToken = CancelToken();
    _cancelTokens['getDishes'] = cancelToken;
    
    try {
      final response = await _dio.get(
        '/merchant/dishes-enhanced',
        queryParameters: {'merchantId': merchantId},
        cancelToken: cancelToken,
        options: Options(
          // 添加缓存头
          headers: {'Cache-Control': 'max-age=300'},
        ),
      );
      
      // 使用 compute 在隔离线程中解析JSON
      final dishes = await compute(_parseDishes, response.data['data']);
      
      return Right(dishes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

// 独立函数用于compute
List<DishEntity> _parseDishes(List<dynamic> json) {
  return json.map((item) => DishModel.fromJson(item).toEntity()).toList();
}
```

## 🔧 数据库设计优化

### 1. 索引策略
```javascript
// 复合索引
db.dishes.createIndex({ "merchantId": 1, "isAvailable": 1, "createdAt": -1 });
db.orders.createIndex({ "merchantId": 1, "status": 1, "createdAt": -1 });
db.inventory.createIndex({ "merchantId": 1, "availableStock": 1 });

// 文本搜索索引
db.dishes.createIndex({ 
  "name": "text", 
  "description": "text" 
}, { 
  weights: { "name": 10, "description": 5 } 
});
```

### 2. 聚合查询优化
```javascript
// 订单统计聚合
const orderStats = await Order.aggregate([
  {
    $match: {
      merchantId: ObjectId(merchantId),
      createdAt: { $gte: startDate, $lte: endDate }
    }
  },
  {
    $group: {
      _id: "$status",
      count: { $sum: 1 },
      totalAmount: { $sum: "$actualAmount" }
    }
  },
  {
    $project: {
      status: "$_id",
      count: 1,
      totalAmount: 1,
      _id: 0
    }
  }
]);
```

## 📊 监控和分析

### 1. 性能监控
```javascript
// middleware/performance/performanceMiddleware.js
const performanceMiddleware = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = Date.now() - start;
    
    // 记录慢查询
    if (duration > 1000) {
      console.warn(`Slow API: ${req.method} ${req.path} - ${duration}ms`);
    }
    
    // 发送到监控系统
    metrics.timing('api.response_time', duration, {
      method: req.method,
      path: req.path,
      status_code: res.statusCode
    });
  });
  
  next();
};
```

### 2. 错误监控
```javascript
// utils/errorTracker.js
class ErrorTracker {
  static track(error, context) {
    const errorData = {
      message: error.message,
      stack: error.stack,
      context,
      timestamp: new Date(),
      userId: context.userId,
      apiPath: context.apiPath
    };
    
    // 发送到错误监控服务
    this.sendToMonitoring(errorData);
  }
}
```

## 🎯 性能指标目标

### API响应时间目标
- 菜品列表查询: < 200ms
- 库存列表查询: < 300ms  
- 订单列表查询: < 400ms
- 状态更新操作: < 100ms

### 前端性能目标
- 首屏渲染: < 1s
- 页面切换: < 300ms
- 列表滚动: 60fps
- 内存使用: < 100MB

### 并发性能目标
- 支持100并发用户
- API吞吐量: 1000 req/s
- 数据库连接池: 50连接
- 缓存命中率: > 80%