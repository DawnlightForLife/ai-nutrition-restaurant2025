import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecases/get_consultations_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'consultation_controller.freezed.dart';
part 'consultation_controller.g.dart';

/// 咨询状态
@freezed
class ConsultationState with _$ConsultationState {
  const factory ConsultationState({
    @Default([]) List<Uconsultation> consultations,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _ConsultationState;
}

/// 咨询控制器 - 使用新的 AsyncNotifier 模式
@riverpod
class ConsultationController extends _$ConsultationController {
  @override
  Future<List<Uconsultation>> build() async {
    final useCase = ref.read(getConsultationsUseCaseProvider);
    final result = await useCase(NoParams());
    
    return result.fold(
      (failure) => throw Exception(failure.message),
      (consultations) => consultations,
    );
  }

  /// 刷新咨询列表
  Future<void> refreshConsultations() async {
    ref.invalidateSelf();
    await future;
  }

  /// 加载咨询（兼容旧接口）
  Future<void> loadConsultations() async {
    return refreshConsultations();
  }

  /// 添加新咨询到列表
  void addConsultation(Uconsultation consultation) {
    final currentConsultations = state.valueOrNull ?? [];
    state = AsyncValue.data([consultation, ...currentConsultations]);
  }

  /// 更新咨询
  void updateConsultation(Uconsultation updatedConsultation) {
    final currentConsultations = state.valueOrNull ?? [];
    final updatedConsultations = currentConsultations.map((consultation) {
      return consultation.id == updatedConsultation.id ? updatedConsultation : consultation;
    }).toList();
    
    state = AsyncValue.data(updatedConsultations);
  }

  /// 删除咨询
  void removeConsultation(String consultationId) {
    final currentConsultations = state.valueOrNull ?? [];
    final filteredConsultations = currentConsultations
        .where((consultation) => consultation.id != consultationId)
        .toList();
    state = AsyncValue.data(filteredConsultations);
  }

  /// 更新咨询状态
  void updateConsultationStatus(String consultationId, String newStatus) {
    final currentConsultations = state.valueOrNull ?? [];
    final updatedConsultations = currentConsultations.map((consultation) {
      if (consultation.id == consultationId) {
        return consultation.copyWith(status: newStatus);
      }
      return consultation;
    }).toList();
    
    state = AsyncValue.data(updatedConsultations);
  }
}

/// 单个咨询控制器
@riverpod
class SingleConsultationController extends _$SingleConsultationController {
  @override
  Future<Uconsultation?> build(String consultationId) async {
    final consultations = await ref.watch(consultationControllerProvider.future);
    return consultations.firstWhere(
      (consultation) => consultation.id == consultationId,
      orElse: () => throw Exception('咨询不存在'),
    );
  }

  /// 刷新单个咨询
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 咨询状态过滤器
@riverpod
List<Uconsultation> filteredConsultations(
  FilteredConsultationsRef ref,
  String? status,
) {
  final consultations = ref.watch(consultationControllerProvider).valueOrNull ?? [];
  
  if (status == null || status.isEmpty) {
    return consultations;
  }
  
  return consultations.where((consultation) => consultation.status == status).toList();
}

/// 用户咨询控制器
@riverpod
class UserConsultationController extends _$UserConsultationController {
  @override
  Future<List<Uconsultation>> build(String userId) async {
    final consultations = await ref.watch(consultationControllerProvider.future);
    return consultations.where((consultation) => consultation.userId == userId).toList();
  }

  /// 刷新用户咨询
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 营养师咨询控制器
@riverpod
class NutritionistConsultationController extends _$NutritionistConsultationController {
  @override
  Future<List<Uconsultation>> build(String nutritionistId) async {
    final consultations = await ref.watch(consultationControllerProvider.future);
    return consultations.where((consultation) => consultation.nutritionistId == nutritionistId).toList();
  }

  /// 刷新营养师咨询
  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}

/// 咨询统计
@riverpod
Map<String, int> consultationStats(ConsultationStatsRef ref) {
  final consultations = ref.watch(consultationControllerProvider).valueOrNull ?? [];
  
  final stats = <String, int>{};
  for (final consultation in consultations) {
    stats[consultation.status] = (stats[consultation.status] ?? 0) + 1;
  }
  
  return stats;
}

/// 今日咨询
@riverpod
List<Uconsultation> todayConsultations(TodayConsultationsRef ref) {
  final consultations = ref.watch(consultationControllerProvider).valueOrNull ?? [];
  final today = DateTime.now();
  
  return consultations.where((consultation) {
    final consultationDate = DateTime.parse(consultation.createdAt);
    return consultationDate.year == today.year &&
           consultationDate.month == today.month &&
           consultationDate.day == today.day;
  }).toList();
}

/// UseCase Provider
@riverpod
GetUconsultationsUseCase getConsultationsUseCase(GetConsultationsUseCaseRef ref) {
  final repository = ref.read(consultationRepositoryProvider);
  return GetUconsultationsUseCase(repository);
}

/// Repository Provider
@riverpod
UconsultationRepository consultationRepository(ConsultationRepositoryRef ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
}

/// 便捷访问器
@riverpod
List<Uconsultation> currentConsultations(CurrentConsultationsRef ref) {
  return ref.watch(consultationControllerProvider).valueOrNull ?? [];
}

@riverpod
bool hasConsultations(HasConsultationsRef ref) {
  final consultations = ref.watch(currentConsultationsProvider);
  return consultations.isNotEmpty;
}

@riverpod
int consultationCount(ConsultationCountRef ref) {
  final consultations = ref.watch(currentConsultationsProvider);
  return consultations.length;
}

/// 待处理咨询
@riverpod
List<Uconsultation> pendingConsultations(PendingConsultationsRef ref) {
  final consultations = ref.watch(currentConsultationsProvider);
  return consultations.where((consultation) => consultation.status == 'pending').toList();
}

/// 进行中的咨询
@riverpod
List<Uconsultation> activeConsultations(ActiveConsultationsRef ref) {
  final consultations = ref.watch(currentConsultationsProvider);
  return consultations.where((consultation) => consultation.status == 'active').toList();
}