import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/order_provider.dart';

/// Uorder列表页面
@RoutePage()
class UorderListPage extends ConsumerStatefulWidget {
  const UorderListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UorderListPage> createState() => _UorderListPageState();
}

class _UorderListPageState extends ConsumerState<UorderListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderProvider.notifier).loadUorders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uorder列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (orders) => ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return ListTile(
              title: Text(order.id),
              subtitle: Text('创建于: ${order.createdAt}'),
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
                  ref.read(orderProvider.notifier).loadUorders();
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
