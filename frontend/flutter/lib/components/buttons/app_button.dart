import 'package:flutter/material.dart';

/**
 * 应用通用按钮组件
 * 
 * 提供统一风格的按钮UI，支持多种按钮样式
 * 包括主要、次要、文本和图标按钮类型
 * 适用于表单提交、操作确认、导航等各种交互场景
 */
class AppButton extends StatelessWidget {
  /// 按钮文本内容
  /// 显示在按钮中间，可为null（用于图标按钮）
  final String? text;
  
  /// 点击回调函数
  /// 按钮被点击时触发，为null时按钮显示为禁用状态
  final VoidCallback? onPressed;
  
  /// 按钮类型
  /// 决定按钮的外观样式，默认为主要按钮
  final ButtonType type;
  
  /// 按钮图标
  /// 显示在文本前面或单独显示（图标按钮）
  final IconData? icon;
  
  /// 是否处于加载状态
  /// 为true时显示加载指示器，并禁用点击
  final bool isLoading;
  
  /// 是否占满父容器宽度
  /// 为true时按钮宽度与父容器一致
  final bool isFullWidth;
  
  /// 内边距
  /// 控制按钮内容与边缘的距离
  final EdgeInsetsGeometry? padding;
  
  /// 固定高度
  /// 指定按钮的高度，覆盖默认值
  final double? height;
  
  /// 固定宽度
  /// 指定按钮的宽度，覆盖默认值
  final double? width;

  /**
   * 构造函数
   * 
   * @param key 组件键
   * @param text 按钮文本
   * @param onPressed 点击回调
   * @param type 按钮类型，默认为主要按钮
   * @param icon 按钮图标
   * @param isLoading 是否处于加载状态，默认为false
   * @param isFullWidth 是否占满父容器宽度，默认为false
   * @param padding 内边距
   * @param height 固定高度
   * @param width 固定宽度
   */
  const AppButton({
    Key? key,
    this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.height,
    this.width,
  }) : super(key: key);

  /**
   * 构建组件UI
   * 
   * 根据按钮类型和属性，创建相应样式的按钮
   * 
   * @param context 构建上下文
   * @return 构建的按钮组件
   */
  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}

/**
 * 按钮类型枚举
 * 
 * 定义不同样式的按钮类型：
 * - primary: 主要按钮，通常使用应用主题色，用于突出显示主要操作
 * - secondary: 次要按钮，通常使用较淡的颜色，用于次要操作
 * - text: 文本按钮，没有背景色，只有文字，用于辅助操作
 * - icon: 图标按钮，只显示图标，常用于工具栏或紧凑布局
 */
enum ButtonType {
  /// 主要按钮，使用主题色背景
  primary,
  
  /// 次要按钮，使用较淡颜色
  secondary,
  
  /// 文本按钮，无背景
  text,
  
  /// 图标按钮，只显示图标
  icon,
}
