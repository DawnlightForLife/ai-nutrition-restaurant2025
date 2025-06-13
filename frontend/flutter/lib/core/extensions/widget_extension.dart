import 'package:flutter/material.dart';

/// Widget 扩展方法
extension WidgetExtensions on Widget {
  /// 添加内边距
  Widget withPadding(EdgeInsets padding) {
    return Padding(
      padding: padding,
      child: this,
    );
  }

  /// 添加水平内边距
  Widget paddingHorizontal(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: this,
    );
  }

  /// 添加垂直内边距
  Widget paddingVertical(double padding) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: padding),
      child: this,
    );
  }

  /// 添加所有方向内边距
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// 居中
  Widget centered() {
    return Center(child: this);
  }

  /// 添加手势点击
  Widget onTap(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: this,
    );
  }

  /// 添加圆角
  Widget withRadius(double radius) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: this,
    );
  }

  /// 添加阴影
  Widget withShadow({
    Color color = Colors.black12,
    double blurRadius = 10,
    Offset offset = Offset.zero,
    double spreadRadius = 0,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: blurRadius,
            offset: offset,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: this,
    );
  }

  /// 设置宽度
  Widget width(double width) {
    return SizedBox(width: width, child: this);
  }

  /// 设置高度
  Widget height(double height) {
    return SizedBox(height: height, child: this);
  }

  /// 设置尺寸
  Widget size(double width, double height) {
    return SizedBox(width: width, height: height, child: this);
  }

  /// 设置背景颜色
  Widget backgroundColor(Color color) {
    return Container(
      color: color,
      child: this,
    );
  }

  /// 添加边框
  Widget withBorder({
    Color color = Colors.grey,
    double width = 1.0,
    BorderRadius? borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color, width: width),
        borderRadius: borderRadius,
      ),
      child: this,
    );
  }
} 