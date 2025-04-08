import 'package:flutter/material.dart';
import 'dart:async';

/**
 * 认证UI状态管理提供者
 * 
 * 负责管理与认证界面相关的UI状态，特别是验证码发送和倒计时功能
 * 主要用于登录、注册和密码重置等需要验证码功能的页面
 * 使用ChangeNotifier实现，可以通过Provider在不同Widget之间共享状态
 */
class AuthUIProvider with ChangeNotifier {
  /// 是否正在发送验证码的状态标志
  bool _isSendingCode = false;
  
  /// 验证码倒计时剩余秒数
  int _secondsRemaining = 0;
  
  /// 用于倒计时的Timer实例，可能为null（未启动倒计时时）
  Timer? _timer;

  /// 获取是否正在发送验证码或倒计时中
  /// 
  /// @return 如果正在发送验证码或倒计时中返回true，否则返回false
  bool get isSendingCode => _isSendingCode;
  
  /// 获取倒计时剩余秒数
  /// 
  /// @return 剩余秒数，为0表示倒计时已结束
  int get secondsRemaining => _secondsRemaining;

  /**
   * 启动验证码倒计时
   * 
   * 设置初始倒计时秒数并开始计时，同时更新发送状态
   * 在发送验证码成功后调用此方法开始倒计时
   * 
   * @param seconds 倒计时的总秒数（通常为60秒）
   */
  void startCountdown(int seconds) {
    _secondsRemaining = seconds;
    _isSendingCode = true;
    notifyListeners();

    // 取消可能存在的旧计时器
    _timer?.cancel();
    
    // 创建新的计时器，每秒更新一次倒计时状态
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      if (_secondsRemaining <= 0) {
        _isSendingCode = false;
        timer.cancel();
      }
      notifyListeners();  // 通知UI状态已更新
    });
  }

  /**
   * 重置验证码状态
   * 
   * 取消倒计时并重置所有状态变量
   * 在用户切换页面或退出验证页面时调用，避免状态残留
   */
  void reset() {
    _timer?.cancel();
    _isSendingCode = false;
    _secondsRemaining = 0;
    notifyListeners();  // 通知UI状态已更新
  }
  
  /**
   * 资源释放
   * 
   * 在提供者被销毁时取消计时器，避免内存泄漏
   * ChangeNotifier的标准方法，会在Provider被从树中移除时自动调用
   */
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
} 