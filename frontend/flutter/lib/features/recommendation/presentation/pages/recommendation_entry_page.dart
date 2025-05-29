import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';

/// 推荐入口页面
/// 
/// 用户进入推荐系统的入口页面
@RoutePage()
class RecommendationEntryPage extends ConsumerStatefulWidget {
  const RecommendationEntryPage({super.key});

  @override
  ConsumerState<RecommendationEntryPage> createState() =>
      _RecommendationEntryPageState();
}

class _RecommendationEntryPageState 
    extends ConsumerState<RecommendationEntryPage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI推荐'),
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.recommend,
              size: 64,
              color: Colors.orange,
            ),
            SizedBox(height: 16),
            Text(
              '推荐入口页面',
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