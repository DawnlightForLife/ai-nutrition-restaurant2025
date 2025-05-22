# 脚本系统使用说明

本目录包含智能营养餐厅系统的各类工具脚本，用于数据库初始化、数据迁移、测试数据生成、系统监控等功能。脚本系统按功能模块化组织，提供独立执行和统一入口两种使用方式。

## 目录

- [1. 统一执行入口](#1-统一执行入口)
- [2. 环境配置](#2-环境配置)
- [3. 数据库模块 (db/)](#3-数据库模块-db)
- [4. 数据生成模块 (data/)](#4-数据生成模块-data)
- [5. 用户管理模块 (user/)](#5-用户管理模块-user)
- [6. 系统监控模块 (monitor/)](#6-系统监控模块-monitor)
- [7. 系统检查模块 (check/)](#7-系统检查模块-check)
- [8. 启动脚本模块 (startup/)](#8-启动脚本模块-startup)
- [9. 可视化工具模块 (viz/)](#9-可视化工具模块-viz)

## 1. 统一执行入口

统一执行入口脚本 `runAll.js` 可按需执行部分或全部脚本，适用于开发环境初始化、测试数据准备等场景。

### 使用方式

```bash
# 执行所有脚本（按预设顺序）
node runAll.js

# 仅执行数据库初始化
node runAll.js --init

# 仅生成测试数据
node runAll.js --data

# 仅执行系统检查
node runAll.js --check

# 组合执行
node runAll.js --init --data

# 查看帮助信息
node runAll.js --help
```

### 支持的选项

| 选项 | 说明 | 执行的脚本 |
|------|------|-----------|
| `--init` | 数据库初始化 | initializeDatabase.js, initAdmin.js |
| `--data` | 测试数据生成 | generateSampleData.js, generateMockHealthData.js, initTestUser.js |
| `--check` | 系统检查 | checkAdmin.js, checkMigrationStatus.js |
| `--migrate` | 执行数据迁移 | runMigration.js |
| `--help` | 显示帮助信息 | - |
| `--env <path>` | 指定环境变量文件 | 默认为 .env.local |

## 2. 环境配置

脚本系统使用单独的环境变量文件，与生产环境隔离。

### .env.local 文件

复制 `.env.local.example` 为 `.env.local` 并根据需要修改：

```
# 数据库连接
DB_URI=mongodb://localhost:27017/ai_nutrition_dev
DB_USER=
DB_PASS=

# 测试用户
ADMIN_EMAIL=admin@example.com
ADMIN_PASSWORD=yourpassword

# 数据生成配置
SAMPLE_DATA_SIZE=small  # small|medium|large
```

## 3. 数据库模块 (db/)

数据库模块提供数据库初始化、重置、迁移和模式验证功能。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `initializeDatabase.js` | 初始化数据库集合结构 | `node db/initializeDatabase.js` |
| `resetDatabase.js` | 清空并重置数据库内容（仅开发环境） | `node db/resetDatabase.js` |
| `migrateToSharding.js` | 迁移数据到MongoDB分片结构 | `node db/migrateToSharding.js` |
| `schemaFreezeVerification.js` | 验证模型schema冻结状态 | `node db/schemaFreezeVerification.js` |
| `migration-nutrition-profile-enum.js` | 补全旧档案的enum字段 | `node db/migration-nutrition-profile-enum.js` |
| `directMigration.js` | 低级别结构迁移入口 | `node db/directMigration.js` |
| `runMigration.js` | 正式迁移器主入口 | `node db/runMigration.js` |
| `fixModelFactory.js` | 修复modelFactory引用问题 | `node db/fixModelFactory.js` |

### 常用执行流程

```bash
# 1. 初始化数据库（新环境）
node db/initializeDatabase.js

# 2. 重置开发环境（谨慎使用）
node db/resetDatabase.js

# 3. 执行数据迁移
node db/runMigration.js
```

## 4. 数据生成模块 (data/)

数据生成模块提供系统测试和演示所需的模拟数据。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `generateSampleData.js` | 生成系统通用演示数据 | `node data/generateSampleData.js` |
| `generateMockHealthData.js` | 生成模拟健康和营养数据 | `node data/generateMockHealthData.js` |
| `initTestUser.js` | 创建测试用户账号 | `node data/initTestUser.js` |

### 脚本参数

```bash
# 生成小型数据集（默认）
node data/generateSampleData.js --size=small

# 生成中型数据集
node data/generateSampleData.js --size=medium

# 生成大型数据集
node data/generateSampleData.js --size=large

# 为指定用户生成健康数据
node data/generateMockHealthData.js --user=user_id

# 创建特定角色测试用户
node data/initTestUser.js --role=nutritionist
```

## 5. 用户管理模块 (user/)

用户管理模块负责系统用户初始化和特殊角色设置。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `initAdmin.js` | 初始化系统管理员账号 | `node user/initAdmin.js` |

### 脚本参数

```bash
# 使用默认配置创建管理员
node user/initAdmin.js

# 指定管理员邮箱和密码
node user/initAdmin.js --email=admin@example.com --password=secure123

# 检查并更新现有管理员权限
node user/initAdmin.js --update
```

## 6. 系统监控模块 (monitor/)

系统监控模块提供性能监控、状态查询和问题修复工具。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `monitorShards.js` | 查看各分片节点状态 | `node monitor/monitorShards.js` |
| `queryRegressionEvaluator.js` | 查询性能变更评估 | `node monitor/queryRegressionEvaluator.js` |
| `queryRollback.js` | 查询结构回退 | `node monitor/queryRollback.js` |

### 脚本参数

```bash
# 详细监控分片状态
node monitor/monitorShards.js --verbose

# 对特定集合评估查询性能
node monitor/queryRegressionEvaluator.js --collection=users

# 回退特定查询结构
node monitor/queryRollback.js --query=recent_orders --version=1.2
```

## 7. 系统检查模块 (check/)

系统检查模块提供各类系统状态和配置检查工具。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `checkAdmin.js` | 检查管理员是否存在 | `node check/checkAdmin.js` |
| `check_model_imports.js` | 校验模型引用情况 | `node check/check_model_imports.js` |
| `checkMigrationStatus.js` | 校验迁移执行状态 | `node check/checkMigrationStatus.js` |

### 使用示例

```bash
# 检查管理员并报告详细信息
node check/checkAdmin.js --detail

# 校验所有模型引用
node check/check_model_imports.js

# 检查特定迁移版本状态
node check/checkMigrationStatus.js --version=1.2.5
```

## 8. 启动脚本模块 (startup/)

启动脚本模块提供系统启动前检查和环境准备脚本。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `startup_check.js` | 启动前检查（已弃用） | `node startup/startup_check.js` |
| `docker_startup.sh` | Docker环境启动前准备 | `bash startup/docker_startup.sh` |
| `deploy-with-query-eval.sh` | 部署启动脚本 | `bash startup/deploy-with-query-eval.sh` |

### 使用注意事项

```bash
# Docker启动（开发环境）
bash startup/docker_startup.sh dev

# Docker启动（生产环境）
bash startup/docker_startup.sh prod

# 部署并执行查询评估
bash startup/deploy-with-query-eval.sh
```

## 9. 可视化工具模块 (viz/)

可视化工具模块为开发人员提供数据模型和系统结构可视化工具。

### 可用脚本

| 脚本 | 说明 | 使用方式 |
|------|------|---------|
| `schemaVisualization.js` | 生成schema可视化HTML | `node viz/schemaVisualization.js` |
| `schemaToMarkdown.js` | 生成schema文档 | `node viz/schemaToMarkdown.js` |

### 使用示例

```bash
# 生成全部模型的可视化
node viz/schemaVisualization.js --output=./docs/schema.html

# 仅生成特定模型的可视化
node viz/schemaVisualization.js --models=User,Nutrition,Order

# 生成Markdown文档
node viz/schemaToMarkdown.js --output=./docs/models.md
```

## 最佳实践

1. **开发环境初始化**：新环境设置时，推荐使用统一入口执行初始化脚本
   ```bash
   node runAll.js --init --data
   ```

2. **定期检查**：部署前或维护时，执行系统检查
   ```bash
   node runAll.js --check
   ```

3. **数据库迁移**：版本更新时，执行数据迁移
   ```bash
   node db/runMigration.js
   ```

4. **测试数据刷新**：需要刷新测试数据时，使用数据生成模块
   ```bash
   node runAll.js --data
   ```

---

**注意**：脚本执行可能会修改数据库内容，请确保在适当的环境中使用正确的配置。所有脚本都支持 `--help` 参数以显示详细的使用说明。
