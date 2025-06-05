import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/cart_item_list.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_management_bar.dart';
import '../providers/cart_provider.dart';

/// 购物车页面
class CartPage extends ConsumerStatefulWidget {
  const CartPage({super.key});
  
  @override
  ConsumerState<CartPage> createState() => _CartPageState();
}

class _CartPageState extends ConsumerState<CartPage> {
  bool _isManagementMode = false;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartProvider);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }
  
  /// 构建应用栏
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartProvider);
    
    return AppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('购物车'),
          if (cart.merchantGroups.isNotEmpty)
            Text(
              cart.merchantGroups.length == 1 
                  ? cart.merchantGroups.first.merchantName
                  : '${cart.merchantGroups.length}家商户',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
        ],
      ),
      actions: [
        if (!_isManagementMode)
          TextButton(
            onPressed: _toggleManagementMode,
            child: const Text('管理'),
          )
        else
          TextButton(
            onPressed: _exitManagementMode,
            child: const Text('退出管理'),
          ),
      ],
    );
  }
  
  /// 构建主体内容
  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // 分类过滤器
        _buildCategoryFilter(context),
        
        // 优惠券横幅
        _buildCouponBanner(context),
        
        // 购物车商品列表
        Expanded(
          child: CartItemList(
            isManagementMode: _isManagementMode,
          ),
        ),
      ],
    );
  }
  
  /// 构建分类过滤器
  Widget _buildCategoryFilter(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildFilterChip(context, '全部(27)', true),
          const SizedBox(width: 12),
          _buildFilterChip(context, '收藏', false),
          const SizedBox(width: 12),
          _buildFilterChip(context, '常购', false),
        ],
      ),
    );
  }
  
  /// 构建筛选标签
  Widget _buildFilterChip(BuildContext context, String label, bool isSelected) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected 
            ? theme.colorScheme.primary.withOpacity(0.1)
            : theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: isSelected 
            ? Border.all(color: theme.colorScheme.primary.withOpacity(0.3))
            : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isSelected 
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.w500 : null,
        ),
      ),
    );
  }
  
  /// 构建优惠券横幅
  Widget _buildCouponBanner(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade100,
            Colors.orange.shade50,
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.local_offer,
            color: Colors.orange.shade600,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '免费领神券',
              style: theme.textTheme.titleSmall?.copyWith(
                color: Colors.orange.shade800,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            '吃喝玩乐都能用 下单一省再省',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.orange.shade700,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '立即领取',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建底部栏
  Widget _buildBottomBar(BuildContext context) {
    if (_isManagementMode) {
      return const CartManagementBar();
    } else {
      return const CartBottomBar();
    }
  }
  
  /// 切换管理模式
  void _toggleManagementMode() {
    setState(() {
      _isManagementMode = true;
    });
  }
  
  /// 退出管理模式
  void _exitManagementMode() {
    setState(() {
      _isManagementMode = false;
    });
  }
}