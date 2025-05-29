- （健康填写、AI推荐、论坛、订单等）
- ## **✅ 用户端功能模块划分：**

1. **认证模块**（/登录 / 找回密码）

2. **营养档案模块**（营养档案创建 / 编辑 / 查看）
    
3. **AI推荐模块**（推荐记录 / 推荐详情 / 反馈）
    
4. **论坛模块**（浏览帖子 / 发帖 / 评论 / 举报）
    
5. **订单模块**（历史订单 / 订单详情 / 支付状态）
    
6. **咨询模块**（营养师咨询 / 聊天 / 咨询历史）
    
7. **客服模块**（客服入口 / 问题反馈）
    
8. **个人中心模块**（资料设置 / 健康目标 / 设置）
    
9. **活动窗口模块**（推荐活动 / 广告轮播）
    
10. **其他功能**（关于我们 / 隐私协议等）

 **✳️ 1. 用户认证模块**

| **页面** | **文件路径**                                       | **功能**                         |
| ------ | ---------------------------------------------- | ------------------------------ |
| 登录页    | /screens/user/auth/login_page.dart             | 支持手机号+验证码登录 / 密码登录 / 第三方登录（预留） |
| 验证码页   | /screens/user/auth/verification_code_page.dart | 填写验证码                          |
| 找回密码页  | /screens/user/auth/reset_password_page.dart    | 通过手机号找回密码                      |
| 登录欢迎页  | /screens/user/home/landing_page.dart           | 登录前展示品牌介绍、功能简介、注册入口等           |
📌 **状态管理：** auth_provider.dart

📌 **数据服务：** auth_service.dart

📌 **组件封装：** 验证码输入、按钮 loading、Toast 提示等

 **✳️ 2. 营养档案模块**

| **页面**     | **文件路径**                                                   | **功能**                |
| ---------- | ---------------------------------------------------------- | --------------------- |
| 营养档案列表页    | /screens/user/nutrition/nutrition_profile_list_page.dart   | 显示该账号下所有档案，可新建/编辑/删除  |
| 营养档案创建/编辑页 | /screens/user/nutrition/nutrition_profile_editor.dart      | 表单填写健康基本信息、饮食偏好、生活习惯等 |
| 营养档案详情页    | /screens/user/nutrition/nutrition_profile_detail_page.dart | 查看当前档案内容，可进入推荐记录      |

📌 **状态管理：** auth_provider.dart

📌 **数据服务：** auth_service.dart

📌 **组件封装：** 验证码输入、按钮 loading、Toast 提示等


 **✳️ 3. AI推荐模块**

| **页面**  | **文件路径**                                                       | **功能**                   |
| ------- | -------------------------------------------------------------- | ------------------------ |
| 推荐记录列表页 | /screens/user/recommendation/recommendation_list_page.dart     | 当前档案下所有 AI 推荐记录，支持分类筛选   |
| 推荐详情页   | /screens/user/recommendation/recommendation_detail_page.dart   | 展示推荐的菜品组合 / 分餐方案 / 能量摄入等 |
| 推荐反馈页   | /screens/user/recommendation/recommendation_feedback_page.dart | 用户对推荐结果进行反馈，支持点赞/不喜欢等    |
📌 **状态管理：** recommendation_provider.dart

📌 **数据服务：** recommendation_service.dart

📌 **数据来源：** MongoDB recommendationModel.js

**✳️ 4. 论坛模块（营养社区）**

| **页面** | **文件路径**                                        | **功能**               |
| ------ | ----------------------------------------------- | -------------------- |
| 论坛首页   | /screens/user/forum/forum_home_page.dart        | 展示推荐帖子/话题入口          |
| 帖子列表页  | /screens/user/forum/forum_post_list_page.dart   | 所有帖子按时间/热度排序         |
| 帖子详情页  | /screens/user/forum/forum_post_detail_page.dart | 查看具体帖子及评论，支持点赞、收藏、举报 |
| 发布帖子页  | /screens/user/forum/create_post_page.dart       | 发布图文内容，选择话题标签        |
| 评论输入弹框 | /screens/user/forum/comment_input_dialog.dart   | 快速评论、@用户、插入图片等       |
📌 **状态管理：** forum_provider.dart

📌 **数据服务：** forum_service.dart

**✳️ 5. 订单模块**

| **页面**   | **文件路径**                                   | **功能**               |
| -------- | ------------------------------------------ | -------------------- |
| 订单列表页    | /screens/user/order/order_list_page.dart   | 展示历史订单，支持筛选（待支付/已完成） |
| 订单详情页    | /screens/user/order/order_detail_page.dart | 展示菜品详情、配送信息、支付状态等    |
| 支付页面（预留） | /screens/user/order/payment_page.dart      | 微信/支付宝支付页入口（暂空）      |
📌 **状态管理：** order_provider.dart

📌 **数据服务：** order_service.dart

**✳️ 6. 咨询模块**

| **页面** | **文件路径**                                        | **功能**           |
| ------ | ----------------------------------------------- | ---------------- |
| 咨询首页   | /screens/user/consult/consult_home_page.dart    | 展示推荐营养师、历史对话入口   |
| 发起咨询页  | /screens/user/consult/start_consult_page.dart   | 选择营养师、提交问题       |
| 聊天页面   | /screens/user/consult/chat_page.dart            | 实时问答界面，支持文字、图片发送 |
| 咨询记录页  | /screens/user/consult/consult_history_page.dart | 所有历史咨询记录         |
📌 **状态管理：** consult_provider.dart

📌 **数据服务：** consult_service.dart

**✳️ 7. 客服模块**

| **页面** | **文件路径**                                         | **功能**         |
| ------ | ------------------------------------------------ | -------------- |
| 客服入口页  | /screens/user/profile/customer_service_page.dart | 客服对接页，可能使用客服系统 |
| 问题反馈页  | /screens/user/profile/feedback_page.dart         | 投诉建议、功能反馈等提交入口 |
📌 **数据服务：** feedback_service.dart

 **✳️ 8. 个人中心模块**

| **页面** | **文件路径**                                     | **功能**                  |
| ------ | -------------------------------------------- | ----------------------- |
| 我的页面   | /screens/user/profile/profile_page.dart      | 展示头像、昵称、设置按钮、我的档案、我的推荐等 |
| 修改资料页  | /screens/user/profile/edit_profile_page.dart | 修改昵称、头像、联系方式等           |
| 健康目标页  | /screens/user/profile/health_goals_page.dart | 设置体重目标、饮食目标等（预留）        |
| 设置页    | /screens/user/profile/settings_page.dart     | 切换语言、退出登录、关于我们、隐私协议     |
**✳️ 9. 活动窗口模块**

| **页面**   | **文件路径**                                     | **功能**              |
| -------- | -------------------------------------------- | ------------------- |
| 首页活动横幅组件 | /components/activity/activity_banner.dart    | 轮播图展示最新活动           |
| 活动详情页    | /screens/user/home/activity_detail_page.dart | 展示活动内容，支持跳转链接或菜品推荐页 |
📌 **数据服务：** activity_service.dart（支持后台实时发布）

 **✳️ 10. 其他功能**

- 隐私协议页：/screens/user/common/privacy_policy_page.dart
    
- 关于我们页：/screens/user/common/about_page.dart