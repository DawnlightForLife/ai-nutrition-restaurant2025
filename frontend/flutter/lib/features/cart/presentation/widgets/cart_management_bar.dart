import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';

class CartManagementBar extends ConsumerStatefulWidget {
  const CartManagementBar({super.key});

  @override
  ConsumerState<CartManagementBar> createState() => _CartManagementBarState();
}

class _CartManagementBarState extends ConsumerState<CartManagementBar> {
  bool _isAllSelected = false;
  final Set<String> _selectedItems = <String>{};

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final validItems = cart.items.where((item) => item.isValid).toList();
    
    if (validItems.isEmpty) {
      return const _EmptyManagementBar();
    }

    return _ManagementBarContent(
      validItemsCount: validItems.length,
      selectedCount: _selectedItems.length,
      isAllSelected: _isAllSelected && _selectedItems.length == validItems.length,
      onSelectAll: (selected) => _handleSelectAll(selected, validItems.map((e) => e.id).toList()),
      onDeleteSelected: _selectedItems.isNotEmpty ? _handleDeleteSelected : null,
      onMoveToFavorites: _selectedItems.isNotEmpty ? _handleMoveToFavorites : null,
    );
  }

  void _handleSelectAll(bool selected, List<String> itemIds) {
    setState(() {
      _isAllSelected = selected;
      if (selected) {
        _selectedItems.addAll(itemIds);
      } else {
        _selectedItems.clear();
      }
    });
  }

  void _handleDeleteSelected() {
    if (_selectedItems.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除选中的${_selectedItems.length}件商品吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performDelete();
            },
            child: Text(
              '删除',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _performDelete() {
    final cartNotifier = ref.read(cartProvider.notifier);
    
    for (final itemId in _selectedItems) {
      cartNotifier.removeItem(itemId);
    }
    
    setState(() {
      _selectedItems.clear();
      _isAllSelected = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('已删除选中商品'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleMoveToFavorites() {
    if (_selectedItems.isEmpty) return;

    // TODO: 实现移动到收藏夹逻辑
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('已将${_selectedItems.length}件商品移至收藏夹'),
        duration: const Duration(seconds: 2),
      ),
    );

    setState(() {
      _selectedItems.clear();
      _isAllSelected = false;
    });
  }
}

class _ManagementBarContent extends StatelessWidget {
  final int validItemsCount;
  final int selectedCount;
  final bool isAllSelected;
  final ValueChanged<bool> onSelectAll;
  final VoidCallback? onDeleteSelected;
  final VoidCallback? onMoveToFavorites;

  const _ManagementBarContent({
    required this.validItemsCount,
    required this.selectedCount,
    required this.isAllSelected,
    required this.onSelectAll,
    this.onDeleteSelected,
    this.onMoveToFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // 全选控件
              InkWell(
                onTap: () => onSelectAll(!isAllSelected),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: isAllSelected,
                        onChanged: (value) => onSelectAll(value ?? false),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '全选',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ],
                  ),
                ),
              ),
              
              // 选中状态显示
              if (selectedCount > 0) ...[
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '已选$selectedCount件',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ),
              ],
              
              const Spacer(),
              
              // 操作按钮组
              if (selectedCount > 0) ...[
                // 移至收藏夹按钮
                TextButton.icon(
                  onPressed: onMoveToFavorites,
                  icon: const Icon(Icons.favorite_border, size: 20),
                  label: const Text('收藏'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                
                // 删除按钮
                TextButton.icon(
                  onPressed: onDeleteSelected,
                  icon: const Icon(Icons.delete_outline, size: 20),
                  label: const Text('删除'),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                ),
              ] else ...[
                // 无选中状态的提示
                Text(
                  '请选择要操作的商品',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyManagementBar extends StatelessWidget {
  const _EmptyManagementBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline,
                size: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                '暂无可管理的商品',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingManagementBar extends StatelessWidget {
  const _LoadingManagementBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 40,
                height: 16,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 80,
                height: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorManagementBar extends StatelessWidget {
  const _ErrorManagementBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                size: 20,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 8),
              Text(
                '加载失败，请刷新页面',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}