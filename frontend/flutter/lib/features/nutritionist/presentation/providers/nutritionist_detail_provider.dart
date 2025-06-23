import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist.dart';
import '../../providers/nutritionist_providers.dart';

part 'nutritionist_detail_provider.freezed.dart';

/// 营养师详情状态
@freezed
class NutritionistDetailState with _$NutritionistDetailState {
  const factory NutritionistDetailState.initial() = _Initial;
  const factory NutritionistDetailState.loading() = _Loading;
  const factory NutritionistDetailState.loaded(Nutritionist nutritionist) = _Loaded;
  const factory NutritionistDetailState.error(String message) = _Error;
}

/// 营养师详情Provider
final nutritionistDetailProvider = StateNotifierProvider.family<
  NutritionistDetailNotifier,
  NutritionistDetailState,
  String
>((ref, nutritionistId) {
  return NutritionistDetailNotifier(ref, nutritionistId);
});

/// 营养师详情Notifier
class NutritionistDetailNotifier extends StateNotifier<NutritionistDetailState> {
  final Ref _ref;
  final String _nutritionistId;

  NutritionistDetailNotifier(this._ref, this._nutritionistId)
      : super(const NutritionistDetailState.initial());

  /// 加载营养师详情
  Future<void> loadNutritionistDetail() async {
    state = const NutritionistDetailState.loading();

    try {
      // 首先尝试通过API获取详情
      final repository = _ref.read(nutritionistRepositoryProvider);
      final result = await repository.getNutritionistById(_nutritionistId);
      
      final success = result.fold(
        (failure) => false,
        (nutritionist) {
          state = NutritionistDetailState.loaded(nutritionist);
          return true;
        },
      );
      
      if (!success) {
        // API失败，尝试从列表中获取
        await _loadFromList();
      }
      
    } catch (e) {
      // 发生异常，尝试从列表中获取
      await _loadFromList();
    }
  }
  
  Future<void> _loadFromList() async {
    try {
      // 从列表中查找营养师
      final listState = _ref.read(nutritionistListProvider);
      
      Nutritionist? nutritionist;
      
      // 如果列表已加载，从中查找
      listState.whenOrNull(
        loaded: (nutritionists) {
          nutritionist = nutritionists.firstWhere(
            (n) => n.id == _nutritionistId,
            orElse: () => throw Exception('营养师不存在'),
          );
        },
      );

      // 如果列表未加载，先加载列表
      if (nutritionist == null) {
        await _ref.read(nutritionistListProvider.notifier).loadNutritionists();
        
        final updatedListState = _ref.read(nutritionistListProvider);
        updatedListState.whenOrNull(
          loaded: (nutritionists) {
            nutritionist = nutritionists.firstWhere(
              (n) => n.id == _nutritionistId,
              orElse: () => throw Exception('营养师不存在'),
            );
          },
        );
      }

      if (nutritionist != null) {
        state = NutritionistDetailState.loaded(nutritionist!);
      } else {
        state = const NutritionistDetailState.error('营养师不存在');
      }
    } catch (e) {
      state = NutritionistDetailState.error('加载营养师详情失败：$e');
    }
  }

  /// 刷新营养师详情
  Future<void> refresh() async {
    await loadNutritionistDetail();
  }
}