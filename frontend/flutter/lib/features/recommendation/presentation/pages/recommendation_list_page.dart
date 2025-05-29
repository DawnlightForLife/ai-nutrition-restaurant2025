import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/recommendation_provider.dart';

/// 推荐记录列表页面
@RoutePage()
class RecommendationListPage extends ConsumerStatefulWidget {
  const RecommendationListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<RecommendationListPage> createState() => _RecommendationListPageState();
}

class _RecommendationListPageState extends ConsumerState<RecommendationListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recommendationProvider.notifier).loadRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recommendationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI推荐记录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: 显示筛选选项
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 筛选标签栏
          const _FilterTabBar(),
          // 推荐列表
          Expanded(
            child: state.when(
              initial: () => const Center(child: Text('准备加载...')),
              loading: () => const Center(child: CircularProgressIndicator()),
              loaded: (recommendations) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return _RecommendationCard(recommendation: recommendation);
                },
              ),
              error: (message) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('错误: $message'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(recommendationProvider.notifier).loadRecommendations();
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: 生成新的推荐
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterTabBar extends StatefulWidget {
  const _FilterTabBar();

  @override
  State<_FilterTabBar> createState() => _FilterTabBarState();
}

class _FilterTabBarState extends State<_FilterTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: const [
          Tab(text: '全部'),
          Tab(text: '早餐'),
          Tab(text: '午餐'),
          Tab(text: '晚餐'),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final dynamic recommendation; // TODO: 使用正确的类型

  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: 跳转到推荐详情页
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: Colors.orange,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recommendation.id ?? '健康营养搭配',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '创建于: ${recommendation.createdAt ?? DateTime.now()}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '已反馈',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                '推荐菜品：蒸蛋羹、西兰花炒牛肉、紫米饭',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text(
                    '营养评分：',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  ...List.generate(5, (index) {
                    return Icon(
                      index < 4 ? Icons.star : Icons.star_border,
                      size: 16,
                      color: Colors.orange,
                    );
                  }),
                  const Spacer(),
                  const Text(
                    '总热量: 520卡',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}