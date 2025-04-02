# UI 组件开发规范说明

本文档定义了智慧AI营养餐厅Flutter项目中UI组件的开发规范，明确了不同类型组件的使用场景、命名约定及开发标准，避免重复定义组件和样式不一致问题。

## 组件分类与职责

### 1. 基础组件 (`common/widgets`)

基础组件是最小粒度、高度可复用的UI元素，它们应当满足以下条件：

- **通用性**：在整个应用的多个场景中重复使用
- **无业务逻辑**：不包含特定业务逻辑，仅负责UI展示
- **高度定制**：提供丰富的自定义选项以适应不同场景
- **独立性**：依赖尽可能少，仅依赖Flutter基础包

示例：
- 按钮基类
- 输入框基类
- 加载指示器
- 空状态占位图
- 分隔线
- 阴影卡片
- 标签控件

### 2. 业务组件 (`components/`)

业务组件是在基础组件之上构建的、具有特定业务场景的UI单元，它们根据功能可进一步细分：

#### 2.1 布局组件 (`components/layout/`)
负责页面结构和布局的组件。

示例：
- `app_scaffold.dart` - 应用基础脚手架
- `app_header.dart` - 应用通用头部
- `app_footer.dart` - 应用通用底部
- `section_container.dart` - 区块容器

#### 2.2 表单组件 (`components/form/`)
处理用户输入和表单操作的组件。

示例：
- `app_text_field.dart` - 应用文本输入框
- `app_dropdown.dart` - 应用下拉选择框
- `app_checkbox.dart` - 应用复选框
- `app_date_picker.dart` - 应用日期选择器

#### 2.3 对话框组件 (`components/dialogs/`)
各类弹窗和对话框组件。

示例：
- `confirmation_dialog.dart` - 确认对话框
- `error_dialog.dart` - 错误提示对话框
- `success_dialog.dart` - 成功提示对话框
- `loading_dialog.dart` - 加载对话框

#### 2.4 头像组件 (`components/avatars/`)
处理用户、商户等头像展示的组件。

示例：
- `user_avatar.dart` - 用户头像
- `merchant_avatar.dart` - 商户头像
- `nutritionist_avatar.dart` - 营养师头像

#### 2.5 按钮组件 (`components/buttons/`)
各类业务场景按钮组件。

示例：
- `primary_button.dart` - 主要按钮
- `secondary_button.dart` - 次要按钮
- `icon_button.dart` - 图标按钮
- `floating_action_button.dart` - 浮动操作按钮

#### 2.6 状态组件 (`components/states/`)
展示不同状态的组件。

示例：
- `empty_state.dart` - 空状态
- `error_state.dart` - 错误状态
- `loading_state.dart` - 加载状态
- `success_state.dart` - 成功状态

#### 2.7 媒体组件 (`components/media/`)
处理图片、视频等媒体内容的组件。

示例：
- `image_gallery.dart` - 图片画廊
- `video_player.dart` - 视频播放器
- `audio_player.dart` - 音频播放器

#### 2.8 反馈组件 (`components/feedback/`)
提供用户反馈的组件。

示例：
- `app_toast.dart` - 轻提示
- `app_snackbar.dart` - 底部提示条
- `rating_bar.dart` - 评分组件

## 命名规范

### 1. 文件命名

- 使用小写字母和下划线
- 基础组件：`[功能]_widget.dart`
- 业务组件：`app_[功能].dart` 或 `[业务]_[功能].dart`

### 2. 类命名

- 使用驼峰命名法（首字母大写）
- 基础组件：`[功能]Widget`
- 业务组件：`App[功能]` 或 `[业务][功能]`

### 3. 命名前缀规范

- `app_`：应用通用组件
- `user_`：用户相关组件
- `merchant_`：商家相关组件
- `nutritionist_`：营养师相关组件
- `admin_`：管理端相关组件
- `health_`：健康相关组件
- `order_`：订单相关组件

## 组件开发标准

### 1. 组件结构

每个组件应包含以下部分：
- 类注释：说明组件用途、使用场景
- 属性定义：必要参数和可选参数
- 构造函数：合理设置默认值
- 组件实现：清晰的代码结构
- 内部方法：职责单一、命名明确

### 2. 样式规范

- 使用应用主题中定义的颜色、字体、间距等
- 避免硬编码样式值，使用 `common/styles` 中定义的常量
- 组件内部样式应与外部隔离，避免样式泄漏
- 支持亮色/暗色模式适配

### 3. 响应式设计

- 所有组件必须支持不同屏幕尺寸
- 使用相对单位而非绝对像素
- 提供合适的约束条件避免溢出
- 测试不同设备尺寸下的显示效果

### 4. 无障碍支持

- 添加适当的语义标签
- 确保足够的对比度
- 支持屏幕阅读器
- 可通过键盘操作

### 5. 性能优化

- 合理使用 `const` 构造函数
- 避免不必要的重绘
- 大列表使用懒加载和虚拟化
- 图片资源优化

## 组件文档和示例

每个组件应提供：
- 详细的类注释
- 参数说明
- 使用示例代码
- 在组件库中的展示

## 组件开发流程

1. **规划阶段**
   - 确定组件需求和定位
   - 评估复用可能性
   - 确定组件分类

2. **开发阶段**
   - 遵循命名和结构规范
   - 实现基本功能和样式
   - 添加必要的自定义选项

3. **审查阶段**
   - 代码审查
   - UI/UX审查
   - 性能测试

4. **迭代优化**
   - 根据反馈优化组件
   - 完善文档和示例
   - 更新组件库

## 常见问题与决策准则

### 问题1：新组件应该放在哪里？

决策标准：
- 如果组件不包含业务逻辑且高度通用，放在 `common/widgets`
- 如果组件与特定业务相关或基于基础组件构建，放在 `components/` 对应子目录

### 问题2：如何避免组件重复？

解决方案：
- 开发前检查现有组件库
- 定期组织组件库评审
- 提取共性封装为基础组件
- 使用组件开发文档记录已有组件

### 问题3：组件应该多大程度支持自定义？

原则：
- 基础组件：最大程度支持自定义
- 业务组件：支持业务场景所需的自定义，保持一致性

## 结论

遵循本文档规范开发UI组件，有助于保持代码库的一致性、提高组件复用率、降低维护成本。随着项目的发展，本规范将持续更新以适应新的需求和最佳实践。

# 组件使用指南

本文档为AI营养餐厅Flutter应用组件使用指南，旨在统一组件使用方式，提高开发效率和保持UI一致性。

## 组件使用原则

1. **使用统一组件库**：优先使用项目内定义的组件，而非直接使用Flutter基础组件
2. **参数传递完整**：使用组件时应提供所有必要参数，可选参数根据需要传递
3. **遵循命名规范**：组件实例变量命名应遵循项目命名规范
4. **不修改组件内部**：如需修改组件行为，通过参数配置，而非直接修改组件源码
5. **组件复用**：相似功能应复用现有组件，而非创建新组件

## 基础组件

### 按钮 (AppButton)

```dart
AppButton(
  text: '登录',
  onPressed: () => login(),
  type: ButtonType.primary,
  size: ButtonSize.medium,
  isLoading: isLoading,
)
```

### 输入框 (CustomInput)

```dart
CustomInput(
  controller: _emailController,
  labelText: '邮箱',
  hintText: '请输入邮箱地址',
  keyboardType: TextInputType.emailAddress,
  validator: (value) => Validators.email(value),
  prefixIcon: Icons.email,
)
```

### 卡片 (AppCard)

```dart
AppCard(
  title: '营养摄入统计',
  child: NutritionStatsView(),
  padding: EdgeInsets.all(16.0),
  elevation: 2.0,
)
```

### 标签栏 (AppTabBar)

```dart
AppTabBar(
  tabs: ['今日', '本周', '本月'],
  onTabChanged: (index) => switchPeriod(index),
  selectedIndex: currentPeriodIndex,
)
```

### 成功消息 (SuccessMessage)

```dart
SuccessMessage(
  message: '订单提交成功',
  duration: Duration(seconds: 3),
  onDismiss: () => Navigator.pop(context),
)
```

### 错误消息 (ErrorMessage)

```dart
ErrorMessage(
  message: '网络连接失败',
  icon: Icons.signal_wifi_off,
  actionText: '重试',
  onAction: () => retry(),
)
```

### 下拉选择器 (CustomDropdown)

```dart
CustomDropdown<String>(
  value: selectedMeal,
  items: ['早餐', '午餐', '晚餐', '加餐'],
  onChanged: (value) => setMeal(value),
  labelText: '选择餐次',
)
```

## 对话框组件

### 确认对话框 (ConfirmDialog)

```dart
ConfirmDialog.show(
  context: context,
  title: '确认删除',
  message: '确定要删除这个饮食记录吗？此操作不可撤销。',
  confirmText: '删除',
  cancelText: '取消',
  onConfirm: () => deleteRecord(),
);
```

### 表单对话框 (FormDialog)

```dart
FormDialog.show(
  context: context,
  title: '添加备注',
  formFields: [
    TextFormField(
      controller: _noteController,
      decoration: InputDecoration(labelText: '备注内容'),
      maxLines: 3,
    ),
  ],
  onSubmit: () => saveNote(_noteController.text),
);
```

## 状态组件

### 加载指示器 (LoadingIndicator)

```dart
// 在组件内使用
LoadingIndicator(
  size: 40.0,
  color: Theme.of(context).primaryColor,
  message: '数据加载中...',
)

// 全屏加载
LoadingIndicator.fullScreenIndicator(
  context: context,
  message: '正在处理您的请求...',
);
```

### 空状态 (EmptyState)

```dart
EmptyState(
  message: '暂无饮食记录',
  subMessage: '开始记录您的第一餐吧',
  icon: Icons.restaurant,
  actionButton: AppButton(
    text: '添加记录',
    onPressed: () => addNewRecord(),
    type: ButtonType.primary,
  ),
)
```

### 骨架加载项 (SkeletonItem)

```dart
SkeletonItem(
  width: double.infinity,
  height: 80.0,
  borderRadius: BorderRadius.circular(8.0),
)
```

### 骨架列表 (SkeletonList)

```dart
SkeletonList(
  itemCount: 5,
  itemHeight: 80.0,
  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  itemBuilder: (context, index) => MealItemSkeleton(),
)
```

## 媒体组件

### 网络图片缓存组件 (CachedNetworkImageWidget)

```dart
CachedNetworkImageWidget(
  imageUrl: 'https://example.com/images/meal.jpg',
  width: 120.0,
  height: 120.0,
  fit: BoxFit.cover,
  borderRadius: BorderRadius.circular(8.0),
  placeholder: Container(
    color: Colors.grey[200],
    child: Icon(Icons.image, color: Colors.grey),
  ),
  errorWidget: Icon(Icons.broken_image, color: Colors.red),
)
```

### 图片选择器组件 (ImagePickerWidget)

```dart
ImagePickerWidget(
  onImagesSelected: (paths) {
    setState(() {
      selectedImagePaths = paths;
    });
  },
  maxImages: 3,
  allowMultiple: true,
  allowCamera: true,
  allowGallery: true,
  enableCrop: true,
  initialImages: existingImages,
)
```

### 视频播放器组件 (VideoPlayerWidget)

```dart
VideoPlayerWidget(
  videoUrl: 'https://example.com/videos/cooking_tutorial.mp4',
  isNetworkVideo: true,
  autoPlay: false,
  showControls: true,
  width: double.infinity,
  height: 240.0,
  onVideoEnd: () => showNextVideo(),
)
```

## 用户组件

### 用户头像组件 (AvatarWidget)

```dart
AvatarWidget(
  imageUrl: user.avatarUrl,
  size: 50.0,
  isOnline: user.isActive,
  showOnlineStatus: true,
  borderColor: Theme.of(context).primaryColor,
  borderWidth: 2.0,
  initials: 'JD', // 当没有头像时显示的文字
  onTap: () => navigateToProfile(user.id),
)
```

### 用户资料卡片组件 (UserProfileCard)

```dart
UserProfileCard(
  username: user.name,
  avatarUrl: user.avatarUrl,
  bio: user.bio,
  location: user.location,
  followersCount: user.followersCount,
  followingCount: user.followingCount,
  isVerified: user.isVerified,
  isFollowing: isFollowing,
  tags: user.interests,
  onFollowTap: () => toggleFollow(user.id),
  onMessageTap: () => sendMessage(user.id),
  showStats: true,
)
```

### 用户设置区域组件 (UserSettingsSection)

```dart
UserSettingsSection(
  title: '账户设置',
  icon: Icons.account_circle,
  children: [
    SettingsItem(
      title: '个人资料',
      subtitle: '编辑您的个人信息',
      icon: Icons.person,
      onTap: () => navigateToProfileEdit(),
    ),
    SettingsItem(
      title: '密码管理',
      subtitle: '更改密码和安全设置',
      icon: Icons.lock,
      onTap: () => navigateToPasswordSettings(),
    ),
    SettingsItem(
      title: '隐私设置',
      subtitle: '管理数据共享和权限',
      icon: Icons.privacy_tip,
      onTap: () => navigateToPrivacySettings(),
    ),
  ],
  collapsible: true,
  expanded: true,
)
```

## 最佳实践

1. **组织相关**：相关组件应放在一起，如表单相关组件应放在同一组件集合中
2. **错误处理**：所有用户输入组件应包含适当的错误处理和反馈机制
3. **响应式设计**：组件应考虑不同屏幕尺寸的适配
4. **主题一致性**：组件应使用应用主题中定义的颜色和样式
5. **无障碍性**：关键组件应考虑无障碍支持，如提供足够的对比度和适当的标签

## 组件维护与更新

如需修改现有组件或添加新组件，请按照以下流程：

1. 提交组件变更申请
2. 经团队审核通过后进行修改
3. 更新组件文档
4. 发布组件更新通知

**注意**：由于Flutter架构已冻结，组件的核心结构不应改变，仅允许进行非破坏性的增强和错误修复。 