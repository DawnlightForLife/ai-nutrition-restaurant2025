# 营养立方组件库开发对接指南 - 完整开发方案

> **文档版本**: 1.0.0  
> **创建日期**: 2025-07-12  
> **更新日期**: 2025-07-12  
> **文档状态**: ✅ 新系统设计阶段  
> **目标受众**: Flutter开发团队、React开发团队、架构师

## 📋 目录

- [1. UI组件设计规范](#1-ui组件设计规范)
- [2. 组件库架构设计](#2-组件库架构设计)
- [3. Flutter组件库实现](#3-flutter组件库实现)
- [4. React组件库实现](#4-react组件库实现)
- [5. 组件状态管理规范](#5-组件状态管理规范)
- [6. 组件测试规范](#6-组件测试规范)
- [7. 组件文档规范](#7-组件文档规范)
- [8. 版本管理与发布](#8-版本管理与发布)
- [9. 性能优化指南](#9-性能优化指南)
- [10. 开发工具与工作流](#10-开发工具与工作流)

---

## 1. UI组件设计规范

### 1.1 品牌组件

#### 1.1.1 启动页组件 (SplashScreen)

##### 设计规范
```yaml
布局结构:
  - 全屏橙绿渐变背景
  - 居中3D立方体Logo
  - 品牌名称"营养立方"
  - 英文名称"Nutrition Cube"
  - Slogan"AI智能营养管理专家"
  - 底部加载进度条

动画效果:
  - 3D立方体旋转动画 (360度/2秒)
  - 文字渐入效果 (0.5秒延迟)
  - 进度条加载动画
  - 整体停留3.5秒后跳转

示例代码:
<SplashScreen
  logoSize={120}
  animationDuration={2000}
  displayDuration={3500}
  onComplete={navigateToMain}
/>
```

#### 1.1.2 Logo组件 (NutritionCubeLogo)

##### 3D立方体Logo
```yaml
设计要素:
  - 立方体6个面，体现营养全面性
  - 橙绿渐变色彩
  - 支持旋转动画
  - 多尺寸适配

尺寸规格:
  - 超大: 120px (启动页)
  - 大号: 64px (页面标题)
  - 中号: 32px (导航栏)
  - 小号: 24px (列表项)

示例代码:
<NutritionCubeLogo
  size="large"
  animated={true}
  variant="gradient"
/>
```

### 1.2 基础组件

#### 1.2.1 按钮组件 (Button)

##### 主按钮 (Primary Button)
```yaml
用途: 主要操作，如提交、确认、下一步
尺寸:
  - 大号: 高度48px，全宽
  - 中号: 高度40px，最小宽度120px
  - 小号: 高度32px，最小宽度80px

样式:
  默认:
    - 背景色: #FF6B35 (营养橙)
    - 文字色: #FFFFFF
    - 圆角: 8px
    - 字体: 16px/14px/12px

  按下:
    - 背景色: #E85A2F (深一度)
    - 缩放: 0.98

  禁用:
    - 背景色: #E0E0E0
    - 文字色: #9E9E9E
    - 不可点击

示例代码:
<Button 
  type="primary"
  size="large"
  onPress={handleSubmit}
  loading={isLoading}
>
  提交订单
</Button>
```

##### 次要按钮 (Secondary Button)
```yaml
用途: 次要操作，如取消、返回
样式:
  - 背景色: #FFFFFF
  - 边框: 1px solid #4CAF50
  - 文字色: #4CAF50
```

##### 文字按钮 (Text Button)
```yaml
用途: 轻量操作，如跳过、查看更多
样式:
  - 背景色: transparent
  - 文字色: #FF6B35
  - 无边框
```

##### 图标按钮 (Icon Button)
```yaml
用途: 工具栏操作，如分享、收藏
尺寸: 44x44px (热区)
图标: 24x24px
```

#### 1.1.2 输入框组件 (Input)

##### 基础输入框
```yaml
结构:
  Container:
    - 高度: 48px
    - 背景: #F5F5F5
    - 圆角: 8px
    - 边框: 1px solid transparent
    
  Input:
    - 字体: 16px
    - 颜色: #333333
    - 占位符色: #999999
    
状态:
  聚焦:
    - 边框色: #FF6B35
    - 背景色: #FFFFFF

  错误:
    - 边框色: #F44336
    - 错误文字: 12px #F44336

示例:
<InputField
  icon="phone"
  placeholder="请输入手机号"
  value={phone}
  onChange={setPhone}
  error={phoneError}
  clearable
/>
```

##### 密码输入框
```yaml
特性:
  - 显示/隐藏切换按钮
  - 密码强度指示器
  - 安全键盘
```

##### 验证码输入框
```yaml
结构:
  - 6个独立输入格
  - 自动跳转下一格
  - 支持粘贴
```

#### 1.1.3 卡片组件 (Card)

##### 基础卡片
```yaml
样式:
  - 背景: #FFFFFF
  - 圆角: 12px
  - 阴影: 0 2px 8px rgba(0,0,0,0.08)
  - 内边距: 16px
  
变体:
  - 平铺卡片: 无阴影
  - 按压卡片: 点击效果
  - 轮廓卡片: 仅边框
```

##### 商品卡片
```yaml
结构:
  图片区:
    - 尺寸: 80x80px / 120x90px
    - 圆角: 8px
    
  信息区:
    - 标题: 16px 粗体
    - 描述: 14px 灰色
    - 标签: 12px 彩色背景
    
  操作区:
    - 价格: 18px 红色
    - 按钮: 加减控件
```

#### 1.1.4 导航组件 (Navigation)

##### 底部导航栏 (BottomNavigationBar)
```yaml
Tab配置:
  首页:
    - 图标: home_outlined / home
    - 标签: "首页"
    - 功能: 主功能入口、Banner推荐

  推荐:
    - 图标: psychology_outlined / psychology
    - 标签: "推荐"
    - 功能: AI营养推荐

  论坛:
    - 图标: forum_outlined / forum
    - 标签: "论坛"
    - 功能: 社区交流

  订单:
    - 图标: receipt_long_outlined / receipt_long
    - 标签: "订单"
    - 功能: 订单管理

  我的:
    - 图标: person_outlined / person
    - 标签: "我的"
    - 功能: 个人中心

样式规范:
  - 高度: 80px (包含安全区域)
  - 背景: #FFFFFF
  - 选中色: #FF6B35 (营养橙)
  - 未选中色: #9E9E9E
  - 徽章: 红色圆点，显示未读数量

示例代码:
<BottomNavigationBar
  currentIndex={selectedIndex}
  onTap={onTabChanged}
  type="fixed"
  selectedItemColor="#FF6B35"
  unselectedItemColor="#9E9E9E"
/>
```

##### 顶部应用栏 (AppBar)
```yaml
样式配置:
  - 高度: 56px + 状态栏高度
  - 背景: #FFFFFF
  - 标题色: #212121
  - 图标色: #757575
  - 阴影: 0 1px 3px rgba(0,0,0,0.12)

功能变体:
  - 基础AppBar: 标题 + 返回按钮
  - 搜索AppBar: 搜索框 + 筛选按钮
  - 操作AppBar: 标题 + 多个操作按钮

示例代码:
<AppBar
  title="营养立方"
  centerTitle={true}
  backgroundColor="#FFFFFF"
  foregroundColor="#212121"
  elevation={1}
/>
```

#### 1.1.5 列表组件 (List)

##### 基础列表项
```yaml
结构:
  - 高度: 56px
  - 左侧图标: 24x24px
  - 标题: 16px
  - 副标题: 14px 灰色
  - 右侧箭头/开关
  
分割线:
  - 高度: 1px
  - 颜色: #F0F0F0
  - 缩进: 16px
```

##### 菜单列表
```yaml
特性:
  - 分组标题
  - 图标可选
  - 角标提示
  - 开关控件
```

#### 1.1.5 标签组件 (Tag)

```yaml
类型:
  状态标签:
    - 成功: #4CAF50 绿色
    - 警告: #FF9800 橙色
    - 错误: #F44336 红色
    - 信息: #2196F3 蓝色
    
  营养标签:
    - 低卡: #4CAF50 绿底白字
    - 高蛋白: #2196F3 蓝底白字
    - 低脂: #FF9800 橙底白字
    
尺寸:
  - 小号: 高20px，字体12px
  - 中号: 高24px，字体14px
```

### 1.2 复合组件

#### 1.2.1 导航栏组件

##### 顶部导航栏
```yaml
iOS风格:
  - 高度: 44px + 状态栏
  - 标题居中
  - 返回按钮: < 图标+文字
  
Android风格:
  - 高度: 56px
  - 标题居左
  - 返回按钮: ← 仅图标
  
通用功能:
  - 渐变背景支持
  - 透明度调节
  - 大标题模式
```

##### Tab栏
```yaml
样式:
  - 指示器: 下划线/背景块
  - 滚动: 超过5个tab
  - 固定: 5个以内
  
状态:
  - 选中: 主题色+粗体
  - 未选中: 灰色+常规
```

#### 1.2.2 搜索框组件

```yaml
结构:
  容器:
    - 高度: 36px
    - 背景: #F0F0F0
    - 圆角: 18px
    
  内容:
    - 搜索图标: 左侧16px
    - 输入区域: 可编辑
    - 清除按钮: 条件显示
    - 取消按钮: 聚焦显示
    
热门搜索:
  - 标签展示
  - 历史记录
  - 搜索建议
```

#### 1.2.3 营养专业组件

##### 营养成分卡片 (NutritionCard)
```yaml
设计规范:
  布局:
    - 卡片容器: 圆角12px，白色背景
    - 标题区: 营养成分名称 + 图标
    - 数值区: 大号数字 + 单位
    - 进度条: 显示推荐摄入比例
    - 颜色编码: 不同营养素使用专属颜色

营养素颜色:
  - 蛋白质: #E91E63 (红色)
  - 碳水化合物: #FFC107 (黄色)
  - 脂肪: #9C27B0 (紫色)
  - 纤维: #795548 (棕色)
  - 维生素: #FF5722 (橙色)

示例代码:
<NutritionCard
  type="protein"
  value={25.6}
  unit="g"
  dailyValue={45}
  percentage={57}
/>
```

##### AI推荐卡片 (AIRecommendationCard)
```yaml
设计规范:
  结构:
    - AI头像: 机器人图标
    - 推荐标题: "今日营养推荐"
    - 菜品图片: 圆角8px
    - 菜品信息: 名称、价格、营养亮点
    - 推荐理由: 简短说明
    - 操作按钮: "查看详情"、"加入购物车"

交互效果:
  - 卡片点击: 轻微缩放
  - 按钮悬停: 颜色变化
  - 加载状态: 骨架屏

示例代码:
<AIRecommendationCard
  dishName="蒸蛋羹"
  dishImage="dish_image_url"
  price={12.8}
  reason="富含优质蛋白质，适合您的增肌目标"
  onViewDetail={handleViewDetail}
  onAddToCart={handleAddToCart}
/>
```

##### 营养档案表单 (NutritionProfileForm)
```yaml
设计规范:
  步骤指示器:
    - 5步流程: 基本信息→目标→偏好→习惯→确认
    - 进度条显示当前步骤
    - 支持前进后退

表单组件:
  - 性别选择: 单选按钮组
  - 年龄段: 滑块选择器
  - 身高体重: 数字输入框
  - 目标选择: 卡片式多选
  - 偏好设置: 标签式选择

验证规则:
  - 必填项检查
  - 数值范围验证
  - 逻辑一致性检查

示例代码:
<NutritionProfileForm
  currentStep={1}
  totalSteps={5}
  onStepChange={handleStepChange}
  onSubmit={handleSubmit}
/>
```

#### 1.2.4 选择器组件

##### 单选/多选
```yaml
单选 (Radio):
  - 圆形图标
  - 选中: 实心圆
  - 动画: 缩放效果
  
多选 (Checkbox):
  - 方形图标
  - 选中: ✓ 符号
  - 动画: 弹性效果
```

##### 开关组件
```yaml
尺寸:
  - 宽: 51px
  - 高: 31px
  
状态:
  - 开启: 绿色背景
  - 关闭: 灰色背景
  - 滑块动画: 0.3s
```

#### 1.2.4 评分组件

```yaml
星级评分:
  - 5颗星展示
  - 支持半星
  - 可交互/只读
  - 大小可配置
  
显示格式:
  - ⭐⭐⭐⭐⭐ 4.8分
  - 动画填充效果
```

#### 1.2.5 步进器组件

```yaml
结构:
  [-] 28 [+]
  
样式:
  - 按钮: 28x28px
  - 数字: 最小宽度40px
  - 禁用: 灰色不可点
  
功能:
  - 最小/最大值限制
  - 长按快速增减
  - 输入框直接编辑
```

### 1.3 业务组件

#### 1.3.1 营养成分展示

```yaml
环形图组件:
  - 中心: 总热量
  - 环形: 三大营养素
  - 图例: 下方说明
  - 动画: 渐进填充
  
进度条组件:
  - 标题 + 当前/目标
  - 彩色进度条
  - 百分比显示
```

#### 1.3.2 菜品卡片

```yaml
横向布局:
  [图片] | 菜名/描述/营养标签/价格 | [操作]
  
纵向布局:
  [图片]
  菜名
  标签组
  价格/操作
  
信息展示:
  - 营养标签高亮
  - 热量醒目显示
  - 优惠信息
```

#### 1.3.3 订单状态组件

```yaml
状态流程:
  待支付 → 已支付 → 制作中 → 配送中 → 已完成
  
视觉设计:
  - 时间轴展示
  - 当前状态高亮
  - 预计时间显示
```

#### 1.3.4 地址选择组件

```yaml
结构:
  - 当前定位
  - 地址列表
  - 新增地址
  - 地图选点
  
功能:
  - 默认地址标记
  - 滑动编辑/删除
  - 搜索地址
```

### 1.4 反馈组件

#### 1.4.1 加载组件

##### 全屏加载
```yaml
样式:
  - 半透明遮罩
  - 中心loading图标
  - 可选加载文字
  
动画:
  - 旋转动画
  - 呼吸效果
  - 骨架屏
```

##### 局部加载
```yaml
下拉刷新:
  - 弹性动画
  - 三种状态
  - 自定义文案
  
上拉加载:
  - 加载更多
  - 没有更多
  - 加载失败
```

#### 1.4.2 Toast提示

```yaml
类型:
  成功: ✓ 图标 + 绿色
  失败: ✕ 图标 + 红色
  警告: ! 图标 + 橙色
  纯文字: 无图标
  
配置:
  - 显示时长: 2-5秒
  - 位置: 顶部/中心/底部
  - 可手动关闭
```

#### 1.4.3 弹窗组件

##### Alert弹窗
```yaml
结构:
  - 标题 (可选)
  - 内容
  - 按钮组 (1-2个)
  
样式:
  - 宽度: 270px
  - 圆角: 12px
  - 背景遮罩
```

##### ActionSheet
```yaml
结构:
  - 标题 (可选)
  - 选项列表
  - 取消按钮
  
交互:
  - 从底部滑出
  - 点击遮罩关闭
  - 滑动关闭
```

#### 1.4.4 空状态组件

```yaml
场景配置:
  无数据:
    - 图标: 空盒子
    - 文字: "暂无数据"
    - 按钮: "去逛逛"
    
  网络错误:
    - 图标: 断网
    - 文字: "网络连接失败"
    - 按钮: "重试"
    
  404错误:
    - 图标: 404
    - 文字: "页面不存在"
    - 按钮: "返回首页"
```

### 1.5 动画规范

#### 1.5.1 时间曲线

```yaml
缓动函数:
  - ease-out: 退出动画 (0.0, 0.0, 0.2, 1.0)
  - ease-in: 进入动画 (0.4, 0.0, 1.0, 1.0)
  - ease-in-out: 标准动画 (0.4, 0.0, 0.2, 1.0)
  - spring: 弹性动画
  
持续时间:
  - 简单动画: 200ms
  - 复杂动画: 300ms
  - 页面转场: 350ms
```

#### 1.5.2 常用动画

```yaml
淡入淡出:
  - opacity: 0 → 1
  - duration: 200ms
  
缩放:
  - scale: 0.8 → 1.0
  - 配合淡入使用
  
滑动:
  - translateX/Y
  - 配合淡入淡出
  
旋转:
  - 加载动画
  - 刷新图标
```

### 1.6 主题配置

#### 1.6.1 颜色系统

```dart
class AppColors {
  // 主题色 - 营养橙色系
  static const primary = Color(0xFFFF6B35);
  static const primaryDark = Color(0xFFE85A2F);
  static const primaryLight = Color(0xFFFF8A65);

  // 辅助色 - 健康绿色系
  static const secondary = Color(0xFF4CAF50);
  static const secondaryDark = Color(0xFF43A047);
  static const secondaryLight = Color(0xFF66BB6A);

  // 品牌渐变
  static const brandGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 功能色
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const error = Color(0xFFF44336);
  static const info = Color(0xFF2196F3);

  // 中性色
  static const textPrimary = Color(0xFF212121);
  static const textSecondary = Color(0xFF757575);
  static const textHint = Color(0xFF9E9E9E);
  static const divider = Color(0xFFE0E0E0);
  static const background = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);

  // 深色模式
  static const darkBackground = Color(0xFF121212);
  static const darkSurface = Color(0xFF1E1E1E);
  static const darkTextPrimary = Color(0xFFFFFFFF);
  static const darkTextSecondary = Color(0xFFB3B3B3);
}
```

#### 1.6.2 字体系统

```dart
class AppTextStyles {
  // 标题
  static const h1 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static const h2 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static const h3 = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  
  // 正文
  static const body1 = TextStyle(fontSize: 16, height: 1.5);
  static const body2 = TextStyle(fontSize: 14, height: 1.5);
  
  // 辅助
  static const caption = TextStyle(fontSize: 12, color: AppColors.textHint);
  static const button = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
}
```

#### 1.6.3 间距系统

```dart
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### 1.7 设计交付规范

#### 1.7.1 切图规范

```yaml
图片格式:
  - 图标: SVG (优先) / PNG @3x
  - 图片: WebP (优先) / JPG
  - 透明图: PNG
  
命名规范:
  - 图标: ic_[功能]_[状态]
  - 图片: img_[模块]_[用途]
  - 背景: bg_[位置]_[样式]
  
尺寸规范:
  - @1x: 基准尺寸
  - @2x: 2倍尺寸
  - @3x: 3倍尺寸
```

#### 1.7.2 标注规范

```yaml
必要标注:
  - 间距: 上下左右
  - 颜色: HEX值
  - 字体: 大小/字重/行高
  - 圆角: 具体数值
  - 阴影: 参数值
  
交互标注:
  - 点击区域
  - 手势操作
  - 动画说明
  - 状态变化
```

---

## 2. 组件库架构设计

### 1.1 设计原则

```yaml
组件设计原则:
  单一职责:
    - 每个组件只负责一个功能
    - 职责边界清晰明确
    - 避免功能耦合
    - 便于测试和维护

  可复用性:
    - 通过props配置不同场景
    - 避免硬编码业务逻辑
    - 支持主题定制
    - 提供丰富的API

  可组合性:
    - 小组件组合成大组件
    - 支持嵌套和继承
    - 明确的组件层次结构
    - 灵活的布局系统

  可访问性:
    - 内置无障碍支持
    - 语义化标记
    - 键盘导航支持
    - 屏幕阅读器友好

健康应用特定原则:
  数据安全:
    - 敏感数据脱敏显示
    - 输入数据验证
    - 安全的数据传递
    - 防XSS攻击

  专业性:
    - 医疗级别的准确性
    - 专业术语标准化
    - 数据展示科学性
    - 用户引导专业化
```

### 1.2 组件分层架构

```yaml
基础层 (Foundation):
  设计令牌 (Design Tokens):
    - 颜色系统: primary, secondary, semantic colors
    - 字体系统: font families, weights, sizes
    - 间距系统: spacing scale (4px基数)
    - 阴影系统: elevation levels
    - 圆角系统: border radius scale
    - 动画参数: duration, easing curves

  工具函数 (Utilities):
    - 主题切换工具
    - 响应式断点工具
    - 无障碍辅助函数
    - 数据验证工具
    - 国际化支持

原子层 (Atoms):
  基础组件:
    - Button: 按钮组件
    - Input: 输入框组件
    - Text: 文本组件
    - Icon: 图标组件
    - Image: 图片组件
    - Badge: 徽章组件
    - Avatar: 头像组件
    - Divider: 分割线组件

分子层 (Molecules):
  组合组件:
    - SearchBar: 搜索栏
    - FormField: 表单字段
    - Card: 卡片组件
    - ListItem: 列表项
    - Dropdown: 下拉选择
    - Slider: 滑块组件
    - Switch: 开关组件
    - Checkbox: 复选框

有机体层 (Organisms):
  复杂组件:
    - Header: 页面头部
    - Navigation: 导航组件
    - Form: 表单组件
    - Table: 表格组件
    - Modal: 模态框
    - Toast: 提示组件
    - Drawer: 抽屉组件

模板层 (Templates):
  页面模板:
    - PageLayout: 页面布局
    - DashboardLayout: 仪表板布局
    - FormLayout: 表单布局
    - ListLayout: 列表布局

页面层 (Pages):
  业务页面:
    - 具体业务逻辑
    - 数据获取和处理
    - 状态管理
    - 路由配置
```

### 1.3 命名规范

```yaml
组件命名:
  Flutter组件:
    基础组件: HealthyButton, HealthyInput
    业务组件: NutritionCard, MealPlanItem
    布局组件: DashboardLayout, FormLayout
    
  React组件:
    基础组件: HealthyButton, HealthyInput
    业务组件: NutritionCard, MealPlanItem
    布局组件: DashboardLayout, FormLayout

文件命名:
  Flutter:
    组件文件: healthy_button.dart
    样式文件: healthy_button_style.dart
    测试文件: healthy_button_test.dart
    
  React:
    组件文件: HealthyButton.tsx
    样式文件: HealthyButton.module.css
    测试文件: HealthyButton.test.tsx
    故事文件: HealthyButton.stories.tsx

属性命名:
  通用规则:
    - 使用驼峰命名法
    - 布尔值使用is/has前缀
    - 事件处理使用on前缀
    - 尺寸使用size/variant

  示例:
    - isLoading: boolean
    - hasError: boolean
    - onPressed: function
    - size: 'small' | 'medium' | 'large'
    - variant: 'primary' | 'secondary' | 'outline'
```

---

## 3. Flutter组件库实现

### 2.1 基础组件结构

```dart
// 基础按钮组件实现
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// 健康应用统一按钮组件
/// 
/// 提供一致的按钮样式和交互体验
/// 内置无障碍支持和主题适配
class HealthyButton extends StatefulWidget {
  /// 按钮文字
  final String text;
  
  /// 点击回调
  final VoidCallback? onPressed;
  
  /// 按钮变体
  final HealthyButtonVariant variant;
  
  /// 按钮尺寸
  final HealthyButtonSize size;
  
  /// 是否加载中
  final bool isLoading;
  
  /// 是否禁用
  final bool isDisabled;
  
  /// 图标（可选）
  final IconData? icon;
  
  /// 自定义颜色（可选）
  final Color? customColor;
  
  /// 语义化标签
  final String? semanticLabel;
  
  /// 语义化提示
  final String? semanticHint;

  const HealthyButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = HealthyButtonVariant.primary,
    this.size = HealthyButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.customColor,
    this.semanticLabel,
    this.semanticHint,
  }) : super(key: key);

  @override
  State<HealthyButton> createState() => _HealthyButtonState();
}

class _HealthyButtonState extends State<HealthyButton>
    with SingleTickerProviderStateMixin {
  
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? widget.text,
      hint: widget.semanticHint ?? '双击激活按钮',
      button: true,
      enabled: !widget.isDisabled && !widget.isLoading,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildButton(context),
          );
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    final theme = Theme.of(context);
    final buttonStyle = _getButtonStyle(context);
    
    return Material(
      color: buttonStyle.backgroundColor,
      borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
      elevation: buttonStyle.elevation,
      child: InkWell(
        onTap: _handleTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        borderRadius: BorderRadius.circular(buttonStyle.borderRadius),
        child: Container(
          padding: buttonStyle.padding,
          constraints: BoxConstraints(
            minHeight: buttonStyle.minHeight,
            minWidth: buttonStyle.minWidth,
          ),
          child: _buildButtonContent(context, buttonStyle),
        ),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context, HealthyButtonStyle style) {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: style.iconSize,
            height: style.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(style.textColor),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '处理中...',
            style: style.textStyle,
          ),
        ],
      );
    }

    final children = <Widget>[];
    
    if (widget.icon != null) {
      children.add(Icon(
        widget.icon,
        size: style.iconSize,
        color: style.textColor,
      ));
      children.add(SizedBox(width: 8));
    }
    
    children.add(Text(
      widget.text,
      style: style.textStyle,
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  HealthyButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return HealthyButtonStyleFactory.getStyle(
      context: context,
      variant: widget.variant,
      size: widget.size,
      isDisabled: widget.isDisabled,
      isPressed: _isPressed,
      customColor: widget.customColor,
    );
  }

  void _handleTap() {
    if (!widget.isDisabled && !widget.isLoading && widget.onPressed != null) {
      // 触觉反馈
      HapticFeedback.lightImpact();
      widget.onPressed!();
    }
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _resetPressedState();
  }

  void _handleTapCancel() {
    _resetPressedState();
  }

  void _resetPressedState() {
    if (_isPressed) {
      setState(() {
        _isPressed = false;
      });
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// 按钮变体枚举
enum HealthyButtonVariant {
  primary,
  secondary,
  outline,
  text,
  danger,
}

/// 按钮尺寸枚举
enum HealthyButtonSize {
  small,
  medium,
  large,
}

/// 按钮样式数据类
class HealthyButtonStyle {
  final Color backgroundColor;
  final Color textColor;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double borderRadius;
  final double elevation;
  final double minHeight;
  final double minWidth;
  final double iconSize;

  const HealthyButtonStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.textStyle,
    required this.padding,
    required this.borderRadius,
    required this.elevation,
    required this.minHeight,
    required this.minWidth,
    required this.iconSize,
  });
}

/// 按钮样式工厂类
class HealthyButtonStyleFactory {
  static HealthyButtonStyle getStyle({
    required BuildContext context,
    required HealthyButtonVariant variant,
    required HealthyButtonSize size,
    required bool isDisabled,
    required bool isPressed,
    Color? customColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // 基础尺寸配置
    final sizeConfig = _getSizeConfig(size);
    
    // 颜色配置
    final colorConfig = _getColorConfig(
      colorScheme: colorScheme,
      variant: variant,
      isDisabled: isDisabled,
      isPressed: isPressed,
      customColor: customColor,
    );
    
    return HealthyButtonStyle(
      backgroundColor: colorConfig.backgroundColor,
      textColor: colorConfig.textColor,
      textStyle: theme.textTheme.labelLarge!.copyWith(
        color: colorConfig.textColor,
        fontSize: sizeConfig.fontSize,
        fontWeight: FontWeight.w600,
      ),
      padding: sizeConfig.padding,
      borderRadius: 8.0,
      elevation: isPressed ? 0 : (variant == HealthyButtonVariant.text ? 0 : 2),
      minHeight: sizeConfig.minHeight,
      minWidth: sizeConfig.minWidth,
      iconSize: sizeConfig.iconSize,
    );
  }

  static _ButtonSizeConfig _getSizeConfig(HealthyButtonSize size) {
    switch (size) {
      case HealthyButtonSize.small:
        return _ButtonSizeConfig(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minHeight: 32,
          minWidth: 64,
          fontSize: 14,
          iconSize: 16,
        );
      case HealthyButtonSize.medium:
        return _ButtonSizeConfig(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          minHeight: 40,
          minWidth: 80,
          fontSize: 16,
          iconSize: 18,
        );
      case HealthyButtonSize.large:
        return _ButtonSizeConfig(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          minHeight: 48,
          minWidth: 120,
          fontSize: 18,
          iconSize: 20,
        );
    }
  }

  static _ButtonColorConfig _getColorConfig({
    required ColorScheme colorScheme,
    required HealthyButtonVariant variant,
    required bool isDisabled,
    required bool isPressed,
    Color? customColor,
  }) {
    if (isDisabled) {
      return _ButtonColorConfig(
        backgroundColor: colorScheme.onSurface.withOpacity(0.12),
        textColor: colorScheme.onSurface.withOpacity(0.38),
      );
    }

    final baseColor = customColor ?? colorScheme.primary;
    final onBaseColor = customColor != null 
        ? _getContrastColor(customColor) 
        : colorScheme.onPrimary;

    switch (variant) {
      case HealthyButtonVariant.primary:
        return _ButtonColorConfig(
          backgroundColor: isPressed ? _darkenColor(baseColor) : baseColor,
          textColor: onBaseColor,
        );
      case HealthyButtonVariant.secondary:
        return _ButtonColorConfig(
          backgroundColor: isPressed 
              ? colorScheme.secondary.withOpacity(0.16)
              : colorScheme.secondary.withOpacity(0.12),
          textColor: colorScheme.secondary,
        );
      case HealthyButtonVariant.outline:
        return _ButtonColorConfig(
          backgroundColor: isPressed 
              ? baseColor.withOpacity(0.08)
              : Colors.transparent,
          textColor: baseColor,
        );
      case HealthyButtonVariant.text:
        return _ButtonColorConfig(
          backgroundColor: isPressed 
              ? baseColor.withOpacity(0.08)
              : Colors.transparent,
          textColor: baseColor,
        );
      case HealthyButtonVariant.danger:
        return _ButtonColorConfig(
          backgroundColor: isPressed 
              ? _darkenColor(colorScheme.error)
              : colorScheme.error,
          textColor: colorScheme.onError,
        );
    }
  }

  static Color _darkenColor(Color color) {
    return Color.fromRGBO(
      (color.red * 0.8).round(),
      (color.green * 0.8).round(),
      (color.blue * 0.8).round(),
      color.opacity,
    );
  }

  static Color _getContrastColor(Color color) {
    // 简单的对比度计算
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

class _ButtonSizeConfig {
  final EdgeInsets padding;
  final double minHeight;
  final double minWidth;
  final double fontSize;
  final double iconSize;

  _ButtonSizeConfig({
    required this.padding,
    required this.minHeight,
    required this.minWidth,
    required this.fontSize,
    required this.iconSize,
  });
}

class _ButtonColorConfig {
  final Color backgroundColor;
  final Color textColor;

  _ButtonColorConfig({
    required this.backgroundColor,
    required this.textColor,
  });
}
```

### 2.2 营养应用特定组件

```dart
// 营养信息卡片组件
class NutritionCard extends StatelessWidget {
  final String foodName;
  final String? foodImage;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isEditable;

  const NutritionCard({
    Key? key,
    required this.foodName,
    this.foodImage,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '营养信息卡片',
      hint: '$foodName，热量${calories.toStringAsFixed(1)}卡路里，蛋白质${protein.toStringAsFixed(1)}克',
      button: true,
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                SizedBox(height: 12),
                _buildNutritionInfo(context),
                if (isEditable) ...[
                  SizedBox(height: 12),
                  _buildActionButtons(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (foodImage != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              foodImage!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                '${calories.toStringAsFixed(1)} 卡路里',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionInfo(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildNutritionItem(
            context,
            '蛋白质',
            protein,
            'g',
            Colors.blue,
          ),
        ),
        Expanded(
          child: _buildNutritionItem(
            context,
            '碳水',
            carbs,
            'g',
            Colors.orange,
          ),
        ),
        Expanded(
          child: _buildNutritionItem(
            context,
            '脂肪',
            fat,
            'g',
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionItem(
    BuildContext context,
    String label,
    double value,
    String unit,
    Color color,
  ) {
    return Semantics(
      label: label,
      value: '${value.toStringAsFixed(1)}$unit',
      child: Column(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${value.toStringAsFixed(1)}$unit',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onEdit != null)
          HealthyButton(
            text: '编辑',
            variant: HealthyButtonVariant.text,
            size: HealthyButtonSize.small,
            icon: Icons.edit,
            onPressed: onEdit,
          ),
        if (onDelete != null) ...[
          SizedBox(width: 8),
          HealthyButton(
            text: '删除',
            variant: HealthyButtonVariant.danger,
            size: HealthyButtonSize.small,
            icon: Icons.delete,
            onPressed: onDelete,
          ),
        ],
      ],
    );
  }
}

// 营养目标进度条组件
class NutritionProgressBar extends StatelessWidget {
  final String label;
  final double current;
  final double target;
  final String unit;
  final Color? color;
  final bool showPercentage;

  const NutritionProgressBar({
    Key? key,
    required this.label,
    required this.current,
    required this.target,
    required this.unit,
    this.color,
    this.showPercentage = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0.0;
    final percentage = (progress * 100).round();
    final progressColor = color ?? _getProgressColor(context, progress);

    return Semantics(
      label: '$label进度',
      value: '已完成${percentage}%，当前${current.toStringAsFixed(1)}$unit，目标${target.toStringAsFixed(1)}$unit',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${current.toStringAsFixed(1)}/${target.toStringAsFixed(1)} $unit',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: progressColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          if (showPercentage) ...[
            SizedBox(height: 4),
            Text(
              '$percentage%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: progressColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getProgressColor(BuildContext context, double progress) {
    final colorScheme = Theme.of(context).colorScheme;
    
    if (progress < 0.5) {
      return colorScheme.error;
    } else if (progress < 0.8) {
      return Colors.orange;
    } else if (progress <= 1.0) {
      return colorScheme.primary;
    } else {
      return colorScheme.error; // 超出目标
    }
  }
}
```

---

## 4. React组件库实现

### 3.1 基础组件结构

```typescript
// React基础按钮组件实现
import React, { useState, useCallback } from 'react';
import { cn } from '@/lib/utils';
import styles from './HealthyButton.module.css';

export interface HealthyButtonProps 
  extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /** 按钮变体 */
  variant?: 'primary' | 'secondary' | 'outline' | 'text' | 'danger';
  
  /** 按钮尺寸 */
  size?: 'small' | 'medium' | 'large';
  
  /** 是否加载中 */
  isLoading?: boolean;
  
  /** 左侧图标 */
  leftIcon?: React.ReactNode;
  
  /** 右侧图标 */
  rightIcon?: React.ReactNode;
  
  /** 是否为全宽按钮 */
  fullWidth?: boolean;
  
  /** 自定义类名 */
  className?: string;
  
  /** 子元素 */
  children: React.ReactNode;
}

/**
 * 健康应用统一按钮组件
 * 
 * @example
 * ```tsx
 * <HealthyButton variant="primary" size="medium" onClick={handleClick}>
 *   提交
 * </HealthyButton>
 * 
 * <HealthyButton 
 *   variant="outline" 
 *   leftIcon={<Icon name="plus" />}
 *   isLoading={isSubmitting}
 * >
 *   添加记录
 * </HealthyButton>
 * ```
 */
export const HealthyButton = React.forwardRef<
  HTMLButtonElement,
  HealthyButtonProps
>(({
  variant = 'primary',
  size = 'medium',
  isLoading = false,
  leftIcon,
  rightIcon,
  fullWidth = false,
  className,
  disabled,
  children,
  onClick,
  ...props
}, ref) => {
  const [isPressed, setIsPressed] = useState(false);

  const handleMouseDown = useCallback(() => {
    setIsPressed(true);
  }, []);

  const handleMouseUp = useCallback(() => {
    setIsPressed(false);
  }, []);

  const handleMouseLeave = useCallback(() => {
    setIsPressed(false);
  }, []);

  const handleClick = useCallback((
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    if (!disabled && !isLoading && onClick) {
      onClick(event);
    }
  }, [disabled, isLoading, onClick]);

  const buttonClasses = cn(
    styles.button,
    styles[variant],
    styles[size],
    {
      [styles.loading]: isLoading,
      [styles.disabled]: disabled,
      [styles.pressed]: isPressed,
      [styles.fullWidth]: fullWidth,
    },
    className
  );

  const isDisabled = disabled || isLoading;

  return (
    <button
      ref={ref}
      className={buttonClasses}
      disabled={isDisabled}
      onClick={handleClick}
      onMouseDown={handleMouseDown}
      onMouseUp={handleMouseUp}
      onMouseLeave={handleMouseLeave}
      aria-disabled={isDisabled}
      aria-busy={isLoading}
      {...props}
    >
      <span className={styles.content}>
        {isLoading && (
          <span className={styles.spinner} aria-hidden="true">
            <svg
              className={styles.spinnerIcon}
              viewBox="0 0 24 24"
              fill="none"
            >
              <circle
                cx="12"
                cy="12"
                r="10"
                stroke="currentColor"
                strokeWidth="2"
                strokeLinecap="round"
                strokeDasharray="32"
                strokeDashoffset="32"
              />
            </svg>
          </span>
        )}
        
        {leftIcon && !isLoading && (
          <span className={styles.leftIcon} aria-hidden="true">
            {leftIcon}
          </span>
        )}
        
        <span className={styles.text}>
          {isLoading ? '处理中...' : children}
        </span>
        
        {rightIcon && !isLoading && (
          <span className={styles.rightIcon} aria-hidden="true">
            {rightIcon}
          </span>
        )}
      </span>
    </button>
  );
});

HealthyButton.displayName = 'HealthyButton';
```

### 3.2 React组件样式

```css
/* HealthyButton.module.css */
.button {
  /* 基础样式 */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  border: 1px solid transparent;
  font-weight: 600;
  text-decoration: none;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
  
  /* 禁用默认样式 */
  outline: none;
  background: none;
  
  /* 无障碍 */
  &:focus-visible {
    outline: 2px solid var(--color-primary);
    outline-offset: 2px;
  }
  
  /* 悬停效果 */
  &:hover:not(.disabled):not(.loading) {
    transform: translateY(-1px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
  
  /* 按下效果 */
  &.pressed:not(.disabled):not(.loading) {
    transform: translateY(0) scale(0.98);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }
}

/* 变体样式 */
.primary {
  background-color: var(--color-primary);
  color: var(--color-on-primary);
  box-shadow: 0 2px 8px rgba(var(--color-primary-rgb), 0.3);
  
  &:hover:not(.disabled):not(.loading) {
    background-color: var(--color-primary-dark);
  }
}

.secondary {
  background-color: var(--color-secondary-container);
  color: var(--color-secondary);
  
  &:hover:not(.disabled):not(.loading) {
    background-color: var(--color-secondary-container-dark);
  }
}

.outline {
  background-color: transparent;
  color: var(--color-primary);
  border-color: var(--color-primary);
  
  &:hover:not(.disabled):not(.loading) {
    background-color: var(--color-primary-container);
  }
}

.text {
  background-color: transparent;
  color: var(--color-primary);
  box-shadow: none;
  
  &:hover:not(.disabled):not(.loading) {
    background-color: var(--color-primary-container);
    transform: none;
    box-shadow: none;
  }
}

.danger {
  background-color: var(--color-error);
  color: var(--color-on-error);
  box-shadow: 0 2px 8px rgba(var(--color-error-rgb), 0.3);
  
  &:hover:not(.disabled):not(.loading) {
    background-color: var(--color-error-dark);
  }
}

/* 尺寸样式 */
.small {
  padding: 8px 16px;
  min-height: 32px;
  font-size: 14px;
  gap: 6px;
}

.medium {
  padding: 12px 24px;
  min-height: 40px;
  font-size: 16px;
  gap: 8px;
}

.large {
  padding: 16px 32px;
  min-height: 48px;
  font-size: 18px;
  gap: 10px;
}

/* 状态样式 */
.disabled {
  opacity: 0.6;
  cursor: not-allowed;
  pointer-events: none;
}

.loading {
  cursor: wait;
  pointer-events: none;
}

.fullWidth {
  width: 100%;
}

/* 内容布局 */
.content {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: inherit;
}

.text {
  line-height: 1;
}

.leftIcon,
.rightIcon {
  display: flex;
  align-items: center;
  justify-content: center;
}

/* 加载动画 */
.spinner {
  display: flex;
  align-items: center;
  justify-content: center;
}

.spinnerIcon {
  width: 16px;
  height: 16px;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* 响应式设计 */
@media (max-width: 640px) {
  .button {
    min-height: 44px; /* iOS推荐的最小触摸目标 */
  }
  
  .small {
    min-height: 36px;
    padding: 10px 16px;
  }
  
  .medium {
    min-height: 44px;
    padding: 14px 24px;
  }
  
  .large {
    min-height: 52px;
    padding: 18px 32px;
  }
}

/* 减少动画偏好支持 */
@media (prefers-reduced-motion: reduce) {
  .button {
    transition: none;
  }
  
  .button:hover:not(.disabled):not(.loading) {
    transform: none;
  }
  
  .button.pressed:not(.disabled):not(.loading) {
    transform: none;
  }
  
  .spinnerIcon {
    animation: none;
  }
}

/* 高对比度模式支持 */
@media (prefers-contrast: high) {
  .button {
    border-width: 2px;
  }
  
  .primary,
  .secondary,
  .danger {
    border-color: currentColor;
  }
}
```

### 3.3 营养应用React组件

```typescript
// 营养信息卡片React组件
import React from 'react';
import { cn } from '@/lib/utils';
import { HealthyButton } from './HealthyButton';
import styles from './NutritionCard.module.css';

export interface NutritionCardProps {
  /** 食物名称 */
  foodName: string;
  
  /** 食物图片URL */
  foodImage?: string;
  
  /** 热量（卡路里） */
  calories: number;
  
  /** 蛋白质（克） */
  protein: number;
  
  /** 碳水化合物（克） */
  carbs: number;
  
  /** 脂肪（克） */
  fat: number;
  
  /** 点击回调 */
  onTap?: () => void;
  
  /** 编辑回调 */
  onEdit?: () => void;
  
  /** 删除回调 */
  onDelete?: () => void;
  
  /** 是否可编辑 */
  isEditable?: boolean;
  
  /** 自定义类名 */
  className?: string;
}

/**
 * 营养信息卡片组件
 * 
 * 用于展示食物的营养信息，包括热量和三大营养素
 */
export const NutritionCard: React.FC<NutritionCardProps> = ({
  foodName,
  foodImage,
  calories,
  protein,
  carbs,
  fat,
  onTap,
  onEdit,
  onDelete,
  isEditable = false,
  className,
}) => {
  return (
    <div 
      className={cn(styles.card, className)}
      onClick={onTap}
      role={onTap ? "button" : undefined}
      tabIndex={onTap ? 0 : undefined}
      aria-label={`营养信息卡片，${foodName}，热量${calories.toFixed(1)}卡路里`}
    >
      <div className={styles.header}>
        {foodImage && (
          <img
            src={foodImage}
            alt={foodName}
            className={styles.foodImage}
            onError={(e) => {
              // 图片加载失败时显示默认图标
              e.currentTarget.style.display = 'none';
            }}
          />
        )}
        
        <div className={styles.foodInfo}>
          <h3 className={styles.foodName}>{foodName}</h3>
          <p className={styles.calories}>
            {calories.toFixed(1)} 卡路里
          </p>
        </div>
      </div>
      
      <div className={styles.nutritionInfo}>
        <NutritionItem
          label="蛋白质"
          value={protein}
          unit="g"
          color="var(--color-nutrition-protein)"
        />
        <NutritionItem
          label="碳水"
          value={carbs}
          unit="g"
          color="var(--color-nutrition-carbs)"
        />
        <NutritionItem
          label="脂肪"
          value={fat}
          unit="g"
          color="var(--color-nutrition-fat)"
        />
      </div>
      
      {isEditable && (
        <div className={styles.actions}>
          {onEdit && (
            <HealthyButton
              variant="text"
              size="small"
              leftIcon={<EditIcon />}
              onClick={(e) => {
                e.stopPropagation();
                onEdit();
              }}
            >
              编辑
            </HealthyButton>
          )}
          
          {onDelete && (
            <HealthyButton
              variant="danger"
              size="small"
              leftIcon={<DeleteIcon />}
              onClick={(e) => {
                e.stopPropagation();
                onDelete();
              }}
            >
              删除
            </HealthyButton>
          )}
        </div>
      )}
    </div>
  );
};

// 营养素项目子组件
interface NutritionItemProps {
  label: string;
  value: number;
  unit: string;
  color: string;
}

const NutritionItem: React.FC<NutritionItemProps> = ({
  label,
  value,
  unit,
  color,
}) => {
  return (
    <div className={styles.nutritionItem}>
      <div 
        className={styles.colorIndicator}
        style={{ backgroundColor: color }}
        aria-hidden="true"
      />
      <div className={styles.value}>
        {value.toFixed(1)}{unit}
      </div>
      <div className={styles.label}>{label}</div>
    </div>
  );
};

// 图标组件（简化示例）
const EditIcon = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
    <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
  </svg>
);

const DeleteIcon = () => (
  <svg width="16" height="16" viewBox="0 0 24 24" fill="currentColor">
    <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
  </svg>
);
```

---

## 5. 组件状态管理规范

### 4.1 Flutter状态管理

```dart
// Riverpod 3.0 状态管理示例
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';

part 'nutrition_notifier.g.dart';

part 'nutrition_state.g.dart';

/// 营养数据状态 (使用Built Value)
abstract class NutritionState implements Built<NutritionState, NutritionStateBuilder> {
  BuiltList<NutritionRecord> get records;
  bool get isLoading;
  String? get error;
  NutritionSummary? get summary;

  NutritionState._();
  factory NutritionState([void Function(NutritionStateBuilder) updates]) = _$NutritionState;

  // 工厂方法提供默认值
  factory NutritionState.initial() => NutritionState((b) => b
    ..records = ListBuilder<NutritionRecord>()
    ..isLoading = false
    ..error = null
    ..summary = null);

  static Serializer<NutritionState> get serializer => _$nutritionStateSerializer;
}

/// 营养记录模型 (使用Built Value替代Freezed)
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'nutrition_record.g.dart';

abstract class NutritionRecord implements Built<NutritionRecord, NutritionRecordBuilder> {
  String get id;
  String get foodName;
  double get calories;
  double get protein;
  double get carbs;
  double get fat;
  DateTime get timestamp;
  String? get imageUrl;

  NutritionRecord._();
  factory NutritionRecord([void Function(NutritionRecordBuilder) updates]) = _$NutritionRecord;

  static Serializer<NutritionRecord> get serializer => _$nutritionRecordSerializer;
}

/// 营养汇总模型 (使用Built Value)
abstract class NutritionSummary implements Built<NutritionSummary, NutritionSummaryBuilder> {
  double get totalCalories;
  double get totalProtein;
  double get totalCarbs;
  double get totalFat;
  double get targetCalories;
  double get targetProtein;
  double get targetCarbs;
  double get targetFat;

  NutritionSummary._();
  factory NutritionSummary([void Function(NutritionSummaryBuilder) updates]) = _$NutritionSummary;

  static Serializer<NutritionSummary> get serializer => _$nutritionSummarySerializer;
}

/// 营养数据状态管理器 (Riverpod 3.0)
@riverpod
class NutritionNotifier extends _$NutritionNotifier {
  @override
  NutritionState build() {
    // 初始化状态
    return NutritionState.initial();
  }

  NutritionRepository get _repository => ref.read(nutritionRepositoryProvider);

  /// 加载营养记录
  Future<void> loadRecords({DateTime? date}) async {
    state = state.rebuild((b) => b
      ..isLoading = true
      ..error = null);
    
    try {
      final records = await _repository.getRecords(date: date);
      final summary = await _repository.getSummary(date: date);
      
      state = state.rebuild((b) => b
        ..records = ListBuilder<NutritionRecord>(records)
        ..summary = summary?.toBuilder()
        ..isLoading = false);
    } catch (error) {
      state = state.rebuild((b) => b
        ..isLoading = false
        ..error = error.toString());
    }
  }

  /// 添加营养记录
  Future<void> addRecord(NutritionRecord record) async {
    try {
      await _repository.addRecord(record);
      
      // 更新本地状态
      state = state.rebuild((b) => b
        ..records.add(record));
      
      // 重新计算汇总
      await _updateSummary();
    } catch (error) {
      state = state.rebuild((b) => b..error = error.toString());
    }
  }

  /// 更新营养记录
  Future<void> updateRecord(NutritionRecord record) async {
    try {
      await _repository.updateRecord(record);
      
      // 更新本地状态
      final updatedRecords = state.records.map((r) {
        return r.id == record.id ? record : r;
      }).toList();
      
      state = state.rebuild((b) => b
        ..records = ListBuilder<NutritionRecord>(updatedRecords));
      
      // 重新计算汇总
      await _updateSummary();
    } catch (error) {
      state = state.rebuild((b) => b..error = error.toString());
    }
  }

  /// 删除营养记录
  Future<void> deleteRecord(String recordId) async {
    try {
      await _repository.deleteRecord(recordId);
      
      // 更新本地状态
      final updatedRecords = state.records
          .where((r) => r.id != recordId)
          .toList();
      
      state = state.rebuild((b) => b
        ..records = ListBuilder<NutritionRecord>(updatedRecords));
      
      // 重新计算汇总
      await _updateSummary();
    } catch (error) {
      state = state.rebuild((b) => b..error = error.toString());
    }
  }

  /// 清除错误状态
  void clearError() {
    state = state.rebuild((b) => b..error = null);
  }

  /// 更新汇总数据
  Future<void> _updateSummary() async {
    try {
      final summary = await _repository.getSummary();
      state = state.rebuild((b) => b..summary = summary?.toBuilder());
    } catch (error) {
      // 汇总更新失败不影响主要功能
      print('Failed to update summary: $error');
    }
  }
}

/// 营养仓库提供者 (Riverpod 3.0)
@riverpod
NutritionRepository nutritionRepository(NutritionRepositoryRef ref) {
  return NutritionRepository();
}

// 注意: nutritionNotifierProvider 将由 @riverpod 注解自动生成

/// 使用示例：在Widget中使用状态
class NutritionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionState = ref.watch(nutritionNotifierProvider);
    final nutritionNotifier = ref.read(nutritionNotifierProvider.notifier);

    return Scaffold(
      body: nutritionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : nutritionState.error != null
              ? ErrorWidget(
                  error: nutritionState.error!,
                  onRetry: () => nutritionNotifier.loadRecords(),
                )
              : NutritionList(
                  records: nutritionState.records.toList(),
                  summary: nutritionState.summary,
                  onAddRecord: nutritionNotifier.addRecord,
                  onUpdateRecord: nutritionNotifier.updateRecord,
                  onDeleteRecord: nutritionNotifier.deleteRecord,
                ),
    );
  }
}
```

### 4.2 React状态管理

```typescript
// Zustand状态管理示例
import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

export interface NutritionRecord {
  id: string;
  foodName: string;
  calories: number;
  protein: number;
  carbs: number;
  fat: number;
  timestamp: Date;
  imageUrl?: string;
}

export interface NutritionSummary {
  totalCalories: number;
  totalProtein: number;
  totalCarbs: number;
  totalFat: number;
  targetCalories: number;
  targetProtein: number;
  targetCarbs: number;
  targetFat: number;
}

interface NutritionState {
  // 状态
  records: NutritionRecord[];
  summary: NutritionSummary | null;
  isLoading: boolean;
  error: string | null;
  
  // 操作
  loadRecords: (date?: Date) => Promise<void>;
  addRecord: (record: Omit<NutritionRecord, 'id'>) => Promise<void>;
  updateRecord: (record: NutritionRecord) => Promise<void>;
  deleteRecord: (recordId: string) => Promise<void>;
  clearError: () => void;
}

export const useNutritionStore = create<NutritionState>()(
  devtools(
    immer((set, get) => ({
      // 初始状态
      records: [],
      summary: null,
      isLoading: false,
      error: null,

      // 加载营养记录
      loadRecords: async (date) => {
        set((state) => {
          state.isLoading = true;
          state.error = null;
        });

        try {
          const response = await fetch(`/api/nutrition/records${date ? `?date=${date.toISOString()}` : ''}`);
          
          if (!response.ok) {
            throw new Error('Failed to load records');
          }

          const { records, summary } = await response.json();

          set((state) => {
            state.records = records;
            state.summary = summary;
            state.isLoading = false;
          });
        } catch (error) {
          set((state) => {
            state.isLoading = false;
            state.error = error instanceof Error ? error.message : 'Unknown error';
          });
        }
      },

      // 添加营养记录
      addRecord: async (recordData) => {
        try {
          const response = await fetch('/api/nutrition/records', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(recordData),
          });

          if (!response.ok) {
            throw new Error('Failed to add record');
          }

          const newRecord = await response.json();

          set((state) => {
            state.records.push(newRecord);
          });

          // 重新计算汇总
          await get().updateSummary();
        } catch (error) {
          set((state) => {
            state.error = error instanceof Error ? error.message : 'Unknown error';
          });
        }
      },

      // 更新营养记录
      updateRecord: async (record) => {
        try {
          const response = await fetch(`/api/nutrition/records/${record.id}`, {
            method: 'PUT',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(record),
          });

          if (!response.ok) {
            throw new Error('Failed to update record');
          }

          const updatedRecord = await response.json();

          set((state) => {
            const index = state.records.findIndex(r => r.id === record.id);
            if (index !== -1) {
              state.records[index] = updatedRecord;
            }
          });

          // 重新计算汇总
          await get().updateSummary();
        } catch (error) {
          set((state) => {
            state.error = error instanceof Error ? error.message : 'Unknown error';
          });
        }
      },

      // 删除营养记录
      deleteRecord: async (recordId) => {
        try {
          const response = await fetch(`/api/nutrition/records/${recordId}`, {
            method: 'DELETE',
          });

          if (!response.ok) {
            throw new Error('Failed to delete record');
          }

          set((state) => {
            state.records = state.records.filter(r => r.id !== recordId);
          });

          // 重新计算汇总
          await get().updateSummary();
        } catch (error) {
          set((state) => {
            state.error = error instanceof Error ? error.message : 'Unknown error';
          });
        }
      },

      // 清除错误状态
      clearError: () => {
        set((state) => {
          state.error = null;
        });
      },

      // 内部方法：更新汇总
      updateSummary: async () => {
        try {
          const response = await fetch('/api/nutrition/summary');
          
          if (!response.ok) {
            throw new Error('Failed to update summary');
          }

          const summary = await response.json();

          set((state) => {
            state.summary = summary;
          });
        } catch (error) {
          console.error('Failed to update summary:', error);
        }
      },
    }))
  )
);

// 使用示例：在React组件中使用状态
import React, { useEffect } from 'react';
import { useNutritionStore } from './nutrition-store';

export const NutritionScreen: React.FC = () => {
  const {
    records,
    summary,
    isLoading,
    error,
    loadRecords,
    addRecord,
    updateRecord,
    deleteRecord,
    clearError,
  } = useNutritionStore();

  useEffect(() => {
    loadRecords();
  }, [loadRecords]);

  if (isLoading) {
    return <div>加载中...</div>;
  }

  if (error) {
    return (
      <div>
        <p>错误: {error}</p>
        <button onClick={clearError}>清除错误</button>
        <button onClick={() => loadRecords()}>重试</button>
      </div>
    );
  }

  return (
    <div>
      {summary && (
        <NutritionSummaryCard summary={summary} />
      )}
      
      <NutritionList
        records={records}
        onAddRecord={addRecord}
        onUpdateRecord={updateRecord}
        onDeleteRecord={deleteRecord}
      />
    </div>
  );
};
```

### 4.3 Riverpod 3.0 状态管理最佳实践

```yaml
核心最佳实践:
  Provider生命周期管理:
    - 使用@riverpod注解自动生成Provider
    - 利用ref.onDispose()清理资源
    - 避免手动创建Provider实例
    - 使用family修饰符处理参数化Provider

  状态更新优化:
    - 使用rebuild()方法更新Built Value对象
    - 避免频繁的state赋值操作
    - 利用select()方法减少Widget重建
    - 使用ref.listen()监听状态变化

  跨组件状态共享:
    - 通过共享Provider实现状态共享
    - 使用ref.invalidate()刷新Provider
    - 利用ref.refresh()重新加载数据
    - 实现状态依赖管理

  性能优化策略:
    - 使用ConsumerWidget替代StatefulWidget
    - 利用Consumer Builder减少重建范围
    - 实现状态分片(State Slicing)
    - 使用AsyncValue处理异步状态
```

```dart
// 跨组件状态共享示例
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  User? build() {
    // 自动从持久化存储加载用户信息
    final storage = ref.read(secureStorageProvider);
    return _loadUserFromStorage(storage);
  }

  Future<void> login(String phone, String code) async {
    final authService = ref.read(authServiceProvider);
    final user = await authService.loginWithCode(phone, code);
    
    // 更新用户状态
    state = user;
    
    // 触发其他相关状态更新
    ref.invalidate(nutritionNotifierProvider);
    ref.invalidate(userProfileProvider);
  }

  Future<void> logout() async {
    // 清理用户状态
    state = null;
    
    // 清理相关缓存
    ref.invalidate(nutritionNotifierProvider);
    ref.invalidate(userProfileProvider);
    ref.invalidate(favoritesProvider);
  }
}

// 依赖用户状态的Provider
@riverpod
Future<UserProfile> userProfile(UserProfileRef ref) async {
  final user = ref.watch(userNotifierProvider);
  if (user == null) throw Exception('User not logged in');
  
  final api = ref.read(apiServiceProvider);
  return api.getUserProfile(user.id);
}

// 性能优化：状态选择器
class UserAvatarWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 只监听用户头像URL的变化，避免用户信息其他字段变化时重建
    final avatarUrl = ref.watch(
      userNotifierProvider.select((user) => user?.avatarUrl)
    );
    
    return CircleAvatar(
      backgroundImage: avatarUrl != null
          ? NetworkImage(avatarUrl)
          : const AssetImage('assets/default_avatar.png') as ImageProvider,
    );
  }
}

// 异步状态处理最佳实践
class NutritionDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nutritionAsync = ref.watch(nutritionSummaryProvider);
    
    return nutritionAsync.when(
      data: (summary) => NutritionSummaryWidget(summary: summary),
      loading: () => const ShimmerLoading(),
      error: (error, stackTrace) => ErrorRetryWidget(
        error: error,
        onRetry: () => ref.refresh(nutritionSummaryProvider),
      ),
    );
  }
}

// 状态监听器示例
class NotificationHandler extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 监听用户状态变化，显示通知
    ref.listen(userNotifierProvider, (previous, next) {
      if (previous != null && next == null) {
        // 用户退出登录
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('您已退出登录')),
        );
      } else if (previous == null && next != null) {
        // 用户登录成功
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('欢迎, ${next.name}!')),
        );
      }
    });
    
    return const SizedBox.shrink();
  }
}
```

### 4.4 状态管理性能优化指导

```yaml
Built Value性能优化:
  对象创建优化:
    - 使用工厂构造函数缓存常用对象
    - 利用Built Value的equality比较减少重建
    - 避免在build方法中创建新对象
    - 使用toBuilder()进行增量更新

  内存管理:
    - 及时释放不需要的Built Collections
    - 使用弱引用处理大型数据集
    - 实现数据分页加载
    - 定期清理过期缓存

Riverpod 3.0性能特性:
  自动优化:
    - Provider自动去重和缓存
    - 智能依赖追踪
    - 自动资源清理
    - 异步操作合并

  手动优化:
    - 使用family处理参数化状态
    - 实现状态计算缓存
    - 优化Provider依赖链
    - 减少状态订阅范围
```

```dart
// 性能优化示例
@riverpod
class OptimizedNutritionNotifier extends _$OptimizedNutritionNotifier {
  @override
  NutritionState build() {
    // 设置缓存策略
    ref.cacheFor(const Duration(minutes: 5));
    
    // 监听网络状态
    ref.listen(connectivityProvider, (previous, next) {
      if (next == ConnectivityResult.wifi) {
        // WiFi连接时同步数据
        _syncWithServer();
      }
    });
    
    return NutritionState.initial();
  }

  // 批量更新状态，减少重建次数
  Future<void> batchUpdateRecords(List<NutritionRecord> records) async {
    final currentRecords = state.records.toList();
    
    // 批量处理所有更新
    final updatedRecords = <NutritionRecord>[];
    for (final record in records) {
      // 业务逻辑处理
      updatedRecords.add(record);
    }
    
    // 一次性更新状态
    state = state.rebuild((b) => b
      ..records = ListBuilder<NutritionRecord>(
        [...currentRecords, ...updatedRecords]
      ));
  }

  // 分页加载优化
  Future<void> loadMoreRecords({int page = 1, int pageSize = 20}) async {
    if (state.isLoading) return; // 防止重复加载
    
    state = state.rebuild((b) => b..isLoading = true);
    
    try {
      final newRecords = await _repository.getRecords(
        page: page,
        pageSize: pageSize,
      );
      
      // 增量添加，避免全量重建
      if (page == 1) {
        // 首页加载，替换数据
        state = state.rebuild((b) => b
          ..records = ListBuilder<NutritionRecord>(newRecords)
          ..isLoading = false);
      } else {
        // 分页加载，追加数据
        state = state.rebuild((b) => b
          ..records.addAll(newRecords)
          ..isLoading = false);
      }
    } catch (error) {
      state = state.rebuild((b) => b
        ..isLoading = false
        ..error = error.toString());
    }
  }

  void _syncWithServer() async {
    // 后台同步，不影响UI状态
    try {
      final serverRecords = await _repository.syncWithServer();
      // 静默更新本地数据
      state = state.rebuild((b) => b
        ..records = ListBuilder<NutritionRecord>(serverRecords));
    } catch (error) {
      // 同步失败不影响用户体验
      print('Background sync failed: $error');
    }
  }
}

// 计算缓存优化
@riverpod
NutritionTrend nutritionTrend(NutritionTrendRef ref, DateTime date) {
  // 使用family参数化，自动缓存不同日期的趋势数据
  final records = ref.watch(nutritionNotifierProvider)
      .records
      .where((r) => _isSameDay(r.timestamp, date))
      .toList();
  
  return NutritionTrend.calculateFromRecords(records);
}

// 选择器性能优化
@riverpod
double todayCalories(TodayCaloriesRef ref) {
  // 只监听今日卡路里数据
  return ref.watch(
    nutritionNotifierProvider.select(
      (state) => state.records
          .where((r) => _isToday(r.timestamp))
          .fold(0.0, (sum, record) => sum + record.calories)
    )
  );
}
```

---

## 6. 组件测试规范

### 5.1 Flutter组件测试

```dart
// healthy_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:healthy_app/components/healthy_button.dart';

void main() {
  group('HealthyButton', () {
    testWidgets('renders with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthyButton(
              text: 'Test Button',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('handles tap events', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthyButton(
              text: 'Tap Me',
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      expect(tapped, isTrue);
    });

    testWidgets('shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthyButton(
              text: 'Submit',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('处理中...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is disabled when isDisabled is true', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthyButton(
              text: 'Disabled',
              isDisabled: true,
              onPressed: () {
                tapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });

    testWidgets('has correct semantics', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HealthyButton(
              text: 'Semantic Button',
              semanticLabel: 'Custom Label',
              semanticHint: 'Custom Hint',
              onPressed: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.text('Semantic Button'));
      expect(semantics.label, equals('Custom Label'));
      expect(semantics.hint, equals('Custom Hint'));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    group('variants', () {
      for (final variant in HealthyButtonVariant.values) {
        testWidgets('renders $variant variant correctly', (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: HealthyButton(
                  text: 'Test',
                  variant: variant,
                  onPressed: () {},
                ),
              ),
            ),
          );

          expect(find.text('Test'), findsOneWidget);
        });
      }
    });

    group('sizes', () {
      for (final size in HealthyButtonSize.values) {
        testWidgets('renders $size size correctly', (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: HealthyButton(
                  text: 'Test',
                  size: size,
                  onPressed: () {},
                ),
              ),
            ),
          );

          expect(find.text('Test'), findsOneWidget);
        });
      }
    });
  });

  group('NutritionCard', () {
    testWidgets('displays nutrition information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(
              foodName: 'Apple',
              calories: 95.0,
              protein: 0.5,
              carbs: 25.0,
              fat: 0.3,
            ),
          ),
        ),
      );

      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('95.0 卡路里'), findsOneWidget);
      expect(find.text('0.5g'), findsOneWidget);
      expect(find.text('25.0g'), findsOneWidget);
      expect(find.text('0.3g'), findsOneWidget);
    });

    testWidgets('shows edit and delete buttons when editable', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(
              foodName: 'Apple',
              calories: 95.0,
              protein: 0.5,
              carbs: 25.0,
              fat: 0.3,
              isEditable: true,
              onEdit: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      expect(find.text('编辑'), findsOneWidget);
      expect(find.text('删除'), findsOneWidget);
    });

    testWidgets('handles tap events', (WidgetTester tester) async {
      bool tapped = false;
      bool edited = false;
      bool deleted = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(
              foodName: 'Apple',
              calories: 95.0,
              protein: 0.5,
              carbs: 25.0,
              fat: 0.3,
              isEditable: true,
              onTap: () => tapped = true,
              onEdit: () => edited = true,
              onDelete: () => deleted = true,
            ),
          ),
        ),
      );

      // 测试主卡片点击
      await tester.tap(find.text('Apple'));
      expect(tapped, isTrue);

      // 测试编辑按钮点击
      await tester.tap(find.text('编辑'));
      expect(edited, isTrue);

      // 测试删除按钮点击
      await tester.tap(find.text('删除'));
      expect(deleted, isTrue);
    });
  });
}

// 集成测试示例
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:healthy_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Nutrition App Integration Tests', () {
    testWidgets('complete nutrition recording flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 等待应用启动
      await tester.pumpAndSettle(Duration(seconds: 2));

      // 查找并点击添加按钮
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // 填写食物信息
      await tester.enterText(find.byType(TextFormField).first, 'Apple');
      await tester.enterText(find.byType(TextFormField).at(1), '95');
      await tester.enterText(find.byType(TextFormField).at(2), '0.5');
      await tester.enterText(find.byType(TextFormField).at(3), '25');
      await tester.enterText(find.byType(TextFormField).at(4), '0.3');

      // 提交表单
      final submitButton = find.text('保存');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // 验证记录已添加
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('95.0 卡路里'), findsOneWidget);
    });

    testWidgets('nutrition summary calculation', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 添加多条营养记录
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextFormField).first, 'Food $i');
        await tester.enterText(find.byType(TextFormField).at(1), '100');
        await tester.enterText(find.byType(TextFormField).at(2), '10');
        await tester.enterText(find.byType(TextFormField).at(3), '15');
        await tester.enterText(find.byType(TextFormField).at(4), '5');

        await tester.tap(find.text('保存'));
        await tester.pumpAndSettle();
      }

      // 验证汇总数据
      expect(find.text('300.0'), findsOneWidget); // 总热量
      expect(find.text('30.0g'), findsOneWidget); // 总蛋白质
    });
  });
}
```

### 5.2 React组件测试

```typescript
// HealthyButton.test.tsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { HealthyButton } from './HealthyButton';

describe('HealthyButton', () => {
  it('renders with text', () => {
    render(<HealthyButton>Test Button</HealthyButton>);
    expect(screen.getByRole('button', { name: 'Test Button' })).toBeInTheDocument();
  });

  it('handles click events', async () => {
    const user = userEvent.setup();
    const handleClick = jest.fn();
    
    render(
      <HealthyButton onClick={handleClick}>
        Click Me
      </HealthyButton>
    );

    await user.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('shows loading state', () => {
    render(
      <HealthyButton isLoading>
        Submit
      </HealthyButton>
    );

    expect(screen.getByText('处理中...')).toBeInTheDocument();
    expect(screen.getByRole('button')).toHaveAttribute('aria-busy', 'true');
  });

  it('is disabled when disabled prop is true', async () => {
    const user = userEvent.setup();
    const handleClick = jest.fn();
    
    render(
      <HealthyButton disabled onClick={handleClick}>
        Disabled
      </HealthyButton>
    );

    const button = screen.getByRole('button');
    expect(button).toBeDisabled();

    await user.click(button);
    expect(handleClick).not.toHaveBeenCalled();
  });

  it('renders with icons', () => {
    const leftIcon = <span data-testid="left-icon">←</span>;
    const rightIcon = <span data-testid="right-icon">→</span>;
    
    render(
      <HealthyButton leftIcon={leftIcon} rightIcon={rightIcon}>
        With Icons
      </HealthyButton>
    );

    expect(screen.getByTestId('left-icon')).toBeInTheDocument();
    expect(screen.getByTestId('right-icon')).toBeInTheDocument();
  });

  describe('variants', () => {
    const variants = ['primary', 'secondary', 'outline', 'text', 'danger'] as const;
    
    variants.forEach((variant) => {
      it(`renders ${variant} variant correctly`, () => {
        render(
          <HealthyButton variant={variant}>
            {variant} Button
          </HealthyButton>
        );

        const button = screen.getByRole('button');
        expect(button).toHaveClass(variant);
      });
    });
  });

  describe('sizes', () => {
    const sizes = ['small', 'medium', 'large'] as const;
    
    sizes.forEach((size) => {
      it(`renders ${size} size correctly`, () => {
        render(
          <HealthyButton size={size}>
            {size} Button
          </HealthyButton>
        );

        const button = screen.getByRole('button');
        expect(button).toHaveClass(size);
      });
    });
  });

  describe('accessibility', () => {
    it('has correct ARIA attributes', () => {
      render(
        <HealthyButton isLoading disabled>
          Accessible Button
        </HealthyButton>
      );

      const button = screen.getByRole('button');
      expect(button).toHaveAttribute('aria-disabled', 'true');
      expect(button).toHaveAttribute('aria-busy', 'true');
    });

    it('supports keyboard navigation', async () => {
      const user = userEvent.setup();
      const handleClick = jest.fn();
      
      render(
        <HealthyButton onClick={handleClick}>
          Keyboard Button
        </HealthyButton>
      );

      const button = screen.getByRole('button');
      button.focus();
      
      await user.keyboard('{Enter}');
      expect(handleClick).toHaveBeenCalledTimes(1);

      await user.keyboard(' ');
      expect(handleClick).toHaveBeenCalledTimes(2);
    });
  });
});

// NutritionCard.test.tsx
import React from 'react';
import { render, screen, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { NutritionCard } from './NutritionCard';

describe('NutritionCard', () => {
  const mockProps = {
    foodName: 'Apple',
    calories: 95,
    protein: 0.5,
    carbs: 25,
    fat: 0.3,
  };

  it('displays nutrition information', () => {
    render(<NutritionCard {...mockProps} />);

    expect(screen.getByText('Apple')).toBeInTheDocument();
    expect(screen.getByText('95.0 卡路里')).toBeInTheDocument();
    expect(screen.getByText('0.5g')).toBeInTheDocument();
    expect(screen.getByText('25.0g')).toBeInTheDocument();
    expect(screen.getByText('0.3g')).toBeInTheDocument();
  });

  it('shows edit and delete buttons when editable', () => {
    render(
      <NutritionCard
        {...mockProps}
        isEditable
        onEdit={jest.fn()}
        onDelete={jest.fn()}
      />
    );

    expect(screen.getByText('编辑')).toBeInTheDocument();
    expect(screen.getByText('删除')).toBeInTheDocument();
  });

  it('handles click events', async () => {
    const user = userEvent.setup();
    const handleTap = jest.fn();
    const handleEdit = jest.fn();
    const handleDelete = jest.fn();
    
    render(
      <NutritionCard
        {...mockProps}
        isEditable
        onTap={handleTap}
        onEdit={handleEdit}
        onDelete={handleDelete}
      />
    );

    // 测试主卡片点击
    await user.click(screen.getByRole('button', { name: /营养信息卡片/ }));
    expect(handleTap).toHaveBeenCalledTimes(1);

    // 测试编辑按钮点击
    await user.click(screen.getByRole('button', { name: '编辑' }));
    expect(handleEdit).toHaveBeenCalledTimes(1);

    // 测试删除按钮点击
    await user.click(screen.getByRole('button', { name: '删除' }));
    expect(handleDelete).toHaveBeenCalledTimes(1);
  });

  it('handles image error gracefully', () => {
    render(
      <NutritionCard
        {...mockProps}
        foodImage="invalid-url.jpg"
      />
    );

    const image = screen.getByAltText('Apple');
    fireEvent.error(image);
    
    expect(image).toHaveStyle({ display: 'none' });
  });

  describe('accessibility', () => {
    it('has proper ARIA labels', () => {
      render(<NutritionCard {...mockProps} onTap={jest.fn()} />);

      const card = screen.getByRole('button');
      expect(card).toHaveAttribute(
        'aria-label',
        '营养信息卡片，Apple，热量95.0卡路里'
      );
    });

    it('supports keyboard navigation', async () => {
      const user = userEvent.setup();
      const handleTap = jest.fn();
      
      render(<NutritionCard {...mockProps} onTap={handleTap} />);

      const card = screen.getByRole('button');
      card.focus();
      
      await user.keyboard('{Enter}');
      expect(handleTap).toHaveBeenCalledTimes(1);
    });
  });
});

// 端到端测试 (使用 Playwright)
// e2e/nutrition.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Nutrition App', () => {
  test('complete nutrition recording flow', async ({ page }) => {
    await page.goto('/nutrition');

    // 点击添加按钮
    await page.click('[data-testid="add-nutrition-button"]');

    // 填写表单
    await page.fill('[name="foodName"]', 'Apple');
    await page.fill('[name="calories"]', '95');
    await page.fill('[name="protein"]', '0.5');
    await page.fill('[name="carbs"]', '25');
    await page.fill('[name="fat"]', '0.3');

    // 提交表单
    await page.click('button[type="submit"]');

    // 验证记录已添加
    await expect(page.locator('text=Apple')).toBeVisible();
    await expect(page.locator('text=95.0 卡路里')).toBeVisible();
  });

  test('nutrition summary updates correctly', async ({ page }) => {
    await page.goto('/nutrition');

    // 添加多条记录
    for (let i = 0; i < 3; i++) {
      await page.click('[data-testid="add-nutrition-button"]');
      await page.fill('[name="foodName"]', `Food ${i}`);
      await page.fill('[name="calories"]', '100');
      await page.fill('[name="protein"]', '10');
      await page.fill('[name="carbs"]', '15');
      await page.fill('[name="fat"]', '5');
      await page.click('button[type="submit"]');
    }

    // 验证汇总数据
    await expect(page.locator('[data-testid="total-calories"]')).toContainText('300.0');
    await expect(page.locator('[data-testid="total-protein"]')).toContainText('30.0g');
  });

  test('responsive design works correctly', async ({ page }) => {
    // 测试移动端
    await page.setViewportSize({ width: 375, height: 667 });
    await page.goto('/nutrition');

    // 验证移动端布局
    const card = page.locator('[data-testid="nutrition-card"]').first();
    await expect(card).toBeVisible();

    // 测试平板端
    await page.setViewportSize({ width: 768, height: 1024 });
    await expect(card).toBeVisible();

    // 测试桌面端
    await page.setViewportSize({ width: 1920, height: 1080 });
    await expect(card).toBeVisible();
  });
});
```

---

## 7. 组件文档规范

### 6.1 Flutter组件文档

```dart
/// 健康应用统一按钮组件
/// 
/// [HealthyButton] 提供一致的按钮样式和交互体验，内置无障碍支持和主题适配。
/// 
/// ## 基本用法
/// 
/// ```dart
/// HealthyButton(
///   text: '确认',
///   onPressed: () {
///     print('Button pressed');
///   },
/// )
/// ```
/// 
/// ## 不同变体
/// 
/// ```dart
/// // 主要按钮
/// HealthyButton(
///   text: '主要操作',
///   variant: HealthyButtonVariant.primary,
///   onPressed: () {},
/// )
/// 
/// // 次要按钮
/// HealthyButton(
///   text: '次要操作',
///   variant: HealthyButtonVariant.secondary,
///   onPressed: () {},
/// )
/// 
/// // 危险操作按钮
/// HealthyButton(
///   text: '删除',
///   variant: HealthyButtonVariant.danger,
///   onPressed: () {},
/// )
/// ```
/// 
/// ## 不同尺寸
/// 
/// ```dart
/// // 小尺寸
/// HealthyButton(
///   text: '小按钮',
///   size: HealthyButtonSize.small,
///   onPressed: () {},
/// )
/// 
/// // 大尺寸
/// HealthyButton(
///   text: '大按钮',
///   size: HealthyButtonSize.large,
///   onPressed: () {},
/// )
/// ```
/// 
/// ## 加载状态
/// 
/// ```dart
/// HealthyButton(
///   text: '保存',
///   isLoading: true,
///   onPressed: () {},
/// )
/// ```
/// 
/// ## 带图标
/// 
/// ```dart
/// HealthyButton(
///   text: '添加',
///   icon: Icons.add,
///   onPressed: () {},
/// )
/// ```
/// 
/// ## 无障碍支持
/// 
/// 组件内置无障碍支持，包括：
/// - 语义化标签
/// - 屏幕阅读器支持
/// - 键盘导航
/// - 触觉反馈
/// 
/// ```dart
/// HealthyButton(
///   text: '提交表单',
///   semanticLabel: '提交用户注册表单',
///   semanticHint: '双击提交表单数据',
///   onPressed: () {},
/// )
/// ```
/// 
/// ## 设计规范
/// 
/// - 最小触摸目标: 44x44px (iOS) / 48x48dp (Android)
/// - 圆角: 8px
/// - 字体权重: 600
/// - 动画时长: 100ms (按下), 200ms (悬停)
/// 
/// ## 技术实现
/// 
/// - 使用 [Material] 和 [InkWell] 实现水波纹效果
/// - 通过 [AnimationController] 实现按下动画
/// - 使用 [Semantics] 包装确保无障碍访问
/// - 支持触觉反馈 [HapticFeedback]
/// 
/// See also:
/// 
/// * [HealthyButtonVariant], 按钮变体枚举
/// * [HealthyButtonSize], 按钮尺寸枚举
/// * [Material Design 3 Button](https://m3.material.io/components/buttons)
class HealthyButton extends StatefulWidget {
  /// 按钮文字
  /// 
  /// 显示在按钮中央的文本内容
  final String text;

  /// 点击回调
  /// 
  /// 按钮被点击时调用的回调函数。如果为 null，按钮将被禁用。
  final VoidCallback? onPressed;

  /// 按钮变体
  /// 
  /// 定义按钮的视觉样式：
  /// - [HealthyButtonVariant.primary]: 主要按钮，用于主要操作
  /// - [HealthyButtonVariant.secondary]: 次要按钮，用于次要操作
  /// - [HealthyButtonVariant.outline]: 边框按钮，用于非主要操作
  /// - [HealthyButtonVariant.text]: 文字按钮，用于最低优先级操作
  /// - [HealthyButtonVariant.danger]: 危险按钮，用于删除等危险操作
  /// 
  /// 默认值为 [HealthyButtonVariant.primary]
  final HealthyButtonVariant variant;

  /// 按钮尺寸
  /// 
  /// 定义按钮的大小：
  /// - [HealthyButtonSize.small]: 小尺寸 (32px高)
  /// - [HealthyButtonSize.medium]: 中等尺寸 (40px高)
  /// - [HealthyButtonSize.large]: 大尺寸 (48px高)
  /// 
  /// 默认值为 [HealthyButtonSize.medium]
  final HealthyButtonSize size;

  /// 是否加载中
  /// 
  /// 当为 true 时，按钮显示加载指示器并禁用交互。
  /// 按钮文字会变为 "处理中..."
  final bool isLoading;

  /// 是否禁用
  /// 
  /// 当为 true 时，按钮被禁用且无法交互。
  /// 视觉上会显示为灰色半透明状态。
  final bool isDisabled;

  /// 图标（可选）
  /// 
  /// 显示在按钮文字左侧的图标。
  /// 如果 [isLoading] 为 true，图标会被加载指示器替换。
  final IconData? icon;

  /// 自定义颜色（可选）
  /// 
  /// 覆盖主题中的默认颜色。
  /// 仅对 [HealthyButtonVariant.primary] 变体有效。
  final Color? customColor;

  /// 语义化标签
  /// 
  /// 用于屏幕阅读器的标签文本。
  /// 如果未提供，将使用 [text] 作为标签。
  final String? semanticLabel;

  /// 语义化提示
  /// 
  /// 用于屏幕阅读器的操作提示。
  /// 默认为 "双击激活按钮"。
  final String? semanticHint;

  /// 创建一个健康应用按钮
  /// 
  /// [text] 参数是必需的，用于显示按钮文字。
  /// [onPressed] 参数定义点击回调，如果为 null 按钮将被禁用。
  const HealthyButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = HealthyButtonVariant.primary,
    this.size = HealthyButtonSize.medium,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.customColor,
    this.semanticLabel,
    this.semanticHint,
  }) : super(key: key);

  @override
  State<HealthyButton> createState() => _HealthyButtonState();
}
```

### 6.2 React组件文档

```typescript
/**
 * 健康应用统一按钮组件
 * 
 * `HealthyButton` 提供一致的按钮样式和交互体验，内置无障碍支持和主题适配。
 * 
 * @example
 * 基本用法
 * ```tsx
 * <HealthyButton onClick={() => console.log('clicked')}>
 *   确认
 * </HealthyButton>
 * ```
 * 
 * @example
 * 不同变体
 * ```tsx
 * // 主要按钮
 * <HealthyButton variant="primary">主要操作</HealthyButton>
 * 
 * // 次要按钮
 * <HealthyButton variant="secondary">次要操作</HealthyButton>
 * 
 * // 危险操作按钮
 * <HealthyButton variant="danger">删除</HealthyButton>
 * ```
 * 
 * @example
 * 不同尺寸
 * ```tsx
 * <HealthyButton size="small">小按钮</HealthyButton>
 * <HealthyButton size="large">大按钮</HealthyButton>
 * ```
 * 
 * @example
 * 加载状态
 * ```tsx
 * <HealthyButton isLoading>保存中...</HealthyButton>
 * ```
 * 
 * @example
 * 带图标
 * ```tsx
 * <HealthyButton leftIcon={<PlusIcon />}>
 *   添加记录
 * </HealthyButton>
 * ```
 * 
 * ## 无障碍支持
 * 
 * 组件内置完整的无障碍支持：
 * - 语义化HTML结构
 * - 键盘导航支持
 * - 屏幕阅读器兼容
 * - 高对比度模式支持
 * - 减少动画偏好支持
 * 
 * ## 设计规范
 * 
 * - 最小触摸目标: 44px高 (移动端)
 * - 圆角: 8px
 * - 字体权重: 600
 * - 动画时长: 200ms
 * - 支持悬停、按下、禁用等状态
 * 
 * ## 技术实现
 * 
 * - 使用CSS Modules实现样式隔离
 * - forwardRef支持ref传递
 * - 完整的TypeScript类型定义
 * - 支持所有原生button属性
 */
export interface HealthyButtonProps 
  extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  
  /** 
   * 按钮变体
   * 
   * 定义按钮的视觉样式：
   * - `primary`: 主要按钮，用于主要操作 (默认)
   * - `secondary`: 次要按钮，用于次要操作
   * - `outline`: 边框按钮，用于非主要操作  
   * - `text`: 文字按钮，用于最低优先级操作
   * - `danger`: 危险按钮，用于删除等危险操作
   * 
   * @default 'primary'
   */
  variant?: 'primary' | 'secondary' | 'outline' | 'text' | 'danger';
  
  /** 
   * 按钮尺寸
   * 
   * 定义按钮的大小：
   * - `small`: 小尺寸 (32px高)
   * - `medium`: 中等尺寸 (40px高) 
   * - `large`: 大尺寸 (48px高)
   * 
   * @default 'medium'
   */
  size?: 'small' | 'medium' | 'large';
  
  /** 
   * 是否加载中
   * 
   * 当为 true 时，按钮显示加载指示器并禁用交互。
   * 按钮文字会变为 "处理中..."
   * 
   * @default false
   */
  isLoading?: boolean;
  
  /** 
   * 左侧图标
   * 
   * 显示在按钮文字左侧的图标元素。
   * 如果 `isLoading` 为 true，图标会被加载指示器替换。
   */
  leftIcon?: React.ReactNode;
  
  /** 
   * 右侧图标
   * 
   * 显示在按钮文字右侧的图标元素。
   * 如果 `isLoading` 为 true，图标会被隐藏。
   */
  rightIcon?: React.ReactNode;
  
  /** 
   * 是否为全宽按钮
   * 
   * 当为 true 时，按钮会占满父容器的宽度。
   * 
   * @default false
   */
  fullWidth?: boolean;
  
  /** 
   * 自定义类名
   * 
   * 添加到按钮根元素的额外CSS类名。
   * 会与内置样式合并，不会覆盖默认样式。
   */
  className?: string;
  
  /** 
   * 子元素
   * 
   * 按钮的文字内容。通常是字符串，也可以是其他React元素。
   */
  children: React.ReactNode;
}
```

### 6.3 Storybook文档

```typescript
// HealthyButton.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { HealthyButton } from './HealthyButton';
import { PlusIcon, EditIcon, TrashIcon } from './icons';

const meta: Meta<typeof HealthyButton> = {
  title: 'Components/HealthyButton',
  component: HealthyButton,
  parameters: {
    layout: 'centered',
    docs: {
      description: {
        component: `
健康应用统一按钮组件，提供一致的按钮样式和交互体验。

## 特性

- 🎨 多种视觉变体 (primary, secondary, outline, text, danger)
- 📏 三种尺寸选择 (small, medium, large)  
- ♿ 完整无障碍支持
- 🔄 内置加载状态
- 🎯 图标支持
- 📱 响应式设计

## 使用场景

- **Primary**: 主要操作按钮，如提交表单、确认操作
- **Secondary**: 次要操作按钮，如取消、返回
- **Outline**: 边框按钮，用于非主要但重要的操作
- **Text**: 文字按钮，用于最低优先级的操作
- **Danger**: 危险操作按钮，如删除、清空数据
        `,
      },
    },
  },
  argTypes: {
    variant: {
      control: 'select',
      options: ['primary', 'secondary', 'outline', 'text', 'danger'],
      description: '按钮变体',
    },
    size: {
      control: 'select', 
      options: ['small', 'medium', 'large'],
      description: '按钮尺寸',
    },
    isLoading: {
      control: 'boolean',
      description: '是否显示加载状态',
    },
    fullWidth: {
      control: 'boolean',
      description: '是否占满父容器宽度',
    },
    disabled: {
      control: 'boolean',
      description: '是否禁用按钮',
    },
    children: {
      control: 'text',
      description: '按钮文字内容',
    },
  },
  args: {
    children: '按钮文字',
    variant: 'primary',
    size: 'medium',
    isLoading: false,
    fullWidth: false,
    disabled: false,
  },
};

export default meta;
type Story = StoryObj<typeof meta>;

// 基础示例
export const Default: Story = {
  args: {
    children: '默认按钮',
  },
};

// 变体示例
export const Variants: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <HealthyButton variant="primary">Primary</HealthyButton>
      <HealthyButton variant="secondary">Secondary</HealthyButton>
      <HealthyButton variant="outline">Outline</HealthyButton>
      <HealthyButton variant="text">Text</HealthyButton>
      <HealthyButton variant="danger">Danger</HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '展示所有按钮变体。Primary用于主要操作，Secondary用于次要操作，Outline用于非主要操作，Text用于最低优先级操作，Danger用于危险操作。',
      },
    },
  },
};

// 尺寸示例
export const Sizes: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '16px', alignItems: 'flex-end' }}>
      <HealthyButton size="small">Small</HealthyButton>
      <HealthyButton size="medium">Medium</HealthyButton>
      <HealthyButton size="large">Large</HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '展示不同尺寸的按钮。Small适用于紧凑的界面，Medium是默认尺寸，Large适用于重要的主要操作。',
      },
    },
  },
};

// 带图标示例
export const WithIcons: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <HealthyButton leftIcon={<PlusIcon />}>
        添加记录
      </HealthyButton>
      <HealthyButton 
        variant="outline" 
        leftIcon={<EditIcon />}
      >
        编辑
      </HealthyButton>
      <HealthyButton 
        variant="danger" 
        leftIcon={<TrashIcon />}
      >
        删除
      </HealthyButton>
      <HealthyButton 
        variant="secondary"
        rightIcon={<span>→</span>}
      >
        下一步
      </HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '展示带图标的按钮。图标可以放在文字的左侧或右侧，有助于快速识别按钮功能。',
      },
    },
  },
};

// 状态示例
export const States: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '16px', flexWrap: 'wrap' }}>
      <HealthyButton>Normal</HealthyButton>
      <HealthyButton isLoading>Loading</HealthyButton>
      <HealthyButton disabled>Disabled</HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '展示按钮的不同状态。Loading状态显示加载指示器，Disabled状态禁用交互。',
      },
    },
  },
};

// 全宽示例
export const FullWidth: Story = {
  render: () => (
    <div style={{ width: '300px' }}>
      <HealthyButton fullWidth>
        全宽按钮
      </HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '全宽按钮占满父容器的宽度，适用于表单提交等场景。',
      },
    },
  },
};

// 营养应用场景示例
export const NutritionAppScenarios: Story = {
  render: () => (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '24px', width: '400px' }}>
      {/* 营养记录操作 */}
      <div>
        <h4>营养记录操作</h4>
        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <HealthyButton 
            variant="primary"
            leftIcon={<PlusIcon />}
            fullWidth
          >
            添加营养记录
          </HealthyButton>
        </div>
      </div>

      {/* 数据分析 */}
      <div>
        <h4>数据分析</h4>
        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <HealthyButton variant="outline">
            生成报告
          </HealthyButton>
          <HealthyButton variant="secondary">
            导出数据
          </HealthyButton>
        </div>
      </div>

      {/* 危险操作 */}
      <div>
        <h4>危险操作</h4>
        <div style={{ display: 'flex', gap: '12px', marginTop: '8px' }}>
          <HealthyButton 
            variant="danger"
            size="small"
            leftIcon={<TrashIcon />}
          >
            删除记录
          </HealthyButton>
          <HealthyButton 
            variant="danger"
            size="small"
          >
            清空数据
          </HealthyButton>
        </div>
      </div>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '展示在营养健康应用中的实际使用场景，包括记录管理、数据分析、危险操作等。',
      },
    },
  },
};

// 可访问性测试
export const AccessibilityTest: Story = {
  render: () => (
    <div style={{ display: 'flex', flexDirection: 'column', gap: '16px' }}>
      <HealthyButton>
        使用Tab键导航到此按钮
      </HealthyButton>
      <HealthyButton disabled>
        禁用状态按钮
      </HealthyButton>
      <HealthyButton isLoading>
        加载状态按钮
      </HealthyButton>
    </div>
  ),
  parameters: {
    docs: {
      description: {
        story: '测试按钮的无障碍特性。使用Tab键进行导航，确保焦点样式清晰可见。屏幕阅读器会正确朗读按钮状态。',
      },
    },
  },
  play: async ({ canvasElement }) => {
    // 可以添加自动化无障碍测试
    const buttons = canvasElement.querySelectorAll('button');
    buttons.forEach(button => {
      console.log('Button ARIA attributes:', {
        'aria-disabled': button.getAttribute('aria-disabled'),
        'aria-busy': button.getAttribute('aria-busy'),
        'disabled': button.hasAttribute('disabled'),
      });
    });
  },
};
```

---

## 总结

本文档提供了AI智能营养餐厅系统的完整组件库开发指南，涵盖：

### 核心内容
1. **UI组件设计规范** - 详细的视觉设计标准和交互规范
2. **架构设计** - 组件库的技术架构和组织结构
3. **Flutter实现** - 移动端组件库的具体实现方案
4. **React实现** - Web端组件库的开发指南
5. **状态管理** - 统一的状态管理解决方案
6. **测试规范** - 完整的组件测试策略
7. **文档规范** - 标准化的组件文档要求

### 关键特色
- **设计系统化** - 统一的视觉语言和交互模式
- **跨平台一致性** - Flutter和React双端组件保持视觉和功能一致
- **可访问性优先** - 内置完整的无障碍支持
- **性能优化** - 针对组件库的专项性能优化方案
- **开发效率** - 完善的开发工具链和工作流程

### 实施价值
- **提升开发效率** - 标准化组件减少重复开发工作
- **保证用户体验** - 统一的设计语言确保体验一致性
- **降低维护成本** - 集中化管理和版本控制
- **支持业务扩展** - 灵活的组件体系支持快速业务迭代

通过遵循本指南，开发团队能够构建出高质量、高一致性的组件库，为AI智能营养餐厅系统提供坚实的UI基础。