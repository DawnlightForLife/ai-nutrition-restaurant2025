import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import '../../config/theme/yuanqi_colors.dart';

final inputsComponent = WidgetbookComponent(
  name: '输入框',
  useCases: [
    WidgetbookUseCase(
      name: '基础输入框',
      builder: (context) {
        final label = context.knobs.string(
          label: '标签',
          initialValue: '手机号',
        );
        
        final hint = context.knobs.string(
          label: '提示文字',
          initialValue: '请输入手机号',
        );
        
        final hasError = context.knobs.boolean(
          label: '显示错误',
          initialValue: false,
        );
        
        final errorText = context.knobs.string(
          label: '错误文字',
          initialValue: '手机号格式不正确',
        );
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              errorText: hasError ? errorText : null,
              filled: true,
              fillColor: YuanqiColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: YuanqiColors.primaryOrange,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '密码输入框',
      builder: (context) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: _PasswordInput(),
        );
      },
    ),
    WidgetbookUseCase(
      name: '搜索框',
      builder: (context) {
        final placeholder = context.knobs.string(
          label: '占位文字',
          initialValue: '搜索菜品、商家',
        );
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: YuanqiColors.background,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                prefixIcon: const Icon(
                  Icons.search,
                  color: YuanqiColors.textSecondary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '验证码输入框',
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: '验证码',
                    hintText: '请输入验证码',
                    filled: true,
                    fillColor: YuanqiColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: YuanqiColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    '获取验证码',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '多行输入框',
      builder: (context) {
        final lines = context.knobs.int.slider(
          label: '行数',
          initialValue: 4,
          min: 1,
          max: 10,
        );
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            maxLines: lines,
            decoration: InputDecoration(
              labelText: '备注',
              hintText: '请输入备注信息',
              alignLabelWithHint: true,
              filled: true,
              fillColor: YuanqiColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: YuanqiColors.primaryOrange,
                  width: 2,
                ),
              ),
            ),
          ),
        );
      },
    ),
  ],
);

class _PasswordInput extends StatefulWidget {
  const _PasswordInput();

  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        labelText: '密码',
        hintText: '请输入密码',
        filled: true,
        fillColor: YuanqiColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: YuanqiColors.primaryOrange,
            width: 2,
          ),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: YuanqiColors.textSecondary,
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