import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

/// Uadmin列表页面
class UadminListPage extends ConsumerStatefulWidget {
  const UadminListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UadminListPage> createState() => _UadminListPageState();
}

class _UadminListPageState extends ConsumerState<UadminListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminProvider.notifier).loadUadmins();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uadmin列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (admins) => ListView.builder(
          itemCount: admins.length,
          itemBuilder: (context, index) {
            final admin = admins[index];
            return ListTile(
              title: Text(admin.id),
              subtitle: Text('创建于: ${admin.createdAt}'),
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
                  ref.read(adminProvider.notifier).loadUadmins();
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
