import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/nutritionist_management_provider.dart';

class BatchOperationsBar extends ConsumerWidget {
  final int selectedCount;
  final Function(String) onBatchOperation;

  const BatchOperationsBar({
    Key? key,
    required this.selectedCount,
    required this.onBatchOperation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nutritionistManagementProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          // 选中数量显示
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '已选择 $selectedCount 项',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Spacer(),
          
          // 批量操作按钮
          if (!state.isPerformingBatchOperation) ...[
            _buildOperationButton(
              icon: Icons.check_circle,
              label: '批量激活',
              color: Colors.green,
              onPressed: () => onBatchOperation('activate'),
            ),
            
            const SizedBox(width: 8),
            
            _buildOperationButton(
              icon: Icons.pause_circle,
              label: '批量暂停',
              color: Colors.orange,
              onPressed: () => onBatchOperation('suspend'),
            ),
            
            const SizedBox(width: 8),
            
            _buildOperationButton(
              icon: Icons.offline_pin,
              label: '批量下线',
              color: Colors.red,
              onPressed: () => onBatchOperation('offline'),
            ),
            
            const SizedBox(width: 16),
            
            _buildOperationButton(
              icon: Icons.file_download,
              label: '导出选中',
              color: Colors.blue,
              onPressed: () => onBatchOperation('export'),
            ),
          ] else ...[
            // 执行批量操作时显示加载状态
            const CircularProgressIndicator(
              strokeWidth: 2,
            ),
            const SizedBox(width: 12),
            const Text('正在执行批量操作...'),
          ],
          
          const SizedBox(width: 16),
          
          // 取消选择按钮
          TextButton.icon(
            onPressed: () => onBatchOperation('cancel'),
            icon: const Icon(Icons.clear),
            label: const Text('取消选择'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOperationButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class BatchOperationDialog extends StatefulWidget {
  final String operationType;
  final int selectedCount;
  final Function(String status, String reason) onConfirm;

  const BatchOperationDialog({
    Key? key,
    required this.operationType,
    required this.selectedCount,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<BatchOperationDialog> createState() => _BatchOperationDialogState();
}

class _BatchOperationDialogState extends State<BatchOperationDialog> {
  final _reasonController = TextEditingController();
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  void _initializeStatus() {
    switch (widget.operationType) {
      case 'activate':
        _selectedStatus = 'active';
        break;
      case 'suspend':
        _selectedStatus = 'suspended';
        break;
      case 'deactivate':
        _selectedStatus = 'inactive';
        break;
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  String get _operationTitle {
    switch (widget.operationType) {
      case 'activate':
        return '批量激活营养师';
      case 'suspend':
        return '批量暂停营养师';
      case 'offline':
        return '批量下线营养师';
      case 'deactivate':
        return '批量停用营养师';
      default:
        return '批量操作';
    }
  }

  String get _operationDescription {
    switch (widget.operationType) {
      case 'activate':
        return '确定要激活选中的 ${widget.selectedCount} 位营养师吗？';
      case 'suspend':
        return '确定要暂停选中的 ${widget.selectedCount} 位营养师吗？';
      case 'offline':
        return '确定要将选中的 ${widget.selectedCount} 位营养师设置为离线状态吗？';
      case 'deactivate':
        return '确定要停用选中的 ${widget.selectedCount} 位营养师吗？';
      default:
        return '确定要执行此操作吗？';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_operationTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_operationDescription),
          
          const SizedBox(height: 16),
          
          // 操作原因输入框
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              labelText: '操作原因（可选）',
              hintText: '请输入操作原因，便于后续审计',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            maxLength: 200,
          ),
          
          if (widget.operationType != 'offline') ...[
            const SizedBox(height: 16),
            
            // 状态选择（如果需要）
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: '目标状态',
                border: OutlineInputBorder(),
              ),
              items: _getStatusOptions(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value;
                });
              },
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: _selectedStatus != null || widget.operationType == 'offline'
              ? () {
                  Navigator.pop(context);
                  widget.onConfirm(
                    _selectedStatus ?? 'offline',
                    _reasonController.text.trim(),
                  );
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _getOperationColor(),
          ),
          child: const Text('确定执行'),
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _getStatusOptions() {
    switch (widget.operationType) {
      case 'activate':
        return [
          const DropdownMenuItem(value: 'active', child: Text('活跃')),
        ];
      case 'suspend':
        return [
          const DropdownMenuItem(value: 'suspended', child: Text('已暂停')),
        ];
      case 'deactivate':
        return [
          const DropdownMenuItem(value: 'inactive', child: Text('不活跃')),
        ];
      default:
        return [
          const DropdownMenuItem(value: 'active', child: Text('活跃')),
          const DropdownMenuItem(value: 'inactive', child: Text('不活跃')),
          const DropdownMenuItem(value: 'suspended', child: Text('已暂停')),
        ];
    }
  }

  Color _getOperationColor() {
    switch (widget.operationType) {
      case 'activate':
        return Colors.green;
      case 'suspend':
        return Colors.orange;
      case 'offline':
        return Colors.red;
      case 'deactivate':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}

// 批量操作结果显示组件
class BatchOperationResultSnackBar {
  static void show(
    BuildContext context, {
    required bool success,
    required String operation,
    required int total,
    required int affected,
    String? error,
  }) {
    final snackBar = SnackBar(
      backgroundColor: success ? Colors.green : Colors.red,
      duration: const Duration(seconds: 4),
      content: Row(
        children: [
          Icon(
            success ? Icons.check_circle : Icons.error,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  success ? '批量操作完成' : '批量操作失败',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (success) ...[
                  Text(
                    '$operation：成功处理 $affected/$total 项',
                    style: const TextStyle(color: Colors.white),
                  ),
                ] else ...[
                  Text(
                    error ?? '操作失败，请重试',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: '关闭',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}