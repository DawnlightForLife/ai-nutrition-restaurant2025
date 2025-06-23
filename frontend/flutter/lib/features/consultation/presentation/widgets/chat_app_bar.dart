import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/consultation_entity.dart';
import '../providers/consultation_provider.dart';
import '../providers/chat_websocket_provider.dart';

class ChatAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String consultationId;

  const ChatAppBar({
    Key? key,
    required this.consultationId,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consultationAsync = ref.watch(consultationProvider(consultationId));
    final connectionAsync = ref.watch(chatConnectionStateProvider);

    return AppBar(
      title: consultationAsync.when(
        data: (consultation) {
          if (consultation == null) return const Text('聊天');
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                consultation.topic,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
              connectionAsync.when(
                data: (isConnected) => Text(
                  isConnected ? '在线' : '连接中...',
                  style: TextStyle(
                    fontSize: 12,
                    color: isConnected ? Colors.green : Colors.orange,
                  ),
                ),
                loading: () => const Text(
                  '连接中...',
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
                error: (_, __) => const Text(
                  '连接异常',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ),
            ],
          );
        },
        loading: () => const Text('加载中...'),
        error: (_, __) => const Text('加载失败'),
      ),
      actions: [
        // 连接状态指示器
        connectionAsync.when(
          data: (isConnected) => Container(
            margin: const EdgeInsets.only(right: 8),
            child: Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: isConnected ? Colors.green : Colors.red,
              size: 20,
            ),
          ),
          loading: () => Container(
            margin: const EdgeInsets.only(right: 8),
            child: const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, __) => Container(
            margin: const EdgeInsets.only(right: 8),
            child: const Icon(
              Icons.error,
              color: Colors.red,
              size: 20,
            ),
          ),
        ),

        // 更多选项菜单
        PopupMenuButton<String>(
          onSelected: (value) => _handleMenuAction(context, ref, value),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'consultation_info',
              child: ListTile(
                leading: Icon(Icons.info_outline),
                title: Text('咨询详情'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'message_history',
              child: ListTile(
                leading: Icon(Icons.history),
                title: Text('聊天记录'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            consultationAsync.when(
              data: (consultation) {
                if (consultation?.status == ConsultationStatus.inProgress) {
                  return const PopupMenuItem(
                    value: 'end_consultation',
                    child: ListTile(
                      leading: Icon(Icons.call_end, color: Colors.red),
                      title: Text('结束咨询', style: TextStyle(color: Colors.red)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  );
                }
                return null;
              },
              loading: () => null,
              error: (_, __) => null,
            ),
          ].whereType<PopupMenuItem<String>>().toList(),
        ),
      ],
    );
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'consultation_info':
        _showConsultationInfo(context, ref);
        break;
      case 'message_history':
        _showMessageHistory(context);
        break;
      case 'end_consultation':
        _showEndConsultationDialog(context, ref);
        break;
    }
  }

  void _showConsultationInfo(BuildContext context, WidgetRef ref) {
    final consultationAsync = ref.read(consultationProvider(consultationId));
    
    consultationAsync.whenData((consultation) {
      if (consultation == null) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('咨询详情'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInfoRow('咨询主题', consultation.topic),
                _buildInfoRow('咨询类型', consultation.consultationType.displayName),
                _buildInfoRow('状态', consultation.status.displayName),
                if (consultation.scheduledStartTime != null)
                  _buildInfoRow(
                    '预约时间',
                    _formatDateTime(consultation.scheduledStartTime!),
                  ),
                if (consultation.actualStartTime != null)
                  _buildInfoRow(
                    '开始时间',
                    _formatDateTime(consultation.actualStartTime!),
                  ),
                if (consultation.actualEndTime != null)
                  _buildInfoRow(
                    '结束时间',
                    _formatDateTime(consultation.actualEndTime!),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('关闭'),
            ),
          ],
        ),
      );
    });
  }

  void _showMessageHistory(BuildContext context) {
    // TODO: 实现查看历史记录功能
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('聊天记录功能开发中')),
    );
  }

  void _showEndConsultationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('结束咨询'),
        content: const Text('确定要结束这次咨询吗？结束后将无法继续发送消息。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _endConsultation(context, ref);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('结束'),
          ),
        ],
      ),
    );
  }

  Future<void> _endConsultation(BuildContext context, WidgetRef ref) async {
    try {
      // 更新咨询状态为已完成
      final success = await ref
          .read(consultationListProvider(ConsultationListParams()).notifier)
          .updateConsultationStatus(consultationId, ConsultationStatus.completed);
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('咨询已结束')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('结束咨询失败：$e')),
        );
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label：',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}