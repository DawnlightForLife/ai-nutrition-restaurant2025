后台系统主要面向平台运营人员，用于对**用户、营养师、加盟店、推荐系统、咨询、内容、权限等**模块进行全局管理、监控与运维。

## **✅ 管理后台功能模块划分：**

| **模块编号** | **模块名称**  | **简要说明**          |
| -------- | --------- | ----------------- |
| M1       | 首页仪表盘     | 系统统计总览、最新动态、一键入口等 |
| M2       | 用户管理      | 查看用户列表、编辑资料、禁用账号等 |
| M3       | 营养档案与推荐管理 | 查看档案、生成推荐、查看反馈等   |
| M4       | 加盟店管理      | 加盟店资料、菜品审核、认证状态处理等 |
| M5       | 营养师管理     | 认证审核、档案管理、推荐跟踪等   |
| M6       | 订单与支付管理   | 订单记录、支付状态、退款处理等   |
| M7       | 内容与论坛管理   | 社区帖子、评论举报、违规审核等   |
| M8       | 咨询与评价管理   | 咨询记录、聊天监控、用户评分处理  |
| M9       | 系统与权限管理   | 管理员账户、角色权限、操作日志等  |
| M10      | 设置与公告管理   | 系统公告、页面设置、客服入口等   |

## **✳️ 页面结构清单（按模块）**

### **✅ M1：首页仪表盘**

| **页面**  | **路径建议**                                         |
| ------- | ------------------------------------------------ |
| 系统首页仪表盘 | /screens/admin/dashboard/dashboard_page.dart     |
| 系统运行状态页 | /screens/admin/dashboard/system_status_page.dart |
### **✅ M2：用户管理**

| **页面** | **路径建议**                                   |
| ------ | ------------------------------------------ |
| 用户列表页  | /screens/admin/users/user_list_page.dart   |
| 用户详情页  | /screens/admin/users/user_detail_page.dart |
| 用户编辑页  | /screens/admin/users/user_edit_page.dart   |
### **✅ M3：营养档案与推荐管理**

| **页面**  | **路径建议**                                                      |
| ------- | ------------------------------------------------------------- |
| 营养档案列表页 | /screens/admin/nutrition/nutrition_profile_list_page.dart     |
| 推荐记录列表页 | /screens/admin/recommendation/recommendation_list_page.dart   |
| 推荐详情页   | /screens/admin/recommendation/recommendation_detail_page.dart |
### **✅ M4：加盟店管理**

| **页面**  | **路径建议**                                                |
| ------- | ------------------------------------------------------- |
| 加盟店列表页   | /screens/admin/merchant/merchant_list_page.dart         |
| 加盟店详情页   | /screens/admin/merchant/merchant_detail_page.dart       |
| 加盟店认证审核页 | /screens/admin/merchant/merchant_verification_page.dart |
| 菜品审核页   | /screens/admin/merchant/dish_review_page.dart           |
### **✅ M5：营养师管理**

| **页面**   | **路径建议**                                                |
| -------- | ------------------------------------------------------- |
| 营养师列表页   | /screens/admin/nutritionist/nutritionist_list_page.dart |
| 营养师认证审核页 | /screens/admin/nutritionist/verification_page.dart      |
| 营养师推荐记录页 | /screens/admin/nutritionist/recommendation_page.dart    |
### **✅ M6：订单与支付管理**

| **页面** | **路径建议**                                      |
| ------ | --------------------------------------------- |
| 订单列表页  | /screens/admin/order/order_list_page.dart     |
| 订单详情页  | /screens/admin/order/order_detail_page.dart   |
| 支付记录页  | /screens/admin/payment/payment_list_page.dart |
### **✅ M7：内容与论坛管理**

| **页面**  | **路径建议**                                     |
| ------- | -------------------------------------------- |
| 帖子列表页   | /screens/admin/forum/post_list_page.dart     |
| 评论管理页   | /screens/admin/forum/comment_list_page.dart  |
| 举报内容审核页 | /screens/admin/forum/report_review_page.dart |
### **✅ M8：咨询与评价管理**

| **页面**  | **路径建议**                                      |
| ------- | --------------------------------------------- |
| 咨询记录列表页 | /screens/admin/consult/consult_list_page.dart |
| 聊天监控页面  | /screens/admin/consult/chat_monitor_page.dart |
| 用户评分管理页 | /screens/admin/review/user_rating_page.dart   |
### **✅ M9：系统与权限管理**

| **页面**  | **路径建议**                                        |
| ------- | ----------------------------------------------- |
| 管理员列表页  | /screens/admin/system/admin_user_list_page.dart |
| 角色权限设置页 | /screens/admin/system/role_permission_page.dart |
| 操作日志页   | /screens/admin/system/audit_log_page.dart       |
### **✅ M10：设置与公告管理**

| **页面**         | **路径建议**                                            |
| -------------- | --------------------------------------------------- |
| 系统公告列表页        | /screens/admin/settings/announcement_list_page.dart |
| 创建/编辑公告页       | /screens/admin/settings/edit_announcement_page.dart |
| 系统配置页（如AI模型开关） | /screens/admin/settings/system_config_page.dart     |
