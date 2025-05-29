- 咨询服务、用户管理、评价

## **✅ 营养师端功能模块划分：**

| **模块编号** | **功能模块** | **简要说明**         |
| -------- | -------- | ---------------- |
| M1       | 认证模块     | 营养师认证流程          |
| M2       | 首页与工作台   | 总览今日待处理咨询、推荐、任务等 |
| M3       | 用户咨询管理   | 实时答疑、历史咨询查看      |
| M4       | 档案与推荐管理  | 用户营养档案查看、提交推荐方案  |
| M5       | 评价与反馈管理  | 查看用户对营养师的评分与留言   |
| M6       | 个人资料设置   | 营养师简介、资质上传、可服务时间 |
## **✳️ 页面结构清单（按模块）**

### **✅ M1 模块：登录与认证模块**

| **页面名** | **路径建议**                                                 | **功能说明**                                    |
| ------- | -------------------------------------------------------- | ------------------------------------------- |
| 营养师登录页  |                                                          | 没有单独的登录页 普通用户个人中心页面有认证入口 通过认证即该账号可以进入营养师工作台 |
| 注册/认证页  | /screens/nutritionist/auth/register_page.dart            | 注册账号并填写营养师资质资料                              |
| 认证状态页   | /screens/nutritionist/auth/verification_status_page.dart | 展示是否通过人工审核、审核意见等                            |
### **✅ M2 模块：首页与工作台**

| **页面名**  | **路径建议**                                           | **功能说明**          |
| -------- | -------------------------------------------------- | ----------------- |
| 首页仪表盘    | /screens/nutritionist/home/dashboard_page.dart     | 今日咨询、推荐数量、待处理任务汇总 |
| 我的工作计划页  | /screens/nutritionist/home/work_plan_page.dart     | 展示营养师本周服务计划和预约任务  |
| 通知与系统消息页 | /screens/nutritionist/home/notifications_page.dart | 后台发送的重要通知与提醒      |
### **✅ M3 模块：用户咨询管理**
| **页面名** | **路径建议**                                                     | **功能说明**           |
| ------- | ------------------------------------------------------------ | ------------------ |
| 咨询会话列表页 | /screens/nutritionist/consult/consult_session_list_page.dart | 展示所有正在/历史咨询会话      |
| 聊天页面    | /screens/nutritionist/consult/chat_page.dart                 | 实时文字/图片聊天，支持推荐卡片发送 |
| 会话详情页   | /screens/nutritionist/consult/session_detail_page.dart       | 查看咨询记录、发起方信息、备注    |
### **✅ M4 模块：档案与推荐管理**

| **页面名**  | **路径建议**                                                           | **功能说明**           |
| -------- | ------------------------------------------------------------------ | ------------------ |
| 用户档案列表页  | /screens/nutritionist/profile/user_profile_list_page.dart          | 查看分配给该营养师的用户营养档案   |
| 用户档案详情页  | /screens/nutritionist/profile/user_profile_detail_page.dart        | 展示档案内容，附带健康数据分析图   |
| 推荐方案撰写页  | /screens/nutritionist/recommendation/edit_recommendation_page.dart | 填写个性化推荐建议（食谱、营养建议） |
| 已提交方案列表页 | /screens/nutritionist/recommendation/submitted_list_page.dart      | 查看历史推荐记录、用户反馈状态    |
### **✅ M5 模块：评价与反馈管理**

| **页面名** | **路径建议**                                              | **功能说明**         |
| ------- | ----------------------------------------------------- | ---------------- |
| 我的评价总览页 | /screens/nutritionist/review/review_summary_page.dart | 查看综合评分、好评率、星级趋势  |
| 用户评价详情页 | /screens/nutritionist/review/review_detail_page.dart  | 浏览单个用户留言与星级详情    |
| 反馈处理页   | /screens/nutritionist/review/response_page.dart       | 回复用户不满意原因、提交整改说明 |
### **✅ M6 模块：个人资料设置**

| **页面名** | **路径建议**                                             | **功能说明**           |
| ------- | ---------------------------------------------------- | ------------------ |
| 我的资料页   | /screens/nutritionist/profile/profile_page.dart      | 展示营养师姓名、头像、简介、擅长方向 |
| 编辑资料页   | /screens/nutritionist/profile/edit_profile_page.dart | 修改联系方式、服务时段、资质上传   |
| 设置页     | /screens/nutritionist/profile/settings_page.dart     | 密码修改、退出登录、隐私说明等    |
