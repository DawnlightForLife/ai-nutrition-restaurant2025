import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/forum_provider.dart';

/// Uforum列表页面
@RoutePage()
class UforumListPage extends ConsumerStatefulWidget {
  const UforumListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UforumListPage> createState() => _UforumListPageState();
}

class _UforumListPageState extends ConsumerState<UforumListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(forumProvider.notifier).loadUforums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(forumProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uforum列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (forums) => ListView.builder(
          itemCount: forums.length,
          itemBuilder: (context, index) {
            final forum = forums[index];
            return ListTile(
              title: Text(forum.id),
              subtitle: Text('创建于: ${forum.createdAt}'),
            );
          },
        ),
        error: (message) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('错误: $message'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(forumProvider.notifier).loadUforums();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
