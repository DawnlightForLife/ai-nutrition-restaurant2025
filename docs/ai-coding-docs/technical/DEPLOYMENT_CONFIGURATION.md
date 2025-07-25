# AI智能营养餐厅系统 - 部署配置指南

> **文档版本**: 2.0.0  
> **创建日期**: 2025-07-13  
> **更新日期**: 2025-07-13  
> **文档状态**: ✅ AI集成部署就绪  
> **目标受众**: DevOps团队、后端开发、系统架构师

## 📋 目录

- [1. 部署架构概述](#1-部署架构概述)
- [2. Docker容器化配置](#2-docker容器化配置)
- [3. AI服务部署配置](#3-ai服务部署配置)
- [4. 数据库部署配置](#4-数据库部署配置)
- [5. 服务编排配置](#5-服务编排配置)
- [6. 环境配置管理](#6-环境配置管理)
- [7. 监控与日志配置](#7-监控与日志配置)
- [8. 安全配置](#8-安全配置)
- [9. 性能优化配置](#9-性能优化配置)
- [10. 生产部署策略](#10-生产部署策略)

---

## 1. 部署架构概述

### 1.1 整体架构设计

```yaml
部署架构:
  开发环境:
    类型: Docker Compose 单机部署
    特点: 快速启动、完整功能、数据隔离
    资源需求: 16GB RAM, 4 CPU核心
    
  测试环境:
    类型: Kubernetes 集群部署
    特点: 自动化测试、CI/CD集成、扩缩容
    资源需求: 32GB RAM, 8 CPU核心
    
  预发布环境:
    类型: 云托管服务 + 容器
    特点: 生产级配置、性能测试、用户验收
    资源需求: 64GB RAM, 16 CPU核心
    
  生产环境:
    类型: 云原生架构 + 托管服务
    特点: 高可用、自动扩缩、监控告警
    资源需求: 弹性扩缩，最小32GB RAM

核心组件:
  应用层:
    - NestJS后端服务 (多实例)
    - React管理后台 (CDN部署)
    - Flutter移动应用 (应用商店)
    
  AI服务层:
    - DeepSeek API集成服务
    - LangChain向量处理服务
    - pgvector向量数据库
    - 图片识别处理服务
    
  数据层:
    - PostgreSQL 15+ (主数据库)
    - Redis 7.0+ (缓存/会话)
    - MinIO/S3 (文件存储)
    
  基础设施:
    - Nginx (负载均衡/反向代理)
    - Docker/Podman (容器运行时)
    - Prometheus + Grafana (监控)
    - ELK Stack (日志聚合)
```

### 1.2 服务依赖图

```mermaid
graph TB
    subgraph "负载均衡层"
        LB[Nginx/HAProxy]
    end
    
    subgraph "应用服务层"
        API1[NestJS-1]
        API2[NestJS-2]
        API3[NestJS-3]
        WEB[React Admin]
    end
    
    subgraph "AI服务层"
        AI_API[DeepSeek API]
        VECTOR[向量处理服务]
        PHOTO[图片识别服务]
        LANG[LangChain服务]
    end
    
    subgraph "数据存储层"
        PG[(PostgreSQL + pgvector)]
        REDIS[(Redis Cluster)]
        MINIO[(MinIO/S3)]
    end
    
    subgraph "监控日志层"
        PROM[Prometheus]
        GRAF[Grafana]
        ELK[ELK Stack]
    end
    
    LB --> API1
    LB --> API2
    LB --> API3
    LB --> WEB
    
    API1 --> VECTOR
    API2 --> PHOTO
    API3 --> LANG
    
    VECTOR --> AI_API
    PHOTO --> AI_API
    LANG --> AI_API
    
    API1 --> PG
    API2 --> PG
    API3 --> PG
    
    API1 --> REDIS
    API2 --> REDIS
    API3 --> REDIS
    
    API1 --> MINIO
    PHOTO --> MINIO
    
    API1 --> PROM
    API2 --> PROM
    API3 --> PROM
```

---

## 2. Docker容器化配置

### 2.1 NestJS后端Dockerfile

```dockerfile
# backend/Dockerfile
# 多阶段构建优化镜像大小

# 构建阶段
FROM node:18.17.0-alpine AS builder

# 安装构建依赖
RUN apk add --no-cache libc6-compat python3 make g++

WORKDIR /app

# 复制package文件并安装依赖
COPY package.json package-lock.json ./
RUN npm ci --only=production && npm cache clean --force

# 复制源代码
COPY . .

# 构建应用
RUN npm run build

# 生产阶段
FROM node:18.17.0-alpine AS production

# 设置时区
RUN apk add --no-cache tzdata
ENV TZ=Asia/Shanghai

# 创建应用用户（非root安全原则）
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nestjs -u 1001

# 设置工作目录
WORKDIR /app

# 从构建阶段复制文件
COPY --from=builder --chown=nestjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nestjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nestjs:nodejs /app/package.json ./

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# 切换到非root用户
USER nestjs

# 暴露端口
EXPOSE 3000

# 启动命令
CMD ["node", "dist/main.js"]

# 元数据标签
LABEL maintainer="AI Nutrition Restaurant Team"
LABEL version="2.0.0"
LABEL description="AI智能营养餐厅后端服务"
```

### 2.2 PostgreSQL + pgvector Dockerfile

```dockerfile
# database/Dockerfile
FROM postgres:15.4-alpine

# 安装pgvector扩展
RUN apk add --no-cache \
    build-base \
    git \
    postgresql-dev

# 下载并编译pgvector
RUN git clone --branch v0.5.0 https://github.com/pgvector/pgvector.git /tmp/pgvector && \
    cd /tmp/pgvector && \
    make && \
    make install && \
    rm -rf /tmp/pgvector

# 设置时区
ENV TZ=Asia/Shanghai

# 复制初始化脚本
COPY init-scripts/ /docker-entrypoint-initdb.d/

# 复制配置文件
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# 设置数据目录权限
RUN mkdir -p /var/lib/postgresql/data && \
    chown -R postgres:postgres /var/lib/postgresql

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD pg_isready -U $POSTGRES_USER -d $POSTGRES_DB || exit 1

# 启动命令
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

LABEL maintainer="AI Nutrition Restaurant Team"
LABEL version="15.4+pgvector0.5.0"
```

### 2.3 Redis集群Dockerfile

```dockerfile
# cache/Dockerfile
FROM redis:7.0.12-alpine

# 安装必要工具
RUN apk add --no-cache \
    bash \
    curl \
    jq

# 设置时区
ENV TZ=Asia/Shanghai

# 复制配置文件
COPY redis.conf /etc/redis/redis.conf
COPY redis-cluster.conf /etc/redis/redis-cluster.conf

# 创建数据目录
RUN mkdir -p /data/redis && \
    chown -R redis:redis /data

# 复制启动脚本
COPY scripts/redis-start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/redis-start.sh

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s \
  CMD redis-cli --no-auth-warning ping || exit 1

# 切换用户
USER redis

# 暴露端口
EXPOSE 6379 16379

# 启动命令
CMD ["/usr/local/bin/redis-start.sh"]

LABEL maintainer="AI Nutrition Restaurant Team"
LABEL version="7.0.12"
```

### 2.4 AI服务容器Dockerfile

```dockerfile
# ai-services/Dockerfile
FROM python:3.11-slim

# 设置环境变量
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    curl \
    git \
    libpq-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 创建应用用户
RUN groupadd -r aiuser && useradd -r -g aiuser aiuser

# 设置工作目录
WORKDIR /app

# 复制requirements并安装Python依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安装额外的AI依赖
RUN pip install --no-cache-dir \
    langchain==0.0.20 \
    openai==4.20.1 \
    pgvector==0.1.8 \
    Pillow==10.0.0 \
    torch==2.0.1 \
    transformers==4.33.0

# 复制应用代码
COPY --chown=aiuser:aiuser . .

# 创建必要目录
RUN mkdir -p /app/logs /app/temp && \
    chown -R aiuser:aiuser /app

# 健康检查
HEALTHCHECK --interval=60s --timeout=30s --start-period=120s \
  CMD curl -f http://localhost:8000/health || exit 1

# 切换用户
USER aiuser

# 暴露端口
EXPOSE 8000

# 启动命令
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]

LABEL maintainer="AI Nutrition Restaurant Team"
LABEL version="2.0.0"
LABEL description="AI服务：图片识别、向量处理、LangChain集成"
```

---

## 3. AI服务部署配置

### 3.1 AI服务环境配置

```yaml
# ai-services/config/production.yml
ai_services:
  deepseek:
    api_endpoint: "https://api.deepseek.com"
    api_version: "v1"
    models:
      chat: "deepseek-chat"
      coder: "deepseek-coder"
      embedding: "text-embedding-ada-002"
    rate_limits:
      requests_per_minute: 1000
      tokens_per_minute: 50000
    timeout: 30
    retry_attempts: 3
    
  langchain:
    vector_store:
      provider: "pgvector"
      connection:
        host: "${DB_HOST}"
        port: 5432
        database: "${DB_NAME}"
        user: "${DB_USER}"
        password: "${DB_PASSWORD}"
    embedding:
      provider: "openai_compatible"
      model: "text-embedding-ada-002"
      dimensions: 1536
    cache:
      provider: "redis"
      ttl: 3600
      
  image_recognition:
    models:
      food_detection: "yolo-v8-food"
      nutrition_analysis: "nutrition-classifier-v2"
    processing:
      max_image_size: "10MB"
      supported_formats: ["jpg", "jpeg", "png", "webp"]
      resize_max_dimension: 1024
    storage:
      provider: "minio"
      bucket: "food-images"
      retention_days: 30
      
  performance:
    worker_processes: 4
    max_concurrent_requests: 100
    request_timeout: 30
    memory_limit: "2GB"
    
  monitoring:
    metrics_enabled: true
    health_check_interval: 30
    log_level: "INFO"
    prometheus_port: 9090
```

### 3.2 向量数据库初始化脚本

```sql
-- database/init-scripts/01-init-pgvector.sql

-- 创建pgvector扩展
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 创建向量嵌入表
CREATE TABLE IF NOT EXISTS vector_embeddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    entity_type VARCHAR(50) NOT NULL,
    entity_id VARCHAR(255) NOT NULL,
    embedding vector(1536) NOT NULL,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 创建向量索引 (HNSW算法，最适合相似性搜索)
CREATE INDEX IF NOT EXISTS idx_vector_embeddings_hnsw 
ON vector_embeddings USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- 创建常规索引
CREATE INDEX IF NOT EXISTS idx_vector_embeddings_entity 
ON vector_embeddings (entity_type, entity_id);

CREATE INDEX IF NOT EXISTS idx_vector_embeddings_created_at 
ON vector_embeddings (created_at DESC);

-- 创建AI功能相关表的向量字段和索引

-- 菜品向量嵌入
ALTER TABLE dishes ADD COLUMN IF NOT EXISTS nutrition_embedding vector(1536);
CREATE INDEX IF NOT EXISTS idx_dishes_nutrition_embedding 
ON dishes USING hnsw (nutrition_embedding vector_cosine_ops)
WHERE nutrition_embedding IS NOT NULL;

-- 用户偏好向量嵌入
ALTER TABLE user_preferences ADD COLUMN IF NOT EXISTS preference_embedding vector(1536);
CREATE INDEX IF NOT EXISTS idx_user_preferences_embedding 
ON user_preferences USING hnsw (preference_embedding vector_cosine_ops)
WHERE preference_embedding IS NOT NULL;

-- 创建向量搜索函数
CREATE OR REPLACE FUNCTION find_similar_dishes(
    query_embedding vector(1536),
    similarity_threshold float DEFAULT 0.7,
    max_results int DEFAULT 10
)
RETURNS TABLE (
    dish_id uuid,
    dish_name varchar,
    similarity_score float
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.id,
        d.name,
        1 - (d.nutrition_embedding <=> query_embedding) as similarity
    FROM dishes d
    WHERE d.nutrition_embedding IS NOT NULL
        AND 1 - (d.nutrition_embedding <=> query_embedding) > similarity_threshold
    ORDER BY d.nutrition_embedding <=> query_embedding
    LIMIT max_results;
END;
$$ LANGUAGE plpgsql;

-- 创建向量更新触发器
CREATE OR REPLACE FUNCTION update_vector_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vector_embeddings_updated_at
    BEFORE UPDATE ON vector_embeddings
    FOR EACH ROW
    EXECUTE FUNCTION update_vector_timestamp();

-- 设置向量搜索相关配置
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements,vector';
ALTER SYSTEM SET work_mem = '256MB';
ALTER SYSTEM SET maintenance_work_mem = '1GB';
ALTER SYSTEM SET effective_cache_size = '4GB';

-- 授权
GRANT ALL PRIVILEGES ON TABLE vector_embeddings TO ai_nutrition_user;
GRANT EXECUTE ON FUNCTION find_similar_dishes TO ai_nutrition_user;

-- 插入初始化数据（可选）
INSERT INTO vector_embeddings (entity_type, entity_id, embedding, metadata) VALUES 
('system', 'initialization', array_fill(0.0, ARRAY[1536])::vector, '{"purpose": "initialization_placeholder"}');

COMMENT ON TABLE vector_embeddings IS 'AI向量嵌入存储表';
COMMENT ON COLUMN vector_embeddings.embedding IS '1536维向量嵌入数据';
COMMENT ON FUNCTION find_similar_dishes IS '基于向量相似性查找相似菜品';
```

### 3.3 AI服务Docker Compose配置

```yaml
# ai-services/docker-compose.ai.yml
version: '3.8'

services:
  ai-vector-service:
    build:
      context: ./ai-services
      dockerfile: Dockerfile
    container_name: ai-vector-service
    restart: unless-stopped
    environment:
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - OPENAI_API_BASE=https://api.deepseek.com
      - POSTGRES_HOST=postgres-ai
      - POSTGRES_PORT=5432
      - POSTGRES_DB=${DB_NAME}
      - POSTGRES_USER=${DB_USER}
      - POSTGRES_PASSWORD=${DB_PASSWORD}
      - REDIS_URL=redis://redis-cluster:6379
      - MINIO_ENDPOINT=minio:9000
      - MINIO_ACCESS_KEY=${MINIO_ACCESS_KEY}
      - MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
      - LOG_LEVEL=INFO
      - WORKERS=4
    ports:
      - "8000:8000"
      - "9090:9090"  # Prometheus metrics
    volumes:
      - ./ai-services/logs:/app/logs
      - ./ai-services/temp:/app/temp
      - /var/run/docker.sock:/var/run/docker.sock:ro
    networks:
      - ai-network
    depends_on:
      postgres-ai:
        condition: service_healthy
      redis-cluster:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          cpus: '1.0'
          memory: 2G
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  ai-image-processor:
    build:
      context: ./ai-services
      dockerfile: Dockerfile.image
    container_name: ai-image-processor
    restart: unless-stopped
    environment:
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - MODEL_PATH=/app/models
      - PROCESSING_WORKERS=2
      - MAX_IMAGE_SIZE=10MB
      - SUPPORTED_FORMATS=jpg,jpeg,png,webp
    ports:
      - "8001:8000"
    volumes:
      - ./ai-models:/app/models:ro
      - ./ai-services/temp:/app/temp
      - minio-data:/app/storage
    networks:
      - ai-network
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 6G
        reservations:
          cpus: '1.0'
          memory: 3G
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 60s
      timeout: 15s
      retries: 3
      start_period: 120s

  langchain-service:
    build:
      context: ./ai-services
      dockerfile: Dockerfile.langchain
    container_name: langchain-service
    restart: unless-stopped
    environment:
      - DEEPSEEK_API_KEY=${DEEPSEEK_API_KEY}
      - LANGCHAIN_TRACING_V2=true
      - LANGCHAIN_API_KEY=${LANGCHAIN_API_KEY}
      - VECTOR_STORE_URL=postgresql://${DB_USER}:${DB_PASSWORD}@postgres-ai:5432/${DB_NAME}
      - REDIS_URL=redis://redis-cluster:6379/2
    ports:
      - "8002:8000"
    volumes:
      - ./langchain-config:/app/config:ro
      - ./ai-services/logs:/app/logs
    networks:
      - ai-network
    depends_on:
      postgres-ai:
        condition: service_healthy
      redis-cluster:
        condition: service_healthy
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 3G
        reservations:
          cpus: '0.5'
          memory: 1G

volumes:
  minio-data:
    driver: local

networks:
  ai-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

---

## 4. 数据库部署配置

### 4.1 PostgreSQL生产配置

```ini
# database/postgresql.conf
# PostgreSQL 15 + pgvector优化配置

# 连接设置
listen_addresses = '*'
port = 5432
max_connections = 200
superuser_reserved_connections = 3

# 内存设置 (假设16GB系统内存)
shared_buffers = 4GB
effective_cache_size = 12GB
work_mem = 256MB
maintenance_work_mem = 1GB
wal_buffers = 64MB

# 检查点设置
checkpoint_completion_target = 0.9
checkpoint_timeout = 10min
max_wal_size = 2GB
min_wal_size = 512MB

# 归档和复制
wal_level = replica
archive_mode = on
archive_command = 'cp %p /var/lib/postgresql/wal_archive/%f'
max_wal_senders = 3
wal_keep_size = 1GB

# 查询规划器
random_page_cost = 1.1
effective_io_concurrency = 200
default_statistics_target = 100

# 向量搜索优化
shared_preload_libraries = 'pg_stat_statements,vector'

# 用于向量索引的内存设置
hnsw.ef_search = 100
hnsw.m = 16

# 日志设置
log_destination = 'csvlog'
logging_collector = on
log_directory = '/var/log/postgresql'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_file_mode = 0640
log_min_duration_statement = 1000
log_checkpoints = on
log_connections = on
log_disconnections = on
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '

# 性能监控
track_activities = on
track_counts = on
track_io_timing = on
track_functions = all

# 自动清理设置
autovacuum = on
autovacuum_max_workers = 4
autovacuum_naptime = 30s
autovacuum_vacuum_scale_factor = 0.1
autovacuum_analyze_scale_factor = 0.05

# 锁设置
deadlock_timeout = 1s
lock_timeout = 30s

# 客户端连接默认设置
timezone = 'Asia/Shanghai'
datestyle = 'iso, mdy'
lc_messages = 'en_US.utf8'
lc_monetary = 'en_US.utf8'
lc_numeric = 'en_US.utf8'
lc_time = 'en_US.utf8'
default_text_search_config = 'pg_catalog.english'
```

### 4.2 Redis集群配置

```conf
# cache/redis.conf
# Redis 7.0 集群配置

# 基本配置
bind 0.0.0.0
port 6379
timeout 300
tcp-keepalive 300

# 内存配置
maxmemory 2gb
maxmemory-policy allkeys-lru
maxmemory-samples 5

# 持久化配置
save 900 1
save 300 10
save 60 10000
rdbcompression yes
rdbchecksum yes
dbfilename dump.rdb
dir /data/redis

# AOF配置
appendonly yes
appendfilename "appendonly.aof"
appendfsync everysec
no-appendfsync-on-rewrite no
auto-aof-rewrite-percentage 100
auto-aof-rewrite-min-size 64mb

# 集群配置
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 15000
cluster-replica-validity-factor 10
cluster-migration-barrier 1
cluster-require-full-coverage yes

# 安全配置
requirepass ${REDIS_PASSWORD}
masterauth ${REDIS_PASSWORD}

# 日志配置
loglevel notice
logfile /data/redis/redis.log

# 客户端配置
timeout 300
tcp-backlog 511
tcp-keepalive 300

# 性能优化
hash-max-ziplist-entries 512
hash-max-ziplist-value 64
list-max-ziplist-size -2
list-compress-depth 0
set-max-intset-entries 512
zset-max-ziplist-entries 128
zset-max-ziplist-value 64
hll-sparse-max-bytes 3000

# 慢查询日志
slowlog-log-slower-than 10000
slowlog-max-len 128

# 事件通知
notify-keyspace-events "Ex"

# 客户端输出缓冲区限制
client-output-buffer-limit normal 0 0 0
client-output-buffer-limit replica 256mb 64mb 60
client-output-buffer-limit pubsub 32mb 8mb 60

# 网络配置
tcp-backlog 511
unixsocket /tmp/redis.sock
unixsocketperm 700
```

---

## 5. 服务编排配置

### 5.1 主Docker Compose配置

```yaml
# docker-compose.yml
version: '3.8'

x-common-variables: &common-variables
  TZ: Asia/Shanghai
  NODE_ENV: production

x-logging: &default-logging
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"

services:
  # 负载均衡器
  nginx:
    image: nginx:1.24-alpine
    container_name: nginx-lb
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/conf.d:/etc/nginx/conf.d:ro
      - ./ssl:/etc/nginx/ssl:ro
      - nginx-logs:/var/log/nginx
    networks:
      - app-network
    depends_on:
      - nestjs-app-1
      - nestjs-app-2
    logging: *default-logging

  # NestJS应用实例1
  nestjs-app-1:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: nestjs-app-1
    restart: unless-stopped
    environment:
      <<: *common-variables
      PORT: 3000
      DB_HOST: postgres-ai
      DB_PORT: 5432
      DB_NAME: ${DB_NAME}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://redis-cluster:6379
      JWT_SECRET: ${JWT_SECRET}
      DEEPSEEK_API_KEY: ${DEEPSEEK_API_KEY}
      AI_SERVICE_URL: http://ai-vector-service:8000
      MINIO_ENDPOINT: minio:9000
      MINIO_ACCESS_KEY: ${MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MINIO_SECRET_KEY}
    volumes:
      - app-logs:/app/logs
      - app-uploads:/app/uploads
    networks:
      - app-network
      - ai-network
    depends_on:
      postgres-ai:
        condition: service_healthy
      redis-cluster:
        condition: service_healthy
    logging: *default-logging
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M

  # NestJS应用实例2
  nestjs-app-2:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: nestjs-app-2
    restart: unless-stopped
    environment:
      <<: *common-variables
      PORT: 3000
      DB_HOST: postgres-ai
      DB_PORT: 5432
      DB_NAME: ${DB_NAME}
      DB_USER: ${DB_USER}
      DB_PASSWORD: ${DB_PASSWORD}
      REDIS_URL: redis://redis-cluster:6379
      JWT_SECRET: ${JWT_SECRET}
      DEEPSEEK_API_KEY: ${DEEPSEEK_API_KEY}
      AI_SERVICE_URL: http://ai-vector-service:8000
      MINIO_ENDPOINT: minio:9000
      MINIO_ACCESS_KEY: ${MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MINIO_SECRET_KEY}
    volumes:
      - app-logs:/app/logs
      - app-uploads:/app/uploads
    networks:
      - app-network
      - ai-network
    depends_on:
      postgres-ai:
        condition: service_healthy
      redis-cluster:
        condition: service_healthy
    logging: *default-logging
    deploy:
      resources:
        limits:
          cpus: '1.5'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 512M

  # PostgreSQL + pgvector
  postgres-ai:
    build:
      context: ./database
      dockerfile: Dockerfile
    container_name: postgres-ai
    restart: unless-stopped
    environment:
      POSTGRES_DB: ${DB_NAME}
      POSTGRES_USER: ${DB_USER}
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      PGDATA: /var/lib/postgresql/data/pgdata
    ports:
      - "5432:5432"
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - postgres-logs:/var/log/postgresql
      - ./database/init-scripts:/docker-entrypoint-initdb.d:ro
    networks:
      - app-network
      - ai-network
    command: >
      postgres
      -c config_file=/etc/postgresql/postgresql.conf
      -c hba_file=/etc/postgresql/pg_hba.conf
    logging: *default-logging
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 8G
        reservations:
          cpus: '1.0'
          memory: 4G
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER} -d ${DB_NAME}"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s

  # Redis集群
  redis-cluster:
    build:
      context: ./cache
      dockerfile: Dockerfile
    container_name: redis-cluster
    restart: unless-stopped
    environment:
      REDIS_PASSWORD: ${REDIS_PASSWORD}
    ports:
      - "6379:6379"
      - "16379:16379"
    volumes:
      - redis-data:/data
      - redis-logs:/var/log/redis
    networks:
      - app-network
      - ai-network
    logging: *default-logging
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 4G
        reservations:
          cpus: '0.5'
          memory: 2G
    healthcheck:
      test: ["CMD", "redis-cli", "--no-auth-warning", "-a", "${REDIS_PASSWORD}", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # MinIO对象存储
  minio:
    image: minio/minio:RELEASE.2023-09-30T07-02-29Z
    container_name: minio-storage
    restart: unless-stopped
    environment:
      MINIO_ACCESS_KEY: ${MINIO_ACCESS_KEY}
      MINIO_SECRET_KEY: ${MINIO_SECRET_KEY}
      MINIO_REGION: ap-southeast-1
    ports:
      - "9000:9000"
      - "9001:9001"
    volumes:
      - minio-data:/data
    networks:
      - app-network
      - ai-network
    command: server /data --console-address ":9001"
    logging: *default-logging
    deploy:
      resources:
        limits:
          memory: 2G
        reservations:
          memory: 512M
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:9000/minio/health/live"]
      interval: 30s
      timeout: 10s
      retries: 3

# 扩展AI服务
  ai-vector-service:
    extends:
      file: ai-services/docker-compose.ai.yml
      service: ai-vector-service

  ai-image-processor:
    extends:
      file: ai-services/docker-compose.ai.yml
      service: ai-image-processor

  langchain-service:
    extends:
      file: ai-services/docker-compose.ai.yml
      service: langchain-service

volumes:
  postgres-data:
    driver: local
  postgres-logs:
    driver: local
  redis-data:
    driver: local
  redis-logs:
    driver: local
  minio-data:
    driver: local
  nginx-logs:
    driver: local
  app-logs:
    driver: local
  app-uploads:
    driver: local

networks:
  app-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.18.0.0/16
  ai-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

### 5.2 Nginx负载均衡配置

```nginx
# nginx/nginx.conf
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 2048;
    use epoll;
    multi_accept on;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # 日志格式
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                   '$status $body_bytes_sent "$http_referer" '
                   '"$http_user_agent" "$http_x_forwarded_for" '
                   'rt=$request_time uct="$upstream_connect_time" '
                   'uht="$upstream_header_time" urt="$upstream_response_time"';

    access_log /var/log/nginx/access.log main;

    # 基本设置
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    client_max_body_size 100M;

    # Gzip压缩
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/javascript
        application/xml+rss
        application/json;

    # 上游服务器定义
    upstream nestjs_backend {
        least_conn;
        server nestjs-app-1:3000 max_fails=3 fail_timeout=30s;
        server nestjs-app-2:3000 max_fails=3 fail_timeout=30s;
        keepalive 32;
    }

    upstream ai_services {
        least_conn;
        server ai-vector-service:8000 max_fails=2 fail_timeout=30s;
        server ai-image-processor:8001 max_fails=2 fail_timeout=30s;
        server langchain-service:8002 max_fails=2 fail_timeout=30s;
        keepalive 16;
    }

    # 限流配置
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=ai:10m rate=2r/s;

    # 主服务器配置
    server {
        listen 80;
        server_name _;

        # 健康检查
        location /health {
            access_log off;
            return 200 "healthy\n";
            add_header Content-Type text/plain;
        }

        # API接口代理
        location /api/ {
            limit_req zone=api burst=20 nodelay;
            
            proxy_pass http://nestjs_backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_cache_bypass $http_upgrade;
            
            # 超时设置
            proxy_connect_timeout 30s;
            proxy_send_timeout 30s;
            proxy_read_timeout 30s;
            
            # 错误处理
            proxy_next_upstream error timeout http_502 http_503 http_504;
        }

        # AI服务代理
        location /ai/ {
            limit_req zone=ai burst=5 nodelay;
            
            proxy_pass http://ai_services;
            proxy_http_version 1.1;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            # AI服务需要更长的超时时间
            proxy_connect_timeout 60s;
            proxy_send_timeout 120s;
            proxy_read_timeout 120s;
            
            # 大文件上传支持
            client_max_body_size 50M;
        }

        # WebSocket支持
        location /ws/ {
            proxy_pass http://nestjs_backend;
            proxy_http_version 1.1;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            
            # WebSocket特殊设置
            proxy_cache_bypass $http_upgrade;
            proxy_buffering off;
        }

        # 静态文件
        location /static/ {
            alias /var/www/static/;
            expires 1y;
            add_header Cache-Control "public, immutable";
        }

        # 错误页面
        error_page 404 /404.html;
        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
            root /usr/share/nginx/html;
        }
    }

    # 包含其他配置文件
    include /etc/nginx/conf.d/*.conf;
}
```

---

## 6. 环境配置管理

### 6.1 环境变量配置文件

```bash
# .env.production
# 生产环境配置

# 应用基础配置
NODE_ENV=production
APP_PORT=3000
APP_HOST=0.0.0.0
APP_NAME="AI智能营养餐厅系统"
APP_VERSION=2.0.0

# 数据库配置
DB_HOST=postgres-ai
DB_PORT=5432
DB_NAME=ai_nutrition_restaurant
DB_USER=ai_nutrition_user
DB_PASSWORD=secure_db_password_2025
DB_MAX_CONNECTIONS=100
DB_SSL_MODE=prefer

# Redis配置
REDIS_HOST=redis-cluster
REDIS_PORT=6379
REDIS_PASSWORD=secure_redis_password_2025
REDIS_DB=0
REDIS_MAX_RETRIES=3

# JWT配置
JWT_SECRET=ultra_secure_jwt_secret_key_2025_ai_nutrition
JWT_EXPIRES_IN=24h
JWT_REFRESH_EXPIRES_IN=7d

# AI服务配置
DEEPSEEK_API_KEY=sk-deepseek-api-key-your-actual-key-here
DEEPSEEK_API_BASE=https://api.deepseek.com
OPENAI_COMPATIBLE_ENDPOINT=https://api.deepseek.com/v1
AI_SERVICE_URL=http://ai-vector-service:8000
AI_TIMEOUT=30000
AI_MAX_RETRIES=3

# LangChain配置
LANGCHAIN_API_KEY=lc-api-key-your-actual-key-here
LANGCHAIN_TRACING_V2=true
LANGCHAIN_PROJECT=ai-nutrition-restaurant

# 文件存储配置
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minio_access_key_2025
MINIO_SECRET_KEY=minio_secret_key_2025_secure
MINIO_BUCKET_NAME=ai-nutrition-files
MINIO_USE_SSL=false
MINIO_REGION=ap-southeast-1

# 短信服务配置
SMS_PROVIDER=aliyun
SMS_ACCESS_KEY=your_sms_access_key
SMS_SECRET_KEY=your_sms_secret_key
SMS_SIGNATURE=AI智能营养餐厅
SMS_TEMPLATE_ID=SMS_123456789

# 支付配置
WECHAT_PAY_APP_ID=your_wechat_app_id
WECHAT_PAY_MCH_ID=your_wechat_mch_id
WECHAT_PAY_API_KEY=your_wechat_pay_api_key
ALIPAY_APP_ID=your_alipay_app_id
ALIPAY_PRIVATE_KEY=your_alipay_private_key

# 监控配置
PROMETHEUS_METRICS_PORT=9090
HEALTH_CHECK_TIMEOUT=10000
LOG_LEVEL=info
LOG_MAX_FILES=7
LOG_MAX_SIZE=100m

# 安全配置
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX_REQUESTS=100
BCRYPT_SALT_ROUNDS=12
SESSION_SECRET=ultra_secure_session_secret_2025

# CORS配置
CORS_ORIGIN=https://admin.ai-nutrition-restaurant.com,https://ai-nutrition-restaurant.com
CORS_CREDENTIALS=true

# 第三方服务配置
GAODE_API_KEY=your_gaode_api_key
BAIDU_API_KEY=your_baidu_api_key
TENCENT_CLOUD_SECRET_ID=your_tencent_secret_id
TENCENT_CLOUD_SECRET_KEY=your_tencent_secret_key

# 环境标识
ENVIRONMENT=production
DEPLOYMENT_DATE=2025-07-13
GIT_COMMIT_HASH=placeholder
```

### 6.2 Docker Compose覆盖配置

```yaml
# docker-compose.override.yml
# 开发环境覆盖配置
version: '3.8'

services:
  nginx:
    ports:
      - "8080:80"  # 开发环境使用8080端口
    volumes:
      - ./nginx/nginx.dev.conf:/etc/nginx/nginx.conf:ro

  nestjs-app-1:
    environment:
      NODE_ENV: development
      LOG_LEVEL: debug
    volumes:
      - ./backend:/app:cached
      - /app/node_modules
    command: ["npm", "run", "start:dev"]

  nestjs-app-2:
    environment:
      NODE_ENV: development
      LOG_LEVEL: debug
    volumes:
      - ./backend:/app:cached
      - /app/node_modules
    command: ["npm", "run", "start:dev"]

  postgres-ai:
    environment:
      POSTGRES_DB: ai_nutrition_dev
    ports:
      - "5433:5432"  # 避免与本地PostgreSQL冲突

  redis-cluster:
    ports:
      - "6380:6379"  # 避免与本地Redis冲突

  ai-vector-service:
    environment:
      LOG_LEVEL: debug
    volumes:
      - ./ai-services:/app:cached

# 测试环境覆盖配置
---
# docker-compose.test.yml
version: '3.8'

services:
  nestjs-app-1:
    environment:
      NODE_ENV: test
      DB_NAME: ai_nutrition_test
    command: ["npm", "run", "test:e2e"]

  postgres-ai:
    environment:
      POSTGRES_DB: ai_nutrition_test
    tmpfs:
      - /var/lib/postgresql/data  # 使用内存数据库提高测试速度

  redis-cluster:
    tmpfs:
      - /data
```

### 6.3 Kubernetes部署配置

```yaml
# k8s/namespace.yml
apiVersion: v1
kind: Namespace
metadata:
  name: ai-nutrition-restaurant
  labels:
    app: ai-nutrition-restaurant
    env: production

---
# k8s/configmap.yml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
  namespace: ai-nutrition-restaurant
data:
  NODE_ENV: "production"
  APP_PORT: "3000"
  DB_HOST: "postgres-service"
  DB_PORT: "5432"
  REDIS_HOST: "redis-service"
  REDIS_PORT: "6379"
  AI_SERVICE_URL: "http://ai-service:8000"
  LOG_LEVEL: "info"

---
# k8s/secrets.yml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: ai-nutrition-restaurant
type: Opaque
stringData:
  DB_PASSWORD: "secure_db_password_2025"
  JWT_SECRET: "ultra_secure_jwt_secret_key_2025"
  DEEPSEEK_API_KEY: "sk-deepseek-api-key-actual"
  REDIS_PASSWORD: "secure_redis_password_2025"

---
# k8s/deployment.yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nestjs-app
  namespace: ai-nutrition-restaurant
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nestjs-app
  template:
    metadata:
      labels:
        app: nestjs-app
    spec:
      containers:
      - name: nestjs
        image: ai-nutrition-restaurant/backend:2.0.0
        ports:
        - containerPort: 3000
        envFrom:
        - configMapRef:
            name: app-config
        - secretRef:
            name: app-secrets
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 60
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1500m"

---
# k8s/service.yml
apiVersion: v1
kind: Service
metadata:
  name: nestjs-service
  namespace: ai-nutrition-restaurant
spec:
  selector:
    app: nestjs-app
  ports:
  - port: 80
    targetPort: 3000
  type: ClusterIP

---
# k8s/ingress.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: ai-nutrition-restaurant
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
    nginx.ingress.kubernetes.io/rate-limit: "100"
spec:
  tls:
  - hosts:
    - api.ai-nutrition-restaurant.com
    secretName: api-tls
  rules:
  - host: api.ai-nutrition-restaurant.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nestjs-service
            port:
              number: 80
```

---

这份部署配置文档涵盖了从开发到生产的完整部署流程，特别针对AI服务和pgvector数据库进行了优化。接下来我将继续完成剩余的缓存策略和索引策略配置。