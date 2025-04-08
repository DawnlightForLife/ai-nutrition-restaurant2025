import 'package:flutter/material.dart';

/**
 * 自定义密码输入组件
 * 
 * 提供带可见性切换的密码输入功能
 * 包含密码隐藏/显示切换按钮，增强用户体验
 * 适用于登录、注册、修改密码等需要密码输入的场景
 */
class CustomPasswordInput extends StatefulWidget {
  /// 密码输入控制器
  /// 用于获取和设置密码输入值
  final TextEditingController controller;
  
  /// 输入框标签文本
  /// 显示在输入框上方或内部
  final String? labelText;
  
  /// 提示文本
  /// 当输入框为空时显示的灰色提示
  final String? hintText;
  
  /// 错误文本
  /// 验证失败时显示在输入框下方的错误提示
  final String? errorText;
  
  /// 验证器函数
  /// 用于验证输入内容是否有效，返回null表示验证通过
  final String? Function(String?)? validator;
  
  /// 输入完成回调
  /// 用户点击键盘完成按钮时触发
  final void Function()? onEditingComplete;
  
  /// 值变化回调
  /// 输入内容发生变化时触发
  final void Function(String)? onChanged;
  
  /// 是否自动获取焦点
  /// 为true时组件显示后会自动激活并弹出键盘
  final bool autofocus;
  
  /// 是否启用输入
  /// 为false时输入框将变为不可编辑状态
  final bool enabled;

  /**
   * 构造函数
   * 
   * @param key 组件键
   * @param controller 密码输入控制器，必须提供
   * @param labelText 标签文本
   * @param hintText 提示文本
   * @param errorText 错误文本
   * @param validator 验证器函数
   * @param onEditingComplete 输入完成回调
   * @param onChanged 值变化回调
   * @param autofocus 是否自动获取焦点，默认为false
   * @param enabled 是否启用，默认为true
   */
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

/**
 * 自定义密码输入组件状态类
 * 
 * 管理密码显示/隐藏状态和视图渲染
 */
class _CustomPasswordInputState extends State<CustomPasswordInput> {
  /// 是否隐藏密码文本
  /// true表示密码以圆点显示，false表示明文显示
  bool _obscureText = true;

  /**
   * 构建组件UI
   * 
   * 创建密码输入框，包含锁图标和可见性切换按钮
   * 
   * @param context 构建上下文
   * @return 构建的组件
   */
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText, // 控制密码是否显示为掩码
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: const Icon(Icons.lock_outline), // 左侧锁图标
        suffixIcon: IconButton(
          // 右侧显示/隐藏密码按钮
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            // 切换密码显示/隐藏状态
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
      keyboardType: TextInputType.visiblePassword, // 使用密码键盘类型
      textInputAction: TextInputAction.next, // 键盘动作为下一步
    );
  }
}
