import '../entities/home_banner.dart';
import '../entities/recommendation_card.dart';
import '../repositories/home_repository.dart';

/// 获取首页数据用例
class GetHomeDataUseCase {
  final HomeRepository _repository;
  
  const GetHomeDataUseCase(this._repository);
  
  /// 获取首页所有数据
  Future<HomeData> call(String userId) async {
    try {
      final futures = await Future.wait([
        _repository.getBanners(),
        _repository.getRecommendationCards(userId),
        _repository.getUserPersonalizedData(userId),
      ]);
      
      return HomeData(
        banners: futures[0] as List<HomeBanner>,
        recommendationCards: futures[1] as List<RecommendationCard>,
        personalizedData: futures[2] as Map<String, dynamic>,
      );
    } catch (e) {
      throw HomeDataException('Failed to load home data: $e');
    }
  }
}

/// 首页数据聚合类
class HomeData {
  final List<HomeBanner> banners;
  final List<RecommendationCard> recommendationCards;
  final Map<String, dynamic> personalizedData;
  
  const HomeData({
    required this.banners,
    required this.recommendationCards,
    required this.personalizedData,
  });
  
  /// 获取活跃的Banner
  List<HomeBanner> get activeBanners => 
      banners.where((banner) => banner.isActive).toList()
        ..sort((a, b) => a.order.compareTo(b.order));
  
  /// 获取可见的推荐卡片
  List<RecommendationCard> get visibleCards =>
      recommendationCards.where((card) => card.isVisible).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
  
  /// 检查是否有新用户引导
  bool get hasNewUserGuide =>
      visibleCards.any((card) => card.type == RecommendationCardType.newUserGuide);
  
  /// 检查是否有进行中的订单
  bool get hasActiveOrders =>
      visibleCards.any((card) => card.type == RecommendationCardType.orderStatus);
}

/// 首页数据异常
class HomeDataException implements Exception {
  final String message;
  const HomeDataException(this.message);
  
  @override
  String toString() => 'HomeDataException: $message';
}