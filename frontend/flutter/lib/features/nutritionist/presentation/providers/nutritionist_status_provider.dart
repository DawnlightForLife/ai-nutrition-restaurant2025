import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/services/websocket/nutritionist_status_websocket_service.dart';

part 'nutritionist_status_provider.freezed.dart';

@freezed
class NutritionistOnlineStatus with _$NutritionistOnlineStatus {
  const factory NutritionistOnlineStatus({
    @Default(false) bool isOnline,
    @Default(false) bool isAvailable,
    String? statusMessage,
    @Default([]) List<String> availableConsultationTypes,
    DateTime? lastActiveAt,
    @Default(NutritionistConnectionStatus.disconnected) NutritionistConnectionStatus connectionStatus,
  }) = _NutritionistOnlineStatus;
}

@freezed
class NutritionistStatusState with _$NutritionistStatusState {
  const factory NutritionistStatusState({
    @Default({}) Map<String, NutritionistOnlineStatus> nutritionistStatuses,
    NutritionistOnlineStatus? myStatus,
    @Default(false) bool isLoading,
    String? error,
    @Default([]) List<String> subscribedNutritionists,
  }) = _NutritionistStatusState;
}

class NutritionistStatusNotifier extends StateNotifier<NutritionistStatusState> {
  final NutritionistStatusWebSocketService _webSocketService;
  
  NutritionistStatusNotifier(this._webSocketService) : super(const NutritionistStatusState()) {
    _initializeListeners();
  }

  void _initializeListeners() {
    // 监听连接状态变化
    _webSocketService.connectionStatus.listen((connectionStatus) {
      if (state.myStatus != null) {
        state = state.copyWith(
          myStatus: state.myStatus!.copyWith(connectionStatus: connectionStatus),
        );
      }
    });

    // 监听状态更新
    _webSocketService.statusUpdates.listen((statusUpdate) {
      _handleStatusUpdate(statusUpdate);
    });

    // 监听错误
    _webSocketService.errors.listen((error) {
      state = state.copyWith(error: error['message'] as String?);
    });
  }

  void _handleStatusUpdate(NutritionistStatusUpdate update) {
    final updatedStatus = NutritionistOnlineStatus(
      isOnline: update.isOnline,
      isAvailable: update.isAvailable,
      statusMessage: update.statusMessage,
      availableConsultationTypes: update.availableConsultationTypes ?? [],
      lastActiveAt: update.lastActiveAt,
      connectionStatus: state.nutritionistStatuses[update.nutritionistId]?.connectionStatus ??
          NutritionistConnectionStatus.connected,
    );

    // 更新营养师状态映射
    final updatedStatuses = Map<String, NutritionistOnlineStatus>.from(state.nutritionistStatuses);
    updatedStatuses[update.nutritionistId] = updatedStatus;

    state = state.copyWith(
      nutritionistStatuses: updatedStatuses,
      // 如果是当前用户的状态更新，也更新myStatus
      myStatus: _isMyStatus(update.nutritionistId) ? updatedStatus : state.myStatus,
    );
  }

  bool _isMyStatus(String nutritionistId) {
    // 这里需要从认证状态获取当前用户的nutritionistId
    // 暂时简单实现，后续可以通过ref.read(authProvider)获取
    return state.myStatus != null;
  }

  // 营养师上线
  Future<void> goOnline({
    String? statusMessage,
    List<String>? availableConsultationTypes,
  }) async {
    if (!_webSocketService.isConnected) {
      state = state.copyWith(error: 'WebSocket未连接');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _webSocketService.goOnline(
        statusMessage: statusMessage,
        availableConsultationTypes: availableConsultationTypes,
      );

      // 更新本地状态
      state = state.copyWith(
        myStatus: const NutritionistOnlineStatus().copyWith(
          isOnline: true,
          isAvailable: true,
          statusMessage: statusMessage,
          availableConsultationTypes: availableConsultationTypes ?? [],
          lastActiveAt: DateTime.now(),
          connectionStatus: _webSocketService.currentStatus,
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '上线失败: ${e.toString()}',
      );
    }
  }

  // 营养师下线
  Future<void> goOffline() async {
    if (!_webSocketService.isConnected) {
      state = state.copyWith(error: 'WebSocket未连接');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _webSocketService.goOffline();

      // 更新本地状态
      state = state.copyWith(
        myStatus: state.myStatus?.copyWith(
          isOnline: false,
          isAvailable: false,
          lastActiveAt: DateTime.now(),
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '下线失败: ${e.toString()}',
      );
    }
  }

  // 更新状态
  Future<void> updateStatus({
    required bool isAvailable,
    String? statusMessage,
    List<String>? availableConsultationTypes,
  }) async {
    if (!_webSocketService.isConnected) {
      state = state.copyWith(error: 'WebSocket未连接');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      
      await _webSocketService.updateStatus(
        isAvailable: isAvailable,
        statusMessage: statusMessage,
        availableConsultationTypes: availableConsultationTypes,
      );

      // 更新本地状态
      state = state.copyWith(
        myStatus: state.myStatus?.copyWith(
          isAvailable: isAvailable,
          statusMessage: statusMessage,
          availableConsultationTypes: availableConsultationTypes ?? state.myStatus?.availableConsultationTypes ?? [],
          lastActiveAt: DateTime.now(),
        ),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '状态更新失败: ${e.toString()}',
      );
    }
  }

  // 订阅营养师状态
  void subscribeToNutritionistStatus(List<String> nutritionistIds) {
    if (!_webSocketService.isConnected) {
      state = state.copyWith(error: 'WebSocket未连接');
      return;
    }

    _webSocketService.subscribeToNutritionistStatus(nutritionistIds);
    
    // 更新订阅列表
    final subscribedSet = Set<String>.from(state.subscribedNutritionists)
      ..addAll(nutritionistIds);
    
    state = state.copyWith(
      subscribedNutritionists: subscribedSet.toList(),
    );
  }

  // 取消订阅营养师状态
  void unsubscribeFromNutritionistStatus(List<String> nutritionistIds) {
    if (!_webSocketService.isConnected) {
      return;
    }

    _webSocketService.unsubscribeFromNutritionistStatus(nutritionistIds);
    
    // 更新订阅列表
    final subscribedSet = Set<String>.from(state.subscribedNutritionists)
      ..removeAll(nutritionistIds);
    
    state = state.copyWith(
      subscribedNutritionists: subscribedSet.toList(),
    );

    // 清理已取消订阅的营养师状态
    final updatedStatuses = Map<String, NutritionistOnlineStatus>.from(state.nutritionistStatuses);
    for (final nutritionistId in nutritionistIds) {
      updatedStatuses.remove(nutritionistId);
    }
    
    state = state.copyWith(nutritionistStatuses: updatedStatuses);
  }

  // 获取特定营养师的状态
  NutritionistOnlineStatus? getNutritionistStatus(String nutritionistId) {
    return state.nutritionistStatuses[nutritionistId];
  }

  // 获取在线营养师数量
  int get onlineNutritionistsCount {
    return state.nutritionistStatuses.values
        .where((status) => status.isOnline)
        .length;
  }

  // 获取可用营养师数量
  int get availableNutritionistsCount {
    return state.nutritionistStatuses.values
        .where((status) => status.isOnline && status.isAvailable)
        .length;
  }

  // 清除错误
  void clearError() {
    state = state.copyWith(error: null);
  }

  // 初始化当前用户状态
  void initializeMyStatus({
    required bool isOnline,
    required bool isAvailable,
    String? statusMessage,
    List<String>? availableConsultationTypes,
  }) {
    state = state.copyWith(
      myStatus: NutritionistOnlineStatus(
        isOnline: isOnline,
        isAvailable: isAvailable,
        statusMessage: statusMessage,
        availableConsultationTypes: availableConsultationTypes ?? [],
        lastActiveAt: DateTime.now(),
        connectionStatus: _webSocketService.currentStatus,
      ),
    );
  }

  // 检查是否已订阅特定营养师
  bool isSubscribedTo(String nutritionistId) {
    return state.subscribedNutritionists.contains(nutritionistId);
  }
}

// Provider实例
final nutritionistStatusProvider = StateNotifierProvider<NutritionistStatusNotifier, NutritionistStatusState>((ref) {
  final webSocketService = ref.watch(nutritionistStatusWebSocketServiceProvider);
  return NutritionistStatusNotifier(webSocketService);
});

// 获取当前用户状态的便捷Provider
final myNutritionistStatusProvider = Provider<NutritionistOnlineStatus?>((ref) {
  final state = ref.watch(nutritionistStatusProvider);
  return state.myStatus;
});

// 获取连接状态的便捷Provider
final nutritionistConnectionStatusProvider = Provider<NutritionistConnectionStatus>((ref) {
  final state = ref.watch(nutritionistStatusProvider);
  return state.myStatus?.connectionStatus ?? NutritionistConnectionStatus.disconnected;
});

// 获取在线营养师数量的Provider
final onlineNutritionistsCountProvider = Provider<int>((ref) {
  final notifier = ref.watch(nutritionistStatusProvider.notifier);
  return notifier.onlineNutritionistsCount;
});

// 获取可用营养师数量的Provider
final availableNutritionistsCountProvider = Provider<int>((ref) {
  final notifier = ref.watch(nutritionistStatusProvider.notifier);
  return notifier.availableNutritionistsCount;
});

// 特定营养师状态的Provider工厂
Provider<NutritionistOnlineStatus?> nutritionistStatusByIdProvider(String nutritionistId) {
  return Provider<NutritionistOnlineStatus?>((ref) {
    final state = ref.watch(nutritionistStatusProvider);
    return state.nutritionistStatuses[nutritionistId];
  });
}