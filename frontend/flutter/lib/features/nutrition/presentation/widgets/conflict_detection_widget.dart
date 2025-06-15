import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/nutrition_template_model.dart';
import '../../data/datasources/remote/nutrition_profile_extended_api.dart';
import '../../data/datasources/remote/nutrition_profile_extended_api_provider.dart';
import '../../../../core/widgets/error_retry_widget.dart';

/// 冲突检测组件
class ConflictDetectionWidget extends ConsumerStatefulWidget {
  final Map<String, dynamic> profileData;
  final bool enabled;

  const ConflictDetectionWidget({
    Key? key,
    required this.profileData,
    this.enabled = true,
  }) : super(key: key);

  @override
  ConsumerState<ConflictDetectionWidget> createState() => _ConflictDetectionWidgetState();
}

class _ConflictDetectionWidgetState extends ConsumerState<ConflictDetectionWidget> {
  ConflictDetectionResult? _lastResult;
  bool _isChecking = false;
  String? _error;

  @override
  void didUpdateWidget(ConflictDetectionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.profileData != oldWidget.profileData && widget.enabled) {
      _checkConflicts();
    }
  }

  Future<void> _checkConflicts() async {
    if (!widget.enabled || widget.profileData.isEmpty) {
      return;
    }

    setState(() {
      _isChecking = true;
      _error = null;
    });

    try {
      final apiService = ref.read(nutritionProfileExtendedApiServiceProvider);
      final conflictData = await apiService.detectConflicts(widget.profileData);
      
      // 将返回的Map转换为ConflictDetectionResult
      final result = ConflictDetectionResult.fromJson(conflictData);
      
      setState(() {
        _lastResult = result;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _error = '冲突检测失败: $e';
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return const SizedBox.shrink();
    }

    if (_isChecking) {
      return _buildLoadingWidget();
    }

    if (_error != null) {
      return _buildErrorWidget();
    }

    if (_lastResult == null) {
      return _buildInitialWidget();
    }

    if (!_lastResult!.hasConflicts) {
      return _buildNoConflictsWidget();
    }

    return _buildConflictsWidget();
  }

  Widget _buildLoadingWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              '正在检测配置冲突...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ErrorRetryWidget(
          message: _error!,
          onRetry: _checkConflicts,
          compact: true,
        ),
      ),
    );
  }

  Widget _buildInitialWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '智能冲突检测已启用，将自动检测配置中的潜在冲突',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ),
            TextButton(
              onPressed: _checkConflicts,
              child: const Text('立即检测'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoConflictsWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '配置检查完成，未发现冲突',
                style: TextStyle(
                  color: Colors.green[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConflictsWidget() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.orange[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.orange[700],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '发现 ${_lastResult!.conflicts.length} 个配置冲突',
                  style: TextStyle(
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._lastResult!.conflicts.map((conflict) => _ConflictItem(conflict: conflict)),
          ],
        ),
      ),
    );
  }
}

/// 冲突项组件
class _ConflictItem extends StatelessWidget {
  final ProfileConflict conflict;

  const _ConflictItem({
    Key? key,
    required this.conflict,
  }) : super(key: key);

  IconData _getIconForType(String type) {
    switch (type) {
      case 'goal':
        return Icons.flag;
      case 'dietary':
        return Icons.restaurant;
      case 'activity':
        return Icons.directions_run;
      case 'health':
        return Icons.health_and_safety;
      default:
        return Icons.warning;
    }
  }

  Color _getColorForSeverity(ConflictSeverity? severity) {
    switch (severity) {
      case ConflictSeverity.high:
        return Colors.red;
      case ConflictSeverity.medium:
        return Colors.orange;
      case ConflictSeverity.low:
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorForSeverity(conflict.severity);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForType(conflict.type),
                color: color,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  conflict.message,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (conflict.suggestions != null && conflict.suggestions!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              '建议:',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            ...conflict.suggestions!.map((suggestion) => Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
                  ),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: TextStyle(
                        color: color.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }
}