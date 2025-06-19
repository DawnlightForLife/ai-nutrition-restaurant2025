import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/inventory_entity.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../data/models/inventory_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';

// Repository provider
final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return InventoryRepositoryImpl(apiClient);
});

// Inventory list provider
final inventoryListProvider = StateNotifierProvider.family<InventoryListNotifier, AsyncValue<List<InventoryEntity>>, String>(
  (ref, merchantId) => InventoryListNotifier(ref.watch(inventoryRepositoryProvider), merchantId),
);

// Single inventory provider
final inventoryProvider = StateNotifierProvider.family<InventoryNotifier, AsyncValue<InventoryEntity?>, String>(
  (ref, inventoryId) => InventoryNotifier(ref.watch(inventoryRepositoryProvider), inventoryId),
);

// Inventory alerts provider
final inventoryAlertsProvider = StateNotifierProvider.family<InventoryAlertsNotifier, AsyncValue<List<InventoryAlert>>, String>(
  (ref, merchantId) => InventoryAlertsNotifier(ref.watch(inventoryRepositoryProvider), merchantId),
);

// Inventory form provider
final inventoryFormProvider = StateNotifierProvider<InventoryFormNotifier, InventoryFormState>(
  (ref) => InventoryFormNotifier(ref.watch(inventoryRepositoryProvider)),
);

// Stock operation provider
final stockOperationProvider = StateNotifierProvider<StockOperationNotifier, StockOperationState>(
  (ref) => StockOperationNotifier(ref.watch(inventoryRepositoryProvider)),
);

class InventoryListNotifier extends StateNotifier<AsyncValue<List<InventoryEntity>>> {
  final InventoryRepository _repository;
  final String merchantId;

  InventoryListNotifier(this._repository, this.merchantId) : super(const AsyncValue.loading()) {
    loadInventories();
  }

  Future<void> loadInventories() async {
    state = const AsyncValue.loading();
    final result = await _repository.getInventoryList(merchantId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (inventories) => state = AsyncValue.data(inventories),
    );
  }

  Future<void> refreshInventories() async {
    await loadInventories();
  }

  Future<bool> removeExpiredStock(String inventoryId) async {
    final result = await _repository.removeExpiredStock(inventoryId);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedInventory) {
        // Update inventory in current state
        state.whenData((inventories) {
          final updatedInventories = inventories.map((inv) => 
            inv.id == inventoryId ? updatedInventory : inv
          ).toList();
          state = AsyncValue.data(updatedInventories);
        });
        return true;
      },
    );
  }
}

class InventoryNotifier extends StateNotifier<AsyncValue<InventoryEntity?>> {
  final InventoryRepository _repository;
  final String inventoryId;

  InventoryNotifier(this._repository, this.inventoryId) : super(const AsyncValue.loading()) {
    loadInventory();
  }

  Future<void> loadInventory() async {
    state = const AsyncValue.loading();
    final result = await _repository.getInventoryById(inventoryId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (inventory) => state = AsyncValue.data(inventory),
    );
  }

  Future<void> refreshInventory() async {
    await loadInventory();
  }
}

class InventoryAlertsNotifier extends StateNotifier<AsyncValue<List<InventoryAlert>>> {
  final InventoryRepository _repository;
  final String merchantId;

  InventoryAlertsNotifier(this._repository, this.merchantId) : super(const AsyncValue.loading()) {
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    state = const AsyncValue.loading();
    final result = await _repository.getInventoryAlerts(merchantId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (alerts) => state = AsyncValue.data(alerts),
    );
  }

  Future<void> refreshAlerts() async {
    await loadAlerts();
  }
}

class InventoryFormNotifier extends StateNotifier<InventoryFormState> {
  final InventoryRepository _repository;

  InventoryFormNotifier(this._repository) : super(const InventoryFormState());

  void updateForm({
    String? name,
    String? unit,
    String? category,
    double? minThreshold,
    AlertSettings? alertSettings,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      unit: unit ?? state.unit,
      category: category ?? state.category,
      minThreshold: minThreshold ?? state.minThreshold,
      alertSettings: alertSettings ?? state.alertSettings,
    );
  }

  void resetForm() {
    state = const InventoryFormState();
  }

  Future<Either<Failure, InventoryEntity>> submitForm() async {
    if (!state.isValid) {
      return Left(ValidationFailure('表单数据无效'));
    }

    state = state.copyWith(isSubmitting: true);

    final request = InventoryCreateRequest(
      name: state.name,
      unit: state.unit,
      category: state.category,
      minThreshold: state.minThreshold,
      alertSettings: AlertSettingsModel(
        lowStockAlert: state.alertSettings.lowStockAlert,
        expiryAlert: state.alertSettings.expiryAlert,
        qualityAlert: state.alertSettings.qualityAlert,
        expiryWarningDays: state.alertSettings.expiryWarningDays,
        lowStockRatio: state.alertSettings.lowStockRatio,
      ),
    );

    final result = await _repository.createInventory(request);

    state = state.copyWith(isSubmitting: false);
    return result;
  }
}

class StockOperationNotifier extends StateNotifier<StockOperationState> {
  final InventoryRepository _repository;

  StockOperationNotifier(this._repository) : super(const StockOperationState());

  Future<Either<Failure, InventoryEntity>> addStock(
    String inventoryId,
    StockAddRequest request,
  ) async {
    state = state.copyWith(isProcessing: true, operationType: 'add');

    final result = await _repository.addStock(inventoryId, request);

    state = state.copyWith(isProcessing: false);
    return result;
  }

  Future<Either<Failure, InventoryEntity>> consumeStock(
    String inventoryId,
    StockConsumeRequest request,
  ) async {
    state = state.copyWith(isProcessing: true, operationType: 'consume');

    final result = await _repository.consumeStock(inventoryId, request);

    state = state.copyWith(isProcessing: false);
    return result;
  }

  void clearOperation() {
    state = const StockOperationState();
  }
}

// State classes
class InventoryFormState {
  final String name;
  final String unit;
  final String category;
  final double minThreshold;
  final AlertSettings alertSettings;
  final bool isSubmitting;

  const InventoryFormState({
    this.name = '',
    this.unit = 'kg',
    this.category = 'ingredient',
    this.minThreshold = 0.0,
    this.alertSettings = const AlertSettings(),
    this.isSubmitting = false,
  });

  bool get isValid => name.isNotEmpty && unit.isNotEmpty && minThreshold >= 0;

  InventoryFormState copyWith({
    String? name,
    String? unit,
    String? category,
    double? minThreshold,
    AlertSettings? alertSettings,
    bool? isSubmitting,
  }) {
    return InventoryFormState(
      name: name ?? this.name,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      minThreshold: minThreshold ?? this.minThreshold,
      alertSettings: alertSettings ?? this.alertSettings,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class StockOperationState {
  final bool isProcessing;
  final String operationType;
  final String? error;

  const StockOperationState({
    this.isProcessing = false,
    this.operationType = '',
    this.error,
  });

  StockOperationState copyWith({
    bool? isProcessing,
    String? operationType,
    String? error,
  }) {
    return StockOperationState(
      isProcessing: isProcessing ?? this.isProcessing,
      operationType: operationType ?? this.operationType,
      error: error ?? this.error,
    );
  }
}