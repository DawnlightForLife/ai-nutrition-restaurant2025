import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import '../../config/theme/yuanqi_colors.dart';

final buttonsComponent = WidgetbookComponent(
  name: '按钮',
  useCases: [
    WidgetbookUseCase(
      name: '主要按钮',
      builder: (context) {
        final text = context.knobs.string(
          label: '按钮文字',
          initialValue: '登录',
        );
        
        final isEnabled = context.knobs.boolean(
          label: '启用',
          initialValue: true,
        );
        
        final isLoading = context.knobs.boolean(
          label: '加载中',
          initialValue: false,
        );
        
        final size = context.knobs.list(
          label: '尺寸',
          options: ['小', '中', '大'],
          initialOption: '中',
        );
        
        return Center(
          child: SizedBox(
            width: _getButtonWidth(size),
            height: _getButtonHeight(size),
            child: ElevatedButton(
              onPressed: isEnabled ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: YuanqiColors.primaryOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(text),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '渐变按钮',
      builder: (context) {
        final text = context.knobs.string(
          label: '按钮文字',
          initialValue: '立即体验',
        );
        
        final hasIcon = context.knobs.boolean(
          label: '显示图标',
          initialValue: false,
        );
        
        return Center(
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              gradient: YuanqiColors.primaryGradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (hasIcon) ...[
                    const Icon(Icons.rocket_launch, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '次要按钮',
      builder: (context) {
        final text = context.knobs.string(
          label: '按钮文字',
          initialValue: '取消',
        );
        
        return Center(
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: YuanqiColors.primaryOrange,
              side: const BorderSide(color: YuanqiColors.primaryOrange),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(text),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '文字按钮',
      builder: (context) {
        final text = context.knobs.string(
          label: '按钮文字',
          initialValue: '忘记密码？',
        );
        
        final color = context.knobs.list(
          label: '颜色',
          options: ['主色', '次要', '危险'],
          initialOption: '主色',
        );
        
        return Center(
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: _getTextButtonColor(color),
            ),
            child: Text(text),
          ),
        );
      },
    ),
    WidgetbookUseCase(
      name: '图标按钮组',
      builder: (context) {
        final showLabels = context.knobs.boolean(
          label: '显示标签',
          initialValue: true,
        );
        
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(
                icon: Icons.home,
                label: showLabels ? '首页' : null,
                isSelected: true,
              ),
              _buildIconButton(
                icon: Icons.restaurant_menu,
                label: showLabels ? '点餐' : null,
                isSelected: false,
              ),
              _buildIconButton(
                icon: Icons.shopping_cart,
                label: showLabels ? '购物车' : null,
                isSelected: false,
              ),
              _buildIconButton(
                icon: Icons.person,
                label: showLabels ? '我的' : null,
                isSelected: false,
              ),
            ],
          ),
        );
      },
    ),
  ],
);

double _getButtonWidth(String size) {
  switch (size) {
    case '小':
      return 120;
    case '大':
      return 280;
    default:
      return 200;
  }
}

double _getButtonHeight(String size) {
  switch (size) {
    case '小':
      return 36;
    case '大':
      return 56;
    default:
      return 46;
  }
}

Color _getTextButtonColor(String color) {
  switch (color) {
    case '次要':
      return YuanqiColors.textSecondary;
    case '危险':
      return Colors.red;
    default:
      return YuanqiColors.primaryOrange;
  }
}

Widget _buildIconButton({
  required IconData icon,
  String? label,
  required bool isSelected,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        onPressed: () {},
        icon: Icon(icon),
        color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textSecondary,
        iconSize: 28,
      ),
      if (label != null)
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? YuanqiColors.primaryOrange : YuanqiColors.textSecondary,
          ),
        ),
    ],
  );
}