import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/merchant_provider.dart';

/// Umerchant列表页面
class UmerchantListPage extends ConsumerStatefulWidget {
  const UmerchantListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UmerchantListPage> createState() => _UmerchantListPageState();
}

class _UmerchantListPageState extends ConsumerState<UmerchantListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(merchantProvider.notifier).loadUmerchants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Umerchant列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (merchants) => ListView.builder(
          itemCount: merchants.length,
          itemBuilder: (context, index) {
            final merchant = merchants[index];
            return ListTile(
              title: Text(merchant.id),
              subtitle: Text('创建于: ${merchant.createdAt}'),
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
                  ref.read(merchantProvider.notifier).loadUmerchants();
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
