# 开发环境设置指南

> **文档版本**: 1.0.0  
> **创建日期**: 2025-07-12  
> **更新日期**: 2025-07-12  
> **文档状态**: ✅ 环境配置指南  
> **目标受众**: 开发团队、新入职员工

## 📋 目录

- [1. 环境要求](#1-环境要求)
- [2. 后端开发环境](#2-后端开发环境)
- [3. 前端开发环境](#3-前端开发环境)
- [4. 数据库环境](#4-数据库环境)
- [5. 开发工具配置](#5-开发工具配置)
- [6. 项目初始化](#6-项目初始化)
- [7. 常见问题解决](#7-常见问题解决)

---

## 1. 环境要求

### 1.1 系统要求

```yaml
操作系统:
  macOS:
    - macOS 12.0+ (推荐)
    - 适用: Intel/Apple Silicon
    - 特性: 最佳Flutter开发体验
    
  Linux:
    - Ubuntu 20.04 LTS+ (推荐)
    - CentOS 8+, Fedora 35+
    - 特性: 性能好，资源占用低
    
  Windows:
    - Windows 10/11 + WSL2 (必须)
    - 推荐Ubuntu 22.04 LTS in WSL2
    - 特性: 需额外配置，性能稍差

硬件要求:
  内存:
    - 最低: 16GB (基础开发)
    - 推荐: 32GB (多服务并行)
    - Docker占用: 4-8GB
    
  存储:
    - SSD: ≥256GB (必须)
    - 剩余空间: ≥50GB
    - Docker镜像: ~10GB
    - Node modules: ~5GB
    
  CPU:
    - 最低: 4核心
    - 推荐: 8核心+
    - Docker编译: CPU密集型
    
  网络:
    - 稳定的互联网连接
    - 下载速度: ≥20Mbps
    - VPN配置(如需)
```

### 1.2 跨平台差异说明

```yaml
macOS特有配置:
  优势:
    - iOS模拟器原生支持
    - Xcode完整工具链
    - Docker Desktop性能优异
    
  注意事项:
    - M1/M2芯片需要Rosetta 2
    - Homebrew安装路径不同
    - 文件系统大小写敏感

Linux特有配置:
  优势:
    - 最佳性能和资源利用
    - Docker原生支持
    - 系统级包管理
    
  注意事项:
    - 需要手动安装Android SDK
    - 无iOS模拟器支持
    - 权限管理更严格

Windows + WSL2特有配置:
  优势:
    - Windows应用兼容性
    - Visual Studio集成
    - 双系统环境
    
  注意事项:
    - WSL2必须正确配置
    - 文件系统性能影响
    - 端口转发配置复杂
    - Docker Desktop WSL2集成
```

### 1.3 必需软件版本

```yaml
基础环境:
  - Node.js: 18.17.0+
  - npm: 9.0.0+
  - Flutter: 3.19.0+
  - Dart: 3.2.0+
  - Docker: 24.0.0+
  - Docker Compose: 2.0.0+

版本管理:
  - Git: 2.40.0+
  - GitHub CLI: 2.30.0+ (可选)

编辑器:
  - VS Code: 1.80.0+ (推荐)
  - Android Studio: 2023.1+ (Flutter开发)
  - WebStorm: 2023.2+ (可选)
```

---

## 2. 后端开发环境

### 2.1 Node.js环境设置

```bash
# 安装nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 重启终端或运行
source ~/.bashrc

# 安装和使用Node.js LTS版本
nvm install 18.17.0
nvm use 18.17.0
nvm alias default 18.17.0

# 验证安装
node --version  # 应显示 v18.17.0+
npm --version   # 应显示 9.0.0+

# 配置npm镜像源（可选，提升下载速度）
npm config set registry https://registry.npmmirror.com
```

### 2.2 NestJS CLI安装

```bash
# 全局安装NestJS CLI
npm install -g @nestjs/cli

# 验证安装
nest --version

# 创建新项目（仅首次）
nest new ai-nutrition-backend
cd ai-nutrition-backend

# 安装项目依赖
npm install
```

### 2.3 后端项目依赖

```json
{
  "dependencies": {
    "@nestjs/common": "^10.0.0",
    "@nestjs/core": "^10.0.0",
    "@nestjs/platform-express": "^10.0.0",
    "@nestjs/typeorm": "^10.0.0",
    "@nestjs/jwt": "^10.1.0",
    "@nestjs/passport": "^10.0.0",
    "@nestjs/websockets": "^10.0.0",
    "@nestjs/platform-socket.io": "^10.0.0",
    "typeorm": "^0.3.17",
    "pg": "^8.11.0",
    "pgvector": "^0.1.4",
    "redis": "^4.6.7",
    "bcrypt": "^5.1.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "langchain": "^0.0.145",
    "@types/bcrypt": "^5.0.0"
  },
  "devDependencies": {
    "@nestjs/testing": "^10.0.0",
    "@types/node": "^20.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.42.0",
    "jest": "^29.5.0",
    "prettier": "^3.0.0",
    "supertest": "^6.3.3",
    "typescript": "^5.1.3"
  }
}
```

---

## 3. 前端开发环境

### 3.1 Flutter环境设置

```bash
# macOS安装Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# 添加到shell配置文件
echo 'export PATH="$PATH:~/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 检查Flutter环境
flutter doctor

# 解决doctor检查中的问题
flutter doctor --android-licenses  # 同意Android许可
```

### 3.2 Android开发环境

```bash
# 安装Android Studio
# 下载地址: https://developer.android.com/studio

# 配置Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# 创建Android虚拟设备
# 在Android Studio中创建AVD，推荐配置：
# - 设备: Pixel 6
# - 系统镜像: Android 13 (API 33)
# - RAM: 4GB
```

### 3.3 iOS开发环境 (仅macOS)

```bash
# 安装Xcode (App Store)
# 安装Xcode命令行工具
xcode-select --install

# 安装CocoaPods
sudo gem install cocoapods

# 创建iOS模拟器 (在Xcode中配置)
# 推荐配置:
# - 设备: iPhone 14
# - iOS版本: 16.0+
```

### 3.4 Flutter项目创建

```bash
# 创建Flutter项目
flutter create ai_nutrition_app
cd ai_nutrition_app

# 添加依赖包
flutter pub add riverpod flutter_riverpod riverpod_annotation
flutter pub add dio cached_network_image
flutter pub add go_router
flutter pub add hive flutter_secure_storage
flutter pub add built_value built_collection
flutter pub add json_annotation
flutter pub add web_socket_channel

# 开发依赖
flutter pub add --dev build_runner
flutter pub add --dev riverpod_generator
flutter pub add --dev built_value_generator
flutter pub add --dev json_serializable
flutter pub add --dev flutter_test
flutter pub add --dev mockito

# 运行代码生成
flutter packages pub run build_runner build
```

---

## 4. 数据库环境

### 4.1 Docker环境设置

```bash
# 安装Docker Desktop
# 下载地址: https://www.docker.com/products/docker-desktop

# 验证安装
docker --version
docker-compose --version

# 启动Docker Desktop服务
```

### 4.2 PostgreSQL + pgvector设置

#### 高性能 Docker Compose 配置

```yaml
# docker-compose.yml - 资源优化版
version: '3.8'

services:
  postgres:
    image: pgvector/pgvector:pg15
    container_name: ai-nutrition-postgres
    environment:
      POSTGRES_DB: ai_nutrition_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password123
      POSTGRES_HOST_AUTH_METHOD: trust
      # 性能优化参数
      POSTGRES_SHARED_BUFFERS: 256MB
      POSTGRES_EFFECTIVE_CACHE_SIZE: 1GB
      POSTGRES_WORK_MEM: 16MB
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
      - ./postgresql.conf:/etc/postgresql/postgresql.conf
    networks:
      - ai-nutrition-network
    # 资源限制 - 防止资源耗尽
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '2.0'
        reservations:
          memory: 512M
          cpus: '0.5'
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: ai-nutrition-redis
    command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      - ./redis.conf:/usr/local/etc/redis/redis.conf
    networks:
      - ai-nutrition-network
    # 资源限制
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
        reservations:
          memory: 128M
          cpus: '0.25'
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

  # 开发环境监控(可选)
  adminer:
    image: adminer:latest
    container_name: ai-nutrition-adminer
    ports:
      - "8080:8080"
    networks:
      - ai-nutrition-network
    deploy:
      resources:
        limits:
          memory: 128M
          cpus: '0.25'
    profiles: ["tools"]

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  ai-nutrition-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
```

#### 平台特定配置

```bash
# macOS Docker Desktop 资源配置
# 设置 -> Resources
# Memory: 8GB (32GB系统) / 6GB (16GB系统)
# CPU: 4 cores
# Disk: 64GB

# Linux 原生 Docker 资源优化
echo '{"default-ulimits":{"nofile":{"hard":65536,"soft":65536}}}' | sudo tee /etc/docker/daemon.json
sudo systemctl restart docker

# Windows WSL2 内存限制
# 创建 %UserProfile%\.wslconfig
# [wsl2]
# memory=8GB
# processors=4
```

#### 启动和验证服务

```bash
# 启动数据库服务
docker-compose up -d

# 验证服务运行
docker-compose ps

# 检查服务健康状态
docker-compose logs postgres
docker-compose logs redis

# 连接PostgreSQL
docker exec -it ai-nutrition-postgres psql -U postgres -d ai_nutrition_db

# 创建pgvector扩展
CREATE EXTENSION IF NOT EXISTS vector;

# 验证pgvector安装
SELECT * FROM pg_extension WHERE extname = 'vector';

# 测试vector功能
CREATE TABLE test_vectors (id bigserial PRIMARY KEY, embedding vector(3));
INSERT INTO test_vectors (embedding) VALUES ('[1,2,3]'), ('[4,5,6]');
SELECT * FROM test_vectors;
DROP TABLE test_vectors;

# 退出psql
\q

# 测试Redis连接
docker exec -it ai-nutrition-redis redis-cli ping
```

#### 资源监控命令

```bash
# 监控容器资源使用
docker stats ai-nutrition-postgres ai-nutrition-redis

# 查看容器日志
docker-compose logs -f --tail=100 postgres

# 数据库性能监控
docker exec -it ai-nutrition-postgres psql -U postgres -c "SELECT * FROM pg_stat_activity;"

# 清理未使用的Docker资源
docker system prune -f
docker volume prune -f
```

### 4.3 数据库客户端工具

```bash
# 推荐工具
# 1. pgAdmin (Web界面)
docker run -p 5050:80 \
  -e 'PGADMIN_DEFAULT_EMAIL=admin@example.com' \
  -e 'PGADMIN_DEFAULT_PASSWORD=admin' \
  -d dpage/pgadmin4

# 2. DBeaver (桌面应用)
# 下载地址: https://dbeaver.io/

# 3. VS Code扩展
# PostgreSQL - ms-ossdata.vscode-postgresql
```

---

## 5. 开发工具配置

### 5.1 VS Code配置

```json
// .vscode/settings.json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "typescript.preferences.importModuleSpecifier": "relative",
  "eslint.validate": ["typescript", "javascript"],
  "prettier.requireConfig": true,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": false
  },
  "dart.flutterSdkPath": "~/flutter",
  "dart.debugExternalPackageLibraries": true,
  "dart.debugSdkLibraries": true
}
```

```json
// .vscode/extensions.json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-vscode.vscode-typescript-next",
    "dart-code.dart-code",
    "dart-code.flutter",
    "ms-ossdata.vscode-postgresql",
    "ms-vscode.vscode-json",
    "bradlc.vscode-tailwindcss",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense"
  ]
}
```

### 5.2 代码格式化配置

```json
// .prettierrc (后端)
{
  "semi": true,
  "trailingComma": "all",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

```yaml
# analysis_options.yaml (Flutter)
include: package:flutter_lints/flutter.yaml

analyzer:
  exclude:
    - "**/*.g.dart"
    - "**/*.g.dart"  # Built Value生成的文件
  
linter:
  rules:
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    unnecessary_null_aware_assignments: true
    prefer_is_empty: true
    prefer_is_not_empty: true
    avoid_print: true
    prefer_interpolation_to_compose_strings: true
```

### 5.3 Git配置

```bash
# 全局Git配置
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false

# 配置Git钩子
# .githooks/pre-commit
#!/bin/sh
# 运行代码检查
npm run lint
flutter analyze
npm run test
flutter test

# 使钩子可执行
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
```

---

## 6. 项目初始化

### 6.1 克隆项目

```bash
# 克隆项目仓库
git clone https://github.com/your-org/ai-nutrition-restaurant.git
cd ai-nutrition-restaurant

# 创建开发分支
git checkout -b feature/setup-environment
```

### 6.2 后端项目初始化

```bash
# 进入后端目录
cd backend

# 安装依赖
npm install

# 复制环境配置文件
cp .env.example .env

# 配置环境变量
# 编辑 .env 文件
DATABASE_URL=postgresql://postgres:password123@localhost:5432/ai_nutrition_db
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-jwt-secret-here
DEEPSEEK_API_KEY=your-deepseek-api-key

# 运行数据库迁移
npm run migration:run

# 启动开发服务器
npm run start:dev

# 验证服务运行
curl http://localhost:3000/health
```

### 6.3 前端项目初始化

```bash
# 进入前端目录
cd ../frontend

# 获取依赖
flutter pub get

# 运行代码生成
flutter packages pub run build_runner build

# 启动Flutter应用
flutter run

# 或者在浏览器中运行
flutter run -d chrome
```

### 6.4 验证环境设置

```bash
# 检查所有服务状态
docker-compose ps  # 数据库服务
curl http://localhost:3000/health  # 后端API
flutter doctor  # Flutter环境

# 运行测试套件
cd backend && npm test
cd ../frontend && flutter test
```

---

## 7. 常见问题解决

### 7.1 Flutter环境问题

```bash
# 问题: flutter doctor显示Android licence未接受
# 解决方案:
flutter doctor --android-licenses
# 全部输入 'y' 接受

# 问题: Xcode版本过旧
# 解决方案:
# 更新Xcode到最新版本，然后运行:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# 问题: CocoaPods版本冲突
# 解决方案:
sudo gem uninstall cocoapods
sudo gem install cocoapods
cd ios && pod repo update
```

### 7.2 数据库连接问题

```bash
# 问题: 无法连接PostgreSQL
# 检查Docker容器状态:
docker-compose ps
docker-compose logs postgres

# 重启数据库服务:
docker-compose down
docker-compose up -d postgres

# 问题: pgvector扩展未安装
# 连接数据库并创建扩展:
docker exec -it ai-nutrition-postgres psql -U postgres -d ai_nutrition_db
CREATE EXTENSION IF NOT EXISTS vector;
```

### 7.3 Node.js依赖问题

```bash
# 问题: npm install失败
# 清理缓存并重新安装:
npm cache clean --force
rm -rf node_modules package-lock.json
npm install

# 问题: 版本冲突
# 使用npm-check-updates更新依赖:
npx npm-check-updates -u
npm install

# 问题: 权限错误
# 修复npm权限:
sudo chown -R $(whoami) ~/.npm
```

### 7.4 开发工具问题

```bash
# 问题: VS Code Flutter插件无法找到SDK
# 解决方案:
# 在VS Code中按 Cmd+Shift+P
# 输入 "Flutter: Change SDK"
# 选择Flutter SDK路径: ~/flutter

# 问题: ESLint规则冲突
# 解决方案:
# 更新.eslintrc.js配置
# 或者临时禁用规则:
// eslint-disable-next-line @typescript-eslint/no-unused-vars
```

### 7.5 网络和代理问题

```bash
# 配置npm代理
npm config set proxy http://proxy-server:port
npm config set https-proxy http://proxy-server:port

# 配置Flutter代理
export HTTP_PROXY=http://proxy-server:port
export HTTPS_PROXY=http://proxy-server:port

# 配置Git代理
git config --global http.proxy http://proxy-server:port
git config --global https.proxy http://proxy-server:port
```

---

## 🚀 自动化环境初始化

### 📜 一键初始化脚本

创建以下脚本文件来自动化环境初始化过程：

#### setup-env.sh (主初始化脚本)

```bash
#!/bin/bash

# AI智能营养餐厅系统 - 环境自动化初始化脚本
# 版本: 1.0.0
# 兼容: macOS, Linux, Windows(WSL2)

set -e  # 出错时停止执行

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检测操作系统
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 检查Node.js环境
check_nodejs() {
    log_info "检查Node.js环境..."
    
    if ! command_exists node; then
        log_warning "Node.js未安装，开始安装..."
        install_nodejs
    else
        NODE_VERSION=$(node --version | sed 's/v//')
        if [[ "$(printf '%s\n' "18.17.0" "$NODE_VERSION" | sort -V | head -n1)" != "18.17.0" ]]; then
            log_warning "Node.js版本过低 ($NODE_VERSION)，需要18.17.0+"
            install_nodejs
        else
            log_success "Node.js版本符合要求: $NODE_VERSION"
        fi
    fi
}

# 安装Node.js
install_nodejs() {
    local os=$(detect_os)
    
    if [[ "$os" == "macos" ]]; then
        if command_exists brew; then
            brew install node@18
        else
            log_error "请先安装Homebrew: https://brew.sh/"
            exit 1
        fi
    elif [[ "$os" == "linux" ]]; then
        # 安装nvm并使用它安装Node.js
        if [[ ! -f "$HOME/.nvm/nvm.sh" ]]; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
            source "$HOME/.nvm/nvm.sh"
        fi
        nvm install 18.17.0
        nvm use 18.17.0
        nvm alias default 18.17.0
    else
        log_error "请手动安装Node.js 18.17.0+"
        exit 1
    fi
}

# 检查Flutter环境
check_flutter() {
    log_info "检查Flutter环境..."
    
    if ! command_exists flutter; then
        log_warning "Flutter未安装，请手动安装Flutter 3.19.0+"
        log_info "安装指南: https://docs.flutter.dev/get-started/install"
        return 1
    else
        FLUTTER_VERSION=$(flutter --version | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
        if [[ "$(printf '%s\n' "3.19.0" "$FLUTTER_VERSION" | sort -V | head -n1)" != "3.19.0" ]]; then
            log_warning "Flutter版本过低 ($FLUTTER_VERSION)，需要3.19.0+"
            return 1
        else
            log_success "Flutter版本符合要求: $FLUTTER_VERSION"
        fi
    fi
    
    # 运行flutter doctor
    log_info "运行Flutter Doctor..."
    flutter doctor
}

# 检查Docker环境
check_docker() {
    log_info "检查Docker环境..."
    
    if ! command_exists docker; then
        log_error "Docker未安装，请先安装Docker Desktop"
        exit 1
    fi
    
    if ! docker info >/dev/null 2>&1; then
        log_error "Docker未运行，请启动Docker Desktop"
        exit 1
    fi
    
    log_success "Docker环境正常"
}

# 初始化项目
init_project() {
    log_info "初始化项目环境..."
    
    # 创建必要的目录
    mkdir -p backend frontend docker/postgres docker/redis
    
    # 创建环境变量文件
    if [[ ! -f backend/.env ]]; then
        log_info "创建后端环境变量文件..."
        cat > backend/.env << EOF
# 数据库配置
DATABASE_URL=postgresql://postgres:password123@localhost:5432/ai_nutrition_db
REDIS_URL=redis://localhost:6379

# JWT配置
JWT_SECRET=your-jwt-secret-here-please-change-in-production
JWT_EXPIRES_IN=7d

# API配置
API_PORT=3000
API_PREFIX=api/v1

# AI服务配置
DEEPSEEK_API_KEY=your-deepseek-api-key
LANGCHAIN_API_KEY=your-langchain-api-key

# 文件上传配置
UPLOAD_DEST=./uploads
MAX_FILE_SIZE=10485760

# 开发环境标识
NODE_ENV=development
DEBUG=true
EOF
        log_success "后端环境变量文件已创建"
    fi
    
    # 创建Docker配置文件
    create_docker_configs
}

# 创建Docker配置文件
create_docker_configs() {
    log_info "创建Docker配置文件..."
    
    # 创建docker-compose.yml
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: pgvector/pgvector:pg15
    container_name: ai-nutrition-postgres
    environment:
      POSTGRES_DB: ai_nutrition_db
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password123
      POSTGRES_HOST_AUTH_METHOD: trust
      POSTGRES_SHARED_BUFFERS: 256MB
      POSTGRES_EFFECTIVE_CACHE_SIZE: 1GB
      POSTGRES_WORK_MEM: 16MB
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./docker/postgres:/docker-entrypoint-initdb.d
    networks:
      - ai-nutrition-network
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '2.0'
        reservations:
          memory: 512M
          cpus: '0.5'
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: ai-nutrition-redis
    command: redis-server --maxmemory 512mb --maxmemory-policy allkeys-lru
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - ai-nutrition-network
    deploy:
      resources:
        limits:
          memory: 1G
          cpus: '1.0'
        reservations:
          memory: 128M
          cpus: '0.25'
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  postgres_data:
    driver: local
  redis_data:
    driver: local

networks:
  ai-nutrition-network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/16
EOF

    # 创建数据库初始化脚本
    cat > docker/postgres/01-init-extensions.sql << 'EOF'
-- 安装必要的扩展
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 验证扩展安装
SELECT extname, extversion FROM pg_extension WHERE extname IN ('vector', 'uuid-ossp', 'pg_trgm');

-- 创建测试vector表
CREATE TABLE IF NOT EXISTS test_vectors (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    embedding vector(1536),
    created_at TIMESTAMP DEFAULT NOW()
);

-- 插入测试数据
INSERT INTO test_vectors (name, embedding) VALUES 
    ('test1', ARRAY[1,2,3,4,5]::float4[]),
    ('test2', ARRAY[2,3,4,5,6]::float4[])
ON CONFLICT DO NOTHING;

COMMIT;
EOF

    log_success "Docker配置文件已创建"
}

# 启动Docker服务
start_docker_services() {
    log_info "启动Docker服务..."
    
    # 启动服务
    docker-compose up -d
    
    # 等待服务启动
    log_info "等待服务启动..."
    sleep 10
    
    # 检查服务状态
    if docker-compose ps | grep -q "Up"; then
        log_success "Docker服务启动成功"
        
        # 验证数据库连接
        log_info "验证数据库连接..."
        if docker exec ai-nutrition-postgres pg_isready -U postgres >/dev/null 2>&1; then
            log_success "PostgreSQL连接正常"
        else
            log_error "PostgreSQL连接失败"
            return 1
        fi
        
        # 验证Redis连接
        if docker exec ai-nutrition-redis redis-cli ping >/dev/null 2>&1; then
            log_success "Redis连接正常"
        else
            log_error "Redis连接失败"
            return 1
        fi
    else
        log_error "Docker服务启动失败"
        docker-compose logs
        return 1
    fi
}

# 安装项目依赖
install_dependencies() {
    log_info "安装项目依赖..."
    
    # 后端依赖
    if [[ -d "backend" ]] && [[ -f "backend/package.json" ]]; then
        log_info "安装后端依赖..."
        cd backend
        npm install
        cd ..
        log_success "后端依赖安装完成"
    fi
    
    # 前端依赖
    if [[ -d "frontend" ]] && [[ -f "frontend/pubspec.yaml" ]]; then
        log_info "安装前端依赖..."
        cd frontend
        flutter pub get
        flutter packages pub run build_runner build
        cd ..
        log_success "前端依赖安装完成"
    fi
}

# 运行验证测试
run_verification() {
    log_info "运行环境验证..."
    
    # 运行完整验证脚本
    ./scripts/verify-env.sh
}

# 主函数
main() {
    echo "🚀 AI智能营养餐厅系统 - 环境自动化初始化"
    echo "================================================"
    
    # 检查基础环境
    check_nodejs
    check_flutter
    check_docker
    
    # 初始化项目
    init_project
    
    # 启动Docker服务
    start_docker_services
    
    # 安装依赖
    install_dependencies
    
    # 运行验证
    run_verification
    
    echo "================================================"
    log_success "环境初始化完成！"
    echo ""
    echo "下一步："
    echo "1. 检查 .env 文件并更新必要的配置"
    echo "2. 运行 ./scripts/verify-env.sh 验证环境"
    echo "3. 开始开发：按照 DEVELOPMENT_WORKFLOW.md 进行"
}

# 执行主函数
main "$@"
```

#### Makefile (简化命令)

```makefile
# AI智能营养餐厅系统 - 开发环境管理

.PHONY: help setup start stop clean test verify

# 默认目标
help:
	@echo "AI智能营养餐厅系统 - 开发环境管理"
	@echo "=================================="
	@echo "可用命令："
	@echo "  setup   - 一键环境初始化"
	@echo "  start   - 启动开发环境"
	@echo "  stop    - 停止开发环境"
	@echo "  clean   - 清理环境"
	@echo "  test    - 运行测试"
	@echo "  verify  - 验证环境"

# 一键环境初始化
setup:
	@echo "🚀 开始环境初始化..."
	@chmod +x scripts/setup-env.sh
	@./scripts/setup-env.sh

# 启动开发环境
start:
	@echo "▶️  启动开发环境..."
	@docker-compose up -d
	@echo "✅ 开发环境已启动"
	@echo "📊 服务状态："
	@docker-compose ps

# 停止开发环境
stop:
	@echo "⏹️  停止开发环境..."
	@docker-compose down
	@echo "✅ 开发环境已停止"

# 清理环境
clean:
	@echo "🧹 清理开发环境..."
	@docker-compose down -v
	@docker system prune -f
	@echo "✅ 环境清理完成"

# 运行测试
test:
	@echo "🧪 运行测试..."
	@if [ -d "backend" ]; then cd backend && npm test; fi
	@if [ -d "frontend" ]; then cd frontend && flutter test; fi

# 验证环境
verify:
	@echo "🔍 验证环境..."
	@chmod +x scripts/verify-env.sh
	@./scripts/verify-env.sh

# 重启环境
restart: stop start

# 查看日志
logs:
	@docker-compose logs -f

# 数据库控制台
db:
	@docker exec -it ai-nutrition-postgres psql -U postgres -d ai_nutrition_db

# Redis控制台
redis:
	@docker exec -it ai-nutrition-redis redis-cli
```

#### 使用说明

```bash
# 克隆项目后，运行一键初始化
chmod +x scripts/setup-env.sh
make setup

# 或者直接运行脚本
./scripts/setup-env.sh

# 日常开发命令
make start    # 启动环境
make stop     # 停止环境
make verify   # 验证环境
make test     # 运行测试
make clean    # 清理环境
```

## 📊 环境验证检查清单

### ✅ 安装验证

```bash
# 运行完整的环境检查脚本
#!/bin/bash

echo "🔍 检查开发环境..."

# Node.js环境
echo "📦 Node.js版本: $(node --version)"
echo "📦 npm版本: $(npm --version)"

# Flutter环境  
echo "📱 Flutter版本: $(flutter --version | head -1)"
echo "📱 Dart版本: $(dart --version)"

# Docker环境
echo "🐳 Docker版本: $(docker --version)"
echo "🐳 Docker Compose版本: $(docker-compose --version)"

# 数据库连接测试
echo "🗄️  测试数据库连接..."
docker exec ai-nutrition-postgres pg_isready -U postgres

# 服务健康检查
echo "🌐 测试后端API..."
curl -f http://localhost:3000/health || echo "后端服务未运行"

echo "✅ 环境检查完成！"
```

## 🔄 持续环境验证机制

### 7.1 GitHub Actions本地运行配置

#### 安装act工具 (GitHub Actions本地运行器)

```bash
# macOS
brew install act

# Linux
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Windows (WSL2)
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | bash
```

#### 创建GitHub Actions工作流

```yaml
# .github/workflows/env-check.yml
name: 开发环境检查

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]
  schedule:
    # 每天早上9点运行环境检查
    - cron: '0 9 * * *'

jobs:
  environment-check:
    runs-on: ubuntu-latest
    
    steps:
    - name: 检出代码
      uses: actions/checkout@v4
      
    - name: 设置Node.js环境
      uses: actions/setup-node@v4
      with:
        node-version: '18.17.0'
        cache: 'npm'
        cache-dependency-path: backend/package-lock.json
        
    - name: 设置Flutter环境
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.19.0'
        channel: 'stable'
        
    - name: 验证环境配置
      run: |
        echo "📦 Node.js版本: $(node --version)"
        echo "📦 npm版本: $(npm --version)"
        echo "📱 Flutter版本: $(flutter --version | head -1)"
        echo "📱 Dart版本: $(dart --version)"
        
    - name: 安装后端依赖
      run: |
        cd backend
        npm ci
        
    - name: 安装前端依赖
      run: |
        cd frontend
        flutter pub get
        
    - name: 运行后端测试
      run: |
        cd backend
        npm run test:unit
        
    - name: 运行前端测试
      run: |
        cd frontend
        flutter test
        
    - name: 代码质量检查
      run: |
        cd backend
        npm run lint
        npm run type-check
        cd ../frontend
        flutter analyze
        
    - name: 构建检查
      run: |
        cd backend
        npm run build
        cd ../frontend
        flutter build web --no-sound-null-safety
```

#### 本地运行GitHub Actions

```bash
# 运行完整的环境检查工作流
act push -j environment-check

# 运行特定步骤
act push -j environment-check -s STEP_NAME

# 使用特定的Docker镜像
act push -j environment-check --platform ubuntu-latest=catthehacker/ubuntu:act-latest

# 运行并查看详细日志
act push -j environment-check --verbose
```

### 7.2 Pre-commit Hook自动检查脚本

#### 安装和配置pre-commit

```bash
# 安装pre-commit
pip install pre-commit

# 或使用包管理器
# macOS
brew install pre-commit

# Ubuntu/Debian
sudo apt install pre-commit
```

#### 创建pre-commit配置

```yaml
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.4.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-json
      - id: check-merge-conflict
      - id: check-added-large-files
        args: ['--maxkb=1024']

  - repo: local
    hooks:
      - id: environment-check
        name: 环境依赖检查
        entry: scripts/pre-commit-env-check.sh
        language: script
        pass_filenames: false
        always_run: true
        
      - id: backend-lint
        name: 后端代码检查
        entry: bash -c 'cd backend && npm run lint'
        language: system
        files: ^backend/.*\.(js|ts)$
        pass_filenames: false
        
      - id: backend-test
        name: 后端单元测试
        entry: bash -c 'cd backend && npm run test:unit'
        language: system
        files: ^backend/.*\.(js|ts)$
        pass_filenames: false
        
      - id: frontend-analyze
        name: Flutter代码分析
        entry: bash -c 'cd frontend && flutter analyze'
        language: system
        files: ^frontend/.*\.dart$
        pass_filenames: false
        
      - id: frontend-test
        name: Flutter单元测试
        entry: bash -c 'cd frontend && flutter test'
        language: system
        files: ^frontend/.*\.dart$
        pass_filenames: false
```

#### 创建pre-commit环境检查脚本

```bash
# scripts/pre-commit-env-check.sh
#!/bin/bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_info "🔍 Pre-commit环境检查..."

# 检查Node.js版本
if ! command -v node >/dev/null 2>&1; then
    log_error "Node.js未安装或未在PATH中"
    exit 1
fi

NODE_VERSION=$(node --version | sed 's/v//')
REQUIRED_NODE="18.17.0"
if [[ "$(printf '%s\n' "$REQUIRED_NODE" "$NODE_VERSION" | sort -V | head -n1)" != "$REQUIRED_NODE" ]]; then
    log_error "Node.js版本过低: $NODE_VERSION (需要: $REQUIRED_NODE+)"
    exit 1
fi
log_info "✅ Node.js版本: $NODE_VERSION"

# 检查Flutter版本
if ! command -v flutter >/dev/null 2>&1; then
    log_error "Flutter未安装或未在PATH中"
    exit 1
fi

FLUTTER_VERSION=$(flutter --version | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')
REQUIRED_FLUTTER="3.19.0"
if [[ "$(printf '%s\n' "$REQUIRED_FLUTTER" "$FLUTTER_VERSION" | sort -V | head -n1)" != "$REQUIRED_FLUTTER" ]]; then
    log_error "Flutter版本过低: $FLUTTER_VERSION (需要: $REQUIRED_FLUTTER+)"
    exit 1
fi
log_info "✅ Flutter版本: $FLUTTER_VERSION"

# 检查Docker服务
if ! command -v docker >/dev/null 2>&1; then
    log_error "Docker未安装"
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    log_warning "Docker未运行，跳过数据库连接检查"
else
    log_info "✅ Docker服务正常"
    
    # 检查数据库容器
    if docker ps | grep -q ai-nutrition-postgres; then
        log_info "✅ PostgreSQL容器运行中"
    else
        log_warning "PostgreSQL容器未运行"
    fi
    
    if docker ps | grep -q ai-nutrition-redis; then
        log_info "✅ Redis容器运行中"
    else
        log_warning "Redis容器未运行"
    fi
fi

# 检查项目依赖
if [[ -f "backend/package.json" ]]; then
    if [[ ! -d "backend/node_modules" ]]; then
        log_warning "后端依赖未安装，请运行: cd backend && npm install"
    else
        log_info "✅ 后端依赖已安装"
    fi
fi

if [[ -f "frontend/pubspec.yaml" ]]; then
    if [[ ! -d "frontend/.dart_tool" ]]; then
        log_warning "前端依赖未安装，请运行: cd frontend && flutter pub get"
    else
        log_info "✅ 前端依赖已安装"
    fi
fi

log_info "🎉 Pre-commit环境检查完成！"
```

#### 激活pre-commit hooks

```bash
# 安装hooks到本地git仓库
pre-commit install

# 手动运行所有hooks
pre-commit run --all-files

# 运行特定hook
pre-commit run environment-check

# 跳过hooks提交 (紧急情况)
git commit -m "紧急修复" --no-verify
```

### 7.3 环境监控脚本

#### 创建持续监控脚本

```bash
# scripts/monitor-env.sh
#!/bin/bash

MONITOR_LOG="logs/env-monitor.log"
mkdir -p logs

log_with_timestamp() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$MONITOR_LOG"
}

monitor_services() {
    log_with_timestamp "开始环境监控..."
    
    while true; do
        # 检查Docker服务
        if ! docker info >/dev/null 2>&1; then
            log_with_timestamp "❌ Docker服务异常"
        fi
        
        # 检查数据库容器
        if ! docker ps | grep -q ai-nutrition-postgres; then
            log_with_timestamp "❌ PostgreSQL容器未运行"
        fi
        
        if ! docker ps | grep -q ai-nutrition-redis; then
            log_with_timestamp "❌ Redis容器未运行"
        fi
        
        # 检查端口占用
        if ! curl -f http://localhost:3000/health >/dev/null 2>&1; then
            log_with_timestamp "❌ 后端API服务异常"
        fi
        
        # 检查系统资源
        MEMORY_USAGE=$(docker stats --no-stream --format "table {{.Container}}\t{{.MemUsage}}" | grep -E "(postgres|redis)")
        if [[ -n "$MEMORY_USAGE" ]]; then
            log_with_timestamp "📊 内存使用情况: $MEMORY_USAGE"
        fi
        
        # 每5分钟检查一次
        sleep 300
    done
}

# 后台运行监控
monitor_services &
MONITOR_PID=$!

echo "环境监控已启动 (PID: $MONITOR_PID)"
echo "日志文件: $MONITOR_LOG"
echo "停止监控: kill $MONITOR_PID"
```

#### 系统服务配置 (可选)

```bash
# 创建systemd服务 (Linux)
sudo tee /etc/systemd/system/ai-nutrition-env-monitor.service > /dev/null <<EOF
[Unit]
Description=AI营养餐厅环境监控
After=docker.service

[Service]
Type=simple
User=$USER
WorkingDirectory=$PWD
ExecStart=$PWD/scripts/monitor-env.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# 启用并启动服务
sudo systemctl enable ai-nutrition-env-monitor
sudo systemctl start ai-nutrition-env-monitor
sudo systemctl status ai-nutrition-env-monitor
```

### 7.4 IDE集成验证

#### VS Code任务配置

```json
// .vscode/tasks.json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "环境完整检查",
            "type": "shell",
            "command": "./scripts/verify-env.sh",
            "group": {
                "kind": "test",
                "isDefault": true
            },
            "presentation": {
                "reveal": "always",
                "panel": "new"
            },
            "problemMatcher": []
        },
        {
            "label": "启动开发环境",
            "type": "shell",
            "command": "make start",
            "group": "build",
            "dependsOn": "环境完整检查"
        },
        {
            "label": "运行环境监控",
            "type": "shell",
            "command": "./scripts/monitor-env.sh",
            "group": "test",
            "runOptions": {
                "runOn": "folderOpen"
            }
        }
    ]
}
```

#### 自动化检查集成

```bash
# 添加到shell配置文件 (~/.bashrc, ~/.zshrc)
alias env-check='./scripts/verify-env.sh'
alias env-monitor='./scripts/monitor-env.sh'
alias dev-start='make setup && make start'

# 项目目录自动检查 (可选)
if [[ -f "./scripts/verify-env.sh" && "$PWD" == *"ai-nutrition"* ]]; then
    echo "🔍 自动运行环境检查..."
    ./scripts/verify-env.sh --quiet
fi
```

### 📋 开发就绪确认

- [ ] Node.js 18.17.0+ 已安装
- [ ] Flutter 3.19.0+ 已安装并配置
- [ ] Docker Desktop 已安装并运行
- [ ] PostgreSQL + pgvector 容器已启动
- [ ] Redis 容器已启动
- [ ] VS Code 及必需扩展已安装
- [ ] 项目代码已克隆
- [ ] 后端依赖已安装
- [ ] 前端依赖已安装
- [ ] 数据库连接测试通过
- [ ] 后端API健康检查通过
- [ ] Flutter应用可以正常启动
- [ ] 代码格式化和检查工具配置完成

---

**环境设置完成！** 🎉

现在您的开发环境已经准备就绪，可以开始按照 `DEVELOPMENT_WORKFLOW.md` 中的流程进行开发了。