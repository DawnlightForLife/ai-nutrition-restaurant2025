# AI智能营养餐厅系统 - 测试策略指南

> **文档版本**: 1.0.0  
> **创建日期**: 2025-07-13  
> **更新日期**: 2025-07-13  
> **文档状态**: ✅ 开发就绪  
> **目标受众**: 开发团队、QA工程师、AI编码工具

## 📋 目录

- [1. 测试策略概述](#1-测试策略概述)
- [2. 测试金字塔架构](#2-测试金字塔架构)
- [3. 单元测试规范](#3-单元测试规范)
- [4. 集成测试策略](#4-集成测试策略)
- [5. 端到端测试](#5-端到端测试)
- [6. API测试框架](#6-api测试框架)
- [7. 前端测试策略](#7-前端测试策略)
- [8. AI功能测试](#8-ai功能测试)
- [8.1 AI图片识别测试](#81-ai图片识别测试)
- [8.2 库存管理测试](#82-库存管理测试)
- [8.3 用户行为分析测试](#83-用户行为分析测试)
- [8.4 营养师咨询测试](#84-营养师咨询测试)
- [9. 性能测试](#9-性能测试)
- [10. 安全测试](#10-安全测试)

---

## 1. 测试策略概述

### 1.1 测试目标

```yaml
质量目标:
  - 代码覆盖率: ≥85%
  - 缺陷逃逸率: <2%
  - 自动化覆盖率: ≥90%
  - 测试执行时间: <15分钟 (单元+集成)
  - 端到端测试: <30分钟

可靠性目标:
  - 系统可用性: 99.5%
  - 平均故障恢复时间: <30分钟
  - API响应时间: <200ms (P95)
  - 前端页面加载: <2秒

技术栈:
  后端测试:
    - Jest: 26.6.3+ (单元测试)
    - Supertest: API集成测试
    - Test Containers: 数据库测试
    - Artillery: 性能测试
    
  前端测试:
    - Flutter Test: 单元测试
    - Integration Test: 集成测试
    - Golden Test: UI回归测试
    - Mockito: 模拟依赖
```

### 1.2 测试环境策略

```yaml
环境配置:
  开发环境 (dev):
    - 用途: 开发者本地测试
    - 数据: 模拟数据
    - 服务: Docker Compose
    - 更新频率: 实时
    
  测试环境 (test):
    - 用途: 自动化测试
    - 数据: 测试数据集
    - 服务: Kubernetes
    - 更新频率: 每次提交
    
  预发布环境 (staging):
    - 用途: 用户验收测试
    - 数据: 脱敏生产数据
    - 服务: 生产级配置
    - 更新频率: 每次发布前
    
  生产环境 (prod):
    - 用途: 生产服务
    - 数据: 真实数据
    - 服务: 高可用配置
    - 监控: 全面监控

数据管理:
  测试数据策略:
    - 数据隔离: 每个测试独立数据
    - 数据清理: 测试后自动清理
    - 数据版本: 与代码版本同步
    - 敏感数据: 脱敏处理
```

---

## 2. 测试金字塔架构

### 2.1 测试层次分布

```yaml
测试金字塔 (目标比例):
  单元测试: 70%
    - 数量: ~2000个
    - 执行时间: <5分钟
    - 覆盖率要求: ≥90%
    - 重点: 业务逻辑、工具函数
    
  集成测试: 20%
    - 数量: ~400个
    - 执行时间: <10分钟
    - 覆盖率要求: ≥80%
    - 重点: API接口、数据库操作
    
  端到端测试: 10%
    - 数量: ~100个
    - 执行时间: <30分钟
    - 覆盖率要求: 核心用户路径
    - 重点: 关键业务流程

测试类型细分:
  单元测试:
    - Service层业务逻辑: 40%
    - Utils工具函数: 15%
    - Model数据模型: 10%
    - Component组件: 25%
    
  集成测试:
    - API接口测试: 60%
    - 数据库集成: 25%
    - 第三方服务: 15%
    
  端到端测试:
    - 用户注册登录: 20%
    - 点餐下单流程: 30%
    - 商家管理: 25%
    - AI推荐系统: 25%
```

### 2.2 测试执行策略

```yaml
测试触发时机:
  开发阶段:
    - 代码提交: 单元测试 + Lint
    - PR创建: 单元测试 + 集成测试
    - 代码合并: 全量测试 + 部署测试环境
    
  发布阶段:
    - 预发布: 端到端测试 + 性能测试
    - 生产发布: 冒烟测试 + 监控检查
    - 发布后: 回归测试 + 用户验收测试
    
  定时任务:
    - 每日凌晨: 完整回归测试
    - 每周末: 性能基准测试
    - 每月: 安全测试扫描

并行执行策略:
  - 单元测试: 按模块并行 (8个Worker)
  - 集成测试: 按服务并行 (4个Worker)
  - 端到端测试: 按用户路径并行 (2个Worker)
  - 数据库测试: 独立数据库实例
```

---

## 3. 单元测试规范

### 3.1 NestJS后端单元测试

```typescript
// 测试文件命名: *.service.spec.ts, *.controller.spec.ts
// 示例: UserService单元测试

import { Test, TestingModule } from '@nestjs/testing';
import { UserService } from './user.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';

describe('UserService', () => {
  let service: UserService;
  let repository: Repository<User>;

  // Mock Repository
  const mockRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
    save: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
    create: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: getRepositoryToken(User),
          useValue: mockRepository,
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    repository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('创建用户', () => {
    const createUserDto = {
      phone: '13800138000',
      nickname: '测试用户',
      email: 'test@example.com',
    };

    it('应该成功创建用户', async () => {
      // Arrange
      const expectedUser = { id: 'uuid', ...createUserDto };
      mockRepository.findOne.mockResolvedValue(null);
      mockRepository.create.mockReturnValue(expectedUser);
      mockRepository.save.mockResolvedValue(expectedUser);

      // Act
      const result = await service.create(createUserDto);

      // Assert
      expect(repository.findOne).toHaveBeenCalledWith({
        where: { phone: createUserDto.phone }
      });
      expect(repository.create).toHaveBeenCalledWith(createUserDto);
      expect(repository.save).toHaveBeenCalledWith(expectedUser);
      expect(result).toEqual(expectedUser);
    });

    it('当手机号已存在时应该抛出冲突异常', async () => {
      // Arrange
      mockRepository.findOne.mockResolvedValue({ id: 'existing-user' });

      // Act & Assert
      await expect(service.create(createUserDto))
        .rejects
        .toThrow(ConflictException);
    });
  });

  describe('查询用户', () => {
    it('应该返回用户信息', async () => {
      // Arrange
      const userId = 'user-id';
      const expectedUser = { id: userId, nickname: '测试用户' };
      mockRepository.findOne.mockResolvedValue(expectedUser);

      // Act
      const result = await service.findById(userId);

      // Assert
      expect(repository.findOne).toHaveBeenCalledWith({
        where: { id: userId }
      });
      expect(result).toEqual(expectedUser);
    });

    it('当用户不存在时应该抛出未找到异常', async () => {
      // Arrange
      mockRepository.findOne.mockResolvedValue(null);

      // Act & Assert
      await expect(service.findById('non-existent'))
        .rejects
        .toThrow(NotFoundException);
    });
  });
});
```

### 3.2 测试配置文件

```typescript
// jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/main.ts',
    '!src/**/*.interface.ts',
    '!src/**/*.dto.ts',
    '!src/**/*.entity.ts',
    '!src/**/*.module.ts',
  ],
  coverageThreshold: {
    global: {
      branches: 85,
      functions: 85,
      lines: 85,
      statements: 85,
    },
  },
  setupFilesAfterEnv: ['<rootDir>/src/test/setup.ts'],
  testTimeout: 10000,
};

// src/test/setup.ts - 测试环境设置
import { ConfigModule } from '@nestjs/config';

// Mock环境变量
process.env.NODE_ENV = 'test';
process.env.DATABASE_URL = 'postgresql://test:test@localhost:5432/test_db';
process.env.REDIS_URL = 'redis://localhost:6379/1';
process.env.JWT_SECRET = 'test-secret';

// 全局测试配置
beforeAll(async () => {
  // 测试前的全局设置
});

afterAll(async () => {
  // 测试后的清理工作
});
```

### 3.3 Flutter前端单元测试

```dart
// test/services/user_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ai_nutrition_app/services/user_service.dart';
import 'package:ai_nutrition_app/models/user.dart';
import 'package:ai_nutrition_app/data/repositories/user_repository.dart';

@GenerateMocks([UserRepository])
import 'user_service_test.mocks.dart';

void main() {
  late UserService userService;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    userService = UserService(mockRepository);
  });

  group('UserService', () {
    group('getUserProfile', () => {
      test('应该返回用户档案', () async {
        // Arrange
        const userId = 'user-123';
        final expectedUser = User(
          id: userId,
          nickname: '测试用户',
          phone: '13800138000',
        );
        
        when(mockRepository.getUserById(userId))
            .thenAnswer((_) async => expectedUser);

        // Act
        final result = await userService.getUserProfile(userId);

        // Assert
        expect(result, equals(expectedUser));
        verify(mockRepository.getUserById(userId)).called(1);
      });

      test('当用户不存在时应该抛出异常', () async {
        // Arrange
        const userId = 'non-existent';
        when(mockRepository.getUserById(userId))
            .thenThrow(UserNotFoundException());

        // Act & Assert
        expect(
          () => userService.getUserProfile(userId),
          throwsA(isA<UserNotFoundException>()),
        );
      });
    });

    group('updateUserProfile', () => {
      test('应该成功更新用户档案', () async {
        // Arrange
        final updateData = UserUpdateData(nickname: '新昵称');
        final updatedUser = User(
          id: 'user-123',
          nickname: '新昵称',
          phone: '13800138000',
        );

        when(mockRepository.updateUser(any, any))
            .thenAnswer((_) async => updatedUser);

        // Act
        final result = await userService.updateUserProfile('user-123', updateData);

        // Assert
        expect(result.nickname, equals('新昵称'));
        verify(mockRepository.updateUser('user-123', updateData)).called(1);
      });
    });
  });
}
```

---

## 4. 集成测试策略

### 4.1 API集成测试

```typescript
// test/integration/user.controller.e2e-spec.ts
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../src/user/entities/user.entity';

describe('UserController (e2e)', () => {
  let app: INestApplication;
  let userRepository: Repository<User>;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [
        AppModule,
        // 使用测试数据库
        TypeOrmModule.forRoot({
          type: 'postgres',
          host: 'localhost',
          port: 5432,
          username: 'test',
          password: 'test',
          database: 'test_ai_nutrition',
          entities: [User],
          synchronize: true,
        }),
      ],
    }).compile();

    app = moduleFixture.createNestApplication();
    userRepository = moduleFixture.get('UserRepository');
    await app.init();
  });

  beforeEach(async () => {
    // 清理测试数据
    await userRepository.clear();
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/users (POST)', () => {
    it('应该创建新用户', () => {
      const createUserDto = {
        phone: '13800138000',
        nickname: '测试用户',
        email: 'test@example.com',
      };

      return request(app.getHttpServer())
        .post('/users')
        .send(createUserDto)
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('id');
          expect(res.body.phone).toBe(createUserDto.phone);
          expect(res.body.nickname).toBe(createUserDto.nickname);
        });
    });

    it('当手机号已存在时应该返回409冲突', async () => {
      // 先创建一个用户
      await userRepository.save({
        phone: '13800138000',
        nickname: '已存在用户',
      });

      const createUserDto = {
        phone: '13800138000',
        nickname: '新用户',
      };

      return request(app.getHttpServer())
        .post('/users')
        .send(createUserDto)
        .expect(409)
        .expect((res) => {
          expect(res.body.message).toContain('手机号已存在');
        });
    });
  });

  describe('/users/:id (GET)', () => {
    it('应该返回用户信息', async () => {
      // 准备测试数据
      const user = await userRepository.save({
        phone: '13800138000',
        nickname: '测试用户',
      });

      return request(app.getHttpServer())
        .get(`/users/${user.id}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.id).toBe(user.id);
          expect(res.body.nickname).toBe('测试用户');
        });
    });

    it('当用户不存在时应该返回404', () => {
      return request(app.getHttpServer())
        .get('/users/non-existent-id')
        .expect(404);
    });
  });
});
```

### 4.2 数据库集成测试

```typescript
// test/integration/database.integration.spec.ts
import { Test } from '@nestjs/testing';
import { TypeOrmModule, getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../src/user/entities/user.entity';
import { NutritionProfile } from '../src/nutrition/entities/nutrition-profile.entity';

describe('数据库集成测试', () => {
  let userRepository: Repository<User>;
  let nutritionRepository: Repository<NutritionProfile>;
  let module: TestingModule;

  beforeAll(async () => {
    module = await Test.createTestingModule({
      imports: [
        TypeOrmModule.forRoot({
          type: 'postgres',
          host: 'localhost',
          port: 5432,
          username: 'test',
          password: 'test',
          database: 'test_integration',
          entities: [User, NutritionProfile],
          synchronize: true,
        }),
        TypeOrmModule.forFeature([User, NutritionProfile]),
      ],
    }).compile();

    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
    nutritionRepository = module.get<Repository<NutritionProfile>>(
      getRepositoryToken(NutritionProfile)
    );
  });

  afterAll(async () => {
    await module.close();
  });

  beforeEach(async () => {
    // 清理测试数据
    await nutritionRepository.clear();
    await userRepository.clear();
  });

  describe('用户与营养档案关联', () => {
    it('应该正确创建用户和营养档案的关联关系', async () => {
      // 创建用户
      const user = await userRepository.save({
        phone: '13800138000',
        nickname: '测试用户',
      });

      // 创建营养档案
      const profile = await nutritionRepository.save({
        userId: user.id,
        name: '基础档案',
        level: 'basic',
        basicInfo: {
          age: 25,
          gender: 'male',
          height: 175,
          weight: 70,
          activityLevel: 'moderately_active',
          goal: 'maintain_weight',
        },
      });

      // 验证关联关系
      const userWithProfile = await userRepository.findOne({
        where: { id: user.id },
        relations: ['nutritionProfiles'],
      });

      expect(userWithProfile.nutritionProfiles).toHaveLength(1);
      expect(userWithProfile.nutritionProfiles[0].id).toBe(profile.id);
    });

    it('应该支持级联删除', async () => {
      // 创建用户和档案
      const user = await userRepository.save({
        phone: '13800138000',
        nickname: '测试用户',
      });

      await nutritionRepository.save({
        userId: user.id,
        name: '基础档案',
        level: 'basic',
        basicInfo: {
          age: 25,
          gender: 'male',
          height: 175,
          weight: 70,
          activityLevel: 'moderately_active',
          goal: 'maintain_weight',
        },
      });

      // 删除用户
      await userRepository.softDelete(user.id);

      // 验证档案也被软删除
      const profiles = await nutritionRepository.find({
        where: { userId: user.id },
        withDeleted: true,
      });

      expect(profiles).toHaveLength(1);
      expect(profiles[0].deletedAt).not.toBeNull();
    });
  });
});
```

---

## 5. 端到端测试

### 5.1 Flutter E2E测试

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ai_nutrition_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('用户注册登录流程', () {
    testWidgets('完整的用户注册流程', (WidgetTester tester) async {
      // 启动应用
      app.main();
      await tester.pumpAndSettle();

      // 1. 进入登录页面
      expect(find.text('智能营养餐厅'), findsOneWidget);
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 2. 点击注册
      await tester.tap(find.text('立即注册'));
      await tester.pumpAndSettle();

      // 3. 填写注册信息
      await tester.enterText(
        find.byKey(Key('phone_input')), 
        '13800138000'
      );
      await tester.enterText(
        find.byKey(Key('nickname_input')), 
        '测试用户'
      );

      // 4. 获取验证码
      await tester.tap(find.byKey(Key('get_code_button')));
      await tester.pumpAndSettle();

      // 5. 输入验证码 (测试环境使用固定验证码)
      await tester.enterText(
        find.byKey(Key('code_input')), 
        '123456'
      );

      // 6. 提交注册
      await tester.tap(find.byKey(Key('register_button')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // 7. 验证注册成功，跳转到首页
      expect(find.text('欢迎使用'), findsOneWidget);
      expect(find.byKey(Key('home_page')), findsOneWidget);
    });

    testWidgets('用户登录流程', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 1. 进入登录页面
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 2. 输入已注册的手机号
      await tester.enterText(
        find.byKey(Key('phone_input')), 
        '13800138000'
      );

      // 3. 获取登录验证码
      await tester.tap(find.byKey(Key('get_code_button')));
      await tester.pumpAndSettle();

      // 4. 输入验证码
      await tester.enterText(
        find.byKey(Key('code_input')), 
        '123456'
      );

      // 5. 登录
      await tester.tap(find.byKey(Key('login_submit_button')));
      await tester.pumpAndSettle(Duration(seconds: 3));

      // 6. 验证登录成功
      expect(find.byKey(Key('home_page')), findsOneWidget);
      expect(find.text('测试用户'), findsOneWidget);
    });
  });

  group('点餐流程测试', () {
    testWidgets('完整的点餐下单流程', (WidgetTester tester) async {
      // 前置条件：用户已登录
      await _loginUser(tester);

      // 1. 浏览餐厅
      await tester.tap(find.byKey(Key('restaurant_tab')));
      await tester.pumpAndSettle();

      // 2. 选择餐厅
      await tester.tap(find.byKey(Key('restaurant_item_0')));
      await tester.pumpAndSettle();

      // 3. 浏览菜品
      expect(find.byKey(Key('dish_list')), findsOneWidget);

      // 4. 添加菜品到购物车
      await tester.tap(find.byKey(Key('add_dish_0')));
      await tester.pumpAndSettle();

      // 5. 检查购物车
      expect(find.text('1'), findsOneWidget); // 购物车数量
      await tester.tap(find.byKey(Key('cart_button')));
      await tester.pumpAndSettle();

      // 6. 确认订单
      await tester.tap(find.byKey(Key('checkout_button')));
      await tester.pumpAndSettle();

      // 7. 选择地址
      await tester.tap(find.byKey(Key('address_selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('address_item_0')));
      await tester.pumpAndSettle();

      // 8. 支付
      await tester.tap(find.byKey(Key('pay_button')));
      await tester.pumpAndSettle();

      // 9. 选择支付方式
      await tester.tap(find.byKey(Key('wechat_pay')));
      await tester.pumpAndSettle();

      // 10. 确认支付 (测试环境模拟支付成功)
      await tester.tap(find.byKey(Key('confirm_pay_button')));
      await tester.pumpAndSettle(Duration(seconds: 5));

      // 11. 验证订单创建成功
      expect(find.text('订单创建成功'), findsOneWidget);
      expect(find.byKey(Key('order_detail_page')), findsOneWidget);
    });
  });
}

// 辅助函数：登录用户
Future<void> _loginUser(WidgetTester tester) async {
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('phone_input')), '13800138000');
  await tester.tap(find.byKey(Key('get_code_button')));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('code_input')), '123456');
  await tester.tap(find.byKey(Key('login_submit_button')));
  await tester.pumpAndSettle(Duration(seconds: 3));
}
```

### 5.2 Web端E2E测试 (Playwright)

```typescript
// e2e/商家管理.spec.ts
import { test, expect } from '@playwright/test';

test.describe('商家后台管理', () => {
  test.beforeEach(async ({ page }) => {
    // 登录商家账号
    await page.goto('/merchant/login');
    await page.fill('[data-testid=phone-input]', '13800138001');
    await page.click('[data-testid=get-code-button]');
    await page.fill('[data-testid=code-input]', '123456');
    await page.click('[data-testid=login-button]');
    await page.waitForNavigation();
  });

  test('商家应该能够添加新菜品', async ({ page }) => {
    // 1. 导航到菜品管理页面
    await page.click('[data-testid=menu-dishes]');
    await page.waitForSelector('[data-testid=dishes-page]');

    // 2. 点击添加菜品
    await page.click('[data-testid=add-dish-button]');
    await page.waitForSelector('[data-testid=dish-form]');

    // 3. 填写菜品信息
    await page.fill('[data-testid=dish-name]', '测试菜品');
    await page.fill('[data-testid=dish-description]', '这是一道测试菜品');
    await page.fill('[data-testid=dish-price]', '29.90');

    // 4. 上传菜品图片
    await page.setInputFiles(
      '[data-testid=dish-image-upload]', 
      'test-assets/dish-image.jpg'
    );

    // 5. 填写营养信息
    await page.fill('[data-testid=calories]', '350');
    await page.fill('[data-testid=protein]', '25');
    await page.fill('[data-testid=carbs]', '30');
    await page.fill('[data-testid=fat]', '12');

    // 6. 选择分类
    await page.click('[data-testid=category-select]');
    await page.click('[data-testid=category-option-main-course]');

    // 7. 添加标签
    await page.click('[data-testid=tag-input]');
    await page.type('[data-testid=tag-input]', '高蛋白');
    await page.press('[data-testid=tag-input]', 'Enter');

    // 8. 保存菜品
    await page.click('[data-testid=save-dish-button]');

    // 9. 验证菜品创建成功
    await expect(page.locator('[data-testid=success-message]'))
      .toContainText('菜品创建成功');

    // 10. 验证菜品出现在列表中
    await page.goto('/merchant/dishes');
    await expect(page.locator('[data-testid=dish-list]'))
      .toContainText('测试菜品');
  });

  test('商家应该能够查看订单统计', async ({ page }) => {
    // 1. 导航到数据分析页面
    await page.click('[data-testid=menu-analytics]');
    await page.waitForSelector('[data-testid=analytics-page]');

    // 2. 检查今日订单数据
    await expect(page.locator('[data-testid=today-orders]'))
      .toBeVisible();
    
    const todayOrders = await page.textContent('[data-testid=today-orders-count]');
    expect(parseInt(todayOrders)).toBeGreaterThanOrEqual(0);

    // 3. 检查营业额数据
    await expect(page.locator('[data-testid=today-revenue]'))
      .toBeVisible();

    // 4. 检查图表显示
    await expect(page.locator('[data-testid=orders-chart]'))
      .toBeVisible();

    // 5. 切换时间范围
    await page.click('[data-testid=time-range-selector]');
    await page.click('[data-testid=time-range-week]');
    
    // 验证数据更新
    await page.waitForTimeout(1000);
    await expect(page.locator('[data-testid=week-orders]'))
      .toBeVisible();
  });
});
```

---

## 6. API测试框架

### 6.1 API自动化测试

```typescript
// test/api/nutrition.api.spec.ts
import { ApiTestClient } from '../utils/api-test-client';
import { TestDataFactory } from '../utils/test-data-factory';

describe('营养推荐API测试', () => {
  let apiClient: ApiTestClient;
  let testUser: any;

  beforeAll(async () => {
    apiClient = new ApiTestClient();
    await apiClient.authenticate();
    
    // 创建测试用户
    testUser = await TestDataFactory.createUser({
      phone: '13800138000',
      nickname: '测试用户',
    });
  });

  afterAll(async () => {
    await TestDataFactory.cleanup();
  });

  describe('POST /api/nutrition/recommendations', () => {
    it('应该返回个性化营养推荐', async () => {
      // 准备测试数据
      const requestData = {
        userId: testUser.id,
        preferences: {
          cuisineTypes: ['chinese', 'western'],
          dietaryRestrictions: ['vegetarian'],
          maxCalories: 2000,
        },
        location: {
          latitude: 39.9042,
          longitude: 116.4074,
        },
      };

      // 发送请求
      const response = await apiClient.post('/api/nutrition/recommendations', requestData);

      // 验证响应
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('recommendations');
      expect(response.body.recommendations).toBeArray();
      expect(response.body.recommendations.length).toBeGreaterThan(0);

      // 验证推荐项格式
      const firstRecommendation = response.body.recommendations[0];
      expect(firstRecommendation).toHaveProperty('dishId');
      expect(firstRecommendation).toHaveProperty('dishName');
      expect(firstRecommendation).toHaveProperty('reason');
      expect(firstRecommendation).toHaveProperty('nutritionMatch');
      expect(firstRecommendation.nutritionMatch).toBeGreaterThanOrEqual(0);
      expect(firstRecommendation.nutritionMatch).toBeLessThanOrEqual(1);
    });

    it('应该处理无效的用户ID', async () => {
      const response = await apiClient.post('/api/nutrition/recommendations', {
        userId: 'invalid-user-id',
        preferences: {},
      });

      expect(response.status).toBe(404);
      expect(response.body.message).toContain('用户不存在');
    });

    it('应该验证必需字段', async () => {
      const response = await apiClient.post('/api/nutrition/recommendations', {});

      expect(response.status).toBe(400);
      expect(response.body.message).toContain('userId is required');
    });
  });

  describe('GET /api/nutrition/profile/:userId', () => {
    it('应该返回用户营养档案', async () => {
      // 创建营养档案
      const profile = await TestDataFactory.createNutritionProfile({
        userId: testUser.id,
        name: '基础档案',
        level: 'basic',
      });

      const response = await apiClient.get(`/api/nutrition/profile/${testUser.id}`);

      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty('id', profile.id);
      expect(response.body).toHaveProperty('name', '基础档案');
      expect(response.body).toHaveProperty('level', 'basic');
    });
  });
});

// API测试客户端工具类
export class ApiTestClient {
  private baseURL = process.env.API_BASE_URL || 'http://localhost:3000';
  private authToken: string;

  async authenticate(): Promise<void> {
    const response = await fetch(`${this.baseURL}/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        phone: 'test-admin',
        password: 'test-password',
      }),
    });

    const data = await response.json();
    this.authToken = data.accessToken;
  }

  async get(endpoint: string): Promise<any> {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${this.authToken}`,
        'Content-Type': 'application/json',
      },
    });

    return {
      status: response.status,
      body: await response.json(),
    };
  }

  async post(endpoint: string, data: any): Promise<any> {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${this.authToken}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(data),
    });

    return {
      status: response.status,
      body: await response.json(),
    };
  }
}
```

---

## 7. 前端测试策略

### 7.1 Flutter Widget测试

```dart
// test/widgets/nutrition_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_nutrition_app/widgets/nutrition_card.dart';
import 'package:ai_nutrition_app/models/nutrition_info.dart';

void main() {
  group('NutritionCard Widget', () {
    testWidgets('应该正确显示营养信息', (WidgetTester tester) async {
      // 准备测试数据
      final nutritionInfo = NutritionInfo(
        calories: 350,
        protein: 25.0,
        carbs: 30.0,
        fat: 12.0,
        fiber: 5.0,
      );

      // 构建Widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(nutrition: nutritionInfo),
          ),
        ),
      );

      // 验证显示内容
      expect(find.text('350'), findsOneWidget); // 卡路里
      expect(find.text('25.0g'), findsOneWidget); // 蛋白质
      expect(find.text('30.0g'), findsOneWidget); // 碳水化合物
      expect(find.text('12.0g'), findsOneWidget); // 脂肪

      // 验证进度条
      expect(find.byType(CircularProgressIndicator), findsNWidgets(4));
    });

    testWidgets('应该处理空营养信息', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(nutrition: null),
          ),
        ),
      );

      expect(find.text('营养信息暂无'), findsOneWidget);
    });

    testWidgets('应该响应点击事件', (WidgetTester tester) async {
      bool tapped = false;
      final nutritionInfo = NutritionInfo(calories: 350);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NutritionCard(
              nutrition: nutritionInfo,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(NutritionCard));
      expect(tapped, isTrue);
    });
  });
}
```

### 7.2 State管理测试 (Riverpod)

```dart
// test/providers/user_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:ai_nutrition_app/providers/user_provider.dart';
import 'package:ai_nutrition_app/services/user_service.dart';

@GenerateMocks([UserService])
import 'user_provider_test.mocks.dart';

void main() {
  group('UserProvider', () {
    late ProviderContainer container;
    late MockUserService mockUserService;

    setUp(() {
      mockUserService = MockUserService();
      container = ProviderContainer(
        overrides: [
          userServiceProvider.overrideWithValue(mockUserService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('应该初始加载用户信息', () async {
      // Arrange
      final expectedUser = User(id: '123', nickname: '测试用户');
      when(mockUserService.getCurrentUser())
          .thenAnswer((_) async => expectedUser);

      // Act
      final asyncValue = container.read(currentUserProvider);
      
      // Assert
      expect(asyncValue, const AsyncValue<User?>.loading());
      
      // 等待异步操作完成
      await container.read(currentUserProvider.future);
      
      final result = container.read(currentUserProvider);
      expect(result.value, equals(expectedUser));
    });

    test('应该处理用户加载错误', () async {
      // Arrange
      when(mockUserService.getCurrentUser())
          .thenThrow(Exception('网络错误'));

      // Act & Assert
      expect(
        () => container.read(currentUserProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('应该更新用户信息', () async {
      // Arrange
      final originalUser = User(id: '123', nickname: '原用户');
      final updatedUser = User(id: '123', nickname: '新用户');
      
      when(mockUserService.getCurrentUser())
          .thenAnswer((_) async => originalUser);
      when(mockUserService.updateUser(any))
          .thenAnswer((_) async => updatedUser);

      // 初始加载
      await container.read(currentUserProvider.future);
      
      // Act - 更新用户
      await container.read(currentUserProvider.notifier).updateUser(
        UserUpdateData(nickname: '新用户')
      );

      // Assert
      final result = container.read(currentUserProvider);
      expect(result.value?.nickname, equals('新用户'));
    });
  });
}
```

---

## 8. AI功能测试

### 8.1 AI推荐系统测试

```typescript
// test/ai/recommendation.service.spec.ts
describe('AI推荐服务测试', () => {
  let service: RecommendationService;
  let mockVectorService: jest.Mocked<VectorService>;
  let mockOpenAIService: jest.Mocked<OpenAIService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        RecommendationService,
        {
          provide: VectorService,
          useValue: createMockVectorService(),
        },
        {
          provide: OpenAIService,
          useValue: createMockOpenAIService(),
        },
      ],
    }).compile();

    service = module.get<RecommendationService>(RecommendationService);
    mockVectorService = module.get(VectorService);
    mockOpenAIService = module.get(OpenAIService);
  });

  describe('generateRecommendations', () => {
    it('应该生成个性化推荐', async () => {
      // Arrange
      const userProfile = {
        id: 'user-123',
        preferences: {
          cuisineTypes: ['chinese'],
          dietaryRestrictions: ['vegetarian'],
          maxCalories: 2000,
        },
        nutritionGoals: {
          protein: 50,
          carbs: 200,
          fat: 60,
        },
      };

      const mockEmbedding = new Array(1536).fill(0.1);
      const mockSimilarDishes = [
        { dishId: 'dish-1', similarity: 0.95 },
        { dishId: 'dish-2', similarity: 0.87 },
      ];

      mockOpenAIService.generateEmbedding.mockResolvedValue(mockEmbedding);
      mockVectorService.findSimilarDishes.mockResolvedValue(mockSimilarDishes);

      // Act
      const recommendations = await service.generateRecommendations(userProfile);

      // Assert
      expect(recommendations).toHaveLength(2);
      expect(recommendations[0].dishId).toBe('dish-1');
      expect(recommendations[0].confidence).toBeGreaterThan(0.9);
      
      expect(mockOpenAIService.generateEmbedding).toHaveBeenCalledWith(
        expect.stringContaining('chinese vegetarian')
      );
      expect(mockVectorService.findSimilarDishes).toHaveBeenCalledWith(
        mockEmbedding,
        expect.any(Object)
      );
    });

    it('应该处理AI服务异常', async () => {
      // Arrange
      mockOpenAIService.generateEmbedding.mockRejectedValue(
        new Error('AI服务不可用')
      );

      // Act & Assert
      await expect(
        service.generateRecommendations({} as any)
      ).rejects.toThrow('AI服务不可用');
    });

    it('应该返回后备推荐当向量搜索失败时', async () => {
      // Arrange
      mockOpenAIService.generateEmbedding.mockResolvedValue([]);
      mockVectorService.findSimilarDishes.mockResolvedValue([]);

      // Mock后备推荐
      const fallbackRecommendations = [
        { dishId: 'popular-1', reason: '热门推荐' },
      ];
      jest.spyOn(service, 'getFallbackRecommendations')
        .mockResolvedValue(fallbackRecommendations);

      // Act
      const result = await service.generateRecommendations({} as any);

      // Assert
      expect(result).toEqual(fallbackRecommendations);
    });
  });

  describe('AI响应质量测试', () => {
    it('推荐结果应该符合用户约束条件', async () => {
      const userProfile = {
        preferences: {
          maxCalories: 500,
          allergens: ['nuts', 'dairy'],
        },
      };

      const recommendations = await service.generateRecommendations(userProfile);

      // 验证所有推荐都符合卡路里限制
      for (const rec of recommendations) {
        expect(rec.nutrition.calories).toBeLessThanOrEqual(500);
        
        // 验证不包含过敏源
        expect(rec.allergens).not.toContain('nuts');
        expect(rec.allergens).not.toContain('dairy');
      }
    });

    it('推荐置信度应该在合理范围内', async () => {
      const recommendations = await service.generateRecommendations({} as any);

      for (const rec of recommendations) {
        expect(rec.confidence).toBeGreaterThanOrEqual(0);
        expect(rec.confidence).toBeLessThanOrEqual(1);
      }

      // 推荐应该按置信度降序排列
      for (let i = 1; i < recommendations.length; i++) {
        expect(recommendations[i].confidence)
          .toBeLessThanOrEqual(recommendations[i-1].confidence);
      }
    });
  });
});

function createMockVectorService() {
  return {
    findSimilarDishes: jest.fn(),
    storeEmbedding: jest.fn(),
    updateEmbedding: jest.fn(),
  };
}

function createMockOpenAIService() {
  return {
    generateEmbedding: jest.fn(),
    chatCompletion: jest.fn(),
    generateNutritionAnalysis: jest.fn(),
  };
}
```

### 8.2 AI对话系统测试

```typescript
// test/ai/chat.service.spec.ts
describe('AI对话服务测试', () => {
  let service: ChatService;
  let mockLangChainService: jest.Mocked<LangChainService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        ChatService,
        {
          provide: LangChainService,
          useValue: {
            createChatSession: jest.fn(),
            sendMessage: jest.fn(),
            getSessionHistory: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<ChatService>(ChatService);
    mockLangChainService = module.get(LangChainService);
  });

  describe('营养咨询对话', () => {
    it('应该提供专业的营养建议', async () => {
      // Arrange
      const userMessage = '我想减肥，应该怎么安排饮食？';
      const expectedResponse = {
        type: 'nutrition_advice',
        content: '建议您采用低卡路里、高蛋白的饮食方案...',
        recommendations: [
          { type: 'dish', id: 'low-cal-salad' },
          { type: 'plan', id: 'weight-loss-plan' },
        ],
        followUpQuestions: [
          '您目前的体重和目标体重是多少？',
          '您有什么饮食偏好或限制吗？',
        ],
      };

      mockLangChainService.sendMessage.mockResolvedValue(expectedResponse);

      // Act
      const result = await service.sendMessage('session-123', userMessage);

      // Assert
      expect(result.type).toBe('nutrition_advice');
      expect(result.content).toContain('低卡路里');
      expect(result.recommendations).toHaveLength(2);
      expect(result.followUpQuestions).toHaveLength(2);
    });

    it('应该记住对话上下文', async () => {
      // Arrange
      const sessionId = 'session-123';
      const messages = [
        { role: 'user', content: '我是素食主义者' },
        { role: 'assistant', content: '好的，我会为您推荐素食选项' },
        { role: 'user', content: '推荐一些高蛋白的素食' },
      ];

      mockLangChainService.getSessionHistory.mockResolvedValue(messages);

      // Act
      await service.sendMessage(sessionId, '推荐一些高蛋白的素食');

      // Assert
      expect(mockLangChainService.sendMessage).toHaveBeenCalledWith(
        sessionId,
        '推荐一些高蛋白的素食',
        expect.objectContaining({
          context: expect.arrayContaining([
            expect.objectContaining({ content: '我是素食主义者' }),
          ]),
        })
      );
    });

    it('应该处理模糊或不完整的查询', async () => {
      // Arrange
      const userMessage = '这个好吃吗？'; // 缺少上下文的查询

      mockLangChainService.sendMessage.mockResolvedValue({
        type: 'clarification_needed',
        content: '请问您指的是哪道菜品呢？',
        suggestedActions: [
          '浏览菜单',
          '查看推荐菜品',
        ],
      });

      // Act
      const result = await service.sendMessage('session-123', userMessage);

      // Assert
      expect(result.type).toBe('clarification_needed');
      expect(result.suggestedActions).toContain('浏览菜单');
    });
  });

  describe('对话质量保证', () => {
    it('响应时间应该在可接受范围内', async () => {
      const startTime = Date.now();
      
      await service.sendMessage('session-123', '测试消息');
      
      const responseTime = Date.now() - startTime;
      expect(responseTime).toBeLessThan(5000); // 5秒内响应
    });

    it('应该过滤不当内容', async () => {
      const inappropriateMessage = '一些不当内容...';
      
      const result = await service.sendMessage('session-123', inappropriateMessage);
      
      expect(result.type).toBe('content_filtered');
      expect(result.content).toContain('无法处理此类内容');
    });

    it('应该限制对话频率', async () => {
      // 模拟快速连续发送消息
      const promises = Array(10).fill(0).map((_, i) => 
        service.sendMessage('session-123', `消息${i}`)
      );

      const results = await Promise.allSettled(promises);
      
      // 应该有一些请求被限流
      const rejectedRequests = results.filter(r => r.status === 'rejected');
      expect(rejectedRequests.length).toBeGreaterThan(0);
    });
  });
});
```

### 8.1 AI图片识别测试

```typescript
// test/ai/photo-recognition.service.spec.ts
describe('AI图片识别服务测试', () => {
  let service: PhotoRecognitionService;
  let mockAIService: jest.Mocked<DeepSeekService>;
  let mockStorageService: jest.Mocked<FileStorageService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        PhotoRecognitionService,
        { provide: DeepSeekService, useValue: createMockAIService() },
        { provide: FileStorageService, useValue: createMockStorageService() },
      ],
    }).compile();

    service = module.get<PhotoRecognitionService>(PhotoRecognitionService);
    mockAIService = module.get(DeepSeekService);
    mockStorageService = module.get(FileStorageService);
  });

  describe('食物识别', () => {
    it('应该正确识别常见食物', async () => {
      // Arrange
      const imageBuffer = Buffer.from('fake-image-data');
      const expectedResult = {
        recognizedItems: [
          {
            name: '宫保鸡丁',
            confidence: 0.95,
            category: 'main_course',
            nutrition: {
              calories: 350,
              protein: 25,
              carbs: 15,
              fat: 20,
            },
          },
        ],
        totalCalories: 350,
        processingTime: 1200,
      };

      mockAIService.recognizeFood.mockResolvedValue(expectedResult);
      mockStorageService.uploadFile.mockResolvedValue('uploaded-url');

      // Act
      const result = await service.recognizeFood(imageBuffer, 'user-123');

      // Assert
      expect(result.recognizedItems).toHaveLength(1);
      expect(result.recognizedItems[0].confidence).toBeGreaterThan(0.9);
      expect(result.totalCalories).toBe(350);
      expect(mockAIService.recognizeFood).toHaveBeenCalledWith(imageBuffer);
    });

    it('应该处理识别失败的情况', async () => {
      // Arrange
      const imageBuffer = Buffer.from('invalid-image');
      mockAIService.recognizeFood.mockRejectedValue(
        new Error('无法识别图片内容')
      );

      // Act & Assert
      await expect(
        service.recognizeFood(imageBuffer, 'user-123')
      ).rejects.toThrow('无法识别图片内容');
    });

    it('应该记录识别历史', async () => {
      // Arrange
      const imageBuffer = Buffer.from('test-image');
      const mockResult = {
        recognizedItems: [{ name: '测试食物', confidence: 0.8 }],
      };
      
      mockAIService.recognizeFood.mockResolvedValue(mockResult);
      mockStorageService.uploadFile.mockResolvedValue('test-url');

      // Act
      await service.recognizeFood(imageBuffer, 'user-123');

      // Assert
      expect(mockStorageService.uploadFile).toHaveBeenCalledWith(
        imageBuffer,
        expect.stringContaining('food-recognition')
      );
    });
  });

  describe('营养分析', () => {
    it('应该提供详细的营养分析', async () => {
      const recognizedItems = [
        { name: '米饭', calories: 200, protein: 4, carbs: 45, fat: 0.5 },
        { name: '青椒肉丝', calories: 180, protein: 15, carbs: 8, fat: 12 },
      ];

      const analysis = await service.analyzeNutrition(recognizedItems, 'user-123');

      expect(analysis.totalNutrition.calories).toBe(380);
      expect(analysis.totalNutrition.protein).toBe(19);
      expect(analysis.recommendations).toContain('该餐搭配较为均衡');
      expect(analysis.healthScore).toBeGreaterThan(0);
      expect(analysis.healthScore).toBeLessThanOrEqual(100);
    });
  });
});
```

### 8.2 库存管理测试

```typescript
// test/inventory/inventory.service.spec.ts
describe('库存管理服务测试', () => {
  let service: InventoryService;
  let mockRepository: jest.Mocked<Repository<Inventory>>;
  let mockNotificationService: jest.Mocked<NotificationService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        InventoryService,
        { provide: getRepositoryToken(Inventory), useValue: createMockRepository() },
        { provide: NotificationService, useValue: createMockNotificationService() },
      ],
    }).compile();

    service = module.get<InventoryService>(InventoryService);
    mockRepository = module.get(getRepositoryToken(Inventory));
    mockNotificationService = module.get(NotificationService);
  });

  describe('库存更新', () => {
    it('应该正确更新库存数量', async () => {
      // Arrange
      const inventoryItem = {
        id: 'item-123',
        dishId: 'dish-456',
        storeId: 'store-789',
        currentStock: 50,
        minThreshold: 10,
      };

      mockRepository.findOne.mockResolvedValue(inventoryItem);
      mockRepository.save.mockImplementation(item => Promise.resolve(item));

      // Act
      const result = await service.updateStock('item-123', -5, 'SALE');

      // Assert
      expect(result.currentStock).toBe(45);
      expect(mockRepository.save).toHaveBeenCalledWith(
        expect.objectContaining({ currentStock: 45 })
      );
    });

    it('应该在库存不足时发送预警', async () => {
      // Arrange
      const lowStockItem = {
        id: 'item-123',
        currentStock: 12,
        minThreshold: 10,
        storeId: 'store-789',
      };

      mockRepository.findOne.mockResolvedValue(lowStockItem);
      mockRepository.save.mockImplementation(item => Promise.resolve(item));

      // Act
      await service.updateStock('item-123', -5, 'SALE');

      // Assert
      expect(mockNotificationService.sendLowStockAlert).toHaveBeenCalledWith(
        'store-789',
        expect.objectContaining({ currentStock: 7 })
      );
    });

    it('应该阻止负库存操作', async () => {
      // Arrange
      const inventoryItem = {
        id: 'item-123',
        currentStock: 3,
        minThreshold: 5,
      };

      mockRepository.findOne.mockResolvedValue(inventoryItem);

      // Act & Assert
      await expect(
        service.updateStock('item-123', -5, 'SALE')
      ).rejects.toThrow('库存不足');
    });
  });

  describe('自动补货建议', () => {
    it('应该基于历史数据生成补货建议', async () => {
      // Arrange
      const salesHistory = [
        { date: '2025-01-01', quantity: 20 },
        { date: '2025-01-02', quantity: 25 },
        { date: '2025-01-03', quantity: 18 },
      ];

      jest.spyOn(service, 'getSalesHistory').mockResolvedValue(salesHistory);

      // Act
      const suggestion = await service.generateRestockSuggestion('item-123');

      // Assert
      expect(suggestion.suggestedQuantity).toBeGreaterThan(0);
      expect(suggestion.urgencyLevel).toBeOneOf(['LOW', 'MEDIUM', 'HIGH']);
      expect(suggestion.estimatedDepletion).toBeInstanceOf(Date);
    });
  });
});
```

### 8.3 用户行为分析测试

```typescript
// test/analytics/user-behavior.service.spec.ts
describe('用户行为分析服务测试', () => {
  let service: UserBehaviorService;
  let mockRepository: jest.Mocked<Repository<UserBehavior>>;
  let mockAnalyticsEngine: jest.Mocked<AnalyticsEngine>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        UserBehaviorService,
        { provide: getRepositoryToken(UserBehavior), useValue: createMockRepository() },
        { provide: AnalyticsEngine, useValue: createMockAnalyticsEngine() },
      ],
    }).compile();

    service = module.get<UserBehaviorService>(UserBehaviorService);
    mockRepository = module.get(getRepositoryToken(UserBehavior));
    mockAnalyticsEngine = module.get(AnalyticsEngine);
  });

  describe('行为数据收集', () => {
    it('应该正确记录用户行为', async () => {
      // Arrange
      const behaviorData = {
        userId: 'user-123',
        action: 'VIEW_DISH',
        targetId: 'dish-456',
        context: { source: 'recommendation' },
        timestamp: new Date(),
      };

      mockRepository.create.mockReturnValue(behaviorData as any);
      mockRepository.save.mockResolvedValue(behaviorData as any);

      // Act
      await service.recordBehavior(behaviorData);

      // Assert
      expect(mockRepository.create).toHaveBeenCalledWith(behaviorData);
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('应该批量处理行为数据', async () => {
      // Arrange
      const behaviors = Array(100).fill(0).map((_, i) => ({
        userId: 'user-123',
        action: 'SCROLL',
        targetId: `item-${i}`,
        timestamp: new Date(),
      }));

      mockRepository.save.mockResolvedValue(behaviors as any);

      // Act
      await service.batchRecordBehaviors(behaviors);

      // Assert
      expect(mockRepository.save).toHaveBeenCalledWith(behaviors);
    });
  });

  describe('用户偏好分析', () => {
    it('应该分析用户饮食偏好', async () => {
      // Arrange
      const userBehaviors = [
        { action: 'ORDER', targetId: 'dish-chinese-1', context: { cuisine: 'chinese' } },
        { action: 'ORDER', targetId: 'dish-chinese-2', context: { cuisine: 'chinese' } },
        { action: 'VIEW', targetId: 'dish-western-1', context: { cuisine: 'western' } },
      ];

      mockRepository.find.mockResolvedValue(userBehaviors as any);

      // Act
      const preferences = await service.analyzeUserPreferences('user-123');

      // Assert
      expect(preferences.cuisinePreferences.chinese).toBeGreaterThan(
        preferences.cuisinePreferences.western
      );
      expect(preferences.confidence).toBeGreaterThan(0);
    });

    it('应该识别用户活跃时段', async () => {
      // Arrange
      const timeBasedBehaviors = [
        { timestamp: new Date('2025-01-01T12:00:00Z'), action: 'ORDER' },
        { timestamp: new Date('2025-01-01T12:30:00Z'), action: 'ORDER' },
        { timestamp: new Date('2025-01-01T19:00:00Z'), action: 'ORDER' },
      ];

      mockRepository.find.mockResolvedValue(timeBasedBehaviors as any);

      // Act
      const timePatterns = await service.analyzeTimePatterns('user-123');

      // Assert
      expect(timePatterns.peakHours).toContain(12);
      expect(timePatterns.peakHours).toContain(19);
      expect(timePatterns.mealTimes.lunch).toBeDefined();
      expect(timePatterns.mealTimes.dinner).toBeDefined();
    });
  });
});
```

### 8.4 营养师咨询测试

```typescript
// test/consultation/consultation.service.spec.ts
describe('营养师咨询服务测试', () => {
  let service: ConsultationService;
  let mockRepository: jest.Mocked<Repository<ConsultationOrder>>;
  let mockMessageService: jest.Mocked<MessageService>;
  let mockAIService: jest.Mocked<NutritionAIService>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        ConsultationService,
        { provide: getRepositoryToken(ConsultationOrder), useValue: createMockRepository() },
        { provide: MessageService, useValue: createMockMessageService() },
        { provide: NutritionAIService, useValue: createMockAIService() },
      ],
    }).compile();

    service = module.get<ConsultationService>(ConsultationService);
    mockRepository = module.get(getRepositoryToken(ConsultationOrder));
    mockMessageService = module.get(MessageService);
    mockAIService = module.get(NutritionAIService);
  });

  describe('咨询订单管理', () => {
    it('应该创建咨询订单', async () => {
      // Arrange
      const orderData = {
        userId: 'user-123',
        nutritionistId: 'nutritionist-456',
        consultationType: 'WEIGHT_LOSS',
        duration: 30,
        scheduledAt: new Date('2025-01-15T10:00:00Z'),
      };

      const expectedOrder = { id: 'order-789', ...orderData };
      mockRepository.create.mockReturnValue(expectedOrder as any);
      mockRepository.save.mockResolvedValue(expectedOrder as any);

      // Act
      const result = await service.createConsultation(orderData);

      // Assert
      expect(result.id).toBe('order-789');
      expect(result.status).toBe('SCHEDULED');
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('应该检查营养师可用性', async () => {
      // Arrange
      const nutritionistId = 'nutritionist-456';
      const requestedTime = new Date('2025-01-15T10:00:00Z');
      
      // 模拟营养师在该时间已有预约
      mockRepository.find.mockResolvedValue([
        { 
          nutritionistId,
          scheduledAt: new Date('2025-01-15T10:00:00Z'),
          duration: 60,
          status: 'SCHEDULED',
        }
      ] as any);

      // Act & Assert
      await expect(
        service.createConsultation({
          userId: 'user-123',
          nutritionistId,
          scheduledAt: requestedTime,
          duration: 30,
        })
      ).rejects.toThrow('营养师在该时间段不可用');
    });
  });

  describe('AI辅助分析', () => {
    it('应该为营养师提供AI分析报告', async () => {
      // Arrange
      const userId = 'user-123';
      const userProfile = {
        age: 28,
        gender: 'female',
        height: 165,
        weight: 60,
        activityLevel: 'moderate',
        healthGoals: ['weight_loss'],
      };

      mockAIService.generateNutritionAnalysis.mockResolvedValue({
        currentStatus: 'HEALTHY_WEIGHT',
        recommendations: [
          '建议每日减少200-300卡路里摄入',
          '增加蛋白质比例至25%',
        ],
        riskFactors: [],
        confidenceScore: 0.92,
      });

      // Act
      const analysis = await service.generateAIAnalysis(userId, userProfile);

      // Assert
      expect(analysis.recommendations).toHaveLength(2);
      expect(analysis.confidenceScore).toBeGreaterThan(0.9);
      expect(mockAIService.generateNutritionAnalysis).toHaveBeenCalledWith(userProfile);
    });

    it('应该实时更新营养建议', async () => {
      // Arrange
      const consultationId = 'consultation-123';
      const newUserData = {
        recentMeals: ['沙拉', '烤鸡胸肉'],
        symptoms: ['轻微疲劳'],
        weightChange: -0.5,
      };

      mockAIService.updateRecommendations.mockResolvedValue({
        adjustedPlan: '基于最新数据调整的营养计划',
        reasoning: '体重下降符合预期，建议继续当前饮食策略',
      });

      // Act
      const updatedPlan = await service.updateRecommendations(consultationId, newUserData);

      // Assert
      expect(updatedPlan.adjustedPlan).toContain('营养计划');
      expect(updatedPlan.reasoning).toContain('体重下降');
    });
  });

  describe('消息系统集成', () => {
    it('应该发送咨询提醒', async () => {
      // Arrange
      const consultation = {
        id: 'consultation-123',
        userId: 'user-123',
        nutritionistId: 'nutritionist-456',
        scheduledAt: new Date(Date.now() + 30 * 60 * 1000), // 30分钟后
      };

      // Act
      await service.sendReminder(consultation.id);

      // Assert
      expect(mockMessageService.sendNotification).toHaveBeenCalledWith(
        consultation.userId,
        expect.objectContaining({
          type: 'CONSULTATION_REMINDER',
          message: expect.stringContaining('30分钟后'),
        })
      );
    });
  });
});
```

---

## 9. 性能测试

### 9.1 API性能测试

```javascript
// performance/api-load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

// 自定义指标
const errorRate = new Rate('errors');

export let options = {
  stages: [
    { duration: '2m', target: 10 },    // 预热
    { duration: '5m', target: 50 },    // 正常负载
    { duration: '10m', target: 100 },  // 高负载
    { duration: '5m', target: 200 },   // 压力测试
    { duration: '2m', target: 0 },     // 恢复
  ],
  thresholds: {
    http_req_duration: ['p(95)<200'], // 95%请求<200ms
    http_req_failed: ['rate<0.02'],   // 错误率<2%
    errors: ['rate<0.05'],            // 业务错误率<5%
  },
};

const BASE_URL = 'http://localhost:3000';
let authToken;

export function setup() {
  // 获取认证token
  const loginRes = http.post(`${BASE_URL}/auth/login`, {
    phone: 'load-test-user',
    password: 'test-password',
  });
  
  authToken = loginRes.json('accessToken');
  return { authToken };
}

export default function(data) {
  const headers = {
    'Authorization': `Bearer ${data.authToken}`,
    'Content-Type': 'application/json',
  };

  // 测试场景1: 获取推荐菜品
  const recommendationRes = http.post(
    `${BASE_URL}/api/nutrition/recommendations`,
    JSON.stringify({
      userId: 'test-user-id',
      preferences: {
        cuisineTypes: ['chinese'],
        maxCalories: 2000,
      },
    }),
    { headers }
  );

  check(recommendationRes, {
    '推荐接口状态正常': (r) => r.status === 200,
    '推荐接口响应时间<500ms': (r) => r.timings.duration < 500,
    '返回推荐结果': (r) => r.json('recommendations').length > 0,
  }) || errorRate.add(1);

  sleep(1);

  // 测试场景2: 搜索餐厅
  const searchRes = http.get(
    `${BASE_URL}/api/restaurants/search?keyword=川菜&location=39.9042,116.4074`,
    { headers }
  );

  check(searchRes, {
    '搜索接口状态正常': (r) => r.status === 200,
    '搜索响应时间<300ms': (r) => r.timings.duration < 300,
  }) || errorRate.add(1);

  sleep(1);

  // 测试场景3: 创建订单
  const orderRes = http.post(
    `${BASE_URL}/api/orders`,
    JSON.stringify({
      storeId: 'test-store-id',
      items: [
        { dishId: 'dish-1', quantity: 2 },
        { dishId: 'dish-2', quantity: 1 },
      ],
      deliveryAddress: {
        street: '测试地址',
        city: '北京市',
      },
    }),
    { headers }
  );

  check(orderRes, {
    '订单创建状态正常': (r) => r.status === 201,
    '订单创建响应时间<1s': (r) => r.timings.duration < 1000,
    '返回订单ID': (r) => r.json('id') !== undefined,
  }) || errorRate.add(1);

  sleep(2);
}

export function teardown(data) {
  // 清理测试数据
  console.log('性能测试完成');
}
```

### 9.2 数据库性能测试

```sql
-- database/performance-test.sql

-- 1. 查询性能测试
EXPLAIN ANALYZE
SELECT d.id, d.name, d.price, d.nutrition
FROM dishes d
JOIN stores s ON d.store_id = s.id
WHERE s.location <-> point(116.4074, 39.9042) < 5000
  AND d.is_available = true
  AND d.nutrition->>'calories' < '500'
ORDER BY s.location <-> point(116.4074, 39.9042)
LIMIT 20;

-- 2. 向量搜索性能测试
EXPLAIN ANALYZE
SELECT entity_id, embedding <=> %s as distance
FROM vector_embeddings
WHERE entity_type = 'dish'
ORDER BY embedding <=> %s
LIMIT 10;

-- 3. 复杂统计查询性能测试
EXPLAIN ANALYZE
WITH daily_stats AS (
  SELECT 
    DATE(created_at) as date,
    store_id,
    COUNT(*) as order_count,
    SUM(total) as revenue
  FROM orders
  WHERE created_at >= CURRENT_DATE - INTERVAL '30 days'
  GROUP BY DATE(created_at), store_id
)
SELECT 
  s.name,
  AVG(ds.order_count) as avg_orders_per_day,
  AVG(ds.revenue) as avg_revenue_per_day
FROM daily_stats ds
JOIN stores s ON ds.store_id = s.id
GROUP BY s.id, s.name
ORDER BY avg_revenue_per_day DESC;

-- 4. 压力测试 - 并发插入
BEGIN;
INSERT INTO orders (id, user_id, store_id, total, status)
SELECT 
  gen_random_uuid(),
  'test-user-' || (random() * 1000)::int,
  'store-' || (random() * 100)::int,
  (random() * 200 + 10)::decimal(10,2),
  'pending'
FROM generate_series(1, 10000);
COMMIT;

-- 5. 索引效果验证
-- 无索引查询
DROP INDEX IF EXISTS idx_orders_created_at;
EXPLAIN ANALYZE
SELECT COUNT(*) FROM orders WHERE created_at > CURRENT_DATE - INTERVAL '7 days';

-- 创建索引后查询
CREATE INDEX idx_orders_created_at ON orders(created_at);
EXPLAIN ANALYZE
SELECT COUNT(*) FROM orders WHERE created_at > CURRENT_DATE - INTERVAL '7 days';
```

### 9.3 前端性能测试

```dart
// test/performance/flutter_performance_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:ai_nutrition_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('性能测试', () => {
    testWidgets('应用启动性能测试', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;
      
      // 开始性能监控
      await binding.enableTimeline();
      
      // 启动应用
      app.main();
      await tester.pumpAndSettle();
      
      // 结束性能监控
      final timeline = await binding.disableTimeline();
      
      // 分析启动时间
      final summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(
        'startup_performance',
        destinationDirectory: 'build/performance/',
      );
      
      // 验证启动时间
      expect(summary.summaryJson['average_frame_build_time_millis'], 
             lessThan(16.67)); // 60FPS = 16.67ms per frame
    });

    testWidgets('列表滚动性能测试', (WidgetTester tester) async {
      final binding = IntegrationTestWidgetsFlutterBinding.instance;
      
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();
      
      // 导航到餐厅列表页面
      await tester.tap(find.byKey(Key('restaurant_tab')));
      await tester.pumpAndSettle();
      
      // 开始性能监控
      await binding.enableTimeline();
      
      // 执行滚动操作
      final listView = find.byType(ListView);
      await tester.fling(listView, Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      
      await tester.fling(listView, Offset(0, -500), 1000);
      await tester.pumpAndSettle();
      
      // 结束性能监控
      final timeline = await binding.disableTimeline();
      
      // 分析滚动性能
      final summary = TimelineSummary.summarize(timeline);
      await summary.writeTimelineToFile(
        'scroll_performance',
        destinationDirectory: 'build/performance/',
      );
      
      // 验证滚动流畅度
      expect(summary.countFrames(), greaterThan(0));
      expect(summary.summaryJson['missed_frame_count'], equals(0));
    });

    testWidgets('内存使用测试', (WidgetTester tester) async {
      // 监控内存使用
      var initialMemory = ProcessInfo.currentMemoryUsage;
      
      // 执行一系列操作
      await tester.pumpWidget(app.MyApp());
      await tester.pumpAndSettle();
      
      // 导航到多个页面
      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byKey(Key('restaurant_tab')));
        await tester.pumpAndSettle();
        
        await tester.tap(find.byKey(Key('profile_tab')));
        await tester.pumpAndSettle();
      }
      
      // 触发垃圾回收
      await tester.binding.reassembleApplication();
      await tester.pumpAndSettle();
      
      var finalMemory = ProcessInfo.currentMemoryUsage;
      var memoryIncrease = finalMemory - initialMemory;
      
      // 验证内存泄漏
      expect(memoryIncrease, lessThan(50 * 1024 * 1024)); // 内存增长<50MB
    });
  });
}
```

---

## 10. 安全测试

### 10.1 API安全测试

```typescript
// test/security/auth.security.spec.ts
describe('认证安全测试', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  describe('JWT令牌安全', () => {
    it('应该拒绝无效的JWT令牌', async () => {
      const invalidToken = 'invalid.jwt.token';
      
      const response = await request(app.getHttpServer())
        .get('/api/user/profile')
        .set('Authorization', `Bearer ${invalidToken}`)
        .expect(401);

      expect(response.body.message).toContain('Unauthorized');
    });

    it('应该拒绝过期的JWT令牌', async () => {
      // 创建过期令牌
      const expiredToken = jwt.sign(
        { userId: 'test-user' },
        'secret',
        { expiresIn: '-1h' }
      );

      await request(app.getHttpServer())
        .get('/api/user/profile')
        .set('Authorization', `Bearer ${expiredToken}`)
        .expect(401);
    });

    it('应该拒绝篡改的JWT令牌', async () => {
      // 创建有效令牌然后篡改
      const validToken = jwt.sign({ userId: 'test-user' }, 'secret');
      const tamperedToken = validToken.slice(0, -5) + 'AAAAA';

      await request(app.getHttpServer())
        .get('/api/user/profile')
        .set('Authorization', `Bearer ${tamperedToken}`)
        .expect(401);
    });
  });

  describe('输入验证安全', () => {
    it('应该防止SQL注入攻击', async () => {
      const maliciousInput = "'; DROP TABLE users; --";

      await request(app.getHttpServer())
        .post('/api/users/search')
        .send({ query: maliciousInput })
        .expect(400); // 应该被输入验证拒绝
    });

    it('应该防止XSS攻击', async () => {
      const xssPayload = '<script>alert("XSS")</script>';

      const response = await request(app.getHttpServer())
        .post('/api/users')
        .send({
          nickname: xssPayload,
          phone: '13800138000',
        })
        .expect(400);

      expect(response.body.message).toContain('Invalid characters');
    });

    it('应该验证文件上传类型', async () => {
      const maliciousFile = Buffer.from('<?php echo "malicious code"; ?>');

      await request(app.getHttpServer())
        .post('/api/upload/avatar')
        .attach('file', maliciousFile, 'malicious.php')
        .expect(400);
    });
  });

  describe('访问控制安全', () => {
    it('应该防止越权访问其他用户数据', async () => {
      // 用户A的token
      const userAToken = await getUserToken('user-a');
      
      // 尝试访问用户B的数据
      await request(app.getHttpServer())
        .get('/api/users/user-b/profile')
        .set('Authorization', `Bearer ${userAToken}`)
        .expect(403);
    });

    it('应该验证商家权限', async () => {
      const userToken = await getUserToken('regular-user');
      
      // 普通用户尝试访问商家功能
      await request(app.getHttpServer())
        .post('/api/merchant/dishes')
        .set('Authorization', `Bearer ${userToken}`)
        .send({ name: '测试菜品' })
        .expect(403);
    });
  });

  describe('限流和防护', () => {
    it('应该限制API调用频率', async () => {
      const userToken = await getUserToken('test-user');
      
      // 快速连续调用API
      const promises = Array(100).fill(0).map(() =>
        request(app.getHttpServer())
          .get('/api/restaurants')
          .set('Authorization', `Bearer ${userToken}`)
      );

      const responses = await Promise.all(promises);
      
      // 应该有请求被限流
      const rateLimitedResponses = responses.filter(r => r.status === 429);
      expect(rateLimitedResponses.length).toBeGreaterThan(0);
    });

    it('应该防护暴力破解登录', async () => {
      const phone = '13800138000';
      
      // 连续失败登录尝试
      for (let i = 0; i < 10; i++) {
        await request(app.getHttpServer())
          .post('/api/auth/login')
          .send({
            phone: phone,
            code: 'wrong-code',
          })
          .expect(401);
      }

      // 第11次尝试应该被暂时锁定
      await request(app.getHttpServer())
        .post('/api/auth/login')
        .send({
          phone: phone,
          code: '123456', // 即使是正确的验证码
        })
        .expect(429); // Too Many Requests
    });
  });
});

// 辅助函数
async function getUserToken(userId: string): Promise<string> {
  // 创建测试用户并返回JWT令牌
  const response = await request(app.getHttpServer())
    .post('/api/auth/test-login')
    .send({ userId });
    
  return response.body.accessToken;
}
```

### 10.2 数据安全测试

```typescript
// test/security/data.security.spec.ts
describe('数据安全测试', () => {
  describe('敏感数据保护', () => {
    it('API响应不应该包含敏感字段', async () => {
      const response = await request(app.getHttpServer())
        .get('/api/users/profile')
        .set('Authorization', `Bearer ${validToken}`)
        .expect(200);

      // 验证敏感字段被过滤
      expect(response.body).not.toHaveProperty('passwordHash');
      expect(response.body).not.toHaveProperty('socialLogins');
      expect(response.body).not.toHaveProperty('paymentInfo');
    });

    it('日志不应该包含敏感信息', async () => {
      // 监控日志输出
      const logSpy = jest.spyOn(console, 'log');
      
      await request(app.getHttpServer())
        .post('/api/auth/login')
        .send({
          phone: '13800138000',
          code: '123456',
        });

      // 检查日志内容
      const logMessages = logSpy.mock.calls.flat().join(' ');
      expect(logMessages).not.toContain('123456'); // 验证码不应该被记录
      expect(logMessages).not.toContain('password');
      
      logSpy.mockRestore();
    });
  });

  describe('数据库安全', () => {
    it('密码应该被正确哈希存储', async () => {
      const userData = {
        phone: '13800138001',
        password: 'test-password-123',
      };

      await request(app.getHttpServer())
        .post('/api/auth/register')
        .send(userData)
        .expect(201);

      // 直接查询数据库验证密码被哈希
      const user = await userRepository.findOne({ 
        where: { phone: userData.phone } 
      });
      
      expect(user.passwordHash).not.toBe(userData.password);
      expect(user.passwordHash).toMatch(/^\$2[ayb]\$\d+\$/); // bcrypt格式
    });

    it('应该正确实现软删除', async () => {
      const user = await createTestUser();
      
      // 删除用户
      await request(app.getHttpServer())
        .delete(`/api/users/${user.id}`)
        .set('Authorization', `Bearer ${adminToken}`)
        .expect(200);

      // 验证用户在普通查询中不可见
      const publicUser = await userRepository.findOne({
        where: { id: user.id }
      });
      expect(publicUser).toBeNull();

      // 验证用户在包含已删除的查询中可见
      const deletedUser = await userRepository.findOne({
        where: { id: user.id },
        withDeleted: true,
      });
      expect(deletedUser).not.toBeNull();
      expect(deletedUser.deletedAt).not.toBeNull();
    });
  });

  describe('GDPR合规性', () => {
    it('应该支持数据导出', async () => {
      const user = await createTestUser();
      
      const response = await request(app.getHttpServer())
        .get('/api/users/export-data')
        .set('Authorization', `Bearer ${await getUserToken(user.id)}`)
        .expect(200);

      // 验证导出数据格式
      expect(response.body).toHaveProperty('personalData');
      expect(response.body).toHaveProperty('activityData');
      expect(response.body).toHaveProperty('exportDate');
    });

    it('应该支持数据删除', async () => {
      const user = await createTestUser();
      
      // 请求删除所有个人数据
      await request(app.getHttpServer())
        .post('/api/users/delete-all-data')
        .set('Authorization', `Bearer ${await getUserToken(user.id)}`)
        .expect(200);

      // 验证用户数据被完全删除
      const deletedUser = await userRepository.findOne({
        where: { id: user.id },
        withDeleted: true,
      });
      
      expect(deletedUser.phone).toBe('[DELETED]');
      expect(deletedUser.email).toBe('[DELETED]');
      expect(deletedUser.nickname).toBe('[DELETED]');
    });
  });
});
```

---

## 文档说明

本测试策略指南定义了AI智能营养餐厅系统的完整测试框架，包括：

1. **测试金字塔** - 70%单元测试，20%集成测试，10%E2E测试
2. **多层测试** - 从单元到端到端的完整覆盖
3. **AI测试** - 针对推荐系统和对话系统的专门测试
4. **性能测试** - API、数据库、前端的全面性能验证
5. **安全测试** - 认证、授权、数据保护的安全测试
6. **自动化策略** - CI/CD集成和持续测试

所有测试都基于真实的技术栈配置，确保测试环境与生产环境的一致性。开发团队应严格按照此策略实施测试，确保系统质量和可靠性。