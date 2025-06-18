/**
 * 食材选择页面
 * 用户根据营养目标选择具体食材和烹饪方式
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/nutrition_ordering.dart';
import '../providers/nutrition_ordering_provider.dart';
import '../widgets/ingredient_category_grid_widget.dart';
import '../widgets/ingredient_detail_dialog.dart';
import '../widgets/cooking_method_selector_widget.dart';
import '../widgets/nutrition_progress_tracker_widget.dart';
import '../widgets/ingredient_recommendations_widget.dart';
import '../../../../shared/widgets/common/loading_overlay.dart';
import '../../../../core/extensions/context_extensions.dart';

class IngredientSelectionPage extends ConsumerStatefulWidget {
  final String profileId;
  final Map<String, double>? customTargets;

  const IngredientSelectionPage({
    super.key,
    required this.profileId,
    this.customTargets,
  });

  @override
  ConsumerState<IngredientSelectionPage> createState() =>
      _IngredientSelectionPageState();
}

class _IngredientSelectionPageState
    extends ConsumerState<IngredientSelectionPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onIngredientSelected(IngredientNutrition ingredient) {
    showDialog(
      context: context,
      builder: (context) => IngredientDetailDialog(
        ingredient: ingredient,
        onAddToSelection: (amount, cookingMethod, cookingMethodName) {
          _addIngredientToSelection(
            ingredient,
            amount,
            cookingMethod,
            cookingMethodName,
          );
        },
      ),
    );
  }

  Future<void> _addIngredientToSelection(
    IngredientNutrition ingredient,
    double amount,
    String? cookingMethod,
    String? cookingMethodName,
  ) async {
    try {
      await ref.read(nutritionOrderingProvider.notifier).addIngredientSelection(
        ingredientId: ingredient.id,
        ingredientName: ingredient.chineseName,
        amount: amount,
        unit: 'g',
        cookingMethod: cookingMethod,
        cookingMethodName: cookingMethodName,
      );
      
      if (mounted) {
        context.showSuccessSnackBar('已添加${ingredient.chineseName}到选择列表');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('添加失败: $e');
      }
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    
    if (category == 'all') {
      ref.read(nutritionOrderingProvider.notifier).searchIngredients(_searchQuery);
    } else {
      ref.read(nutritionOrderingProvider.notifier).filterIngredientsByCategory(category);
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    ref.read(nutritionOrderingProvider.notifier).searchIngredients(
      query, 
      category: _selectedCategory == 'all' ? null : _selectedCategory,
    );
  }

  void _onProceedToCart() {
    context.pushRoute('/nutrition/ordering/cart', extra: {
      'profileId': widget.profileId,
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionOrderingProvider);
    final recommendations = ref.watch(ingredientRecommendationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('选择食材'),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade800,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.green.shade800,
          unselectedLabelColor: Colors.grey.shade600,
          indicatorColor: Colors.green.shade600,
          tabs: const [
            Tab(
              icon: Icon(Icons.restaurant),
              text: '全部食材',
            ),
            Tab(
              icon: Icon(Icons.recommend),
              text: 'AI推荐',
            ),
            Tab(
              icon: Icon(Icons.track_changes),
              text: '营养进度',
            ),
          ],
        ),
      ),
      body: LoadingOverlay(
        isLoading: state.isLoading,
        child: Column(
          children: [
            // 搜索栏
            _buildSearchBar(),
            
            // 内容区域
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // 全部食材标签页
                  _buildAllIngredientsTab(state),
                  
                  // AI推荐标签页
                  _buildRecommendationsTab(recommendations),
                  
                  // 营养进度标签页
                  _buildNutritionProgressTab(state),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(state),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.white,
      child: Column(
        children: [
          // 搜索输入框
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: '搜索食材名称...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                      icon: const Icon(Icons.clear),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.green.shade400),
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 分类快速筛选
          _buildCategoryFilter(),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final categories = [
      {'key': 'all', 'name': '全部', 'icon': Icons.apps},
      {'key': 'meat', 'name': '肉类', 'icon': Icons.lunch_dining},
      {'key': 'vegetables', 'name': '蔬菜', 'icon': Icons.eco},
      {'key': 'fruits', 'name': '水果', 'icon': Icons.apple},
      {'key': 'grains', 'name': '谷物', 'icon': Icons.grain},
      {'key': 'dairy', 'name': '乳制品', 'icon': Icons.water_drop},
      {'key': 'nuts_seeds', 'name': '坚果', 'icon': Icons.circle},
    ];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['key'];
          
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'] as IconData,
                    size: 16,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                  const SizedBox(width: 4),
                  Text(category['name'] as String),
                ],
              ),
              onSelected: (_) => _onCategoryChanged(category['key'] as String),
              backgroundColor: Colors.grey.shade100,
              selectedColor: Colors.green.shade600,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAllIngredientsTab(NutritionOrderingState state) {
    final ingredients = state.ingredients;
    
    if (ingredients.isEmpty) {
      return _buildEmptyState('暂无食材数据', '请检查网络连接或重新加载');
    }

    return IngredientCategoryGridWidget(
      ingredients: ingredients,
      onIngredientTap: _onIngredientSelected,
      selectedCategory: _selectedCategory,
    );
  }

  Widget _buildRecommendationsTab(List<IngredientRecommendation> recommendations) {
    if (recommendations.isEmpty) {
      return _buildEmptyState(
        '暂无推荐',
        '设置营养目标后将显示智能推荐食材',
      );
    }

    return IngredientRecommendationsWidget(
      recommendations: recommendations,
      onIngredientSelected: _onIngredientSelected,
    );
  }

  Widget _buildNutritionProgressTab(NutritionOrderingState state) {
    return NutritionProgressTrackerWidget(
      targetIntake: state.targetNutritionIntake,
      currentIntake: state.currentNutritionIntake,
      selections: state.selections,
      balanceAnalysis: state.balanceAnalysis,
      onSelectionRemoved: (index) {
        ref.read(nutritionOrderingProvider.notifier).removeIngredientSelection(index);
      },
      onAmountChanged: (index, amount) {
        ref.read(nutritionOrderingProvider.notifier).updateIngredientAmount(index, amount);
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              ref.read(nutritionOrderingProvider.notifier).initialize();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重新加载'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(NutritionOrderingState state) {
    final selectionsCount = state.selections.length;
    final hasSelections = selectionsCount > 0;
    
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
          // 选择统计
          if (hasSelections) ...[
            Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.green.shade600,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '已选择 $selectionsCount 种食材',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(2); // 切换到营养进度标签页
                  },
                  child: const Text('查看详情'),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
          
          // 操作按钮
          Row(
            children: [
              if (hasSelections) ...[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(nutritionOrderingProvider.notifier).clearAllSelections();
                      context.showInfoSnackBar('已清空所有选择');
                    },
                    icon: const Icon(Icons.clear_all),
                    label: const Text('清空'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.red.shade300),
                      foregroundColor: Colors.red.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: hasSelections ? 2 : 1,
                child: ElevatedButton.icon(
                  onPressed: hasSelections ? _onProceedToCart : null,
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(hasSelections ? '进入购物车' : '请先选择食材'),
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
}