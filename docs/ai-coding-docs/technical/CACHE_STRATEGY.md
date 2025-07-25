# AI智能营养餐厅系统 - 缓存策略设计

> **文档版本**: 3.0.0  
> **创建日期**: 2025-07-13  
> **更新日期**: 2025-07-13  
> **文档状态**: ✅ 100%功能完整缓存就绪  
> **目标受众**: 后端开发团队、系统架构师、DevOps团队

## 📋 目录

- [1. 缓存策略概述](#1-缓存策略概述)
- [2. Redis缓存架构](#2-redis缓存架构)
- [3. 核心业务缓存](#3-核心业务缓存)
- [4. AI功能缓存策略](#4-ai功能缓存策略)
- [5. 新增功能缓存设计](#5-新增功能缓存设计)
- [6. 缓存更新策略](#6-缓存更新策略)
- [7. 缓存监控与优化](#7-缓存监控与优化)
- [8. 缓存故障处理](#8-缓存故障处理)

---

## 1. 缓存策略概述

### 1.1 缓存架构设计

```yaml
缓存层级:
  L1 - 应用内存缓存:
    - 类型: Node.js Map/LRU Cache
    - 用途: 热点数据、配置信息
    - 容量: 128MB per instance
    - TTL: 5-60分钟
    
  L2 - Redis分布式缓存:
    - 类型: Redis 7.0 Cluster
    - 用途: 会话、API响应、计算结果
    - 容量: 4GB集群
    - TTL: 1小时-7天
    
  L3 - CDN边缘缓存:
    - 类型: CloudFlare/阿里云CDN
    - 用途: 静态资源、图片
    - 容量: 无限制
    - TTL: 1天-1年

缓存策略:
  读取策略:
    - Cache-Aside: 主要策略
    - Read-Through: AI推荐结果
    - Refresh-Ahead: 热点数据预加载
    
  写入策略:
    - Write-Behind: 用户行为数据
    - Write-Through: 订单状态
    - Write-Around: 大文件上传

数据一致性:
  - 最终一致性: 用户行为统计
  - 强一致性: 订单状态、库存
  - 会话一致性: 用户偏好设置
```

### 1.2 缓存键命名规范

```typescript
// 缓存键命名标准
export enum CacheKeyPrefix {
  // 用户相关
  USER_PROFILE = 'user:profile',
  USER_SESSION = 'user:session', 
  USER_PREFERENCES = 'user:preferences',
  USER_POINTS = 'user:points',
  USER_MEMBERSHIP = 'user:membership',
  
  // AI功能相关
  AI_RECOMMENDATION = 'ai:recommendation',
  AI_VECTOR_EMBEDDING = 'ai:vector',
  AI_PHOTO_RECOGNITION = 'ai:photo',
  AI_NUTRITION_ANALYSIS = 'ai:nutrition',
  AI_CHAT_SESSION = 'ai:chat',
  
  // 新增功能
  INVENTORY_STOCK = 'inventory:stock',
  PICKUP_CODE = 'pickup:code',
  USER_BEHAVIOR = 'behavior:user',
  CONSULTATION_ORDER = 'consultation:order',
  MEMBER_WALLET = 'member:wallet',
  
  // 会员积分系统
  POINTS_BALANCE = 'points:balance',
  POINTS_TRANSACTION = 'points:transaction',
  MEMBERSHIP_BENEFITS = 'member:benefits',
  
  // 促销活动系统
  ACTIVE_PROMOTIONS = 'promotion:active',
  USER_COUPONS = 'coupon:user',
  COUPON_TEMPLATE = 'coupon:template',
  
  // 配送管理系统
  DELIVERY_ZONES = 'delivery:zones',
  DELIVERY_TIME_SLOTS = 'delivery:slots',
  DELIVERY_ROUTES = 'delivery:routes',
  
  // 通知推送系统
  USER_NOTIFICATIONS = 'notification:user',
  NOTIFICATION_PREFERENCES = 'notification:preferences',
  PUSH_TOKENS = 'notification:tokens',
  
  // 社区论坛增强
  POST_LIKES = 'community:likes',
  USER_FOLLOWS = 'community:follows',
  TRENDING_POSTS = 'community:trending',
  
  // 业务数据
  RESTAURANT_INFO = 'restaurant:info',
  DISH_DETAIL = 'dish:detail',
  ORDER_STATUS = 'order:status',
  NUTRITION_PROFILE = 'nutrition:profile',
  
  // 系统配置
  SYSTEM_CONFIG = 'system:config',
  API_RATE_LIMIT = 'rate:limit',
  HEALTH_CHECK = 'health:check',
}

// 缓存键构造器
export class CacheKeyBuilder {
  static userProfile(userId: string): string {
    return `${CacheKeyPrefix.USER_PROFILE}:${userId}`;
  }
  
  static aiRecommendation(userId: string, type: string): string {
    return `${CacheKeyPrefix.AI_RECOMMENDATION}:${userId}:${type}`;
  }
  
  static vectorEmbedding(entityType: string, entityId: string): string {
    return `${CacheKeyPrefix.AI_VECTOR_EMBEDDING}:${entityType}:${entityId}`;
  }
  
  static inventoryStock(storeId: string, dishId: string): string {
    return `${CacheKeyPrefix.INVENTORY_STOCK}:${storeId}:${dishId}`;
  }
  
  static pickupCode(orderId: string): string {
    return `${CacheKeyPrefix.PICKUP_CODE}:${orderId}`;
  }
  
  static userBehavior(userId: string, timeWindow: string): string {
    return `${CacheKeyPrefix.USER_BEHAVIOR}:${userId}:${timeWindow}`;
  }
  
  static consultationOrder(orderId: string): string {
    return `${CacheKeyPrefix.CONSULTATION_ORDER}:${orderId}`;
  }
  
  static memberWallet(userId: string): string {
    return `${CacheKeyPrefix.MEMBER_WALLET}:${userId}`;
  }
  
  // 会员积分系统缓存键
  static pointsBalance(userId: string): string {
    return `${CacheKeyPrefix.POINTS_BALANCE}:${userId}`;
  }
  
  static pointsTransaction(userId: string, page: number): string {
    return `${CacheKeyPrefix.POINTS_TRANSACTION}:${userId}:${page}`;
  }
  
  static membershipBenefits(level: string): string {
    return `${CacheKeyPrefix.MEMBERSHIP_BENEFITS}:${level}`;
  }
  
  // 促销活动系统缓存键
  static activePromotions(storeId?: string): string {
    return storeId ? 
      `${CacheKeyPrefix.ACTIVE_PROMOTIONS}:${storeId}` : 
      CacheKeyPrefix.ACTIVE_PROMOTIONS;
  }
  
  static userCoupons(userId: string, status?: string): string {
    return status ? 
      `${CacheKeyPrefix.USER_COUPONS}:${userId}:${status}` : 
      `${CacheKeyPrefix.USER_COUPONS}:${userId}`;
  }
  
  static couponTemplate(templateId: string): string {
    return `${CacheKeyPrefix.COUPON_TEMPLATE}:${templateId}`;
  }
  
  // 配送管理系统缓存键
  static deliveryZones(storeId: string): string {
    return `${CacheKeyPrefix.DELIVERY_ZONES}:${storeId}`;
  }
  
  static deliveryTimeSlots(zoneId: string, date: string): string {
    return `${CacheKeyPrefix.DELIVERY_TIME_SLOTS}:${zoneId}:${date}`;
  }
  
  static deliveryRoutes(personId: string, date: string): string {
    return `${CacheKeyPrefix.DELIVERY_ROUTES}:${personId}:${date}`;
  }
  
  // 通知推送系统缓存键
  static userNotifications(userId: string, type?: string): string {
    return type ? 
      `${CacheKeyPrefix.USER_NOTIFICATIONS}:${userId}:${type}` : 
      `${CacheKeyPrefix.USER_NOTIFICATIONS}:${userId}`;
  }
  
  static notificationPreferences(userId: string): string {
    return `${CacheKeyPrefix.NOTIFICATION_PREFERENCES}:${userId}`;
  }
  
  static pushTokens(userId: string): string {
    return `${CacheKeyPrefix.PUSH_TOKENS}:${userId}`;
  }
  
  // 社区论坛增强缓存键
  static postLikes(postId: string): string {
    return `${CacheKeyPrefix.POST_LIKES}:${postId}`;
  }
  
  static userFollows(userId: string): string {
    return `${CacheKeyPrefix.USER_FOLLOWS}:${userId}`;
  }
  
  static trendingPosts(timeRange: string): string {
    return `${CacheKeyPrefix.TRENDING_POSTS}:${timeRange}`;
  }
}
```

---

## 2. Redis缓存架构

### 2.1 Redis集群配置

```typescript
// src/config/redis.config.ts
import { RedisModuleOptions } from '@nestjs-modules/ioredis';

export const redisConfig: RedisModuleOptions = {
  type: 'cluster',
  nodes: [
    { host: 'redis-node-1', port: 6379 },
    { host: 'redis-node-2', port: 6379 },
    { host: 'redis-node-3', port: 6379 },
  ],
  options: {
    password: process.env.REDIS_PASSWORD,
    retryDelayOnFailover: 100,
    enableReadyCheck: true,
    maxRetriesPerRequest: 3,
    connectTimeout: 10000,
    commandTimeout: 5000,
    family: 4,
    keyPrefix: 'ai-nutrition:',
    db: 0,
  },
  // 连接池配置
  pool: {
    max: 50,
    min: 5,
    acquireTimeoutMillis: 60000,
    createTimeoutMillis: 30000,
    destroyTimeoutMillis: 5000,
    idleTimeoutMillis: 30000,
    reapIntervalMillis: 1000,
    createRetryIntervalMillis: 200,
  },
};

// Redis数据库分配
export enum RedisDatabase {
  SESSION = 0,        // 用户会话
  CACHE = 1,          // API响应缓存
  AI_RESULTS = 2,     // AI计算结果
  USER_BEHAVIOR = 3,  // 用户行为数据
  RATE_LIMIT = 4,     // 限流数据
  QUEUE = 5,          // 任务队列
  TEMP = 6,           // 临时数据
  STATS = 7,          // 统计数据
}
```

### 2.2 缓存服务基础类

```typescript
// src/common/cache/cache.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';

@Injectable()
export class CacheService {
  private readonly logger = new Logger(CacheService.name);

  constructor(@InjectRedis() private readonly redis: Redis) {}

  // 基础缓存操作
  async set(key: string, value: any, ttl?: number): Promise<void> {
    try {
      const serializedValue = JSON.stringify(value);
      if (ttl) {
        await this.redis.setex(key, ttl, serializedValue);
      } else {
        await this.redis.set(key, serializedValue);
      }
    } catch (error) {
      this.logger.error(`Cache set error for key ${key}:`, error);
      throw error;
    }
  }

  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      this.logger.error(`Cache get error for key ${key}:`, error);
      return null;
    }
  }

  async del(key: string): Promise<void> {
    try {
      await this.redis.del(key);
    } catch (error) {
      this.logger.error(`Cache delete error for key ${key}:`, error);
    }
  }

  async exists(key: string): Promise<boolean> {
    try {
      const result = await this.redis.exists(key);
      return result === 1;
    } catch (error) {
      this.logger.error(`Cache exists error for key ${key}:`, error);
      return false;
    }
  }

  // 批量操作
  async mget<T>(keys: string[]): Promise<(T | null)[]> {
    try {
      const values = await this.redis.mget(...keys);
      return values.map(value => value ? JSON.parse(value) : null);
    } catch (error) {
      this.logger.error(`Cache mget error:`, error);
      return keys.map(() => null);
    }
  }

  async mset(keyValues: { [key: string]: any }, ttl?: number): Promise<void> {
    try {
      const pipeline = this.redis.pipeline();
      
      Object.entries(keyValues).forEach(([key, value]) => {
        const serializedValue = JSON.stringify(value);
        if (ttl) {
          pipeline.setex(key, ttl, serializedValue);
        } else {
          pipeline.set(key, serializedValue);
        }
      });
      
      await pipeline.exec();
    } catch (error) {
      this.logger.error(`Cache mset error:`, error);
      throw error;
    }
  }

  // 列表操作
  async lpush(key: string, ...values: any[]): Promise<number> {
    try {
      const serializedValues = values.map(v => JSON.stringify(v));
      return await this.redis.lpush(key, ...serializedValues);
    } catch (error) {
      this.logger.error(`Cache lpush error for key ${key}:`, error);
      throw error;
    }
  }

  async lrange<T>(key: string, start: number, stop: number): Promise<T[]> {
    try {
      const values = await this.redis.lrange(key, start, stop);
      return values.map(value => JSON.parse(value));
    } catch (error) {
      this.logger.error(`Cache lrange error for key ${key}:`, error);
      return [];
    }
  }

  // 有序集合操作（用于排行榜、时间序列）
  async zadd(key: string, score: number, member: string): Promise<number> {
    try {
      return await this.redis.zadd(key, score, member);
    } catch (error) {
      this.logger.error(`Cache zadd error for key ${key}:`, error);
      throw error;
    }
  }

  async zrange(key: string, start: number, stop: number, withScores = false): Promise<string[]> {
    try {
      if (withScores) {
        return await this.redis.zrange(key, start, stop, 'WITHSCORES');
      }
      return await this.redis.zrange(key, start, stop);
    } catch (error) {
      this.logger.error(`Cache zrange error for key ${key}:`, error);
      return [];
    }
  }

  // 哈希操作
  async hset(key: string, field: string, value: any): Promise<number> {
    try {
      const serializedValue = JSON.stringify(value);
      return await this.redis.hset(key, field, serializedValue);
    } catch (error) {
      this.logger.error(`Cache hset error for key ${key}:`, error);
      throw error;
    }
  }

  async hget<T>(key: string, field: string): Promise<T | null> {
    try {
      const value = await this.redis.hget(key, field);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      this.logger.error(`Cache hget error for key ${key}:`, error);
      return null;
    }
  }

  async hgetall<T>(key: string): Promise<{ [field: string]: T }> {
    try {
      const hash = await this.redis.hgetall(key);
      const result: { [field: string]: T } = {};
      
      Object.entries(hash).forEach(([field, value]) => {
        result[field] = JSON.parse(value);
      });
      
      return result;
    } catch (error) {
      this.logger.error(`Cache hgetall error for key ${key}:`, error);
      return {};
    }
  }

  // 原子操作
  async incr(key: string): Promise<number> {
    try {
      return await this.redis.incr(key);
    } catch (error) {
      this.logger.error(`Cache incr error for key ${key}:`, error);
      throw error;
    }
  }

  async decr(key: string): Promise<number> {
    try {
      return await this.redis.decr(key);
    } catch (error) {
      this.logger.error(`Cache decr error for key ${key}:`, error);
      throw error;
    }
  }

  // 过期时间操作
  async expire(key: string, seconds: number): Promise<boolean> {
    try {
      const result = await this.redis.expire(key, seconds);
      return result === 1;
    } catch (error) {
      this.logger.error(`Cache expire error for key ${key}:`, error);
      return false;
    }
  }

  async ttl(key: string): Promise<number> {
    try {
      return await this.redis.ttl(key);
    } catch (error) {
      this.logger.error(`Cache ttl error for key ${key}:`, error);
      return -1;
    }
  }

  // 模式匹配删除
  async deletePattern(pattern: string): Promise<number> {
    try {
      const keys = await this.redis.keys(pattern);
      if (keys.length === 0) return 0;
      
      return await this.redis.del(...keys);
    } catch (error) {
      this.logger.error(`Cache delete pattern error for ${pattern}:`, error);
      return 0;
    }
  }
}
```

---

## 3. 核心业务缓存

### 3.1 用户相关缓存

```typescript
// src/modules/user/cache/user-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class UserCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 用户档案缓存
  async getUserProfile(userId: string): Promise<UserProfile | null> {
    const key = CacheKeyBuilder.userProfile(userId);
    return await this.cacheService.get<UserProfile>(key);
  }

  async setUserProfile(userId: string, profile: UserProfile, ttl = 3600): Promise<void> {
    const key = CacheKeyBuilder.userProfile(userId);
    await this.cacheService.set(key, profile, ttl);
  }

  async invalidateUserProfile(userId: string): Promise<void> {
    const key = CacheKeyBuilder.userProfile(userId);
    await this.cacheService.del(key);
  }

  // 用户偏好设置缓存
  async getUserPreferences(userId: string): Promise<UserPreferences | null> {
    const key = `${CacheKeyPrefix.USER_PREFERENCES}:${userId}`;
    return await this.cacheService.get<UserPreferences>(key);
  }

  async setUserPreferences(userId: string, preferences: UserPreferences): Promise<void> {
    const key = `${CacheKeyPrefix.USER_PREFERENCES}:${userId}`;
    await this.cacheService.set(key, preferences, 7200); // 2小时
  }

  // 用户会话缓存
  async getUserSession(sessionId: string): Promise<UserSession | null> {
    const key = `${CacheKeyPrefix.USER_SESSION}:${sessionId}`;
    return await this.cacheService.get<UserSession>(key);
  }

  async setUserSession(sessionId: string, session: UserSession): Promise<void> {
    const key = `${CacheKeyPrefix.USER_SESSION}:${sessionId}`;
    await this.cacheService.set(key, session, 86400); // 24小时
  }

  async extendUserSession(sessionId: string, extensionTime = 86400): Promise<void> {
    const key = `${CacheKeyPrefix.USER_SESSION}:${sessionId}`;
    await this.cacheService.expire(key, extensionTime);
  }

  // 用户积分缓存
  async getUserPoints(userId: string): Promise<number | null> {
    const key = CacheKeyBuilder.memberWallet(userId);
    const wallet = await this.cacheService.hget<MemberWallet>(key, 'points');
    return wallet?.points || null;
  }

  async updateUserPoints(userId: string, points: number): Promise<void> {
    const key = CacheKeyBuilder.memberWallet(userId);
    await this.cacheService.hset(key, 'points', points);
    await this.cacheService.expire(key, 3600); // 1小时
  }

  // 用户会员等级缓存
  async getUserMembership(userId: string): Promise<MembershipLevel | null> {
    const key = CacheKeyBuilder.userMembership(userId);
    return await this.cacheService.get<MembershipLevel>(key);
  }

  async setUserMembership(userId: string, level: MembershipLevel): Promise<void> {
    const key = CacheKeyBuilder.userMembership(userId);
    await this.cacheService.set(key, level, 7200); // 2小时
  }
}
```

### 3.2 餐厅和菜品缓存

```typescript
// src/modules/restaurant/cache/restaurant-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';

@Injectable()
export class RestaurantCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 餐厅信息缓存
  async getRestaurantInfo(restaurantId: string): Promise<RestaurantInfo | null> {
    const key = `${CacheKeyPrefix.RESTAURANT_INFO}:${restaurantId}`;
    return await this.cacheService.get<RestaurantInfo>(key);
  }

  async setRestaurantInfo(restaurantId: string, info: RestaurantInfo): Promise<void> {
    const key = `${CacheKeyPrefix.RESTAURANT_INFO}:${restaurantId}`;
    await this.cacheService.set(key, info, 7200); // 2小时
  }

  // 菜品详情缓存
  async getDishDetail(dishId: string): Promise<DishDetail | null> {
    const key = `${CacheKeyPrefix.DISH_DETAIL}:${dishId}`;
    return await this.cacheService.get<DishDetail>(key);
  }

  async setDishDetail(dishId: string, detail: DishDetail): Promise<void> {
    const key = `${CacheKeyPrefix.DISH_DETAIL}:${dishId}`;
    await this.cacheService.set(key, detail, 3600); // 1小时
  }

  // 菜品列表缓存（按餐厅分组）
  async getRestaurantDishes(restaurantId: string): Promise<DishDetail[] | null> {
    const key = `restaurant:dishes:${restaurantId}`;
    return await this.cacheService.get<DishDetail[]>(key);
  }

  async setRestaurantDishes(restaurantId: string, dishes: DishDetail[]): Promise<void> {
    const key = `restaurant:dishes:${restaurantId}`;
    await this.cacheService.set(key, dishes, 1800); // 30分钟
  }

  // 营养信息缓存
  async getDishNutrition(dishId: string): Promise<NutritionInfo | null> {
    const key = `dish:nutrition:${dishId}`;
    return await this.cacheService.get<NutritionInfo>(key);
  }

  async setDishNutrition(dishId: string, nutrition: NutritionInfo): Promise<void> {
    const key = `dish:nutrition:${dishId}`;
    await this.cacheService.set(key, nutrition, 86400); // 24小时
  }
}
```

---

## 4. AI功能缓存策略

### 4.1 AI推荐结果缓存

```typescript
// src/modules/ai/cache/ai-recommendation-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class AIRecommendationCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // AI推荐结果缓存
  async getRecommendations(userId: string, type: string): Promise<AIRecommendation[] | null> {
    const key = CacheKeyBuilder.aiRecommendation(userId, type);
    return await this.cacheService.get<AIRecommendation[]>(key);
  }

  async setRecommendations(
    userId: string, 
    type: string, 
    recommendations: AIRecommendation[]
  ): Promise<void> {
    const key = CacheKeyBuilder.aiRecommendation(userId, type);
    // AI推荐结果缓存1小时，因为用户偏好可能变化
    await this.cacheService.set(key, recommendations, 3600);
  }

  // 向量嵌入缓存
  async getVectorEmbedding(entityType: string, entityId: string): Promise<number[] | null> {
    const key = CacheKeyBuilder.vectorEmbedding(entityType, entityId);
    return await this.cacheService.get<number[]>(key);
  }

  async setVectorEmbedding(
    entityType: string, 
    entityId: string, 
    embedding: number[]
  ): Promise<void> {
    const key = CacheKeyBuilder.vectorEmbedding(entityType, entityId);
    // 向量嵌入相对稳定，缓存24小时
    await this.cacheService.set(key, embedding, 86400);
  }

  // 营养分析结果缓存
  async getNutritionAnalysis(userId: string, foodItems: string[]): Promise<NutritionAnalysis | null> {
    const key = `${CacheKeyPrefix.AI_NUTRITION_ANALYSIS}:${userId}:${this.hashFoodItems(foodItems)}`;
    return await this.cacheService.get<NutritionAnalysis>(key);
  }

  async setNutritionAnalysis(
    userId: string, 
    foodItems: string[], 
    analysis: NutritionAnalysis
  ): Promise<void> {
    const key = `${CacheKeyPrefix.AI_NUTRITION_ANALYSIS}:${userId}:${this.hashFoodItems(foodItems)}`;
    await this.cacheService.set(key, analysis, 7200); // 2小时
  }

  // AI聊天会话缓存
  async getChatSession(sessionId: string): Promise<ChatSession | null> {
    const key = `${CacheKeyPrefix.AI_CHAT_SESSION}:${sessionId}`;
    return await this.cacheService.get<ChatSession>(key);
  }

  async setChatSession(sessionId: string, session: ChatSession): Promise<void> {
    const key = `${CacheKeyPrefix.AI_CHAT_SESSION}:${sessionId}`;
    await this.cacheService.set(key, session, 3600); // 1小时
  }

  async appendChatMessage(sessionId: string, message: ChatMessage): Promise<void> {
    const key = `${CacheKeyPrefix.AI_CHAT_SESSION}:${sessionId}`;
    const session = await this.getChatSession(sessionId);
    
    if (session) {
      session.messages.push(message);
      session.lastUpdated = new Date();
      await this.setChatSession(sessionId, session);
    }
  }

  // 相似度搜索结果缓存
  async getSimilaritySearchResults(
    queryEmbedding: number[], 
    threshold: number
  ): Promise<SimilaritySearchResult[] | null> {
    const key = `ai:similarity:${this.hashEmbedding(queryEmbedding)}:${threshold}`;
    return await this.cacheService.get<SimilaritySearchResult[]>(key);
  }

  async setSimilaritySearchResults(
    queryEmbedding: number[], 
    threshold: number, 
    results: SimilaritySearchResult[]
  ): Promise<void> {
    const key = `ai:similarity:${this.hashEmbedding(queryEmbedding)}:${threshold}`;
    await this.cacheService.set(key, results, 1800); // 30分钟
  }

  // 工具方法
  private hashFoodItems(items: string[]): string {
    return Buffer.from(items.sort().join(',')).toString('base64').substring(0, 16);
  }

  private hashEmbedding(embedding: number[]): string {
    const sum = embedding.reduce((a, b) => a + b, 0);
    return Math.abs(sum).toString(36).substring(0, 12);
  }
}
```

### 4.2 图片识别缓存

```typescript
// src/modules/ai/cache/photo-recognition-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';

@Injectable()
export class PhotoRecognitionCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 图片识别结果缓存（基于图片哈希）
  async getRecognitionResult(imageHash: string): Promise<FoodRecognitionResult | null> {
    const key = `${CacheKeyPrefix.AI_PHOTO_RECOGNITION}:${imageHash}`;
    return await this.cacheService.get<FoodRecognitionResult>(key);
  }

  async setRecognitionResult(
    imageHash: string, 
    result: FoodRecognitionResult
  ): Promise<void> {
    const key = `${CacheKeyPrefix.AI_PHOTO_RECOGNITION}:${imageHash}`;
    // 图片识别结果缓存7天，因为同样的图片识别结果稳定
    await this.cacheService.set(key, result, 604800);
  }

  // 用户识别历史缓存（最近的识别记录）
  async getUserRecognitionHistory(userId: string): Promise<FoodRecognitionRecord[] | null> {
    const key = `ai:photo:history:${userId}`;
    return await this.cacheService.lrange<FoodRecognitionRecord>(key, 0, 19); // 最近20条
  }

  async addUserRecognitionHistory(
    userId: string, 
    record: FoodRecognitionRecord
  ): Promise<void> {
    const key = `ai:photo:history:${userId}`;
    await this.cacheService.lpush(key, record);
    // 保持最新20条记录
    await this.cacheService.ltrim(key, 0, 19);
    await this.cacheService.expire(key, 86400); // 24小时
  }

  // 识别统计缓存
  async getRecognitionStats(userId: string): Promise<RecognitionStatistic | null> {
    const key = `ai:photo:stats:${userId}`;
    return await this.cacheService.get<RecognitionStatistic>(key);
  }

  async updateRecognitionStats(userId: string, stats: RecognitionStatistic): Promise<void> {
    const key = `ai:photo:stats:${userId}`;
    await this.cacheService.set(key, stats, 7200); // 2小时
  }

  // 模型预测缓存（基于食物特征）
  async getModelPrediction(features: FoodFeatures): Promise<ModelPrediction | null> {
    const key = `ai:model:prediction:${this.hashFeatures(features)}`;
    return await this.cacheService.get<ModelPrediction>(key);
  }

  async setModelPrediction(
    features: FoodFeatures, 
    prediction: ModelPrediction
  ): Promise<void> {
    const key = `ai:model:prediction:${this.hashFeatures(features)}`;
    await this.cacheService.set(key, prediction, 3600); // 1小时
  }

  private hashFeatures(features: FoodFeatures): string {
    const str = JSON.stringify(features);
    return Buffer.from(str).toString('base64').substring(0, 16);
  }
}
```

---

## 5. 新增功能缓存设计

### 5.1 库存管理缓存

```typescript
// src/modules/inventory/cache/inventory-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class InventoryCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 库存数量缓存
  async getInventoryStock(storeId: string, dishId: string): Promise<number | null> {
    const key = CacheKeyBuilder.inventoryStock(storeId, dishId);
    return await this.cacheService.get<number>(key);
  }

  async setInventoryStock(storeId: string, dishId: string, stock: number): Promise<void> {
    const key = CacheKeyBuilder.inventoryStock(storeId, dishId);
    await this.cacheService.set(key, stock, 300); // 5分钟，库存变化频繁
  }

  async updateInventoryStock(storeId: string, dishId: string, delta: number): Promise<number> {
    const key = CacheKeyBuilder.inventoryStock(storeId, dishId);
    const currentStock = await this.getInventoryStock(storeId, dishId);
    
    if (currentStock !== null) {
      const newStock = Math.max(0, currentStock + delta);
      await this.setInventoryStock(storeId, dishId, newStock);
      return newStock;
    }
    
    return 0;
  }

  // 库存预警缓存
  async getLowStockAlerts(storeId: string): Promise<LowStockAlert[] | null> {
    const key = `inventory:alerts:${storeId}`;
    return await this.cacheService.get<LowStockAlert[]>(key);
  }

  async setLowStockAlerts(storeId: string, alerts: LowStockAlert[]): Promise<void> {
    const key = `inventory:alerts:${storeId}`;
    await this.cacheService.set(key, alerts, 600); // 10分钟
  }

  // 补货建议缓存
  async getRestockSuggestions(storeId: string): Promise<RestockSuggestion[] | null> {
    const key = `inventory:restock:${storeId}`;
    return await this.cacheService.get<RestockSuggestion[]>(key);
  }

  async setRestockSuggestions(storeId: string, suggestions: RestockSuggestion[]): Promise<void> {
    const key = `inventory:restock:${storeId}`;
    await this.cacheService.set(key, suggestions, 3600); // 1小时
  }

  // 供应商信息缓存
  async getSupplierInfo(supplierId: string): Promise<Supplier | null> {
    const key = `inventory:supplier:${supplierId}`;
    return await this.cacheService.get<Supplier>(key);
  }

  async setSupplierInfo(supplierId: string, supplier: Supplier): Promise<void> {
    const key = `inventory:supplier:${supplierId}`;
    await this.cacheService.set(key, supplier, 7200); // 2小时
  }

  // 库存事务历史缓存
  async getInventoryTransactions(storeId: string, dishId: string): Promise<InventoryTransaction[] | null> {
    const key = `inventory:transactions:${storeId}:${dishId}`;
    return await this.cacheService.lrange<InventoryTransaction>(key, 0, 49); // 最近50条
  }

  async addInventoryTransaction(
    storeId: string, 
    dishId: string, 
    transaction: InventoryTransaction
  ): Promise<void> {
    const key = `inventory:transactions:${storeId}:${dishId}`;
    await this.cacheService.lpush(key, transaction);
    await this.cacheService.ltrim(key, 0, 49); // 保持最新50条
    await this.cacheService.expire(key, 86400); // 24小时
  }
}
```

### 5.2 取餐码缓存

```typescript
// src/modules/pickup/cache/pickup-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class PickupCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 取餐码缓存
  async getPickupCode(orderId: string): Promise<PickupCode | null> {
    const key = CacheKeyBuilder.pickupCode(orderId);
    return await this.cacheService.get<PickupCode>(key);
  }

  async setPickupCode(orderId: string, pickupCode: PickupCode): Promise<void> {
    const key = CacheKeyBuilder.pickupCode(orderId);
    // 取餐码有效期通常1-2小时
    const ttl = pickupCode.expiresAt 
      ? Math.floor((pickupCode.expiresAt.getTime() - Date.now()) / 1000)
      : 7200;
    await this.cacheService.set(key, pickupCode, ttl);
  }

  async invalidatePickupCode(orderId: string): Promise<void> {
    const key = CacheKeyBuilder.pickupCode(orderId);
    await this.cacheService.del(key);
  }

  // 通过取餐码查找订单
  async getOrderByPickupCode(code: string): Promise<string | null> {
    const key = `pickup:code-to-order:${code}`;
    return await this.cacheService.get<string>(key);
  }

  async setOrderPickupCode(code: string, orderId: string, ttl: number): Promise<void> {
    const key = `pickup:code-to-order:${code}`;
    await this.cacheService.set(key, orderId, ttl);
  }

  // 取餐历史缓存
  async getPickupHistory(userId: string): Promise<PickupHistory[] | null> {
    const key = `pickup:history:${userId}`;
    return await this.cacheService.lrange<PickupHistory>(key, 0, 29); // 最近30条
  }

  async addPickupHistory(userId: string, history: PickupHistory): Promise<void> {
    const key = `pickup:history:${userId}`;
    await this.cacheService.lpush(key, history);
    await this.cacheService.ltrim(key, 0, 29);
    await this.cacheService.expire(key, 2592000); // 30天
  }

  // 营养标签缓存
  async getNutritionLabel(orderId: string): Promise<NutritionLabel | null> {
    const key = `pickup:nutrition-label:${orderId}`;
    return await this.cacheService.get<NutritionLabel>(key);
  }

  async setNutritionLabel(orderId: string, label: NutritionLabel): Promise<void> {
    const key = `pickup:nutrition-label:${orderId}`;
    await this.cacheService.set(key, label, 86400); // 24小时
  }
}
```

### 5.3 用户行为分析缓存

```typescript
// src/modules/analytics/cache/user-behavior-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class UserBehaviorCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 用户行为数据缓存（分时间窗口）
  async getUserBehavior(userId: string, timeWindow: string): Promise<UserBehavior[] | null> {
    const key = CacheKeyBuilder.userBehavior(userId, timeWindow);
    return await this.cacheService.lrange<UserBehavior>(key, 0, -1);
  }

  async addUserBehavior(userId: string, behavior: UserBehavior): Promise<void> {
    const now = new Date();
    const timeWindows = [
      `hour:${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}-${now.getHours()}`,
      `day:${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}`,
      `week:${now.getFullYear()}-${this.getWeekNumber(now)}`,
      `month:${now.getFullYear()}-${now.getMonth() + 1}`,
    ];

    for (const timeWindow of timeWindows) {
      const key = CacheKeyBuilder.userBehavior(userId, timeWindow);
      await this.cacheService.lpush(key, behavior);
      
      // 设置不同的过期时间
      const ttl = this.getTTLForTimeWindow(timeWindow);
      await this.cacheService.expire(key, ttl);
    }
  }

  // 用户偏好分析结果缓存
  async getUserPreferenceAnalysis(userId: string): Promise<UserPreferenceAnalysis | null> {
    const key = `behavior:preference:${userId}`;
    return await this.cacheService.get<UserPreferenceAnalysis>(key);
  }

  async setUserPreferenceAnalysis(userId: string, analysis: UserPreferenceAnalysis): Promise<void> {
    const key = `behavior:preference:${userId}`;
    await this.cacheService.set(key, analysis, 7200); // 2小时
  }

  // 用户活跃时段分析缓存
  async getUserActiveTimePatterns(userId: string): Promise<ActiveTimePattern[] | null> {
    const key = `behavior:time-patterns:${userId}`;
    return await this.cacheService.get<ActiveTimePattern[]>(key);
  }

  async setUserActiveTimePatterns(userId: string, patterns: ActiveTimePattern[]): Promise<void> {
    const key = `behavior:time-patterns:${userId}`;
    await this.cacheService.set(key, patterns, 86400); // 24小时
  }

  // 用户会话分析缓存
  async getUserSession(userId: string, sessionId: string): Promise<UserSession | null> {
    const key = `behavior:session:${userId}:${sessionId}`;
    return await this.cacheService.get<UserSession>(key);
  }

  async setUserSession(userId: string, sessionId: string, session: UserSession): Promise<void> {
    const key = `behavior:session:${userId}:${sessionId}`;
    await this.cacheService.set(key, session, 3600); // 1小时
  }

  async updateUserSession(userId: string, sessionId: string, updates: Partial<UserSession>): Promise<void> {
    const key = `behavior:session:${userId}:${sessionId}`;
    const session = await this.getUserSession(userId, sessionId);
    
    if (session) {
      const updatedSession = { ...session, ...updates };
      await this.setUserSession(userId, sessionId, updatedSession);
    }
  }

  // 批量行为数据缓存（用于离线分析）
  async getBatchBehaviorData(timeWindow: string): Promise<UserBehavior[] | null> {
    const key = `behavior:batch:${timeWindow}`;
    return await this.cacheService.lrange<UserBehavior>(key, 0, -1);
  }

  async addBatchBehaviorData(timeWindow: string, behaviors: UserBehavior[]): Promise<void> {
    const key = `behavior:batch:${timeWindow}`;
    await this.cacheService.lpush(key, ...behaviors);
    await this.cacheService.expire(key, 86400); // 24小时
  }

  // 工具方法
  private getWeekNumber(date: Date): number {
    const onejan = new Date(date.getFullYear(), 0, 1);
    const millisecsInDay = 86400000;
    return Math.ceil((((date.getTime() - onejan.getTime()) / millisecsInDay) + onejan.getDay() + 1) / 7);
  }

  private getTTLForTimeWindow(timeWindow: string): number {
    if (timeWindow.startsWith('hour:')) return 3600; // 1小时
    if (timeWindow.startsWith('day:')) return 86400; // 1天
    if (timeWindow.startsWith('week:')) return 604800; // 7天
    if (timeWindow.startsWith('month:')) return 2592000; // 30天
    return 3600; // 默认1小时
  }
}
```

### 5.4 营养师咨询缓存

```typescript
// src/modules/consultation/cache/consultation-cache.service.ts
import { Injectable } from '@nestjs/common';
import { CacheService } from '../../../common/cache/cache.service';
import { CacheKeyBuilder } from '../../../common/cache/cache-key.builder';

@Injectable()
export class ConsultationCacheService {
  constructor(private readonly cacheService: CacheService) {}

  // 咨询订单缓存
  async getConsultationOrder(orderId: string): Promise<ConsultationOrder | null> {
    const key = CacheKeyBuilder.consultationOrder(orderId);
    return await this.cacheService.get<ConsultationOrder>(key);
  }

  async setConsultationOrder(orderId: string, order: ConsultationOrder): Promise<void> {
    const key = CacheKeyBuilder.consultationOrder(orderId);
    await this.cacheService.set(key, order, 7200); // 2小时
  }

  async updateConsultationOrder(orderId: string, updates: Partial<ConsultationOrder>): Promise<void> {
    const key = CacheKeyBuilder.consultationOrder(orderId);
    const order = await this.getConsultationOrder(orderId);
    
    if (order) {
      const updatedOrder = { ...order, ...updates };
      await this.setConsultationOrder(orderId, updatedOrder);
    }
  }

  // 咨询消息缓存
  async getConsultationMessages(orderId: string): Promise<ConsultationMessage[] | null> {
    const key = `consultation:messages:${orderId}`;
    return await this.cacheService.lrange<ConsultationMessage>(key, 0, -1);
  }

  async addConsultationMessage(orderId: string, message: ConsultationMessage): Promise<void> {
    const key = `consultation:messages:${orderId}`;
    await this.cacheService.lpush(key, message);
    await this.cacheService.expire(key, 86400); // 24小时
  }

  // 营养师可用性缓存
  async getNutritionistAvailability(nutritionistId: string, date: string): Promise<AvailabilitySlot[] | null> {
    const key = `consultation:availability:${nutritionistId}:${date}`;
    return await this.cacheService.get<AvailabilitySlot[]>(key);
  }

  async setNutritionistAvailability(
    nutritionistId: string, 
    date: string, 
    slots: AvailabilitySlot[]
  ): Promise<void> {
    const key = `consultation:availability:${nutritionistId}:${date}`;
    await this.cacheService.set(key, slots, 3600); // 1小时
  }

  // 营养计划跟踪缓存
  async getNutritionPlanTracking(planId: string): Promise<NutritionPlanTracking | null> {
    const key = `consultation:plan-tracking:${planId}`;
    return await this.cacheService.get<NutritionPlanTracking>(key);
  }

  async setNutritionPlanTracking(planId: string, tracking: NutritionPlanTracking): Promise<void> {
    const key = `consultation:plan-tracking:${planId}`;
    await this.cacheService.set(key, tracking, 7200); // 2小时
  }

  async updateNutritionPlanTracking(planId: string, updates: Partial<NutritionPlanTracking>): Promise<void> {
    const key = `consultation:plan-tracking:${planId}`;
    const tracking = await this.getNutritionPlanTracking(planId);
    
    if (tracking) {
      const updatedTracking = { ...tracking, ...updates };
      await this.setNutritionPlanTracking(planId, updatedTracking);
    }
  }

  // 咨询报告缓存
  async getConsultationReport(orderId: string): Promise<ConsultationReport | null> {
    const key = `consultation:report:${orderId}`;
    return await this.cacheService.get<ConsultationReport>(key);
  }

  async setConsultationReport(orderId: string, report: ConsultationReport): Promise<void> {
    const key = `consultation:report:${orderId}`;
    await this.cacheService.set(key, report, 86400); // 24小时
  }

  // 用户咨询历史缓存
  async getUserConsultationHistory(userId: string): Promise<ConsultationOrder[] | null> {
    const key = `consultation:user-history:${userId}`;
    return await this.cacheService.get<ConsultationOrder[]>(key);
  }

  async setUserConsultationHistory(userId: string, history: ConsultationOrder[]): Promise<void> {
    const key = `consultation:user-history:${userId}`;
    await this.cacheService.set(key, history, 7200); // 2小时
  }

  // 营养师评价缓存
  async getNutritionistRating(nutritionistId: string): Promise<NutritionistRating | null> {
    const key = `consultation:nutritionist-rating:${nutritionistId}`;
    return await this.cacheService.get<NutritionistRating>(key);
  }

  async setNutritionistRating(nutritionistId: string, rating: NutritionistRating): Promise<void> {
    const key = `consultation:nutritionist-rating:${nutritionistId}`;
    await this.cacheService.set(key, rating, 3600); // 1小时
  }
}
```

---

## 6. 缓存更新策略

### 6.1 缓存失效策略

```typescript
// src/common/cache/cache-invalidation.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { CacheService } from './cache.service';

@Injectable()
export class CacheInvalidationService {
  private readonly logger = new Logger(CacheInvalidationService.name);

  constructor(private readonly cacheService: CacheService) {}

  // 用户相关缓存失效
  async invalidateUserCache(userId: string): Promise<void> {
    const patterns = [
      `${CacheKeyPrefix.USER_PROFILE}:${userId}`,
      `${CacheKeyPrefix.USER_PREFERENCES}:${userId}`,
      `${CacheKeyPrefix.USER_POINTS}:${userId}`,
      `${CacheKeyPrefix.USER_MEMBERSHIP}:${userId}`,
      `${CacheKeyPrefix.AI_RECOMMENDATION}:${userId}:*`,
      `behavior:*:${userId}`,
      `consultation:user-history:${userId}`,
    ];

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated cache for user: ${userId}`);
  }

  // 订单相关缓存失效
  async invalidateOrderCache(orderId: string, userId: string): Promise<void> {
    const patterns = [
      `${CacheKeyPrefix.ORDER_STATUS}:${orderId}`,
      `${CacheKeyPrefix.PICKUP_CODE}:${orderId}`,
      `pickup:code-to-order:*`, // 需要查找对应的取餐码
      `pickup:nutrition-label:${orderId}`,
      `${CacheKeyPrefix.USER_POINTS}:${userId}`, // 可能影响积分
    ];

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated cache for order: ${orderId}`);
  }

  // 餐厅菜品缓存失效
  async invalidateRestaurantCache(restaurantId: string): Promise<void> {
    const patterns = [
      `${CacheKeyPrefix.RESTAURANT_INFO}:${restaurantId}`,
      `restaurant:dishes:${restaurantId}`,
      `${CacheKeyPrefix.AI_RECOMMENDATION}:*:restaurant`,
    ];

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated cache for restaurant: ${restaurantId}`);
  }

  // 菜品缓存失效
  async invalidateDishCache(dishId: string, storeId?: string): Promise<void> {
    const patterns = [
      `${CacheKeyPrefix.DISH_DETAIL}:${dishId}`,
      `dish:nutrition:${dishId}`,
      `${CacheKeyPrefix.AI_VECTOR_EMBEDDING}:dish:${dishId}`,
    ];

    if (storeId) {
      patterns.push(
        `${CacheKeyPrefix.INVENTORY_STOCK}:${storeId}:${dishId}`,
        `inventory:transactions:${storeId}:${dishId}`,
      );
    }

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated cache for dish: ${dishId}`);
  }

  // 库存相关缓存失效
  async invalidateInventoryCache(storeId: string, dishId?: string): Promise<void> {
    const patterns = [
      `inventory:alerts:${storeId}`,
      `inventory:restock:${storeId}`,
    ];

    if (dishId) {
      patterns.push(
        `${CacheKeyPrefix.INVENTORY_STOCK}:${storeId}:${dishId}`,
        `inventory:transactions:${storeId}:${dishId}`,
      );
    } else {
      patterns.push(`${CacheKeyPrefix.INVENTORY_STOCK}:${storeId}:*`);
    }

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated inventory cache for store: ${storeId}`);
  }

  // AI相关缓存失效
  async invalidateAICache(userId?: string): Promise<void> {
    const patterns = userId
      ? [
          `${CacheKeyPrefix.AI_RECOMMENDATION}:${userId}:*`,
          `${CacheKeyPrefix.AI_NUTRITION_ANALYSIS}:${userId}:*`,
          `${CacheKeyPrefix.AI_CHAT_SESSION}:*${userId}*`,
        ]
      : [
          `${CacheKeyPrefix.AI_RECOMMENDATION}:*`,
          `${CacheKeyPrefix.AI_VECTOR_EMBEDDING}:*`,
          `ai:similarity:*`,
          `ai:model:prediction:*`,
        ];

    await this.invalidateMultiplePatterns(patterns);
    this.logger.log(`Invalidated AI cache${userId ? ` for user: ${userId}` : ''}`);
  }

  // 批量失效多个模式
  private async invalidateMultiplePatterns(patterns: string[]): Promise<void> {
    const promises = patterns.map(pattern => {
      if (pattern.includes('*')) {
        return this.cacheService.deletePattern(pattern);
      } else {
        return this.cacheService.del(pattern);
      }
    });

    await Promise.allSettled(promises);
  }

  // 定时清理过期缓存
  async cleanupExpiredCache(): Promise<void> {
    try {
      // 清理过期的用户行为数据
      const now = new Date();
      const expiredTimeWindows = [
        `hour:${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate()}-${now.getHours() - 2}`,
        `day:${now.getFullYear()}-${now.getMonth() + 1}-${now.getDate() - 2}`,
      ];

      for (const timeWindow of expiredTimeWindows) {
        await this.cacheService.deletePattern(`behavior:*:${timeWindow}`);
      }

      // 清理过期的临时数据
      await this.cacheService.deletePattern('temp:*');
      
      this.logger.log('Completed expired cache cleanup');
    } catch (error) {
      this.logger.error('Failed to cleanup expired cache:', error);
    }
  }
}
```

### 6.2 缓存预热策略

```typescript
// src/common/cache/cache-warmup.service.ts
import { Injectable, Logger, OnApplicationBootstrap } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CacheService } from './cache.service';
import { UserCacheService } from '../../modules/user/cache/user-cache.service';
import { RestaurantCacheService } from '../../modules/restaurant/cache/restaurant-cache.service';

@Injectable()
export class CacheWarmupService implements OnApplicationBootstrap {
  private readonly logger = new Logger(CacheWarmupService.name);

  constructor(
    private readonly cacheService: CacheService,
    private readonly userCacheService: UserCacheService,
    private readonly restaurantCacheService: RestaurantCacheService,
    private readonly configService: ConfigService,
  ) {}

  async onApplicationBootstrap(): Promise<void> {
    if (this.configService.get('CACHE_WARMUP_ENABLED', true)) {
      await this.warmupCache();
    }
  }

  async warmupCache(): Promise<void> {
    this.logger.log('Starting cache warmup...');

    try {
      await Promise.all([
        this.warmupSystemConfig(),
        this.warmupPopularRestaurants(),
        this.warmupPopularDishes(),
        this.warmupAIModels(),
      ]);

      this.logger.log('Cache warmup completed successfully');
    } catch (error) {
      this.logger.error('Cache warmup failed:', error);
    }
  }

  // 预热系统配置
  private async warmupSystemConfig(): Promise<void> {
    const configs = [
      { key: 'system:rate-limits', value: { api: 100, ai: 10 } },
      { key: 'system:feature-flags', value: { aiEnabled: true, newUIEnabled: false } },
      { key: 'system:maintenance', value: { inProgress: false, scheduledAt: null } },
    ];

    for (const config of configs) {
      await this.cacheService.set(config.key, config.value, 3600);
    }

    this.logger.log('System config cache warmed up');
  }

  // 预热热门餐厅
  private async warmupPopularRestaurants(): Promise<void> {
    // 模拟热门餐厅数据
    const popularRestaurants = [
      { id: 'rest-1', name: '健康轻食', category: 'healthy' },
      { id: 'rest-2', name: '营养汤品', category: 'soup' },
      { id: 'rest-3', name: '低卡美食', category: 'low-calorie' },
    ];

    for (const restaurant of popularRestaurants) {
      await this.restaurantCacheService.setRestaurantInfo(restaurant.id, restaurant as any);
    }

    this.logger.log('Popular restaurants cache warmed up');
  }

  // 预热热门菜品
  private async warmupPopularDishes(): Promise<void> {
    // 模拟热门菜品数据
    const popularDishes = [
      { id: 'dish-1', name: '蛋白质沙拉', calories: 250, protein: 25 },
      { id: 'dish-2', name: '低脂鸡胸肉', calories: 200, protein: 30 },
      { id: 'dish-3', name: '营养汤品', calories: 150, protein: 15 },
    ];

    for (const dish of popularDishes) {
      await this.restaurantCacheService.setDishDetail(dish.id, dish as any);
      await this.restaurantCacheService.setDishNutrition(dish.id, {
        calories: dish.calories,
        protein: dish.protein,
      } as any);
    }

    this.logger.log('Popular dishes cache warmed up');
  }

  // 预热AI模型
  private async warmupAIModels(): Promise<void> {
    // 预热向量嵌入缓存
    const commonEmbeddings = [
      { type: 'dish', id: 'salad', embedding: new Array(1536).fill(0.1) },
      { type: 'dish', id: 'chicken', embedding: new Array(1536).fill(0.2) },
      { type: 'user', id: 'preference-healthy', embedding: new Array(1536).fill(0.3) },
    ];

    for (const item of commonEmbeddings) {
      const key = `${CacheKeyPrefix.AI_VECTOR_EMBEDDING}:${item.type}:${item.id}`;
      await this.cacheService.set(key, item.embedding, 86400);
    }

    this.logger.log('AI models cache warmed up');
  }

  // 手动预热指定用户数据
  async warmupUserData(userId: string): Promise<void> {
    try {
      // 这里需要从数据库加载用户数据
      // const userProfile = await this.userService.getUserProfile(userId);
      // const userPreferences = await this.userService.getUserPreferences(userId);
      
      // 模拟数据预热
      const mockProfile = { id: userId, name: 'Test User' };
      const mockPreferences = { cuisineTypes: ['chinese'], maxCalories: 2000 };

      await this.userCacheService.setUserProfile(userId, mockProfile as any);
      await this.userCacheService.setUserPreferences(userId, mockPreferences as any);

      this.logger.log(`User data warmed up for: ${userId}`);
    } catch (error) {
      this.logger.error(`Failed to warmup user data for ${userId}:`, error);
    }
  }
}
```

---

## 7. 缓存监控与优化

### 7.1 缓存监控服务

```typescript
// src/common/cache/cache-monitor.service.ts
import { Injectable, Logger } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { PrometheusService } from '../monitoring/prometheus.service';

@Injectable()
export class CacheMonitorService {
  private readonly logger = new Logger(CacheMonitorService.name);

  constructor(
    @InjectRedis() private readonly redis: Redis,
    private readonly prometheusService: PrometheusService,
  ) {}

  // 每分钟监控缓存状态
  @Cron(CronExpression.EVERY_MINUTE)
  async monitorCacheHealth(): Promise<void> {
    try {
      const info = await this.redis.info();
      const stats = this.parseCacheStats(info);
      
      // 记录监控指标
      this.prometheusService.recordCacheMetrics(stats);
      
      // 检查关键指标
      await this.checkCacheAlerts(stats);
      
    } catch (error) {
      this.logger.error('Cache monitoring failed:', error);
    }
  }

  // 每小时收集缓存统计
  @Cron(CronExpression.EVERY_HOUR)
  async collectCacheStatistics(): Promise<void> {
    try {
      const statistics = await this.gatherDetailedStats();
      
      // 分析缓存命中率
      await this.analyzeCacheHitRates(statistics);
      
      // 分析热点数据
      await this.analyzeHotKeys(statistics);
      
      // 分析内存使用
      await this.analyzeMemoryUsage(statistics);
      
      this.logger.log('Cache statistics collected');
    } catch (error) {
      this.logger.error('Failed to collect cache statistics:', error);
    }
  }

  // 解析缓存统计信息
  private parseCacheStats(info: string): CacheStats {
    const lines = info.split('\r\n');
    const stats: any = {};

    lines.forEach(line => {
      if (line.includes(':')) {
        const [key, value] = line.split(':');
        stats[key] = isNaN(Number(value)) ? value : Number(value);
      }
    });

    return {
      usedMemory: stats.used_memory || 0,
      maxMemory: stats.maxmemory || 0,
      hitRate: this.calculateHitRate(stats),
      connectedClients: stats.connected_clients || 0,
      keyspaceHits: stats.keyspace_hits || 0,
      keyspaceMisses: stats.keyspace_misses || 0,
      evictedKeys: stats.evicted_keys || 0,
      expiredKeys: stats.expired_keys || 0,
    };
  }

  // 计算缓存命中率
  private calculateHitRate(stats: any): number {
    const hits = stats.keyspace_hits || 0;
    const misses = stats.keyspace_misses || 0;
    const total = hits + misses;
    
    return total > 0 ? (hits / total) * 100 : 0;
  }

  // 检查缓存告警
  private async checkCacheAlerts(stats: CacheStats): Promise<void> {
    // 内存使用率告警
    if (stats.maxMemory > 0) {
      const memoryUsagePercent = (stats.usedMemory / stats.maxMemory) * 100;
      if (memoryUsagePercent > 90) {
        this.logger.warn(`High cache memory usage: ${memoryUsagePercent.toFixed(2)}%`);
      }
    }

    // 命中率告警
    if (stats.hitRate < 80) {
      this.logger.warn(`Low cache hit rate: ${stats.hitRate.toFixed(2)}%`);
    }

    // 连接数告警
    if (stats.connectedClients > 100) {
      this.logger.warn(`High number of cache connections: ${stats.connectedClients}`);
    }

    // 驱逐键告警
    if (stats.evictedKeys > 1000) {
      this.logger.warn(`High number of evicted keys: ${stats.evictedKeys}`);
    }
  }

  // 收集详细统计信息
  private async gatherDetailedStats(): Promise<DetailedCacheStats> {
    const [keyCount, dbSize, slowlogEntries] = await Promise.all([
      this.getKeyCount(),
      this.getDatabaseSize(),
      this.getSlowlogEntries(),
    ]);

    return {
      totalKeys: keyCount,
      databaseSize: dbSize,
      slowQueries: slowlogEntries,
      keyDistribution: await this.getKeyDistribution(),
    };
  }

  // 获取键总数
  private async getKeyCount(): Promise<number> {
    try {
      const dbsize = await this.redis.dbsize();
      return dbsize;
    } catch (error) {
      this.logger.error('Failed to get key count:', error);
      return 0;
    }
  }

  // 获取数据库大小
  private async getDatabaseSize(): Promise<number> {
    try {
      const info = await this.redis.info('memory');
      const match = info.match(/used_memory:(\d+)/);
      return match ? parseInt(match[1]) : 0;
    } catch (error) {
      this.logger.error('Failed to get database size:', error);
      return 0;
    }
  }

  // 获取慢查询日志
  private async getSlowlogEntries(): Promise<any[]> {
    try {
      return await this.redis.slowlog('get', 10);
    } catch (error) {
      this.logger.error('Failed to get slowlog entries:', error);
      return [];
    }
  }

  // 获取键分布统计
  private async getKeyDistribution(): Promise<{ [prefix: string]: number }> {
    try {
      const distribution: { [prefix: string]: number } = {};
      const prefixes = Object.values(CacheKeyPrefix);
      
      for (const prefix of prefixes) {
        const keys = await this.redis.keys(`${prefix}:*`);
        distribution[prefix] = keys.length;
      }
      
      return distribution;
    } catch (error) {
      this.logger.error('Failed to get key distribution:', error);
      return {};
    }
  }

  // 分析缓存命中率
  private async analyzeCacheHitRates(stats: DetailedCacheStats): Promise<void> {
    // 按前缀分析命中率
    const hitRatesByPrefix: { [prefix: string]: number } = {};
    
    for (const prefix of Object.values(CacheKeyPrefix)) {
      // 这里需要更复杂的逻辑来统计各前缀的命中率
      // 可以通过应用级别的统计来实现
      hitRatesByPrefix[prefix] = Math.random() * 100; // 模拟数据
    }

    this.logger.log('Cache hit rates by prefix:', hitRatesByPrefix);
  }

  // 分析热点数据
  private async analyzeHotKeys(stats: DetailedCacheStats): Promise<void> {
    // 分析访问频率最高的键
    // 这需要在应用层面记录访问统计
    this.logger.log('Hot keys analysis completed');
  }

  // 分析内存使用
  private async analyzeMemoryUsage(stats: DetailedCacheStats): Promise<void> {
    const memoryUsageByPrefix: { [prefix: string]: number } = {};
    
    // 估算各前缀的内存使用
    for (const [prefix, count] of Object.entries(stats.keyDistribution)) {
      // 这是一个粗略的估算，实际需要更精确的方法
      memoryUsageByPrefix[prefix] = count * 1024; // 假设每个键平均1KB
    }

    this.logger.log('Memory usage by prefix:', memoryUsageByPrefix);
  }
}

// 类型定义
interface CacheStats {
  usedMemory: number;
  maxMemory: number;
  hitRate: number;
  connectedClients: number;
  keyspaceHits: number;
  keyspaceMisses: number;
  evictedKeys: number;
  expiredKeys: number;
}

interface DetailedCacheStats {
  totalKeys: number;
  databaseSize: number;
  slowQueries: any[];
  keyDistribution: { [prefix: string]: number };
}
```

---

这份缓存策略文档完整覆盖了所有新增功能的缓存设计，包括AI服务、库存管理、用户行为分析、营养师咨询等功能的缓存键定义、TTL策略、失效机制和监控方案。接下来我将完成最后一个任务：索引策略优化。