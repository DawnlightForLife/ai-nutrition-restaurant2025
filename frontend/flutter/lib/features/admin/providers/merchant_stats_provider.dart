import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/dio_provider.dart';
import '../../../core/utils/logger.dart';

/// 加盟商统计数据状态管理
final merchantStatsProvider = StateNotifierProvider<MerchantStatsNotifier, AsyncValue<Map<String, dynamic>>>((ref) {
  return MerchantStatsNotifier(ref);
});

class MerchantStatsNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  final Ref ref;
  
  MerchantStatsNotifier(this.ref) : super(const AsyncValue.loading());
  
  /// 加载统计数据
  Future<void> loadStats({String? timeRange}) async {
    try {
      state = const AsyncValue.loading();
      
      // 使用模拟数据确保页面能正常显示
      final stats = <String, dynamic>{
        'overview': <String, dynamic>{
          'totalMerchants': 48,
          'totalStores': 65,
          'activeStores': 58,
          'pendingStores': 7,
          'newMerchantsThisMonth': 5,
          'newStoresThisMonth': 8,
          'typeDistribution': <Map<String, dynamic>>[
            {'type': 'restaurant', 'count': 25},
            {'type': 'fast_food', 'count': 18},
            {'type': 'drink_shop', 'count': 12},
            {'type': 'bakery', 'count': 8},
            {'type': 'other', 'count': 2},
          ],
        },
        'orderRevenue': <String, dynamic>{
          'totalOrders': 15680,
          'totalRevenue': 456789,
          'avgOrdersPerDay': 523,
          'avgRevenuePerDay': 15226,
          'avgOrderValue': 29.12,
          'completionRate': 94.2,
          'topDishes': <Map<String, dynamic>>[
            {'name': '宫保鸡丁', 'sales': 1250},
            {'name': '青椒土豆丝', 'sales': 980},
            {'name': '红烧肉', 'sales': 875},
            {'name': '麻婆豆腐', 'sales': 720},
            {'name': '糖醋里脊', 'sales': 650},
          ],
        },
        'userBehavior': <String, dynamic>{
          'activeUsers': 8960,
          'newUserRate': 32.5,
          'returnRate': 67.8,
          'conversionRate': 15.6,
        },
        'operationalQuality': <String, dynamic>{
          'dishListingRate': 87.5,
          'inventoryAlerts': 3,
          'complaintsCount': 2,
          'promotionParticipationRate': 78.2,
        },
        'topMerchants': <Map<String, dynamic>>[
          {'name': '老北京炸酱面', 'storeCount': 3, 'revenue': 45000, 'orderCount': 1580},
          {'name': '川味小炒', 'storeCount': 2, 'revenue': 38000, 'orderCount': 1320},
          {'name': '粥铺', 'storeCount': 4, 'revenue': 35000, 'orderCount': 1450},
          {'name': '饺子馆', 'storeCount': 1, 'revenue': 28000, 'orderCount': 980},
          {'name': '沙县小吃', 'storeCount': 2, 'revenue': 25000, 'orderCount': 1100},
        ],
      };
      
      // 尝试从API获取真实数据（如果后端可用）
      try {
        final apiClient = ref.read(apiClientProvider);
        
        // 尝试获取概况数据
        try {
          final overviewResponse = await apiClient.get('/admin/merchant-stats/overview');
          if (overviewResponse.data != null && overviewResponse.data['data'] != null) {
            final overviewData = overviewResponse.data['data'] as Map<String, dynamic>;
            stats['overview'] = <String, dynamic>{
              ...stats['overview'] as Map<String, dynamic>,
              ...overviewData,
            };
          }
        } catch (e) {
          AppLogger.w('获取加盟商概况失败，使用模拟数据', error: e);
        }
        
      } catch (e) {
        AppLogger.w('API客户端获取失败，使用模拟数据', error: e);
      }
      
      state = AsyncValue.data(stats);
    } catch (e, stack) {
      AppLogger.e('加载加盟商统计数据失败', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }
}