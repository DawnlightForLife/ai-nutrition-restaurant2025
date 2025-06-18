/**
 * 推荐面板组件
 */

import 'package:flutter/material.dart';
import '../../domain/entities/nutrition_cart.dart';

class RecommendationsPanel extends StatelessWidget {
  final List<RecommendedItem> recommendations;
  final NutritionCart? cart;
  final NutritionBalanceAnalysis? analysis;
  final Function(RecommendedItem) onAddRecommendation;
  final VoidCallback onRefreshRecommendations;

  const RecommendationsPanel({
    super.key,
    required this.recommendations,
    this.cart,
    this.analysis,
    required this.onAddRecommendation,
    required this.onRefreshRecommendations,
  });

  @override
  Widget build(BuildContext context) {
    if (cart == null || cart!.items.isEmpty) {
      return _buildEmptyCartState(context);
    }

    if (recommendations.isEmpty) {
      return _buildNoRecommendationsState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 推荐说明
          _buildRecommendationHeader(context),
          const SizedBox(height: 16),
          
          // 营养缺失提醒
          if (analysis != null) ...[
            _buildNutritionDeficiencies(context),
            const SizedBox(height: 16),
          ],
          
          // 推荐商品列表
          _buildRecommendationsList(context),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            '添加商品后获得推荐',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'AI会根据您的营养需求推荐合适的商品',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoRecommendationsState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.green[400],
          ),
          const SizedBox(height: 16),
          Text(
            '营养搭配很棒！',
            style: TextStyle(
              fontSize: 18,
              color: Colors.green[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '当前购物车营养均衡，暂无特别推荐',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRefreshRecommendations,
            icon: const Icon(Icons.refresh),
            label: const Text('刷新推荐'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationHeader(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'AI营养师推荐',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onRefreshRecommendations,
                  icon: const Icon(Icons.refresh),
                  tooltip: '刷新推荐',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '基于您当前的购物车内容，我们为您推荐以下商品来优化营养搭配',
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionDeficiencies(BuildContext context) {
    final deficiencies = _getDeficiencies();
    if (deficiencies.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Text(
                  '营养缺失提醒',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '您的购物车中缺少以下营养元素：',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: deficiencies.map((deficiency) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    deficiency,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange.shade800,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsList(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final recommendation = recommendations[index];
        return _buildRecommendationCard(context, recommendation);
      },
    );
  }

  Widget _buildRecommendationCard(BuildContext context, RecommendedItem recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recommendation.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        recommendation.reason,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(recommendation.improvementScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.trending_up,
                        size: 14,
                        color: _getScoreColor(recommendation.improvementScore),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '+${(recommendation.improvementScore * 10).toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _getScoreColor(recommendation.improvementScore),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            if (recommendation.nutritionBenefit.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                '营养益处:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: recommendation.nutritionBenefit.entries.map((entry) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${entry.key}: +${entry.value.toStringAsFixed(1)}${_getUnit(entry.key)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade700,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (recommendation.quantity > 0) ...[
                  Text(
                    '建议数量: ${recommendation.quantity.toStringAsFixed(1)} ${recommendation.unit ?? ''}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ] else ...[
                  const SizedBox.shrink(),
                ],
                ElevatedButton.icon(
                  onPressed: () => onAddRecommendation(recommendation),
                  icon: const Icon(Icons.add_shopping_cart, size: 16),
                  label: const Text('添加到购物车'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> _getDeficiencies() {
    if (analysis == null) return [];
    
    return analysis!.elementAnalysis.entries
        .where((entry) => entry.value.status == 'deficient')
        .map((entry) => entry.value.elementName)
        .toList();
  }

  Color _getScoreColor(double score) {
    if (score >= 0.7) return Colors.green;
    if (score >= 0.4) return Colors.orange;
    return Colors.blue;
  }

  String _getUnit(String nutrient) {
    switch (nutrient.toLowerCase()) {
      case 'protein':
      case 'carbohydrate':
      case 'fat':
      case 'fiber':
        return 'g';
      case 'vitamin_c':
      case 'vitamin_b':
      case 'calcium':
      case 'iron':
        return 'mg';
      case 'calories':
        return ' 卡';
      default:
        return '';
    }
  }
}