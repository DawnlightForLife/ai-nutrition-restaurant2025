import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumPostListPage extends ConsumerWidget {
  const ForumPostListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子列表'),
      ),
      body: const Center(
        child: Text(
          '帖子列表页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
