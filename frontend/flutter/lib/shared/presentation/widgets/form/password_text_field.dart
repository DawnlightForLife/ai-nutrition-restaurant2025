import 'package:flutter/material.dart';

/// 密码输入框
class PasswordTextField extends StatefulWidget {
  /// 控制器
  final TextEditingController controller;
  
  /// 标签文本
  final String labelText;
  
  /// 提示文本
  final String? hintText;
  
  /// 验证器
  final String? Function(String?)? validator;
  
  /// 是否自动获取焦点
  final bool autofocus;
  
  /// 是否启用
  final bool enabled;
  
  /// 构造函数
  const PasswordTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.autofocus = false,
    this.enabled = true,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
} 