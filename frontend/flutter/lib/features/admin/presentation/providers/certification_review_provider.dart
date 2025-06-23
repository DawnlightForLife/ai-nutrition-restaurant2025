import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../data/services/certification_review_service.dart';

part 'certification_review_provider.freezed.dart';
part 'certification_review_provider.g.dart';

/// 认证申请筛选参数
@freezed
class CertificationFilterParams with _$CertificationFilterParams {
  const factory CertificationFilterParams({
    @Default('pending') String status,
    String? certificationLevel,
    String? specialization,
    String? searchQuery,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _CertificationFilterParams;
}

/// 认证申请模型
@freezed
class CertificationApplication with _$CertificationApplication {
  const factory CertificationApplication({
    required String id,
    required String nutritionistId,
    required String nutritionistName,
    String? nutritionistAvatar,
    required String certificationLevel,
    required List<String> specializations,
    required String status,
    required DateTime submittedAt,
    DateTime? reviewedAt,
    String? reviewerId,
    String? reviewerName,
    String? reviewNotes,
    @Default('normal') String priority,
    Map<String, dynamic>? documents,
    Map<String, dynamic>? educationInfo,
    Map<String, dynamic>? experienceInfo,
  }) = _CertificationApplication;

  factory CertificationApplication.fromJson(Map<String, dynamic> json) =>
      _$CertificationApplicationFromJson(json);
}

/// 认证申请列表Provider
final certificationApplicationsProvider = FutureProvider.autoDispose
    .family<List<CertificationApplication>, CertificationFilterParams>(
  (ref, params) async {
    final service = ref.watch(certificationReviewServiceProvider);
    return service.getApplications(params);
  },
);

/// 认证申请详情Provider
final certificationApplicationDetailProvider = FutureProvider.autoDispose
    .family<CertificationApplication, String>(
  (ref, applicationId) async {
    final service = ref.watch(certificationReviewServiceProvider);
    return service.getApplicationDetail(applicationId);
  },
);

/// 认证统计Provider
final certificationStatisticsProvider = FutureProvider.autoDispose<Map<String, dynamic>>(
  (ref) async {
    final service = ref.watch(certificationReviewServiceProvider);
    return service.getStatistics();
  },
);

/// 审核申请StateNotifier
class ReviewApplicationNotifier extends StateNotifier<AsyncValue<void>> {
  final CertificationReviewService _service;

  ReviewApplicationNotifier(this._service) : super(const AsyncValue.data(null));

  Future<void> reviewApplication({
    required String applicationId,
    required String decision,
    required String reviewNotes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.reviewApplication(
        applicationId: applicationId,
        decision: decision,
        reviewNotes: reviewNotes,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> batchReview({
    required List<String> applicationIds,
    required String decision,
    required String reviewNotes,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.batchReview(
        applicationIds: applicationIds,
        decision: decision,
        reviewNotes: reviewNotes,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updatePriority({
    required String applicationId,
    required String priority,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.updateApplicationPriority(
        applicationId: applicationId,
        priority: priority,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> assignReviewer({
    required String applicationId,
    required String reviewerId,
  }) async {
    state = const AsyncValue.loading();
    try {
      await _service.assignReviewer(
        applicationId: applicationId,
        reviewerId: reviewerId,
      );
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

/// 审核申请Provider
final reviewApplicationProvider =
    StateNotifierProvider.autoDispose<ReviewApplicationNotifier, AsyncValue<void>>(
  (ref) {
    final service = ref.watch(certificationReviewServiceProvider);
    return ReviewApplicationNotifier(service);
  },
);

/// 审核历史Provider
final reviewHistoryProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
  (ref, applicationId) async {
    final service = ref.watch(certificationReviewServiceProvider);
    return service.getReviewHistory(applicationId);
  },
);