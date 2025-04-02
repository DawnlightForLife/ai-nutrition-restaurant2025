# 数据库模型结构冻结规范

**状态: 已冻结**

**生效日期: 2023年4月1日（核心模型） / 2023年4月10日（扩展模型）**

## 目录

1. [冻结目的](#冻结目的)
2. [冻结模型列表](#冻结模型列表)
3. [模型结构详情](#模型结构详情)
4. [开发指南](#开发指南)
5. [后续调整流程](#后续调整流程)

## 冻结目的

为确保AI营养餐厅应用的前后端开发一致性，并避免随意修改数据库结构导致的兼容性问题，现将所有核心数据库模型结构冻结。冻结后的模型结构将作为所有开发工作的基础，不得随意更改。

## 冻结模型列表

以下模型结构已冻结，任何修改必须通过正式审批流程：

### 核心模型（2023年4月1日冻结）

1. `userModel.js` - 用户模型
2. `nutritionProfileModel.js` - 营养档案模型
3. `aiRecommendationModel.js` - AI推荐模型
4. `forumPostModel.js` - 论坛帖子模型
5. `consultationModel.js` - 咨询模型
6. `merchantModel.js` - 商家模型
7. `orderModel.js` - 订单模型
8. `adminModel.js` - 管理员模型
9. `auditLogModel.js` - 审计日志模型
10. `userRoleModel.js` - 用户角色与权限模型

### 扩展模型（2023年4月10日冻结）

11. `healthDataModel.js` - 健康数据模型
12. `dishModel.js` - 菜品模型
13. `storeDishModel.js` - 商家菜品模型
14. `storeModel.js` - 店铺模型
15. `subscriptionModel.js` - 订阅模型
16. `userFavoriteModel.js` - 用户收藏模型
17. `forumCommentModel.js` - 论坛评论模型
18. `dataAccessControlModel.js` - 数据访问控制模型
19. `dbMetricsModel.js` - 数据库指标模型
20. `merchantStatsModel.js` - 商家统计模型

## 模型结构详情

### 1. userModel.js - 用户模型

**主要字段：**
- `phone`: String (必填，唯一) - 用户手机号
- `password`: String (必填) - 加密密码
- `role`: String (枚举: user, admin, nutritionist, merchant)
- `active_role`: String (枚举: user, nutritionist, merchant)
- 用户基本信息: nickname, real_name, email, avatar_url, height, weight, age, gender, activity_level
- `region`: 地区信息 (province, city)
- `dietary_preferences`: 饮食偏好 (cuisine_preference, allergies, avoided_ingredients, spicy_preference)
- `health_data`: 健康数据 (has_recent_medical_report, medical_report_url, health_issues)
- `nutritionist_verification`: 营养师认证信息
- `merchant_verification`: 商家认证信息
- `wechat_openid`, `alipay_userid`: 第三方登录
- `privacy_settings`: 隐私设置
- `data_access_controls`: 数据访问控制
- `account_status`: 账户状态

### 2. nutritionProfileModel.js - 营养档案模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `name`: String (必填) - 档案名称
- 基本信息: gender, age, height, weight, activity_level
- `health_conditions`: 健康状况
- `dietary_preferences`: 饮食偏好
- `goals`: 营养目标
- `nutrition_targets`: 目标热量和宏量素
- `notes`: 备注
- `is_family_member`: 是否为家庭成员档案
- `family_relationship`: 家庭成员关系
- `privacy_settings`: 档案隐私设置
- `access_grants`: 授权记录
- `related_health_data`: 关联的健康数据
- `recommendation_history`: 关联的AI推荐历史
- `version`: 档案版本
- `modification_history`: 修改历史

### 3. aiRecommendationModel.js - AI推荐模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `nutrition_profile_id`: ObjectId (必填，关联NutritionProfile)
- `recommendation_type`: String (枚举: dish, meal, meal_plan, diet_suggestion)
- `recommendation_time`: String (枚举: breakfast, lunch, dinner, snack, any)
- `context`: 推荐环境背景
- `filters`: 筛选条件
- `location`: 位置信息
- `recommended_dishes`: 推荐菜品
- `recommended_meal`: 套餐推荐
- `recommended_meal_plan`: 膳食计划推荐
- `diet_suggestions`: 饮食建议
- `analysis`: AI分析
- `overall_score`: 推荐总体得分
- `algorithm_info`: 算法信息

### 4. forumPostModel.js - 论坛帖子模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `title`: String (必填) - 帖子标题
- `content`: String (必填) - 帖子内容
- `images`: 图片列表
- `tags`: 标签列表
- `view_count`: 浏览数
- `like_count`: 点赞数
- `comment_count`: 评论数
- `is_pinned`: 是否置顶
- `is_highlighted`: 是否加精
- `status`: 帖子状态
- `moderation`: 审核信息
- `created_at`, `updated_at`: 创建和更新时间

### 5. consultationModel.js - 咨询模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `nutritionist_id`: ObjectId (必填，关联Nutritionist)
- `consultation_type`: String (枚举: text, voice, video, in_person)
- `status`: String (枚举: pending, scheduled, in_progress, completed, cancelled)
- `scheduled_time`: 预约时间
- `start_time`, `end_time`: 实际开始和结束时间
- `topic`: 咨询主题
- `messages`: 咨询内容记录
- `ai_recommendation_id`: 相关AI推荐
- `professional_feedback`: 营养师的专业反馈
- `follow_up_recommendations`: 后续建议
- `requires_follow_up`: 是否需要后续咨询
- `user_rating`: 用户评价
- `payment`: 费用信息

### 6. merchantModel.js - 商家模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `business_name`: String (必填) - 商家名称
- `business_type`: String (必填，枚举: restaurant, gym, maternity_center, school_company)
- `registration_number`: String (必填) - 注册号
- `tax_id`: String (必填) - 税号
- `contact`: 联系信息
- `address`: 地址信息
- `business_profile`: 营业信息
- `nutrition_features`: 营养与健康特色
- `merchant_settings`: 商家特定设置

### 7. orderModel.js - 订单模型

**主要字段：**
- `order_number`: String (必填，唯一) - 订单号
- `user_id`: ObjectId (必填，关联User)
- `merchant_id`: ObjectId (必填，关联Merchant)
- `merchant_type`: String (必填，枚举: restaurant, gym, maternity_center, school_company)
- `items`: 订单项目列表
- `nutrition_profile_id`: 使用的营养档案
- `ai_recommendation_id`: 相关的AI推荐
- `status`: 订单状态
- `order_type`: 订单类型
- `payment`: 支付信息
- `price_details`: 价格明细
- `delivery`: 配送信息
- `dine_in`: 堂食信息
- `nutrition_summary`: 订单营养摘要
- `nutrition_goal_alignment`: 订单与营养目标吻合度评分

### 8. adminModel.js - 管理员模型

**主要字段：**
- `username`: String (必填，唯一) - 用户名
- `password`: String (必填) - 加密密码
- `name`: String (必填) - 姓名
- `email`: String (必填，唯一) - 邮箱
- `phone`: String - 手机号
- `role`: String (枚举: super_admin, content_admin, user_admin, merchant_admin, data_admin, read_only)
- `permissions`: 权限列表
- `two_factor_auth`: 双因素认证
- `is_active`: 是否活跃
- 安全相关字段: password_reset_token, failed_login_attempts等
- `data_access_level`: 管理员访问分级
- `login_history`: 登录历史
- `authorized_operations`: 授权的操作范围

### 9. auditLogModel.js - 审计日志模型

**主要字段：**
- `action`: String (必填，枚举) - 操作类型
- `description`: String (必填) - 操作描述
- `actor`: 操作执行者
- `resource`: 资源信息
- `data_snapshot`: 记录操作前后的数据
- `result`: 操作结果
- `parameters`: 操作参数
- `context`: 操作环境
- `sensitivity_level`: 敏感度分级
- `created_at`: 操作时间
- `retention_policy`: 数据保留策略
- `expiry_date`: 过期时间

### 10. userRoleModel.js - 用户角色与权限模型

**主要字段：**
- `name`: String (必填，唯一) - 角色名称
- `description`: String (必填) - 角色描述
- `permissions`: 权限列表
  - `resource`: 资源类型
  - `actions`: 操作权限
- `is_system_role`: 是否系统角色
- `is_active`: 是否活跃
- `priority`: 优先级
- `created_by`: 创建者

### 11. healthDataModel.js - 健康数据模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `nutrition_profile_id`: ObjectId (必填，关联NutritionProfile)
- `data_type`: String (必填，枚举: daily_record, medical_report, body_index, nutrition_intake)
- `record_date`: Date (必填) - 记录日期
- `weight`: 体重记录
- `blood_pressure`: 血压记录
- `blood_sugar`: 血糖记录
- `heart_rate`: 心率记录
- `water_intake`: 饮水量记录
- `food_logs`: 饮食记录
- `exercise_logs`: 运动记录
- `sleep_logs`: 睡眠记录
- `mood_logs`: 情绪记录
- `medical_conditions`: 医疗状况
- `medication`: 药物使用情况
- `allergies`: 过敏记录
- `source`: 数据来源
- `verified`: 是否已验证
- `privacy_level`: 隐私级别
- `data_sharing`: 数据共享设置

### 12. dishModel.js - 菜品模型

**主要字段：**
- `name`: String (必填) - 菜品名称
- `description`: String - 菜品描述
- `categories`: 菜品分类
- `tags`: 标签列表
- `image_url`: 图片URL
- `nutrition_facts`: 营养成分
  - `calories`: 热量
  - `protein`: 蛋白质
  - `carbohydrates`: 碳水化合物
  - `fat`: 脂肪
  - `fiber`: 膳食纤维
  - `sugar`: 糖分
  - `sodium`: 钠含量
  - `cholesterol`: 胆固醇
  - `vitamins`: 维生素含量
  - `minerals`: 矿物质含量
- `ingredients`: 原料列表
- `cooking_method`: 烹饪方式
- `spicy_level`: 辣度等级
- `suitable_health_conditions`: 适合的健康状况
- `unsuitable_health_conditions`: 不适合的健康状况
- `season_availability`: 应季时间
- `average_rating`: 平均评分
- `review_count`: 评价数量

### 13. storeDishModel.js - 商家菜品模型

**主要字段：**
- `store_id`: ObjectId (必填，关联Store)
- `dish_id`: ObjectId (必填, 关联Dish)
- `merchant_id`: ObjectId (必填，关联Merchant)
- `local_price`: 本店价格
- `promotion`: 促销信息
- `available`: 是否可用
- `sales_count`: 销售数量
- `custom_nutrition_facts`: 商家自定义营养成分
- `preparation_time`: 制作时间
- `featured`: 是否为特色菜
- `is_seasonal`: 是否为季节性菜品
- `local_modifications`: 本店特色调整
- `stock_status`: 库存状态
- `active_period`: 供应时段

### 14. storeModel.js - 店铺模型

**主要字段：**
- `merchant_id`: ObjectId (必填，关联Merchant)
- `store_name`: String (必填) - 店铺名称
- `store_type`: String (必填) - 店铺类型
- `address`: 地址信息
- `contact`: 联系信息
- `business_hours`: 营业时间
- `delivery_radius`: 配送范围
- `minimum_order`: 最低订单金额
- `payment_methods`: 支付方式
- `featured_dishes`: 特色菜品
- `store_rating`: 店铺评分
- `review_count`: 评价数量
- `store_images`: 店铺图片
- `health_certificates`: 健康证书
- `special_services`: 特殊服务
- `average_preparation_time`: 平均制作时间
- `delivery_options`: 配送选项
- `in_store_dining`: 堂食信息

### 15. subscriptionModel.js - 订阅模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `plan_id`: ObjectId (必填) - 套餐ID
- `subscription_type`: String (必填) - 订阅类型
- `status`: String (必填) - 订阅状态
- `start_date`: 开始日期
- `end_date`: 结束日期
- `auto_renew`: 是否自动续费
- `items`: 订阅项目
- `billing`: 计费信息
- `payment_history`: 支付历史
- `usage_statistics`: 使用统计
- `notification_settings`: 通知设置
- `discount_applied`: 已应用折扣
- `cancellation_info`: 取消信息
- `subscription_settings`: 订阅设置

### 16. userFavoriteModel.js - 用户收藏模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `item_id`: ObjectId (必填) - 收藏项目ID
- `item_type`: String (必填) - 收藏项目类型
- `favorite_date`: 收藏日期
- `note`: 用户备注
- `custom_tags`: 自定义标签
- `collection_name`: 收藏夹名称
- `notification_enabled`: 是否开启提醒
- `last_viewed`: 最后查看时间
- `is_pinned`: 是否置顶

### 17. forumCommentModel.js - 论坛评论模型

**主要字段：**
- `user_id`: ObjectId (必填，关联User)
- `post_id`: ObjectId (必填，关联ForumPost)
- `parent_id`: ObjectId - 父评论ID
- `content`: String (必填) - 评论内容
- `images`: 图片列表
- `like_count`: 点赞数
- `is_hidden`: 是否隐藏
- `moderation`: 审核信息
- `is_expert_comment`: 是否专家评论
- `mentioned_users`: 提及的用户
- `created_at`, `updated_at`: 创建和更新时间

### 18. dataAccessControlModel.js - 数据访问控制模型

**主要字段：**
- `access_id`: String (必填, 唯一) - 访问控制ID
- `access_name`: String (必填) - 访问控制名称
- `description`: String - 描述
- `data_owner`: 数据所有者信息
- `data_requester`: 数据请求者信息
- `access_level`: 访问级别
- `resource_type`: 资源类型
- `resource_id`: 资源ID
- `granted_permissions`: 授予的权限
- `access_conditions`: 访问条件
- `time_limitations`: 时间限制
- `audit_trail`: 审计记录
- `privacy_impact_assessment`: 隐私影响评估
- `revocation_conditions`: 撤销条件
- `created_at`, `updated_at`: 创建和更新时间

### 19. dbMetricsModel.js - 数据库指标模型

**主要字段：**
- `timestamp`: Date (必填) - 时间戳
- `collection_name`: String (必填) - 集合名称
- `operation_type`: String - 操作类型
- `query_time`: 查询时间
- `index_usage`: 索引使用情况
- `documents_scanned`: 扫描的文档数
- `documents_returned`: 返回的文档数
- `total_keys_examined`: 检查的键总数
- `execution_time_millis`: 执行时间(毫秒)
- `query_shape`: 查询形状
- `user_id`: 执行查询的用户ID
- `api_endpoint`: 相关API端点
- `namespace`: 命名空间
- `index_used`: 使用的索引
- `is_sharded`: 是否分片

### 20. merchantStatsModel.js - 商家统计模型

**主要字段：**
- `merchant_id`: ObjectId (必填，关联Merchant)
- `date_range`: 日期范围
- `total_orders`: 总订单数
- `total_revenue`: 总收入
- `average_order_value`: 平均订单价值
- `popular_dishes`: 热门菜品
- `customer_demographics`: 顾客统计信息
- `peak_hours`: 高峰时段
- `order_channels`: 订单渠道分布
- `refund_rate`: 退款率
- `customer_satisfaction`: 顾客满意度
- `delivery_stats`: 配送统计
- `promotion_effectiveness`: 促销效果
- `inventory_turnover`: 库存周转
- `new_vs_returning`: 新客vs回头客
- `health_score_distribution`: 健康评分分布

## 开发指南

1. **严格遵循模型结构**：
   - 所有前端表单字段必须与后端模型字段完全匹配
   - 不得在前端或API层硬编码与数据模型不一致的字段
   - 不得绕过模型验证或类型检查

2. **使用模型的引用关系**：
   - 严格使用模型中定义的ref引用关系处理关联数据
   - 数据关联必须通过ObjectId进行，不得使用其他字段关联

3. **使用枚举值**：
   - 严格使用模型中定义的枚举值
   - 前端下拉菜单等选择组件必须与模型的枚举值保持一致

4. **必填字段处理**：
   - 确保前端表单中，数据库模型要求的必填字段都有相应的验证
   - API请求处理时必须验证所有必填字段

5. **敏感数据处理**：
   - 遵循模型字段的敏感度设置，相应地增加前端混淆和后端保护
   - 严格按照sensitivity_level处理数据展示和权限控制

## 后续调整流程

如确实需要修改模型结构，必须遵循以下流程：

1. 提出修改申请，详细说明：
   - 修改的必要性
   - 具体修改内容
   - 对现有数据的影响
   - 迁移方案

2. 获得架构师、产品经理和数据库管理员的批准

3. 制定完整的迁移计划，包括：
   - 前端适配方案
   - 后端更新方案
   - 数据迁移脚本
   - 回滚计划

4. 测试环境完整验证后才能应用到生产环境

任何未经上述流程的模型修改将被视为违规操作，可能导致系统不稳定和数据不一致。 