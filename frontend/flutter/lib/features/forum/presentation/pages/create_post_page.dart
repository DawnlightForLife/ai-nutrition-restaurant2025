import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostPage extends ConsumerWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发布帖子'),
      ),
      body: const Center(
        child: Text(
          '发布帖子页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
