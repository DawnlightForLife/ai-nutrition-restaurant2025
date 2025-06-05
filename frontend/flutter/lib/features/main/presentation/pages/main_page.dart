import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/navigation_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../nutrition/presentation/pages/recommendation_entry_page.dart';
import '../widgets/forum_placeholder.dart';
import '../widgets/order_placeholder.dart';
// TODO: Import proper UserProfilePage when created
import '../widgets/user_profile_placeholder.dart';

/// 主页面 - 包含底部导航栏
class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  late final PageController _pageController;

  // 页面列表
  final List<Widget> _pages = const [
    HomePage(),                    // 首页
    RecommendationEntryPage(),     // 推荐
    ForumPlaceholder(),            // 论坛 (临时占位)
    OrderPlaceholder(),            // 订单 (临时占位)
    UserProfilePlaceholder(),      // 我的 (临时占位)
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);

    // 监听索引变化，切换页面
    ref.listen<int>(navigationProvider, (previous, next) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(next);
      }
    });

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // 禁止滑动切换
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index);
        },
      ),
    );
  }
}