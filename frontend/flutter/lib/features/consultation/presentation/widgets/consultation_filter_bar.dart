import 'package:flutter/material.dart';
import '../../domain/entities/consultation_entity.dart';

class ConsultationFilterBar extends StatefulWidget {
  final VoidCallback? onFilterChanged;

  const ConsultationFilterBar({
    Key? key,
    this.onFilterChanged,
  }) : super(key: key);

  @override
  State<ConsultationFilterBar> createState() => _ConsultationFilterBarState();
}

class _ConsultationFilterBarState extends State<ConsultationFilterBar> {
  ConsultationType? _selectedType;
  DateTimeRange? _selectedDateRange;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 搜索框
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '搜索咨询标题或描述...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        widget.onFilterChanged?.call();
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              // 延迟搜索以避免过于频繁的API调用
              Future.delayed(const Duration(milliseconds: 500), () {
                if (_searchController.text == value) {
                  widget.onFilterChanged?.call();
                }
              });
            },
          ),
          
          const SizedBox(height: 12),
          
          // 筛选选项
          Row(
            children: [
              // 咨询类型筛选
              Expanded(
                child: _buildTypeFilter(),
              ),
              
              const SizedBox(width: 12),
              
              // 日期范围筛选
              Expanded(
                child: _buildDateRangeFilter(),
              ),
              
              const SizedBox(width: 12),
              
              // 清除筛选按钮
              if (_hasActiveFilters())
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('清除'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeFilter() {
    return PopupMenuButton<ConsultationType?>(
      onSelected: (type) {
        setState(() {
          _selectedType = type;
        });
        widget.onFilterChanged?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.filter_list,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Text(
              _selectedType?.displayName ?? '类型',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<ConsultationType?>(
          value: null,
          child: Text('全部类型'),
        ),
        ...ConsultationType.values.map(
          (type) => PopupMenuItem<ConsultationType?>(
            value: type,
            child: Row(
              children: [
                Text(type.icon),
                const SizedBox(width: 8),
                Text(type.displayName),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return InkWell(
      onTap: _selectDateRange,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                _selectedDateRange != null
                    ? '${_formatDate(_selectedDateRange!.start)} - ${_formatDate(_selectedDateRange!.end)}'
                    : '选择日期',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}';
  }

  bool _hasActiveFilters() {
    return _selectedType != null || 
           _selectedDateRange != null || 
           _searchController.text.isNotEmpty;
  }

  void _clearFilters() {
    setState(() {
      _selectedType = null;
      _selectedDateRange = null;
      _searchController.clear();
    });
    widget.onFilterChanged?.call();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
      widget.onFilterChanged?.call();
    }
  }
}