import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_export_provider.dart';
import '../../domain/models/export_config_model.dart';

/// 导出进度对话框
class ExportProgressDialog extends ConsumerWidget {
  final VoidCallback? onCompleted;
  final VoidCallback? onCancelled;

  const ExportProgressDialog({
    super.key,
    this.onCompleted,
    this.onCancelled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exportState = ref.watch(dataExportProvider);
    final theme = Theme.of(context);

    return PopScope(
      canPop: !exportState.isExporting,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标和标题
              Row(
                children: [
                  _buildStatusIcon(exportState),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTitle(exportState),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (exportState.currentStep != null)
                          Text(
                            exportState.currentStep!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 进度指示器
              if (exportState.isExporting) ...[
                if (exportState.progress != null) ...[
                  // 进度条
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: exportState.progress,
                        backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                        minHeight: 8,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(exportState.progress! * 100).toInt()}%',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _getProgressDescription(exportState.progress!),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ] else ...[
                  // 无确定进度的加载指示器
                  const CircularProgressIndicator(),
                ],
              ] else if (exportState.lastResult != null) ...[
                // 结果显示
                _buildResultContent(context, exportState.lastResult!),
              ] else if (exportState.error != null) ...[
                // 错误显示
                _buildErrorContent(context, exportState.error!),
              ],
              
              const SizedBox(height: 24),
              
              // 按钮
              _buildActionButtons(context, ref, exportState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(ExportState state) {
    if (state.isExporting) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ),
        ),
      );
    } else if (state.lastResult?.isSuccess == true) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 28,
        ),
      );
    } else if (state.error != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.error,
          color: Colors.white,
          size: 28,
        ),
      );
    } else {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        child: Icon(
          Icons.download,
          color: Colors.grey[600],
          size: 28,
        ),
      );
    }
  }

  String _getTitle(ExportState state) {
    if (state.isExporting) {
      return '正在导出...';
    } else if (state.lastResult?.isSuccess == true) {
      return '导出成功！';
    } else if (state.error != null) {
      return '导出失败';
    } else {
      return '准备导出';
    }
  }

  String _getProgressDescription(double progress) {
    if (progress < 0.3) return '准备中';
    if (progress < 0.7) return '处理中';
    if (progress < 0.9) return '生成中';
    return '完成中';
  }

  Widget _buildResultContent(BuildContext context, ExportResult result) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          
          if (result.fileName != null || result.fileSizeDescription != null) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),
            
            // 文件信息
            Row(
              children: [
                Icon(
                  Icons.insert_drive_file,
                  color: Colors.grey[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (result.fileName != null)
                        Text(
                          result.fileName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      if (result.fileSizeDescription != null)
                        Text(
                          '文件大小: ${result.fileSizeDescription}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String error) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error,
            color: Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              error,
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    ExportState state,
  ) {
    if (state.isExporting) {
      // 导出中，只显示取消按钮
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () {
            // 取消导出逻辑
            Navigator.pop(context);
            onCancelled?.call();
          },
          child: const Text('取消'),
        ),
      );
    } else if (state.lastResult?.isSuccess == true) {
      // 成功，显示分享和完成按钮
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(dataExportProvider.notifier).shareLastExport();
              },
              icon: const Icon(Icons.share),
              label: const Text('分享'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onCompleted?.call();
              },
              icon: const Icon(Icons.done),
              label: const Text('完成'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      // 失败或初始状态，显示重试和关闭按钮
      return Row(
        children: [
          if (state.error != null) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(dataExportProvider.notifier).clearError();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('重试'),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onCancelled?.call();
              },
              child: const Text('关闭'),
            ),
          ),
        ],
      );
    }
  }

  /// 显示导出进度对话框
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onCompleted,
    VoidCallback? onCancelled,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ExportProgressDialog(
        onCompleted: onCompleted,
        onCancelled: onCancelled,
      ),
    );
  }
}