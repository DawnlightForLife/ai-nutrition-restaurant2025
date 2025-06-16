import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../../../theme/app_colors.dart';
import '../../../../routes/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  late AnimationController _cubeController;
  late AnimationController _textController;
  late Animation<double> _cubeAnimation;
  late Animation<double> _textAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // 设置全屏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    
    // 立方体旋转动画
    _cubeController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _cubeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cubeController,
      curve: Curves.easeInOut,
    ));
    
    // 文字动画
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _textAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
    ));
    
    // 启动动画
    _cubeController.repeat();
    _textController.forward();
    
    // 3.5秒后检查登录状态并跳转
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  /// 检查认证状态并导航
  Future<void> _checkAuthAndNavigate() async {
    try {
      // 等待认证状态初始化完成，给更多时间
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final authState = ref.read(authStateProvider);
      
      print('=== Splash页面认证状态检查 ===');
      print('isAuthenticated: ${authState.isAuthenticated}');
      print('user: ${authState.user?.name}');
      print('token: ${authState.token != null ? "存在" : "不存在"}');
      print('isLoading: ${authState.isLoading}');
      print('error: ${authState.error}');
      
      // 检查是否已认证
      if (authState.isAuthenticated && authState.user != null && authState.token != null) {
        print('✅ 用户已登录，跳转到主页');
        _navigateToMainPage();
      } else {
        print('❌ 用户未登录，跳转到登录页');
        _navigateToLoginPage();
      }
    } catch (e) {
      print('❌ 检查认证状态失败: $e');
      // 发生错误时默认跳转到登录页
      _navigateToLoginPage();
    }
  }

  /// 跳转到主页
  void _navigateToMainPage() {
    Navigator.pushReplacementNamed(context, RouteNames.main);
  }

  /// 跳转到登录页
  void _navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  void dispose() {
    // 恢复系统UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _cubeController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryOrange.withOpacity(0.8),
              AppColors.secondaryGreen.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 营养立方体动画
                AnimatedBuilder(
                  animation: _cubeAnimation,
                  builder: (context, child) {
                    return Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(_cubeAnimation.value * 6.28)
                        ..rotateX(_cubeAnimation.value * 0.5),
                      child: _buildNutritionCube(),
                    );
                  },
                ),
                const SizedBox(height: 60),
                // 品牌名称
                FadeTransition(
                  opacity: _textAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_textAnimation),
                    child: Column(
                      children: [
                        const Text(
                          '营养立方',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: const Text(
                            'AI 智能营养管理专家',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCube() {
    return Container(
      width: 120,
      height: 120,
      child: Stack(
        children: [
          // 立方体的各个面
          Positioned(
            left: 20,
            top: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      size: 32,
                      color: AppColors.primaryOrange,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '营养',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // 侧面效果
          Positioned(
            left: 10,
            top: 10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.secondaryGreen.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            left: 30,
            top: 30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}