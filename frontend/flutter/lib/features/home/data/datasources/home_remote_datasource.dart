import 'package:dio/dio.dart';
import '../models/home_banner_model.dart';
import '../models/recommendation_card_model.dart';

/// 首页远程数据源
abstract class HomeRemoteDataSource {
  Future<List<HomeBannerModel>> getBanners();
  Future<List<RecommendationCardModel>> getRecommendationCards(String userId);
  Future<void> trackBannerClick(String bannerId, String userId);
  Future<void> trackQuickActionClick(String actionId, String userId);
  Future<Map<String, dynamic>> getUserPersonalizedData(String userId);
}

/// 首页远程数据源实现
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;
  
  const HomeRemoteDataSourceImpl(this._dio);
  
  @override
  Future<List<HomeBannerModel>> getBanners() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/home/banners');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> bannersJson = data['data'] as List<dynamic>;
          return bannersJson
              .map((json) => HomeBannerModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      
      // 返回默认Banner数据
      return _getDefaultBanners();
    } catch (e) {
      // 网络错误时返回默认数据
      return _getDefaultBanners();
    }
  }
  
  @override
  Future<List<RecommendationCardModel>> getRecommendationCards(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/home/recommendations/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> cardsJson = data['data'] as List<dynamic>;
          return cardsJson
              .map((json) => RecommendationCardModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      
      // 返回默认推荐卡片
      return _getDefaultRecommendationCards(userId);
    } catch (e) {
      // 网络错误时返回默认数据
      return _getDefaultRecommendationCards(userId);
    }
  }
  
  @override
  Future<void> trackBannerClick(String bannerId, String userId) async {
    try {
      await _dio.post<Map<String, dynamic>>('/analytics/banner-click', data: {
        'bannerId': bannerId,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // 忽略埋点错误，不影响用户体验
    }
  }
  
  @override
  Future<void> trackQuickActionClick(String actionId, String userId) async {
    try {
      await _dio.post<Map<String, dynamic>>('/analytics/quick-action-click', data: {
        'actionId': actionId,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // 忽略埋点错误，不影响用户体验
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserPersonalizedData(String userId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/home/personalized/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          return data['data'] as Map<String, dynamic>;
        }
      }
      
      return {};
    } catch (e) {
      return {};
    }
  }
  
  /// 获取默认Banner数据
  List<HomeBannerModel> _getDefaultBanners() {
    return [
      const HomeBannerModel(
        id: 'banner_welcome',
        title: '欢迎来到营养立方',
        subtitle: '智能AI为您推荐健康营养餐',
        imageUrl: 'assets/images/banner_welcome.png',
        type: 'feature',
        isActive: true,
        order: 1,
        createdAt: '2024-01-01T00:00:00Z',
      ),
      const HomeBannerModel(
        id: 'banner_ai',
        title: 'AI智能推荐',
        subtitle: '根据您的营养档案，精准推荐适合的餐品',
        imageUrl: 'https://via.placeholder.com/400x200/4ECDC4/FFFFFF?text=AI+Recommendation',
        targetUrl: '/ai/chat',
        type: 'promotion',
        isActive: true,
        order: 2,
        createdAt: '2024-01-01T00:00:00Z',
      ),
    ];
  }
  
  /// 获取默认推荐卡片数据
  List<RecommendationCardModel> _getDefaultRecommendationCards(String userId) {
    // 这里可以根据用户状态返回不同的卡片
    return [
      const RecommendationCardModel(
        id: 'card_new_user',
        type: 'newUserGuide',
        title: '创建您的营养档案',
        subtitle: '个性化推荐的第一步',
        targetRoute: '/nutrition/profile/create',
        isVisible: true,
        priority: 10,
      ),
      const RecommendationCardModel(
        id: 'card_ai_recommend',
        type: 'aiRecommendation',
        title: '继续AI推荐',
        subtitle: '发现更多适合您的美食',
        targetRoute: '/ai/chat',
        isVisible: true,
        priority: 8,
      ),
    ];
  }
}