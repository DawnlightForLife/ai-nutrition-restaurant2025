import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/services/nutritionist_management_service.dart';
import '../../domain/entities/nutritionist_management_entity.dart';
import '../../../../core/services/performance/performance_monitor_service.dart';

part 'nutritionist_management_provider.freezed.dart';

@freezed
class NutritionistManagementState with _$NutritionistManagementState {
  const factory NutritionistManagementState({
    @Default([]) List<NutritionistManagementEntity> nutritionists,
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingMore,
    @Default(1) int currentPage,
    @Default(1) int totalPages,
    @Default(0) int totalRecords,
    @Default(20) int pageSize,
    String? error,
    String? searchQuery,
    String? statusFilter,
    String? verificationStatusFilter,
    String? specializationFilter,
    @Default('createdAt') String sortBy,
    @Default('desc') String sortOrder,
    @Default({}) Set<String> selectedNutritionists,
    @Default(false) bool isPerformingBatchOperation,
    NutritionistManagementOverview? overview,
  }) = _NutritionistManagementState;
}

class NutritionistManagementNotifier
    extends StateNotifier<NutritionistManagementState> {
  final NutritionistManagementService _service;

  NutritionistManagementNotifier(this._service)
      : super(const NutritionistManagementState());

  // 加载营养师列表
  Future<void> loadNutritionists({
    bool refresh = false,
    int? page,
  }) async {
    if (refresh) {
      state = state.copyWith(
        isLoading: true,
        error: null,
        currentPage: 1,
        nutritionists: [],
      );
    } else if (page != null && page > 1) {
      state = state.copyWith(isLoadingMore: true);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final result = await monitorPerformance(
        'load_nutritionists',
        () => _service.getNutritionists(
          page: page ?? state.currentPage,
          limit: state.pageSize,
          status: state.statusFilter,
          verificationStatus: state.verificationStatusFilter,
          specialization: state.specializationFilter,
          search: state.searchQuery,
          sortBy: state.sortBy,
          sortOrder: state.sortOrder,
        ),
        metadata: {
          'page': page ?? state.currentPage,
          'refresh': refresh,
          'filters': {
            'status': state.statusFilter,
            'verificationStatus': state.verificationStatusFilter,
            'specialization': state.specializationFilter,
            'search': state.searchQuery,
          },
        },
      );

      final newNutritionists = page != null && page > 1
          ? [...state.nutritionists, ...result.nutritionists]
          : result.nutritionists;

      state = state.copyWith(
        nutritionists: newNutritionists,
        currentPage: result.pagination.current,
        totalPages: result.pagination.total,
        totalRecords: result.pagination.totalRecords,
        isLoading: false,
        isLoadingMore: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }

  // 搜索营养师
  Future<void> searchNutritionists(String query) async {
    state = state.copyWith(searchQuery: query);
    await loadNutritionists(refresh: true);
  }

  // 设置筛选条件
  void setStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
    loadNutritionists(refresh: true);
  }

  void setVerificationStatusFilter(String? verificationStatus) {
    state = state.copyWith(verificationStatusFilter: verificationStatus);
    loadNutritionists(refresh: true);
  }

  void setSpecializationFilter(String? specialization) {
    state = state.copyWith(specializationFilter: specialization);
    loadNutritionists(refresh: true);
  }

  // 设置排序方式
  void setSorting(String sortBy, String sortOrder) {
    state = state.copyWith(sortBy: sortBy, sortOrder: sortOrder);
    loadNutritionists(refresh: true);
  }

  // 清除所有筛选条件
  void clearFilters() {
    state = state.copyWith(
      searchQuery: null,
      statusFilter: null,
      verificationStatusFilter: null,
      specializationFilter: null,
      sortBy: 'createdAt',
      sortOrder: 'desc',
    );
    loadNutritionists(refresh: true);
  }

  // 选择/取消选择营养师
  void toggleNutritionistSelection(String nutritionistId) {
    final selectedSet = Set<String>.from(state.selectedNutritionists);
    if (selectedSet.contains(nutritionistId)) {
      selectedSet.remove(nutritionistId);
    } else {
      selectedSet.add(nutritionistId);
    }
    state = state.copyWith(selectedNutritionists: selectedSet);
  }

  // 全选/取消全选当前页面的营养师
  void toggleSelectAll() {
    final currentPageIds = state.nutritionists.map((n) => n.id).toSet();
    final isAllSelected = currentPageIds.every(
      (id) => state.selectedNutritionists.contains(id),
    );

    Set<String> newSelected;
    if (isAllSelected) {
      // 取消全选：移除当前页面的所有ID
      newSelected = Set<String>.from(state.selectedNutritionists)
        ..removeAll(currentPageIds);
    } else {
      // 全选：添加当前页面的所有ID
      newSelected = Set<String>.from(state.selectedNutritionists)
        ..addAll(currentPageIds);
    }

    state = state.copyWith(selectedNutritionists: newSelected);
  }

  // 清除选择
  void clearSelection() {
    state = state.copyWith(selectedNutritionists: {});
  }

  // 更新营养师状态
  Future<bool> updateNutritionistStatus(
    String nutritionistId,
    String status, {
    String? reason,
  }) async {
    try {
      await _service.updateNutritionistStatus(nutritionistId, status, reason);
      
      // 更新本地状态
      final updatedNutritionists = state.nutritionists.map((n) {
        if (n.id == nutritionistId) {
          return n.copyWith(status: status);
        }
        return n;
      }).toList();

      state = state.copyWith(nutritionists: updatedNutritionists);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // 批量更新营养师状态
  Future<bool> batchUpdateStatus(
    List<String> nutritionistIds,
    String status, {
    String? reason,
  }) async {
    state = state.copyWith(isPerformingBatchOperation: true);

    try {
      final result = await _service.batchUpdateNutritionists(
        nutritionistIds,
        'updateStatus',
        {'status': status, 'reason': reason},
      );

      // 更新本地状态
      final updatedNutritionists = state.nutritionists.map((n) {
        if (nutritionistIds.contains(n.id)) {
          return n.copyWith(status: status);
        }
        return n;
      }).toList();

      state = state.copyWith(
        nutritionists: updatedNutritionists,
        isPerformingBatchOperation: false,
        selectedNutritionists: {},
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isPerformingBatchOperation: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 批量设置营养师离线
  Future<bool> batchSetOffline(List<String> nutritionistIds) async {
    state = state.copyWith(isPerformingBatchOperation: true);

    try {
      await _service.batchUpdateNutritionists(
        nutritionistIds,
        'setOffline',
        {},
      );

      // 更新本地状态
      final updatedNutritionists = state.nutritionists.map((n) {
        if (nutritionistIds.contains(n.id)) {
          return n.copyWith(isOnline: false);
        }
        return n;
      }).toList();

      state = state.copyWith(
        nutritionists: updatedNutritionists,
        isPerformingBatchOperation: false,
        selectedNutritionists: {},
      );

      return true;
    } catch (e) {
      state = state.copyWith(
        isPerformingBatchOperation: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // 加载管理概览数据
  Future<void> loadOverview() async {
    try {
      final overview = await _service.getManagementOverview();
      state = state.copyWith(overview: overview);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  // 导出营养师数据
  Future<bool> exportNutritionists({
    String format = 'csv',
    List<String>? selectedIds,
  }) async {
    try {
      await _service.exportNutritionists(
        format: format,
        status: state.statusFilter,
        verificationStatus: state.verificationStatusFilter,
      );
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // 加载更多数据
  Future<void> loadMore() async {
    if (state.currentPage < state.totalPages && !state.isLoadingMore) {
      await loadNutritionists(page: state.currentPage + 1);
    }
  }

  // 快速搜索营养师
  Future<List<NutritionistQuickSearchResult>> quickSearch(String query) async {
    try {
      return await _service.searchNutritionists(query);
    } catch (e) {
      return [];
    }
  }

  // 获取营养师详情
  Future<NutritionistDetailEntity?> getNutritionistDetail(
      String nutritionistId) async {
    try {
      return await _service.getNutritionistDetail(nutritionistId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }
}

// Provider实例
final nutritionistManagementProvider = StateNotifierProvider<
    NutritionistManagementNotifier, NutritionistManagementState>(
  (ref) => NutritionistManagementNotifier(
    ref.watch(nutritionistManagementServiceProvider),
  ),
);

// 营养师管理服务Provider
final nutritionistManagementServiceProvider =
    Provider<NutritionistManagementService>(
  (ref) => NutritionistManagementService(),
);

// 筛选状态Provider
final nutritionistFiltersProvider =
    StateProvider<NutritionistFilters>((ref) => const NutritionistFilters());

@freezed
class NutritionistFilters with _$NutritionistFilters {
  const factory NutritionistFilters({
    String? status,
    String? verificationStatus,
    String? specialization,
    @Default('createdAt') String sortBy,
    @Default('desc') String sortOrder,
  }) = _NutritionistFilters;
}