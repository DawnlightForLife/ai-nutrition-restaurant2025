import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'coordinator_manager.dart';

/// Coordinator 使用示例
/// 展示如何在实际页面中使用 Coordinator 处理业务流程

// 示例1：登录页面使用 AuthFlowCoordinator
class LoginPageExample extends ConsumerWidget {
  const LoginPageExample({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // 获取 Coordinator
            final coordinator = ref.read(coordinatorManagerProvider).auth;
            
            // 模拟登录成功
            final mockUser = AuthUser(
              id: '123',
              phone: '13800138000',
              accessToken: 'token',
              refreshToken: 'refresh',
            );
            
            // 使用 Coordinator 处理登录后的流程
            final result = await coordinator.handleLoginSuccess(mockUser);
            
            // 处理结果
            result.when(
              success: (data, message) {
                // 登录流程成功完成
                if (message != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message)),
                  );
                }
              },
              failure: (error, code) {
                // 处理错误
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              cancelled: () {
                // 用户取消了流程
              },
            );
          },
          child: const Text('登录'),
        ),
      ),
    );
  }
}

// 示例2：营养档案页面使用 NutritionFlowCoordinator
class NutritionProfilePageExample extends ConsumerWidget {
  final NutritionProfile profile;
  
  const NutritionProfilePageExample({
    Key? key,
    required this.profile,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('营养档案'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // 获取 Coordinator
              final coordinator = ref.read(coordinatorManagerProvider).nutrition;
              
              // 处理档案删除流程
              final result = await coordinator.handleProfileDeletion(profile.id);
              
              result.when(
                success: (_) {
                  // 删除成功，页面会自动导航
                },
                failure: (error, _) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
                cancelled: () {
                  // 用户取消了删除
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 档案内容...
          
          ElevatedButton(
            onPressed: () async {
              // 使用 Coordinator 处理创建完成后的流程
              final coordinator = ref.read(coordinatorManagerProvider).nutrition;
              await coordinator.handleProfileCreationSuccess(profile);
            },
            child: const Text('获取AI推荐'),
          ),
        ],
      ),
    );
  }
}

// 示例3：订单页面使用 OrderFlowCoordinator
class OrderPageExample extends ConsumerWidget {
  final String orderId;
  
  const OrderPageExample({
    Key? key,
    required this.orderId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('订单详情')),
      body: Column(
        children: [
          // 订单内容...
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final coordinator = ref.read(coordinatorManagerProvider).order;
                  
                  // 处理支付流程
                  final result = await coordinator.handleOrderPayment(orderId);
                  
                  if (result is Failure) {
                    // 显示错误
                  }
                },
                child: const Text('去支付'),
              ),
              
              TextButton(
                onPressed: () async {
                  final coordinator = ref.read(coordinatorManagerProvider).order;
                  
                  // 处理取消流程
                  await coordinator.handleOrderCancellation(orderId);
                },
                child: const Text('取消订单'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 示例4：直接在 Provider 中使用 Coordinator
final someBusinessLogicProvider = Provider((ref) {
  return SomeBusinessLogic(ref);
});

class SomeBusinessLogic {
  final Ref ref;
  
  SomeBusinessLogic(this.ref);
  
  Future<void> processAfterProfileCreation(NutritionProfile profile) async {
    // 获取 Coordinator
    final nutritionCoordinator = ref.read(coordinatorManagerProvider).nutrition;
    
    // 处理档案创建后的流程
    final result = await nutritionCoordinator.handleProfileCreationSuccess(profile);
    
    // 根据结果进行其他业务处理
    result.when(
      success: (_) {
        // 继续其他业务逻辑
      },
      failure: (error, _) {
        // 错误处理
      },
      cancelled: () {
        // 用户取消
      },
    );
  }
}