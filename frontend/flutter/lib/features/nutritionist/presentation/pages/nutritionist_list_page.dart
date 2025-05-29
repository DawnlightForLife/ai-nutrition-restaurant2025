import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/nutritionist_provider.dart';

/// Unutritionist列表页面
@RoutePage()
class UnutritionistListPage extends ConsumerStatefulWidget {
  const UnutritionistListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UnutritionistListPage> createState() => _UnutritionistListPageState();
}

class _UnutritionistListPageState extends ConsumerState<UnutritionistListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nutritionistProvider.notifier).loadUnutritionists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(nutritionistProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Unutritionist列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (nutritionists) => ListView.builder(
          itemCount: nutritionists.length,
          itemBuilder: (context, index) {
            final nutritionist = nutritionists[index];
            return ListTile(
              title: Text(nutritionist.id),
              subtitle: Text('创建于: ${nutritionist.createdAt}'),
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
                  ref.read(nutritionistProvider.notifier).loadUnutritionists();
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
