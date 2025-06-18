/**
 * 批量操作栏组件
 */

import 'package:flutter/material.dart';

class BatchOperationBar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onBatchUpdate;
  final VoidCallback onBatchDelete;
  final VoidCallback onExport;

  const BatchOperationBar({
    super.key,
    required this.selectedCount,
    required this.onBatchUpdate,
    required this.onBatchDelete,
    required this.onExport,
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
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Text(
                '已选择 $selectedCount 项',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onExport,
                icon: const Icon(Icons.download, size: 20),
                label: const Text('导出'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onBatchUpdate,
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('批量编辑'),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onBatchDelete,
                icon: const Icon(Icons.delete, size: 20),
                label: const Text('删除'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}