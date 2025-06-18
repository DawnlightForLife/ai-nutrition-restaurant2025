/**
 * 营养购物车页面
 * 革命性的基于营养元素的购物车界面
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/nutrition_cart.dart';
import '../providers/nutrition_cart_provider.dart';
import '../widgets/cart_item_widget.dart';
import '../widgets/nutrition_balance_panel.dart';
import '../widgets/recommendations_panel.dart';
import '../widgets/merchant_group_widget.dart';
import '../widgets/nutrition_goals_selector.dart';
import '../widgets/cart_summary_widget.dart';

class NutritionCartPage extends ConsumerStatefulWidget {
  final String userId;

  const NutritionCartPage({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<NutritionCartPage> createState() => _NutritionCartPageState();
}

class _NutritionCartPageState extends ConsumerState<NutritionCartPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(nutritionCartProvider(widget.userId));
    final cartNotifier = ref.read(nutritionCartProvider(widget.userId).notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('营养购物车'),
        actions: [
          // 营养分析按钮
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.analytics_outlined),
                if (cartState.analysis?.overallScore != null &&
                    cartState.analysis!.overallScore < 7.0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              cartNotifier.setCurrentView('nutrition');
              cartNotifier.toggleNutritionPanel();
            },
            tooltip: '营养分析',
          ),
          // 推荐按钮
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.lightbulb_outline),
                if (cartState.recommendations.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${cartState.recommendations.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              cartNotifier.setCurrentView('recommendations');
              cartNotifier.toggleRecommendations();
            },
            tooltip: '智能推荐',
          ),
          // 清空购物车
          if (cartState.cart?.items.isNotEmpty == true)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => _showClearCartDialog(context),
              tooltip: '清空购物车',
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.shopping_cart), text: '购物车'),
            Tab(icon: Icon(Icons.analytics), text: '营养分析'),
            Tab(icon: Icon(Icons.recommend), text: '推荐'),
          ],
        ),
      ),
      body: cartState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCartView(context, cartState, cartNotifier),
                _buildNutritionView(context, cartState, cartNotifier),
                _buildRecommendationsView(context, cartState, cartNotifier),
              ],
            ),
      bottomNavigationBar: _buildBottomBar(context, cartState, cartNotifier),
    );
  }

  Widget _buildCartView(
    BuildContext context,
    NutritionCartState state,
    NutritionCartNotifier notifier,
  ) {
    final cart = state.cart;
    
    if (cart == null || cart.items.isEmpty) {
      return _buildEmptyCartView(context);
    }

    final itemsByMerchant = notifier.itemsByMerchant;

    return RefreshIndicator(
      onRefresh: () => notifier.loadCart(),
      child: CustomScrollView(
        slivers: [
          // 营养目标设置
          if (state.nutritionGoals.isEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flag_outlined, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '设置营养目标，获得更精准的营养分析',
                                style: TextStyle(color: Colors.blue.shade700),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => _showGoalSelector(context),
                          child: const Text('设置营养目标'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // 营养状态快览
          if (state.analysis != null)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildNutritionStatusCard(state.analysis!),
              ),
            ),

          // 按商家分组的商品列表
          ...itemsByMerchant.entries.map((entry) {
            final merchantId = entry.key;
            final items = entry.value;
            final merchantName = items.isNotEmpty ? items.first.merchantName : '';

            return SliverList(
              delegate: SliverChildListDelegate([
                MerchantGroupWidget(
                  merchantId: merchantId,
                  merchantName: merchantName,
                  items: items,
                  onItemQuantityChanged: (itemId, quantity) {
                    notifier.updateItemQuantity(itemId, quantity);
                  },
                  onItemRemoved: (itemId) {
                    notifier.removeItem(itemId);
                  },
                  isUpdating: state.isUpdating,
                  itemUpdatingStatus: state.itemUpdatingStatus,
                ),
              ]),
            );
          }).toList(),

          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
    );
  }

  Widget _buildNutritionView(
    BuildContext context,
    NutritionCartState state,
    NutritionCartNotifier notifier,
  ) {
    return NutritionBalancePanel(
      analysis: state.analysis,
      cart: state.cart,
      nutritionGoals: state.nutritionGoals,
      isAnalyzing: state.isAnalyzing,
      onAnalyze: () => notifier.analyzeNutritionBalance(),
      onSetGoals: () => _showGoalSelector(context),
      onOptimizeCart: (priorities) => notifier.optimizeCart(priorities),
    );
  }

  Widget _buildRecommendationsView(
    BuildContext context,
    NutritionCartState state,
    NutritionCartNotifier notifier,
  ) {
    return RecommendationsPanel(
      recommendations: state.recommendations,
      cart: state.cart,
      analysis: state.analysis,
      onAddRecommendation: (recommendation) {
        _addRecommendationToCart(context, recommendation, notifier);
      },
      onRefreshRecommendations: () => notifier.loadRecommendations(),
    );
  }

  Widget _buildEmptyCartView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            '购物车为空',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '添加一些营养美食吧！',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.pushRoute('/nutrition/ordering/needs-analysis');
            },
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('开始营养点餐'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionStatusCard(NutritionBalanceAnalysis analysis) {
    final scoreColor = _getScoreColor(analysis.overallScore);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '营养平衡评分',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: scoreColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${analysis.overallScore.toStringAsFixed(1)}/10',
                    style: TextStyle(
                      color: scoreColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: analysis.overallScore / 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
            ),
            if (analysis.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...analysis.warnings.take(2).map((warning) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        warning,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    NutritionCartState state,
    NutritionCartNotifier notifier,
  ) {
    final cart = state.cart;
    if (cart == null || cart.items.isEmpty) return const SizedBox.shrink();

    return CartSummaryWidget(
      cart: cart,
      analysis: state.analysis,
      isUpdating: state.isUpdating,
      onCheckout: () => _proceedToCheckout(context),
    );
  }

  Color _getScoreColor(double score) {
    if (score >= 8.0) return Colors.green;
    if (score >= 6.0) return Colors.orange;
    return Colors.red;
  }

  void _showClearCartDialog(BuildContext context) {
    context.showConfirmDialog(
      title: '清空购物车',
      message: '确定要清空购物车中的所有商品吗？',
    ).then((confirmed) {
      if (confirmed) {
        ref.read(nutritionCartProvider(widget.userId).notifier).clearCart();
        context.showSuccessSnackBar('购物车已清空');
      }
    });
  }

  void _showGoalSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NutritionGoalsSelector(
        userId: widget.userId,
        currentGoals: ref.read(nutritionCartProvider(widget.userId)).nutritionGoals,
        goalTemplates: ref.read(nutritionCartProvider(widget.userId)).goalTemplates,
        onGoalsSet: (goals) {
          ref.read(nutritionCartProvider(widget.userId).notifier).setNutritionGoals(goals);
          Navigator.of(context).pop();
        },
        onTemplateApplied: (templateId) {
          ref.read(nutritionCartProvider(widget.userId).notifier).applyGoalTemplate(templateId);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _addRecommendationToCart(
    BuildContext context,
    RecommendedItem recommendation,
    NutritionCartNotifier notifier,
  ) {
    // TODO: 创建NutritionCartItem并添加到购物车
    context.showInfoSnackBar('推荐商品添加功能开发中...');
  }

  void _proceedToCheckout(BuildContext context) {
    context.pushRoute('/checkout', extra: {
      'userId': widget.userId,
      'cartId': ref.read(nutritionCartProvider(widget.userId)).cart?.id,
    });
  }
}