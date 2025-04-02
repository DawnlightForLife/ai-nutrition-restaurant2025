import 'package:flutter/material.dart';

/// 应用选项卡组件
///
/// 标准化的选项卡组件，支持自定义标签和内容
class AppTabBar extends StatefulWidget {
  final List<String> tabTitles;
  final List<Widget> tabContents;
  final int initialIndex;
  final double height;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;
  final TextStyle? labelStyle;
  final TextStyle? unselectedLabelStyle;
  final Color? backgroundColor;
  final TabController? controller;
  final ValueChanged<int>? onTabChanged;
  final bool isScrollable;
  final EdgeInsetsGeometry? labelPadding;

  const AppTabBar({
    Key? key,
    required this.tabTitles,
    required this.tabContents,
    this.initialIndex = 0,
    this.height = 46.0,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.labelStyle,
    this.unselectedLabelStyle,
    this.backgroundColor,
    this.controller,
    this.onTabChanged,
    this.isScrollable = false,
    this.labelPadding,
  })  : assert(tabTitles.length == tabContents.length,
            'Tab titles length must match tab contents length'),
        super(key: key);

  @override
  State<AppTabBar> createState() => _AppTabBarState();
}

class _AppTabBarState extends State<AppTabBar> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = widget.controller ?? TabController(
        length: widget.tabTitles.length,
        vsync: this,
        initialIndex: widget.initialIndex);
    
    if (widget.onTabChanged != null) {
      _tabController!.addListener(() {
        if (!_tabController!.indexIsChanging) {
          widget.onTabChanged!(_tabController!.index);
        }
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _tabController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 待填充组件逻辑
    return Container();
  }
}
