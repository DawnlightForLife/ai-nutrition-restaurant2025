import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/usecases/get_merchants_usecase.dart';
import '../../../../core/base/use_case.dart';

part 'merchant_controller.freezed.dart';
part 'merchant_controller.g.dart';

/// Merchant 状态类
@freezed
class MerchantState with _$MerchantState {
  const factory MerchantState({
    @Default([]) List<Umerchant> merchants,
    @Default(false) bool isLoading,
    String? error,
    Umerchant? selectedMerchant,
    @Default({}) Map<String, List<Umerchant>> merchantsByCategory,
  }) = _MerchantState;

  const MerchantState._();

  /// 是否处于初始状态
  bool get isInitial => merchants.isEmpty && !isLoading && error == null;

  /// 是否已加载数据
  bool get hasData => merchants.isNotEmpty;

  /// 获取所有分类
  List<String> get categories => merchantsByCategory.keys.toList();
}

/// Merchant 控制器
@riverpod
class MerchantController extends _$MerchantController {
  late final GetUmerchantsUseCase _getMerchantsUseCase;

  @override
  FutureOr<MerchantState> build() {
    _getMerchantsUseCase = ref.watch(getMerchantsUseCaseProvider);
    return const MerchantState();
  }

  /// 加载商家列表
  Future<void> loadMerchants() async {
    state = const AsyncValue.loading();

    final result = await _getMerchantsUseCase(NoParams());

    state = result.fold(
      (failure) => AsyncValue.data(
        MerchantState(error: failure.message),
      ),
      (merchants) {
        final merchantsByCategory = _groupByCategory(merchants);
        return AsyncValue.data(
          MerchantState(
            merchants: merchants,
            merchantsByCategory: merchantsByCategory,
          ),
        );
      },
    );
  }

  /// 按分类分组商家
  Map<String, List<Umerchant>> _groupByCategory(List<Umerchant> merchants) {
    final grouped = <String, List<Umerchant>>{};
    for (final merchant in merchants) {
      final category = merchant.category ?? '其他';
      grouped.putIfAbsent(category, () => []).add(merchant);
    }
    return grouped;
  }

  /// 刷新商家列表
  Future<void> refresh() async {
    await loadMerchants();
  }

  /// 根据ID获取商家
  Umerchant? getMerchantById(String id) {
    return state.valueOrNull?.merchants.firstWhere(
      (merchant) => merchant.id == id,
      orElse: () => throw Exception('Merchant not found'),
    );
  }

  /// 搜索商家
  List<Umerchant> searchMerchants(String query) {
    final merchants = state.valueOrNull?.merchants ?? [];
    if (query.isEmpty) return merchants;

    return merchants.where((merchant) {
      final nameMatch = merchant.name.toLowerCase().contains(query.toLowerCase());
      final descriptionMatch = merchant.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
      return nameMatch || descriptionMatch;
    }).toList();
  }

  /// 按分类筛选商家
  List<Umerchant> filterByCategory(String category) {
    return state.valueOrNull?.merchantsByCategory[category] ?? [];
  }

  /// 按评分筛选商家
  List<Umerchant> filterByRating(double minRating) {
    final merchants = state.valueOrNull?.merchants ?? [];
    return merchants.where((merchant) => (merchant.rating ?? 0) >= minRating).toList();
  }

  /// 按距离排序商家（需要位置信息）
  List<Umerchant> sortByDistance(double userLat, double userLng) {
    final merchants = List<Umerchant>.from(state.valueOrNull?.merchants ?? []);
    // TODO: 实现距离计算和排序逻辑
    return merchants;
  }

  /// 选择商家
  void selectMerchant(Umerchant? merchant) {
    state = state.whenData((data) => data.copyWith(selectedMerchant: merchant));
  }

  /// 清除选中的商家
  void clearSelection() {
    selectMerchant(null);
  }

  /// 清除错误
  void clearError() {
    state = state.whenData((data) => data.copyWith(error: null));
  }
}

/// UseCase Provider
@riverpod
GetUmerchantsUseCase getMerchantsUseCase(GetMerchantsUseCaseRef ref) {
  final repository = ref.watch(merchantRepositoryProvider);
  return GetUmerchantsUseCase(repository);
}

/// Repository Provider (需要在DI中配置)
final merchantRepositoryProvider = Provider<UmerchantRepository>((ref) {
  throw UnimplementedError('请在DI配置中实现此Provider');
});

// ===== 便捷访问器 =====

/// 商家列表
@riverpod
List<Umerchant> merchantList(MerchantListRef ref) {
  return ref.watch(merchantControllerProvider).valueOrNull?.merchants ?? [];
}

/// 是否正在加载
@riverpod
bool merchantIsLoading(MerchantIsLoadingRef ref) {
  return ref.watch(merchantControllerProvider).isLoading;
}

/// 错误信息
@riverpod
String? merchantError(MerchantErrorRef ref) {
  return ref.watch(merchantControllerProvider).valueOrNull?.error;
}

/// 选中的商家
@riverpod
Umerchant? selectedMerchant(SelectedMerchantRef ref) {
  return ref.watch(merchantControllerProvider).valueOrNull?.selectedMerchant;
}

/// 商家分类列表
@riverpod
List<String> merchantCategories(MerchantCategoriesRef ref) {
  return ref.watch(merchantControllerProvider).valueOrNull?.categories ?? [];
}

/// 按分类获取商家
@riverpod
List<Umerchant> merchantsByCategory(MerchantsByCategoryRef ref, String category) {
  return ref.watch(merchantControllerProvider).valueOrNull?.merchantsByCategory[category] ?? [];
}

// ===== 兼容旧接口 =====

/// 旧的 Provider 兼容层
final merchantProvider = Provider<AsyncValue<MerchantState>>((ref) {
  return ref.watch(merchantControllerProvider);
});