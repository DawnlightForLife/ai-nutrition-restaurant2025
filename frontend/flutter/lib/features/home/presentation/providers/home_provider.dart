import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/home_banner.dart';
import '../../domain/entities/recommendation_card.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

/// 依赖注入
final dioProvider = Provider<Dio>((ref) {
  // 这里可以配置Dio实例，但为了简化，我们使用现有的网络配置
  return Dio(); // 实际项目中应该使用已配置的Dio实例
});

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final dio = ref.read(dioProvider);
  return HomeRemoteDataSourceImpl(dio);
});

final homeRepositoryProvider = Provider<HomeRepositoryImpl>((ref) {
  final dataSource = ref.read(homeRemoteDataSourceProvider);
  return HomeRepositoryImpl(dataSource);
});

final getHomeDataUseCaseProvider = Provider<GetHomeDataUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetHomeDataUseCase(repository);
});

/// 首页数据状态
class HomeState {
  final List<HomeBanner> banners;
  final List<RecommendationCard> recommendationCards;
  final Map<String, dynamic> personalizedData;
  final bool isLoading;
  final String? error;
  
  const HomeState({
    this.banners = const [],
    this.recommendationCards = const [],
    this.personalizedData = const {},
    this.isLoading = false,
    this.error,
  });
  
  HomeState copyWith({
    List<HomeBanner>? banners,
    List<RecommendationCard>? recommendationCards,
    Map<String, dynamic>? personalizedData,
    bool? isLoading,
    String? error,
  }) {
    return HomeState(
      banners: banners ?? this.banners,
      recommendationCards: recommendationCards ?? this.recommendationCards,
      personalizedData: personalizedData ?? this.personalizedData,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
  
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
}

/// 首页状态管理
final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref);
});

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref _ref;
  
  HomeNotifier(this._ref) : super(const HomeState());
  
  /// 加载首页数据
  Future<void> loadHomeData() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authState = _ref.read(authStateProvider);
      final userId = authState.user?.id ?? 'guest';
      
      final useCase = _ref.read(getHomeDataUseCaseProvider);
      final homeData = await useCase.call(userId);
      
      state = state.copyWith(
        banners: homeData.banners,
        recommendationCards: homeData.recommendationCards,
        personalizedData: homeData.personalizedData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
  
  /// 刷新首页数据
  Future<void> refreshHomeData() async {
    await loadHomeData();
  }
  
  /// 处理Banner点击
  Future<void> onBannerTap(HomeBanner banner) async {
    try {
      final authState = _ref.read(authStateProvider);
      final userId = authState.user?.id ?? 'guest';
      
      final repository = _ref.read(homeRepositoryProvider);
      await repository.trackBannerClick(banner.id, userId);
      
      // 这里可以添加导航逻辑
    } catch (e) {
      // 埋点失败不影响用户体验
    }
  }
  
  /// 处理快捷操作点击
  Future<void> onQuickActionTap(String actionId) async {
    try {
      final authState = _ref.read(authStateProvider);
      final userId = authState.user?.id ?? 'guest';
      
      final repository = _ref.read(homeRepositoryProvider);
      await repository.trackQuickActionClick(actionId, userId);
    } catch (e) {
      // 埋点失败不影响用户体验
    }
  }
}