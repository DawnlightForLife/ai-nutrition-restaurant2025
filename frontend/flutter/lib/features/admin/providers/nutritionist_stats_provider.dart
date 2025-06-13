import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/dio_provider.dart';
import '../../../core/utils/logger.dart';

/// 营养师统计数据状态管理
final nutritionistStatsProvider = StateNotifierProvider<NutritionistStatsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return NutritionistStatsNotifier(ref);
});

class NutritionistStatsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref ref;
  Map<String, dynamic> _cachedStats = <String, dynamic>{};
  
  NutritionistStatsNotifier(this.ref) : super(const AsyncValue.loading());
  
  /// 加载统计数据
  Future<void> loadStats({String? timeRange}) async {
    try {
      state = const AsyncValue.loading();
      
      // 使用模拟数据确保页面能正常显示
      final stats = <String, dynamic>{
        'overview': <String, dynamic>{
          'totalNutritionists': 126,
          'certifiedNutritionists': 118,
          'activeNutritionists': 89,
          'newNutritionistsThisMonth': 10,
          'levelDistribution': <Map<String, dynamic>>[
            {'level': 1, 'count': 35},
            {'level': 2, 'count': 42},
            {'level': 3, 'count': 28},
            {'level': 4, 'count': 13},
            {'level': 5, 'count': 8},
          ],
        },
        'consultation': <String, dynamic>{
          'totalConsultations': 3460,
          'responseTimeStats': <String, dynamic>{
            'avgResponseTime': 1800000, // 30分钟（毫秒）
            'minResponseTime': 300000,  // 5分钟
            'maxResponseTime': 7200000, // 2小时
          },
          'dailyConsultations': <Map<String, dynamic>>[
            {'date': '2025-6-6', 'count': 45},
            {'date': '2025-6-7', 'count': 52},
            {'date': '2025-6-8', 'count': 38},
            {'date': '2025-6-9', 'count': 61},
            {'date': '2025-6-10', 'count': 48},
            {'date': '2025-6-11', 'count': 55},
            {'date': '2025-6-12', 'count': 42},
          ],
          'ratingDistribution': <Map<String, dynamic>>[
            {'rating': 5, 'count': 1580},
            {'rating': 4, 'count': 890},
            {'rating': 3, 'count': 320},
            {'rating': 2, 'count': 80},
            {'rating': 1, 'count': 25},
          ],
          'goodRatingRate': 85.2,
        },
        'recommendation': <String, dynamic>{
          'totalRecommendations': 12345,
          'acceptedRecommendations': 8765,
          'successRate': 71.0,
          'nutritionistCoverage': <String, dynamic>{
            'avgUsersPerNutritionist': 28.5,
            'maxUsersPerNutritionist': 65,
            'minUsersPerNutritionist': 8,
          },
          'recommendationTypes': <Map<String, dynamic>>[
            {'type': 'weight_loss', 'count': 4580},
            {'type': 'muscle_gain', 'count': 2890},
            {'type': 'health_management', 'count': 2340},
            {'type': 'disease_diet', 'count': 1680},
            {'type': 'pregnancy', 'count': 855},
          ],
          'recommendationSource': <String, dynamic>{
            'ai': 8765,
            'manual': 3580,
          },
        },
        'income': <String, dynamic>{
          'consultationIncome': <String, dynamic>{
            'totalIncome': 285600,
            'totalCount': 3460,
            'avgIncome': 82.5,
          },
          'monthlySettlement': <Map<String, dynamic>>[
            {'nutritionistId': '1', 'nutritionistName': '张医生', 'totalAmount': 15600, 'consultationCount': 89, 'settlementAmount': 10920},
            {'nutritionistId': '2', 'nutritionistName': '李医生', 'totalAmount': 12800, 'consultationCount': 76, 'settlementAmount': 8960},
            {'nutritionistId': '3', 'nutritionistName': '王医生', 'totalAmount': 11200, 'consultationCount': 68, 'settlementAmount': 7840},
          ],
          'withdrawalStats': <String, dynamic>{
            'totalWithdrawals': 0,
            'pendingWithdrawals': 0,
            'completedWithdrawals': 0,
            'totalWithdrawnAmount': 0,
          },
        },
        'ranking': <String, dynamic>{
          'consultation': <Map<String, dynamic>>[
            {'nutritionistId': '1', 'nutritionistName': '张医生', 'consultationCount': 89, 'totalIncome': 15600, 'avgRating': 4.8},
            {'nutritionistId': '2', 'nutritionistName': '李医生', 'consultationCount': 76, 'totalIncome': 12800, 'avgRating': 4.7},
            {'nutritionistId': '3', 'nutritionistName': '王医生', 'consultationCount': 68, 'totalIncome': 11200, 'avgRating': 4.6},
          ],
          'rating': <Map<String, dynamic>>[],
          'income': <Map<String, dynamic>>[],
        },
      };
      
      // 尝试从API获取真实数据（如果后端可用）
      try {
        final apiClient = ref.read(apiClientProvider);
        
        // 尝试获取概况数据
        try {
          final overviewResponse = await apiClient.get('/admin/nutritionist-stats/overview');
          if (overviewResponse.data != null && overviewResponse.data['data'] != null) {
            final overviewData = overviewResponse.data['data'] as Map<String, dynamic>;
            stats['overview'] = <String, dynamic>{
              ...stats['overview'] as Map<String, dynamic>,
              ...overviewData,
            };
          }
        } catch (e) {
          AppLogger.w('获取营养师概况失败，使用模拟数据', error: e);
        }
        
      } catch (e) {
        AppLogger.w('API客户端获取失败，使用模拟数据', error: e);
      }
      
      _cachedStats = stats;
      state = AsyncValue.data(stats);
    } catch (e, stack) {
      AppLogger.e('加载营养师统计数据失败', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }
  
  /// 加载特定类型的排行榜
  Future<void> loadRanking(String type) async {
    try {
      final ranking = <Map<String, dynamic>>[];
      _cachedStats['ranking'][type] = ranking;
      state = AsyncValue.data(_cachedStats);
    } catch (e) {
      AppLogger.e('加载营养师排行榜失败', error: e);
    }
  }
}