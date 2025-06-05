import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_recommendation_chat_page.dart';

class AiRecommendationResultPage extends ConsumerStatefulWidget {
  final List<RecommendationItem> recommendations;

  const AiRecommendationResultPage({
    super.key,
    required this.recommendations,
  });

  @override
  ConsumerState<AiRecommendationResultPage> createState() =>
      _AiRecommendationResultPageState();
}

class _AiRecommendationResultPageState
    extends ConsumerState<AiRecommendationResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _sortBy = 'match'; // match, price, distance, calories

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐结果'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '推荐餐品'),
            Tab(text: '营养分析'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRecommendationList(context),
          _buildNutritionAnalysis(context),
        ],
      ),
    );
  }

  Widget _buildRecommendationList(BuildContext context) {
    final sortedRecommendations = _getSortedRecommendations();

    return Column(
      children: [
        // 排序选项
        _buildSortOptions(context),
        
        // 推荐列表
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedRecommendations.length,
            itemBuilder: (context, index) {
              return _buildRecommendationCard(
                context,
                sortedRecommendations[index],
                index + 1,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortOptions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '排序：',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('匹配度', 'match'),
                  const SizedBox(width: 8),
                  _buildSortChip('价格', 'price'),
                  const SizedBox(width: 8),
                  _buildSortChip('距离', 'distance'),
                  const SizedBox(width: 8),
                  _buildSortChip('热量', 'calories'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    return ChoiceChip(
      label: Text(label),
      selected: _sortBy == value,
      onSelected: (selected) {
        if (selected) {
          setState(() => _sortBy = value);
        }
      },
    );
  }

  Widget _buildRecommendationCard(
    BuildContext context,
    RecommendationItem item,
    int rank,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _handleItemTap(item),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域
            Container(
              height: 160,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: Stack(
                children: [
                  // 模拟图片
                  Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 60,
                      color: theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  
                  // 排名标签
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getRankColor(rank),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'TOP $rank',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  
                  // 匹配度标签
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${item.matchScore}% 匹配',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // 信息区域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题和价格
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '¥${item.price}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // 餐厅信息
                  Row(
                    children: [
                      Icon(
                        Icons.store,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.restaurant,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        size: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.distance}km',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // 营养信息
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(context, Icons.local_fire_department,
                          '${item.calories}kcal'),
                      _buildInfoChip(
                          context, Icons.fitness_center, '蛋白质${item.protein}g'),
                      _buildInfoChip(context, Icons.grain, '碳水45g'),
                      _buildInfoChip(context, Icons.opacity, '脂肪12g'),
                    ],
                  ),
                  
                  // 推荐理由
                  if (item.reason != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 16,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.reason!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  
                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleViewDetails(item),
                          icon: const Icon(Icons.info_outline, size: 18),
                          label: const Text('查看详情'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _handleAddToCart(item),
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text('加入购物车'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionAnalysis(BuildContext context) {
    final theme = Theme.of(context);
    
    // 计算平均营养数据
    final avgCalories = widget.recommendations
        .map((e) => e.calories)
        .reduce((a, b) => a + b) ~/ widget.recommendations.length;
    final avgProtein = widget.recommendations
        .map((e) => e.protein)
        .reduce((a, b) => a + b) ~/ widget.recommendations.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 营养概览卡片
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '营养概览',
                        style: theme.textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildNutritionRow(
                    context,
                    '平均热量',
                    '$avgCalories kcal',
                    '符合您的目标热量范围',
                  ),
                  const Divider(height: 24),
                  _buildNutritionRow(
                    context,
                    '平均蛋白质',
                    '$avgProtein g',
                    '满足您的高蛋白需求',
                  ),
                  const Divider(height: 24),
                  _buildNutritionRow(
                    context,
                    '营养均衡度',
                    '85%',
                    '推荐餐品营养搭配合理',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 营养分布图表
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '营养素分布',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildNutrientBar(context, '蛋白质', 0.3, Colors.blue),
                  const SizedBox(height: 12),
                  _buildNutrientBar(context, '碳水化合物', 0.45, Colors.orange),
                  const SizedBox(height: 12),
                  _buildNutrientBar(context, '脂肪', 0.25, Colors.green),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // 健康提示
          Card(
            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '健康提示',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip(context, '推荐餐品均符合您的减脂目标，热量控制得当'),
                  _buildTip(context, '蛋白质含量充足，有助于维持肌肉量'),
                  _buildTip(context, '建议搭配适量蔬菜，增加膳食纤维摄入'),
                  _buildTip(context, '记得多喝水，保持良好的水分平衡'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(
    BuildContext context,
    String label,
    String value,
    String description,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNutrientBar(
    BuildContext context,
    String label,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
            Text(
              '${(value * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value,
          backgroundColor: color.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 8,
        ),
      ],
    );
  }

  Widget _buildTip(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 3:
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  List<RecommendationItem> _getSortedRecommendations() {
    final sorted = List<RecommendationItem>.from(widget.recommendations);
    
    switch (_sortBy) {
      case 'price':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'distance':
        sorted.sort((a, b) => a.distance.compareTo(b.distance));
        break;
      case 'calories':
        sorted.sort((a, b) => a.calories.compareTo(b.calories));
        break;
      case 'match':
      default:
        sorted.sort((a, b) => b.matchScore.compareTo(a.matchScore));
        break;
    }
    
    return sorted;
  }

  void _handleItemTap(RecommendationItem item) {
    // TODO: 跳转到餐品详情页
  }

  void _handleViewDetails(RecommendationItem item) {
    // TODO: 查看餐品详情
  }

  void _handleAddToCart(RecommendationItem item) {
    // TODO: 添加到购物车
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已将 ${item.name} 加入购物车'),
        action: SnackBarAction(
          label: '查看',
          onPressed: () {
            // TODO: 跳转到购物车
          },
        ),
      ),
    );
  }
}