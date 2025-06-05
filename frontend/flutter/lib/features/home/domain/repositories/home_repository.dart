import '../entities/home_banner.dart';
import '../entities/recommendation_card.dart';

/// 首页数据仓库接口
abstract class HomeRepository {
  /// 获取首页Banner列表
  Future<List<HomeBanner>> getBanners();
  
  /// 获取推荐卡片列表
  Future<List<RecommendationCard>> getRecommendationCards(String userId);
  
  /// 记录Banner点击事件
  Future<void> trackBannerClick(String bannerId, String userId);
  
  /// 记录快捷操作点击事件
  Future<void> trackQuickActionClick(String actionId, String userId);
  
  /// 获取用户个性化数据
  Future<Map<String, dynamic>> getUserPersonalizedData(String userId);
}