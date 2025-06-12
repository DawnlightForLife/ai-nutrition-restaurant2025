import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../data/services/merchant_application_service.dart';

/// 商家申请状态
class MerchantApplicationState {
  final bool isLoading;
  final String? error;
  final bool isSubmitted;
  final List<Map<String, dynamic>> userApplications;
  final bool hasLoadedApplications;

  const MerchantApplicationState({
    this.isLoading = false,
    this.error,
    this.isSubmitted = false,
    this.userApplications = const [],
    this.hasLoadedApplications = false,
  });

  MerchantApplicationState copyWith({
    bool? isLoading,
    String? error,
    bool? isSubmitted,
    List<Map<String, dynamic>>? userApplications,
    bool? hasLoadedApplications,
  }) {
    return MerchantApplicationState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSubmitted: isSubmitted ?? this.isSubmitted,
      userApplications: userApplications ?? this.userApplications,
      hasLoadedApplications: hasLoadedApplications ?? this.hasLoadedApplications,
    );
  }
}

/// 商家申请服务Provider
final merchantApplicationServiceProvider = Provider<MerchantApplicationService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MerchantApplicationService(apiClient);
});

/// 商家申请状态管理
class MerchantApplicationNotifier extends StateNotifier<MerchantApplicationState> {
  final MerchantApplicationService _service;

  MerchantApplicationNotifier(this._service) : super(const MerchantApplicationState());

  /// 提交商家申请
  Future<bool> submitApplication(Map<String, dynamic> applicationData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 检查是否有被拒绝的申请需要更新
      final rejectedApplication = state.userApplications.firstWhere(
        (app) => app['verification']?['verificationStatus'] == 'rejected',
        orElse: () => {},
      );
      
      if (rejectedApplication.isNotEmpty && rejectedApplication['id'] != null) {
        // 如果有被拒绝的申请，使用更新API
        await _service.updateApplication(rejectedApplication['id'], applicationData);
      } else {
        // 否则创建新申请
        await _service.submitApplication(applicationData);
      }
      
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
      );
      
      // 申请成功后立即刷新用户申请记录
      await refreshUserApplications();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 获取用户申请记录
  Future<void> loadUserApplications() async {
    // 如果已经加载过，不再重复加载
    if (state.hasLoadedApplications) {
      return;
    }

    await _loadApplications();
  }

  /// 强制刷新用户申请记录
  Future<void> refreshUserApplications() async {
    print('MerchantApplicationProvider: 开始刷新用户申请记录...');
    
    // 重置状态，清除缓存
    state = state.copyWith(
      hasLoadedApplications: false,
      userApplications: [],
      error: null,
    );
    
    await _loadApplications();
    print('MerchantApplicationProvider: 刷新完成，当前申请数量: ${state.userApplications.length}');
    if (state.userApplications.isNotEmpty) {
      final latestApp = state.userApplications.first;
      final status = latestApp['verification']?['verificationStatus'];
      print('MerchantApplicationProvider: 最新申请状态: $status');
    }
  }

  /// 内部方法：加载申请记录
  Future<void> _loadApplications() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final applications = await _service.getUserApplications();
      print('Provider: 获取到申请数据，数量: ${applications.length}');
      if (applications.isNotEmpty) {
        final latestStatus = applications.first['verification']?['verificationStatus'];
        print('Provider: 最新申请状态: $latestStatus');
      }
      
      state = state.copyWith(
        isLoading: false,
        userApplications: applications,
        hasLoadedApplications: true,
      );
      
      print('Provider: 状态已更新，当前状态包含 ${state.userApplications.length} 个申请');
    } catch (e) {
      print('Provider: 加载申请失败: $e');
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        hasLoadedApplications: true,
      );
    }
  }

  /// 更新被拒绝的申请
  Future<bool> updateRejectedApplication(String applicationId, Map<String, dynamic> updateData) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.updateApplication(applicationId, updateData);
      state = state.copyWith(
        isLoading: false,
        isSubmitted: true,
      );
      
      // 更新成功后立即刷新用户申请记录
      await refreshUserApplications();
      
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  /// 重置状态
  void reset() {
    state = const MerchantApplicationState();
  }
}

/// 商家申请Provider
final merchantApplicationProvider = 
    StateNotifierProvider<MerchantApplicationNotifier, MerchantApplicationState>((ref) {
  final service = ref.watch(merchantApplicationServiceProvider);
  return MerchantApplicationNotifier(service);
});