# 团队开发指南

## 🎯 模块责任分配

### 功能模块负责人
```yaml
features/
├── auth/        # 负责人: @认证团队
├── user/        # 负责人: @用户团队  
├── nutrition/   # 负责人: @营养团队
├── order/       # 负责人: @订单团队
├── merchant/    # 负责人: @商家团队
├── admin/       # 负责人: @管理团队
└── common/      # 负责人: @架构团队
```

### 共享模块（需要架构团队审核）
```yaml
core/           # 核心功能 - 修改需要架构评审
shared/         # 共享组件 - 修改需要设计评审
config/         # 配置文件 - 修改需要技术负责人批准
```

## 📋 开发流程

### 1. 开始新功能
```bash
# 1. 从最新的main分支创建功能分支
git checkout main
git pull origin main
git checkout -b feature/[module-name]/[feature-description]

# 2. 使用模板创建标准结构
./scripts/create_feature.sh [feature_name]

# 3. 安装pre-commit hooks
pre-commit install
```

### 2. AI工具使用规范

#### 使用Cursor时：
1. **打开项目时包含这些文件作为上下文**：
   - `ARCHITECTURE_FREEZE.md`
   - `AI_DEVELOPMENT_RULES.md`
   - 你负责模块的 `README.md`

2. **Cursor规则设置**：
```
@workspace 请遵循以下规则：
1. 严格遵循 Clean Architecture + DDD
2. 不创建新的顶层目录
3. 使用 Riverpod 进行状态管理
4. 所有异步操作返回 Either<Failure, Success>
5. 使用现有的基类和工具类
```

3. **提示词模板**：
```
我需要在 features/[module_name]/ 下添加 [功能描述]
请遵循现有的架构模式，使用 Clean Architecture 的三层结构
```

### 3. 代码审查清单

提交PR前，确保：

- [ ] 运行架构检查: `dart scripts/check_architecture.dart`
- [ ] 运行测试: `flutter test`
- [ ] 运行分析: `flutter analyze`
- [ ] 代码格式化: `dart format .`
- [ ] 更新相关文档
- [ ] 没有硬编码值
- [ ] 添加了必要的测试

### 4. 避免冲突的最佳实践

1. **小步提交**
   - 每个PR只做一件事
   - 避免大规模重构

2. **及时同步**
   - 每天开始工作前拉取最新代码
   - 完成功能后尽快提PR

3. **沟通优先**
   - 修改共享代码前在群里说一声
   - 遇到架构问题先讨论

## 🚨 常见问题处理

### Q: AI工具生成了不符合架构的代码怎么办？

1. 不要直接使用，先理解代码意图
2. 按照架构规范重构代码
3. 使用已有的模式和基类

### Q: 需要修改其他团队的模块怎么办？

1. 先和模块负责人沟通
2. 创建issue说明修改原因
3. 提PR并指定模块负责人review

### Q: 发现架构问题怎么办？

1. 不要擅自修改架构
2. 在 `architecture-discussions` 频道提出
3. 等待架构团队评估和决策

## 📊 代码质量标准

### 命名规范
```dart
// 类名：大驼峰
class UserProfile {}

// 文件名：小写下划线
user_profile.dart

// 常量：大写下划线
const int MAX_RETRY_COUNT = 3;

// 私有变量：下划线开头
String _privateField;
```

### 注释规范
```dart
/// 用户档案实体类
/// 
/// 包含用户的基本信息和健康数据
class UserProfile {
  /// 用户唯一标识
  final String id;
  
  /// 创建新的用户档案
  /// 
  /// [id] 用户唯一标识，不能为空
  /// [name] 用户姓名
  UserProfile({
    required this.id,
    required this.name,
  });
}
```

## 🔧 工具链配置

### VSCode 推荐配置
```json
{
  "editor.formatOnSave": true,
  "dart.lineLength": 100,
  "files.exclude": {
    "**/*.g.dart": true,
    "**/*.freezed.dart": true
  }
}
```

### Android Studio 配置
1. 安装 Flutter 和 Dart 插件
2. 设置代码格式化快捷键
3. 启用 dartfmt on save

## 📚 学习资源

- [Clean Architecture 原理](docs/clean_architecture.md)
- [DDD 在 Flutter 中的实践](docs/ddd_flutter.md)
- [Riverpod 最佳实践](docs/riverpod_best_practices.md)
- [架构决策记录](docs/architecture_decisions/)