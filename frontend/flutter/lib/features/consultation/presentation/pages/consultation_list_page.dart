import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../providers/consultation_provider.dart';

/// Uconsultation列表页面
@RoutePage()
class UconsultationListPage extends ConsumerStatefulWidget {
  const UconsultationListPage({Key? key}) : super(key: key);

  @override
  ConsumerState<UconsultationListPage> createState() => _UconsultationListPageState();
}

class _UconsultationListPageState extends ConsumerState<UconsultationListPage> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(consultationProvider.notifier).loadUconsultations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consultationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uconsultation列表'),
      ),
      body: state.when(
        initial: () => const Center(child: Text('准备加载...')),
        loading: () => const Center(child: CircularProgressIndicator()),
        loaded: (consultations) => ListView.builder(
          itemCount: consultations.length,
          itemBuilder: (context, index) {
            final consultation = consultations[index];
            return ListTile(
              title: Text(consultation.id),
              subtitle: Text('创建于: ${consultation.createdAt}'),
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
                  ref.read(consultationProvider.notifier).loadUconsultations();
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
