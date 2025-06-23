import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/ai/ai_service_interface.dart';
import '../../../../core/services/ai/ai_service_providers.dart';

/// AI助手页面 - 营养师AI辅助工具
/// 提供AI辅助生成食谱、建议回复等功能
/// 支持热更换AI服务提供者
class AiAssistantPage extends ConsumerStatefulWidget {
  const AiAssistantPage({super.key});

  @override
  ConsumerState<AiAssistantPage> createState() => _AiAssistantPageState();
}

class _AiAssistantPageState extends ConsumerState<AiAssistantPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AIMessage> _messages = [];
  bool _isLoading = false;
  String _selectedAssistantType = 'nutrition_plan';

  final Map<String, String> _assistantTypes = {
    'nutrition_plan': '营养方案助手',
    'consultation_reply': '咨询回复助手',
    'diet_analysis': '饮食分析助手',
    'recipe_generator': '食谱生成助手',
  };

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeWelcomeMessage() {
    _messages.add(AIMessage(
      content: '您好！我是您的AI营养助手。我可以帮助您：\n\n'
          '🍎 生成个性化营养方案\n'
          '💬 起草专业咨询回复\n'
          '📊 分析客户饮食记录\n'
          '🍽️ 创建健康食谱\n\n'
          '请选择您需要的助手类型，然后告诉我您的需求！',
      isUser: false,
      timestamp: DateTime.now(),
      messageType: 'welcome',
    ));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    final aiServiceAvailable = ref.watch(aiServiceAvailabilityProvider);
    final currentServiceInfo = ref.watch(currentAIServiceInfoProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // AI服务状态栏
          _buildServiceStatusBar(aiServiceAvailable, currentServiceInfo),
          
          // AI助手类型选择
          _buildAssistantTypeSelector(),
          
          // 聊天消息列表
          Expanded(
            child: aiServiceAvailable 
                ? _buildMessageList()
                : _buildServiceUnavailableWidget(),
          ),
          
          // 输入框
          _buildMessageInput(aiServiceAvailable),
        ],
      ),
    );
  }

  Widget _buildServiceStatusBar(bool isAvailable, dynamic serviceInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAvailable ? Colors.green[50] : Colors.red[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAvailable ? Icons.check_circle : Icons.error,
            size: 16,
            color: isAvailable ? Colors.green[600] : Colors.red[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              serviceInfo != null 
                  ? '${serviceInfo?.displayName ?? 'AI服务'} - ${serviceInfo?.statusText ?? '状态未知'}'
                  : (isAvailable ? 'AI服务可用' : 'AI服务不可用'),
              style: TextStyle(
                fontSize: 12,
                color: isAvailable ? Colors.green[700] : Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isAvailable)
            TextButton(
              onPressed: () => _showServiceSettings(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
              ),
              child: Text(
                '设置',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[600],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceUnavailableWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.cloud_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'AI服务暂不可用',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '请检查网络连接或切换到其他AI服务',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showServiceSettings(),
            icon: const Icon(Icons.settings),
            label: const Text('AI服务设置'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => _retryConnection(),
            child: const Text('重试连接'),
          ),
        ],
      ),
    );
  }

  Widget _buildAssistantTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI助手类型',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: _assistantTypes.entries.map((entry) {
              final isSelected = _selectedAssistantType == entry.key;
              return ChoiceChip(
                label: Text(entry.value),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedAssistantType = entry.key;
                    });
                    _onAssistantTypeChanged();
                  }
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: isSelected 
                      ? Theme.of(context).primaryColor 
                      : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(AIMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser 
            ? MainAxisAlignment.end 
            : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? Theme.of(context).primaryColor 
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.content,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : Colors.black87,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  if (message.messageType == 'nutrition_plan') ...[
                    const SizedBox(height: 8),
                    _buildNutritionPlanActions(),
                  ],
                  if (message.messageType == 'recipe') ...[
                    const SizedBox(height: 8),
                    _buildRecipeActions(),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser 
                          ? Colors.white70 
                          : Colors.grey[500],
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNutritionPlanActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _shareNutritionPlan(),
            icon: const Icon(Icons.share, size: 16),
            label: const Text('分享给客户', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _saveNutritionPlan(),
            icon: const Icon(Icons.save, size: 16),
            label: const Text('保存方案', style: TextStyle(fontSize: 12)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _addToRecipeLibrary(),
            icon: const Icon(Icons.library_add, size: 16),
            label: const Text('添加到食谱库', style: TextStyle(fontSize: 12)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(bool isServiceAvailable) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // 快捷输入按钮
          IconButton(
            onPressed: () => _showQuickInputOptions(),
            icon: const Icon(Icons.add_circle_outline),
            color: Theme.of(context).primaryColor,
          ),
          
          // 文本输入框
          Expanded(
            child: TextField(
              controller: _messageController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: _getInputHint(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _sendMessage(value);
                }
              },
            ),
          ),
          
          const SizedBox(width: 8),
          
          // 发送按钮
          IconButton(
            onPressed: (_isLoading || !isServiceAvailable) ? null : () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                _sendMessage(message);
              }
            },
            icon: _isLoading 
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  String _getInputHint() {
    switch (_selectedAssistantType) {
      case 'nutrition_plan':
        return '描述客户情况，我来生成营养方案...';
      case 'consultation_reply':
        return '输入客户问题，我来起草回复...';
      case 'diet_analysis':
        return '输入饮食记录，我来分析...';
      case 'recipe_generator':
        return '描述需求，我来生成食谱...';
      default:
        return '请输入您的问题...';
    }
  }

  void _onAssistantTypeChanged() {
    String message;
    switch (_selectedAssistantType) {
      case 'nutrition_plan':
        message = '已切换到营养方案助手模式。请描述客户的基本情况（年龄、性别、身高体重、健康状况、营养目标等），我将为您生成个性化的营养方案。';
        break;
      case 'consultation_reply':
        message = '已切换到咨询回复助手模式。请提供客户的问题或咨询内容，我将帮您起草专业的回复。';
        break;
      case 'diet_analysis':
        message = '已切换到饮食分析助手模式。请提供客户的饮食记录，我将分析其营养状况并给出改善建议。';
        break;
      case 'recipe_generator':
        message = '已切换到食谱生成助手模式。请告诉我营养需求、食材偏好、烹饪难度等要求，我将为您生成合适的食谱。';
        break;
      default:
        message = '助手模式已切换，请告诉我您的需求。';
    }
    
    _addAIMessage(message, 'mode_switch');
  }

  void _sendMessage(String content) {
    // 添加用户消息
    setState(() {
      _messages.add(AIMessage(
        content: content,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _messageController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    // 使用真实AI服务或模拟回复
    _generateAIResponse(content);
  }

  void _generateAIResponse(String userMessage) async {
    try {
      // 检查是否使用流式聊天
      final streamingAvailable = ref.read(streamingChatAvailableProvider);
      
      if (streamingAvailable) {
        await _generateStreamingResponse(userMessage);
      } else {
        await _generateStaticResponse(userMessage);
      }
    } catch (e) {
      _addAIMessage('抱歉，AI服务出现错误：$e', 'error');
    }
  }

  Future<void> _generateStreamingResponse(String userMessage) async {
    final chatStreamGenerator = ref.read(aiChatStreamProvider);
    final assistantType = _getAIAssistantType();
    
    // 准备聊天历史
    final chatMessages = _messages.map((msg) => ChatMessage(
      content: msg.content,
      isUser: msg.isUser,
      timestamp: msg.timestamp,
      messageType: msg.messageType,
    )).toList();
    
    // 开始流式响应
    final stream = chatStreamGenerator(
      messages: chatMessages,
      assistantType: assistantType,
    );
    
    String accumulatedResponse = '';
    bool isFirstChunk = true;
    
    await for (final chunk in stream) {
      if (isFirstChunk) {
        // 添加第一个响应消息
        setState(() {
          _messages.add(AIMessage(
            content: chunk,
            isUser: false,
            timestamp: DateTime.now(),
            messageType: _getMessageTypeForAssistant(assistantType),
          ));
          _isLoading = false;
        });
        accumulatedResponse = chunk;
        isFirstChunk = false;
      } else {
        // 更新最后一条消息
        accumulatedResponse += chunk;
        setState(() {
          if (_messages.isNotEmpty && !_messages.last.isUser) {
            _messages.last = AIMessage(
              content: accumulatedResponse,
              isUser: false,
              timestamp: _messages.last.timestamp,
              messageType: _messages.last.messageType,
            );
          }
        });
      }
      _scrollToBottom();
    }
  }

  Future<void> _generateStaticResponse(String userMessage) async {
    final assistantType = _getAIAssistantType();
    
    switch (assistantType) {
      case AIAssistantType.nutritionPlan:
        await _generateNutritionPlanResponse(userMessage);
        break;
      case AIAssistantType.consultationReply:
        await _generateConsultationReplyResponse(userMessage);
        break;
      case AIAssistantType.dietAnalysis:
        await _generateDietAnalysisResponse(userMessage);
        break;
      case AIAssistantType.recipeGenerator:
        await _generateRecipeResponse(userMessage);
        break;
      default:
        _generateGeneralResponse(userMessage);
    }
  }

  Future<void> _generateNutritionPlanResponse(String userMessage) async {
    final generator = ref.read(nutritionPlanGeneratorProvider);
    
    // 从用户消息中解析客户信息（简化实现）
    final clientInfo = _parseClientInfoFromMessage(userMessage);
    final nutritionGoals = _parseNutritionGoalsFromMessage(userMessage);
    
    final response = await generator(
      clientInfo: clientInfo,
      nutritionGoals: nutritionGoals,
    );
    
    if (response.success && response.plan != null) {
      final plan = response.plan!;
      final formattedResponse = _formatNutritionPlan(plan);
      _addAIMessage(formattedResponse, 'nutrition_plan');
    } else {
      _addAIMessage('抱歉，营养方案生成失败：${response.error}', 'error');
    }
  }

  Future<void> _generateConsultationReplyResponse(String userMessage) async {
    final generator = ref.read(consultationReplyGeneratorProvider);
    
    final response = await generator(
      question: userMessage,
      context: _getConversationContext(),
    );
    
    if (response.success && response.reply != null) {
      _addAIMessage(response.reply!, 'consultation_reply');
    } else {
      _addAIMessage('抱歉，咨询回复生成失败：${response.error}', 'error');
    }
  }

  Future<void> _generateDietAnalysisResponse(String userMessage) async {
    final analyzer = ref.read(dietAnalyzerProvider);
    
    // 从用户消息中解析饮食记录（简化实现）
    final foodRecords = _parseFoodRecordsFromMessage(userMessage);
    
    final response = await analyzer(
      foodRecords: foodRecords,
      analysisType: DietAnalysisType.comprehensive,
    );
    
    if (response.success && response.analysis != null) {
      final analysis = response.analysis!;
      final formattedResponse = _formatDietAnalysis(analysis);
      _addAIMessage(formattedResponse, 'diet_analysis');
    } else {
      _addAIMessage('抱歉，饮食分析失败：${response.error}', 'error');
    }
  }

  Future<void> _generateRecipeResponse(String userMessage) async {
    final generator = ref.read(recipeGeneratorProvider);
    
    // 从用户消息中解析食谱要求（简化实现）
    final requirements = _parseRecipeRequirementsFromMessage(userMessage);
    
    final response = await generator(requirements: requirements);
    
    if (response.success && response.recipe != null) {
      final recipe = response.recipe!;
      final formattedResponse = _formatRecipe(recipe);
      _addAIMessage(formattedResponse, 'recipe');
    } else {
      _addAIMessage('抱歉，食谱生成失败：${response.error}', 'error');
    }
  }

  void _generateGeneralResponse(String userMessage) async {
    // 如果没有专门的AI服务，回退到模拟响应
    _simulateAIResponse(userMessage);
  }

  void _simulateAIResponse(String userMessage) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 2));

    String response;
    String messageType = 'text';

    switch (_selectedAssistantType) {
      case 'nutrition_plan':
        response = _generateMockNutritionPlanResponse(userMessage);
        messageType = 'nutrition_plan';
        break;
      case 'consultation_reply':
        response = _generateMockConsultationReplyResponse(userMessage);
        break;
      case 'diet_analysis':
        response = _generateMockDietAnalysisResponse(userMessage);
        break;
      case 'recipe_generator':
        response = _generateMockRecipeResponse(userMessage);
        messageType = 'recipe';
        break;
      default:
        response = '感谢您的问题，我正在学习如何更好地帮助您。';
    }

    _addAIMessage(response, messageType);
  }

  void _addAIMessage(String content, String messageType) {
    if (mounted) {
      setState(() {
        _messages.add(AIMessage(
          content: content,
          isUser: false,
          timestamp: DateTime.now(),
          messageType: messageType,
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  String _generateMockNutritionPlanResponse(String userMessage) {
    return '''基于您提供的信息，我为您制定了以下营养方案：

**每日营养目标：**
• 总热量：1800-2000 kcal
• 蛋白质：15-20%（135-150g）
• 脂肪：25-30%（50-67g）
• 碳水化合物：50-60%（225-300g）

**三餐分配建议：**

🌅 **早餐（30%）**
• 燕麦粥 + 坚果 + 水果
• 脱脂牛奶或豆浆
• 煮蛋1个

🌞 **午餐（40%）**
• 瘦肉/鱼肉100g
• 蔬菜200g
• 糙米/全麦面100g

🌙 **晚餐（30%）**
• 蒸蛋羹或豆腐
• 绿叶蔬菜150g
• 少量主食

**注意事项：**
• 每日饮水1500-2000ml
• 适量运动配合
• 定期监测体重变化

这个方案需要根据实际执行情况进行调整。''';
  }

  String _generateMockConsultationReplyResponse(String userMessage) {
    return '''针对客户的咨询，我建议您这样回复：

感谢您的信任和详细描述。根据您的情况，我建议：

1. **immediate建议**：
   - 先调整饮食结构，减少精制食品摄入
   - 增加优质蛋白质和膳食纤维

2. **具体方案**：
   - 我将为您制定个性化的营养计划
   - 包含详细的食物选择和搭配

3. **后续跟进**：
   - 建议每周跟进一次执行情况
   - 根据反馈及时调整方案

如果您方便的话，我们可以进一步讨论具体的执行细节。您看这个时间安排如何？

（建议：语气专业但亲切，体现专业性的同时让客户感到被关心）''';
  }

  String _generateMockDietAnalysisResponse(String userMessage) {
    return '''**饮食分析报告：**

📊 **营养摄入评估**
• 总热量：偏高（建议减少200-300kcal）
• 蛋白质：充足
• 脂肪：偏高（特别是饱和脂肪）
• 碳水化合物：比例合理

⚠️ **主要问题**
1. 精制糖摄入过多
2. 深加工食品比例高
3. 蔬菜摄入不足
4. 优质脂肪来源少

✅ **改善建议**
• 增加绿叶蔬菜至每日300g
• 用坚果、橄榄油替代部分饱和脂肪
• 减少甜食和含糖饮料
• 增加全谷物食品

📈 **预期效果**
按照建议调整后，预计2-4周可见明显改善。''';
  }

  String _generateMockRecipeResponse(String userMessage) {
    return '''🍽️ **推荐食谱：彩虹蔬菜蛋白碗**

**食材（1人份）：**
• 鸡胸肉 100g
• 西兰花 80g
• 胡萝卜 50g
• 紫甘蓝 50g
• 糙米饭 80g
• 牛油果 1/4个
• 橄榄油 1茶匙

**制作步骤：**
1. 鸡胸肉用少量盐和黑胡椒腌制
2. 平底锅少油煎制鸡胸肉
3. 蔬菜分别焯水保持脆嫩
4. 糙米饭打底，摆放蔬菜和蛋白质
5. 淋上橄榄油和柠檬汁

**营养价值：**
• 热量：约450kcal
• 蛋白质：35g
• 膳食纤维：8g
• 维生素C丰富

**特点：**
营养均衡、色彩丰富、制作简单，适合忙碌的现代人。''';
  }

  void _showQuickInputOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '快捷输入',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildQuickInputOption('制定减肥方案', '帮我为25岁女性，160cm，65kg，目标减重至55kg制定营养方案'),
            _buildQuickInputOption('糖尿病饮食指导', '糖尿病患者日常饮食需要注意什么？'),
            _buildQuickInputOption('孕期营养建议', '怀孕16周需要补充哪些营养素？'),
            _buildQuickInputOption('儿童营养搭配', '5岁儿童每日营养需求和食谱推荐'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInputOption(String title, String content) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        _messageController.text = content;
      },
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  // 操作方法
  void _shareNutritionPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('营养方案已分享给客户')),
    );
  }

  void _saveNutritionPlan() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('营养方案已保存')),
    );
  }

  void _addToRecipeLibrary() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('食谱已添加到食谱库')),
    );
  }

  // AI服务相关辅助方法
  
  void _showServiceSettings() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildServiceSettingsSheet(),
    );
  }

  void _retryConnection() async {
    final switcher = ref.read(aiServiceSwitchProvider.notifier);
    await switcher.reloadCurrentService();
  }

  Widget _buildServiceSettingsSheet() {
    return Consumer(
      builder: (context, ref, child) {
        final serviceInfoListAsync = ref.watch(aiServiceInfoListProvider);
        
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI服务设置',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              serviceInfoListAsync.when(
                data: (serviceInfoList) => Column(
                  children: serviceInfoList.map((info) => ListTile(
                    leading: Icon(
                      info.isActive ? Icons.check_circle : Icons.circle_outlined,
                      color: info.isActive ? Colors.green : Colors.grey,
                    ),
                    title: Text(info.displayName),
                    subtitle: Text('${info.description} - ${info.statusText}'),
                    trailing: info.isAvailable 
                        ? (info.isActive ? null : TextButton(
                            onPressed: () => _switchToService(info.name),
                            child: const Text('切换'),
                          ))
                        : Icon(Icons.error, color: Colors.red),
                    onTap: info.isAvailable && !info.isActive
                        ? () => _switchToService(info.name)
                        : null,
                  )).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('加载失败: $error'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('关闭'),
                  ),
                  ElevatedButton(
                    onPressed: () => _refreshServiceList(),
                    child: const Text('刷新'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _switchToService(String serviceName) async {
    Navigator.pop(context); // 关闭设置面板
    
    final switcher = ref.read(aiServiceSwitchProvider.notifier);
    await switcher.switchToProvider(serviceName);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已切换到 $serviceName')),
      );
    }
  }

  void _refreshServiceList() {
    ref.refresh(aiServiceInfoListProvider);
  }

  // 数据解析和格式化方法

  AIAssistantType _getAIAssistantType() {
    switch (_selectedAssistantType) {
      case 'nutrition_plan':
        return AIAssistantType.nutritionPlan;
      case 'consultation_reply':
        return AIAssistantType.consultationReply;
      case 'diet_analysis':
        return AIAssistantType.dietAnalysis;
      case 'recipe_generator':
        return AIAssistantType.recipeGenerator;
      default:
        return AIAssistantType.general;
    }
  }

  String _getMessageTypeForAssistant(AIAssistantType assistantType) {
    switch (assistantType) {
      case AIAssistantType.nutritionPlan:
        return 'nutrition_plan';
      case AIAssistantType.consultationReply:
        return 'consultation_reply';
      case AIAssistantType.dietAnalysis:
        return 'diet_analysis';
      case AIAssistantType.recipeGenerator:
        return 'recipe';
      default:
        return 'text';
    }
  }

  String _getConversationContext() {
    // 获取最近几条消息作为上下文
    final recentMessages = _messages.length > 5 
        ? _messages.sublist(_messages.length - 5)
        : _messages;
    return recentMessages
        .map((msg) => '${msg.isUser ? "用户" : "营养师"}: ${msg.content}')
        .join('\n');
  }

  // 简化的数据解析方法（实际应用中可能需要更复杂的NLP解析）
  
  ClientInfo _parseClientInfoFromMessage(String message) {
    // 简化实现：提取基本信息
    return ClientInfo(
      age: 30, // 可以从消息中解析
      gender: 'female',
      height: 165.0,
      weight: 60.0,
      activityLevel: 'moderate',
    );
  }

  NutritionGoals _parseNutritionGoalsFromMessage(String message) {
    // 简化实现：根据消息内容推断目标
    String primaryGoal = 'health_maintenance';
    if (message.contains('减肥') || message.contains('减重')) {
      primaryGoal = 'weight_loss';
    } else if (message.contains('增重') || message.contains('增肌')) {
      primaryGoal = 'weight_gain';
    }
    
    return NutritionGoals(primaryGoal: primaryGoal);
  }

  List<FoodRecord> _parseFoodRecordsFromMessage(String message) {
    // 简化实现：创建示例饮食记录
    return [
      FoodRecord(
        id: '1',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        mealType: 'lunch',
        foods: [
          FoodItem(name: '米饭', quantity: 100, unit: 'g'),
          FoodItem(name: '鸡胸肉', quantity: 80, unit: 'g'),
          FoodItem(name: '西兰花', quantity: 150, unit: 'g'),
        ],
      ),
    ];
  }

  RecipeRequirements _parseRecipeRequirementsFromMessage(String message) {
    // 简化实现：根据消息内容解析要求
    return RecipeRequirements(
      mealType: 'dinner',
      servings: 2,
      difficulty: 'easy',
      preparationTime: 30,
    );
  }

  // 格式化方法

  String _formatNutritionPlan(NutritionPlan plan) {
    final buffer = StringBuffer();
    buffer.writeln('🥗 **${plan.title}**');
    buffer.writeln(plan.description);
    buffer.writeln('\n**每日营养目标：**');
    
    plan.dailyNutritionTargets.forEach((key, value) {
      buffer.writeln('• $key: ${value.toStringAsFixed(1)}${_getNutritionUnit(key)}');
    });
    
    buffer.writeln('\n**餐食安排：**');
    for (final meal in plan.mealPlans) {
      buffer.writeln('\n🍽️ **${meal.mealType}**');
      buffer.writeln('${meal.description}');
      buffer.writeln('食物：${meal.foods.join(', ')}');
    }
    
    if (plan.recommendations.isNotEmpty) {
      buffer.writeln('\n**建议：**');
      for (final rec in plan.recommendations) {
        buffer.writeln('• $rec');
      }
    }
    
    return buffer.toString();
  }

  String _formatDietAnalysis(DietAnalysis analysis) {
    final buffer = StringBuffer();
    buffer.writeln('📊 **饮食分析报告**');
    
    buffer.writeln('**营养摄入总结：**');
    analysis.nutritionSummary.forEach((key, value) {
      buffer.writeln('• $key: ${value.toStringAsFixed(1)}${_getNutritionUnit(key)}');
    });
    
    if (analysis.strengths.isNotEmpty) {
      buffer.writeln('\n✅ **优点：**');
      for (final strength in analysis.strengths) {
        buffer.writeln('• $strength');
      }
    }
    
    if (analysis.weaknesses.isNotEmpty) {
      buffer.writeln('\n⚠️ **需要改善：**');
      for (final weakness in analysis.weaknesses) {
        buffer.writeln('• $weakness');
      }
    }
    
    if (analysis.recommendations.isNotEmpty) {
      buffer.writeln('\n💡 **建议：**');
      for (final rec in analysis.recommendations) {
        buffer.writeln('• $rec');
      }
    }
    
    return buffer.toString();
  }

  String _formatRecipe(Recipe recipe) {
    final buffer = StringBuffer();
    buffer.writeln('🍽️ **${recipe.name}**');
    buffer.writeln(recipe.description);
    
    buffer.writeln('\n**食材：**');
    for (final ingredient in recipe.ingredients) {
      buffer.writeln('• ${ingredient.name} ${ingredient.quantity}${ingredient.unit}');
    }
    
    buffer.writeln('\n**制作步骤：**');
    for (int i = 0; i < recipe.instructions.length; i++) {
      buffer.writeln('${i + 1}. ${recipe.instructions[i]}');
    }
    
    buffer.writeln('\n**营养信息：**');
    recipe.nutrition.forEach((key, value) {
      buffer.writeln('• $key: ${value.toStringAsFixed(1)}${_getNutritionUnit(key)}');
    });
    
    buffer.writeln('\n⏱️ 准备时间：${recipe.preparationTime}分钟');
    buffer.writeln('👨‍🍳 烹饪时间：${recipe.cookingTime}分钟');
    buffer.writeln('👥 份量：${recipe.servings}人份');
    buffer.writeln('📚 难度：${recipe.difficulty}');
    
    return buffer.toString();
  }

  String _getNutritionUnit(String nutrientKey) {
    switch (nutrientKey.toLowerCase()) {
      case 'calories':
      case 'total_calories':
        return 'kcal';
      case 'protein':
      case 'fat':
      case 'carbs':
      case 'fiber':
        return 'g';
      case 'sodium':
        return 'mg';
      case 'water':
        return 'ml';
      default:
        return '';
    }
  }
}

/// AI消息数据模型
class AIMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String messageType;

  AIMessage({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.messageType = 'text',
  });
}