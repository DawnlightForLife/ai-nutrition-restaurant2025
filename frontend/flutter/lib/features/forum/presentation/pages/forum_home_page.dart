import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForumHomePage extends ConsumerWidget {
  const ForumHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('论坛首页'),
      ),
      body: const Center(
        child: Text(
          '论坛首页',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
