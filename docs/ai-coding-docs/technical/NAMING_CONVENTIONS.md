# AI智能营养餐厅系统 - 命名规范标准

## 📋 概述

本文档定义AI智能营养餐厅系统V3的统一命名规范，确保代码库的一致性和可维护性。

**版本**: v1.0  
**适用范围**: 后端NestJS + TypeORM, 前端Flutter, 数据库PostgreSQL  
**最后更新**: 2025年1月  

---

## 🎯 核心原则

### 1. 一致性原则
- 在同一项目/模块内保持命名风格一致
- TypeScript代码统一使用camelCase
- 数据库字段统一使用camelCase（TypeORM转换）
- 枚举值统一使用UPPER_SNAKE_CASE

### 2. 语义化原则
- 名称应清楚表达用途和含义
- 避免缩写，使用完整的英文单词
- 布尔值使用is/has/can前缀

### 3. 国际化原则
- 所有标识符使用英文
- 注释和文档支持中英文
- 用户界面文案通过i18n处理

---

## 💾 数据库命名规范

### 表名规范
```sql
-- ✅ 正确示例
users                    -- 复数形式，全小写
nutrition_profiles       -- 多单词用下划线连接
order_items             -- 关联表用下划线

-- ❌ 错误示例  
User                    -- 不要用大写
user_table             -- 不要用table后缀
nutritionProfiles      -- 不要用camelCase
```

### 字段名规范
```sql
-- ✅ 正确示例（TypeORM映射后的实际数据库列名）
id                     -- 主键统一用id
user_id               -- 外键：表名_id
created_at            -- 时间戳：动词_at
updated_at            -- 
phone                 -- 单词字段用camelCase映射
nickname              -- 
profile_level         -- 枚举字段
is_complete          -- 布尔字段：is_开头

-- ❌ 错误示例
ID                    -- 不要全大写
userId               -- TypeORM实体中使用，但数据库实际是user_id
createdAt            -- TypeORM实体中使用，但数据库实际是created_at
phone_number         -- 简化为phone
nick_name           -- 简化为nickname
```

### 索引命名规范
```sql
-- ✅ 正确示例
idx_users_phone              -- idx_表名_字段名
idx_orders_user_status_date  -- 组合索引：idx_表名_字段1_字段2_字段3
uk_users_email              -- 唯一索引：uk_表名_字段名
fk_orders_user_id           -- 外键：fk_表名_字段名

-- ❌ 错误示例
index_1                     -- 无意义名称
users_phone_idx            -- 格式不统一
```

---

## 🔧 TypeORM实体命名规范

### 实体类命名
```typescript
// ✅ 正确示例
export class User { }              -- PascalCase，单数形式
export class NutritionProfile { }  -- 多单词用PascalCase
export class OrderItem { }         -- 关联实体用PascalCase

// ❌ 错误示例
export class Users { }             -- 不要用复数
export class user { }              -- 不要用小写
export class nutritionProfile { }  -- 不要用camelCase开头
```

### 实体属性命名
```typescript
// ✅ 正确示例
@Entity('users')  // 数据库表名
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;                      // 主键统一用id

  @Column({ name: 'user_id' })      // 明确指定数据库列名
  userId: string;                   // TypeScript属性用camelCase

  @Column()
  phone: string;                    // 简单字段，camelCase

  @Column()
  nickname: string;                 // 单词组合，camelCase

  @CreateDateColumn()
  createdAt: Date;                  // 时间戳，camelCase

  @Column({ type: 'boolean' })
  isActive: boolean;                // 布尔值，is前缀

  @Column({ type: 'boolean' })
  hasPermission: boolean;           // 布尔值，has前缀

  // 关联关系
  @OneToMany(() => Order, order => order.user)
  orders: Order[];                  // 一对多关系，复数形式

  @ManyToOne(() => Company, company => company.users)
  @JoinColumn({ name: 'company_id' }) // 明确指定外键列名
  company: Company;                 // 多对一关系，单数形式
}

// ❌ 错误示例
export class User {
  @Column()
  Phone: string;                    // 不要用PascalCase

  @Column()
  nick_name: string;               // 不要用snake_case

  @Column()
  active: boolean;                 // 布尔值要用is前缀

  @Column()
  user_id: string;                 // TypeScript属性应该是camelCase
}
```

### 枚举命名规范
```typescript
// ✅ 正确示例
export enum UserStatus {
  ACTIVE = 'active',              // 枚举key用UPPER_SNAKE_CASE
  INACTIVE = 'inactive',          // 枚举value用lower_snake_case
  SUSPENDED = 'suspended',
  DELETED = 'deleted'
}

export enum OrderStatus {
  PENDING_PAYMENT = 'pending_payment',
  PAID = 'paid',
  CONFIRMED = 'confirmed',
  PREPARING = 'preparing',
  READY_FOR_PICKUP = 'ready_for_pickup',
  DELIVERING = 'delivering',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
  REFUNDED = 'refunded'
}

// ❌ 错误示例
export enum UserStatus {
  active = 'active',              // key不要用小写
  Inactive = 'inactive',          // key不要用PascalCase
  ACTIVE = 'ACTIVE',             // value不要用大写
  PENDING = 'pendingStatus'      // value保持简洁
}
```

---

## 🏗️ NestJS代码命名规范

### 文件命名
```typescript
// ✅ 正确示例
user.entity.ts                   // 实体文件
user.dto.ts                     // DTO文件
user.service.ts                 // 服务文件
user.controller.ts              // 控制器文件
user.module.ts                  // 模块文件
auth.guard.ts                   // 守卫文件
jwt.strategy.ts                 // 策略文件

nutrition-profile.entity.ts     // 多单词用连字符
nutrition-profile.service.ts
nutrition-profile.controller.ts

// ❌ 错误示例
User.entity.ts                  // 不要用PascalCase
userEntity.ts                   // 不要省略后缀
user_entity.ts                  // 不要用下划线
```

### 类和接口命名
```typescript
// ✅ 正确示例
export class UserService { }           // 服务类：名词+Service
export class UserController { }        // 控制器：名词+Controller
export class CreateUserDto { }         // DTO：动词+名词+Dto
export class UpdateUserDto { }
export class UserResponseDto { }       // 响应DTO：名词+ResponseDto

export interface UserInterface { }     // 接口：名词+Interface
export interface PaymentConfig { }     // 配置接口：名词+Config

// ❌ 错误示例
export class userService { }           // 不要用camelCase开头
export class User_Service { }          // 不要用下划线
export class IUser { }                 // 不要用I前缀
```

### 方法命名
```typescript
// ✅ 正确示例
class UserService {
  // CRUD操作
  async createUser(dto: CreateUserDto): Promise<User> { }
  async findUserById(id: string): Promise<User> { }
  async findAllUsers(): Promise<User[]> { }
  async updateUser(id: string, dto: UpdateUserDto): Promise<User> { }
  async deleteUser(id: string): Promise<void> { }

  // 业务方法
  async verifyUserPassword(user: User, password: string): Promise<boolean> { }
  async generateAccessToken(user: User): Promise<string> { }
  async sendVerificationEmail(user: User): Promise<void> { }

  // 查询方法
  async getUsersByStatus(status: UserStatus): Promise<User[]> { }
  async searchUsersByKeyword(keyword: string): Promise<User[]> { }

  // 检查方法
  async isUserActive(userId: string): Promise<boolean> { }
  async hasUserPermission(userId: string, permission: string): Promise<boolean> { }
  async canUserAccess(userId: string, resourceId: string): Promise<boolean> { }
}

// ❌ 错误示例
class UserService {
  async CreateUser() { }              // 不要用PascalCase
  async create_user() { }             // 不要用snake_case
  async user() { }                    // 方法名要有动词
  async getUserName() { }             // 应该是getUser().name或findUserById()
}
```

### 控制器路由命名
```typescript
// ✅ 正确示例
@Controller('api/v1/users')           // 控制器路径：复数形式
export class UserController {
  @Get()                              // GET /api/v1/users
  async findAll() { }

  @Get(':id')                         // GET /api/v1/users/:id
  async findOne(@Param('id') id: string) { }

  @Post()                             // POST /api/v1/users
  async create(@Body() dto: CreateUserDto) { }

  @Put(':id')                         // PUT /api/v1/users/:id
  async update(@Param('id') id: string, @Body() dto: UpdateUserDto) { }

  @Delete(':id')                      // DELETE /api/v1/users/:id
  async remove(@Param('id') id: string) { }

  // 特殊业务端点
  @Post(':id/verify-email')           // POST /api/v1/users/:id/verify-email
  async verifyEmail(@Param('id') id: string) { }

  @Post('register')                   // POST /api/v1/users/register
  async register(@Body() dto: RegisterDto) { }

  @Post('login')                      // POST /api/v1/users/login
  async login(@Body() dto: LoginDto) { }
}

// ❌ 错误示例
@Controller('user')                   // 应该用复数
@Controller('api/v1/User')           // 不要用PascalCase
export class UserController {
  @Get('getUserList')                 // 应该用RESTful风格
  async getUserList() { }

  @Post('createNewUser')              // 应该用RESTful风格
  async createNewUser() { }
}
```

---

## 📱 Flutter命名规范

### 文件命名
```dart
// ✅ 正确示例
user_profile.dart               // 页面文件：下划线命名
user_profile_page.dart          // 页面：名词+_page
user_profile_widget.dart        // 组件：名词+_widget
user_service.dart              // 服务：名词+_service
user_model.dart                // 模型：名词+_model
app_colors.dart                // 常量：名词+类型
app_strings.dart
api_endpoints.dart

// ❌ 错误示例
UserProfile.dart               // 不要用PascalCase
userProfile.dart               // 不要用camelCase
user-profile.dart              // 不要用连字符
```

### 类命名
```dart
// ✅ 正确示例
class UserProfilePage extends StatefulWidget { }     // 页面：PascalCase
class UserProfileWidget extends StatelessWidget { }   // 组件：PascalCase
class UserService { }                                 // 服务：PascalCase
class UserModel { }                                   // 模型：PascalCase

// ❌ 错误示例
class userProfilePage { }                             // 不要用camelCase
class User_Profile_Page { }                           // 不要用下划线
```

### 变量和方法命名
```dart
// ✅ 正确示例
class UserService {
  // 变量：camelCase
  String userName;
  bool isLoggedIn;
  List<User> userList;
  
  // 方法：camelCase，动词开头
  Future<User> fetchUserProfile() async { }
  void updateUserProfile(User user) { }
  bool isUserValid(User user) { }
  
  // 私有成员：下划线开头
  String _apiToken;
  void _validateUser() { }
}

// ❌ 错误示例
class UserService {
  String UserName;                    // 不要用PascalCase
  bool is_logged_in;                 // 不要用snake_case
  List<User> user_list;              // 不要用snake_case
  
  Future<User> FetchUserProfile() { } // 不要用PascalCase
  void fetch_user_profile() { }       // 不要用snake_case
}
```

---

## 🔧 配置文件命名规范

### 环境变量命名
```bash
# ✅ 正确示例
NODE_ENV=development                  # 全大写，下划线分隔
DATABASE_HOST=localhost               # 清晰的层级结构
DATABASE_PORT=5432
DATABASE_NAME=ai_nutrition_restaurant

JWT_ACCESS_SECRET=your_secret_key
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_SECRET=your_refresh_key
JWT_REFRESH_EXPIRES_IN=7d

REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

DEEPSEEK_API_KEY=sk-xxxxx
DEEPSEEK_BASE_URL=https://api.deepseek.com
DEEPSEEK_MODEL=deepseek-chat

# ❌ 错误示例
nodeEnv=development                   # 不要用camelCase
database-host=localhost              # 不要用连字符
Database_Host=localhost              # 不要混合大小写
```

### JSON配置文件
```json
// ✅ 正确示例 - package.json
{
  "name": "ai-nutrition-restaurant-backend",    // kebab-case for npm packages
  "version": "1.0.0",
  "scripts": {
    "start": "node dist/main",                  // kebab-case for npm scripts
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\"",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json"
  }
}
```

---

## 📝 API响应命名规范

### 成功响应结构
```typescript
// ✅ 正确示例
interface ApiResponse<T> {
  success: boolean;                   // 操作是否成功
  data?: T;                          // 返回数据，camelCase
  message: string;                   // 响应消息
  timestamp: string;                 // 时间戳
  requestId?: string;                // 请求ID（可选）
}

interface PaginatedResponse<T> {
  success: boolean;
  data: {
    items: T[];                      // 列表数据
    totalCount: number;              // 总数量
    pageSize: number;                // 页大小
    currentPage: number;             // 当前页
    totalPages: number;              // 总页数
    hasNextPage: boolean;            // 是否有下一页
    hasPrevPage: boolean;            // 是否有上一页
  };
  message: string;
  timestamp: string;
}

// ❌ 错误示例
interface ApiResponse<T> {
  Success: boolean;                   // 不要用PascalCase
  Data: T;                           // 不要用PascalCase
  msg: string;                       // 不要缩写
  created_at: string;                // 不要用snake_case
}
```

### 错误响应结构
```typescript
// ✅ 正确示例
interface ErrorResponse {
  success: false;
  error: {
    code: string;                    // 错误代码
    message: string | string[];      // 错误消息
    details?: any;                   // 详细信息（可选）
  };
  timestamp: string;
  path: string;                      // 请求路径
  method: string;                    // 请求方法
  requestId?: string;
}

// 错误代码命名规范
enum ErrorCode {
  VALIDATION_ERROR = 'VALIDATION_ERROR',           // 验证错误
  AUTHENTICATION_FAILED = 'AUTHENTICATION_FAILED', // 认证失败
  AUTHORIZATION_DENIED = 'AUTHORIZATION_DENIED',   // 授权被拒
  RESOURCE_NOT_FOUND = 'RESOURCE_NOT_FOUND',       // 资源未找到
  DUPLICATE_RESOURCE = 'DUPLICATE_RESOURCE',       // 资源重复
  INTERNAL_SERVER_ERROR = 'INTERNAL_SERVER_ERROR', // 服务器内部错误
  EXTERNAL_SERVICE_ERROR = 'EXTERNAL_SERVICE_ERROR' // 外部服务错误
}
```

---

## 🧪 测试文件命名规范

### 测试文件命名
```typescript
// ✅ 正确示例
user.service.spec.ts             // 单元测试：原文件名+.spec.ts
user.controller.spec.ts
user.e2e-spec.ts                 // E2E测试：原文件名+.e2e-spec.ts
auth.integration.spec.ts         // 集成测试：原文件名+.integration.spec.ts

// ❌ 错误示例
user.test.ts                     // 不要用.test.ts
user-spec.ts                     // 不要省略.service等标识
UserService.spec.ts              // 不要用PascalCase
```

### 测试用例命名
```typescript
// ✅ 正确示例
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user successfully with valid data', async () => { });
    it('should throw validation error when email is invalid', async () => { });
    it('should throw conflict error when user already exists', async () => { });
  });

  describe('findUserById', () => {
    it('should return user when id exists', async () => { });
    it('should throw not found error when id does not exist', async () => { });
    it('should throw validation error when id is invalid format', async () => { });
  });
});

// ❌ 错误示例
describe('UserService', () => {
  it('test1', () => { });                    // 描述不清楚
  it('createUser', () => { });               // 缺少should和期望结果
  it('should work', () => { });              // 太模糊
});
```

---

## 📂 目录结构命名规范

### 后端目录结构
```
src/
├── common/                    # 公共模块：小写，描述性名称
│   ├── decorators/           # 装饰器
│   ├── filters/              # 过滤器
│   ├── guards/               # 守卫
│   ├── interceptors/         # 拦截器
│   └── pipes/                # 管道
├── config/                   # 配置：小写
├── database/                 # 数据库：小写
│   ├── entities/             # 实体：复数形式
│   ├── migrations/           # 迁移：复数形式
│   └── seeds/                # 种子数据：复数形式
├── modules/                  # 业务模块：复数形式
│   ├── auth/                 # 认证模块：小写
│   ├── users/                # 用户模块：复数形式
│   ├── nutrition/            # 营养模块：单数形式（概念性）
│   └── restaurants/          # 餐厅模块：复数形式
└── utils/                    # 工具函数：复数形式
```

### 前端目录结构
```
lib/
├── core/                     # 核心功能：小写
│   ├── constants/            # 常量：复数形式
│   ├── themes/               # 主题：复数形式
│   └── utils/                # 工具：复数形式
├── features/                 # 功能模块：复数形式
│   ├── auth/                 # 认证：小写
│   ├── profile/              # 用户档案：单数形式
│   └── nutrition/            # 营养：单数形式
├── shared/                   # 共享组件：小写
│   ├── widgets/              # 组件：复数形式
│   ├── models/               # 模型：复数形式
│   └── services/             # 服务：复数形式
└── main.dart                 # 入口文件
```

---

## ✅ 检查清单

### 代码提交前检查
- [ ] 所有TypeScript变量和方法使用camelCase
- [ ] 所有类名使用PascalCase
- [ ] 所有枚举值使用UPPER_SNAKE_CASE
- [ ] 数据库表名使用小写复数形式
- [ ] 实体属性明确指定数据库列名映射
- [ ] 布尔值字段使用is/has/can前缀
- [ ] API路径使用kebab-case
- [ ] 文件名符合对应语言的规范
- [ ] 环境变量使用UPPER_SNAKE_CASE

### 文档更新检查
- [ ] 新增字段在DATA_MODEL_DESIGN.md中有记录
- [ ] API变更在相关文档中更新
- [ ] 数据库迁移文件命名正确
- [ ] 测试文件覆盖新功能

---

## 🔄 迁移指南

### 现有代码修复
1. **数据库字段映射修复**
   ```typescript
   // 修复前
   @Column()
   profile_level: string;
   
   // 修复后
   @Column({ name: 'profile_level' })  // 明确指定数据库列名
   profileLevel: string;                // TypeScript属性用camelCase
   ```

2. **枚举值统一**
   ```typescript
   // 修复前
   export enum UserStatus {
     active = 'active',
     inactive = 'inactive'
   }
   
   // 修复后
   export enum UserStatus {
     ACTIVE = 'active',
     INACTIVE = 'inactive'
   }
   ```

3. **布尔字段重命名**
   ```typescript
   // 修复前
   @Column()
   complete: boolean;
   
   // 修复后
   @Column()
   isComplete: boolean;
   ```

---

**文档维护**: 技术架构师  
**执行责任**: 全体开发团队  
**最后更新**: 2025年1月  
**下次review**: 每个sprint结束后review遵守情况