import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/workbench_service.dart';
import '../../domain/models/workbench_models.dart';

/// 工作台统计数据Provider
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((ref) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getDashboardStats();
});

/// 待办任务Provider
final workbenchTasksProvider = FutureProvider.autoDispose<List<WorkbenchTask>>((ref) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getTasks();
});

/// 咨询列表Provider
final workbenchConsultationsProvider = FutureProvider.autoDispose.family<List<WorkbenchConsultation>, String?>((ref, status) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getConsultations(status: status);
});

/// 快捷操作Provider
final quickActionsProvider = FutureProvider.autoDispose<List<QuickAction>>((ref) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getQuickActions();
});

/// 排班表Provider
final scheduleProvider = FutureProvider.autoDispose.family<Schedule, ScheduleParams>((ref, params) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getSchedule(
    startDate: params.startDate,
    endDate: params.endDate,
  );
});

/// 收入明细Provider
final incomeDetailsProvider = FutureProvider.autoDispose.family<IncomeDetails, IncomeParams>((ref, params) async {
  final service = ref.watch(workbenchServiceProvider);
  return service.getIncomeDetails(
    startDate: params.startDate,
    endDate: params.endDate,
    page: params.page,
    limit: params.limit,
  );
});

/// 咨询操作StateNotifier
class ConsultationActionsNotifier extends StateNotifier<AsyncValue<void>> {
  final WorkbenchService _service;

  ConsultationActionsNotifier(this._service) : super(const AsyncValue.data(null));

  /// 接受咨询
  Future<void> acceptConsultation(String consultationId) async {
    state = const AsyncValue.loading();
    try {
      await _service.acceptConsultation(consultationId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 拒绝咨询
  Future<void> rejectConsultation(String consultationId, String? reason) async {
    state = const AsyncValue.loading();
    try {
      await _service.rejectConsultation(consultationId, reason);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 完成咨询
  Future<void> completeConsultation(String consultationId, String? summary) async {
    state = const AsyncValue.loading();
    try {
      await _service.completeConsultation(consultationId, summary);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 咨询操作Provider
final consultationActionsProvider = StateNotifierProvider.autoDispose<ConsultationActionsNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(workbenchServiceProvider);
  return ConsultationActionsNotifier(service);
});

/// 批量消息StateNotifier
class BatchMessageNotifier extends StateNotifier<AsyncValue<BatchMessageResult?>> {
  final WorkbenchService _service;

  BatchMessageNotifier(this._service) : super(const AsyncValue.data(null));

  /// 发送批量消息
  Future<void> sendBatchMessage({
    required List<String> clientIds,
    required String message,
    String type = 'notification',
  }) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.sendBatchMessage(
        clientIds: clientIds,
        message: message,
        type: type,
      );
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 批量消息Provider
final batchMessageProvider = StateNotifierProvider.autoDispose<BatchMessageNotifier, AsyncValue<BatchMessageResult?>>((ref) {
  final service = ref.watch(workbenchServiceProvider);
  return BatchMessageNotifier(service);
});

/// 排班参数
class ScheduleParams {
  final DateTime? startDate;
  final DateTime? endDate;

  ScheduleParams({this.startDate, this.endDate});
}

/// 收入参数
class IncomeParams {
  final DateTime? startDate;
  final DateTime? endDate;
  final int page;
  final int limit;

  IncomeParams({
    this.startDate,
    this.endDate,
    this.page = 1,
    this.limit = 20,
  });
}

/// 在线状态管理StateNotifier
class OnlineStatusNotifier extends StateNotifier<AsyncValue<OnlineStatusResult?>> {
  final WorkbenchService _service;

  OnlineStatusNotifier(this._service) : super(const AsyncValue.data(null));

  /// 切换在线状态
  Future<void> toggleOnlineStatus() async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.toggleOnlineStatus();
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// 更新可用状态
  Future<void> updateAvailability(bool isAvailable) async {
    state = const AsyncValue.loading();
    try {
      final result = await _service.updateAvailability(isAvailable: isAvailable);
      state = AsyncValue.data(result);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 在线状态Provider
final onlineStatusProvider = StateNotifierProvider.autoDispose<OnlineStatusNotifier, AsyncValue<OnlineStatusResult?>>((ref) {
  final service = ref.watch(workbenchServiceProvider);
  return OnlineStatusNotifier(service);
});