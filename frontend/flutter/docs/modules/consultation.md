# 咨询模块 (Consultation)

## 📋 模块概述

咨询模块提供用户与营养师之间的在线咨询服务，支持实时聊天、营养方案定制、健康指导等功能。

### 核心功能
- 💬 实时在线咨询
- 👨‍⚕️ 营养师匹配
- 📝 咨询记录管理
- 📊 营养方案跟踪
- ⭐ 评价反馈系统

## 🎯 主要功能

### 1. 咨询服务类型
- **即时咨询**：实时文字/语音交流
- **预约咨询**：按时间段预约专家
- **方案定制**：个性化营养计划
- **跟踪指导**：长期健康管理

### 2. 咨询状态流转
- `pending` - 待接单
- `active` - 咨询中
- `completed` - 已完成
- `cancelled` - 已取消
- `evaluated` - 已评价

## 🔌 状态管理

```dart
@riverpod
class ConsultationController extends _$ConsultationController {
  @override
  Future<List<Consultation>> build() async {
    final useCase = ref.read(getConsultationsUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (consultations) => consultations,
    );
  }

  Future<void> createConsultation(ConsultationRequest request) async { /* ... */ }
  Future<void> sendMessage(String consultationId, String message) async { /* ... */ }
  Future<void> completeConsultation(String consultationId) async { /* ... */ }
}
```

## 📱 核心组件

- **ConsultationList**: 咨询列表展示
- **ChatInterface**: 聊天界面组件
- **NutritionistCard**: 营养师信息卡片
- **ConsultationHistory**: 历史记录查看
- **RatingDialog**: 评价对话框

## 🚀 使用示例

```dart
class ConsultationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationsState = ref.watch(consultationControllerProvider);
    
    return AsyncView<List<Consultation>>(
      value: consultationsState,
      data: (consultations) => ConsultationList(
        consultations: consultations,
        onTap: (consultation) => context.go('/consultation/${consultation.id}'),
      ),
    );
  }
}
```

---

**📚 相关文档**
- [营养师认证流程](./docs/NUTRITIONIST_AUTH.md)
- [聊天协议文档](./docs/CHAT_PROTOCOL.md)
