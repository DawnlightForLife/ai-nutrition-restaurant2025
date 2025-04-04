import 'package:flutter/material.dart';

/// 自定义密码输入组件
///
/// 提供带可见性切换的密码输入功能
class CustomPasswordInput extends StatefulWidget {
  /// 控制器
  final TextEditingController controller;
  
  /// 标签文本
  final String? labelText;
  
  /// 提示文本
  final String? hintText;
  
  /// 错误文本
  final String? errorText;
  
  /// 验证器函数
  final String? Function(String?)? validator;
  
  /// 输入完成回调
  final void Function()? onEditingComplete;
  
  /// 值变化回调
  final void Function(String)? onChanged;
  
  /// 自动获取焦点
  final bool autofocus;
  
  /// 是否启用
  final bool enabled;

  const CustomPasswordInput({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.validator,
    this.onEditingComplete,
    this.onChanged,
    this.autofocus = false,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CustomPasswordInput> createState() => _CustomPasswordInputState();
}

class _CustomPasswordInputState extends State<CustomPasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline),
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
      validator: widget.validator,
      onEditingComplete: widget.onEditingComplete,
      onChanged: widget.onChanged,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
    );
  }
}
