import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;

import 'providers/core/auth_provider.dart';
import 'services/core/auth_service.dart';
import 'services/api_service.dart';
import 'utils/global_error_handler.dart';
import 'router/app_routes.dart';

/// 波浪动画画笔
class _WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double waveHeight;

  _WavePainter(this.animation, this.color, this.waveHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final y = size.height * 0.75;
    
    path.moveTo(0, y);
    for (double x = 0; x < size.width; x++) {
      path.lineTo(
        x,
        y + math.sin((x / size.width * 2 * math.pi) + animation.value * 2 * math.pi) * waveHeight,
      );
    }
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => true;
}

/// 启动屏幕
///
/// 应用启动时显示，同时检查用户登录状态
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _isChecking = false;
  String _statusText = '正在启动';
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    
    // 动画控制器
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 缩放动画
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // 淡入动画
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // 确保动画在下一帧开始
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward().then((_) {
        _checkAuthStatus();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 检查用户登录状态并导航到相应页面
  Future<void> _checkAuthStatus() async {
    if (_isChecking) return;
    _isChecking = true;
    
    try {
      if (!mounted) return;
      
      setState(() {
        _statusText = '正在验证身份...';
      });

      // 获取服务
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // 检查是否已经登录（带token验证）
      final isAuthenticated = await authProvider.checkAuth(authService: authService);
      
      if (!mounted) return;
      
      setState(() {
        _statusText = isAuthenticated ? '正在加载主页...' : '正在加载登录页...';
      });

      // 给用户一点时间看到状态变化
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      
      // 准备页面跳转动画
      await _controller.reverse();
      
      if (!mounted) return;
      
      // 根据登录状态导航到相应页面
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusText = '连接服务器失败，请检查网络';
          _showError = true;
        });
        
        // 3秒后重试
        await Future.delayed(const Duration(seconds: 3));
        
        if (mounted) {
          setState(() {
            _showError = false;
            _statusText = '正在重试...';
          });
          
          // 重试一次
          _checkAuthStatus();
        }
      }
    } finally {
      _isChecking = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.green.shade400,
              Colors.green.shade50,
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo动画
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 应用名称
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: const Text(
                      'AI营养餐厅',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // 状态文本
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      _statusText,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 加载指示器或错误按钮
                  Opacity(
                    opacity: _fadeAnimation.value,
                    child: _showError
                        ? TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showError = false;
                                _statusText = '正在重试...';
                              });
                              _checkAuthStatus();
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                            ),
                            label: const Text(
                              '点击重试',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
