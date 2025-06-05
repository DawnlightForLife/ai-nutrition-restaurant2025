import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AI推荐聊天页面
/// 
/// 用户与AI进行对话获取个性化推荐的页面
class AiRecommendationChatPage extends ConsumerStatefulWidget {
  const AiRecommendationChatPage({super.key});

  @override
  ConsumerState<AiRecommendationChatPage> createState() =>
      _AiRecommendationChatPageState();
}

class _AiRecommendationChatPageState 
    extends ConsumerState<AiRecommendationChatPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI营养推荐'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.smart_toy,
              size: 64,
              color: Colors.blue,
            ),
            SizedBox(height: 16),
            Text(
              'AI推荐聊天页面',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '功能开发中...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}