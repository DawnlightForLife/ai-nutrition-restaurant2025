import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/home_provider.dart';
import '../widgets/home_banner_carousel.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/recommendation_cards_section.dart';
import '../../domain/entities/quick_action.dart';
import '../../../../routes/app_navigator.dart';
import '../../../../shared/widgets/status/error_handling_widget.dart';

/// 首页
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 页面初始化时加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeProvider.notifier).loadHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养立方'),
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.titleLarge?.color,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => AppNavigator.toNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => AppNavigator.toSearch(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeProvider.notifier).refreshHomeData(),
        child: _buildBody(homeState),
      ),
    );
  }

  Widget _buildBody(HomeState state) {
    if (state.isLoading && state.banners.isEmpty) {
      return _buildLoadingState();
    }

    if (state.error != null && state.banners.isEmpty) {
      return _buildErrorState(state.error!);
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          
          // Banner轮播
          if (state.activeBanners.isNotEmpty)
            HomeBannerCarousel(
              banners: state.activeBanners,
              onBannerTap: (banner) {
                ref.read(homeProvider.notifier).onBannerTap(banner);
                _handleBannerNavigation(banner.targetUrl);
              },
            ),
          
          const SizedBox(height: 32),
          
          // 快捷功能
          _buildSectionTitle('快捷功能'),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: QuickActionsGrid(
              actions: DefaultQuickActions.actions,
              onActionTap: (actionId) {
                ref.read(homeProvider.notifier).onQuickActionTap(actionId);
              },
            ),
          ),
          
          const SizedBox(height: 32),
          
          // 推荐卡片
          if (state.visibleCards.isNotEmpty)
            RecommendationCardsSection(
              cards: state.visibleCards,
              onCardTap: (card) {
                // 处理卡片点击事件
              },
            ),
          
          const SizedBox(height: 32),
          
          // 最近活动
          _buildRecentActivitiesSection(),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('加载中...'),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return ErrorHandlingWidget(
      error: error,
      title: '加载失败',
      subtitle: '请检查网络连接后重试',
      onRetry: () => ref.read(homeProvider.notifier).loadHomeData(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesSection() {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('最近活动'),
        const SizedBox(height: 16),
        
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.timeline,
                  size: 48,
                  color: theme.disabledColor,
                ),
                const SizedBox(height: 12),
                Text(
                  '暂无活动',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '开始您的第一次AI推荐吧！',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.disabledColor,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => AppNavigator.toNutritionProfiles(context),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('开始推荐'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _handleBannerNavigation(String? targetUrl) {
    if (targetUrl == null) return;
    
    switch (targetUrl) {
      case '/ai/chat':
        AppNavigator.toNutritionProfiles(context);
        break;
      case '/search':
        AppNavigator.toSearch(context);
        break;
      default:
        // 其他URL处理
        break;
    }
  }
}