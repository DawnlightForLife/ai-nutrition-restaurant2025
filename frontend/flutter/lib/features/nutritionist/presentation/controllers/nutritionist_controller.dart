import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/usecases/get_nutritionists_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'nutritionist_controller.freezed.dart';
part 'nutritionist_controller.g.dart';

/// Nutritionist 状态类
@freezed
class NutritionistState with _$NutritionistState {
  const factory NutritionistState({
    @Default([]) List<Unutritionist> nutritionists,
    @Default(false) bool isLoading,
    String? error,
    Unutritionist? selectedNutritionist,
    @Default({}) Map<String, List<Unutritionist>> nutritionistsBySpecialty,
  }) = _NutritionistState;

  const NutritionistState._();

  /// 是否处于初始状态
  bool get isInitial => nutritionists.isEmpty && !isLoading && error == null;

  /// 是否已加载数据
  bool get hasData => nutritionists.isNotEmpty;

  /// 获取所有专业领域
  List<String> get specialties => nutritionistsBySpecialty.keys.toList();

  /// 获取在线营养师
  List<Unutritionist> get onlineNutritionists =>
      nutritionists.where((n) => n.isOnline ?? false).toList();

  /// 获取认证营养师
  List<Unutritionist> get verifiedNutritionists =>
      nutritionists.where((n) => n.isVerified ?? false).toList();
}

/// Nutritionist 控制器
@riverpod
class NutritionistController extends _$NutritionistController {
  late final GetUnutritionistsUseCase _getNutritionistsUseCase;

  @override
  FutureOr<NutritionistState> build() {
    _getNutritionistsUseCase = ref.watch(getNutritionistsUseCaseProvider);
    return const NutritionistState();
  }

  /// 加载营养师列表
  Future<void> loadNutritionists() async {
    state = const AsyncValue.loading();

    final result = await _getNutritionistsUseCase(NoParams());

    state = result.fold(
      (failure) => AsyncValue.data(
        NutritionistState(error: failure.message),
      ),
      (nutritionists) {
        final nutritionistsBySpecialty = _groupBySpecialty(nutritionists);
        return AsyncValue.data(
          NutritionistState(
            nutritionists: nutritionists,
            nutritionistsBySpecialty: nutritionistsBySpecialty,
          ),
        );
      },
    );
  }

  /// 按专业领域分组营养师
  Map<String, List<Unutritionist>> _groupBySpecialty(List<Unutritionist> nutritionists) {
    final grouped = <String, List<Unutritionist>>{};
    for (final nutritionist in nutritionists) {
      for (final specialty in nutritionist.specialties ?? []) {
        grouped.putIfAbsent(specialty, () => []).add(nutritionist);
      }
    }
    return grouped;
  }

  /// 刷新营养师列表
  Future<void> refresh() async {
    await loadNutritionists();
  }

  /// 根据ID获取营养师
  Unutritionist? getNutritionistById(String id) {
    return state.valueOrNull?.nutritionists.firstWhere(
      (nutritionist) => nutritionist.id == id,
      orElse: () => throw Exception('Nutritionist not found'),
    );
  }

  /// 搜索营养师
  List<Unutritionist> searchNutritionists(String query) {
    final nutritionists = state.valueOrNull?.nutritionists ?? [];
    if (query.isEmpty) return nutritionists;

    return nutritionists.where((nutritionist) {
      final nameMatch = nutritionist.name.toLowerCase().contains(query.toLowerCase());
      final bioMatch = nutritionist.bio?.toLowerCase().contains(query.toLowerCase()) ?? false;
      final specialtyMatch = nutritionist.specialties?.any(
            (s) => s.toLowerCase().contains(query.toLowerCase()),
          ) ??
          false;
      return nameMatch || bioMatch || specialtyMatch;
    }).toList();
  }

  /// 按专业领域筛选营养师
  List<Unutritionist> filterBySpecialty(String specialty) {
    return state.valueOrNull?.nutritionistsBySpecialty[specialty] ?? [];
  }

  /// 按评分筛选营养师
  List<Unutritionist> filterByRating(double minRating) {
    final nutritionists = state.valueOrNull?.nutritionists ?? [];
    return nutritionists.where((n) => (n.rating ?? 0) >= minRating).toList();
  }

  /// 按价格范围筛选营养师
  List<Unutritionist> filterByPriceRange(double minPrice, double maxPrice) {
    final nutritionists = state.valueOrNull?.nutritionists ?? [];
    return nutritionists.where((n) {
      final price = n.consultationPrice ?? 0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  /// 获取推荐营养师（基于评分和咨询数）
  List<Unutritionist> getRecommended({int limit = 5}) {
    final nutritionists = List<Unutritionist>.from(state.valueOrNull?.nutritionists ?? []);
    nutritionists.sort((a, b) {
      final scoreA = (a.rating ?? 0) * (a.consultationCount ?? 0);
      final scoreB = (b.rating ?? 0) * (b.consultationCount ?? 0);
      return scoreB.compareTo(scoreA);
    });
    return nutritionists.take(limit).toList();
  }

  /// 选择营养师
  void selectNutritionist(Unutritionist? nutritionist) {
    state = state.whenData((data) => data.copyWith(selectedNutritionist: nutritionist));
  }

  /// 清除选中的营养师
  void clearSelection() {
    selectNutritionist(null);
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }
}

/// UseCase Provider
@riverpod
GetUnutritionistsUseCase getNutritionistsUseCase(GetNutritionistsUseCaseRef ref) {
  final repository = ref.watch(nutritionistRepositoryProvider);
  return GetUnutritionistsUseCase(repository);
}

/// Repository Provider (需要在DI中配置)
final nutritionistRepositoryProvider = Provider<UnutritionistRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});

// ===== 便捷访问器 =====

/// 营养师列表
@riverpod
List<Unutritionist> nutritionistList(NutritionistListRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.nutritionists ?? [];
}

/// 是否正在加载
@riverpod
bool nutritionistIsLoading(NutritionistIsLoadingRef ref) {
  return ref.watch(nutritionistControllerProvider).isLoading;
}

/// 错误信息
@riverpod
String? nutritionistError(NutritionistErrorRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.error;
}

/// 选中的营养师
@riverpod
Unutritionist? selectedNutritionist(SelectedNutritionistRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.selectedNutritionist;
}

/// 在线营养师列表
@riverpod
List<Unutritionist> onlineNutritionists(OnlineNutritionistsRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.onlineNutritionists ?? [];
}

/// 认证营养师列表
@riverpod
List<Unutritionist> verifiedNutritionists(VerifiedNutritionistsRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.verifiedNutritionists ?? [];
}

/// 营养师专业领域列表
@riverpod
List<String> nutritionistSpecialties(NutritionistSpecialtiesRef ref) {
  return ref.watch(nutritionistControllerProvider).valueOrNull?.specialties ?? [];
}

/// 推荐营养师列表
@riverpod
List<Unutritionist> recommendedNutritionists(RecommendedNutritionistsRef ref) {
  final controller = ref.watch(nutritionistControllerProvider.notifier);
  return controller.getRecommended();
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final nutritionistProvider = Provider<AsyncValue<NutritionistState>>((ref) {
  return ref.watch(nutritionistControllerProvider);
});