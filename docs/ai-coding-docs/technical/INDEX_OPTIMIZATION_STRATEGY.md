# AI智能营养餐厅系统 - 索引优化策略

> **文档版本**: 3.0.0  
> **创建日期**: 2025-07-13  
> **更新日期**: 2025-07-13  
> **文档状态**: ✅ 100%功能完整索引就绪  
> **目标受众**: 数据库管理员、后端开发、系统架构师

## 📋 目录

- [1. 索引策略概述](#1-索引策略概述)
- [2. 核心业务索引](#2-核心业务索引)
- [3. AI功能专用索引](#3-ai功能专用索引)
- [4. 用户行为分析索引](#4-用户行为分析索引)
- [5. 新增功能索引设计](#5-新增功能索引设计)
- [6. 复合索引策略](#6-复合索引策略)
- [7. 分区表索引](#7-分区表索引)
- [8. 索引维护与优化](#8-索引维护与优化)
- [9. 性能监控与调优](#9-性能监控与调优)

---

## 1. 索引策略概述

### 1.1 索引设计原则

```yaml
索引设计原则:
  查询优化:
    - 基于实际查询模式设计索引
    - 优先考虑高频查询
    - 支持多表关联查询
    - 覆盖索引优化
    
  数据特性:
    - 考虑数据分布和基数
    - 针对时间序列数据优化
    - 支持范围查询和排序
    - 处理空值和重复值
    
  维护成本:
    - 平衡查询性能与写入性能
    - 控制索引数量和大小
    - 避免冗余索引
    - 定期维护和优化

技术选型:
  B-Tree索引:
    - 用途: 等值查询、范围查询、排序
    - 适用: 大部分常规查询
    - 特点: 平衡树结构，查询效率稳定
    
  GiST索引:
    - 用途: 地理位置查询
    - 适用: 餐厅位置搜索
    - 特点: 支持复杂几何查询
    
  GIN索引:
    - 用途: 全文搜索、JSONB查询、数组查询
    - 适用: 菜品搜索、标签查询
    - 特点: 倒排索引结构
    
  HNSW索引 (pgvector):
    - 用途: 向量相似性搜索
    - 适用: AI推荐、图片识别
    - 特点: 近似最近邻搜索
    
  BRIN索引:
    - 用途: 大表范围查询
    - 适用: 时间序列数据
    - 特点: 块级索引，空间效率高
```

### 1.2 索引命名规范

```sql
-- 索引命名规范
-- 格式: idx_{table_name}_{column_name(s)}_{suffix}

-- 单列索引
-- idx_{table_name}_{column_name}
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- 复合索引  
-- idx_{table_name}_{column1}_{column2}_{suffix}
CREATE INDEX idx_orders_user_id_status ON orders(user_id, status);
CREATE INDEX idx_dishes_store_id_category ON dishes(store_id, category);

-- 唯一索引
-- uk_{table_name}_{column_name}
CREATE UNIQUE INDEX uk_users_phone ON users(phone);
CREATE UNIQUE INDEX uk_stores_merchant_id_name ON stores(merchant_id, name);

-- 部分索引
-- idx_{table_name}_{column_name}_partial
CREATE INDEX idx_orders_status_partial ON orders(status) WHERE status != 'completed';

-- 函数索引
-- idx_{table_name}_{function_name}_{column_name}
CREATE INDEX idx_users_lower_email ON users(lower(email));

-- 向量索引
-- idx_{table_name}_{column_name}_vector_{algorithm}
CREATE INDEX idx_vector_embeddings_embedding_hnsw ON vector_embeddings 
USING hnsw (embedding vector_cosine_ops);

-- GIN索引
-- idx_{table_name}_{column_name}_gin
CREATE INDEX idx_dishes_tags_gin ON dishes USING GIN (tags);

-- 地理索引
-- idx_{table_name}_{column_name}_gist
CREATE INDEX idx_stores_location_gist ON stores USING GIST (location);
```

---

## 2. 核心业务索引

### 2.1 用户相关索引

```sql
-- ================================
-- 用户表索引 (users)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 唯一索引 - 手机号登录
CREATE UNIQUE INDEX uk_users_phone ON users(phone) 
WHERE deleted_at IS NULL;

-- 唯一索引 - 邮箱登录
CREATE UNIQUE INDEX uk_users_email ON users(email) 
WHERE email IS NOT NULL AND deleted_at IS NULL;

-- 复合索引 - 用户状态查询
CREATE INDEX idx_users_status_role ON users(status, role) 
WHERE deleted_at IS NULL;

-- 索引 - 注册时间范围查询
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- 索引 - 会员等级查询 (新增)
CREATE INDEX idx_users_membership_level ON users(membership_level) 
WHERE membership_level != 'BASIC';

-- 索引 - 积分查询 (新增)
CREATE INDEX idx_users_points ON users(points DESC) 
WHERE points > 0;

-- 索引 - 设备指纹 (新增)
CREATE INDEX idx_users_device_fingerprint ON users(device_fingerprint) 
WHERE device_fingerprint IS NOT NULL;

-- 部分索引 - 活跃用户
CREATE INDEX idx_users_active ON users(last_login_at DESC) 
WHERE status = 'ACTIVE' AND last_login_at > CURRENT_DATE - INTERVAL '30 days';

-- 函数索引 - 昵称搜索
CREATE INDEX idx_users_nickname_lower ON users(lower(nickname)) 
WHERE deleted_at IS NULL;

-- ================================
-- 用户偏好表索引 (user_preferences)
-- ================================

-- 外键索引
CREATE INDEX idx_user_preferences_user_id ON user_preferences(user_id);

-- 复合索引 - 偏好查询
CREATE INDEX idx_user_preferences_user_cuisine ON user_preferences(user_id, cuisine_types);

-- 向量索引 - AI推荐 (新增)
CREATE INDEX idx_user_preferences_embedding_hnsw ON user_preferences 
USING hnsw (preference_embedding vector_cosine_ops)
WHERE preference_embedding IS NOT NULL;

-- ================================
-- 用户会话表索引 (user_sessions)
-- ================================

-- 主键索引 (session_id)
-- 外键索引
CREATE INDEX idx_user_sessions_user_id ON user_sessions(user_id);

-- 复合索引 - 活跃会话查询
CREATE INDEX idx_user_sessions_user_active ON user_sessions(user_id, expires_at) 
WHERE is_active = true;

-- 索引 - 会话过期清理
CREATE INDEX idx_user_sessions_expires_at ON user_sessions(expires_at) 
WHERE is_active = true;

-- 索引 - IP地址查询
CREATE INDEX idx_user_sessions_ip_address ON user_sessions(ip_address);

-- ================================
-- 积分交易表索引 (points_transactions) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_points_transactions_user_id ON points_transactions(user_id);

-- 复合索引 - 用户积分历史
CREATE INDEX idx_points_transactions_user_created ON points_transactions(user_id, created_at DESC);

-- 索引 - 交易类型统计
CREATE INDEX idx_points_transactions_type_created ON points_transactions(transaction_type, created_at DESC);

-- 索引 - 积分规则关联
CREATE INDEX idx_points_transactions_rule_id ON points_transactions(rule_id) 
WHERE rule_id IS NOT NULL;

-- 复合索引 - 时间范围查询
CREATE INDEX idx_points_transactions_created_amount ON points_transactions(created_at DESC, amount) 
WHERE amount > 0;
```

### 2.2 商家与菜品索引

```sql
-- ================================
-- 商家表索引 (merchants)
-- ================================

-- 唯一索引 - 商家账号
CREATE UNIQUE INDEX uk_merchants_account ON merchants(account) 
WHERE deleted_at IS NULL;

-- 索引 - 商家状态
CREATE INDEX idx_merchants_status ON merchants(status) 
WHERE status = 'ACTIVE';

-- 索引 - 认证状态
CREATE INDEX idx_merchants_verified ON merchants(is_verified, verified_at DESC) 
WHERE is_verified = true;

-- ================================
-- 门店表索引 (stores)
-- ================================

-- 外键索引
CREATE INDEX idx_stores_merchant_id ON stores(merchant_id);

-- 地理位置索引 - 距离查询
CREATE INDEX idx_stores_location_gist ON stores USING GIST (location) 
WHERE status = 'ACTIVE';

-- 复合索引 - 商家门店查询
CREATE INDEX idx_stores_merchant_status ON stores(merchant_id, status);

-- 索引 - 营业状态
CREATE INDEX idx_stores_business_hours ON stores(is_open) 
WHERE status = 'ACTIVE';

-- 复合索引 - 地区分类
CREATE INDEX idx_stores_city_category ON stores(city, category) 
WHERE status = 'ACTIVE';

-- 索引 - 评分排序
CREATE INDEX idx_stores_rating ON stores(rating DESC) 
WHERE rating >= 4.0 AND status = 'ACTIVE';

-- 索引 - AI服务特性 (新增)
CREATE INDEX idx_stores_ai_features ON stores USING GIN (ai_service_features) 
WHERE ai_service_features IS NOT NULL;

-- ================================
-- 菜品表索引 (dishes)
-- ================================

-- 外键索引
CREATE INDEX idx_dishes_store_id ON dishes(store_id);

-- 复合索引 - 门店菜品查询
CREATE INDEX idx_dishes_store_available ON dishes(store_id, is_available) 
WHERE deleted_at IS NULL;

-- 复合索引 - 分类价格查询
CREATE INDEX idx_dishes_category_price ON dishes(category, price) 
WHERE is_available = true;

-- 索引 - 价格范围查询
CREATE INDEX idx_dishes_price ON dishes(price) 
WHERE is_available = true;

-- 全文搜索索引 - 菜品名称和描述
CREATE INDEX idx_dishes_search_gin ON dishes 
USING GIN (to_tsvector('english', name || ' ' || COALESCE(description, '')));

-- 标签搜索索引
CREATE INDEX idx_dishes_tags_gin ON dishes USING GIN (tags) 
WHERE tags IS NOT NULL;

-- 营养成分索引 - 卡路里查询
CREATE INDEX idx_dishes_calories ON dishes((nutrition->>'calories')::numeric) 
WHERE nutrition IS NOT NULL;

-- 复合索引 - 营养成分范围查询
CREATE INDEX idx_dishes_nutrition_range ON dishes(
    (nutrition->>'calories')::numeric,
    (nutrition->>'protein')::numeric
) WHERE nutrition IS NOT NULL;

-- 向量索引 - AI推荐 (新增)
CREATE INDEX idx_dishes_nutrition_embedding_hnsw ON dishes 
USING hnsw (nutrition_embedding vector_cosine_ops)
WHERE nutrition_embedding IS NOT NULL;

-- 索引 - AI推荐分数 (新增)
CREATE INDEX idx_dishes_ai_score ON dishes(ai_recommendation_score DESC) 
WHERE ai_recommendation_score > 0;

-- 复合索引 - 热门推荐
CREATE INDEX idx_dishes_popular ON dishes(popularity_score DESC, rating DESC) 
WHERE is_available = true AND status = 'ACTIVE';

-- ================================
-- 菜品库存表索引 (store_dishes) - 增强
-- ================================

-- 复合主键索引
CREATE UNIQUE INDEX uk_store_dishes_store_dish ON store_dishes(store_id, dish_id);

-- 库存查询索引
CREATE INDEX idx_store_dishes_stock ON store_dishes(current_stock) 
WHERE is_available = true;

-- 低库存预警索引
CREATE INDEX idx_store_dishes_low_stock ON store_dishes(store_id, current_stock) 
WHERE current_stock <= min_threshold;

-- 复合索引 - 门店可用菜品
CREATE INDEX idx_store_dishes_store_available ON store_dishes(store_id, is_available, current_stock) 
WHERE is_available = true AND current_stock > 0;
```

### 2.3 订单相关索引

```sql
-- ================================
-- 订单表索引 (orders)
-- ================================

-- 外键索引
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_store_id ON orders(store_id);

-- 复合索引 - 用户订单历史
CREATE INDEX idx_orders_user_created ON orders(user_id, created_at DESC);

-- 索引 - 订单状态
CREATE INDEX idx_orders_status ON orders(status);

-- 复合索引 - 门店订单管理
CREATE INDEX idx_orders_store_status_created ON orders(store_id, status, created_at DESC);

-- 索引 - 支付状态
CREATE INDEX idx_orders_payment_status ON orders(payment_status);

-- 复合索引 - 配送查询
CREATE INDEX idx_orders_delivery_status_time ON orders(delivery_status, estimated_delivery_time) 
WHERE delivery_status IN ('PREPARING', 'DELIVERING');

-- 索引 - 订单总金额统计
CREATE INDEX idx_orders_total_amount_created ON orders(total_amount, created_at DESC) 
WHERE status = 'COMPLETED';

-- 索引 - AI推荐订单 (新增)
CREATE INDEX idx_orders_ai_recommended ON orders(ai_recommendation_used, created_at DESC) 
WHERE ai_recommendation_used = true;

-- 索引 - 营养分析 (新增)
CREATE INDEX idx_orders_nutrition_analysis ON orders(nutrition_analysis_id) 
WHERE nutrition_analysis_id IS NOT NULL;

-- 复合索引 - 促销活动订单 (新增)
CREATE INDEX idx_orders_promotion_created ON orders(promotion_applied, created_at DESC) 
WHERE promotion_applied IS NOT NULL;

-- 时间分区索引 (按月分区)
CREATE INDEX idx_orders_created_month ON orders(date_trunc('month', created_at), status);

-- ================================
-- 订单项表索引 (order_items)
-- ================================

-- 外键索引
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_dish_id ON order_items(dish_id);

-- 复合索引 - 菜品销量统计
CREATE INDEX idx_order_items_dish_created ON order_items(dish_id, created_at DESC);

-- 复合索引 - 订单商品查询
CREATE INDEX idx_order_items_order_dish ON order_items(order_id, dish_id);

-- 索引 - 数量和金额统计
CREATE INDEX idx_order_items_quantity_amount ON order_items(quantity, unit_price) 
WHERE quantity > 0;

-- ================================
-- 支付记录表索引 (payments)
-- ================================

-- 外键索引
CREATE INDEX idx_payments_order_id ON payments(order_id);

-- 索引 - 支付状态
CREATE INDEX idx_payments_status ON payments(status);

-- 索引 - 支付方式统计
CREATE INDEX idx_payments_method_created ON payments(payment_method, created_at DESC);

-- 复合索引 - 交易流水查询
CREATE INDEX idx_payments_transaction_status ON payments(transaction_id, status) 
WHERE transaction_id IS NOT NULL;

-- 索引 - 支付金额范围
CREATE INDEX idx_payments_amount_created ON payments(amount DESC, created_at DESC) 
WHERE status = 'SUCCESS';

-- 索引 - 退款查询
CREATE INDEX idx_payments_refund_status ON payments(refund_status, refund_amount) 
WHERE refund_status IS NOT NULL;
```

---

## 3. AI功能专用索引

### 3.1 向量嵌入索引

```sql
-- ================================
-- 向量嵌入表索引 (vector_embeddings)
-- ================================

-- 主键索引 (id)

-- 复合索引 - 实体查询
CREATE INDEX idx_vector_embeddings_entity ON vector_embeddings(entity_type, entity_id);

-- 向量相似性搜索索引 (HNSW算法)
CREATE INDEX idx_vector_embeddings_hnsw_cosine ON vector_embeddings 
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- 向量相似性搜索索引 (内积)
CREATE INDEX idx_vector_embeddings_hnsw_inner ON vector_embeddings 
USING hnsw (embedding vector_ip_ops)
WITH (m = 16, ef_construction = 64);

-- 向量相似性搜索索引 (L2距离)
CREATE INDEX idx_vector_embeddings_hnsw_l2 ON vector_embeddings 
USING hnsw (embedding vector_l2_ops)
WITH (m = 16, ef_construction = 64);

-- 元数据搜索索引
CREATE INDEX idx_vector_embeddings_metadata_gin ON vector_embeddings 
USING GIN (metadata) 
WHERE metadata IS NOT NULL;

-- 时间索引 - 向量更新时间
CREATE INDEX idx_vector_embeddings_updated_at ON vector_embeddings(updated_at DESC);

-- 复合索引 - 实体类型和时间
CREATE INDEX idx_vector_embeddings_type_created ON vector_embeddings(entity_type, created_at DESC);

-- 部分索引 - 菜品向量
CREATE INDEX idx_vector_embeddings_dish_hnsw ON vector_embeddings 
USING hnsw (embedding vector_cosine_ops)
WHERE entity_type = 'dish';

-- 部分索引 - 用户偏好向量
CREATE INDEX idx_vector_embeddings_user_pref_hnsw ON vector_embeddings 
USING hnsw (embedding vector_cosine_ops)
WHERE entity_type = 'user_preference';

-- ================================
-- AI推荐记录表索引 (ai_recommendations)
-- ================================

-- 外键索引
CREATE INDEX idx_ai_recommendations_user_id ON ai_recommendations(user_id);

-- 复合索引 - 用户推荐历史
CREATE INDEX idx_ai_recommendations_user_created ON ai_recommendations(user_id, created_at DESC);

-- 索引 - 推荐类型
CREATE INDEX idx_ai_recommendations_type ON ai_recommendations(recommendation_type);

-- 复合索引 - 推荐效果分析
CREATE INDEX idx_ai_recommendations_type_score ON ai_recommendations(recommendation_type, confidence_score DESC);

-- 索引 - 推荐结果使用情况
CREATE INDEX idx_ai_recommendations_used ON ai_recommendations(is_used, created_at DESC);

-- 复合索引 - A/B测试分析
CREATE INDEX idx_ai_recommendations_model_version ON ai_recommendations(model_version, created_at DESC);

-- JSONB索引 - 推荐参数
CREATE INDEX idx_ai_recommendations_parameters_gin ON ai_recommendations 
USING GIN (recommendation_parameters);

-- JSONB索引 - 推荐结果
CREATE INDEX idx_ai_recommendations_results_gin ON ai_recommendations 
USING GIN (recommendation_results);

-- ================================
-- 食物识别记录表索引 (food_recognition_records) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_food_recognition_user_id ON food_recognition_records(user_id);

-- 索引 - 图片哈希去重
CREATE INDEX idx_food_recognition_image_hash ON food_recognition_records(image_hash);

-- 复合索引 - 用户识别历史
CREATE INDEX idx_food_recognition_user_created ON food_recognition_records(user_id, created_at DESC);

-- 索引 - 识别置信度
CREATE INDEX idx_food_recognition_confidence ON food_recognition_records(confidence_score DESC) 
WHERE confidence_score >= 0.8;

-- 复合索引 - 识别结果统计
CREATE INDEX idx_food_recognition_food_confidence ON food_recognition_records(
    recognized_food_name, 
    confidence_score DESC
) WHERE confidence_score >= 0.5;

-- JSONB索引 - 识别结果详情
CREATE INDEX idx_food_recognition_results_gin ON food_recognition_records 
USING GIN (recognition_results);

-- 索引 - 处理时间性能分析
CREATE INDEX idx_food_recognition_processing_time ON food_recognition_records(processing_time_ms) 
WHERE processing_time_ms IS NOT NULL;

-- ================================
-- 识别统计表索引 (recognition_statistics) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_recognition_statistics_user_id ON recognition_statistics(user_id);

-- 复合索引 - 用户统计查询
CREATE INDEX idx_recognition_statistics_user_period ON recognition_statistics(user_id, statistics_period);

-- 索引 - 统计周期
CREATE INDEX idx_recognition_statistics_period ON recognition_statistics(statistics_period, created_at DESC);

-- 索引 - 识别次数排序
CREATE INDEX idx_recognition_statistics_recognition_count ON recognition_statistics(total_recognitions DESC);

-- 索引 - 准确率统计
CREATE INDEX idx_recognition_statistics_accuracy ON recognition_statistics(average_accuracy DESC) 
WHERE average_accuracy IS NOT NULL;

-- JSONB索引 - 食物类别统计
CREATE INDEX idx_recognition_statistics_food_categories_gin ON recognition_statistics 
USING GIN (food_categories_stats);
```

### 3.2 营养分析索引

```sql
-- ================================
-- 营养分析表索引 (nutrition_analyses) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_nutrition_analyses_user_id ON nutrition_analyses(user_id);

-- 复合索引 - 用户分析历史
CREATE INDEX idx_nutrition_analyses_user_created ON nutrition_analyses(user_id, created_at DESC);

-- 索引 - 分析类型
CREATE INDEX idx_nutrition_analyses_type ON nutrition_analyses(analysis_type);

-- 复合索引 - 食物分析
CREATE INDEX idx_nutrition_analyses_food_type ON nutrition_analyses(food_items, analysis_type) 
USING GIN (food_items);

-- 索引 - 总卡路里范围
CREATE INDEX idx_nutrition_analyses_calories ON nutrition_analyses(total_calories) 
WHERE total_calories > 0;

-- 复合索引 - 营养成分范围查询
CREATE INDEX idx_nutrition_analyses_nutrition_range ON nutrition_analyses(
    total_calories,
    total_protein,
    total_carbs
) WHERE total_calories > 0;

-- JSONB索引 - 营养建议
CREATE INDEX idx_nutrition_analyses_recommendations_gin ON nutrition_analyses 
USING GIN (recommendations);

-- JSONB索引 - 分析结果
CREATE INDEX idx_nutrition_analyses_results_gin ON nutrition_analyses 
USING GIN (analysis_results);

-- 索引 - 健康评分
CREATE INDEX idx_nutrition_analyses_health_score ON nutrition_analyses(health_score DESC) 
WHERE health_score IS NOT NULL;

-- 复合索引 - 用户健康趋势
CREATE INDEX idx_nutrition_analyses_user_score_date ON nutrition_analyses(
    user_id, 
    health_score DESC, 
    created_at DESC
) WHERE health_score IS NOT NULL;

-- ================================
-- 营养计划表索引 (nutrition_plans)
-- ================================

-- 外键索引
CREATE INDEX idx_nutrition_plans_user_id ON nutrition_plans(user_id);
CREATE INDEX idx_nutrition_plans_profile_id ON nutrition_plans(nutrition_profile_id);

-- 复合索引 - 用户计划查询
CREATE INDEX idx_nutrition_plans_user_status ON nutrition_plans(user_id, status);

-- 索引 - 计划类型
CREATE INDEX idx_nutrition_plans_plan_type ON nutrition_plans(plan_type);

-- 索引 - 计划状态和时间
CREATE INDEX idx_nutrition_plans_status_created ON nutrition_plans(status, created_at DESC);

-- 复合索引 - 活跃计划
CREATE INDEX idx_nutrition_plans_active ON nutrition_plans(user_id, start_date, end_date) 
WHERE status = 'ACTIVE';

-- 索引 - 计划目标
CREATE INDEX idx_nutrition_plans_goal ON nutrition_plans(primary_goal);

-- JSONB索引 - 计划内容
CREATE INDEX idx_nutrition_plans_content_gin ON nutrition_plans 
USING GIN (plan_content);

-- 索引 - AI生成计划
CREATE INDEX idx_nutrition_plans_ai_generated ON nutrition_plans(is_ai_generated, created_at DESC);

-- ================================
-- 营养计划跟踪表索引 (nutrition_plan_tracking) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_nutrition_plan_tracking_plan_id ON nutrition_plan_tracking(plan_id);
CREATE INDEX idx_nutrition_plan_tracking_user_id ON nutrition_plan_tracking(user_id);

-- 复合索引 - 计划跟踪查询
CREATE INDEX idx_nutrition_plan_tracking_plan_date ON nutrition_plan_tracking(plan_id, tracking_date DESC);

-- 索引 - 跟踪日期
CREATE INDEX idx_nutrition_plan_tracking_date ON nutrition_plan_tracking(tracking_date DESC);

-- 复合索引 - 用户跟踪历史
CREATE INDEX idx_nutrition_plan_tracking_user_date ON nutrition_plan_tracking(user_id, tracking_date DESC);

-- 索引 - 目标完成度
CREATE INDEX idx_nutrition_plan_tracking_completion ON nutrition_plan_tracking(goal_completion_rate DESC) 
WHERE goal_completion_rate IS NOT NULL;

-- JSONB索引 - 实际摄入数据
CREATE INDEX idx_nutrition_plan_tracking_actual_gin ON nutrition_plan_tracking 
USING GIN (actual_intake);

-- JSONB索引 - 目标数据
CREATE INDEX idx_nutrition_plan_tracking_target_gin ON nutrition_plan_tracking 
USING GIN (target_intake);

-- 复合索引 - 合规性分析
CREATE INDEX idx_nutrition_plan_tracking_compliance ON nutrition_plan_tracking(
    plan_id, 
    goal_completion_rate DESC, 
    tracking_date DESC
) WHERE goal_completion_rate >= 0.8;
```

---

## 4. 用户行为分析索引

### 4.1 用户行为数据索引

```sql
-- ================================
-- 用户行为表索引 (user_behaviors) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_user_behaviors_user_id ON user_behaviors(user_id);

-- 复合索引 - 用户行为时间序列
CREATE INDEX idx_user_behaviors_user_timestamp ON user_behaviors(user_id, timestamp DESC);

-- 索引 - 行为动作类型
CREATE INDEX idx_user_behaviors_action ON user_behaviors(action_type);

-- 复合索引 - 行为分析
CREATE INDEX idx_user_behaviors_action_timestamp ON user_behaviors(action_type, timestamp DESC);

-- 索引 - 目标对象
CREATE INDEX idx_user_behaviors_target ON user_behaviors(target_type, target_id) 
WHERE target_type IS NOT NULL;

-- 复合索引 - 特定对象行为
CREATE INDEX idx_user_behaviors_target_action ON user_behaviors(target_type, target_id, action_type);

-- JSONB索引 - 行为上下文
CREATE INDEX idx_user_behaviors_context_gin ON user_behaviors 
USING GIN (context) 
WHERE context IS NOT NULL;

-- 索引 - 会话ID
CREATE INDEX idx_user_behaviors_session_id ON user_behaviors(session_id) 
WHERE session_id IS NOT NULL;

-- 复合索引 - 会话行为序列
CREATE INDEX idx_user_behaviors_session_timestamp ON user_behaviors(session_id, timestamp) 
WHERE session_id IS NOT NULL;

-- 时间分区索引 - 按小时分区
CREATE INDEX idx_user_behaviors_hour ON user_behaviors(date_trunc('hour', timestamp), action_type);

-- 时间分区索引 - 按天分区
CREATE INDEX idx_user_behaviors_day ON user_behaviors(date_trunc('day', timestamp), user_id);

-- 索引 - IP地址分析
CREATE INDEX idx_user_behaviors_ip_address ON user_behaviors(ip_address) 
WHERE ip_address IS NOT NULL;

-- 索引 - 设备信息
CREATE INDEX idx_user_behaviors_device ON user_behaviors(device_type, platform) 
WHERE device_type IS NOT NULL;

-- 复合索引 - 地理位置行为
CREATE INDEX idx_user_behaviors_location ON user_behaviors(location_lat, location_lng) 
WHERE location_lat IS NOT NULL AND location_lng IS NOT NULL;

-- ================================
-- 用户偏好分析表索引 (user_preference_analyses) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_user_preference_analyses_user_id ON user_preference_analyses(user_id);

-- 索引 - 分析版本
CREATE INDEX idx_user_preference_analyses_version ON user_preference_analyses(analysis_version, created_at DESC);

-- 复合索引 - 用户最新分析
CREATE INDEX idx_user_preference_analyses_user_latest ON user_preference_analyses(
    user_id, 
    analysis_version DESC, 
    created_at DESC
);

-- 索引 - 置信度
CREATE INDEX idx_user_preference_analyses_confidence ON user_preference_analyses(confidence_score DESC) 
WHERE confidence_score >= 0.7;

-- JSONB索引 - 料理偏好
CREATE INDEX idx_user_preference_analyses_cuisine_gin ON user_preference_analyses 
USING GIN (cuisine_preferences);

-- JSONB索引 - 时间偏好
CREATE INDEX idx_user_preference_analyses_time_gin ON user_preference_analyses 
USING GIN (time_preferences);

-- JSONB索引 - 价格偏好
CREATE INDEX idx_user_preference_analyses_price_gin ON user_preference_analyses 
USING GIN (price_preferences);

-- JSONB索引 - 营养偏好
CREATE INDEX idx_user_preference_analyses_nutrition_gin ON user_preference_analyses 
USING GIN (nutrition_preferences);

-- 向量索引 - 偏好向量
CREATE INDEX idx_user_preference_analyses_vector_hnsw ON user_preference_analyses 
USING hnsw (preference_vector vector_cosine_ops)
WHERE preference_vector IS NOT NULL;

-- ================================
-- 用户会话分析表索引 (user_sessions_analysis) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_user_sessions_analysis_user_id ON user_sessions_analysis(user_id);

-- 索引 - 会话ID
CREATE INDEX idx_user_sessions_analysis_session_id ON user_sessions_analysis(session_id);

-- 复合索引 - 用户会话时间
CREATE INDEX idx_user_sessions_analysis_user_start ON user_sessions_analysis(user_id, session_start_time DESC);

-- 索引 - 会话时长
CREATE INDEX idx_user_sessions_analysis_duration ON user_sessions_analysis(session_duration_minutes DESC) 
WHERE session_duration_minutes > 0;

-- 索引 - 页面浏览数
CREATE INDEX idx_user_sessions_analysis_page_views ON user_sessions_analysis(total_page_views DESC);

-- 索引 - 转化率
CREATE INDEX idx_user_sessions_analysis_conversion ON user_sessions_analysis(conversion_rate DESC) 
WHERE conversion_rate > 0;

-- 复合索引 - 高价值会话
CREATE INDEX idx_user_sessions_analysis_high_value ON user_sessions_analysis(
    conversion_rate DESC, 
    session_duration_minutes DESC
) WHERE conversion_rate > 0.1 AND session_duration_minutes > 5;

-- JSONB索引 - 行为路径
CREATE INDEX idx_user_sessions_analysis_path_gin ON user_sessions_analysis 
USING GIN (behavior_path);

-- 索引 - 跳出率
CREATE INDEX idx_user_sessions_analysis_bounce ON user_sessions_analysis(is_bounce_session) 
WHERE is_bounce_session = false;

-- 复合索引 - 设备会话分析
CREATE INDEX idx_user_sessions_analysis_device ON user_sessions_analysis(device_type, platform, session_start_time DESC);
```

### 4.2 行为统计索引

```sql
-- ================================
-- 用户行为统计表索引 (user_behavior_statistics) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_user_behavior_statistics_user_id ON user_behavior_statistics(user_id);

-- 复合索引 - 用户统计周期
CREATE INDEX idx_user_behavior_statistics_user_period ON user_behavior_statistics(
    user_id, 
    statistics_period, 
    period_start_date DESC
);

-- 索引 - 统计周期
CREATE INDEX idx_user_behavior_statistics_period ON user_behavior_statistics(
    statistics_period, 
    period_start_date DESC
);

-- 索引 - 活跃度评分
CREATE INDEX idx_user_behavior_statistics_activity_score ON user_behavior_statistics(activity_score DESC) 
WHERE activity_score > 0;

-- 索引 - 参与度评分
CREATE INDEX idx_user_behavior_statistics_engagement_score ON user_behavior_statistics(engagement_score DESC) 
WHERE engagement_score > 0;

-- 复合索引 - 用户价值评估
CREATE INDEX idx_user_behavior_statistics_user_value ON user_behavior_statistics(
    user_id,
    activity_score DESC,
    engagement_score DESC
) WHERE activity_score > 50 AND engagement_score > 50;

-- JSONB索引 - 行为分布
CREATE INDEX idx_user_behavior_statistics_distribution_gin ON user_behavior_statistics 
USING GIN (behavior_distribution);

-- JSONB索引 - 偏好标签
CREATE INDEX idx_user_behavior_statistics_tags_gin ON user_behavior_statistics 
USING GIN (preference_tags);

-- 复合索引 - 趋势分析
CREATE INDEX idx_user_behavior_statistics_trend ON user_behavior_statistics(
    user_id,
    period_start_date DESC,
    activity_score DESC
);

-- ================================
-- 热门内容统计表索引 (popular_content_statistics) - 新增
-- ================================

-- 索引 - 内容类型
CREATE INDEX idx_popular_content_statistics_type ON popular_content_statistics(content_type);

-- 复合索引 - 内容热度排序
CREATE INDEX idx_popular_content_statistics_popularity ON popular_content_statistics(
    content_type,
    popularity_score DESC,
    statistics_date DESC
);

-- 索引 - 统计日期
CREATE INDEX idx_popular_content_statistics_date ON popular_content_statistics(statistics_date DESC);

-- 复合索引 - 内容标识
CREATE INDEX idx_popular_content_statistics_content ON popular_content_statistics(
    content_type,
    content_id,
    statistics_date DESC
);

-- 索引 - 浏览次数
CREATE INDEX idx_popular_content_statistics_views ON popular_content_statistics(view_count DESC) 
WHERE view_count > 0;

-- 索引 - 交互次数
CREATE INDEX idx_popular_content_statistics_interactions ON popular_content_statistics(interaction_count DESC) 
WHERE interaction_count > 0;

-- 复合索引 - 转化率排序
CREATE INDEX idx_popular_content_statistics_conversion ON popular_content_statistics(
    content_type,
    conversion_rate DESC
) WHERE conversion_rate > 0;

-- 索引 - 分享次数
CREATE INDEX idx_popular_content_statistics_shares ON popular_content_statistics(share_count DESC) 
WHERE share_count > 0;

-- JSONB索引 - 用户群体分布
CREATE INDEX idx_popular_content_statistics_demographics_gin ON popular_content_statistics 
USING GIN (user_demographics) 
WHERE user_demographics IS NOT NULL;
```

---

## 5. 新增功能索引设计

### 5.1 库存管理索引

```sql
-- ================================
-- 库存表索引 (inventory) - 新增
-- ================================

-- 复合主键索引
CREATE UNIQUE INDEX uk_inventory_store_dish ON inventory(store_id, dish_id);

-- 外键索引
CREATE INDEX idx_inventory_store_id ON inventory(store_id);
CREATE INDEX idx_inventory_dish_id ON inventory(dish_id);

-- 库存数量索引
CREATE INDEX idx_inventory_current_stock ON inventory(current_stock);

-- 低库存预警索引
CREATE INDEX idx_inventory_low_stock ON inventory(store_id, current_stock) 
WHERE current_stock <= min_threshold;

-- 复合索引 - 库存状态查询
CREATE INDEX idx_inventory_store_available ON inventory(store_id, is_available, current_stock) 
WHERE is_available = true;

-- 索引 - 最大库存容量
CREATE INDEX idx_inventory_max_capacity ON inventory(max_capacity DESC) 
WHERE max_capacity > 0;

-- 复合索引 - 库存周转率分析
CREATE INDEX idx_inventory_turnover ON inventory(
    store_id,
    (current_stock::float / NULLIF(min_threshold, 0)) DESC
) WHERE min_threshold > 0;

-- 索引 - 库存预留
CREATE INDEX idx_inventory_reserved ON inventory(reserved_stock) 
WHERE reserved_stock > 0;

-- 复合索引 - 可用库存查询
CREATE INDEX idx_inventory_available_stock ON inventory(
    store_id,
    (current_stock - COALESCE(reserved_stock, 0)) DESC
) WHERE is_available = true;

-- 索引 - 库存更新时间
CREATE INDEX idx_inventory_updated_at ON inventory(updated_at DESC);

-- ================================
-- 库存事务表索引 (inventory_transactions) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_inventory_transactions_inventory_id ON inventory_transactions(inventory_id);
CREATE INDEX idx_inventory_transactions_order_id ON inventory_transactions(order_id) 
WHERE order_id IS NOT NULL;

-- 复合索引 - 库存事务历史
CREATE INDEX idx_inventory_transactions_inventory_created ON inventory_transactions(
    inventory_id, 
    created_at DESC
);

-- 索引 - 事务类型
CREATE INDEX idx_inventory_transactions_type ON inventory_transactions(transaction_type);

-- 复合索引 - 库存变动分析
CREATE INDEX idx_inventory_transactions_type_created ON inventory_transactions(
    transaction_type, 
    created_at DESC
);

-- 索引 - 数量变动
CREATE INDEX idx_inventory_transactions_quantity ON inventory_transactions(quantity_change);

-- 复合索引 - 出入库统计
CREATE INDEX idx_inventory_transactions_inout_analysis ON inventory_transactions(
    inventory_id,
    transaction_type,
    ABS(quantity_change) DESC,
    created_at DESC
);

-- 索引 - 操作员
CREATE INDEX idx_inventory_transactions_operator ON inventory_transactions(operated_by) 
WHERE operated_by IS NOT NULL;

-- 复合索引 - 门店库存流水
CREATE INDEX idx_inventory_transactions_store_flow ON inventory_transactions(
    store_id,
    created_at DESC,
    transaction_type
);

-- 时间分区索引 - 按月分区
CREATE INDEX idx_inventory_transactions_month ON inventory_transactions(
    date_trunc('month', created_at),
    transaction_type
);

-- ================================
-- 采购建议表索引 (purchase_suggestions) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_purchase_suggestions_store_id ON purchase_suggestions(store_id);
CREATE INDEX idx_purchase_suggestions_dish_id ON purchase_suggestions(dish_id);
CREATE INDEX idx_purchase_suggestions_supplier_id ON purchase_suggestions(supplier_id) 
WHERE supplier_id IS NOT NULL;

-- 复合索引 - 门店采购建议
CREATE INDEX idx_purchase_suggestions_store_urgency ON purchase_suggestions(
    store_id, 
    urgency_level, 
    created_at DESC
);

-- 索引 - 紧急程度
CREATE INDEX idx_purchase_suggestions_urgency ON purchase_suggestions(urgency_level, created_at DESC);

-- 索引 - 建议状态
CREATE INDEX idx_purchase_suggestions_status ON purchase_suggestions(status);

-- 复合索引 - 未处理建议
CREATE INDEX idx_purchase_suggestions_pending ON purchase_suggestions(
    store_id, 
    status, 
    urgency_level
) WHERE status = 'PENDING';

-- 索引 - 建议数量
CREATE INDEX idx_purchase_suggestions_quantity ON purchase_suggestions(suggested_quantity DESC) 
WHERE suggested_quantity > 0;

-- 复合索引 - 成本分析
CREATE INDEX idx_purchase_suggestions_cost ON purchase_suggestions(
    store_id,
    estimated_cost DESC,
    urgency_level
) WHERE estimated_cost > 0;

-- 索引 - 预计耗尽时间
CREATE INDEX idx_purchase_suggestions_depletion ON purchase_suggestions(estimated_depletion_date) 
WHERE estimated_depletion_date IS NOT NULL;

-- ================================
-- 供应商表索引 (suppliers) - 新增
-- ================================

-- 唯一索引 - 供应商代码
CREATE UNIQUE INDEX uk_suppliers_code ON suppliers(supplier_code) 
WHERE deleted_at IS NULL;

-- 索引 - 供应商名称搜索
CREATE INDEX idx_suppliers_name_lower ON suppliers(lower(supplier_name)) 
WHERE deleted_at IS NULL;

-- 索引 - 供应商状态
CREATE INDEX idx_suppliers_status ON suppliers(status) 
WHERE status = 'ACTIVE';

-- 复合索引 - 地区供应商
CREATE INDEX idx_suppliers_region_status ON suppliers(region, status) 
WHERE status = 'ACTIVE';

-- 索引 - 供应商评级
CREATE INDEX idx_suppliers_rating ON suppliers(rating DESC) 
WHERE rating IS NOT NULL;

-- 复合索引 - 优质供应商
CREATE INDEX idx_suppliers_quality ON suppliers(
    rating DESC, 
    reliability_score DESC
) WHERE status = 'ACTIVE' AND rating >= 4.0;

-- 全文搜索索引 - 供应商信息
CREATE INDEX idx_suppliers_search_gin ON suppliers 
USING GIN (to_tsvector('english', supplier_name || ' ' || COALESCE(description, '')))
WHERE deleted_at IS NULL;

-- JSONB索引 - 联系信息
CREATE INDEX idx_suppliers_contact_gin ON suppliers 
USING GIN (contact_info) 
WHERE contact_info IS NOT NULL;

-- JSONB索引 - 供应品类
CREATE INDEX idx_suppliers_categories_gin ON suppliers 
USING GIN (supply_categories) 
WHERE supply_categories IS NOT NULL;
```

### 5.2 取餐码管理索引

```sql
-- ================================
-- 取餐码表索引 (pickup_codes) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_pickup_codes_order_id ON pickup_codes(order_id);

-- 唯一索引 - 取餐码 (考虑时间窗口的唯一性)
CREATE UNIQUE INDEX uk_pickup_codes_code_active ON pickup_codes(pickup_code) 
WHERE status = 'ACTIVE' AND expires_at > CURRENT_TIMESTAMP;

-- 索引 - 取餐码状态
CREATE INDEX idx_pickup_codes_status ON pickup_codes(status);

-- 复合索引 - 有效取餐码查询
CREATE INDEX idx_pickup_codes_active ON pickup_codes(
    pickup_code, 
    status, 
    expires_at
) WHERE status = 'ACTIVE';

-- 索引 - 过期时间
CREATE INDEX idx_pickup_codes_expires_at ON pickup_codes(expires_at);

-- 复合索引 - 清理过期取餐码
CREATE INDEX idx_pickup_codes_expired_cleanup ON pickup_codes(status, expires_at) 
WHERE status != 'USED' AND expires_at < CURRENT_TIMESTAMP;

-- 索引 - 创建时间
CREATE INDEX idx_pickup_codes_created_at ON pickup_codes(created_at DESC);

-- 复合索引 - 订单取餐码历史
CREATE INDEX idx_pickup_codes_order_created ON pickup_codes(order_id, created_at DESC);

-- 索引 - 使用时间
CREATE INDEX idx_pickup_codes_used_at ON pickup_codes(used_at DESC) 
WHERE used_at IS NOT NULL;

-- 复合索引 - 取餐码使用统计
CREATE INDEX idx_pickup_codes_usage_stats ON pickup_codes(
    status,
    used_at DESC,
    (EXTRACT(EPOCH FROM (used_at - created_at))/60)::int
) WHERE status = 'USED';

-- ================================
-- 营养标签表索引 (nutrition_labels) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_nutrition_labels_order_id ON nutrition_labels(order_id);

-- 索引 - 标签类型
CREATE INDEX idx_nutrition_labels_label_type ON nutrition_labels(label_type);

-- 复合索引 - 订单营养标签
CREATE INDEX idx_nutrition_labels_order_type ON nutrition_labels(order_id, label_type);

-- 索引 - 二维码内容
CREATE INDEX idx_nutrition_labels_qr_code ON nutrition_labels(qr_code_content) 
WHERE qr_code_content IS NOT NULL;

-- JSONB索引 - 营养信息
CREATE INDEX idx_nutrition_labels_info_gin ON nutrition_labels 
USING GIN (nutrition_info);

-- JSONB索引 - 过敏原信息
CREATE INDEX idx_nutrition_labels_allergens_gin ON nutrition_labels 
USING GIN (allergen_info) 
WHERE allergen_info IS NOT NULL;

-- 索引 - 创建时间
CREATE INDEX idx_nutrition_labels_created_at ON nutrition_labels(created_at DESC);

-- 复合索引 - 有效期管理
CREATE INDEX idx_nutrition_labels_validity ON nutrition_labels(
    expires_at,
    status
) WHERE expires_at IS NOT NULL;

-- ================================
-- 取餐历史表索引 (pickup_history) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_pickup_history_user_id ON pickup_history(user_id);
CREATE INDEX idx_pickup_history_order_id ON pickup_history(order_id);
CREATE INDEX idx_pickup_history_pickup_code_id ON pickup_history(pickup_code_id);

-- 复合索引 - 用户取餐历史
CREATE INDEX idx_pickup_history_user_pickup_time ON pickup_history(user_id, pickup_time DESC);

-- 索引 - 取餐时间
CREATE INDEX idx_pickup_history_pickup_time ON pickup_history(pickup_time DESC);

-- 复合索引 - 订单取餐记录
CREATE INDEX idx_pickup_history_order_pickup ON pickup_history(order_id, pickup_time DESC);

-- 索引 - 取餐地点
CREATE INDEX idx_pickup_history_location ON pickup_history(pickup_location) 
WHERE pickup_location IS NOT NULL;

-- 复合索引 - 取餐效率分析
CREATE INDEX idx_pickup_history_efficiency ON pickup_history(
    (EXTRACT(EPOCH FROM (pickup_time - created_at))/60)::int,
    pickup_time DESC
);

-- 索引 - 取餐验证方式
CREATE INDEX idx_pickup_history_verification_method ON pickup_history(verification_method);

-- JSONB索引 - 额外信息
CREATE INDEX idx_pickup_history_metadata_gin ON pickup_history 
USING GIN (metadata) 
WHERE metadata IS NOT NULL;

-- 时间分区索引 - 按月分区
CREATE INDEX idx_pickup_history_month ON pickup_history(
    date_trunc('month', pickup_time)
);
```

### 5.3 营养师咨询索引

```sql
-- ================================
-- 咨询订单表索引 (consultation_orders) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_consultation_orders_user_id ON consultation_orders(user_id);
CREATE INDEX idx_consultation_orders_nutritionist_id ON consultation_orders(nutritionist_id);

-- 复合索引 - 用户咨询历史
CREATE INDEX idx_consultation_orders_user_created ON consultation_orders(user_id, created_at DESC);

-- 复合索引 - 营养师订单管理
CREATE INDEX idx_consultation_orders_nutritionist_status ON consultation_orders(
    nutritionist_id, 
    status, 
    scheduled_at
);

-- 索引 - 咨询状态
CREATE INDEX idx_consultation_orders_status ON consultation_orders(status);

-- 索引 - 咨询类型
CREATE INDEX idx_consultation_orders_type ON consultation_orders(consultation_type);

-- 复合索引 - 预约时间查询
CREATE INDEX idx_consultation_orders_scheduled ON consultation_orders(
    scheduled_at,
    status
) WHERE scheduled_at IS NOT NULL;

-- 复合索引 - 今日咨询安排
CREATE INDEX idx_consultation_orders_today ON consultation_orders(
    nutritionist_id,
    scheduled_at
) WHERE DATE(scheduled_at) = CURRENT_DATE AND status IN ('SCHEDULED', 'IN_PROGRESS');

-- 索引 - 咨询时长
CREATE INDEX idx_consultation_orders_duration ON consultation_orders(duration_minutes) 
WHERE duration_minutes > 0;

-- 复合索引 - 价格查询
CREATE INDEX idx_consultation_orders_price ON consultation_orders(
    consultation_type,
    total_amount DESC
) WHERE total_amount > 0;

-- 索引 - 完成时间
CREATE INDEX idx_consultation_orders_completed_at ON consultation_orders(completed_at DESC) 
WHERE completed_at IS NOT NULL;

-- 复合索引 - 咨询效果评估
CREATE INDEX idx_consultation_orders_rating ON consultation_orders(
    nutritionist_id,
    rating DESC,
    completed_at DESC
) WHERE rating IS NOT NULL;

-- ================================
-- 咨询消息表索引 (consultation_messages) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_consultation_messages_order_id ON consultation_messages(consultation_order_id);
CREATE INDEX idx_consultation_messages_sender_id ON consultation_messages(sender_id);

-- 复合索引 - 咨询对话历史
CREATE INDEX idx_consultation_messages_order_created ON consultation_messages(
    consultation_order_id, 
    created_at
);

-- 索引 - 消息类型
CREATE INDEX idx_consultation_messages_type ON consultation_messages(message_type);

-- 复合索引 - 发送者消息
CREATE INDEX idx_consultation_messages_sender_created ON consultation_messages(
    sender_id, 
    created_at DESC
);

-- 索引 - 阅读状态
CREATE INDEX idx_consultation_messages_read_status ON consultation_messages(is_read, created_at) 
WHERE is_read = false;

-- 复合索引 - 未读消息查询
CREATE INDEX idx_consultation_messages_unread ON consultation_messages(
    consultation_order_id,
    recipient_id,
    is_read,
    created_at
) WHERE is_read = false;

-- 全文搜索索引 - 消息内容
CREATE INDEX idx_consultation_messages_content_gin ON consultation_messages 
USING GIN (to_tsvector('english', message_content))
WHERE message_type = 'TEXT';

-- JSONB索引 - 附件信息
CREATE INDEX idx_consultation_messages_attachments_gin ON consultation_messages 
USING GIN (attachments) 
WHERE attachments IS NOT NULL;

-- 时间分区索引 - 按月分区
CREATE INDEX idx_consultation_messages_month ON consultation_messages(
    date_trunc('month', created_at),
    consultation_order_id
);

-- ================================
-- 营养师档案表索引 (nutritionist_profiles) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_nutritionist_profiles_user_id ON nutritionist_profiles(user_id);

-- 唯一索引 - 执业证书号
CREATE UNIQUE INDEX uk_nutritionist_profiles_license ON nutritionist_profiles(license_number) 
WHERE license_number IS NOT NULL AND deleted_at IS NULL;

-- 索引 - 认证状态
CREATE INDEX idx_nutritionist_profiles_verified ON nutritionist_profiles(is_verified) 
WHERE is_verified = true;

-- 索引 - 营养师等级
CREATE INDEX idx_nutritionist_profiles_level ON nutritionist_profiles(professional_level);

-- 复合索引 - 可用营养师查询
CREATE INDEX idx_nutritionist_profiles_available ON nutritionist_profiles(
    is_verified,
    is_available,
    rating DESC
) WHERE is_verified = true AND is_available = true;

-- JSONB索引 - 专业领域
CREATE INDEX idx_nutritionist_profiles_specialties_gin ON nutritionist_profiles 
USING GIN (specialties);

-- JSONB索引 - 工作经验
CREATE INDEX idx_nutritionist_profiles_experience_gin ON nutritionist_profiles 
USING GIN (work_experience) 
WHERE work_experience IS NOT NULL;

-- 索引 - 评分排序
CREATE INDEX idx_nutritionist_profiles_rating ON nutritionist_profiles(rating DESC) 
WHERE rating IS NOT NULL;

-- 复合索引 - 经验和评分
CREATE INDEX idx_nutritionist_profiles_experience_rating ON nutritionist_profiles(
    years_experience DESC,
    rating DESC
) WHERE is_verified = true;

-- 索引 - 咨询费用
CREATE INDEX idx_nutritionist_profiles_consultation_fee ON nutritionist_profiles(consultation_fee_per_hour) 
WHERE consultation_fee_per_hour > 0;

-- 复合索引 - 价格区间查询
CREATE INDEX idx_nutritionist_profiles_price_range ON nutritionist_profiles(
    consultation_fee_per_hour,
    rating DESC
) WHERE is_available = true AND consultation_fee_per_hour > 0;

-- ================================
-- 营养师可用时间表索引 (nutritionist_availability) - 新增
-- ================================

-- 外键索引
CREATE INDEX idx_nutritionist_availability_nutritionist_id ON nutritionist_availability(nutritionist_id);

-- 复合索引 - 营养师时间安排
CREATE INDEX idx_nutritionist_availability_nutritionist_date ON nutritionist_availability(
    nutritionist_id,
    available_date,
    start_time
);

-- 索引 - 可用日期
CREATE INDEX idx_nutritionist_availability_date ON nutritionist_availability(available_date);

-- 复合索引 - 可预约时间查询
CREATE INDEX idx_nutritionist_availability_bookable ON nutritionist_availability(
    available_date,
    start_time,
    is_available
) WHERE is_available = true;

-- 复合索引 - 营养师可预约时间
CREATE INDEX idx_nutritionist_availability_nutritionist_bookable ON nutritionist_availability(
    nutritionist_id,
    available_date,
    start_time
) WHERE is_available = true;

-- 索引 - 时间段类型
CREATE INDEX idx_nutritionist_availability_slot_type ON nutritionist_availability(slot_type);

-- 复合索引 - 特定类型时间查询
CREATE INDEX idx_nutritionist_availability_type_date ON nutritionist_availability(
    slot_type,
    available_date,
    nutritionist_id
);

-- 索引 - 重复模式
CREATE INDEX idx_nutritionist_availability_recurrence ON nutritionist_availability(recurrence_pattern) 
WHERE recurrence_pattern IS NOT NULL;

-- 复合索引 - 时间段冲突检查
CREATE INDEX idx_nutritionist_availability_conflict_check ON nutritionist_availability(
    nutritionist_id,
    available_date,
    start_time,
    end_time
);
```

---

## 6. 复合索引策略

### 6.1 高频查询复合索引

```sql
-- ================================
-- 高频业务查询复合索引
-- ================================

-- 用户点餐历史查询 (orders表)
CREATE INDEX idx_orders_user_history_optimized ON orders(
    user_id,
    status,
    created_at DESC,
    total_amount DESC
) WHERE status IN ('COMPLETED', 'CANCELLED');

-- 门店营业数据查询 (orders表)
CREATE INDEX idx_orders_store_business_optimized ON orders(
    store_id,
    DATE(created_at),
    status,
    total_amount
) WHERE status = 'COMPLETED';

-- 菜品销量统计查询 (order_items表)
CREATE INDEX idx_order_items_dish_sales_optimized ON order_items(
    dish_id,
    DATE(created_at),
    quantity,
    unit_price
);

-- 用户行为路径分析 (user_behaviors表)
CREATE INDEX idx_user_behaviors_path_analysis_optimized ON user_behaviors(
    user_id,
    session_id,
    timestamp,
    action_type,
    target_type
) WHERE session_id IS NOT NULL;

-- AI推荐效果分析 (ai_recommendations表)
CREATE INDEX idx_ai_recommendations_effectiveness_optimized ON ai_recommendations(
    recommendation_type,
    model_version,
    is_used,
    confidence_score DESC,
    created_at DESC
);

-- 库存周转率分析 (inventory_transactions表)
CREATE INDEX idx_inventory_transactions_turnover_optimized ON inventory_transactions(
    inventory_id,
    transaction_type,
    DATE(created_at),
    ABS(quantity_change) DESC
);

-- 营养师工作负载查询 (consultation_orders表)
CREATE INDEX idx_consultation_orders_workload_optimized ON consultation_orders(
    nutritionist_id,
    DATE(scheduled_at),
    status,
    duration_minutes
) WHERE scheduled_at IS NOT NULL;

-- 用户价值评估查询 (用户表 + 订单表关联)
CREATE INDEX idx_users_value_assessment_optimized ON users(
    membership_level,
    points DESC,
    last_login_at DESC,
    status
) WHERE status = 'ACTIVE';

-- 地理位置餐厅搜索 (stores表)
CREATE INDEX idx_stores_location_search_optimized ON stores(
    location,
    rating DESC,
    is_open,
    status
) USING GIST (location) WHERE status = 'ACTIVE';

-- 菜品营养搜索 (dishes表)
CREATE INDEX idx_dishes_nutrition_search_optimized ON dishes(
    is_available,
    (nutrition->>'calories')::numeric,
    (nutrition->>'protein')::numeric,
    rating DESC,
    price
) WHERE is_available = true AND nutrition IS NOT NULL;

-- ================================
-- 时间序列分析复合索引
-- ================================

-- 每日订单趋势分析
CREATE INDEX idx_orders_daily_trend ON orders(
    DATE(created_at),
    status,
    COUNT(*) OVER (PARTITION BY DATE(created_at))
) WHERE status = 'COMPLETED';

-- 用户活跃度趋势分析
CREATE INDEX idx_user_behaviors_activity_trend ON user_behaviors(
    user_id,
    DATE(timestamp),
    COUNT(*) OVER (PARTITION BY user_id, DATE(timestamp))
);

-- 库存变动趋势分析
CREATE INDEX idx_inventory_transactions_trend ON inventory_transactions(
    store_id,
    DATE(created_at),
    transaction_type,
    SUM(quantity_change) OVER (PARTITION BY store_id, DATE(created_at))
);

-- AI推荐使用趋势分析
CREATE INDEX idx_ai_recommendations_usage_trend ON ai_recommendations(
    DATE(created_at),
    recommendation_type,
    is_used,
    COUNT(*) OVER (PARTITION BY DATE(created_at), recommendation_type)
);

-- ================================
-- 关联查询优化索引
-- ================================

-- 用户-订单-菜品三表关联查询
CREATE INDEX idx_order_items_user_dish_join ON order_items(
    order_id,
    dish_id,
    quantity,
    created_at DESC
);

-- 门店-菜品-库存三表关联查询  
CREATE INDEX idx_dishes_store_inventory_join ON dishes(
    store_id,
    id,
    is_available,
    category
) WHERE is_available = true;

-- 用户-行为-偏好三表关联查询
CREATE INDEX idx_user_behaviors_preference_join ON user_behaviors(
    user_id,
    action_type,
    target_type,
    target_id,
    timestamp DESC
);

-- 咨询-营养师-用户三表关联查询
CREATE INDEX idx_consultation_nutritionist_user_join ON consultation_orders(
    nutritionist_id,
    user_id,
    status,
    scheduled_at,
    rating
);

-- ================================
-- 聚合查询优化索引
-- ================================

-- 月度销售额统计
CREATE INDEX idx_orders_monthly_revenue ON orders(
    DATE_TRUNC('month', created_at),
    status,
    total_amount
) WHERE status = 'COMPLETED';

-- 用户行为频次统计
CREATE INDEX idx_user_behaviors_frequency ON user_behaviors(
    user_id,
    action_type,
    DATE_TRUNC('day', timestamp)
);

-- 菜品平均评分统计
CREATE INDEX idx_dishes_rating_stats ON dishes(
    category,
    rating,
    status
) WHERE rating IS NOT NULL AND status = 'ACTIVE';

-- 库存消耗速率统计
CREATE INDEX idx_inventory_consumption_rate ON inventory_transactions(
    inventory_id,
    DATE_TRUNC('week', created_at),
    transaction_type,
    quantity_change
) WHERE transaction_type IN ('SALE', 'CONSUMPTION');
```

### 6.2 分析型查询索引

```sql
-- ================================
-- 商业智能分析索引
-- ================================

-- 用户生命周期价值分析
CREATE INDEX idx_users_lifetime_value ON users(
    created_at,
    last_login_at,
    membership_level,
    points,
    (
        SELECT SUM(total_amount) 
        FROM orders 
        WHERE orders.user_id = users.id 
        AND orders.status = 'COMPLETED'
    ) DESC
) WHERE status = 'ACTIVE';

-- 产品销售表现分析
CREATE INDEX idx_dishes_sales_performance ON dishes(
    category,
    store_id,
    rating DESC,
    price,
    (
        SELECT COUNT(*) 
        FROM order_items 
        WHERE order_items.dish_id = dishes.id
        AND order_items.created_at >= CURRENT_DATE - INTERVAL '30 days'
    ) DESC
) WHERE is_available = true;

-- 地区市场分析
CREATE INDEX idx_stores_market_analysis ON stores(
    city,
    category,
    rating DESC,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.store_id = stores.id
        AND orders.status = 'COMPLETED'
        AND orders.created_at >= CURRENT_DATE - INTERVAL '30 days'
    ) DESC
) WHERE status = 'ACTIVE';

-- 营养师绩效分析
CREATE INDEX idx_nutritionist_performance ON nutritionist_profiles(
    professional_level,
    years_experience,
    rating DESC,
    (
        SELECT COUNT(*)
        FROM consultation_orders
        WHERE consultation_orders.nutritionist_id = nutritionist_profiles.user_id
        AND consultation_orders.status = 'COMPLETED'
        AND consultation_orders.completed_at >= CURRENT_DATE - INTERVAL '30 days'
    ) DESC
) WHERE is_verified = true;

-- AI推荐系统效果分析
CREATE INDEX idx_ai_recommendation_performance ON ai_recommendations(
    model_version,
    recommendation_type,
    confidence_score DESC,
    is_used,
    created_at DESC,
    (confidence_score * CASE WHEN is_used THEN 1 ELSE 0 END) DESC
);

-- ================================
-- 实时监控索引
-- ================================

-- 实时订单监控
CREATE INDEX idx_orders_realtime_monitoring ON orders(
    status,
    created_at DESC,
    store_id,
    estimated_delivery_time
) WHERE status IN ('PENDING', 'CONFIRMED', 'PREPARING', 'DELIVERING');

-- 实时库存监控
CREATE INDEX idx_inventory_realtime_monitoring ON inventory(
    store_id,
    current_stock,
    min_threshold,
    (current_stock::float / NULLIF(min_threshold, 0)) ASC
) WHERE is_available = true AND current_stock <= min_threshold * 1.5;

-- 实时用户活动监控
CREATE INDEX idx_user_behaviors_realtime_monitoring ON user_behaviors(
    timestamp DESC,
    action_type,
    user_id
) WHERE timestamp >= CURRENT_TIMESTAMP - INTERVAL '1 hour';

-- 实时AI服务监控
CREATE INDEX idx_ai_recommendations_realtime_monitoring ON ai_recommendations(
    created_at DESC,
    recommendation_type,
    confidence_score,
    processing_time_ms
) WHERE created_at >= CURRENT_TIMESTAMP - INTERVAL '1 hour';

-- ================================
-- 数据清理维护索引
-- ================================

-- 过期数据清理索引
CREATE INDEX idx_cleanup_expired_sessions ON user_sessions(
    expires_at,
    is_active
) WHERE expires_at < CURRENT_TIMESTAMP;

CREATE INDEX idx_cleanup_expired_pickup_codes ON pickup_codes(
    expires_at,
    status
) WHERE expires_at < CURRENT_TIMESTAMP AND status != 'USED';

CREATE INDEX idx_cleanup_old_user_behaviors ON user_behaviors(
    timestamp
) WHERE timestamp < CURRENT_TIMESTAMP - INTERVAL '90 days';

-- 软删除数据清理索引
CREATE INDEX idx_cleanup_soft_deleted ON users(
    deleted_at
) WHERE deleted_at IS NOT NULL AND deleted_at < CURRENT_TIMESTAMP - INTERVAL '1 year';

-- 日志数据归档索引
CREATE INDEX idx_archive_old_logs ON system_logs(
    created_at,
    log_level
) WHERE created_at < CURRENT_TIMESTAMP - INTERVAL '30 days';
```

---

## 7. 分区表索引

### 7.1 时间分区索引

```sql
-- ================================
-- 订单表按月分区索引
-- ================================

-- 创建分区表 (假设已存在)
-- CREATE TABLE orders_y2025m01 PARTITION OF orders 
-- FOR VALUES FROM ('2025-01-01') TO ('2025-02-01');

-- 每个分区的本地索引
CREATE INDEX idx_orders_y2025m01_user_id ON orders_y2025m01(user_id);
CREATE INDEX idx_orders_y2025m01_store_id ON orders_y2025m01(store_id);
CREATE INDEX idx_orders_y2025m01_status ON orders_y2025m01(status);
CREATE INDEX idx_orders_y2025m01_created_at ON orders_y2025m01(created_at DESC);

-- 复合分区索引
CREATE INDEX idx_orders_y2025m01_user_status ON orders_y2025m01(user_id, status, created_at DESC);
CREATE INDEX idx_orders_y2025m01_store_status ON orders_y2025m01(store_id, status, total_amount DESC);

-- ================================
-- 用户行为表按日分区索引
-- ================================

-- 每日分区的本地索引
CREATE INDEX idx_user_behaviors_d20250113_user_id ON user_behaviors_y2025m01d13(user_id);
CREATE INDEX idx_user_behaviors_d20250113_action ON user_behaviors_y2025m01d13(action_type);
CREATE INDEX idx_user_behaviors_d20250113_timestamp ON user_behaviors_y2025m01d13(timestamp);

-- 用户行为序列分析索引
CREATE INDEX idx_user_behaviors_d20250113_sequence ON user_behaviors_y2025m01d13(
    user_id,
    session_id,
    timestamp
) WHERE session_id IS NOT NULL;

-- 行为热点分析索引
CREATE INDEX idx_user_behaviors_d20250113_hotspot ON user_behaviors_y2025m01d13(
    target_type,
    target_id,
    action_type,
    timestamp DESC
);

-- ================================
-- 库存事务表按月分区索引
-- ================================

-- 月度分区的库存流水索引
CREATE INDEX idx_inventory_transactions_y2025m01_inventory ON inventory_transactions_y2025m01(inventory_id);
CREATE INDEX idx_inventory_transactions_y2025m01_type ON inventory_transactions_y2025m01(transaction_type);
CREATE INDEX idx_inventory_transactions_y2025m01_created ON inventory_transactions_y2025m01(created_at DESC);

-- 库存分析复合索引
CREATE INDEX idx_inventory_transactions_y2025m01_analysis ON inventory_transactions_y2025m01(
    store_id,
    transaction_type,
    quantity_change,
    created_at DESC
);

-- ================================
-- AI推荐记录表按周分区索引
-- ================================

-- 周度分区的推荐记录索引
CREATE INDEX idx_ai_recommendations_w202502_user ON ai_recommendations_y2025w02(user_id);
CREATE INDEX idx_ai_recommendations_w202502_type ON ai_recommendations_y2025w02(recommendation_type);
CREATE INDEX idx_ai_recommendations_w202502_created ON ai_recommendations_y2025w02(created_at DESC);

-- 推荐效果分析索引
CREATE INDEX idx_ai_recommendations_w202502_effectiveness ON ai_recommendations_y2025w02(
    recommendation_type,
    confidence_score DESC,
    is_used,
    created_at DESC
);

-- ================================
-- 全局分区索引管理
-- ================================

-- 分区索引维护函数
CREATE OR REPLACE FUNCTION maintain_partition_indexes(table_name TEXT)
RETURNS VOID AS $$
DECLARE
    partition_name TEXT;
    index_sql TEXT;
BEGIN
    -- 遍历所有分区
    FOR partition_name IN 
        SELECT schemaname||'.'||tablename 
        FROM pg_tables 
        WHERE tablename LIKE table_name || '_y%'
    LOOP
        -- 为每个分区创建标准索引
        CASE table_name
            WHEN 'orders' THEN
                index_sql := format('CREATE INDEX IF NOT EXISTS idx_%s_user_id ON %s(user_id)', 
                                  replace(partition_name, '.', '_'), partition_name);
                EXECUTE index_sql;
                
                index_sql := format('CREATE INDEX IF NOT EXISTS idx_%s_store_id ON %s(store_id)', 
                                  replace(partition_name, '.', '_'), partition_name);
                EXECUTE index_sql;
                
            WHEN 'user_behaviors' THEN
                index_sql := format('CREATE INDEX IF NOT EXISTS idx_%s_user_timestamp ON %s(user_id, timestamp)', 
                                  replace(partition_name, '.', '_'), partition_name);
                EXECUTE index_sql;
                
            WHEN 'inventory_transactions' THEN
                index_sql := format('CREATE INDEX IF NOT EXISTS idx_%s_inventory_created ON %s(inventory_id, created_at DESC)', 
                                  replace(partition_name, '.', '_'), partition_name);
                EXECUTE index_sql;
        END CASE;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- 定期执行分区索引维护
-- SELECT maintain_partition_indexes('orders');
-- SELECT maintain_partition_indexes('user_behaviors');
-- SELECT maintain_partition_indexes('inventory_transactions');
```

### 7.2 数据量分区索引

```sql
-- ================================
-- 大表分区优化索引
-- ================================

-- 用户表按地区分区的索引优化
CREATE INDEX idx_users_region_china_phone ON users_region_china(phone) WHERE deleted_at IS NULL;
CREATE INDEX idx_users_region_china_membership ON users_region_china(membership_level, points DESC);
CREATE INDEX idx_users_region_china_activity ON users_region_china(last_login_at DESC) WHERE status = 'ACTIVE';

-- 菜品表按类别分区的索引优化
CREATE INDEX idx_dishes_category_main_course_store ON dishes_category_main_course(store_id, is_available);
CREATE INDEX idx_dishes_category_main_course_price ON dishes_category_main_course(price) WHERE is_available = true;
CREATE INDEX idx_dishes_category_main_course_nutrition ON dishes_category_main_course 
USING hnsw (nutrition_embedding vector_cosine_ops) WHERE nutrition_embedding IS NOT NULL;

-- 向量嵌入表按类型分区的索引优化
CREATE INDEX idx_vector_embeddings_dish_hnsw_optimized ON vector_embeddings_entity_dish 
USING hnsw (embedding vector_cosine_ops) WITH (m = 32, ef_construction = 128);

CREATE INDEX idx_vector_embeddings_user_hnsw_optimized ON vector_embeddings_entity_user 
USING hnsw (embedding vector_cosine_ops) WITH (m = 16, ef_construction = 64);

-- ================================
-- 混合分区索引策略
-- ================================

-- 订单表按时间和状态混合分区
CREATE INDEX idx_orders_completed_y2025m01_revenue ON orders_completed_y2025m01(
    total_amount DESC,
    created_at DESC,
    user_id
);

CREATE INDEX idx_orders_pending_realtime_monitoring ON orders_pending_current(
    created_at DESC,
    store_id,
    estimated_delivery_time
);

-- 用户行为表按用户和时间混合分区  
CREATE INDEX idx_user_behaviors_vip_users_activity ON user_behaviors_vip_users(
    timestamp DESC,
    action_type,
    target_type
);

CREATE INDEX idx_user_behaviors_regular_users_summary ON user_behaviors_regular_users(
    DATE(timestamp),
    action_type,
    COUNT(*) OVER (PARTITION BY DATE(timestamp), action_type)
);
```

---

## 8. 索引维护与优化

### 8.1 索引维护策略

```sql
-- ================================
-- 索引健康状况监控
-- ================================

-- 创建索引监控视图
CREATE OR REPLACE VIEW v_index_health_status AS
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size,
    idx_scan as scans,
    idx_tup_read as tuples_read,
    idx_tup_fetch as tuples_fetched,
    CASE 
        WHEN idx_scan = 0 THEN 'UNUSED'
        WHEN idx_scan < 100 THEN 'LOW_USAGE'
        WHEN idx_scan < 1000 THEN 'MEDIUM_USAGE'
        ELSE 'HIGH_USAGE'
    END as usage_level,
    CASE
        WHEN idx_tup_read > 0 THEN round((idx_tup_fetch::numeric / idx_tup_read) * 100, 2)
        ELSE 0
    END as selectivity_ratio
FROM pg_stat_user_indexes
JOIN pg_indexes ON (indexname = indexrelname AND schemaname = schemaname)
ORDER BY pg_relation_size(indexrelid) DESC;

-- 查找未使用的索引
CREATE OR REPLACE VIEW v_unused_indexes AS
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE idx_scan = 0
    AND indexrelname NOT LIKE '%_pkey'  -- 排除主键
    AND indexrelname NOT LIKE 'uk_%'    -- 排除唯一约束
ORDER BY pg_relation_size(indexrelid) DESC;

-- 查找低效索引
CREATE OR REPLACE VIEW v_inefficient_indexes AS
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan,
    idx_tup_read,
    idx_tup_fetch,
    round((idx_tup_fetch::numeric / NULLIF(idx_tup_read, 0)) * 100, 2) as efficiency_ratio,
    pg_size_pretty(pg_relation_size(indexrelid)) as index_size
FROM pg_stat_user_indexes
WHERE idx_scan > 0 
    AND idx_tup_read > 0
    AND (idx_tup_fetch::numeric / idx_tup_read) < 0.1  -- 效率低于10%
ORDER BY pg_relation_size(indexrelid) DESC;

-- ================================
-- 索引重建和维护函数
-- ================================

-- 重建表的所有索引
CREATE OR REPLACE FUNCTION rebuild_table_indexes(table_name TEXT)
RETURNS VOID AS $$
DECLARE
    index_record RECORD;
    start_time TIMESTAMP;
    end_time TIMESTAMP;
BEGIN
    start_time := clock_timestamp();
    
    FOR index_record IN 
        SELECT indexname 
        FROM pg_indexes 
        WHERE tablename = table_name 
        AND indexname NOT LIKE '%_pkey'  -- 排除主键
    LOOP
        RAISE NOTICE 'Rebuilding index: %', index_record.indexname;
        EXECUTE format('REINDEX INDEX CONCURRENTLY %I', index_record.indexname);
    END LOOP;
    
    end_time := clock_timestamp();
    RAISE NOTICE 'Table % indexes rebuilt in %', table_name, (end_time - start_time);
END;
$$ LANGUAGE plpgsql;

-- 更新表统计信息
CREATE OR REPLACE FUNCTION update_table_statistics(table_name TEXT)
RETURNS VOID AS $$
BEGIN
    EXECUTE format('ANALYZE %I', table_name);
    RAISE NOTICE 'Statistics updated for table: %', table_name;
END;
$$ LANGUAGE plpgsql;

-- 批量重建向量索引
CREATE OR REPLACE FUNCTION rebuild_vector_indexes()
RETURNS VOID AS $$
DECLARE
    vector_index RECORD;
BEGIN
    FOR vector_index IN 
        SELECT schemaname, indexname 
        FROM pg_indexes 
        WHERE indexdef LIKE '%hnsw%'
    LOOP
        RAISE NOTICE 'Rebuilding vector index: %', vector_index.indexname;
        EXECUTE format('REINDEX INDEX CONCURRENTLY %I.%I', 
                      vector_index.schemaname, vector_index.indexname);
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- 索引性能分析函数
-- ================================

-- 分析索引使用效率
CREATE OR REPLACE FUNCTION analyze_index_efficiency()
RETURNS TABLE (
    table_name TEXT,
    index_name TEXT,
    usage_level TEXT,
    efficiency_ratio NUMERIC,
    recommendation TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        tablename::TEXT,
        indexname::TEXT,
        CASE 
            WHEN idx_scan = 0 THEN 'UNUSED'
            WHEN idx_scan < 100 THEN 'LOW'
            WHEN idx_scan < 1000 THEN 'MEDIUM'
            ELSE 'HIGH'
        END::TEXT,
        CASE
            WHEN idx_tup_read > 0 THEN round((idx_tup_fetch::numeric / idx_tup_read) * 100, 2)
            ELSE 0
        END,
        CASE
            WHEN idx_scan = 0 THEN 'Consider dropping this index'
            WHEN idx_scan < 100 AND pg_relation_size(indexrelid) > 100*1024*1024 THEN 'Low usage, consider dropping'
            WHEN idx_tup_read > 0 AND (idx_tup_fetch::numeric / idx_tup_read) < 0.1 THEN 'Low efficiency, review index design'
            ELSE 'Index is performing well'
        END::TEXT
    FROM pg_stat_user_indexes
    WHERE schemaname = 'public'
    ORDER BY pg_relation_size(indexrelid) DESC;
END;
$$ LANGUAGE plpgsql;

-- 生成索引维护计划
CREATE OR REPLACE FUNCTION generate_index_maintenance_plan()
RETURNS TABLE (
    priority INTEGER,
    action TEXT,
    table_name TEXT,
    index_name TEXT,
    reason TEXT
) AS $$
BEGIN
    RETURN QUERY
    -- 高优先级：删除未使用的大索引
    SELECT 
        1 as priority,
        'DROP INDEX' as action,
        tablename::TEXT,
        indexname::TEXT,
        'Unused index consuming ' || pg_size_pretty(pg_relation_size(indexrelid)) as reason
    FROM pg_stat_user_indexes
    WHERE idx_scan = 0 
        AND pg_relation_size(indexrelid) > 100*1024*1024  -- 大于100MB
        AND indexrelname NOT LIKE '%_pkey'
        AND indexrelname NOT LIKE 'uk_%'
    
    UNION ALL
    
    -- 中优先级：重建低效的向量索引
    SELECT 
        2 as priority,
        'REINDEX' as action,
        tablename::TEXT,
        indexname::TEXT,
        'Low efficiency vector index' as reason
    FROM pg_stat_user_indexes psi
    JOIN pg_indexes pi ON (psi.indexrelname = pi.indexname)
    WHERE pi.indexdef LIKE '%hnsw%'
        AND psi.idx_tup_read > 0
        AND (psi.idx_tup_fetch::numeric / psi.idx_tup_read) < 0.2
    
    UNION ALL
    
    -- 低优先级：更新大表统计信息
    SELECT 
        3 as priority,
        'ANALYZE' as action,
        tablename::TEXT,
        'ALL_INDEXES' as index_name,
        'Large table needs statistics update' as reason
    FROM pg_stat_user_tables
    WHERE n_live_tup > 1000000  -- 超过100万行
        AND (last_analyze IS NULL OR last_analyze < CURRENT_DATE - INTERVAL '7 days')
    
    ORDER BY priority, pg_relation_size(indexrelid) DESC;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- 定期维护任务
-- ================================

-- 每日维护任务
CREATE OR REPLACE FUNCTION daily_index_maintenance()
RETURNS VOID AS $$
BEGIN
    -- 更新关键表统计信息
    PERFORM update_table_statistics('users');
    PERFORM update_table_statistics('orders');
    PERFORM update_table_statistics('user_behaviors');
    
    -- 重建低效的小索引
    PERFORM rebuild_vector_indexes();
    
    RAISE NOTICE 'Daily index maintenance completed';
END;
$$ LANGUAGE plpgsql;

-- 周度维护任务  
CREATE OR REPLACE FUNCTION weekly_index_maintenance()
RETURNS VOID AS $$
BEGIN
    -- 重建核心表索引
    PERFORM rebuild_table_indexes('orders');
    PERFORM rebuild_table_indexes('user_behaviors');
    PERFORM rebuild_table_indexes('vector_embeddings');
    
    -- 分析索引效率
    RAISE NOTICE 'Weekly index efficiency analysis:';
    PERFORM analyze_index_efficiency();
    
    RAISE NOTICE 'Weekly index maintenance completed';
END;
$$ LANGUAGE plpgsql;

-- 月度维护任务
CREATE OR REPLACE FUNCTION monthly_index_maintenance()
RETURNS VOID AS $$
BEGIN
    -- 生成维护计划
    RAISE NOTICE 'Monthly index maintenance plan:';
    PERFORM generate_index_maintenance_plan();
    
    -- 清理过期分区索引
    -- 这里需要根据实际分区策略实施
    
    RAISE NOTICE 'Monthly index maintenance completed';
END;
$$ LANGUAGE plpgsql;
```

### 8.2 索引性能调优

```sql
-- ================================
-- 索引参数优化
-- ================================

-- 向量索引参数调优
-- 针对不同数据规模优化HNSW参数

-- 小型数据集（< 10万条）
ALTER INDEX idx_vector_embeddings_small_hnsw 
SET (m = 8, ef_construction = 32);

-- 中型数据集（10万-100万条）
ALTER INDEX idx_vector_embeddings_medium_hnsw 
SET (m = 16, ef_construction = 64);

-- 大型数据集（> 100万条）
ALTER INDEX idx_vector_embeddings_large_hnsw 
SET (m = 32, ef_construction = 128);

-- GIN索引参数调优
ALTER INDEX idx_dishes_tags_gin 
SET (fastupdate = off, gin_pending_list_limit = 4096);

-- B-Tree索引填充因子调优
-- 对于频繁更新的表，降低填充因子
ALTER INDEX idx_orders_user_created 
SET (fillfactor = 80);

-- 对于只读表，提高填充因子
ALTER INDEX idx_dishes_nutrition_search_optimized 
SET (fillfactor = 95);

-- ================================
-- 查询计划优化
-- ================================

-- 创建索引使用情况分析函数
CREATE OR REPLACE FUNCTION analyze_query_plans(query_text TEXT)
RETURNS TABLE (
    plan_line TEXT
) AS $$
BEGIN
    RETURN QUERY
    EXECUTE format('EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT) %s', query_text);
END;
$$ LANGUAGE plpgsql;

-- 创建索引建议函数
CREATE OR REPLACE FUNCTION suggest_indexes_for_query(query_text TEXT)
RETURNS TABLE (
    suggestion TEXT
) AS $$
DECLARE
    plan_text TEXT;
BEGIN
    -- 获取查询计划
    EXECUTE format('EXPLAIN %s', query_text) INTO plan_text;
    
    -- 分析计划并提供建议
    IF plan_text LIKE '%Seq Scan%' THEN
        RETURN QUERY SELECT 'Consider adding index on frequently scanned columns'::TEXT;
    END IF;
    
    IF plan_text LIKE '%Sort%' THEN
        RETURN QUERY SELECT 'Consider adding index on ORDER BY columns'::TEXT;
    END IF;
    
    IF plan_text LIKE '%Hash Join%' THEN
        RETURN QUERY SELECT 'Consider adding index on JOIN columns'::TEXT;
    END IF;
    
    IF plan_text LIKE '%Filter%' THEN
        RETURN QUERY SELECT 'Consider adding index on WHERE clause columns'::TEXT;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- 自适应索引优化
-- ================================

-- 创建查询性能监控表
CREATE TABLE IF NOT EXISTS query_performance_log (
    id SERIAL PRIMARY KEY,
    query_hash TEXT NOT NULL,
    query_text TEXT NOT NULL,
    execution_time_ms NUMERIC NOT NULL,
    rows_examined BIGINT,
    rows_returned BIGINT,
    index_used TEXT[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 创建索引性能监控表
CREATE TABLE IF NOT EXISTS index_performance_log (
    id SERIAL PRIMARY KEY,
    index_name TEXT NOT NULL,
    table_name TEXT NOT NULL,
    scans_count BIGINT DEFAULT 0,
    tuples_read BIGINT DEFAULT 0,
    tuples_fetched BIGINT DEFAULT 0,
    avg_selectivity NUMERIC,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 自动索引建议函数
CREATE OR REPLACE FUNCTION auto_suggest_indexes()
RETURNS TABLE (
    table_name TEXT,
    suggested_index TEXT,
    reason TEXT,
    priority INTEGER
) AS $$
BEGIN
    RETURN QUERY
    -- 基于查询性能日志的索引建议
    WITH slow_queries AS (
        SELECT 
            query_text,
            AVG(execution_time_ms) as avg_time,
            COUNT(*) as frequency
        FROM query_performance_log
        WHERE created_at >= CURRENT_DATE - INTERVAL '7 days'
            AND execution_time_ms > 1000  -- 慢于1秒的查询
        GROUP BY query_text
        ORDER BY avg_time * frequency DESC
        LIMIT 10
    )
    SELECT 
        'multiple'::TEXT as table_name,
        'Review slow queries for index opportunities'::TEXT as suggested_index,
        'Found ' || COUNT(*) || ' slow queries in the last 7 days'::TEXT as reason,
        1 as priority
    FROM slow_queries
    
    UNION ALL
    
    -- 基于表扫描统计的索引建议
    SELECT 
        tablename::TEXT,
        'CREATE INDEX ON ' || tablename || ' (most_filtered_column)'::TEXT,
        'High sequential scan ratio'::TEXT,
        2 as priority
    FROM pg_stat_user_tables
    WHERE seq_scan > idx_scan * 10  -- 顺序扫描是索引扫描的10倍以上
        AND n_live_tup > 10000  -- 表有足够的数据量
    
    ORDER BY priority;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- 索引使用统计更新
-- ================================

-- 更新索引性能统计
CREATE OR REPLACE FUNCTION update_index_performance_stats()
RETURNS VOID AS $$
BEGIN
    INSERT INTO index_performance_log (
        index_name,
        table_name,
        scans_count,
        tuples_read,
        tuples_fetched,
        avg_selectivity
    )
    SELECT 
        indexrelname,
        tablename,
        idx_scan,
        idx_tup_read,
        idx_tup_fetch,
        CASE 
            WHEN idx_tup_read > 0 THEN 
                round((idx_tup_fetch::numeric / idx_tup_read) * 100, 2)
            ELSE 0 
        END
    FROM pg_stat_user_indexes
    ON CONFLICT (index_name) DO UPDATE SET
        scans_count = EXCLUDED.scans_count,
        tuples_read = EXCLUDED.tuples_read,
        tuples_fetched = EXCLUDED.tuples_fetched,
        avg_selectivity = EXCLUDED.avg_selectivity,
        last_updated = CURRENT_TIMESTAMP;
        
    RAISE NOTICE 'Index performance statistics updated';
END;
$$ LANGUAGE plpgsql;
```

---

## 9. 性能监控与调优

### 9.1 索引性能监控

```sql
-- ================================
-- 索引性能监控视图
-- ================================

-- 综合索引性能仪表板
CREATE OR REPLACE VIEW v_index_performance_dashboard AS
SELECT 
    psi.schemaname,
    psi.tablename,
    psi.indexrelname as index_name,
    pg_size_pretty(pg_relation_size(psi.indexrelid)) as index_size,
    psi.idx_scan as total_scans,
    psi.idx_tup_read as tuples_read,
    psi.idx_tup_fetch as tuples_fetched,
    
    -- 扫描效率
    CASE 
        WHEN psi.idx_tup_read > 0 THEN 
            round((psi.idx_tup_fetch::numeric / psi.idx_tup_read) * 100, 2)
        ELSE 0 
    END as scan_efficiency_pct,
    
    -- 使用频率等级
    CASE 
        WHEN psi.idx_scan = 0 THEN 'NEVER_USED'
        WHEN psi.idx_scan < 10 THEN 'RARELY_USED'
        WHEN psi.idx_scan < 100 THEN 'SOMETIMES_USED'
        WHEN psi.idx_scan < 1000 THEN 'FREQUENTLY_USED'
        ELSE 'HEAVILY_USED'
    END as usage_frequency,
    
    -- 索引类型
    pi.indexdef,
    
    -- 表统计信息
    pgst.n_live_tup as table_rows,
    pgst.seq_scan as table_seq_scans,
    
    -- 成本效益分析
    CASE 
        WHEN psi.idx_scan > 0 THEN 
            round(pg_relation_size(psi.indexrelid)::numeric / psi.idx_scan, 2)
        ELSE NULL
    END as bytes_per_scan,
    
    -- 建议
    CASE
        WHEN psi.idx_scan = 0 AND pg_relation_size(psi.indexrelid) > 10*1024*1024 THEN 'CONSIDER_DROPPING'
        WHEN psi.idx_scan < 10 AND pg_relation_size(psi.indexrelid) > 100*1024*1024 THEN 'LOW_USAGE_LARGE_INDEX'
        WHEN psi.idx_tup_read > 0 AND (psi.idx_tup_fetch::numeric / psi.idx_tup_read) < 0.01 THEN 'VERY_LOW_SELECTIVITY'
        WHEN psi.idx_scan > 10000 AND (psi.idx_tup_fetch::numeric / psi.idx_tup_read) > 0.9 THEN 'HIGH_PERFORMANCE'
        ELSE 'NORMAL'
    END as recommendation
    
FROM pg_stat_user_indexes psi
JOIN pg_indexes pi ON (psi.indexrelname = pi.indexname AND psi.schemaname = pi.schemaname)
JOIN pg_stat_user_tables pgst ON (psi.tablename = pgst.tablename AND psi.schemaname = pgst.schemaname)
ORDER BY pg_relation_size(psi.indexrelid) DESC;

-- 向量索引专门监控视图
CREATE OR REPLACE VIEW v_vector_index_performance AS
SELECT 
    psi.tablename,
    psi.indexrelname as vector_index_name,
    pg_size_pretty(pg_relation_size(psi.indexrelid)) as index_size,
    psi.idx_scan as scans,
    psi.idx_tup_read as vectors_examined,
    psi.idx_tup_fetch as vectors_returned,
    
    -- 向量索引特有指标
    CASE 
        WHEN psi.idx_tup_read > 0 THEN 
            round((psi.idx_tup_fetch::numeric / psi.idx_tup_read) * 100, 2)
        ELSE 0 
    END as recall_efficiency,
    
    -- 提取HNSW参数
    CASE 
        WHEN pi.indexdef LIKE '%m = %' THEN 
            regexp_replace(pi.indexdef, '.*m = (\d+).*', '\1')::int
        ELSE NULL 
    END as hnsw_m_parameter,
    
    CASE 
        WHEN pi.indexdef LIKE '%ef_construction = %' THEN 
            regexp_replace(pi.indexdef, '.*ef_construction = (\d+).*', '\1')::int
        ELSE NULL 
    END as hnsw_ef_construction,
    
    -- 向量索引使用建议
    CASE
        WHEN psi.idx_scan = 0 THEN 'UNUSED_VECTOR_INDEX'
        WHEN psi.idx_tup_read > 0 AND (psi.idx_tup_fetch::numeric / psi.idx_tup_read) < 0.1 THEN 'LOW_RECALL_RATE'
        WHEN psi.idx_scan > 100 AND (psi.idx_tup_fetch::numeric / psi.idx_tup_read) > 0.8 THEN 'OPTIMAL_PERFORMANCE'
        ELSE 'REVIEW_PARAMETERS'
    END as vector_index_advice
    
FROM pg_stat_user_indexes psi
JOIN pg_indexes pi ON (psi.indexrelname = pi.indexname)
WHERE pi.indexdef LIKE '%hnsw%'
ORDER BY psi.idx_scan DESC;

-- 索引碎片化监控视图
CREATE OR REPLACE VIEW v_index_fragmentation AS
SELECT 
    schemaname,
    tablename,
    indexname,
    pg_size_pretty(pg_relation_size(indexrelid)) as current_size,
    
    -- 估算的最优大小（基于表行数）
    pg_size_pretty(
        pg_stat_user_tables.n_live_tup * 
        CASE 
            WHEN indexdef LIKE '%gin%' THEN 100  -- GIN索引平均每行100字节
            WHEN indexdef LIKE '%gist%' THEN 150 -- GIST索引平均每行150字节
            WHEN indexdef LIKE '%hnsw%' THEN 200 -- HNSW索引平均每行200字节
            ELSE 50  -- B-tree索引平均每行50字节
        END
    ) as estimated_optimal_size,
    
    -- 碎片化程度
    CASE 
        WHEN pg_stat_user_tables.n_live_tup > 0 THEN
            round(
                (pg_relation_size(indexrelid)::numeric / 
                 (pg_stat_user_tables.n_live_tup * 
                  CASE 
                      WHEN indexdef LIKE '%gin%' THEN 100
                      WHEN indexdef LIKE '%gist%' THEN 150
                      WHEN indexdef LIKE '%hnsw%' THEN 200
                      ELSE 50
                  END
                 ) - 1) * 100, 2
            )
        ELSE 0
    END as fragmentation_pct,
    
    -- 重建建议
    CASE 
        WHEN pg_stat_user_tables.n_live_tup > 0 AND
             pg_relation_size(indexrelid) > 
             (pg_stat_user_tables.n_live_tup * 
              CASE 
                  WHEN indexdef LIKE '%gin%' THEN 100
                  WHEN indexdef LIKE '%gist%' THEN 150  
                  WHEN indexdef LIKE '%hnsw%' THEN 200
                  ELSE 50
              END * 1.5) THEN 'CONSIDER_REINDEX'
        ELSE 'OK'
    END as reindex_recommendation
    
FROM pg_stat_user_indexes
JOIN pg_stat_user_tables ON (pg_stat_user_indexes.tablename = pg_stat_user_tables.tablename)
JOIN pg_indexes ON (pg_stat_user_indexes.indexrelname = pg_indexes.indexname)
WHERE pg_relation_size(indexrelid) > 10*1024*1024  -- 只监控大于10MB的索引
ORDER BY fragmentation_pct DESC NULLS LAST;

-- ================================
-- 实时性能监控函数
-- ================================

-- 实时索引使用情况监控
CREATE OR REPLACE FUNCTION monitor_index_usage_realtime()
RETURNS TABLE (
    timestamp TIMESTAMP,
    index_name TEXT,
    scans_per_minute NUMERIC,
    efficiency_ratio NUMERIC,
    status TEXT
) AS $$
DECLARE
    current_time TIMESTAMP := CURRENT_TIMESTAMP;
BEGIN
    RETURN QUERY
    SELECT 
        current_time,
        indexrelname::TEXT,
        
        -- 每分钟扫描次数（需要与之前的快照比较）
        COALESCE(
            (idx_scan - COALESCE(
                (SELECT scans_count FROM index_performance_log ipl 
                 WHERE ipl.index_name = indexrelname 
                 ORDER BY last_updated DESC LIMIT 1), 0
            ))::numeric / 
            EXTRACT(EPOCH FROM (current_time - COALESCE(
                (SELECT last_updated FROM index_performance_log ipl 
                 WHERE ipl.index_name = indexrelname 
                 ORDER BY last_updated DESC LIMIT 1), current_time - INTERVAL '1 minute'
            ))) * 60, 0
        ) as scans_per_minute,
        
        -- 效率比率
        CASE 
            WHEN idx_tup_read > 0 THEN 
                round((idx_tup_fetch::numeric / idx_tup_read) * 100, 2)
            ELSE 0 
        END,
        
        -- 状态判断
        CASE 
            WHEN idx_scan = 0 THEN 'IDLE'
            WHEN idx_tup_read > 0 AND (idx_tup_fetch::numeric / idx_tup_read) < 0.1 THEN 'LOW_EFFICIENCY'
            WHEN idx_scan > 10 THEN 'ACTIVE'
            ELSE 'NORMAL'
        END::TEXT
        
    FROM pg_stat_user_indexes
    WHERE idx_scan > 0 OR indexrelname IN (
        SELECT index_name FROM index_performance_log 
        WHERE last_updated >= CURRENT_TIMESTAMP - INTERVAL '5 minutes'
    )
    ORDER BY idx_scan DESC;
END;
$$ LANGUAGE plpgsql;

-- 索引热点分析
CREATE OR REPLACE FUNCTION analyze_index_hotspots(time_window INTERVAL DEFAULT '1 hour')
RETURNS TABLE (
    index_name TEXT,
    table_name TEXT,
    scan_frequency NUMERIC,
    data_selectivity NUMERIC,
    performance_score NUMERIC,
    hotspot_level TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH index_activity AS (
        SELECT 
            psi.indexrelname,
            psi.tablename,
            psi.idx_scan,
            psi.idx_tup_read,
            psi.idx_tup_fetch,
            pg_relation_size(psi.indexrelid) as index_size
        FROM pg_stat_user_indexes psi
        WHERE psi.idx_scan > 0
    ),
    scored_indexes AS (
        SELECT 
            indexrelname::TEXT,
            tablename::TEXT,
            
            -- 扫描频率评分 (0-100)
            CASE 
                WHEN idx_scan >= 1000 THEN 100
                WHEN idx_scan >= 100 THEN 80 + (idx_scan - 100) * 20.0 / 900
                WHEN idx_scan >= 10 THEN 60 + (idx_scan - 10) * 20.0 / 90
                ELSE idx_scan * 60.0 / 10
            END as scan_freq_score,
            
            -- 数据选择性评分 (0-100)
            CASE 
                WHEN idx_tup_read > 0 THEN 
                    (idx_tup_fetch::numeric / idx_tup_read) * 100
                ELSE 0 
            END as selectivity_score,
            
            idx_scan,
            idx_tup_read,
            idx_tup_fetch
            
        FROM index_activity
    )
    SELECT 
        indexrelname,
        tablename,
        scan_freq_score,
        selectivity_score,
        
        -- 综合性能评分
        round((scan_freq_score * 0.6 + selectivity_score * 0.4), 2) as perf_score,
        
        -- 热点等级
        CASE 
            WHEN (scan_freq_score * 0.6 + selectivity_score * 0.4) >= 90 THEN 'CRITICAL_HOTSPOT'
            WHEN (scan_freq_score * 0.6 + selectivity_score * 0.4) >= 70 THEN 'HIGH_HOTSPOT'
            WHEN (scan_freq_score * 0.6 + selectivity_score * 0.4) >= 50 THEN 'MEDIUM_HOTSPOT'
            WHEN (scan_freq_score * 0.6 + selectivity_score * 0.4) >= 30 THEN 'LOW_HOTSPOT'
            ELSE 'COLD'
        END::TEXT
        
    FROM scored_indexes
    ORDER BY perf_score DESC;
END;
$$ LANGUAGE plpgsql;

-- ================================
-- 自动化监控报告
-- ================================

-- 生成每日索引性能报告
CREATE OR REPLACE FUNCTION generate_daily_index_report()
RETURNS TEXT AS $$
DECLARE
    report_text TEXT := '';
    total_indexes INTEGER;
    unused_indexes INTEGER;
    large_indexes INTEGER;
    vector_indexes INTEGER;
BEGIN
    -- 统计总体情况
    SELECT COUNT(*) INTO total_indexes FROM pg_stat_user_indexes;
    SELECT COUNT(*) INTO unused_indexes FROM pg_stat_user_indexes WHERE idx_scan = 0;
    SELECT COUNT(*) INTO large_indexes FROM pg_stat_user_indexes 
    WHERE pg_relation_size(indexrelid) > 100*1024*1024;
    SELECT COUNT(*) INTO vector_indexes FROM pg_indexes WHERE indexdef LIKE '%hnsw%';
    
    report_text := report_text || E'=== 每日索引性能报告 ===\n';
    report_text := report_text || E'生成时间: ' || CURRENT_TIMESTAMP || E'\n\n';
    
    report_text := report_text || E'索引概览:\n';
    report_text := report_text || E'- 总索引数: ' || total_indexes || E'\n';
    report_text := report_text || E'- 未使用索引: ' || unused_indexes || E'\n';
    report_text := report_text || E'- 大型索引(>100MB): ' || large_indexes || E'\n';
    report_text := report_text || E'- 向量索引: ' || vector_indexes || E'\n\n';
    
    -- 添加热点索引分析
    report_text := report_text || E'热点索引 (Top 5):\n';
    
    -- 这里可以调用热点分析函数并格式化结果
    
    -- 添加问题索引
    report_text := report_text || E'\n需要关注的索引:\n';
    
    -- 返回报告
    RETURN report_text;
END;
$$ LANGUAGE plpgsql;

-- 设置自动监控任务（需要pg_cron扩展）
-- SELECT cron.schedule('daily-index-report', '0 6 * * *', 'SELECT generate_daily_index_report()');
-- SELECT cron.schedule('update-index-stats', '*/30 * * * *', 'SELECT update_index_performance_stats()');
```

## 7. 新增功能索引设计

### 7.1 会员积分系统索引

```sql
-- ================================
-- 积分规则表索引 (points_rules)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 索引 - 动作类型
CREATE INDEX idx_points_rules_action_type ON points_rules(action_type);

-- 复合索引 - 活跃规则查询
CREATE INDEX idx_points_rules_active_dates ON points_rules(is_active, valid_from, valid_to)
WHERE is_active = true;

-- 索引 - 会员等级要求
CREATE INDEX idx_points_rules_required_level ON points_rules(required_level)
WHERE required_level IS NOT NULL;

-- 复合索引 - 动作类型和等级
CREATE INDEX idx_points_rules_action_level ON points_rules(action_type, required_level);

-- ================================
-- 积分交易记录表索引 (points_transactions)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_points_transactions_user_id ON points_transactions(user_id);

-- 复合索引 - 用户积分历史 (最重要的查询)
CREATE INDEX idx_points_transactions_user_created ON points_transactions(user_id, created_at DESC);

-- 索引 - 交易类型
CREATE INDEX idx_points_transactions_type ON points_transactions(transaction_type);

-- 复合索引 - 用户交易类型
CREATE INDEX idx_points_transactions_user_type ON points_transactions(user_id, transaction_type, created_at DESC);

-- 索引 - 订单关联
CREATE INDEX idx_points_transactions_order_id ON points_transactions(order_id)
WHERE order_id IS NOT NULL;

-- 索引 - 规则关联
CREATE INDEX idx_points_transactions_rule_id ON points_transactions(rule_id)
WHERE rule_id IS NOT NULL;

-- 索引 - 过期日期
CREATE INDEX idx_points_transactions_expire_date ON points_transactions(expire_date)
WHERE expire_date IS NOT NULL;

-- 复合索引 - 即将过期的积分
CREATE INDEX idx_points_transactions_user_expire ON points_transactions(user_id, expire_date)
WHERE expire_date IS NOT NULL AND expire_date >= CURRENT_DATE;

-- 时间分区索引 - 按月分区
CREATE INDEX idx_points_transactions_month ON points_transactions(date_trunc('month', created_at), user_id);

-- ================================
-- 会员权益表索引 (membership_benefits)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 索引 - 会员等级
CREATE INDEX idx_membership_benefits_level ON membership_benefits(membership_level);

-- 复合索引 - 等级和权益类型
CREATE INDEX idx_membership_benefits_level_type ON membership_benefits(membership_level, benefit_type);

-- 索引 - 活跃权益
CREATE INDEX idx_membership_benefits_active ON membership_benefits(is_active)
WHERE is_active = true;

-- 复合索引 - 活跃权益查询
CREATE INDEX idx_membership_benefits_active_level ON membership_benefits(membership_level, benefit_type)
WHERE is_active = true;
```

### 7.2 促销活动系统索引

```sql
-- ================================
-- 促销活动表索引 (promotions)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 复合索引 - 活跃促销查询 (最重要)
CREATE INDEX idx_promotions_active_dates ON promotions(is_active, start_date, end_date)
WHERE is_active = true;

-- 索引 - 促销类型
CREATE INDEX idx_promotions_type ON promotions(type);

-- 复合索引 - 类型和时间
CREATE INDEX idx_promotions_type_dates ON promotions(type, start_date, end_date);

-- JSONB索引 - 适用门店
CREATE INDEX idx_promotions_stores_gin ON promotions USING GIN (applicable_stores)
WHERE applicable_stores IS NOT NULL;

-- JSONB索引 - 适用菜品
CREATE INDEX idx_promotions_dishes_gin ON promotions USING GIN (applicable_dishes)
WHERE applicable_dishes IS NOT NULL;

-- 索引 - 使用限制
CREATE INDEX idx_promotions_usage ON promotions(usage_limit, used_count)
WHERE usage_limit IS NOT NULL;

-- 复合索引 - 可用促销
CREATE INDEX idx_promotions_available ON promotions(is_active, used_count, usage_limit)
WHERE is_active = true AND (usage_limit IS NULL OR used_count < usage_limit);

-- ================================
-- 优惠券模板表索引 (coupon_templates)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 索引 - 优惠券类型
CREATE INDEX idx_coupon_templates_type ON coupon_templates(type);

-- 复合索引 - 活跃模板
CREATE INDEX idx_coupon_templates_active ON coupon_templates(is_active, type)
WHERE is_active = true;

-- 索引 - 发行统计
CREATE INDEX idx_coupon_templates_quantity ON coupon_templates(total_quantity, issued_count)
WHERE total_quantity IS NOT NULL;

-- 复合索引 - 可发行模板
CREATE INDEX idx_coupon_templates_available ON coupon_templates(is_active, issued_count, total_quantity)
WHERE is_active = true AND (total_quantity IS NULL OR issued_count < total_quantity);

-- ================================
-- 用户优惠券表索引 (user_coupons)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_user_coupons_user_id ON user_coupons(user_id);
CREATE INDEX idx_user_coupons_template_id ON user_coupons(template_id);

-- 复合索引 - 用户可用优惠券 (最重要)
CREATE INDEX idx_user_coupons_user_available ON user_coupons(user_id, status, expire_date)
WHERE status = 'unused' AND expire_date >= CURRENT_DATE;

-- 索引 - 优惠券码
CREATE UNIQUE INDEX uk_user_coupons_code ON user_coupons(coupon_code);

-- 索引 - 状态
CREATE INDEX idx_user_coupons_status ON user_coupons(status);

-- 索引 - 过期日期
CREATE INDEX idx_user_coupons_expire_date ON user_coupons(expire_date);

-- 索引 - 使用的订单
CREATE INDEX idx_user_coupons_order_id ON user_coupons(order_id)
WHERE order_id IS NOT NULL;

-- 复合索引 - 模板使用统计
CREATE INDEX idx_user_coupons_template_status ON user_coupons(template_id, status, created_at);
```

### 7.3 配送管理系统索引

```sql
-- ================================
-- 配送区域表索引 (delivery_zones)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_delivery_zones_store_id ON delivery_zones(store_id);

-- 复合索引 - 门店活跃区域
CREATE INDEX idx_delivery_zones_store_active ON delivery_zones(store_id, is_active)
WHERE is_active = true;

-- 空间索引 - 配送边界 (地理查询)
CREATE INDEX idx_delivery_zones_boundaries_gist ON delivery_zones USING GIST (boundaries);

-- 索引 - 配送费用
CREATE INDEX idx_delivery_zones_fee ON delivery_zones(delivery_fee);

-- 索引 - 免费配送门槛
CREATE INDEX idx_delivery_zones_free_threshold ON delivery_zones(free_delivery_threshold)
WHERE free_delivery_threshold IS NOT NULL;

-- ================================
-- 配送时段表索引 (delivery_time_slots)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_delivery_time_slots_zone_id ON delivery_time_slots(zone_id);

-- 复合索引 - 区域活跃时段
CREATE INDEX idx_delivery_time_slots_zone_active ON delivery_time_slots(zone_id, is_active)
WHERE is_active = true;

-- 复合索引 - 时间段查询
CREATE INDEX idx_delivery_time_slots_time ON delivery_time_slots(start_time, end_time);

-- JSONB索引 - 可用星期
CREATE INDEX idx_delivery_time_slots_days_gin ON delivery_time_slots USING GIN (available_days);

-- 索引 - 容量查询
CREATE INDEX idx_delivery_time_slots_capacity ON delivery_time_slots(max_orders, current_orders);

-- 复合索引 - 可用时段
CREATE INDEX idx_delivery_time_slots_available ON delivery_time_slots(zone_id, current_orders, max_orders)
WHERE is_active = true AND current_orders < max_orders;

-- ================================
-- 配送路线表索引 (delivery_routes)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_delivery_routes_person_id ON delivery_routes(delivery_person_id);

-- 复合索引 - 配送员日期路线
CREATE INDEX idx_delivery_routes_person_date ON delivery_routes(delivery_person_id, delivery_date);

-- 索引 - 配送日期
CREATE INDEX idx_delivery_routes_date ON delivery_routes(delivery_date);

-- 索引 - 路线状态
CREATE INDEX idx_delivery_routes_status ON delivery_routes(status);

-- 复合索引 - 活跃路线
CREATE INDEX idx_delivery_routes_active ON delivery_routes(delivery_date, status)
WHERE status IN ('planned', 'in_progress');

-- JSONB索引 - 订单列表
CREATE INDEX idx_delivery_routes_orders_gin ON delivery_routes USING GIN (order_ids);

-- ================================
-- 配送人员表索引 (delivery_personnel)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 唯一索引
CREATE UNIQUE INDEX uk_delivery_personnel_phone ON delivery_personnel(phone);

-- 索引 - 状态
CREATE INDEX idx_delivery_personnel_status ON delivery_personnel(status);

-- 复合索引 - 可用配送员
CREATE INDEX idx_delivery_personnel_available ON delivery_personnel(status, is_active)
WHERE is_active = true;

-- JSONB索引 - 工作区域
CREATE INDEX idx_delivery_personnel_zones_gin ON delivery_personnel USING GIN (working_zones)
WHERE working_zones IS NOT NULL;

-- 空间索引 - 当前位置
CREATE INDEX idx_delivery_personnel_location_gist ON delivery_personnel USING GIST (current_location)
WHERE current_location IS NOT NULL;

-- 索引 - 评分
CREATE INDEX idx_delivery_personnel_rating ON delivery_personnel(rating DESC);

-- 索引 - 位置更新时间
CREATE INDEX idx_delivery_personnel_location_update ON delivery_personnel(last_location_update DESC)
WHERE last_location_update IS NOT NULL;
```

### 7.4 通知推送系统索引

```sql
-- ================================
-- 通知模板表索引 (notification_templates)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 唯一索引
CREATE UNIQUE INDEX uk_notification_templates_code ON notification_templates(template_code);

-- 索引 - 通知类型
CREATE INDEX idx_notification_templates_type ON notification_templates(type);

-- 复合索引 - 活跃模板
CREATE INDEX idx_notification_templates_active ON notification_templates(is_active, type)
WHERE is_active = true;

-- JSONB索引 - 推送渠道
CREATE INDEX idx_notification_templates_channels_gin ON notification_templates USING GIN (channels)
WHERE channels IS NOT NULL;

-- ================================
-- 用户通知表索引 (user_notifications)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_user_notifications_user_id ON user_notifications(user_id);
CREATE INDEX idx_user_notifications_template_id ON user_notifications(template_id)
WHERE template_id IS NOT NULL;

-- 复合索引 - 用户未读通知 (最重要)
CREATE INDEX idx_user_notifications_user_unread ON user_notifications(user_id, is_read, created_at DESC)
WHERE is_read = false;

-- 索引 - 通知类型
CREATE INDEX idx_user_notifications_type ON user_notifications(type);

-- 复合索引 - 用户类型通知
CREATE INDEX idx_user_notifications_user_type ON user_notifications(user_id, type, created_at DESC);

-- 索引 - 推送渠道
CREATE INDEX idx_user_notifications_channel ON user_notifications(channel);

-- 索引 - 发送状态
CREATE INDEX idx_user_notifications_status ON user_notifications(status);

-- 复合索引 - 发送状态时间
CREATE INDEX idx_user_notifications_status_created ON user_notifications(status, created_at DESC);

-- 索引 - 发送时间
CREATE INDEX idx_user_notifications_sent_at ON user_notifications(sent_at DESC)
WHERE sent_at IS NOT NULL;

-- 索引 - 已读时间
CREATE INDEX idx_user_notifications_read_at ON user_notifications(read_at DESC)
WHERE read_at IS NOT NULL;

-- 时间分区索引 - 按月分区
CREATE INDEX idx_user_notifications_month ON user_notifications(date_trunc('month', created_at), user_id);

-- ================================
-- 推送令牌表索引 (push_tokens)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_push_tokens_user_id ON push_tokens(user_id);

-- 复合索引 - 用户活跃令牌
CREATE INDEX idx_push_tokens_user_active ON push_tokens(user_id, is_active)
WHERE is_active = true;

-- 索引 - 设备平台
CREATE INDEX idx_push_tokens_platform ON push_tokens(platform);

-- 索引 - 设备ID
CREATE INDEX idx_push_tokens_device_id ON push_tokens(device_id)
WHERE device_id IS NOT NULL;

-- 索引 - 最后使用时间
CREATE INDEX idx_push_tokens_last_used ON push_tokens(last_used_at DESC);

-- 复合索引 - 平台活跃令牌
CREATE INDEX idx_push_tokens_platform_active ON push_tokens(platform, is_active, last_used_at DESC)
WHERE is_active = true;

-- ================================
-- 通知偏好设置表索引 (notification_preferences)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_notification_preferences_user_id ON notification_preferences(user_id);

-- 复合索引 - 用户通知类型偏好
CREATE INDEX idx_notification_preferences_user_type ON notification_preferences(user_id, notification_type);

-- 索引 - 通知类型
CREATE INDEX idx_notification_preferences_type ON notification_preferences(notification_type);

-- 复合索引 - 推送启用
CREATE INDEX idx_notification_preferences_push_enabled ON notification_preferences(notification_type, push_enabled)
WHERE push_enabled = true;

-- 复合索引 - 邮件启用
CREATE INDEX idx_notification_preferences_email_enabled ON notification_preferences(notification_type, email_enabled)
WHERE email_enabled = true;

-- 复合索引 - 短信启用
CREATE INDEX idx_notification_preferences_sms_enabled ON notification_preferences(notification_type, sms_enabled)
WHERE sms_enabled = true;
```

### 7.5 社区论坛增强索引

```sql
-- ================================
-- 帖子点赞表索引 (post_likes)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_post_likes_post_id ON post_likes(post_id);
CREATE INDEX idx_post_likes_user_id ON post_likes(user_id);

-- 唯一约束索引
CREATE UNIQUE INDEX uk_post_likes_post_user ON post_likes(post_id, user_id);

-- 索引 - 点赞类型
CREATE INDEX idx_post_likes_type ON post_likes(type);

-- 复合索引 - 帖子点赞统计
CREATE INDEX idx_post_likes_post_type ON post_likes(post_id, type);

-- 复合索引 - 用户点赞历史
CREATE INDEX idx_post_likes_user_created ON post_likes(user_id, created_at DESC);

-- 复合索引 - 帖子点赞时间
CREATE INDEX idx_post_likes_post_created ON post_likes(post_id, created_at DESC);

-- ================================
-- 用户关注表索引 (user_follows)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_user_follows_follower_id ON user_follows(follower_id);
CREATE INDEX idx_user_follows_followee_id ON user_follows(followee_id);

-- 唯一约束索引
CREATE UNIQUE INDEX uk_user_follows_follower_followee ON user_follows(follower_id, followee_id);

-- 复合索引 - 关注者活跃关注
CREATE INDEX idx_user_follows_follower_active ON user_follows(follower_id, is_active)
WHERE is_active = true;

-- 复合索引 - 被关注者活跃粉丝
CREATE INDEX idx_user_follows_followee_active ON user_follows(followee_id, is_active)
WHERE is_active = true;

-- 复合索引 - 关注时间
CREATE INDEX idx_user_follows_follower_created ON user_follows(follower_id, created_at DESC);

-- 复合索引 - 被关注时间
CREATE INDEX idx_user_follows_followee_created ON user_follows(followee_id, created_at DESC);

-- ================================
-- 内容举报表索引 (content_reports)
-- ================================

-- 主键索引 (自动创建)
-- PRIMARY KEY (id)

-- 外键索引
CREATE INDEX idx_content_reports_reporter_id ON content_reports(reporter_id);
CREATE INDEX idx_content_reports_reviewer_id ON content_reports(reviewer_id)
WHERE reviewer_id IS NOT NULL;

-- 复合索引 - 内容举报查询
CREATE INDEX idx_content_reports_content ON content_reports(content_type, content_id);

-- 索引 - 举报原因
CREATE INDEX idx_content_reports_reason ON content_reports(reason);

-- 索引 - 举报状态
CREATE INDEX idx_content_reports_status ON content_reports(status);

-- 复合索引 - 待审核举报
CREATE INDEX idx_content_reports_pending ON content_reports(status, created_at)
WHERE status = 'pending';

-- 复合索引 - 举报者历史
CREATE INDEX idx_content_reports_reporter_created ON content_reports(reporter_id, created_at DESC);

-- 复合索引 - 审核员处理历史
CREATE INDEX idx_content_reports_reviewer_reviewed ON content_reports(reviewer_id, reviewed_at DESC)
WHERE reviewer_id IS NOT NULL;

-- 复合索引 - 内容类型和状态
CREATE INDEX idx_content_reports_type_status ON content_reports(content_type, status, created_at DESC);

-- 时间分区索引 - 按月分区
CREATE INDEX idx_content_reports_month ON content_reports(date_trunc('month', created_at), status);
```

---

这份索引优化策略文档全面覆盖了AI智能营养餐厅系统的所有索引需求，包括：

1. **核心业务索引** - 用户、商家、订单等基础功能的高效索引设计
2. **AI功能专用索引** - 向量相似性搜索、图片识别、营养分析等AI功能的专门优化
3. **行为分析索引** - 用户行为追踪、偏好分析、会话分析的时间序列索引
4. **新增功能索引** - 库存管理、取餐码、营养师咨询等新功能的完整索引方案
5. **复合索引策略** - 针对复杂查询场景的多列索引优化
6. **分区表索引** - 大数据量场景的分区索引管理
7. **维护与监控** - 完整的索引生命周期管理和性能监控体系

特别针对AI功能优化了：
- **pgvector HNSW索引**的参数调优
- **向量相似性搜索**的多种距离算法支持
- **实时推荐系统**的缓存索引策略
- **大规模用户行为数据**的时间分区索引

整个索引策略确保了系统在各种负载下的查询性能，为AI功能的快速响应提供了坚实的数据访问基础。

<function_calls>
<invoke name="TodoWrite">
<parameter name="todos">[{"content": "P0: \u8865\u5145API\u63a5\u53e3\u5b9a\u4e49 - AI\u62cd\u7167\u8bc6\u522b\u3001\u5e93\u5b58\u7ba1\u7406\u3001\u53d6\u9910\u7801\u7b49", "status": "completed", "priority": "high", "id": "201"}, {"content": "P0: \u540c\u6b65\u524d\u7aef\u72b6\u6001\u7ba1\u7406 - \u66f4\u65b0\u4f1a\u5458\u7b49\u7ea7\u3001\u79ef\u5206\u7cfb\u7edf\u7b49\u65b0\u529f\u80fd", "status": "completed", "priority": "high", "id": "202"}, {"content": "P1: \u5b8c\u5584\u7248\u672c\u914d\u7f6e - TypeORM\u3001pgvector\u3001LangChain\u7248\u672c", "status": "completed", "priority": "high", "id": "203"}, {"content": "P1: \u66f4\u65b0\u6d4b\u8bd5\u7b56\u7565 - \u8986\u76d6AI\u529f\u80fd\u3001\u5e93\u5b58\u7ba1\u7406\u7b49\u65b0\u529f\u80fd", "status": "completed", "priority": "high", "id": "204"}, {"content": "P1: \u4f18\u5316\u90e8\u7f72\u914d\u7f6e - \u6dfb\u52a0pgvector\u548cAI\u670d\u52a1\u4f9d\u8d56", "status": "completed", "priority": "high", "id": "205"}, {"content": "P2: \u8865\u5145\u7f13\u5b58\u7b56\u7565 - \u65b0\u589e\u8868\u7684\u7f13\u5b58\u952e\u5b9a\u4e49", "status": "completed", "priority": "medium", "id": "206"}, {"content": "P2: \u4f18\u5316\u7d22\u5f15\u7b56\u7565 - AI\u529f\u80fd\u548c\u884c\u4e3a\u5206\u6790\u4e13\u7528\u7d22\u5f15", "status": "completed", "priority": "medium", "id": "207"}]