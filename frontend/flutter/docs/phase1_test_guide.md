# Phase 1 功能测试指南

## 概述
本指南用于测试第一阶段实现的基础架构功能，包括：
- 路由系统与守卫
- 错误处理与边界
- 网络监控与离线支持

## 启动测试应用

1. 确保依赖已安装：
```bash
flutter pub get
```

2. 运行应用：
```bash
flutter run
```

3. 应用启动后会自动跳转到测试页面

## 测试功能说明

### 1. 路由测试 (Routing Tests)

#### Navigate to Login (Guest Guard)
- 测试访客守卫功能
- 应该跳转到登录页面

#### Navigate to Profile (Auth Guard)
- 测试认证守卫功能
- 未登录状态应该重定向到登录页面

#### Navigate to 404 Page
- 测试404页面处理
- 访问不存在的路由应显示404页面

#### Navigate with Deep Link
- 测试深度链接功能
- 应该能正确解析和导航到指定页面

### 2. 错误处理测试 (Error Handling Tests)

#### Throw Network Exception
- 测试网络异常处理
- 应该显示红色错误提示

#### Throw Auth Exception
- 测试认证异常处理
- 应该显示认证错误提示

#### Throw General Exception
- 测试通用异常处理
- 应该转换为AppException并显示

#### Test Async Error
- 测试异步错误处理
- 延迟后抛出错误，应该被正确捕获

### 3. 网络监控测试 (Network Monitoring Tests)

#### Check Current Network Status
- 显示当前网络状态
- 包括连接状态、连接类型、是否有互联网

#### Add Offline Operation
- 添加离线操作到队列
- 网络恢复后会自动同步

#### Cache Test Data
- 缓存测试数据
- 用于离线数据访问

#### Retrieve Cached Data
- 获取缓存的数据
- 验证缓存功能是否正常

#### View Pending Operations
- 查看待处理的离线操作
- 显示操作类型、端点和时间戳

### 4. 集成测试 (Integration Tests)

#### Test Error + Offline Queue
- 测试错误处理与离线队列的集成
- 网络错误时自动将操作加入队列

#### Navigate to Test Error Page
- 测试错误边界页面
- 包含多种错误场景的演示

## 错误边界测试页面

在错误边界测试页面中，有三个测试场景：

1. **Immediate Error**: 立即抛出错误，测试同步错误捕获
2. **Async Error**: 延迟2秒后抛出错误，测试异步错误捕获
3. **Recoverable Error**: 可恢复的错误，测试错误恢复机制

## 网络状态指示器

应用顶部会显示网络状态横幅：
- 🔴 红色：离线状态
- 🟡 黄色：仅移动数据
- 🟢 绿色：WiFi连接
- ✅ 隐藏：网络正常

## 预期结果

1. **路由系统**：
   - 所有路由应该正确导航
   - 守卫应该按预期工作
   - 404页面应该正确显示

2. **错误处理**：
   - 所有错误应该被捕获并显示
   - 不应该出现应用崩溃
   - 错误信息应该清晰可读

3. **网络监控**：
   - 网络状态应该实时更新
   - 离线操作应该正确排队
   - 缓存功能应该正常工作

## 故障排除

如果遇到问题：

1. 检查控制台日志
2. 确保所有依赖正确安装
3. 检查网络权限设置
4. 验证GetIt服务注册

## 下一步

测试完成后，可以继续进行第二阶段的开发：
- 状态管理优化
- 细粒度状态控制
- 状态持久化