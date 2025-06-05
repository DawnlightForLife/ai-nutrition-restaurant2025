import 'package:flutter/material.dart';
import '../../domain/entities/quick_action.dart';
import '../../../../routes/app_navigator.dart';

/// 快捷操作网格组件
class QuickActionsGrid extends StatelessWidget {
  final List<QuickAction> actions;
  final Function(String)? onActionTap;
  
  const QuickActionsGrid({
    super.key,
    required this.actions,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final enabledActions = actions.where((action) => action.isEnabled).toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    if (enabledActions.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: enabledActions.length,
      itemBuilder: (context, index) {
        final action = enabledActions[index];
        return _buildActionCard(context, action);
      },
    );
  }

  Widget _buildActionCard(BuildContext context, QuickAction action) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () => _handleActionTap(context, action),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  action.icon,
                  color: action.color,
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 8),
              
              // 标题
              Flexible(
                child: Text(
                  action.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              const SizedBox(height: 2),
              
              // 副标题
              Flexible(
                child: Text(
                  action.subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleActionTap(BuildContext context, QuickAction action) {
    // 记录点击事件
    onActionTap?.call(action.id);
    
    // 导航到对应页面
    _navigateToAction(context, action);
  }

  void _navigateToAction(BuildContext context, QuickAction action) {
    switch (action.route) {
      case '/ai/chat':
        // 需要检查是否有营养档案
        _navigateToAIRecommendation(context, action);
        break;
      case '/search':
        AppNavigator.pushToSearch(context);
        break;
      case '/nutrition/profiles':
        AppNavigator.toNutritionProfiles(context);
        break;
      case '/stores/nearby':
        _navigateToNearbyStores(context, action);
        break;
      default:
        // 显示开发中提示
        _showComingSoonDialog(context, action);
    }
  }

  void _navigateToAIRecommendation(BuildContext context, QuickAction action) {
    // TODO: 检查用户是否有营养档案
    // 如果没有，引导创建；如果有，直接进入AI推荐
    AppNavigator.toNutritionProfiles(context);
  }

  void _navigateToNearbyStores(BuildContext context, QuickAction action) {
    // TODO: 实现附近门店功能
    _showComingSoonDialog(context, action);
  }

  void _showComingSoonDialog(BuildContext context, QuickAction action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(action.title),
        content: const Text('功能开发中，敬请期待！'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}