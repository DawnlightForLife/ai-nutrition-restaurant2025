import 'package:flutter/material.dart';

/// 加载指示器组件
///
/// 用于显示加载状态，可选择性地覆盖全屏或局部区域
class LoadingIndicator extends StatelessWidget {
  /// 是否显示加载动画
  final bool isLoading;
  
  /// 子组件，会被加载动画覆盖
  final Widget? child;
  
  /// 加载提示文本
  final String? message;
  
  /// 背景颜色
  final Color backgroundColor;
  
  /// 指示器颜色
  final Color indicatorColor;
  
  /// 文本颜色
  final Color textColor;
  
  /// 是否全屏覆盖
  final bool isFullScreen;
  
  /// 构造函数
  const LoadingIndicator({
    Key? key,
    required this.isLoading,
    this.child,
    this.message,
    this.backgroundColor = Colors.black45,
    this.indicatorColor = Colors.white,
    this.textColor = Colors.white,
    this.isFullScreen = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果不在加载状态且有子组件，直接返回子组件
    if (!isLoading && child != null) {
      return child!;
    }
    
    // 如果不在加载状态且没有子组件，返回空容器
    if (!isLoading && child == null) {
      return Container();
    }
    
    // 构建加载指示器
    Widget loadingWidget = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
    
    // 如果是全屏覆盖，使用Stack包裹
    if (isFullScreen) {
      return Stack(
        children: [
          if (child != null) child!,
          Positioned.fill(
            child: Container(
              color: backgroundColor,
              child: loadingWidget,
            ),
          ),
        ],
      );
    }
    
    // 非全屏覆盖，直接返回加载指示器
    return loadingWidget;
  }
  
  /// 创建简单的全屏加载指示器，用于静态方法调用
  static Future<void> show(
    BuildContext context, {
    String? message,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: LoadingIndicator(
            isLoading: true,
            message: message,
          ),
        );
      },
    );
  }
  
  /// 隐藏加载指示器，用于静态方法调用
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
  
  /// 在执行某个异步任务期间显示加载指示器
  static Future<T> during<T>(
    BuildContext context,
    Future<T> future, {
    String? message,
  }) async {
    show(context, message: message);
    try {
      final result = await future;
      hide(context);
      return result;
    } catch (e) {
      hide(context);
      rethrow;
    }
  }
} 