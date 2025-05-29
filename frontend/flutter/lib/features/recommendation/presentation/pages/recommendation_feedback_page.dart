import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationFeedbackPage extends ConsumerWidget {
  const RecommendationFeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐反馈'),
      ),
      body: const Center(
        child: Text(
          '推荐反馈页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
