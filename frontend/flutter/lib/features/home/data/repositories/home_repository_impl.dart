import '../../domain/entities/home_banner.dart';
import '../../domain/entities/recommendation_card.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_datasource.dart';

/// 首页仓库实现
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  
  const HomeRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<HomeBanner>> getBanners() async {
    try {
      final models = await _remoteDataSource.getBanners();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw HomeRepositoryException('Failed to get banners: $e');
    }
  }
  
  @override
  Future<List<RecommendationCard>> getRecommendationCards(String userId) async {
    try {
      final models = await _remoteDataSource.getRecommendationCards(userId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw HomeRepositoryException('Failed to get recommendation cards: $e');
    }
  }
  
  @override
  Future<void> trackBannerClick(String bannerId, String userId) async {
    try {
      await _remoteDataSource.trackBannerClick(bannerId, userId);
    } catch (e) {
      // 埋点失败不影响用户体验，记录日志即可
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<void> trackQuickActionClick(String actionId, String userId) async {
    try {
      await _remoteDataSource.trackQuickActionClick(actionId, userId);
    } catch (e) {
      // 埋点失败不影响用户体验，记录日志即可
      // TODO: 使用日志系统替代print
    }
  }
  
  @override
  Future<Map<String, dynamic>> getUserPersonalizedData(String userId) async {
    try {
      return await _remoteDataSource.getUserPersonalizedData(userId);
    } catch (e) {
      throw HomeRepositoryException('Failed to get personalized data: $e');
    }
  }
}

/// 首页仓库异常
class HomeRepositoryException implements Exception {
  final String message;
  const HomeRepositoryException(this.message);
  
  @override
  String toString() => 'HomeRepositoryException: $message';
}