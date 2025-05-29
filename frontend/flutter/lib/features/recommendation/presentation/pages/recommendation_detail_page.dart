import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecommendationDetailPage extends ConsumerWidget {
  const RecommendationDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('推荐详情'),
      ),
      body: const Center(
        child: Text(
          '推荐详情页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
