import 'package:flutter/material.dart';
import 'dart:async';

class InventoryFilterBar extends StatefulWidget {
  final String searchQuery;
  final String statusFilter;
  final String categoryFilter;
  final Function(String) onSearchChanged;
  final Function(String) onStatusFilterChanged;
  final Function(String) onCategoryFilterChanged;

  const InventoryFilterBar({
    Key? key,
    required this.searchQuery,
    required this.statusFilter,
    required this.categoryFilter,
    required this.onSearchChanged,
    required this.onStatusFilterChanged,
    required this.onCategoryFilterChanged,
  }) : super(key: key);

  @override
  State<InventoryFilterBar> createState() => _InventoryFilterBarState();
}

class _InventoryFilterBarState extends State<InventoryFilterBar> {
  late TextEditingController _searchController;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 搜索框
          TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintText: '搜索库存项目...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onSearchChanged('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // 筛选按钮行
          Row(
            children: [
              // 状态筛选
              Expanded(
                child: _buildFilterDropdown(
                  value: widget.statusFilter,
                  items: const [
                    {'value': 'all', 'label': '所有状态'},
                    {'value': 'low_stock', 'label': '库存不足'},
                    {'value': 'expiring', 'label': '即将过期'},
                    {'value': 'expired', 'label': '已过期'},
                  ],
                  onChanged: widget.onStatusFilterChanged,
                  icon: Icons.inventory,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // 分类筛选
              Expanded(
                child: _buildFilterDropdown(
                  value: widget.categoryFilter,
                  items: const [
                    {'value': 'all', 'label': '所有分类'},
                    {'value': 'ingredient', 'label': '食材'},
                    {'value': 'spice', 'label': '调料'},
                    {'value': 'beverage', 'label': '饮料'},
                    {'value': 'other', 'label': '其他'},
                  ],
                  onChanged: widget.onCategoryFilterChanged,
                  icon: Icons.category,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<Map<String, String>> items,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item['value'],
            child: Row(
              children: [
                Icon(icon, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  item['label']!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          if (newValue != null) {
            onChanged(newValue);
          }
        },
      ),
    );
  }
}