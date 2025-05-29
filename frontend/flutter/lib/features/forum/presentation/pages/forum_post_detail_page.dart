import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumPostDetailPage extends ConsumerWidget {
  const ForumPostDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子详情'),
      ),
      body: const Center(
        child: Text(
          '帖子详情页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
