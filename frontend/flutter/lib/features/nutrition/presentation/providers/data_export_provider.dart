import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/models/export_config_model.dart';
import '../../domain/services/data_export_service.dart';

/// 导出状态
class ExportState {
  final bool isExporting;
  final double? progress;
  final String? currentStep;
  final ExportResult? lastResult;
  final String? error;

  const ExportState({
    this.isExporting = false,
    this.progress,
    this.currentStep,
    this.lastResult,
    this.error,
  });

  ExportState copyWith({
    bool? isExporting,
    double? progress,
    String? currentStep,
    ExportResult? lastResult,
    String? error,
  }) {
    return ExportState(
      isExporting: isExporting ?? this.isExporting,
      progress: progress ?? this.progress,
      currentStep: currentStep ?? this.currentStep,
      lastResult: lastResult ?? this.lastResult,
      error: error ?? this.error,
    );
  }
}

/// 导出状态管理器
class DataExportNotifier extends StateNotifier<ExportState> {
  DataExportNotifier() : super(const ExportState());

  /// 导出单个档案
  Future<void> exportProfile(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) async {
    state = state.copyWith(
      isExporting: true,
      progress: 0.0,
      currentStep: '准备导出数据...',
      error: null,
    );

    try {
      // 模拟进度更新
      await _updateProgress(0.2, '验证档案数据...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _updateProgress(0.4, '生成导出内容...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _updateProgress(0.7, '创建${config.format.displayName}文件...');
      
      // 执行实际导出
      final result = await DataExportService.exportProfile(profile, config);
      
      await _updateProgress(1.0, '导出完成');
      
      state = state.copyWith(
        isExporting: false,
        progress: null,
        currentStep: null,
        lastResult: result,
        error: result.isSuccess ? null : result.error,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        progress: null,
        currentStep: null,
        error: e.toString(),
      );
    }
  }

  /// 批量导出档案
  Future<void> exportProfiles(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    state = state.copyWith(
      isExporting: true,
      progress: 0.0,
      currentStep: '准备导出${profiles.length}个档案...',
      error: null,
    );

    try {
      // 验证数据
      await _updateProgress(0.1, '验证档案数据...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      // 处理每个档案
      for (int i = 0; i < profiles.length; i++) {
        final progress = 0.1 + (0.7 * (i + 1) / profiles.length);
        await _updateProgress(
          progress, 
          '处理档案 ${i + 1}/${profiles.length}: ${profiles[i].profileName}',
        );
        await Future.delayed(const Duration(milliseconds: 200));
      }
      
      await _updateProgress(0.8, '合并数据...');
      await Future.delayed(const Duration(milliseconds: 300));
      
      await _updateProgress(0.9, '生成${config.format.displayName}文件...');
      
      // 执行实际导出
      final result = await DataExportService.exportProfiles(profiles, config);
      
      await _updateProgress(1.0, '导出完成');
      
      state = state.copyWith(
        isExporting: false,
        progress: null,
        currentStep: null,
        lastResult: result,
        error: result.isSuccess ? null : result.error,
      );
    } catch (e) {
      state = state.copyWith(
        isExporting: false,
        progress: null,
        currentStep: null,
        error: e.toString(),
      );
    }
  }

  /// 分享导出文件
  Future<void> shareLastExport() async {
    final lastResult = state.lastResult;
    if (lastResult != null && lastResult.isSuccess) {
      try {
        await DataExportService.shareExportedFile(lastResult);
      } catch (e) {
        state = state.copyWith(error: '分享失败: ${e.toString()}');
      }
    }
  }

  /// 清除状态
  void clearState() {
    state = const ExportState();
  }

  /// 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// 更新进度
  Future<void> _updateProgress(double progress, String step) async {
    state = state.copyWith(
      progress: progress,
      currentStep: step,
    );
  }
}

/// 导出状态Provider
final dataExportProvider = StateNotifierProvider<DataExportNotifier, ExportState>(
  (ref) => DataExportNotifier(),
);

/// 导出历史记录Provider
final exportHistoryProvider = StateProvider<List<ExportResult>>((ref) => []);

/// 添加导出记录到历史
void addExportToHistory(WidgetRef ref, ExportResult result) {
  if (result.isSuccess) {
    final history = ref.read(exportHistoryProvider);
    final newHistory = [result, ...history];
    // 只保留最近10条记录
    if (newHistory.length > 10) {
      newHistory.removeRange(10, newHistory.length);
    }
    ref.read(exportHistoryProvider.notifier).state = newHistory;
  }
}

/// 获取导出统计信息
final exportStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final history = ref.watch(exportHistoryProvider);
  
  final stats = <String, dynamic>{
    'total_exports': history.length,
    'total_file_size': history.fold<int>(
      0, 
      (sum, result) => sum + (result.fileSize ?? 0),
    ),
    'format_counts': <String, int>{},
    'last_export_date': history.isNotEmpty 
        ? DateTime.now().toIso8601String() 
        : null,
  };
  
  // 统计各格式的使用次数
  for (final result in history) {
    if (result.fileName != null) {
      final extension = result.fileName!.split('.').last.toLowerCase();
      stats['format_counts'][extension] = 
          (stats['format_counts'][extension] ?? 0) + 1;
    }
  }
  
  return stats;
});

/// 常用导出配置Provider
final favoriteExportConfigsProvider = StateProvider<List<ExportConfig>>((ref) {
  return [
    ExportConfig.defaultConfig(ExportFormat.pdf),
    ExportConfig.complete(ExportFormat.excel),
    ExportConfig.minimal(ExportFormat.json),
  ];
});

/// 添加收藏配置
void addFavoriteConfig(WidgetRef ref, ExportConfig config) {
  final favorites = ref.read(favoriteExportConfigsProvider);
  if (!favorites.any((c) => c == config)) {
    ref.read(favoriteExportConfigsProvider.notifier).state = [
      config,
      ...favorites,
    ];
  }
}

/// 移除收藏配置
void removeFavoriteConfig(WidgetRef ref, ExportConfig config) {
  final favorites = ref.read(favoriteExportConfigsProvider);
  ref.read(favoriteExportConfigsProvider.notifier).state = 
      favorites.where((c) => c != config).toList();
}