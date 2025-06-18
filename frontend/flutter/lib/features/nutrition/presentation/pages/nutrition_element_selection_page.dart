/**
 * 营养元素选择页面
 * 用户可以按营养分类选择目标摄入量，系统实时显示营养平衡状态
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/nutrition_ordering.dart';
import '../providers/nutrition_ordering_provider.dart';
import '../widgets/nutrition_element_category_widget.dart';
import '../widgets/nutrition_balance_indicator_widget.dart';
import '../widgets/nutrition_targets_adjuster_widget.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../core/extensions/context_extensions.dart';

class NutritionElementSelectionPage extends ConsumerStatefulWidget {
  final String profileId;

  const NutritionElementSelectionPage({
    super.key,
    required this.profileId,
  });

  @override
  ConsumerState<NutritionElementSelectionPage> createState() =>
      _NutritionElementSelectionPageState();
}

class _NutritionElementSelectionPageState
    extends ConsumerState<NutritionElementSelectionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'macronutrients';
  final Map<String, double> _customTargets = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // 初始化数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionOrderingProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onTargetAdjusted(String element, double target) {
    setState(() {
      _customTargets[element] = target;
    });
    // TODO: 更新Provider中的目标值
  }

  void _onProceedToIngredients() {
    context.pushRoute('/nutrition/ordering/ingredient-selection', extra: {
      'profileId': widget.profileId,
      'customTargets': _customTargets,
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionOrderingProvider);
    final constants = ref.watch(nutritionConstantsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('营养元素选择'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade800,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showNutritionInfo();
            },
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: Column(
          children: [
            // 营养平衡指示器
            _buildNutritionBalanceHeader(state),
            
            // 营养分类标签页
            _buildCategoryTabs(constants),
            
            // 内容区域
            Expanded(
              child: _buildContent(state),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(state),
    );
  }

  Widget _buildNutritionBalanceHeader(NutritionOrderingState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // 营养平衡指示器
          NutritionBalanceIndicatorWidget(
            analysis: state.balanceAnalysis,
            score: state.nutritionScore,
          ),
          
          const SizedBox(height: 16),
          
          // 快速调整提示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '拖拽滑块调整各营养元素目标摄入量，实时查看营养平衡状态',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(AsyncValue<List<NutritionElement>> constants) {
    return constants.when(
      data: (elements) {
        // Extract categories from nutrition elements
        final categories = <String, dynamic>{};
        for (final element in elements) {
          categories[element.category] = element.category;
        }
        
        return Container(
          color: Colors.white,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: Colors.green.shade700,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Colors.green.shade600,
            onTap: (index) {
              final categoryKeys = categories.keys.toList();
              if (index < categoryKeys.length) {
                _onCategoryChanged(categoryKeys[index]);
              }
            },
            tabs: categories.entries.map((entry) {
              return Tab(
                text: _getCategoryDisplayName(entry.key),
                icon: Icon(_getCategoryIcon(entry.key), size: 20),
              );
            }).toList(),
          ),
        );
      },
      loading: () => const SizedBox(
        height: 80,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Container(
        height: 80,
        color: Colors.red.shade50,
        child: Center(
          child: Text(
            '加载分类失败: $error',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(NutritionOrderingState state) {
    return TabBarView(
      controller: _tabController,
      children: [
        // 宏量营养素
        _buildCategoryContent('macronutrients', state),
        
        // 维生素
        _buildCategoryContent('vitamins', state),
        
        // 矿物质
        _buildCategoryContent('minerals', state),
        
        // 氨基酸
        _buildCategoryContent('amino_acids', state),
        
        // 其他营养素
        _buildCategoryContent('others', state),
      ],
    );
  }

  Widget _buildCategoryContent(String category, NutritionOrderingState state) {
    final elements = state.elementsByCategory[category] ?? [];
    
    if (elements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_dining_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              '该分类暂无营养元素',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 分类说明
          _buildCategoryDescription(category),
          
          const SizedBox(height: 16),
          
          // 营养元素列表
          NutritionElementCategoryWidget(
            category: category,
            elements: elements,
            targetIntake: state.targetNutritionIntake,
            currentIntake: state.currentNutritionIntake,
            onTargetChanged: _onTargetAdjusted,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryDescription(String category) {
    final descriptions = {
      'macronutrients': '宏量营养素是身体所需的主要营养成分，包括蛋白质、碳水化合物和脂肪，为身体提供能量和基本构建材料。',
      'vitamins': '维生素是维持身体正常生理功能必需的有机化合物，虽然需求量小，但对健康至关重要。',
      'minerals': '矿物质是构成身体组织和维持生理功能的无机物质，参与多种酶活性和代谢过程。',
      'amino_acids': '氨基酸是蛋白质的构成单位，其中必需氨基酸无法自体合成，必须从食物中获取。',
      'others': '其他营养素包括膳食纤维、抗氧化剂、植物营养素等，对健康具有重要的保护和调节作用。',
    };

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                color: Colors.green.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                _getCategoryDisplayName(category),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            descriptions[category] ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(NutritionOrderingState state) {
    final hasTargets = state.targetNutritionIntake.isNotEmpty;
    final balanceScore = state.nutritionScore?.overall ?? 0.0;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 营养评分显示
          if (hasTargets) ...[
            Row(
              children: [
                Icon(
                  Icons.score_outlined,
                  color: Colors.green.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '营养平衡评分: ${balanceScore.toStringAsFixed(1)}/100',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                _buildScoreIndicator(balanceScore),
              ],
            ),
            const SizedBox(height: 12),
          ],
          
          // 操作按钮
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showNutritionTargetsAdjuster();
                  },
                  icon: const Icon(Icons.tune),
                  label: const Text('精确调整'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.green.shade300),
                    foregroundColor: Colors.green.shade700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: hasTargets ? _onProceedToIngredients : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('选择食材'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreIndicator(double score) {
    Color color = Colors.red;
    if (score >= 80) {
      color = Colors.green;
    } else if (score >= 60) {
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        score >= 80 ? '优秀' : score >= 60 ? '良好' : '需改善',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    const names = {
      'macronutrients': '宏量营养素',
      'vitamins': '维生素',
      'minerals': '矿物质',
      'amino_acids': '氨基酸',
      'fatty_acids': '脂肪酸',
      'antioxidants': '抗氧化剂',
      'phytonutrients': '植物营养素',
      'probiotics': '益生菌',
      'fiber': '膳食纤维',
      'water': '水分',
      'others': '其他',
    };
    return names[category] ?? category;
  }

  IconData _getCategoryIcon(String category) {
    const icons = {
      'macronutrients': Icons.fitness_center,
      'vitamins': Icons.local_pharmacy,
      'minerals': Icons.diamond,
      'amino_acids': Icons.science_outlined,
      'fatty_acids': Icons.opacity,
      'antioxidants': Icons.shield,
      'phytonutrients': Icons.eco,
      'probiotics': Icons.microwave,
      'fiber': Icons.grain,
      'water': Icons.water_drop,
      'others': Icons.more_horiz,
    };
    return icons[category] ?? Icons.local_dining;
  }

  void _showNutritionInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('营养元素选择说明'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '如何使用：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('1. 浏览不同营养元素分类'),
              Text('2. 调整各营养素的目标摄入量'),
              Text('3. 观察营养平衡指示器的变化'),
              Text('4. 确认目标后进入食材选择'),
              SizedBox(height: 16),
              Text(
                '提示：',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• 绿色表示摄入充足'),
              Text('• 橙色表示需要注意'),
              Text('• 红色表示严重不足或过量'),
              Text('• 滑块可精确调整目标值'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('了解'),
          ),
        ],
      ),
    );
  }

  void _showNutritionTargetsAdjuster() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: NutritionTargetsAdjusterWidget(
            scrollController: scrollController,
            targetIntake: ref.watch(nutritionOrderingProvider).targetNutritionIntake,
            onTargetChanged: _onTargetAdjusted,
          ),
        ),
      ),
    );
  }
}