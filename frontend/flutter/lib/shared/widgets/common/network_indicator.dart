import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/network_monitor.dart';

/// 网络状态横幅
/// 
/// 在屏幕顶部显示网络连接状态的横幅
class NetworkBanner extends ConsumerWidget {
  final Widget child;

  const NetworkBanner({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final networkStatus = ref.watch(networkStatusProvider);
    
    return Stack(
      children: [
        child,
        networkStatus.when(
          data: (status) {
            if (!status.hasInternet) {
              return const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _OfflineBanner(),
              );
            }
            return const SizedBox.shrink();
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

/// 离线状态横幅
class _OfflineBanner extends StatelessWidget {
  const _OfflineBanner();

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      color: Colors.red,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.wifi_off,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '网络连接已断开，部分功能可能无法正常使用',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}