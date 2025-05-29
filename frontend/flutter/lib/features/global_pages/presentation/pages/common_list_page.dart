import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/common_provider.dart';

/// Ucommon列表页面
@RoutePage()
class UcommonListPage extends ConsumerStatefulWidget {
  const UcommonListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UcommonListPage> createState() => _UcommonListPageState();
}

class _UcommonListPageState extends ConsumerState<UcommonListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(commonProvider.notifier).loadUcommons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commonProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ucommon列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (commons) => ListView.builder(
          itemCount: commons.length,
          itemBuilder: (context, index) {
            final common = commons[index];
            return ListTile(
              title: Text(common.id),
              subtitle: Text('创建于: ${common.createdAt}'),
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
                  ref.read(commonProvider.notifier).loadUcommons();
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
