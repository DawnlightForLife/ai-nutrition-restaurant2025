import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/client_service.dart';
import '../../domain/models/client_models.dart';

/// 客户列表Provider
final clientListProvider = FutureProvider.autoDispose.family<List<NutritionistClient>, ClientListParams>((ref, params) async {
  final service = ref.watch(clientServiceProvider);
  return service.getClients(
    search: params.search,
    tag: params.tag,
    sortBy: params.sortBy,
    page: params.page,
    limit: params.limit,
  );
});

/// 客户详情Provider
final clientDetailProvider = FutureProvider.autoDispose.family<ClientDetail, String>((ref, clientId) async {
  final service = ref.watch(clientServiceProvider);
  return service.getClientDetail(clientId);
});

/// 客户统计Provider
final clientStatsProvider = FutureProvider.autoDispose.family<ClientStats, String>((ref, clientId) async {
  final service = ref.watch(clientServiceProvider);
  return service.getClientStats(clientId);
});

/// 潜在客户搜索Provider
final potentialClientsProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, keyword) async {
  if (keyword.isEmpty) return [];
  final service = ref.watch(clientServiceProvider);
  return service.searchPotentialClients(keyword);
});

/// 添加客户StateNotifier
class AddClientNotifier extends StateNotifier<AsyncValue<NutritionistClient?>> {
  final ClientService _service;

  AddClientNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> addClient({
    required String nickname,
    int? age,
    String? gender,
    HealthOverview? healthOverview,
    List<String>? tags,
    String? notes,
  }) async {
    state = const AsyncValue.loading();
    try {
      final client = await _service.addClient(
        nickname: nickname,
        age: age,
        gender: gender,
        healthOverview: healthOverview,
        tags: tags,
        notes: notes,
      );
      state = AsyncValue.data(client);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 添加客户Provider
final addClientProvider = StateNotifierProvider.autoDispose<AddClientNotifier, AsyncValue<NutritionistClient?>>((ref) {
  final service = ref.watch(clientServiceProvider);
  return AddClientNotifier(service);
});

/// 更新客户StateNotifier
class UpdateClientNotifier extends StateNotifier<AsyncValue<NutritionistClient?>> {
  final ClientService _service;

  UpdateClientNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> updateClient(
    String clientId, {
    String? nickname,
    int? age,
    String? gender,
    HealthOverview? healthOverview,
    List<String>? tags,
    String? notes,
    bool? isActive,
  }) async {
    state = const AsyncValue.loading();
    try {
      final client = await _service.updateClient(
        clientId,
        nickname: nickname,
        age: age,
        gender: gender,
        healthOverview: healthOverview,
        tags: tags,
        notes: notes,
        isActive: isActive,
      );
      state = AsyncValue.data(client);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 更新客户Provider
final updateClientProvider = StateNotifierProvider.autoDispose<UpdateClientNotifier, AsyncValue<NutritionistClient?>>((ref) {
  final service = ref.watch(clientServiceProvider);
  return UpdateClientNotifier(service);
});

/// 进展更新StateNotifier
class ProgressUpdateNotifier extends StateNotifier<AsyncValue<void>> {
  final ClientService _service;

  ProgressUpdateNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> updateProgress(String clientId, ProgressUpdateParams params) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateProgress(clientId, params);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 进展更新Provider
final progressUpdateProvider = StateNotifierProvider.autoDispose<ProgressUpdateNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(clientServiceProvider);
  return ProgressUpdateNotifier(service);
});

/// 目标管理StateNotifier
class GoalManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ClientService _service;

  GoalManagementNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> addGoal(
    String clientId, {
    required String type,
    required String description,
    double? targetValue,
    DateTime? targetDate,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.addGoal(
        clientId,
        type: type,
        description: description,
        targetValue: targetValue,
        targetDate: targetDate,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateGoal(
    String clientId,
    String goalId, {
    double? currentValue,
    String? status,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateGoal(
        clientId,
        goalId,
        currentValue: currentValue,
        status: status,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 目标管理Provider
final goalManagementProvider = StateNotifierProvider.autoDispose<GoalManagementNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(clientServiceProvider);
  return GoalManagementNotifier(service);
});

/// 提醒管理StateNotifier
class ReminderManagementNotifier extends StateNotifier<AsyncValue<void>> {
  final ClientService _service;

  ReminderManagementNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> addReminder(
    String clientId, {
    required String type,
    required String title,
    String? description,
    required DateTime reminderDate,
    bool? isRecurring,
    String? recurringPattern,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.addReminder(
        clientId,
        type: type,
        title: title,
        description: description,
        reminderDate: reminderDate,
        isRecurring: isRecurring,
        recurringPattern: recurringPattern,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> completeReminder(String clientId, String reminderId) async {
    state = const AsyncValue.loading();
    try {
      await _service.completeReminder(clientId, reminderId);
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 提醒管理Provider
final reminderManagementProvider = StateNotifierProvider.autoDispose<ReminderManagementNotifier, AsyncValue<void>>((ref) {
  final service = ref.watch(clientServiceProvider);
  return ReminderManagementNotifier(service);
});