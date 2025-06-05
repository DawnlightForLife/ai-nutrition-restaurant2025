import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/navigation/app_router.dart';

class AiRecommendationChatPage extends ConsumerStatefulWidget {
  const AiRecommendationChatPage({super.key});

  @override
  ConsumerState<AiRecommendationChatPage> createState() =>
      _AiRecommendationChatPageState();
}

class _AiRecommendationChatPageState
    extends ConsumerState<AiRecommendationChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    // 初始化欢迎消息
    _addBotMessage(
      '嗨！我是元气，您的智能营养助手！😊\n\n'
      '我可以根据您的健康状况和喜好，为您推荐最合适的美食。\n\n'
      '您可以告诉我：\n'
      '• 今天想吃什么风味\n'
      '• 有没有特别的需求\n'
      '• 预算大概多少\n\n'
      '来吧，跟我说说您的想法吧！👇',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('元气 AI'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _handleReset,
            tooltip: '重新开始',
          ),
        ],
      ),
      body: Column(
        children: [
          // 聊天消息列表
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isTyping) {
                        return _buildTypingIndicator(context);
                      }
                      return _buildMessage(context, _messages[index]);
                    },
                  ),
          ),
          
          // 快捷选项
          _buildQuickActions(context),
          
          // 输入区域
          _buildInputArea(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildMessage(BuildContext context, ChatMessage message) {
    final theme = Theme.of(context);
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: theme.colorScheme.primary,
              child: const Icon(Icons.smart_toy, color: Colors.white),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (message.recommendations != null) ...[
                    const SizedBox(height: 12),
                    ...message.recommendations!.map((rec) =>
                        _buildRecommendationCard(context, rec)),
                  ],
                ],
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: theme.colorScheme.secondary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, RecommendationItem item) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: InkWell(
        onTap: () => _handleRecommendationTap(item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '¥${item.price}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.restaurant,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildNutritionChip(context, '${item.calories}kcal'),
                  const SizedBox(width: 8),
                  _buildNutritionChip(context, '蛋白质${item.protein}g'),
                  const SizedBox(width: 8),
                  _buildNutritionChip(context, '匹配度${item.matchScore}%'),
                ],
              ),
              if (item.reason != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.reason!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionChip(BuildContext context, String label) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall,
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.smart_toy, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 200)),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .onSurfaceVariant
                .withOpacity(0.3 + (value * 0.7)),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        if (mounted && _isTyping) {
          setState(() {});
        }
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final quickActions = [
      '想吃清淡的',
      '高蛋白餐',
      '减脂餐',
      '500卡以内',
      '附近1公里',
    ];

    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: quickActions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(quickActions[index]),
              onPressed: () => _handleQuickAction(quickActions[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: '告诉我您的需求...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _handleSendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: _messageController.text.trim().isEmpty
                ? null
                : _handleSendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }

  void _addBotMessage(String text, {List<RecommendationItem>? recommendations}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
        recommendations: recommendations,
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _handleSendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    setState(() => _isTyping = true);

    // 模拟AI响应
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() => _isTyping = false);

      // 模拟推荐结果
      if (text.contains('清淡') || text.contains('高蛋白') || 
          text.contains('减脂') || text.contains('卡')) {
        _addBotMessage(
          '根据您的需求和营养档案，我为您推荐以下餐品：',
          recommendations: _generateMockRecommendations(text),
        );
      } else {
        _addBotMessage(
          '好的，我理解您的需求。请问您有什么具体的偏好吗？比如：\n'
          '• 口味偏好（清淡、辣、甜等）\n'
          '• 营养需求（高蛋白、低脂等）\n'
          '• 价格范围\n'
          '• 距离要求',
        );
      }
    });
  }

  void _handleQuickAction(String action) {
    _messageController.text = action;
    _handleSendMessage();
  }

  void _handleRecommendationTap(RecommendationItem item) {
    // 跳转到推荐结果页
    context.router.push(AiRecommendationResultRoute(
      recommendations: [item],
    ));
  }

  void _handleReset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重新开始'),
        content: const Text('确定要清空当前对话并重新开始吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _messages.clear();
                _addBotMessage(
                  '您好！我是您的AI营养助手。\n\n'
                  '基于您的营养档案，我可以为您推荐最合适的餐品。\n\n'
                  '您可以告诉我：\n'
                  '• 想吃什么类型的食物\n'
                  '• 有什么特殊需求\n'
                  '• 预算范围\n\n'
                  '让我们开始吧！您今天想吃点什么？',
                );
              });
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<RecommendationItem> _generateMockRecommendations(String query) {
    return [
      RecommendationItem(
        id: '1',
        name: '藜麦鸡胸肉沙拉',
        restaurant: '健康轻食·万达店',
        price: 38,
        calories: 320,
        protein: 28,
        matchScore: 95,
        reason: '高蛋白低脂，符合您的减脂需求',
        distance: 0.8,
      ),
      RecommendationItem(
        id: '2',
        name: '蒸海鲈鱼配时蔬',
        restaurant: '粤味鲜·中心城店',
        price: 58,
        calories: 280,
        protein: 32,
        matchScore: 92,
        reason: '清淡少油，营养均衡',
        distance: 1.2,
      ),
      RecommendationItem(
        id: '3',
        name: '燕麦牛奶粥套餐',
        restaurant: '早安轻食·商业街店',
        price: 28,
        calories: 350,
        protein: 15,
        matchScore: 88,
        reason: '低GI主食，饱腹感强',
        distance: 0.5,
      ),
    ];
  }
}

// 聊天消息模型
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<RecommendationItem>? recommendations;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.recommendations,
  });
}

// 推荐项模型
class RecommendationItem {
  final String id;
  final String name;
  final String restaurant;
  final double price;
  final int calories;
  final int protein;
  final int matchScore;
  final String? reason;
  final double distance;

  RecommendationItem({
    required this.id,
    required this.name,
    required this.restaurant,
    required this.price,
    required this.calories,
    required this.protein,
    required this.matchScore,
    this.reason,
    required this.distance,
  });
}