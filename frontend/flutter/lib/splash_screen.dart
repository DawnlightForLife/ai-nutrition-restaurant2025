import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math' as math;

import 'providers/core/auth_provider.dart';
import 'services/core/auth_service.dart';
import 'services/core/api_service.dart';
import 'utils/global_error_handler.dart';
import 'router/app_routes.dart';

/**
 * 波浪动画画笔
 * 
 * 自定义画笔，用于绘制底部的波浪动画效果。
 * 通过传入的animation参数控制波浪的移动，通过color参数控制波浪的颜色，
 * 通过waveHeight参数控制波浪的高度。
 */
class _WavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final double waveHeight;

  _WavePainter(this.animation, this.color, this.waveHeight);

  /**
   * 绘制波浪
   * 
   * @param canvas 画布，用于绘制图形
   * @param size 可用的绘制区域大小
   */
  @override
  void paint(Canvas canvas, Size size) {
    // 初始化画笔
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 创建路径
    final path = Path();
    // 波浪的基线位置，设置在画布高度的3/4处
    final y = size.height * 0.75;
    
    // 波浪起点
    path.moveTo(0, y);
    
    // 使用正弦函数绘制波浪线
    for (double x = 0; x < size.width; x++) {
      path.lineTo(
        x,
        // y + sin(当前位置在波长中的比例 * 2π + 动画值 * 2π) * 波高
        y + math.sin((x / size.width * 2 * math.pi) + animation.value * 2 * math.pi) * waveHeight,
      );
    }
    
    // 完成路径，确保填充整个底部区域
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    // 在画布上绘制路径
    canvas.drawPath(path, paint);
  }

  /**
   * 决定是否需要重绘
   * 
   * 由于波浪动画需要连续更新，所以总是返回true
   * 
   * @param oldDelegate 上一次使用的画笔
   * @return 是否需要重绘
   */
  @override
  bool shouldRepaint(_WavePainter oldDelegate) => true;
}

/**
 * 启动屏幕
 *
 * 应用启动时显示的第一个屏幕，包含品牌标识和加载动画。
 * 同时负责检查用户登录状态，并根据状态导航到相应页面。
 */
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/**
 * 启动屏幕状态管理类
 * 
 * 管理启动屏幕的动画和状态检查流程
 */
class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // 动画控制器，用于管理所有动画
  late AnimationController _controller;
  // 缩放动画，用于Logo的缩放效果
  late Animation<double> _scaleAnimation;
  // 淡入动画，用于文字的淡入效果
  late Animation<double> _fadeAnimation;
  // 标记是否正在检查认证状态，防止重复检查
  bool _isChecking = false;
  // 显示给用户的状态文本
  String _statusText = '正在启动';
  // 是否显示错误信息
  bool _showError = false;

  /**
   * 初始化状态
   * 
   * 创建动画控制器和各种动画，并设置动画完成后的回调
   */
  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器，设置动画时长为1.5秒
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 创建Logo的缩放动画，使用弹性曲线效果
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    // 创建文字的淡入动画，使用ease out曲线
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
      ),
    );

    // 确保动画在下一帧开始，避免构建过程中启动动画
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 启动动画，并在动画完成后检查用户认证状态
      _controller.forward().then((_) {
        _checkAuthStatus();
      });
    });
  }

  /**
   * 释放资源
   * 
   * 释放动画控制器，避免内存泄漏
   */
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /**
   * 检查用户登录状态并导航到相应页面
   * 
   * 流程：
   * 1. 从Provider获取认证服务和状态管理器
   * 2. 检查用户是否已登录
   * 3. 根据登录状态导航到主页或登录页
   * 4. 处理可能的错误并提供重试机制
   */
  Future<void> _checkAuthStatus() async {
    // 防止重复检查
    if (_isChecking) return;
    _isChecking = true;
    
    try {
      // 检查组件是否仍然挂载在Widget树上
      if (!mounted) return;
      
      // 更新状态文本
      setState(() {
        _statusText = '正在验证身份...';
      });

      // 从Provider获取所需服务
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      
      // 检查用户是否已经登录，该方法会验证存储的Token是否有效
      final isAuthenticated = await authProvider.checkAuth(authService: authService);
      
      // 再次检查组件是否仍然挂载在Widget树上
      if (!mounted) return;
      
      // 根据认证结果更新状态文本
      setState(() {
        _statusText = isAuthenticated ? '正在加载主页...' : '正在加载登录页...';
      });

      // 给用户一点时间看到状态变化，提升用户体验
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (!mounted) return;
      
      // 准备页面跳转动画，反向运行动画使Logo缩小并消失
      await _controller.reverse();
      
      if (!mounted) return;
      
      // 根据登录状态导航到相应页面
      if (isAuthenticated) {
        // 已登录，导航到主页
        Navigator.pushReplacementNamed(context, AppRoutes.main);
      } else {
        // 未登录，导航到登录页
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      // 处理认证过程中的错误
      if (mounted) {
        // 显示错误信息
        setState(() {
          _statusText = '连接服务器失败，请检查网络';
          _showError = true;
        });
        
        // 3秒后自动重试
        await Future.delayed(const Duration(seconds: 3));
        
        if (mounted) {
          // 更新状态准备重试
          setState(() {
            _showError = false;
            _statusText = '正在重试...';
          });
          
          // 自动重试一次
          _checkAuthStatus();
        }
      }
    } finally {
      // 无论成功或失败，都重置检查状态
      _isChecking = false;
    }
  }

  /**
   * 构建启动屏幕UI
   * 
   * 包含:
   * - 背景渐变
   * - Logo动画
   * - 应用名称
   * - 状态文本
   * - 底部波浪动画
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 背景渐变，从绿色渐变到浅绿色
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
        // 使用AnimatedBuilder监听动画值变化并重建UI
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo动画 - 使用缩放动画
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      // Logo容器样式 - 白色圆形带阴影
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
                      // Logo图标 - 使用餐厅菜单图标
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
                  
                  // 应用名称 - 使用淡入动画
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
                  
                  // 状态文本 - 使用淡入动画
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
                  
                  // 显示错误时添加重试按钮
                  if (_showError)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: ElevatedButton(
                          onPressed: _checkAuthStatus,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text('重试'),
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
