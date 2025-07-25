# 微交互设计规范 - 完整设计方案

> **文档版本**: 1.0.0  
> **创建日期**: 2025-07-12  
> **更新日期**: 2025-07-12  
> **文档状态**: ✅ 新系统设计阶段  
> **目标受众**: UI设计师、Flutter开发团队、动画设计师

## 📋 目录

- [1. 微交互设计概述](#1-微交互设计概述)
- [2. 动画时长与缓动曲线](#2-动画时长与缓动曲线)
- [3. 按钮与操作反馈](#3-按钮与操作反馈)
- [4. 表单交互反馈](#4-表单交互反馈)
- [5. 状态转换动画](#5-状态转换动画)
- [6. 通知与提示反馈](#6-通知与提示反馈)
- [7. 加载与进度反馈](#7-加载与进度反馈)
- [8. 页面转场动画](#8-页面转场动画)
- [9. Flutter实现规范](#9-flutter实现规范)

---

## 1. 微交互设计概述

### 1.1 设计理念

```yaml
微交互四要素:
  触发器 (Triggers):
    - 用户操作触发
    - 系统事件触发
    - 外部数据变化触发
    - 定时器触发

  规则 (Rules):
    - 触发后的行为逻辑
    - 动画执行条件
    - 状态变化规则
    - 异常处理规则

  反馈 (Feedback):
    - 视觉反馈 (动画、颜色变化)
    - 触觉反馈 (震动)
    - 听觉反馈 (音效)
    - 信息反馈 (文字提示)

  循环/模式 (Loops & Modes):
    - 重复性行为
    - 状态模式切换
    - 上下文感知
    - 适应性调整
```

### 1.2 设计原则

```yaml
健康应用微交互原则:
  专业可信:
    - 动画稳重不浮夸
    - 医疗场景避免过度动效
    - 专业操作优先功能性
    - 保持品牌一致性

  用户友好:
    - 降低认知负担
    - 提供清晰状态反馈
    - 支持快速操作流程
    - 容错性和可撤销性

  性能优先:
    - 60fps流畅动画
    - 低功耗动画设计
    - 避免复杂计算动画
    - 支持动画禁用选项

  无障碍兼容:
    - 支持减少动画偏好
    - 提供非视觉反馈替代
    - 保证色盲用户体验
    - 支持屏幕阅读器
```

---

## 2. 动画时长与缓动曲线

### 2.1 标准动画时长

```yaml
动画时长分级:
  极快 (Instant):
    时长: 0ms
    应用场景:
      - 开关状态切换
      - 复选框选中
      - 单选按钮选择
      - 简单状态指示器

  快速 (Fast):
    时长: 100-200ms
    应用场景:
      - 按钮点击反馈
      - 工具提示显示
      - 小范围颜色变化
      - 图标状态切换

  标准 (Standard):
    时长: 250-300ms
    应用场景:
      - 卡片展开/收起
      - 表单验证提示
      - 抽屉菜单滑出
      - 标签页切换

  慢速 (Slow):
    时长: 400-500ms
    应用场景:
      - 页面转场动画
      - 大范围布局变化
      - 复杂组件展开
      - 数据加载过渡

  特殊场景:
    时长: 600ms+
    应用场景:
      - 引导动画
      - 成就/庆祝动画
      - 品牌展示动画
      - 错误恢复动画
```

### 2.2 缓动曲线规范

```yaml
标准缓动曲线:
  Ease-In (慢进快出):
    Flutter: Curves.easeIn
    CSS: cubic-bezier(0.42, 0, 1, 1)
    应用: 元素消失、收起动画

  Ease-Out (快进慢出):
    Flutter: Curves.easeOut  
    CSS: cubic-bezier(0, 0, 0.58, 1)
    应用: 元素进入、展开动画

  Ease-In-Out (慢进慢出):
    Flutter: Curves.easeInOut
    CSS: cubic-bezier(0.42, 0, 0.58, 1)
    应用: 状态切换、平滑过渡

  FastOut-SlowIn (Material标准):
    Flutter: Curves.fastOutSlowIn
    CSS: cubic-bezier(0.4, 0, 0.2, 1)
    应用: Material Design组件

自定义缓动曲线:
  健康应用专用:
    Flutter: Cubic(0.25, 0.1, 0.25, 1)
    特点: 轻微弹性，专业稳重
    应用: 营养数据展示、健康指标变化

  按钮反馈专用:
    Flutter: Cubic(0.1, 0, 0.3, 1)
    特点: 快速响应，明确反馈
    应用: 所有按钮交互

  错误提示专用:
    Flutter: Curves.elasticOut
    特点: 轻微震动感，引起注意
    应用: 表单验证错误、操作失败
```

---

## 3. 按钮与操作反馈

### 3.1 按钮状态动画

```yaml
主要按钮 (Primary Button):
  正常状态:
    - 背景色: Theme.primaryColor
    - 阴影: elevation 2
    - 圆角: 8px
    - 内边距: 16px 24px

  悬停状态 (Web):
    动画时长: 150ms
    缓动: Curves.easeOut
    变化: elevation 4, 背景色加深5%

  按下状态:
    动画时长: 100ms
    缓动: Curves.easeIn
    变化: elevation 0, 缩放0.98

  加载状态:
    动画时长: 无限循环
    效果: 显示LoadingSpinner + 文字变为"处理中..."
    禁用: 所有交互

  禁用状态:
    动画时长: 200ms
    效果: 透明度0.6, 灰度滤镜
    交互: 完全禁用

次要按钮 (Secondary Button):
  设计变化:
    - 背景透明，边框2px
    - 悬停时背景填充主色调10%
    - 其他状态逻辑同主要按钮

文字按钮 (Text Button):
  设计变化:
    - 无背景无边框
    - 悬停时背景主色调5%
    - 按下时背景主色调10%
```

### 3.2 按钮反馈代码规范

```dart
// Flutter实现示例
class HealthyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;

  @override
  _HealthyButtonState createState() => _HealthyButtonState();
}

class _HealthyButtonState extends State<HealthyButton> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: 2.0,
      end: 0.0,
    ).animate(_controller);
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }
}
```

---

## 4. 表单交互反馈

### 4.1 输入框交互动画

```yaml
输入框聚焦动画:
  动画时长: 200ms
  缓动曲线: Curves.easeOut
  视觉变化:
    - 边框颜色: 灰色 → 主色调
    - 边框宽度: 1px → 2px
    - 标签上移: 基线 → 上移12px
    - 标签缩放: 1.0 → 0.85
    - 辅助文字淡入: opacity 0 → 1

输入框失焦动画:
  动画时长: 200ms
  缓动曲线: Curves.easeIn
  视觉变化:
    - 边框还原 (如果有内容保持主色调)
    - 标签位置 (如果无内容回到基线)

输入验证反馈:
  成功状态:
    动画时长: 300ms
    缓动: Curves.easeOut
    效果: 绿色对勾图标从右侧滑入
  
  错误状态:
    动画时长: 400ms
    缓动: Curves.elasticOut
    效果: 
      - 输入框左右震动3次
      - 边框变红
      - 错误文字从下方滑入
```

### 4.2 开关与选择器动画

```yaml
切换开关 (Switch):
  动画时长: 150ms
  缓动: Curves.easeInOut
  变化过程:
    - 滑块位置: 左 ↔ 右
    - 背景颜色: 灰色 ↔ 主色调
    - 滑块阴影: 轻微位移

复选框 (Checkbox):
  选中动画时长: 200ms
  缓动: Curves.easeOut
  动画步骤:
    1. 背景填充 (0-100ms)
    2. 对勾路径绘制 (100-200ms)
  
  取消选中:
    时长: 150ms
    效果: 背景色淡出

单选按钮 (Radio):
  选中动画: 圆点从中心放大
  时长: 150ms
  缓动: Curves.easeOut

滑块 (Slider):
  拖拽跟随: 实时无延迟
  释放回弹: 100ms, Curves.easeOut
  值变化提示: 气泡显示当前值
```

---

## 5. 状态转换动画

### 5.1 加载状态动画

```yaml
页面级加载:
  骨架屏动画:
    - 闪烁效果: 1500ms循环
    - 渐变: 浅灰 → 白色 → 浅灰
    - 缓动: Curves.easeInOut
  
  转场到内容:
    - 时长: 300ms
    - 效果: 骨架屏淡出，内容淡入
    - 延迟: 各元素错开50ms

组件级加载:
  旋转指示器:
    - 速度: 每秒1圈 (1000ms/圈)
    - 缓动: Curves.linear
    - 大小: 24x24px (小), 32x32px (中), 48x48px (大)
  
  进度条:
    - 不确定进度: 滑动动画1500ms循环
    - 确定进度: 平滑增长，最小增量5%
    - 完成动画: 绿色对勾替换进度条

按钮加载:
  LoadingSpinner + 文字:
    - Spinner位置: 文字左侧
    - 文字变化: "确认" → "处理中..."
    - 按钮宽度保持不变
    - 禁用状态: 透明度0.6
```

### 5.2 数据刷新动画

```yaml
下拉刷新:
  拉动阶段:
    - 触发距离: 80px
    - 指示器: 箭头 → 加载图标
    - 阻尼系数: 0.6 (越拉越难)
  
  刷新阶段:
    - 旋转动画: 连续旋转
    - 完成反馈: 绿色对勾 + "刷新完成"
    - 自动回弹: 500ms

自动刷新:
  数据更新提示:
    - 顶部滑入通知条
    - 文字: "发现X条新内容"
    - 点击展开新内容
    - 3秒后自动消失

页面刷新:
  内容替换:
    - 旧内容淡出: 150ms
    - 新内容淡入: 200ms (延迟50ms)
    - 错开动画: 列表项间隔30ms
```

---

## 6. 通知与提示反馈

### 6.1 Toast消息规范

```yaml
成功提示 (Success Toast):
  显示时长: 3000ms (3秒)
  动画:
    进入: 从顶部滑入 200ms
    停留: 静态显示
    退出: 淡出 150ms
  视觉设计:
    - 背景: 绿色 #4CAF50
    - 图标: 白色对勾
    - 文字: 白色
    - 圆角: 8px
    - 阴影: elevation 6

错误提示 (Error Toast):
  显示时长: 5000ms (5秒)
  动画: 同成功提示
  特殊效果: 
    - 进入时轻微震动 (100ms)
    - 背景: 红色 #F44336
    - 图标: 白色感叹号

警告提示 (Warning Toast):
  显示时长: 4000ms (4秒)
  背景: 橙色 #FF9800
  图标: 白色警告三角形

信息提示 (Info Toast):
  显示时长: 3000ms (3秒)
  背景: 蓝色 #2196F3
  图标: 白色信息圆圈

操作确认提示:
  显示时长: 无限 (需用户操作)
  包含: 撤销按钮
  自动消失: 用户操作后或30秒
```

### 6.2 Snackbar行为规范

```yaml
页面底部Snackbar:
  位置: 距离底部16px
  宽度: 屏幕宽度 - 32px
  最大宽度: 560px (平板/桌面)

多个Snackbar管理:
  队列机制: FIFO (先进先出)
  最大数量: 3个
  超出处理: 最旧的立即消失

交互行为:
  手势消失:
    - 向左/右滑动消失
    - 滑动距离 > 50% 宽度触发
    - 动画时长: 200ms
  
  点击消失:
    - 点击空白区域消失
    - 动画: 淡出 150ms

操作按钮:
  位置: 右侧
  样式: 文字按钮
  颜色: 白色或对比色
  最多: 2个按钮
```

---

## 7. 加载与进度反馈

### 7.1 页面加载策略

```yaml
渐进式加载:
  骨架屏阶段:
    - 立即显示结构骨架
    - 模拟真实内容布局
    - 避免布局位移 (CLS)
  
  内容填充阶段:
    - 关键内容优先显示
    - 图片懒加载
    - 次要内容延后加载
  
  完成阶段:
    - 骨架屏淡出: 200ms
    - 内容淡入: 250ms (延迟50ms)
    - 错开动画增强层次感

长时间加载优化:
  进度指示:
    - 0-3秒: 简单旋转指示器
    - 3-10秒: 进度条 + 百分比
    - 10秒+: 详细状态 + 取消选项
  
  用户反馈:
    - 预估完成时间
    - 当前处理步骤说明
    - 提供取消或后台处理选项
```

### 7.2 数据同步进度

```yaml
营养数据同步:
  步骤指示:
    1. "正在同步用户档案..." (20%)
    2. "正在同步饮食记录..." (50%)
    3. "正在更新营养分析..." (80%)
    4. "同步完成" (100%)
  
  每步动画:
    - 进度条平滑增长
    - 步骤文字淡入淡出
    - 完成时绿色对勾

图片上传进度:
  单图上传:
    - 环形进度指示器
    - 中心显示百分比
    - 完成时对勾替换百分比
  
  多图上传:
    - 网格布局显示所有图片
    - 每张图片独立进度指示
    - 总体进度条在顶部

错误处理:
  失败重试:
    - 失败时红色叉号
    - 点击重试按钮
    - 重试时恢复进度动画
  
  部分失败:
    - 成功项目: 绿色对勾
    - 失败项目: 红色叉号 + 重试按钮
    - 整体状态: 黄色警告
```

---

## 8. 页面转场动画

### 8.1 路由转场规范

```yaml
标准页面切换:
  前进导航:
    动画: 新页面从右侧滑入
    时长: 300ms
    缓动: Curves.easeOut
    旧页面: 同时向左侧滑出
  
  后退导航:
    动画: 当前页面向右滑出
    时长: 250ms
    缓动: Curves.easeIn
    显示: 下层页面

模态页面:
  底部弹出:
    动画: 从底部滑入
    时长: 350ms
    缓动: Curves.fastOutSlowIn
    背景: 半透明遮罩淡入
  
  全屏模态:
    动画: 淡入 + 轻微缩放
    时长: 250ms
    初始缩放: 0.95 → 1.0

特殊场景转场:
  营养分析结果:
    动画: 翻页效果
    时长: 400ms
    效果: 3D翻转展示结果
  
  健康报告:
    动画: 自上而下展开
    时长: 500ms
    效果: 纸张展开感觉
```

### 8.2 标签页切换

```yaml
水平标签页:
  切换动画:
    - 内容区域滑动切换
    - 时长: 250ms
    - 缓动: Curves.easeInOut
  
  指示器动画:
    - 下划线滑动到新位置
    - 时长: 200ms
    - 缓动: Curves.easeOut

垂直标签页:
  切换动画:
    - 内容垂直滑动
    - 时长: 200ms
    - 同时淡出淡入

预加载策略:
  相邻标签页预加载
  避免切换时空白
  懒加载远距离标签页
```

---

## 9. Flutter实现规范

### 9.1 动画控制器管理

```dart
// 标准动画控制器组织
class AnimationControllerManager {
  // 单例模式管理全局动画
  static final AnimationControllerManager _instance = 
      AnimationControllerManager._internal();
  factory AnimationControllerManager() => _instance;
  AnimationControllerManager._internal();

  // 动画时长常量
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration standardDuration = Duration(milliseconds: 250);
  static const Duration slowDuration = Duration(milliseconds: 400);

  // 缓动曲线常量
  static const Curve healthyEase = Cubic(0.25, 0.1, 0.25, 1);
  static const Curve buttonFeedback = Cubic(0.1, 0, 0.3, 1);
}

// 可复用动画组件基类
abstract class AnimatedHealthyWidget extends StatefulWidget {
  const AnimatedHealthyWidget({Key? key}) : super(key: key);
}

abstract class AnimatedHealthyWidgetState<T extends AnimatedHealthyWidget> 
    extends State<T> with TickerProviderStateMixin {
  
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    controller = AnimationController(
      duration: AnimationControllerManager.standardDuration,
      vsync: this,
    );

    fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: AnimationControllerManager.healthyEase,
    ));

    scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

### 9.2 通用动画工具类

```dart
// 通用动画工具
class HealthyAnimations {
  // 按钮点击反馈动画
  static void buttonTapFeedback(AnimationController controller) {
    controller.forward().then((_) {
      controller.reverse();
    });
  }

  // 成功状态动画
  static Animation<double> createSuccessAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );
  }

  // 错误震动动画
  static Animation<double> createShakeAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.elasticIn,
      ),
    );
  }

  // 页面转场动画
  static Widget createSlideTransition({
    required Animation<double> animation,
    required Widget child,
    SlideDirection direction = SlideDirection.rightToLeft,
  }) {
    late Offset beginOffset;
    late Offset endOffset;

    switch (direction) {
      case SlideDirection.rightToLeft:
        beginOffset = const Offset(1.0, 0.0);
        endOffset = Offset.zero;
        break;
      case SlideDirection.leftToRight:
        beginOffset = const Offset(-1.0, 0.0);
        endOffset = Offset.zero;
        break;
      case SlideDirection.bottomToTop:
        beginOffset = const Offset(0.0, 1.0);
        endOffset = Offset.zero;
        break;
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: child,
    );
  }
}

enum SlideDirection {
  rightToLeft,
  leftToRight,
  bottomToTop,
}
```

### 9.3 性能优化规范

```dart
// 动画性能优化最佳实践
class AnimationOptimization {
  // 1. 使用RepaintBoundary隔离动画重绘区域
  static Widget optimizedAnimatedWidget(Widget child) {
    return RepaintBoundary(
      child: child,
    );
  }

  // 2. 复杂动画使用CustomPainter
  static Widget complexAnimation({
    required Animation<double> animation,
    required CustomPainter painter,
  }) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: painter,
          child: child,
        );
      },
    );
  }

  // 3. 避免在build方法中创建Animation
  // ❌ 错误做法
  Widget badExample() {
    final animation = Tween<double>(begin: 0, end: 1).animate(controller);
    return AnimatedBuilder(animation: animation, builder: ...);
  }

  // ✅ 正确做法 - 在initState中创建
  late final Animation<double> goodAnimation;
  
  void initState() {
    super.initState();
    goodAnimation = Tween<double>(begin: 0, end: 1).animate(controller);
  }

  // 4. 大列表中使用AnimatedList而非ListView重建
  static Widget optimizedList({
    required List<Widget> children,
    required GlobalKey<AnimatedListState> listKey,
  }) {
    return AnimatedList(
      key: listKey,
      initialItemCount: children.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut)),
          ),
          child: children[index],
        );
      },
    );
  }
}
```

### 9.4 无障碍支持

```dart
// 动画无障碍支持
class AccessibleAnimations {
  // 检查用户是否禁用动画
  static bool get shouldReduceAnimations {
    return MediaQuery.of(context).disableAnimations;
  }

  // 条件动画 - 支持禁用动画偏好
  static Duration getAnimationDuration(Duration normalDuration) {
    return shouldReduceAnimations ? Duration.zero : normalDuration;
  }

  // 无障碍友好的动画组件
  static Widget accessibleAnimatedWidget({
    required Widget child,
    required Animation<double> animation,
    String? semanticsLabel,
    String? semanticsHint,
  }) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return Opacity(
            opacity: shouldReduceAnimations ? 1.0 : animation.value,
            child: Transform.scale(
              scale: shouldReduceAnimations ? 1.0 : animation.value,
              child: child,
            ),
          );
        },
      ),
    );
  }

  // 为屏幕阅读器提供状态变化公告
  static void announceStatusChange(BuildContext context, String message) {
    Semantics.of(context).announce(
      message,
      TextDirection.ltr,
    );
  }
}
```

---

## 🎯 总结

本微交互设计规范为AI智能营养餐厅系统定义了完整的动画和反馈标准，确保：

1. **一致性**: 所有交互使用统一的时长和缓动曲线
2. **专业性**: 适合健康医疗领域的稳重可信动画风格  
3. **性能**: 优化的Flutter实现确保60fps流畅体验
4. **无障碍**: 完整支持减少动画偏好和屏幕阅读器
5. **可维护**: 模块化的代码结构便于开发和维护

通过严格遵循这些规范，团队可以打造出专业、流畅、一致的用户体验。