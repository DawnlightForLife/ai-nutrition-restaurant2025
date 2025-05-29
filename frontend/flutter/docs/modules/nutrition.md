# 营养管理模块 (Nutrition)

## 📋 模块概述

营养管理模块是应用的核心功能，提供个性化营养档案管理、AI智能推荐和营养目标追踪等功能。

### 核心功能
- 📊 个性化营养档案创建与管理
- 🤖 AI 智能营养推荐
- 🎯 营养目标设定与追踪
- 📈 营养摄入分析与报告
- 🍎 食物营养成分查询
- ⭐ 个人收藏与偏好管理

## 🏗️ 模块架构

```
nutrition/
├── data/                      # 数据层
│   ├── datasources/          # 数据源
│   │   ├── nutrition_api.dart
│   │   └── nutrition_local_datasource.dart
│   ├── models/               # 数据模型
│   │   ├── nutrition_profile_model.dart
│   │   ├── recommendation_model.dart
│   │   └── food_item_model.dart
│   └── repositories/         # 仓储实现
│       └── nutrition_repository_impl.dart
├── domain/                   # 领域层
│   ├── entities/             # 业务实体
│   │   ├── nutrition_profile.dart
│   │   ├── recommendation.dart
│   │   └── food_item.dart
│   ├── repositories/         # 仓储接口
│   │   └── i_nutrition_repository.dart
│   └── usecases/            # 用例
│       ├── get_nutrition_profile_usecase.dart
│       ├── update_nutrition_profile_usecase.dart
│       └── get_ai_recommendations_usecase.dart
└── presentation/            # 表现层
    ├── pages/               # 页面
    │   ├── nutrition_profile_page.dart
    │   ├── recommendations_page.dart
    │   ├── nutrition_analysis_page.dart
    │   └── food_search_page.dart
    ├── widgets/             # 组件
    │   ├── profile_form.dart
    │   ├── recommendation_card.dart
    │   ├── nutrition_chart.dart
    │   └── progress_indicator.dart
    └── providers/           # 状态管理
        └── nutrition_profile_controller.dart
```

## 🎯 主要功能

### 1. 营养档案管理

#### 档案信息包含
- **基础信息**：身高、体重、年龄、性别
- **活动水平**：久坐、轻度活动、中度活动、高强度活动
- **健康状况**：过敏源、疾病史、用药情况
- **营养目标**：减重、增重、维持、增肌等
- **饮食偏好**：素食、生酮、地中海等饮食模式

#### 完成度计算
```dart
class CompletionStats {
  final int completionPercentage;  // 完成百分比
  final List<String> missingFields;  // 缺失字段
  
  // 计算逻辑包含11个关键字段
  // 每个字段权重相等，总计100%
}
```

### 2. AI 智能推荐

#### 推荐算法基础
- **个人档案分析**：基于用户营养档案
- **健康目标匹配**：与设定目标对齐
- **营养缺口识别**：分析当前摄入不足
- **食物搭配优化**：确保营养均衡

#### 推荐类型
- **每日餐食推荐**：早、中、晚餐搭配
- **单品推荐**：特定营养素补充
- **替代方案**：不喜欢食物的替代品
- **应季推荐**：基于时令的食材推荐

### 3. 营养分析

#### 分析维度
- **宏量营养素**：碳水化合物、蛋白质、脂肪
- **微量营养素**：维生素、矿物质
- **热量分析**：摄入vs消耗对比
- **营养密度**：食物营养价值评分

#### 可视化图表
- **环形图**：营养素占比
- **折线图**：营养趋势分析
- **柱状图**：目标达成情况
- **雷达图**：营养平衡评估

## 🔌 状态管理

### NutritionProfileController

使用 Riverpod 2.0 AsyncNotifier 模式：

```dart
@riverpod
class NutritionProfileController extends _$NutritionProfileController {
  @override
  Future<NutritionProfileState> build() async {
    final nutritionApi = ref.read(nutritionApiProvider);
    final authService = ref.read(authServiceProvider);
    
    final userId = await authService.getUserId();
    if (userId == null) throw Exception('用户未登录');
    
    final response = await nutritionApi.getNutritionProfile(userId);
    
    if (response.response.statusCode == 200) {
      final data = response.data;
      if (data['profiles'] != null && data['profiles'].isNotEmpty) {
        final profile = NutritionProfile.fromJson(data['profiles'][0]);
        final completionStats = _calculateCompletionStats(profile);
        
        return NutritionProfileState(
          profile: profile,
          completionStats: completionStats,
        );
      }
    }
    
    return const NutritionProfileState();
  }

  // 创建档案
  Future<bool> createProfile(NutritionProfile profile) async { /* ... */ }
  
  // 更新档案
  Future<bool> updateProfile(NutritionProfile profile) async { /* ... */ }
  
  // 刷新数据
  Future<void> refresh() async { /* ... */ }
}
```

### 状态结构

```dart
@freezed
class NutritionProfileState with _$NutritionProfileState {
  const factory NutritionProfileState({
    NutritionProfile? profile,
    CompletionStats? completionStats,
  }) = _NutritionProfileState;
}

@freezed
class CompletionStats with _$CompletionStats {
  const factory CompletionStats({
    required int completionPercentage,
    required List<String> missingFields,
  }) = _CompletionStats;
}
```

## 📱 UI 组件

### 1. 营养档案页面
```dart
class NutritionProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(nutritionProfileControllerProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('营养档案')),
      body: AsyncView<NutritionProfileState>(
        value: profileState,
        data: (state) => _buildProfileContent(state),
        loading: () => const ProfileSkeleton(),
        error: (error, stack) => ErrorRetryWidget(
          onRetry: () => ref.refresh(nutritionProfileControllerProvider),
        ),
      ),
    );
  }
}
```

### 2. 核心组件

#### 档案表单组件
```dart
class ProfileForm extends StatefulWidget {
  final NutritionProfile? initialProfile;
  final Function(NutritionProfile) onSubmit;
  
  // 特性：
  // - 步骤式表单填写
  // - 实时验证
  // - 自动保存草稿
  // - 进度指示器
}
```

#### 推荐卡片组件
```dart
class RecommendationCard extends StatelessWidget {
  final Recommendation recommendation;
  
  // 特性：
  // - 营养信息展示
  // - 收藏功能
  // - 详情查看
  // - 一键添加到计划
}
```

#### 营养图表组件
```dart
class NutritionChart extends StatelessWidget {
  final ChartType type;
  final List<NutritionData> data;
  
  // 支持的图表类型：
  // - 环形图（营养素占比）
  // - 柱状图（目标达成）
  // - 折线图（趋势分析）
  // - 雷达图（营养平衡）
}
```

## 🤖 AI 推荐系统

### 推荐引擎架构
```dart
class AIRecommendationEngine {
  // 1. 用户画像分析
  UserProfile analyzeUserProfile(NutritionProfile profile);
  
  // 2. 营养需求计算
  NutritionRequirements calculateRequirements(UserProfile profile);
  
  // 3. 食物匹配算法
  List<FoodItem> matchFoods(NutritionRequirements requirements);
  
  // 4. 推荐排序优化
  List<Recommendation> rankRecommendations(
    List<FoodItem> foods,
    UserPreferences preferences
  );
}
```

### 推荐算法要素

#### 1. 用户特征权重
```dart
class UserFeatureWeights {
  final double ageWeight = 0.15;
  final double genderWeight = 0.10;
  final double activityWeight = 0.20;
  final double healthGoalWeight = 0.25;
  final double preferenceWeight = 0.20;
  final double medicalWeight = 0.10;
}
```

#### 2. 营养优先级
```dart
enum NutritionPriority {
  critical,    // 严重缺乏
  important,   // 重要补充
  beneficial,  // 有益添加
  optional,    // 可选项目
}
```

#### 3. 推荐置信度
```dart
class RecommendationConfidence {
  final double nutritionMatch;    // 营养匹配度
  final double preferenceMatch;   // 偏好匹配度
  final double safetyScore;      // 安全评分
  final double overallConfidence; // 综合置信度
}
```

## 📊 数据分析

### 营养摄入追踪
```dart
class NutritionTracker {
  // 每日营养摄入记录
  Future<void> recordIntake(FoodIntake intake);
  
  // 营养缺口分析
  NutritionGap analyzeGap(
    DailyIntake actual,
    NutritionTarget target
  );
  
  // 趋势分析
  List<TrendPoint> analyzeTrend(
    DateRange range,
    NutritionType type
  );
  
  // 目标达成评估
  GoalAchievement assessGoalAchievement(
    List<DailyIntake> history,
    NutritionGoal goal
  );
}
```

### 报告生成
```dart
class NutritionReportGenerator {
  // 周度报告
  WeeklyReport generateWeeklyReport(
    String userId,
    DateTime weekStart
  );
  
  // 月度报告
  MonthlyReport generateMonthlyReport(
    String userId,
    DateTime monthStart
  );
  
  // 自定义报告
  CustomReport generateCustomReport(
    String userId,
    ReportConfig config
  );
}
```

## 🧪 测试策略

### 1. 单元测试

#### Controller 测试
```dart
group('NutritionProfileController', () {
  test('should load user nutrition profile', () async {
    // 测试档案加载
  });
  
  test('should calculate completion stats correctly', () async {
    // 测试完成度计算
  });
  
  test('should update profile successfully', () async {
    // 测试档案更新
  });
});
```

#### 推荐算法测试
```dart
group('AIRecommendationEngine', () {
  test('should generate recommendations based on profile', () {
    // 测试推荐生成
  });
  
  test('should prioritize recommendations correctly', () {
    // 测试推荐排序
  });
});
```

### 2. Widget 测试
```dart
testWidgets('ProfileForm should validate required fields', (tester) async {
  // 测试表单验证
});

testWidgets('RecommendationCard should display nutrition info', (tester) async {
  // 测试推荐卡片显示
});
```

### 3. 集成测试
```dart
testWidgets('user can create and update nutrition profile', (tester) async {
  // 测试完整的档案管理流程
});
```

## 📡 API 集成

### 营养相关接口

```dart
@RestApi()
abstract class NutritionApi {
  factory NutritionApi(Dio dio) = _NutritionApi;
  
  // 获取营养档案
  @GET('/nutrition/profile/{userId}')
  Future<HttpResponse<Map<String, dynamic>>> getNutritionProfile(
    @Path() String userId
  );
  
  // 更新营养档案
  @PUT('/nutrition/profile/{userId}')
  Future<HttpResponse<Map<String, dynamic>>> updateNutritionProfile(
    @Path() String userId,
    @Body() Map<String, dynamic> profile
  );
  
  // 获取AI推荐
  @POST('/nutrition/recommendations')
  Future<HttpResponse<List<Map<String, dynamic>>>> getAIRecommendations(
    @Body() Map<String, dynamic> profileData
  );
  
  // 食物搜索
  @GET('/nutrition/foods/search')
  Future<HttpResponse<List<Map<String, dynamic>>>> searchFoods(
    @Query('q') String query,
    @Query('limit') int limit
  );
  
  // 营养分析
  @POST('/nutrition/analyze')
  Future<HttpResponse<Map<String, dynamic>>> analyzeNutrition(
    @Body() List<Map<String, dynamic>> intakeData
  );
}
```

## 🔄 数据流

### 档案管理流程
```
UI Layer (ProfileForm)
    ↓ 用户输入
NutritionProfileController
    ↓ 验证数据
ValidationService
    ↓ 调用API
NutritionApi
    ↓ 保存数据
Database
    ↓ 更新缓存
Local Storage
    ↓ 通知UI
State Update → UI Refresh
```

### AI推荐流程
```
User Profile Data
    ↓ 特征提取
FeatureExtractor
    ↓ 需求计算
NutritionCalculator
    ↓ 食物匹配
FoodMatcher
    ↓ 排序优化
RecommendationRanker
    ↓ 结果返回
UI Display
```

## ⚙️ 配置说明

### 营养计算配置
```dart
class NutritionConfig {
  // BMR计算公式选择
  static const BMRFormula bmrFormula = BMRFormula.harris_benedict;
  
  // 活动系数
  static const Map<ActivityLevel, double> activityMultipliers = {
    ActivityLevel.sedentary: 1.2,
    ActivityLevel.light: 1.375,
    ActivityLevel.moderate: 1.55,
    ActivityLevel.active: 1.725,
    ActivityLevel.veryActive: 1.9,
  };
  
  // 营养素比例
  static const Map<MacroNutrient, double> macroRatios = {
    MacroNutrient.carbohydrate: 0.50,
    MacroNutrient.protein: 0.25,
    MacroNutrient.fat: 0.25,
  };
}
```

### AI推荐配置
```dart
class AIConfig {
  // 推荐数量限制
  static const int maxRecommendations = 20;
  static const int minRecommendations = 5;
  
  // 置信度阈值
  static const double minConfidenceThreshold = 0.6;
  static const double highConfidenceThreshold = 0.8;
  
  // 更新频率
  static const Duration recommendationRefreshInterval = Duration(hours: 6);
}
```

## 🚀 使用示例

### 1. 加载营养档案
```dart
class ProfilePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(nutritionProfileControllerProvider);
    final profile = ref.watch(currentProfileProvider);
    final completionStats = ref.watch(profileCompletionStatsProvider);
    
    return AsyncView<NutritionProfileState>(
      value: profileState,
      data: (state) => Column(
        children: [
          if (completionStats != null)
            CompletionIndicator(stats: completionStats),
          if (profile != null)
            ProfileSummary(profile: profile),
        ],
      ),
    );
  }
}
```

### 2. 更新档案信息
```dart
class EditProfileButton extends ConsumerWidget {
  final NutritionProfile profile;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final updated = await showDialog<NutritionProfile>(
          context: context,
          builder: (context) => ProfileEditDialog(profile: profile),
        );
        
        if (updated != null) {
          await ref
              .read(nutritionProfileControllerProvider.notifier)
              .updateProfile(updated);
        }
      },
      child: const Text('编辑档案'),
    );
  }
}
```

### 3. 检查档案完成度
```dart
// 使用便捷访问器
final isComplete = ref.watch(isProfileCompleteProvider);
final completionPercentage = ref.watch(profileCompletionStatsProvider)
    ?.completionPercentage ?? 0;

if (!isComplete) {
  // 显示完善档案提示
  return IncompleteProfileBanner(
    percentage: completionPercentage,
    onTap: () => Navigator.pushNamed(context, '/profile/edit'),
  );
}
```

## 🛠️ 开发指南

### 1. 添加新的营养指标
1. 更新 `NutritionProfile` 实体
2. 修改数据模型 `NutritionProfileModel`
3. 调整完成度计算逻辑
4. 更新API接口
5. 修改UI表单

### 2. 扩展AI推荐算法
```dart
// 1. 创建新的推荐策略
class NewRecommendationStrategy implements RecommendationStrategy {
  @override
  List<Recommendation> generateRecommendations(UserProfile profile) {
    // 实现新的推荐逻辑
  }
}

// 2. 注册策略
class RecommendationEngine {
  void registerStrategy(String name, RecommendationStrategy strategy) {
    _strategies[name] = strategy;
  }
}
```

### 3. 自定义营养图表
```dart
// 继承基础图表组件
class CustomNutritionChart extends NutritionChart {
  @override
  Widget buildChart(List<NutritionData> data) {
    // 自定义图表实现
  }
}
```

## 📝 最佳实践

### 1. 数据验证
- 严格验证用户输入的营养数据
- 设置合理的数值范围限制
- 提供友好的错误提示

### 2. 性能优化
- 缓存营养计算结果
- 延迟加载非关键数据
- 优化图表渲染性能

### 3. 用户体验
- 提供步骤式档案填写流程
- 实时显示完成进度
- 支持草稿保存功能

### 4. 数据安全
- 加密敏感健康数据
- 遵守数据隐私法规
- 提供数据导出功能

## 🔍 故障排除

### 常见问题

#### 1. 档案加载失败
```dart
// 检查网络连接和认证状态
if (error is NetworkException) {
  // 网络错误处理
} else if (error is AuthException) {
  // 认证过期处理
}
```

#### 2. AI推荐不准确
```dart
// 检查用户档案完整性
final completionStats = ref.watch(profileCompletionStatsProvider);
if (completionStats.completionPercentage < 80) {
  // 提示用户完善档案
}
```

#### 3. 计算结果异常
```dart
// 验证输入数据范围
if (profile.weight < 30 || profile.weight > 300) {
  throw ValidationException('体重数据超出合理范围');
}
```

---

**📚 相关文档**
- [营养档案测试指南](../../NUTRITION_PROFILE_TEST_GUIDE.md)
- [AI推荐算法文档](./docs/AI_RECOMMENDATION_ALGORITHM.md)
- [营养计算公式说明](./docs/NUTRITION_CALCULATION.md)