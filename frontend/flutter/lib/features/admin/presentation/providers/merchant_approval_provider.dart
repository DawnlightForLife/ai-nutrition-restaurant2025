import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../../../core/utils/logger.dart';
import '../../data/services/admin_merchant_service.dart';
import '../../data/models/merchant_model.dart';

/// 管理员商家服务Provider
final adminMerchantServiceProvider = Provider<AdminMerchantService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AdminMerchantService(apiClient);
});

/// 商家审批状态
class MerchantApprovalState {
  final bool isLoading;
  final List<MerchantModel> pendingMerchants;
  final List<MerchantModel> approvedMerchants;
  final List<MerchantModel> rejectedMerchants;
  final String? error;
  final int currentPage;
  final bool hasMore;

  const MerchantApprovalState({
    this.isLoading = false,
    this.pendingMerchants = const [],
    this.approvedMerchants = const [],
    this.rejectedMerchants = const [],
    this.error,
    this.currentPage = 1,
    this.hasMore = true,
  });

  MerchantApprovalState copyWith({
    bool? isLoading,
    List<MerchantModel>? pendingMerchants,
    List<MerchantModel>? approvedMerchants,
    List<MerchantModel>? rejectedMerchants,
    String? error,
    int? currentPage,
    bool? hasMore,
  }) {
    return MerchantApprovalState(
      isLoading: isLoading ?? this.isLoading,
      pendingMerchants: pendingMerchants ?? this.pendingMerchants,
      approvedMerchants: approvedMerchants ?? this.approvedMerchants,
      rejectedMerchants: rejectedMerchants ?? this.rejectedMerchants,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

/// 商家审批状态管理
class MerchantApprovalNotifier extends StateNotifier<MerchantApprovalState> {
  final AdminMerchantService _service;

  MerchantApprovalNotifier(this._service) : super(const MerchantApprovalState()) {
    loadMerchants();
  }

  /// 加载商家列表
  Future<void> loadMerchants({bool refresh = false}) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      currentPage: refresh ? 1 : state.currentPage,
    );

    try {
      // 并行加载三种状态的商家
      final results = await Future.wait([
        _service.getMerchants(verificationStatus: 'pending', page: state.currentPage),
        _service.getMerchants(verificationStatus: 'approved', page: state.currentPage),
        _service.getMerchants(verificationStatus: 'rejected', page: state.currentPage),
      ]);

      final pendingData = results[0];
      final approvedData = results[1];
      final rejectedData = results[2];

      // 解析数据 - 先用原始Map避免序列化问题
      final pendingList = <MerchantModel>[];
      final approvedList = <MerchantModel>[];
      final rejectedList = <MerchantModel>[];
      
      try {
        // 安全解析pending数据
        for (final item in (pendingData['data'] as List)) {
          try {
            final merchant = MerchantModel.fromJson(item as Map<String, dynamic>);
            pendingList.add(merchant);
          } catch (e) {
            AppLogger.error('解析pending商家数据失败: $e', error: e);
            // 创建最小化的商家数据
            final safeItem = item as Map<String, dynamic>;
            final merchant = MerchantModel(
              id: safeItem['id'] as String,
              businessName: safeItem['businessName'] as String?,
              businessType: safeItem['businessType'] as String?,
            );
            pendingList.add(merchant);
          }
        }
        
        // 安全解析approved数据
        for (final item in (approvedData['data'] as List)) {
          try {
            final merchant = MerchantModel.fromJson(item as Map<String, dynamic>);
            approvedList.add(merchant);
          } catch (e) {
            AppLogger.error('解析approved商家数据失败: $e', error: e);
            final safeItem = item as Map<String, dynamic>;
            final merchant = MerchantModel(
              id: safeItem['id'] as String,
              businessName: safeItem['businessName'] as String?,
              businessType: safeItem['businessType'] as String?,
            );
            approvedList.add(merchant);
          }
        }
        
        // 安全解析rejected数据
        for (final item in (rejectedData['data'] as List)) {
          try {
            final merchant = MerchantModel.fromJson(item as Map<String, dynamic>);
            rejectedList.add(merchant);
          } catch (e) {
            AppLogger.error('解析rejected商家数据失败: $e', error: e);
            final safeItem = item as Map<String, dynamic>;
            final merchant = MerchantModel(
              id: safeItem['id'] as String,
              businessName: safeItem['businessName'] as String?,
              businessType: safeItem['businessType'] as String?,
            );
            rejectedList.add(merchant);
          }
        }
      } catch (e) {
        AppLogger.error('解析商家数据失败: $e', error: e);
      }

      state = state.copyWith(
        isLoading: false,
        pendingMerchants: refresh 
            ? pendingList 
            : [...state.pendingMerchants, ...pendingList],
        approvedMerchants: refresh 
            ? approvedList 
            : [...state.approvedMerchants, ...approvedList],
        rejectedMerchants: refresh 
            ? rejectedList 
            : [...state.rejectedMerchants, ...rejectedList],
        hasMore: pendingList.length >= 10 || approvedList.length >= 10 || rejectedList.length >= 10,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 刷新列表
  Future<void> refresh() async {
    await loadMerchants(refresh: true);
  }

  /// 加载更多
  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    
    state = state.copyWith(currentPage: state.currentPage + 1);
    await loadMerchants();
  }

  /// 审批商家
  Future<bool> verifyMerchant(
    String merchantId, {
    required String status,
    String? rejectionReason,
  }) async {
    try {
      await _service.verifyMerchant(
        merchantId,
        verificationStatus: status,
        rejectionReason: rejectionReason,
      );

      // 更新本地状态
      if (status == 'approved') {
        // 从待审核移到已通过
        final merchant = state.pendingMerchants.firstWhere((m) => m.id == merchantId);
        final updatedVerification = merchant.verification?.copyWith(
          isVerified: true,
          verificationStatus: 'approved',
          verifiedAt: DateTime.now(),
        ) ?? VerificationInfo(
          isVerified: true,
          verificationStatus: 'approved',
          verifiedAt: DateTime.now(),
        );
        
        state = state.copyWith(
          pendingMerchants: state.pendingMerchants.where((m) => m.id != merchantId).toList(),
          approvedMerchants: [
            merchant.copyWith(verification: updatedVerification),
            ...state.approvedMerchants,
          ],
        );
      } else if (status == 'rejected') {
        // 从待审核移到已拒绝
        final merchant = state.pendingMerchants.firstWhere((m) => m.id == merchantId);
        final updatedVerification = merchant.verification?.copyWith(
          isVerified: false,
          verificationStatus: 'rejected',
          verifiedAt: DateTime.now(),
          rejectionReason: rejectionReason,
        ) ?? VerificationInfo(
          isVerified: false,
          verificationStatus: 'rejected',
          verifiedAt: DateTime.now(),
          rejectionReason: rejectionReason,
        );
        
        state = state.copyWith(
          pendingMerchants: state.pendingMerchants.where((m) => m.id != merchantId).toList(),
          rejectedMerchants: [
            merchant.copyWith(verification: updatedVerification),
            ...state.rejectedMerchants,
          ],
        );
      }

      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

/// 商家审批Provider
final merchantApprovalProvider = 
    StateNotifierProvider<MerchantApprovalNotifier, MerchantApprovalState>((ref) {
  final service = ref.watch(adminMerchantServiceProvider);
  return MerchantApprovalNotifier(service);
});