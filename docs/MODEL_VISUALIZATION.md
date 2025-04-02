# 数据库模型可视化

本文档提供AI营养餐厅应用的数据库模型结构和关系的可视化表示，帮助开发人员快速理解模型间的关系。

## 版本说明

- **核心模型冻结:** v2.0.0 (2023年4月1日)
- **扩展模型冻结:** v2.1.0 (2023年4月10日)
- **新增功能模型:** v2.2.0 (2023年4月20日)

## 模型概览

### 核心模型（v2.0.0）

```
┌─────────────────┐      ┌────────────────────┐      ┌──────────────────┐
│                 │      │                    │      │                  │
│    用户模型     │──────▶  营养档案模型     │◀─────│    AI推荐模型    │
│   (userModel)   │      │(nutritionProfile)  │      │(aiRecommendation)│
│                 │      │                    │      │                  │
└────────┬────────┘      └────────────────────┘      └──────────────────┘
         │
         │
         │                ┌────────────────────┐      ┌──────────────────┐
         │                │                    │      │                  │
         └───────────────▶│    订单模型       │◀─────│    商家模型      │
                          │   (orderModel)     │      │  (merchantModel) │
                          │                    │      │                  │
                          └────────┬───────────┘      └──────────────────┘
                                   │
                                   │
                                   │
                          ┌────────▼───────────┐
                          │                    │
                          │   咨询模型        │
                          │(consultationModel) │
                          │                    │
                          └────────────────────┘

         ┌─────────────────┐      ┌────────────────────┐
         │                 │      │                    │
         │  论坛帖子模型   │◀─────│   管理员模型      │
         │ (forumPostModel)│      │  (adminModel)      │
         │                 │      │                    │
         └─────────────────┘      └────────────────────┘

         ┌─────────────────┐      ┌────────────────────┐
         │                 │      │                    │
         │  用户角色模型   │      │   审计日志模型    │
         │ (userRoleModel) │      │  (auditLogModel)   │
         │                 │      │                    │
         └─────────────────┘      └────────────────────┘
```

### 扩展模型（v2.1.0）

```
┌─────────────────┐      ┌────────────────────┐      ┌──────────────────┐
│                 │      │                    │      │                  │
│  健康数据模型   │◀─────▶    菜品模型       │◀─────│  商家菜品模型    │
│(healthDataModel)│      │   (dishModel)      │      │ (storeDishModel) │
│                 │      │                    │      │                  │
└─────────────────┘      └────────────────────┘      └────────┬─────────┘
                                                              │
                                                              │
┌─────────────────┐      ┌────────────────────┐      ┌───────▼──────────┐
│                 │      │                    │      │                  │
│   订阅模型      │      │   用户收藏模型     │      │    店铺模型      │
│(subscriptionModel)     │(userFavoriteModel) │      │  (storeModel)    │
│                 │      │                    │      │                  │
└─────────────────┘      └────────────────────┘      └──────────────────┘

┌─────────────────┐      ┌────────────────────┐      ┌──────────────────┐
│                 │      │                    │      │                  │
│ 论坛评论模型    │      │ 数据访问控制模型   │      │ 数据库指标模型   │
│(forumCommentModel)     │(dataAccessControl) │      │ (dbMetricsModel) │
│                 │      │                    │      │                  │
└─────────────────┘      └────────────────────┘      └──────────────────┘

                         ┌────────────────────┐
                         │                    │
                         │  商家统计模型      │
                         │(merchantStatsModel)│
                         │                    │
                         └────────────────────┘
```

### 新增功能模型（v2.2.0）

```
┌─────────────────────┐      ┌─────────────────────┐
│                     │      │                     │
│   消息提醒模型      │◀─────┤  OAuth账号绑定模型  │
│ (notificationModel) │      │ (oauthAccountModel) │
│                     │      │                     │
└──────────┬──────────┘      └─────────┬───────────┘
           │                           │
           │                           │
           ▼                           ▼
┌─────────────────────────────────────────────────┐
│                                                 │
│                   用户模型                       │
│                  (userModel)                    │
│                                                 │
└─────────────────────────────────────────────────┘
```

### 核心模型与扩展模型的关系

```
┌─────────────────────────────── 核心模型 ───────────────────────────────┐
│                                                                        │
│  ┌───────────┐       ┌───────────────┐       ┌─────────────────┐      │
│  │           │       │               │       │                 │      │
│  │ userModel │──────▶│nutritionProfile◀─────▶│aiRecommendation│      │
│  │           │       │               │       │                 │      │
│  └─────┬─────┘       └───────┬───────┘       └─────────────────┘      │
│        │                     │                                         │
│        │                     │                                         │
│        │             ┌───────▼───────┐        ┌─────────────┐         │
│        │             │               │        │             │         │
│        └────────────▶│  orderModel   │◀──────▶│merchantModel│         │
│                      │               │        │             │         │
│                      └───────────────┘        └─────────────┘         │
│                                                                        │
└─────────────────────────────────┬──────────────────────────────────────┘
                                  │
                                  │
┌─────────────────────────────────▼─────────── 扩展模型 ─────────────────┐
│                                                                        │
│  ┌───────────────┐    ┌───────────┐     ┌────────────┐  ┌──────────┐  │
│  │               │    │           │     │            │  │          │  │
│  │healthDataModel│    │ dishModel │────▶│storeDishModel│◀─storeModel│  │
│  │               │    │           │     │            │  │          │  │
│  └───────────────┘    └───────────┘     └────────────┘  └──────────┘  │
│                                                                        │
│  ┌─────────────────┐  ┌─────────────┐  ┌───────────────┐  ┌─────────┐ │
│  │                 │  │             │  │               │  │         │ │
│  │subscriptionModel│  │userFavorite │  │forumCommentModel│ │dbMetrics│ │
│  │                 │  │             │  │               │  │         │ │
│  └─────────────────┘  └─────────────┘  └───────────────┘  └─────────┘ │
│                                                                        │
└───────────────────────────────────┬────────────────────────────────────┘
                                   │
                                   │
┌──────────────────────────────────▼─────── 新增功能模型 ───────────────┐
│                                                                        │
│          ┌─────────────────┐             ┌────────────────┐           │
│          │                 │             │                │           │
│          │notificationModel│◀────────────│oauthAccountModel           │
│          │                 │             │                │           │
│          └─────────────────┘             └────────────────┘           │
│                                                                        │
└────────────────────────────────────────────────────────────────────────┘
```

## 模型详细结构

### 核心模型（v2.0.0）

#### 1. 用户模型 (userModel)

```
┌─────────────────────────────────────┐
│ userModel                           │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ phone: String                       │
│ password: String (加密)             │
│ role: String                        │
│ active_role: String                 │
│ nickname: String                    │
│ real_name: String                   │
│ email: String                       │
│ avatar_url: String                  │
│ height: Number                      │
│ weight: Number                      │
│ age: Number                         │
│ gender: String                      │
│ activity_level: String              │
│ region: Object                      │
│ dietary_preferences: Object         │
│ health_data: Object                 │
│ verification: Object                │
│ privacy_settings: Object            │
│ account_status: String              │
└─────────────────────────────────────┘
```

#### 2. 营养档案模型 (nutritionProfileModel)

```
┌─────────────────────────────────────┐
│ nutritionProfileModel               │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ name: String                        │
│ gender: String                      │
│ age: Number                         │
│ height: Number                      │
│ weight: Number                      │
│ activity_level: String              │
│ health_conditions: [String]         │
│ dietary_preferences: Object         │
│ goals: [String]                     │
│ nutrition_targets: Object           │
│ notes: String                       │
│ is_family_member: Boolean           │
│ family_relationship: String         │
│ privacy_settings: Object            │
│ version: String                     │
└─────────────────────────────────────┘
```

#### 3. AI推荐模型 (aiRecommendationModel)

```
┌─────────────────────────────────────┐
│ aiRecommendationModel               │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ nutrition_profile_id: ObjectId      │
│ recommendation_type: String         │
│ recommendation_time: String         │
│ context: Object                     │
│ filters: Object                     │
│ location: Object                    │
│ recommended_dishes: [Object]        │
│ recommended_meal: Object            │
│ recommended_meal_plan: Object       │
│ diet_suggestions: [String]          │
│ analysis: Object                    │
│ overall_score: Number               │
│ algorithm_info: Object              │
└─────────────────────────────────────┘
```

### 扩展模型（v2.1.0）

#### 11. 健康数据模型 (healthDataModel)

```
┌─────────────────────────────────────┐
│ healthDataModel                     │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ nutrition_profile_id: ObjectId      │
│ data_type: String                   │
│ record_date: Date                   │
│ weight: Number                      │
│ blood_pressure: Object              │
│ blood_sugar: Number                 │
│ heart_rate: Number                  │
│ water_intake: Number                │
│ food_logs: [Object]                 │
│ exercise_logs: [Object]             │
│ sleep_logs: Object                  │
│ mood_logs: Object                   │
│ medical_conditions: [String]        │
│ medication: [Object]                │
│ allergies: [String]                 │
│ source: String                      │
│ verified: Boolean                   │
│ privacy_level: String               │
└─────────────────────────────────────┘
```

#### 12. 菜品模型 (dishModel)

```
┌─────────────────────────────────────┐
│ dishModel                           │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ name: String                        │
│ description: String                 │
│ categories: [String]                │
│ tags: [String]                      │
│ image_url: String                   │
│ nutrition_facts: Object             │
│ ingredients: [String]               │
│ cooking_method: String              │
│ spicy_level: String                 │
│ suitable_health_conditions: [String]│
│ unsuitable_health_conditions: [String]│
│ season_availability: [String]       │
│ average_rating: Number              │
│ review_count: Number                │
└─────────────────────────────────────┘
```

#### 13. 商家菜品模型 (storeDishModel)

```
┌─────────────────────────────────────┐
│ storeDishModel                      │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ store_id: ObjectId (ref: storeModel)│
│ dish_id: ObjectId (ref: dishModel)  │
│ merchant_id: ObjectId               │
│ local_price: Number                 │
│ promotion: Object                   │
│ available: Boolean                  │
│ sales_count: Number                 │
│ custom_nutrition_facts: Object      │
│ preparation_time: Number            │
│ featured: Boolean                   │
│ is_seasonal: Boolean                │
│ local_modifications: String         │
│ stock_status: String                │
│ active_period: String               │
└─────────────────────────────────────┘
```

#### 14. 店铺模型 (storeModel)

```
┌─────────────────────────────────────┐
│ storeModel                          │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ merchant_id: ObjectId               │
│ store_name: String                  │
│ store_type: String                  │
│ address: Object                     │
│ contact: Object                     │
│ business_hours: Object              │
│ delivery_radius: Number             │
│ minimum_order: Number               │
│ payment_methods: [String]           │
│ featured_dishes: [ObjectId]         │
│ store_rating: Number                │
│ review_count: Number                │
│ store_images: [String]              │
│ health_certificates: [Object]       │
│ special_services: [String]          │
│ average_preparation_time: Number    │
└─────────────────────────────────────┘
```

#### 15. 订阅模型 (subscriptionModel)

```
┌─────────────────────────────────────┐
│ subscriptionModel                   │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ plan_id: ObjectId                   │
│ subscription_type: String           │
│ status: String                      │
│ start_date: Date                    │
│ end_date: Date                      │
│ auto_renew: Boolean                 │
│ items: [Object]                     │
│ billing: Object                     │
│ payment_history: [Object]           │
│ usage_statistics: Object            │
│ notification_settings: Object       │
│ discount_applied: Object            │
│ cancellation_info: Object           │
└─────────────────────────────────────┘
```

#### 16. 用户收藏模型 (userFavoriteModel)

```
┌─────────────────────────────────────┐
│ userFavoriteModel                   │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ item_id: ObjectId                   │
│ item_type: String                   │
│ favorite_date: Date                 │
│ note: String                        │
│ custom_tags: [String]               │
│ collection_name: String             │
│ notification_enabled: Boolean       │
│ last_viewed: Date                   │
│ is_pinned: Boolean                  │
└─────────────────────────────────────┘
```

#### 17. 论坛评论模型 (forumCommentModel)

```
┌─────────────────────────────────────┐
│ forumCommentModel                   │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ post_id: ObjectId (ref: forumPost)  │
│ parent_id: ObjectId                 │
│ content: String                     │
│ images: [String]                    │
│ like_count: Number                  │
│ is_hidden: Boolean                  │
│ moderation: Object                  │
│ is_expert_comment: Boolean          │
│ mentioned_users: [ObjectId]         │
│ created_at: Date                    │
│ updated_at: Date                    │
└─────────────────────────────────────┘
```

#### 18. 数据访问控制模型 (dataAccessControlModel)

```
┌─────────────────────────────────────┐
│ dataAccessControlModel              │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ access_id: String                   │
│ access_name: String                 │
│ description: String                 │
│ data_owner: Object                  │
│ data_requester: Object              │
│ access_level: String                │
│ resource_type: String               │
│ resource_id: ObjectId               │
│ granted_permissions: [String]       │
│ access_conditions: Object           │
│ time_limitations: Object            │
│ audit_trail: [Object]               │
│ privacy_impact_assessment: Object   │
│ revocation_conditions: [String]     │
└─────────────────────────────────────┘
```

#### 19. 数据库指标模型 (dbMetricsModel)

```
┌─────────────────────────────────────┐
│ dbMetricsModel                      │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ timestamp: Date                     │
│ collection_name: String             │
│ operation_type: String              │
│ query_time: Number                  │
│ index_usage: Object                 │
│ documents_scanned: Number           │
│ documents_returned: Number          │
│ total_keys_examined: Number         │
│ execution_time_millis: Number       │
│ query_shape: Object                 │
│ user_id: ObjectId                   │
│ api_endpoint: String                │
│ namespace: String                   │
│ index_used: String                  │
│ is_sharded: Boolean                 │
└─────────────────────────────────────┘
```

#### 20. 商家统计模型 (merchantStatsModel)

```
┌─────────────────────────────────────┐
│ merchantStatsModel                  │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ merchant_id: ObjectId               │
│ date_range: Object                  │
│ total_orders: Number                │
│ total_revenue: Number               │
│ average_order_value: Number         │
│ popular_dishes: [Object]            │
│ customer_demographics: Object       │
│ peak_hours: [Object]                │
│ order_channels: Object              │
│ refund_rate: Number                 │
│ customer_satisfaction: Number       │
│ delivery_stats: Object              │
│ promotion_effectiveness: Object     │
│ inventory_turnover: Number          │
│ new_vs_returning: Object            │
│ health_score_distribution: Object   │
└─────────────────────────────────────┘
```

### 新增功能模型（v2.2.0）

#### 21. 消息提醒模型 (notificationModel)

```
┌─────────────────────────────────────┐
│ notificationModel                   │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ type: String                        │
│ title: String                       │
│ content: String                     │
│ is_read: Boolean                    │
│ read_at: Date                       │
│ related_object: {                   │
│   object_type: String               │
│   object_id: ObjectId               │
│ }                                   │
│ priority: String                    │
│ delivery_channels: [String]         │
│ push_status: Object                 │
│ created_at: Date                    │
│ updated_at: Date                    │
│ expires_at: Date                    │
└─────────────────────────────────────┘
```

#### 22. OAuth账号绑定模型 (oauthAccountModel)

```
┌─────────────────────────────────────┐
│ oauthAccountModel                   │
├─────────────────────────────────────┤
│ _id: ObjectId                       │
│ user_id: ObjectId (ref: userModel)  │
│ provider: String                    │
│ wechat: {                           │
│   openid: String                    │
│   unionid: String                   │
│   nickname: String                  │
│   headimgurl: String                │
│   ... (其他微信用户信息)            │
│ }                                   │
│ alipay: {                           │
│   user_id: String                   │
│   nick_name: String                 │
│   ... (其他支付宝用户信息)          │
│ }                                   │
│ common: {                           │
│   platform_uid: String              │
│   platform_token: String            │
│   platform_email: String            │
│   ... (其他通用平台信息)            │
│ }                                   │
│ access_token: String (加密)         │
│ refresh_token: String (加密)        │
│ access_token_expires_at: Date       │
│ refresh_token_expires_at: Date      │
│ is_active: Boolean                  │
│ is_primary: Boolean                 │
│ created_at: Date                    │
│ updated_at: Date                    │
│ last_used_at: Date                  │
└─────────────────────────────────────┘
```

## 模型关系说明

1. **用户与营养档案**: 一个用户可以创建多个营养档案（自己和家人）
2. **营养档案与AI推荐**: AI根据营养档案生成推荐内容
3. **商家与店铺**: 一个商家可以拥有多个店铺
4. **店铺与商家菜品**: 每个店铺有自己的菜品清单
5. **菜品与商家菜品**: 基础菜品被各店铺引用并添加特定信息
6. **用户与健康数据**: 用户可以记录自己的健康数据
7. **用户与订阅**: 用户可以订阅不同的服务计划
8. **论坛帖子与评论**: 一个帖子可以有多个评论和回复
9. **用户与消息提醒**: 用户会收到各种类型的系统通知
10. **用户与OAuth账号**: 用户可以绑定多个第三方平台账号

## 数据流动图

```
┌─────────┐      ┌─────────────┐     ┌───────────────┐     ┌────────────┐
│         │      │             │     │               │     │            │
│  用户   │─────▶│ 营养档案    │────▶│   健康数据    │────▶│  AI推荐    │
│         │      │             │     │               │     │            │
└────┬────┘      └─────────────┘     └───────────────┘     └──────┬─────┘
     │                                                            │
     │                                                            ▼
┌────▼────┐      ┌─────────────┐     ┌───────────────┐     ┌────────────┐
│         │      │             │     │               │     │            │
│ OAuth   │      │   店铺      │────▶│  商家菜品     │◀────│   菜品     │
│ 账号    │      │             │     │               │     │            │
└────┬────┘      └─────────────┘     └───────┬───────┘     └────────────┘
     │                                       │
     │                                       ▼
┌────▼────┐      ┌─────────────┐     ┌───────────────┐     ┌────────────┐
│         │      │             │     │               │     │            │
│ 通知    │◀─────│  用户收藏   │◀────│   用户交互    │────▶│ 论坛/评论  │
│         │      │             │     │               │     │            │
└─────────┘      └─────────────┘     └───────────────┘     └────────────┘
```

## 模型冻结注意事项

1. 所有开发必须基于已冻结的模型结构进行
2. 任何修改必须经过正式的变更申请流程
3. 前后端API交互必须严格遵守API契约文档
4. 模型关联必须使用正确的引用字段和类型
5. 新增模型必须按照规范命名并注册到系统中

## 参考资料

- [DATABASE_FROZEN_MODELS.md](DATABASE_FROZEN_MODELS.md) - 冻结模型详细说明
- [MODEL_VERSION_CONTROL.md](MODEL_VERSION_CONTROL.md) - 模型版本控制记录
- [API_CONTRACT.md](API_CONTRACT.md) - API接口契约
- [EXTEND_MODELS_FROZEN_RECORD.md](EXTEND_MODELS_FROZEN_RECORD.md) - 扩展模型冻结记录 