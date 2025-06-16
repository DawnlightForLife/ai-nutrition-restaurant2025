import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 加载状态
class LoadingState {
  final bool isLoading;
  final String? message;
  final double? progress;
  final String? operation;
  
  const LoadingState({
    this.isLoading = false,
    this.message,
    this.progress,
    this.operation,
  });
  
  LoadingState copyWith({
    bool? isLoading,
    String? message,
    double? progress,
    String? operation,
  }) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      progress: progress,
      operation: operation,
    );
  }
  
  /// 创建加载状态
  factory LoadingState.loading({
    String? message,
    double? progress,
    String? operation,
  }) {
    return LoadingState(
      isLoading: true,
      message: message,
      progress: progress,
      operation: operation,
    );
  }
  
  /// 创建空闲状态
  factory LoadingState.idle() {
    return const LoadingState(isLoading: false);
  }
}

/// 加载状态管理器
class LoadingStateNotifier extends StateNotifier<LoadingState> {
  LoadingStateNotifier() : super(LoadingState.idle());
  
  /// 开始加载
  void startLoading({
    String? message,
    double? progress,
    String? operation,
  }) {
    state = LoadingState.loading(
      message: message,
      progress: progress,
      operation: operation,
    );
  }
  
  /// 更新加载进度
  void updateProgress({
    double? progress,
    String? message,
  }) {
    if (state.isLoading) {
      state = state.copyWith(
        progress: progress,
        message: message,
      );
    }
  }
  
  /// 停止加载
  void stopLoading() {
    state = LoadingState.idle();
  }
  
  /// 设置操作消息
  void setMessage(String message) {
    if (state.isLoading) {
      state = state.copyWith(message: message);
    }
  }
}

/// 全局加载状态提供者
final loadingStateProvider = StateNotifierProvider<LoadingStateNotifier, LoadingState>((ref) {
  return LoadingStateNotifier();
});

/// 特定操作的加载状态提供者
final operationLoadingProvider = StateNotifierProvider.family<LoadingStateNotifier, LoadingState, String>((ref, operation) {
  return LoadingStateNotifier();
});

/// 加载状态管理扩展
extension LoadingStateProviderExtension on WidgetRef {
  /// 开始全局加载
  void startGlobalLoading({
    String? message,
    double? progress,
    String? operation,
  }) {
    read(loadingStateProvider.notifier).startLoading(
      message: message,
      progress: progress,
      operation: operation,
    );
  }
  
  /// 停止全局加载
  void stopGlobalLoading() {
    read(loadingStateProvider.notifier).stopLoading();
  }
  
  /// 开始特定操作加载
  void startOperationLoading(
    String operation, {
    String? message,
    double? progress,
  }) {
    read(operationLoadingProvider(operation).notifier).startLoading(
      message: message,
      progress: progress,
      operation: operation,
    );
  }
  
  /// 停止特定操作加载
  void stopOperationLoading(String operation) {
    read(operationLoadingProvider(operation).notifier).stopLoading();
  }
  
  /// 执行带加载状态的操作
  Future<T> executeWithLoading<T>(
    Future<T> Function() operation, {
    String? message,
    String? operationName,
    bool useGlobal = true,
  }) async {
    try {
      if (useGlobal) {
        startGlobalLoading(message: message, operation: operationName);
      } else if (operationName != null) {
        startOperationLoading(operationName, message: message);
      }
      
      return await operation();
    } finally {
      if (useGlobal) {
        stopGlobalLoading();
      } else if (operationName != null) {
        stopOperationLoading(operationName);
      }
    }
  }
}

/// 预定义的操作类型
class LoadingOperations {
  static const String createProfile = 'create_profile';
  static const String updateProfile = 'update_profile';
  static const String deleteProfile = 'delete_profile';
  static const String cloneProfile = 'clone_profile';
  static const String loadProfiles = 'load_profiles';
  static const String generateAIRecommendation = 'generate_ai_recommendation';
  static const String saveRecommendation = 'save_recommendation';
  static const String updateProgress = 'update_progress';
  static const String uploadFile = 'upload_file';
  static const String exportData = 'export_data';
}

/// 加载消息配置
class LoadingMessages {
  static const Map<String, String> messages = {
    LoadingOperations.createProfile: '正在创建档案...',
    LoadingOperations.updateProfile: '正在更新档案...',
    LoadingOperations.deleteProfile: '正在删除档案...',
    LoadingOperations.cloneProfile: '正在克隆档案...',
    LoadingOperations.loadProfiles: '正在加载档案列表...',
    LoadingOperations.generateAIRecommendation: '正在生成AI推荐...',
    LoadingOperations.saveRecommendation: '正在保存推荐...',
    LoadingOperations.updateProgress: '正在更新进度...',
    LoadingOperations.uploadFile: '正在上传文件...',
    LoadingOperations.exportData: '正在导出数据...',
  };
  
  static String getMessage(String operation) {
    return messages[operation] ?? '处理中...';
  }
}