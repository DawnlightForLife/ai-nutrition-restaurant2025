import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/order_provider.dart';
import '../../domain/entities/order_entity.dart';

class OrderFilterBar extends ConsumerStatefulWidget {
  final VoidCallback onFilterChanged;

  const OrderFilterBar({
    Key? key,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  ConsumerState<OrderFilterBar> createState() => _OrderFilterBarState();
}

class _OrderFilterBarState extends ConsumerState<OrderFilterBar> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(orderFilterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 搜索框
          TextField(
            controller: _searchController,
            onChanged: (value) {
              ref.read(orderFilterProvider.notifier).updateFilter(searchQuery: value);
              widget.onFilterChanged();
            },
            decoration: InputDecoration(
              hintText: '搜索订单号、客户姓名或电话...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        ref.read(orderFilterProvider.notifier).updateFilter(searchQuery: '');
                        widget.onFilterChanged();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 筛选标签
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // 订单类型筛选
                _buildFilterChip(
                  label: filterState.orderType?.displayName ?? '订单类型',
                  icon: Icons.category,
                  isSelected: filterState.orderType != null,
                  onTap: () => _showOrderTypeDialog(),
                  onClear: filterState.orderType != null
                      ? () {
                          ref.read(orderFilterProvider.notifier).clearOrderType();
                          widget.onFilterChanged();
                        }
                      : null,
                ),
                
                const SizedBox(width: 8),
                
                // 支付状态筛选
                _buildFilterChip(
                  label: filterState.paymentStatus?.displayName ?? '支付状态',
                  icon: Icons.payment,
                  isSelected: filterState.paymentStatus != null,
                  onTap: () => _showPaymentStatusDialog(),
                  onClear: filterState.paymentStatus != null
                      ? () {
                          ref.read(orderFilterProvider.notifier).clearPaymentStatus();
                          widget.onFilterChanged();
                        }
                      : null,
                ),
                
                const SizedBox(width: 8),
                
                // 日期筛选
                _buildFilterChip(
                  label: _getDateRangeLabel(filterState.startDate, filterState.endDate),
                  icon: Icons.date_range,
                  isSelected: filterState.startDate != null || filterState.endDate != null,
                  onTap: () => _showDateRangePicker(),
                  onClear: (filterState.startDate != null || filterState.endDate != null)
                      ? () {
                          ref.read(orderFilterProvider.notifier).updateFilter(
                            startDate: null,
                            endDate: null,
                          );
                          widget.onFilterChanged();
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
            if (onClear != null) ...[
              const SizedBox(width: 4),
              InkWell(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 16,
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showOrderTypeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择订单类型'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: OrderType.values.map((type) {
            return ListTile(
              leading: Icon(type.icon),
              title: Text(type.displayName),
              onTap: () {
                ref.read(orderFilterProvider.notifier).updateFilter(orderType: type);
                widget.onFilterChanged();
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showPaymentStatusDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择支付状态'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: PaymentStatus.values.map((status) {
            return ListTile(
              leading: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: status.color,
                  shape: BoxShape.circle,
                ),
              ),
              title: Text(status.displayName),
              onTap: () {
                ref.read(orderFilterProvider.notifier).updateFilter(paymentStatus: status);
                widget.onFilterChanged();
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      initialDateRange: DateTimeRange(
        start: ref.read(orderFilterProvider).startDate ?? DateTime.now().subtract(const Duration(days: 7)),
        end: ref.read(orderFilterProvider).endDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      ref.read(orderFilterProvider.notifier).updateFilter(
        startDate: picked.start,
        endDate: picked.end,
      );
      widget.onFilterChanged();
    }
  }

  String _getDateRangeLabel(DateTime? startDate, DateTime? endDate) {
    if (startDate == null && endDate == null) {
      return '选择日期';
    }
    
    if (startDate != null && endDate != null) {
      return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
    }
    
    if (startDate != null) {
      return '从 ${_formatDate(startDate)}';
    }
    
    return '至 ${_formatDate(endDate!)}';
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }
}