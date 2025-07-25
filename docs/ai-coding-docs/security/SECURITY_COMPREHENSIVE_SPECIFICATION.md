# AI智能营养餐厅系统 - 完整安全规范

> **文档版本**: 3.0.0  
> **创建日期**: 2025-07-23  
> **文档状态**: ✅ 安全架构设计完成  
> **目标受众**: 安全工程师、架构师、开发团队

## 📋 目录

- [1. 安全架构总览](#1-安全架构总览)
- [2. 认证安全](#2-认证安全)
- [3. 授权与权限控制](#3-授权与权限控制)
- [4. 数据安全](#4-数据安全)
- [5. API安全](#5-api安全)
- [6. 支付安全](#6-支付安全)
- [7. 隐私保护](#7-隐私保护)
- [8. 安全监控与审计](#8-安全监控与审计)
- [9. 应急响应](#9-应急响应)
- [10. 合规要求](#10-合规要求)

---

## 1. 安全架构总览

### 1.1 安全设计原则

```yaml
零信任架构:
  - 假设网络始终不安全
  - 验证每个请求
  - 最小权限原则
  - 持续监控和验证

纵深防御:
  网络层: 防火墙、DDoS防护、WAF
  应用层: 认证、授权、输入验证
  数据层: 加密、脱敏、访问控制
  监控层: 日志审计、异常检测

安全开发生命周期:
  设计阶段: 威胁建模、安全架构设计
  开发阶段: 安全编码、静态分析
  测试阶段: 安全测试、渗透测试
  部署阶段: 安全配置、漏洞扫描
  运维阶段: 监控告警、应急响应
```

### 1.2 安全威胁矩阵

```yaml
OWASP Top 10 对应措施:
  A01 访问控制失效:
    - RBAC权限控制
    - JWT Token验证
    - 会话管理
    - 权限最小化

  A02 加密失效:
    - HTTPS/TLS 1.3
    - 数据库字段加密
    - 密码哈希存储
    - 敏感数据脱敏

  A03 注入攻击:
    - 参数化查询
    - 输入验证和清理
    - ORM使用
    - CSP策略

  A04 不安全设计:
    - 威胁建模
    - 安全架构设计
    - 代码审查
    - 安全测试

  A05 安全配置错误:
    - 最小化原则
    - 默认拒绝策略
    - 配置检查清单
    - 自动化配置管理

  A06 易受攻击的组件:
    - 依赖扫描
    - 定期更新
    - 组件库管理
    - 漏洞监控

  A07 身份认证失效:
    - 多因素认证
    - 强密码策略
    - 会话管理
    - 失败监控

  A08 软件和数据完整性失效:
    - 代码签名
    - 完整性检查
    - 供应链安全
    - CI/CD安全

  A09 安全日志记录失效:
    - 完整日志记录
    - 实时监控
    - 日志保护
    - 异常告警

  A10 服务端请求伪造:
    - URL白名单
    - 网络隔离
    - 请求验证
    - 响应过滤
```

---

## 2. 认证安全

### 2.1 多因素认证设计

```yaml
认证方式层次:
  第一层 - 知识因子:
    - 手机号 + 密码
    - 密码复杂度要求：8-32位，包含大小写字母、数字、特殊字符
    - 密码哈希：bcrypt，cost=12
    - 密码策略：不能重复最近5次密码

  第二层 - 持有因子:
    - 短信验证码（6位数字，5分钟有效）
    - 邮箱验证码（6位数字，10分钟有效）
    - 频率限制：同一手机号每分钟最多发送1次，每小时最多5次

  第三层 - 生物因子（可选）:
    - 指纹认证（移动端）
    - 面部识别（移动端）
    - 仅用于快速登录，不替代主要认证

强制MFA场景:
  - 新设备登录
  - 敏感操作（修改密码、绑定支付方式）
  - 管理员权限操作
  - 角色切换到高权限角色
```

### 2.2 JWT Token安全策略

```typescript
// JWT配置
interface JwtConfig {
  accessToken: {
    secret: string;          // 256位随机密钥
    expiresIn: '15m';        // 15分钟有效期
    algorithm: 'HS256';      // 签名算法
    issuer: 'nutrition-app'; // 发行者
    audience: 'mobile';      // 受众
  };
  
  refreshToken: {
    secret: string;          // 不同的密钥
    expiresIn: '7d';         // 7天有效期
    algorithm: 'HS256';
  };
}

// Token载荷结构
interface JwtPayload {
  userId: string;
  currentRole: string;
  permissions: string[];
  deviceId: string;        // 设备标识
  sessionId: string;       // 会话标识
  iat: number;            // 签发时间
  exp: number;            // 过期时间
  jti: string;            // Token唯一标识
}

// Token安全措施
class TokenSecurityService {
  // Token黑名单（Redis存储）
  private readonly blacklistedTokens = new Set<string>();
  
  async validateToken(token: string): Promise<JwtPayload> {
    // 1. 验证Token格式和签名
    const payload = this.jwtService.verify(token);
    
    // 2. 检查是否在黑名单中
    if (await this.isTokenBlacklisted(payload.jti)) {
      throw new UnauthorizedException('Token已失效');
    }
    
    // 3. 验证设备绑定
    const validDevice = await this.validateDevice(payload.userId, payload.deviceId);
    if (!validDevice) {
      throw new UnauthorizedException('设备验证失败');
    }
    
    // 4. 验证会话状态
    const sessionValid = await this.validateSession(payload.sessionId);
    if (!sessionValid) {
      throw new UnauthorizedException('会话已过期');
    }
    
    return payload;
  }
  
  async revokeToken(tokenId: string): Promise<void> {
    // 加入黑名单，设置过期时间
    await this.redisService.setex(`blacklist:${tokenId}`, 3600 * 24 * 7, '1');
  }
  
  async revokeAllUserTokens(userId: string): Promise<void> {
    // 撤销用户所有Token（如密码修改后）
    await this.redisService.del(`user_session:${userId}:*`);
  }
}
```

### 2.3 会话管理安全

```yaml
会话安全策略:
  会话标识:
    - 随机生成128位会话ID
    - 使用加密安全随机数生成器
    - 会话ID不包含用户信息

  会话存储:
    - Redis存储会话数据
    - 会话数据加密存储
    - 设置合理的过期时间

  会话保护:
    - HTTP Only Cookie（Web端）
    - Secure Cookie（HTTPS）
    - SameSite=Strict
    - 定期轮换会话ID

  会话监控:
    - 同一用户并发会话限制（最多5个）
    - 异常登录检测（地理位置、设备）
    - 会话活跃度监控
    - 自动登出机制

会话失效条件:
  - 用户主动登出
  - 会话超时（30分钟无操作）
  - 密码修改
  - 权限变更
  - 检测到异常行为
```

---

## 3. 授权与权限控制

### 3.1 RBAC权限模型

```typescript
// 权限验证装饰器
export function RequirePermissions(...permissions: string[]) {
  return applyDecorators(
    SetMetadata('permissions', permissions),
    UseGuards(AuthGuard, PermissionGuard)
  );
}

// 动态权限检查
export function RequireResourceAccess(resourceType: string) {
  return applyDecorators(
    SetMetadata('resourceType', resourceType),
    UseGuards(AuthGuard, ResourceAccessGuard)
  );
}

// 权限守卫实现
@Injectable()
export class PermissionGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private permissionService: PermissionService,
    private auditService: AuditService
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const requiredPermissions = this.reflector.get<string[]>('permissions', context.getHandler());
    if (!requiredPermissions) return true;

    const request = context.switchToHttp().getRequest();
    const user = request.user;
    
    try {
      // 获取用户当前角色权限
      const userPermissions = await this.permissionService.getUserPermissions(
        user.userId, 
        user.currentRole
      );

      // 检查权限
      const hasPermission = requiredPermissions.every(permission => 
        userPermissions.includes(permission)
      );

      // 记录权限检查结果
      await this.auditService.logPermissionCheck({
        userId: user.userId,
        role: user.currentRole,
        requiredPermissions,
        granted: hasPermission,
        resource: request.url,
        method: request.method,
        timestamp: new Date(),
      });

      return hasPermission;
    } catch (error) {
      // 权限检查失败，记录并拒绝访问
      await this.auditService.logSecurityEvent({
        type: 'PERMISSION_CHECK_FAILED',
        userId: user.userId,
        error: error.message,
        timestamp: new Date(),
      });
      
      return false;
    }
  }
}

// 资源访问控制
@Injectable()
export class ResourceAccessGuard implements CanActivate {
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    const resourceType = this.reflector.get<string>('resourceType', context.getHandler());
    const resourceId = request.params.id;

    // 检查用户是否有权访问特定资源
    return await this.checkResourceAccess(
      user.userId,
      user.currentRole,
      resourceType,
      resourceId,
      request.method
    );
  }

  private async checkResourceAccess(
    userId: string,
    role: string,
    resourceType: string,
    resourceId: string,
    method: string
  ): Promise<boolean> {
    switch (resourceType) {
      case 'nutrition_profile':
        return this.checkNutritionProfileAccess(userId, role, resourceId, method);
      case 'order':
        return this.checkOrderAccess(userId, role, resourceId, method);
      case 'restaurant':
        return this.checkRestaurantAccess(userId, role, resourceId, method);
      default:
        return false;
    }
  }
}
```

### 3.2 API权限矩阵

```yaml
权限级别定义:
  L0 - 公开访问: 无需认证
  L1 - 用户认证: 需要有效Token
  L2 - 角色权限: 需要特定角色
  L3 - 资源权限: 需要资源所有权
  L4 - 管理权限: 需要管理员权限

API权限配置:
  # 用户管理API
  GET /api/v1/users/me: L1
  PUT /api/v1/users/me: L1
  GET /api/v1/users/:id: L2[admin] || L3[self]
  DELETE /api/v1/users/:id: L4[super_admin]

  # 营养档案API  
  GET /api/v1/nutrition/profiles/me: L1
  POST /api/v1/nutrition/profiles: L1
  PUT /api/v1/nutrition/profiles/:id: L3[owner] || L2[nutritionist]
  GET /api/v1/nutrition/profiles/:id: L3[owner] || L2[nutritionist] || L4[admin]

  # 订单API
  POST /api/v1/orders: L1
  GET /api/v1/orders/me: L1
  GET /api/v1/orders/:id: L3[owner] || L2[restaurant_owner] || L4[admin]
  PUT /api/v1/orders/:id/status: L2[restaurant_owner] || L4[admin]

  # 餐厅管理API
  POST /api/v1/restaurants: L2[restaurant_owner]
  PUT /api/v1/restaurants/:id: L3[owner] || L4[admin]
  DELETE /api/v1/restaurants/:id: L3[owner] || L4[admin]

  # 管理API
  GET /api/v1/admin/users: L4[admin]
  GET /api/v1/admin/analytics: L4[admin]
  POST /api/v1/admin/system/backup: L4[super_admin]
```

---

## 4. 数据安全

### 4.1 数据加密策略

```yaml
传输加密:
  协议: TLS 1.3
  密码套件: 仅支持强加密套件
  证书: EV SSL证书，定期更新
  HSTS: 强制HTTPS，max-age=31536000
  
  移动端额外保护:
    - SSL Pinning
    - 证书透明度检查
    - 中间人攻击检测

存储加密:
  数据库级别:
    - 透明数据加密（TDE）
    - 备份加密
    - 日志文件加密
    
  字段级别加密:
    敏感字段: AES-256-GCM加密
    加密字段列表:
      - 真实姓名
      - 身份证号
      - 银行卡号
      - 详细地址
      - 健康信息
      - 支付信息
    
  密钥管理:
    - 密钥轮换（每90天）
    - 硬件安全模块（HSM）
    - 分层密钥架构
    - 密钥托管备份

应用层加密:
  密码存储: bcrypt, cost=12
  敏感配置: 环境变量加密
  日志脱敏: 自动识别和脱敏
  文件存储: 上传文件加密存储
```

### 4.2 数据脱敏规则

```typescript
// 数据脱敏服务
@Injectable()
export class DataMaskingService {
  
  // 手机号脱敏：139****8888
  maskPhone(phone: string): string {
    if (!phone || phone.length !== 11) return phone;
    return phone.substring(0, 3) + '****' + phone.substring(7);
  }

  // 邮箱脱敏：u***@example.com
  maskEmail(email: string): string {
    if (!email || !email.includes('@')) return email;
    const [local, domain] = email.split('@');
    return local.charAt(0) + '***@' + domain;
  }

  // 姓名脱敏：张*明
  maskName(name: string): string {
    if (!name || name.length < 2) return name;
    return name.charAt(0) + '*'.repeat(name.length - 2) + name.charAt(name.length - 1);
  }

  // 身份证脱敏：110***********1234
  maskIdCard(idCard: string): string {
    if (!idCard || idCard.length !== 18) return idCard;
    return idCard.substring(0, 3) + '*'.repeat(11) + idCard.substring(14);
  }

  // 银行卡脱敏：6222 **** **** 1234
  maskBankCard(cardNumber: string): string {
    if (!cardNumber || cardNumber.length < 12) return cardNumber;
    return cardNumber.substring(0, 4) + ' **** **** ' + cardNumber.substring(cardNumber.length - 4);
  }

  // 地址脱敏：北京市朝阳区***
  maskAddress(address: string): string {
    if (!address || address.length < 6) return address;
    return address.substring(0, 6) + '***';
  }

  // 自动脱敏对象
  maskObject<T extends object>(obj: T, maskingRules: MaskingRules): T {
    const masked = { ...obj };
    
    for (const [field, rule] of Object.entries(maskingRules)) {
      if (masked[field]) {
        switch (rule.type) {
          case 'phone':
            masked[field] = this.maskPhone(masked[field]);
            break;
          case 'email':
            masked[field] = this.maskEmail(masked[field]);
            break;
          case 'name':
            masked[field] = this.maskName(masked[field]);
            break;
          case 'idCard':
            masked[field] = this.maskIdCard(masked[field]);
            break;
          case 'bankCard':
            masked[field] = this.maskBankCard(masked[field]);
            break;
          case 'address':
            masked[field] = this.maskAddress(masked[field]);
            break;
          case 'custom':
            masked[field] = rule.maskFn(masked[field]);
            break;
        }
      }
    }
    
    return masked;
  }
}

// 脱敏规则配置
const userDataMaskingRules: MaskingRules = {
  phone: { type: 'phone' },
  email: { type: 'email' },
  realName: { type: 'name' },
  address: { type: 'address' },
  idCard: { type: 'idCard' },
};

// 自动脱敏装饰器
export function AutoMask(rules: MaskingRules) {
  return function (target: any, propertyName: string, descriptor: PropertyDescriptor) {
    const method = descriptor.value;
    
    descriptor.value = async function (...args: any[]) {
      const result = await method.apply(this, args);
      
      if (result && typeof result === 'object') {
        const maskingService = new DataMaskingService();
        return maskingService.maskObject(result, rules);
      }
      
      return result;
    };
  };
}

// 使用示例
@Controller('users')
export class UserController {
  
  @Get('me')
  @AutoMask(userDataMaskingRules)
  async getCurrentUser(@Req() request): Promise<UserDto> {
    // 返回的用户数据会自动脱敏
    return this.userService.findById(request.user.userId);
  }
}
```

### 4.3 数据访问审计

```yaml
审计范围:
  数据读取:
    - 用户查看敏感信息
    - 管理员查看用户数据
    - 批量数据导出
    - 数据库直接查询

  数据修改:
    - 个人信息修改
    - 营养档案更新
    - 权限变更
    - 数据删除操作

  系统操作:
    - 登录登出
    - 权限变更
    - 配置修改
    - 系统维护操作

审计日志格式:
  timestamp: ISO 8601格式
  userId: 操作用户ID
  action: 操作类型
  resource: 资源类型和ID
  details: 操作详情
  ipAddress: 客户端IP
  userAgent: 用户代理
  result: 操作结果
  duration: 操作耗时

审计存储:
  - 独立的审计数据库
  - 日志不可篡改性
  - 定期备份和归档
  - 长期保存（7年）
```

---

## 5. API安全

### 5.1 输入验证与过滤

```typescript
// 统一输入验证
import { IsPhoneNumber, IsEmail, IsString, Length, Matches, IsOptional } from 'class-validator';
import { Transform } from 'class-transformer';
import { sanitize } from 'class-sanitizer';

export class CreateUserDto {
  @IsPhoneNumber('CN')
  @Transform(({ value }) => value?.replace(/\s+/g, '')) // 移除空格
  phone: string;

  @IsEmail()
  @IsOptional()
  @Transform(({ value }) => value?.toLowerCase())
  email?: string;

  @IsString()
  @Length(8, 32)
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/, {
    message: '密码必须包含大小写字母、数字和特殊字符'
  })
  password: string;

  @IsString()
  @Length(2, 20)
  @Matches(/^[\u4e00-\u9fa5a-zA-Z0-9_]+$/, {
    message: '昵称只能包含中文、英文、数字和下划线'
  })
  @sanitize('escape') // 转义HTML字符
  nickname: string;
}

// SQL注入防护
@Injectable()
export class SqlInjectionGuard implements CanActivate {
  private readonly sqlInjectionPatterns = [
    /(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE)?|INSERT( +INTO)?|MERGE|SELECT|UPDATE|UNION( +ALL)?)\b)/gi,
    /((\%3D)|(=))[^\n]*((\%27)|(\')|(\-\-)|(\%3B)|(;))/gi,
    /\w*((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))/gi,
    /((\%27)|(\'))union/gi,
  ];

  canActivate(context: ExecutionContext): boolean {
    const request = context.switchToHttp().getRequest();
    
    // 检查所有输入参数
    const allParams = { ...request.params, ...request.query, ...request.body };
    
    for (const [key, value] of Object.entries(allParams)) {
      if (typeof value === 'string') {
        for (const pattern of this.sqlInjectionPatterns) {
          if (pattern.test(value)) {
            throw new BadRequestException(`检测到可疑的SQL注入尝试: ${key}`);
          }
        }
      }
    }
    
    return true;
  }
}

// XSS防护
@Injectable()
export class XssProtectionInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    
    // 清理请求数据
    this.sanitizeObject(request.body);
    this.sanitizeObject(request.query);
    this.sanitizeObject(request.params);
    
    return next.handle().pipe(
      map(data => {
        // 清理响应数据中的HTML标签
        return this.sanitizeResponseData(data);
      })
    );
  }

  private sanitizeObject(obj: any): void {
    if (!obj) return;
    
    for (const key in obj) {
      if (typeof obj[key] === 'string') {
        obj[key] = this.sanitizeString(obj[key]);
      } else if (typeof obj[key] === 'object') {
        this.sanitizeObject(obj[key]);
      }
    }
  }

  private sanitizeString(str: string): string {
    return str
      .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '') // 移除script标签
      .replace(/<iframe\b[^<]*(?:(?!<\/iframe>)<[^<]*)*<\/iframe>/gi, '') // 移除iframe标签
      .replace(/javascript:/gi, '') // 移除javascript:
      .replace(/on\w+\s*=/gi, '') // 移除事件处理器
      .trim();
  }

  private sanitizeResponseData(data: any): any {
    if (typeof data === 'string') {
      return this.sanitizeString(data);
    } else if (Array.isArray(data)) {
      return data.map(item => this.sanitizeResponseData(item));
    } else if (typeof data === 'object' && data !== null) {
      const sanitized = {};
      for (const key in data) {
        sanitized[key] = this.sanitizeResponseData(data[key]);
      }
      return sanitized;
    }
    return data;
  }
}
```

### 5.2 API限流与熔断

```typescript
// 限流策略
@Injectable()
export class RateLimitService {
  constructor(private readonly redisService: RedisService) {}

  async checkRateLimit(
    identifier: string,
    action: string,
    limit: number,
    windowMs: number
  ): Promise<boolean> {
    const key = `rate_limit:${action}:${identifier}`;
    const current = await this.redisService.incr(key);
    
    if (current === 1) {
      await this.redisService.expire(key, Math.ceil(windowMs / 1000));
    }
    
    return current <= limit;
  }

  async getRemainingRequests(
    identifier: string,
    action: string,
    limit: number
  ): Promise<number> {
    const key = `rate_limit:${action}:${identifier}`;
    const current = await this.redisService.get(key);
    return Math.max(0, limit - (parseInt(current) || 0));
  }
}

// 限流装饰器
export function RateLimit(action: string, limit: number, windowMs: number) {
  return applyDecorators(
    SetMetadata('rateLimit', { action, limit, windowMs }),
    UseGuards(RateLimitGuard)
  );
}

@Injectable()
export class RateLimitGuard implements CanActivate {
  constructor(
    private reflector: Reflector,
    private rateLimitService: RateLimitService
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const rateLimitConfig = this.reflector.get('rateLimit', context.getHandler());
    if (!rateLimitConfig) return true;

    const request = context.switchToHttp().getRequest();
    const response = context.switchToHttp().getResponse();
    
    // 使用用户ID或IP作为标识符
    const identifier = request.user?.userId || request.ip;
    
    const { action, limit, windowMs } = rateLimitConfig;
    
    const allowed = await this.rateLimitService.checkRateLimit(
      identifier,
      action,
      limit,
      windowMs
    );

    if (!allowed) {
      const remaining = await this.rateLimitService.getRemainingRequests(
        identifier,
        action,
        limit
      );
      
      response.set({
        'X-RateLimit-Limit': limit.toString(),
        'X-RateLimit-Remaining': remaining.toString(),
        'X-RateLimit-Reset': new Date(Date.now() + windowMs).toISOString(),
      });
      
      throw new TooManyRequestsException('请求过于频繁，请稍后再试');
    }

    return true;
  }
}

// 使用示例
@Controller('auth')
export class AuthController {
  
  @Post('login')
  @RateLimit('login', 5, 15 * 60 * 1000) // 15分钟内最多5次登录尝试
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('send-code')
  @RateLimit('send_code', 1, 60 * 1000) // 每分钟最多发送1次验证码
  async sendVerificationCode(@Body() dto: SendCodeDto) {
    return this.authService.sendVerificationCode(dto);
  }
}

// 熔断器实现
@Injectable()
export class CircuitBreakerService {
  private circuits = new Map<string, CircuitState>();

  async execute<T>(
    serviceId: string,
    operation: () => Promise<T>,
    options: CircuitBreakerOptions = {}
  ): Promise<T> {
    const circuit = this.getCircuit(serviceId, options);
    
    if (circuit.state === 'OPEN') {
      if (Date.now() - circuit.lastFailureTime < circuit.timeout) {
        throw new ServiceUnavailableException(`服务 ${serviceId} 暂时不可用`);
      } else {
        circuit.state = 'HALF_OPEN';
      }
    }

    try {
      const result = await operation();
      this.onSuccess(circuit);
      return result;
    } catch (error) {
      this.onFailure(circuit);
      throw error;
    }
  }

  private onSuccess(circuit: CircuitState): void {
    circuit.failureCount = 0;
    circuit.state = 'CLOSED';
  }

  private onFailure(circuit: CircuitState): void {
    circuit.failureCount++;
    circuit.lastFailureTime = Date.now();
    
    if (circuit.failureCount >= circuit.failureThreshold) {
      circuit.state = 'OPEN';
    }
  }
}
```

### 5.3 CSRF和CORS防护

```yaml
CSRF防护:
  策略: Double Submit Cookie + SameSite
  
  实现:
    - 生成随机CSRF token
    - 同时设置在Cookie和Header中
    - 服务端验证两个值是否一致
    - SameSite=Strict防止跨站请求

  配置:
    csrfToken:
      secret: 256位随机密钥
      expiry: 24小时
      httpOnly: false  # JavaScript需要读取
      secure: true     # 仅HTTPS传输
      sameSite: 'strict'

CORS配置:
  生产环境:
    origin: 
      - https://app.nutrition.com
      - https://admin.nutrition.com
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH']
    allowedHeaders: 
      - 'Content-Type'
      - 'Authorization'
      - 'X-CSRF-Token'
      - 'X-Requested-With'
    credentials: true
    maxAge: 86400  # 24小时预检缓存

  开发环境:
    origin: true  # 允许所有源（仅开发环境）
    credentials: true
```

---

## 6. 支付安全

### 6.1 支付流程安全设计

```yaml
支付安全架构:
  支付方式:
    - 微信支付（主要）
    - 支付宝（备选）
    - 银联支付（企业用户）
    
  安全措施:
    - PCI DSS合规
    - 支付数据不存储
    - 支付令牌化
    - 实时风控

支付流程:
  1. 订单创建:
     - 订单金额验证
     - 商品信息验证
     - 用户权限检查
     - 生成支付订单号

  2. 支付发起:
     - 调用第三方支付API
     - 获取支付URL/二维码
     - 设置支付超时时间
     - 记录支付请求日志

  3. 支付回调:
     - 验证回调签名
     - 验证订单状态
     - 防重复处理
     - 更新订单状态

  4. 支付查询:
     - 定时查询支付状态
     - 处理支付异常
     - 支付结果同步
     - 发送支付通知

风控规则:
  用户维度:
    - 单日支付限额：个人5000元，企业50000元
    - 单笔支付限额：个人1000元，企业10000元
    - 异常登录后24小时内限制支付
    - 新注册用户7天内支付限额500元

  订单维度:
    - 订单金额与商品价格一致性检查
    - 连续重复订单检测
    - 异常订单模式识别
    - 高风险商品特殊审核

  设备维度:
    - 同一设备单日支付次数限制
    - 异常设备环境检测
    - 设备指纹风险评估
    - 多账户共用设备警告
```

### 6.2 支付数据安全

```typescript
// 支付服务安全实现
@Injectable()
export class PaymentSecurityService {
  constructor(
    private readonly cryptoService: CryptoService,
    private readonly auditService: AuditService,
    private readonly riskControlService: RiskControlService
  ) {}

  async createPaymentOrder(orderData: CreatePaymentOrderDto): Promise<PaymentOrder> {
    // 1. 风险评估
    const riskScore = await this.riskControlService.assessPaymentRisk({
      userId: orderData.userId,
      amount: orderData.amount,
      deviceId: orderData.deviceId,
      ipAddress: orderData.ipAddress
    });

    if (riskScore > 0.8) {
      throw new ForbiddenException('支付风险评估未通过，请联系客服');
    }

    // 2. 订单数据验证
    await this.validateOrderData(orderData);

    // 3. 生成支付订单
    const paymentOrder = await this.createSecurePaymentOrder(orderData);

    // 4. 记录支付审计日志
    await this.auditService.logPaymentEvent({
      type: 'PAYMENT_ORDER_CREATED',
      orderId: paymentOrder.id,
      userId: orderData.userId,
      amount: orderData.amount,
      riskScore,
      timestamp: new Date()
    });

    return paymentOrder;
  }

  async handlePaymentCallback(callbackData: any): Promise<void> {
    try {
      // 1. 验证回调签名
      const isValidSignature = await this.verifyCallbackSignature(callbackData);
      if (!isValidSignature) {
        throw new UnauthorizedException('支付回调签名验证失败');
      }

      // 2. 防重放攻击
      const isReplay = await this.checkReplayAttack(callbackData);
      if (isReplay) {
        throw new BadRequestException('重复的支付回调');
      }

      // 3. 处理支付结果
      await this.processPaymentResult(callbackData);

    } catch (error) {
      // 记录支付异常
      await this.auditService.logPaymentEvent({
        type: 'PAYMENT_CALLBACK_ERROR',
        error: error.message,
        callbackData: this.maskSensitiveData(callbackData),
        timestamp: new Date()
      });
      
      throw error;
    }
  }

  private async validateOrderData(orderData: CreatePaymentOrderDto): Promise<void> {
    // 验证订单金额
    if (orderData.amount <= 0 || orderData.amount > 100000) {
      throw new BadRequestException('订单金额超出允许范围');
    }

    // 验证商品信息
    const items = await this.getOrderItems(orderData.orderId);
    const calculatedAmount = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    
    if (Math.abs(calculatedAmount - orderData.amount) > 0.01) {
      throw new BadRequestException('订单金额与商品价格不匹配');
    }

    // 验证用户权限
    const user = await this.getUserById(orderData.userId);
    if (!user || !user.isActive) {
      throw new ForbiddenException('用户状态异常，无法支付');
    }
  }

  private async verifyCallbackSignature(callbackData: any): Promise<boolean> {
    const { signature, ...dataToVerify } = callbackData;
    
    // 根据支付平台的签名算法验证
    const expectedSignature = await this.cryptoService.generateSignature(
      dataToVerify,
      this.getPaymentPlatformSecret(callbackData.platform)
    );
    
    return this.cryptoService.verifySignature(signature, expectedSignature);
  }

  private async checkReplayAttack(callbackData: any): Promise<boolean> {
    const key = `payment_callback:${callbackData.platform}:${callbackData.tradeNo}`;
    const exists = await this.redisService.exists(key);
    
    if (exists) {
      return true; // 重放攻击
    }
    
    // 设置回调记录，防止重放
    await this.redisService.setex(key, 3600, '1'); // 1小时过期
    return false;
  }

  private maskSensitiveData(data: any): any {
    const sensitiveFields = ['bankAccount', 'cardNumber', 'cvv', 'signature'];
    const masked = { ...data };
    
    sensitiveFields.forEach(field => {
      if (masked[field]) {
        masked[field] = '***';
      }
    });
    
    return masked;
  }
}

// 支付风控服务
@Injectable()
export class PaymentRiskControlService {
  async assessPaymentRisk(riskData: PaymentRiskData): Promise<number> {
    let riskScore = 0;

    // 用户行为风险
    riskScore += await this.assessUserBehaviorRisk(riskData.userId);
    
    // 设备风险
    riskScore += await this.assessDeviceRisk(riskData.deviceId);
    
    // 金额风险
    riskScore += await this.assessAmountRisk(riskData.amount, riskData.userId);
    
    // 地理位置风险
    riskScore += await this.assessLocationRisk(riskData.ipAddress, riskData.userId);

    return Math.min(riskScore, 1.0); // 确保风险分数在0-1之间
  }

  private async assessUserBehaviorRisk(userId: string): Promise<number> {
    // 检查用户最近的支付行为
    const recentPayments = await this.getRecentPayments(userId, 24); // 24小时内
    
    let risk = 0;
    
    // 频率风险：24小时内支付次数过多
    if (recentPayments.length > 10) {
      risk += 0.3;
    }
    
    // 金额风险：支付金额异常
    const avgAmount = recentPayments.reduce((sum, p) => sum + p.amount, 0) / recentPayments.length;
    const userHistoryAvg = await this.getUserHistoryAvgAmount(userId);
    
    if (avgAmount > userHistoryAvg * 3) {
      risk += 0.2;
    }
    
    return risk;
  }

  private async assessDeviceRisk(deviceId: string): Promise<number> {
    // 检查设备风险
    const deviceInfo = await this.getDeviceInfo(deviceId);
    
    let risk = 0;
    
    // 新设备风险
    if (deviceInfo.isNew) {
      risk += 0.1;
    }
    
    // 设备异常风险
    if (deviceInfo.isJailbroken || deviceInfo.isEmulator) {
      risk += 0.4;
    }
    
    return risk;
  }
}
```

### 6.3 支付合规要求

```yaml
PCI DSS合规:
  要求1: 网络安全
    - 防火墙配置
    - 网络分段
    - DMZ隔离

  要求2: 默认密码
    - 更改默认密码
    - 删除默认账户
    - 禁用不必要服务

  要求3: 存储保护
    - 不存储支付卡数据
    - 使用代币化
    - 加密传输

  要求4: 传输加密
    - TLS 1.2以上
    - 强加密套件
    - 证书管理

  要求5: 防病毒
    - 防病毒软件
    - 定期更新
    - 实时监控

  要求6: 安全开发
    - 安全编码标准
    - 代码审查
    - 漏洞管理

  要求7: 访问控制
    - 最小权限原则
    - 角色权限管理
    - 访问审计

  要求8: 身份管理
    - 唯一用户标识
    - 强认证
    - 定期审查

  要求9: 物理安全
    - 物理访问控制
    - 介质销毁
    - 环境监控

  要求10: 监控日志
    - 完整日志记录
    - 日志保护
    - 定期审查

  要求11: 安全测试
    - 漏洞扫描
    - 渗透测试
    - 网络监控

  要求12: 安全策略
    - 信息安全策略
    - 安全培训
    - 应急响应

反洗钱(AML):
  客户识别:
    - 实名认证
    - 身份验证
    - 尽职调查

  交易监控:
    - 可疑交易识别
    - 大额交易报告
    - 交易模式分析

  记录保存:
    - 交易记录保存5年
    - 客户信息更新
    - 审计跟踪
```

---

## 7. 隐私保护

### 7.1 GDPR合规实施

```yaml
数据主体权利:
  访问权:
    - 提供个人数据副本
    - 30天内响应请求
    - 免费提供一次
    - 机器可读格式

  更正权:
    - 允许修改不准确数据
    - 主动提供更正途径
    - 及时处理更正请求
    - 通知第三方更正

  删除权(被遗忘权):
    - 用户可请求删除数据
    - 评估删除请求合法性
    - 保留必要的业务数据
    - 通知数据处理方

  限制处理权:
    - 暂停数据处理
    - 保留数据但不使用
    - 特定条件下限制

  数据可携带权:
    - 结构化数据格式
    - 机器可读格式
    - 便于数据迁移
    - 30天内提供

  反对权:
    - 反对特定处理活动
    - 营销目的处理
    - 自动化决策

合法性基础:
  同意:
    - 明确具体的同意
    - 自由给予的同意
    - 知情同意
    - 可撤回的同意

  合同履行:
    - 履行合同必需
    - 订单处理
    - 服务提供

  法律义务:
    - 遵守法律要求
    - 税务记录
    - 反洗钱要求

  重要利益:
    - 保护生命安全
    - 紧急情况处理

  公共利益:
    - 公共卫生
    - 食品安全

  合法利益:
    - 欺诈防范
    - 网络安全
    - 业务改进
```

### 7.2 隐私设计原则

```typescript
// 隐私设计实现
@Injectable()
export class PrivacyService {
  
  // 数据最小化
  async collectMinimalData(userData: any): Promise<any> {
    const minimumRequiredFields = [
      'phone', 'nickname', 'ageGroup', 'gender'
    ];
    
    const filteredData = {};
    minimumRequiredFields.forEach(field => {
      if (userData[field] !== undefined) {
        filteredData[field] = userData[field];
      }
    });
    
    return filteredData;
  }

  // 目的限定
  async checkDataUsagePurpose(userId: string, purpose: string): Promise<boolean> {
    const userConsents = await this.getUserConsents(userId);
    
    const allowedPurposes = {
      'service_provision': ['essential', 'service_improvement'],
      'marketing': ['marketing_consent'],
      'analytics': ['analytics_consent'],
      'research': ['research_consent']
    };
    
    return allowedPurposes[purpose]?.some(consent => 
      userConsents[consent] === true
    ) || false;
  }

  // 存储限制
  async cleanupExpiredData(): Promise<void> {
    const retentionPolicies = {
      'user_activity_logs': 365, // 1年
      'marketing_data': 1095,    // 3年
      'financial_records': 2555, // 7年
      'session_data': 30,        // 30天
    };

    for (const [dataType, retentionDays] of Object.entries(retentionPolicies)) {
      const cutoffDate = new Date();
      cutoffDate.setDate(cutoffDate.getDate() - retentionDays);
      
      await this.deleteExpiredData(dataType, cutoffDate);
    }
  }

  // 透明度
  async generatePrivacyReport(userId: string): Promise<PrivacyReport> {
    const userData = await this.getUserData(userId);
    const dataProcessingActivities = await this.getDataProcessingActivities(userId);
    const consents = await this.getUserConsents(userId);
    const dataSharing = await this.getDataSharingInfo(userId);

    return {
      personalData: this.maskSensitiveData(userData),
      processingActivities: dataProcessingActivities,
      consents: consents,
      dataSharing: dataSharing,
      retentionPeriods: await this.getRetentionPeriods(),
      contactInfo: this.getDataProtectionOfficerContact(),
      generatedAt: new Date(),
    };
  }

  // 用户控制
  async updatePrivacySettings(userId: string, settings: PrivacySettings): Promise<void> {
    // 验证设置有效性
    this.validatePrivacySettings(settings);
    
    // 更新用户同意状态
    await this.updateUserConsents(userId, settings.consents);
    
    // 更新数据处理偏好
    await this.updateDataProcessingPreferences(userId, settings.dataProcessing);
    
    // 应用营销偏好
    await this.updateMarketingPreferences(userId, settings.marketing);
    
    // 记录隐私设置变更
    await this.logPrivacySettingsChange(userId, settings);
  }

  // 数据安全
  async encryptPersonalData(data: any): Promise<any> {
    const sensitiveFields = [
      'realName', 'idCard', 'address', 'medicalInfo', 'financialInfo'
    ];
    
    const encrypted = { ...data };
    
    for (const field of sensitiveFields) {
      if (encrypted[field]) {
        encrypted[field] = await this.cryptoService.encrypt(encrypted[field]);
      }
    }
    
    return encrypted;
  }

  // 责任可证明
  async generateComplianceReport(): Promise<ComplianceReport> {
    return {
      dataInventory: await this.generateDataInventory(),
      processingActivities: await this.getProcessingActivitiesRegister(),
      legalBases: await this.getLegalBasesDocumentation(),
      securityMeasures: await this.getSecurityMeasuresDocumentation(),
      dataTransfers: await this.getDataTransferDocumentation(),
      breachLog: await this.getDataBreachLog(),
      assessments: await this.getDataProtectionImpactAssessments(),
      policies: await this.getPrivacyPoliciesVersions(),
      training: await this.getStaffTrainingRecords(),
      audits: await this.getPrivacyAuditReports(),
    };
  }
}

// 同意管理
@Injectable()
export class ConsentManagementService {
  
  async recordConsent(consentData: ConsentRecord): Promise<void> {
    // 验证同意有效性
    this.validateConsent(consentData);
    
    // 记录同意
    await this.saveConsentRecord({
      userId: consentData.userId,
      purpose: consentData.purpose,
      granted: consentData.granted,
      timestamp: new Date(),
      version: consentData.policyVersion,
      method: consentData.method, // 'explicit', 'implicit', 'opt-out'
      ipAddress: consentData.ipAddress,
      userAgent: consentData.userAgent,
      evidence: consentData.evidence,
    });
    
    // 触发数据处理变更
    if (consentData.granted) {
      await this.enableDataProcessing(consentData.userId, consentData.purpose);
    } else {
      await this.disableDataProcessing(consentData.userId, consentData.purpose);
    }
  }

  async withdrawConsent(userId: string, purpose: string): Promise<void> {
    // 记录同意撤回
    await this.recordConsent({
      userId,
      purpose,
      granted: false,
      policyVersion: await this.getCurrentPolicyVersion(),
      method: 'explicit',
      timestamp: new Date(),
    });
    
    // 停止相关数据处理
    await this.stopDataProcessing(userId, purpose);
    
    // 通知相关系统
    await this.notifyConsentWithdrawal(userId, purpose);
  }

  private validateConsent(consentData: ConsentRecord): void {
    if (!consentData.userId || !consentData.purpose) {
      throw new BadRequestException('同意记录缺少必要信息');
    }
    
    if (consentData.granted && !consentData.evidence) {
      throw new BadRequestException('明确同意需要提供证据');
    }
    
    // 检查同意是否自由给予
    if (this.isConsentCoerced(consentData)) {
      throw new BadRequestException('同意不能是强制的');
    }
  }
}
```

### 7.3 数据跨境传输

```yaml
数据本地化:
  中国用户数据:
    - 存储在中国境内
    - 使用国内云服务
    - 遵守《数据安全法》
    - 遵守《个人信息保护法》

  数据出境评估:
    评估要素:
      - 数据重要程度
      - 出境目的和范围
      - 境外接收方情况
      - 数据出境风险

    出境机制:
      - 数据出境安全评估
      - 个人信息保护认证
      - 标准合同条款
      - 其他法定条件

传输保护措施:
  技术保护:
    - 端到端加密
    - 数据传输加密
    - 访问控制
    - 数据脱敏

  法律保护:
    - 数据处理协议
    - 数据主体权利保护
    - 监管合规承诺
    - 争议解决机制

  监控措施:
    - 传输日志记录
    - 访问行为监控
    - 异常活动检测
    - 定期合规审计
```

---

## 8. 安全监控与审计

### 8.1 安全事件监控

```typescript
// 安全事件监控服务
@Injectable()
export class SecurityMonitoringService {
  constructor(
    private readonly logService: LogService,
    private readonly alertService: AlertService,
    private readonly threatDetectionService: ThreatDetectionService
  ) {}

  async monitorSecurityEvents(): Promise<void> {
    // 启动各种安全监控
    await Promise.all([
      this.monitorFailedLogins(),
      this.monitorUnauthorizedAccess(),
      this.monitorDataAccess(),
      this.monitorSystemAnomalies(),
      this.monitorNetworkTraffic(),
    ]);
  }

  // 监控登录失败
  private async monitorFailedLogins(): Promise<void> {
    const failedLogins = await this.getRecentFailedLogins(5); // 5分钟内
    
    // 检测暴力破解攻击
    const attackPatterns = this.detectBruteForceAttacks(failedLogins);
    
    for (const pattern of attackPatterns) {
      if (pattern.attempts > 10) {
        await this.handleSecurityIncident({
          type: 'BRUTE_FORCE_ATTACK',
          severity: 'HIGH',
          source: pattern.ipAddress,
          details: `IP ${pattern.ipAddress} 在 ${pattern.timeWindow} 内尝试登录 ${pattern.attempts} 次`,
          affectedUsers: pattern.targetUsers,
          timestamp: new Date(),
        });
        
        // 自动封锁IP
        await this.blockIpAddress(pattern.ipAddress, 3600); // 1小时
      }
    }
  }

  // 监控未授权访问
  private async monitorUnauthorizedAccess(): Promise<void> {
    const unauthorizedAttempts = await this.getUnauthorizedAccessAttempts(10); // 10分钟内
    
    for (const attempt of unauthorizedAttempts) {
      await this.analyzeUnauthorizedAccess(attempt);
    }
  }

  // 监控敏感数据访问
  private async monitorDataAccess(): Promise<void> {
    const sensitiveDataAccess = await this.getSensitiveDataAccess(15); // 15分钟内
    
    for (const access of sensitiveDataAccess) {
      // 检测异常访问模式
      const isAnomalous = await this.detectAnomalousDataAccess(access);
      
      if (isAnomalous) {
        await this.handleSecurityIncident({
          type: 'SUSPICIOUS_DATA_ACCESS',
          severity: 'MEDIUM',
          userId: access.userId,
          details: `用户 ${access.userId} 的数据访问模式异常`,
          dataAccessed: access.resources,
          timestamp: new Date(),
        });
      }
    }
  }

  // 处理安全事件
  private async handleSecurityIncident(incident: SecurityIncident): Promise<void> {
    // 记录安全事件
    await this.logService.logSecurityIncident(incident);
    
    // 根据严重级别采取措施
    switch (incident.severity) {
      case 'CRITICAL':
        await this.handleCriticalIncident(incident);
        break;
      case 'HIGH':
        await this.handleHighIncident(incident);
        break;
      case 'MEDIUM':
        await this.handleMediumIncident(incident);
        break;
      case 'LOW':
        await this.handleLowIncident(incident);
        break;
    }
    
    // 发送告警
    await this.alertService.sendSecurityAlert(incident);
  }

  private async detectAnomalousDataAccess(access: DataAccessEvent): Promise<boolean> {
    // 用户历史行为分析
    const userBehavior = await this.getUserBehaviorProfile(access.userId);
    
    // 检查访问时间异常
    const timeAnomaly = this.isAccessTimeAnomalous(access.timestamp, userBehavior.normalHours);
    
    // 检查访问频率异常
    const frequencyAnomaly = await this.isAccessFrequencyAnomalous(access.userId, access.timestamp);
    
    // 检查访问资源异常
    const resourceAnomaly = this.isAccessResourceAnomalous(access.resources, userBehavior.normalResources);
    
    // 检查地理位置异常
    const locationAnomaly = await this.isAccessLocationAnomalous(access.ipAddress, userBehavior.normalLocations);
    
    return timeAnomaly || frequencyAnomaly || resourceAnomaly || locationAnomaly;
  }
}

// 威胁检测服务
@Injectable()
export class ThreatDetectionService {
  
  async detectThreats(events: SecurityEvent[]): Promise<ThreatDetectionResult[]> {
    const threats: ThreatDetectionResult[] = [];
    
    // SQL注入检测
    threats.push(...await this.detectSqlInjection(events));
    
    // XSS攻击检测
    threats.push(...await this.detectXssAttacks(events));
    
    // CSRF攻击检测
    threats.push(...await this.detectCsrfAttacks(events));
    
    // 账户接管检测
    threats.push(...await this.detectAccountTakeover(events));
    
    // 数据泄露检测
    threats.push(...await this.detectDataBreach(events));
    
    // 内部威胁检测
    threats.push(...await this.detectInsiderThreats(events));
    
    return threats;
  }

  private async detectSqlInjection(events: SecurityEvent[]): Promise<ThreatDetectionResult[]> {
    const sqlInjectionPatterns = [
      /(\b(SELECT|INSERT|UPDATE|DELETE|DROP|CREATE|ALTER|EXEC|UNION)\b)/gi,
      /((\%3D)|(=))[^\n]*((\%27)|(\')|(\-\-)|(\%3B)|(;))/gi,
      /\w*((\%27)|(\'))((\%6F)|o|(\%4F))((\%72)|r|(\%52))/gi,
    ];

    const threats: ThreatDetectionResult[] = [];
    
    for (const event of events) {
      if (event.type === 'HTTP_REQUEST') {
        const payload = event.payload || '';
        
        for (const pattern of sqlInjectionPatterns) {
          if (pattern.test(payload)) {
            threats.push({
              type: 'SQL_INJECTION',
              severity: 'HIGH',
              confidence: 0.8,
              source: event.source,
              evidence: {
                matchedPattern: pattern.toString(),
                payload: payload.substring(0, 200), // 限制长度
              },
              timestamp: event.timestamp,
            });
            break;
          }
        }
      }
    }
    
    return threats;
  }

  private async detectAccountTakeover(events: SecurityEvent[]): Promise<ThreatDetectionResult[]> {
    const threats: ThreatDetectionResult[] = [];
    
    // 按用户分组事件
    const eventsByUser = this.groupEventsByUser(events);
    
    for (const [userId, userEvents] of eventsByUser.entries()) {
      // 检测异常登录模式
      const loginEvents = userEvents.filter(e => e.type === 'LOGIN_ATTEMPT');
      
      if (loginEvents.length > 0) {
        const riskScore = await this.calculateAccountTakeoverRisk(userId, loginEvents);
        
        if (riskScore > 0.7) {
          threats.push({
            type: 'ACCOUNT_TAKEOVER',
            severity: 'CRITICAL',
            confidence: riskScore,
            userId: userId,
            evidence: {
              suspiciousLogins: loginEvents.length,
              riskFactors: await this.getAccountRiskFactors(userId, loginEvents),
            },
            timestamp: new Date(),
          });
        }
      }
    }
    
    return threats;
  }

  private async calculateAccountTakeoverRisk(
    userId: string, 
    loginEvents: SecurityEvent[]
  ): Promise<number> {
    let riskScore = 0;
    
    // 地理位置风险
    const locations = await this.extractLocations(loginEvents);
    if (locations.length > 3) { // 多个不同地理位置
      riskScore += 0.3;
    }
    
    // 设备风险
    const devices = await this.extractDevices(loginEvents);
    if (devices.some(d => d.isNew)) { // 新设备
      riskScore += 0.2;
    }
    
    // 时间风险
    const timeRisk = this.calculateTimeRisk(loginEvents);
    riskScore += timeRisk;
    
    // 失败率风险
    const failureRate = this.calculateFailureRate(loginEvents);
    riskScore += failureRate * 0.3;
    
    return Math.min(riskScore, 1.0);
  }
}
```

### 8.2 审计日志管理

```yaml
审计日志架构:
  收集层:
    - 应用日志收集
    - 系统日志收集
    - 数据库日志收集
    - 网络日志收集

  传输层:
    - 安全传输协议
    - 日志聚合
    - 实时流处理
    - 备份机制

  存储层:
    - 分布式存储
    - 长期归档
    - 数据压缩
    - 冗余备份

  分析层:
    - 实时分析
    - 异常检测
    - 模式识别
    - 威胁情报

日志记录标准:
  必要字段:
    - timestamp: 时间戳
    - userId: 用户ID
    - sessionId: 会话ID
    - action: 操作类型
    - resource: 资源标识
    - result: 操作结果
    - ipAddress: IP地址
    - userAgent: 用户代理

  安全事件:
    - 登录/登出
    - 权限变更
    - 敏感数据访问
    - 系统配置变更
    - 异常行为

  业务事件:
    - 订单创建/修改
    - 支付操作
    - 数据导出
    - 用户注册

日志保护:
  完整性保护:
    - 数字签名
    - 哈希验证
    - 区块链存证
    - 不可篡改存储

  机密性保护:
    - 敏感数据脱敏
    - 访问控制
    - 传输加密
    - 存储加密

  可用性保护:
    - 冗余备份
    - 故障转移
    - 快速恢复
    - 性能监控

合规要求:
  保存期限:
    - 安全日志: 6个月
    - 访问日志: 1年
    - 财务日志: 7年
    - 审计日志: 3年

  监管报告:
    - 定期合规报告
    - 安全事件报告
    - 数据泄露报告
    - 审计发现报告
```

---

## 9. 应急响应

### 9.1 安全事件响应流程

```yaml
响应级别定义:
  L1 - 低风险:
    - 单个用户账户异常
    - 轻微的系统配置错误
    - 非关键系统故障
    响应时间: 24小时内

  L2 - 中风险:
    - 多个用户账户受影响
    - 敏感数据可能泄露
    - 系统性能显著下降
    响应时间: 4小时内

  L3 - 高风险:
    - 大规模用户账户泄露
    - 支付系统安全事件
    - 核心系统完全故障
    响应时间: 1小时内

  L4 - 危机级别:
    - 全系统性安全攻击
    - 大规模数据泄露
    - 服务完全中断
    响应时间: 15分钟内

响应流程:
  1. 事件发现和报告:
     - 自动监控告警
     - 员工主动报告
     - 外部通知
     - 用户反馈

  2. 初步评估:
     - 事件分类
     - 影响范围评估
     - 风险级别确定
     - 响应团队通知

  3. 遏制措施:
     - 隔离受影响系统
     - 停止可疑活动
     - 保护证据
     - 阻止进一步损害

  4. 调查分析:
     - 收集证据
     - 分析攻击路径
     - 确定影响范围
     - 识别根本原因

  5. 清除和恢复:
     - 清除威胁
     - 修复漏洞
     - 恢复服务
     - 验证系统安全

  6. 经验总结:
     - 事件报告
     - 流程改进
     - 安全加固
     - 培训更新

应急联系人:
  安全团队:
    - 首席安全官: 24/7值班
    - 安全工程师: 轮班制
    - 事件响应专员: 专职负责

  业务团队:
    - 产品负责人: 业务影响评估
    - 运维团队: 系统恢复
    - 客服团队: 用户沟通

  外部支持:
    - 网络安全公司: 技术支持
    - 法律顾问: 合规指导
    - 公关公司: 危机沟通
    - 执法部门: 必要时报案
```

### 9.2 数据泄露响应

```typescript
// 数据泄露响应服务
@Injectable()
export class DataBreachResponseService {
  constructor(
    private readonly auditService: AuditService,
    private readonly notificationService: NotificationService,
    private readonly legalService: LegalService,
    private readonly mediaService: MediaService
  ) {}

  async handleDataBreach(incident: DataBreachIncident): Promise<void> {
    // 1. 立即响应 (0-1小时)
    await this.immediateResponse(incident);
    
    // 2. 评估和遏制 (1-24小时)
    await this.assessAndContain(incident);
    
    // 3. 调查和通知 (24-72小时)
    await this.investigateAndNotify(incident);
    
    // 4. 长期跟进 (72小时后)
    await this.longTermFollowUp(incident);
  }

  private async immediateResponse(incident: DataBreachIncident): Promise<void> {
    // 记录事件开始时间
    incident.discoveryTime = new Date();
    
    // 立即通知安全团队
    await this.notificationService.notifySecurityTeam({
      type: 'DATA_BREACH',
      severity: incident.severity,
      summary: incident.description,
      discoveryTime: incident.discoveryTime,
    });
    
    // 初步遏制措施
    if (incident.affectedSystems?.length > 0) {
      for (const system of incident.affectedSystems) {
        await this.containSystem(system);
      }
    }
    
    // 开始证据保全
    await this.preserveEvidence(incident);
    
    // 评估是否需要关闭受影响服务
    const shouldShutdown = await this.assessShutdownNeed(incident);
    if (shouldShutdown) {
      await this.emergencyShutdown(incident.affectedSystems);
    }
  }

  private async assessAndContain(incident: DataBreachIncident): Promise<void> {
    // 详细影响评估
    const assessment = await this.conductDetailedAssessment(incident);
    incident.impactAssessment = assessment;
    
    // 确定受影响的个人数据类型和数量
    incident.affectedDataTypes = await this.identifyAffectedDataTypes(incident);
    incident.affectedRecordCount = await this.countAffectedRecords(incident);
    
    // 评估法律义务
    const legalObligations = await this.legalService.assessLegalObligations(incident);
    incident.notificationRequirements = legalObligations.notifications;
    
    // 加强遏制措施
    await this.enhanceContainment(incident);
    
    // 开始取证调查
    await this.startForensicInvestigation(incident);
  }

  private async investigateAndNotify(incident: DataBreachIncident): Promise<void> {
    // 深入调查
    const investigation = await this.conductInvestigation(incident);
    incident.investigationFindings = investigation;
    
    // 确定通知义务
    const notifications = await this.determineNotificationObligations(incident);
    
    // 通知监管机构 (72小时内)
    if (notifications.regulatory) {
      await this.notifyRegulators(incident);
      incident.regulatoryNotificationTime = new Date();
    }
    
    // 通知受影响个人 (无不当延迟)
    if (notifications.individuals) {
      await this.notifyAffectedIndividuals(incident);
      incident.individualNotificationTime = new Date();
    }
    
    // 通知业务合作伙伴
    if (notifications.partners) {
      await this.notifyBusinessPartners(incident);
    }
    
    // 准备公开声明 (如需要)
    if (notifications.public) {
      await this.preparePublicStatement(incident);
    }
  }

  private async notifyAffectedIndividuals(incident: DataBreachIncident): Promise<void> {
    const affectedUsers = await this.getAffectedUsers(incident);
    
    for (const user of affectedUsers) {
      const notification = {
        userId: user.id,
        incidentId: incident.id,
        subject: '重要安全通知 - 数据安全事件',
        message: await this.generateUserNotificationMessage(incident, user),
        channels: await this.determineNotificationChannels(user),
        timestamp: new Date(),
      };
      
      await this.notificationService.sendUserNotification(notification);
      
      // 为用户提供保护措施建议
      await this.provideProtectionGuidance(user, incident);
    }
    
    // 设置用户咨询热线
    await this.setupUserHelpline(incident);
  }

  private async generateUserNotificationMessage(
    incident: DataBreachIncident, 
    user: User
  ): Promise<string> {
    return `
亲爱的用户，

我们发现了一起涉及您个人信息的安全事件，特此通知您相关情况。

事件概述：
- 发生时间：${incident.occurredTime}
- 发现时间：${incident.discoveryTime}
- 影响范围：${incident.affectedDataTypes.join(', ')}

您的哪些信息可能受到影响：
${await this.getUserSpecificAffectedData(user, incident)}

我们已采取的措施：
- 立即修复了安全漏洞
- 通知了相关监管部门
- 加强了安全监控

您需要采取的措施：
1. 立即修改账户密码
2. 监控账户异常活动
3. 注意相关诈骗信息
4. 如有疑问请联系我们

联系方式：
客服热线：400-xxx-xxxx
邮箱：security@nutrition.com

我们对此次事件深表歉意，并承诺继续加强数据安全保护。

AI智能营养餐厅团队
${new Date().toLocaleDateString()}
    `;
  }

  private async longTermFollowUp(incident: DataBreachIncident): Promise<void> {
    // 持续监控
    await this.setupContinuousMonitoring(incident);
    
    // 安全加固
    await this.implementSecurityEnhancements(incident);
    
    // 流程改进
    await this.updateIncidentResponseProcedures(incident);
    
    // 员工培训
    await this.conductSecurityTraining(incident);
    
    // 定期报告
    await this.scheduleRegularReports(incident);
    
    // 经验总结
    await this.conductLessonsLearned(incident);
  }
}

// 通知服务
@Injectable()
export class BreachNotificationService {
  
  async notifyRegulators(incident: DataBreachIncident): Promise<void> {
    const regulators = [
      {
        name: '国家网信办',
        contactInfo: 'report@cac.gov.cn',
        timeLimit: 72, // 小时
        template: 'cac_template'
      },
      {
        name: '公安部网络安全部门',
        contactInfo: '110@police.gov.cn',
        timeLimit: 24, // 小时
        template: 'police_template'
      }
    ];

    for (const regulator of regulators) {
      const report = await this.generateRegulatoryReport(incident, regulator);
      await this.submitRegulatoryReport(regulator, report);
      
      // 记录通知时间
      await this.recordNotificationTime(incident.id, regulator.name, new Date());
    }
  }

  private async generateRegulatoryReport(
    incident: DataBreachIncident, 
    regulator: any
  ): Promise<RegulatoryReport> {
    return {
      incidentId: incident.id,
      organizationInfo: await this.getOrganizationInfo(),
      incidentDetails: {
        natureOfBreach: incident.type,
        categoryOfData: incident.affectedDataTypes,
        numberOfIndividuals: incident.affectedRecordCount,
        potentialConsequences: incident.riskAssessment,
        securityMeasures: incident.containmentMeasures,
      },
      timeline: {
        occurredTime: incident.occurredTime,
        discoveryTime: incident.discoveryTime,
        containmentTime: incident.containmentTime,
        reportingTime: new Date(),
      },
      contactPerson: await this.getDataProtectionOfficer(),
      remediationPlan: incident.remediationPlan,
      attachments: incident.evidenceFiles,
    };
  }
}
```

### 9.3 业务连续性计划

```yaml
业务连续性目标:
  RTO (恢复时间目标):
    - 核心业务: 2小时
    - 重要业务: 8小时
    - 一般业务: 24小时

  RPO (恢复点目标):
    - 用户数据: 1小时
    - 订单数据: 30分钟
    - 支付数据: 15分钟

备份策略:
  数据备份:
    - 实时备份: 关键交易数据
    - 每日备份: 用户数据和配置
    - 每周备份: 完整系统备份
    - 每月备份: 归档和长期存储

  备份验证:
    - 自动验证: 每日
    - 手动验证: 每周
    - 恢复测试: 每月
    - 全面测试: 每季度

灾难恢复:
  恢复优先级:
    P1 - 关键系统:
      - 用户认证系统
      - 支付处理系统
      - 核心数据库
      - API网关

    P2 - 重要系统:
      - 订单管理系统
      - 营养分析系统
      - 消息通知系统
      - 文件存储系统

    P3 - 一般系统:
      - 数据分析系统
      - 报告系统
      - 监控系统
      - 日志系统

  恢复流程:
    1. 事件确认和评估
    2. 激活灾难恢复团队
    3. 建立临时指挥中心
    4. 执行恢复计划
    5. 验证系统功能
    6. 切换到正常运营

应急演练:
  演练类型:
    - 桌面演练: 每月
    - 功能演练: 每季度
    - 全面演练: 每年

  演练内容:
    - 通信测试
    - 系统恢复
    - 数据恢复
    - 业务切换
    - 协调配合

  演练评估:
    - 响应时间
    - 恢复效果
    - 协调效率
    - 改进建议
```

---

## 10. 合规要求

### 10.1 法律法规遵循

```yaml
中国法律法规:
  《网络安全法》:
    - 网络安全等级保护
    - 关键信息基础设施保护
    - 个人信息保护
    - 数据出境安全评估

  《数据安全法》:
    - 数据分类分级保护
    - 重要数据保护
    - 数据活动安全管理
    - 数据安全应急处置

  《个人信息保护法》:
    - 个人信息处理规则
    - 个人信息跨境提供
    - 个人在个人信息处理中的权利
    - 履行个人信息保护职责的部门

  《食品安全法》:
    - 食品安全标准
    - 食品生产经营
    - 食品检验
    - 食品安全事故处置

国际标准:
  ISO 27001:
    - 信息安全管理体系
    - 风险管理
    - 控制措施
    - 持续改进

  SOC 2 Type II:
    - 安全性
    - 可用性
    - 处理完整性
    - 机密性
    - 隐私

  PCI DSS:
    - 支付卡数据保护
    - 网络安全要求
    - 漏洞管理
    - 访问控制

行业标准:
  餐饮行业:
    - 食品安全管理体系
    - 营养标签标准
    - 餐饮服务规范
    - 外卖配送标准

  移动应用:
    - 应用商店审核标准
    - 隐私政策要求
    - 数据安全要求
    - 广告投放规范
```

### 10.2 合规检查清单

```yaml
数据保护合规:
  ✅ 隐私政策制定和发布
  ✅ 用户同意机制实施
  ✅ 个人信息收集最小化
  ✅ 数据处理目的明确
  ✅ 数据安全技术措施
  ✅ 个人信息权利保障
  ✅ 数据泄露应急预案
  ✅ 定期合规评估

网络安全合规:
  ✅ 网络安全等级保护备案
  ✅ 安全管理制度建立
  ✅ 技术安全措施实施
  ✅ 安全风险评估
  ✅ 安全事件应急响应
  ✅ 网络日志留存
  ✅ 定期安全检测
  ✅ 人员安全管理

支付安全合规:
  ✅ 支付业务许可
  ✅ 资金安全管理
  ✅ 反洗钱制度
  ✅ 客户身份识别
  ✅ 可疑交易报告
  ✅ 支付数据保护
  ✅ 第三方支付规范
  ✅ 跨境支付合规

食品安全合规:
  ✅ 食品经营许可证
  ✅ 供应商资质审核
  ✅ 食品安全管理制度
  ✅ 营养标签规范
  ✅ 食品追溯体系
  ✅ 食品安全事故应急
  ✅ 从业人员健康管理
  ✅ 定期食品安全检查
```

### 10.3 合规监控与报告

```typescript
// 合规监控服务
@Injectable()
export class ComplianceMonitoringService {
  constructor(
    private readonly auditService: AuditService,
    private readonly reportService: ReportService,
    private readonly alertService: AlertService
  ) {}

  async performComplianceCheck(): Promise<ComplianceReport> {
    const checks = await Promise.all([
      this.checkDataProtectionCompliance(),
      this.checkNetworkSecurityCompliance(),
      this.checkPaymentCompliance(),
      this.checkFoodSafetyCompliance(),
    ]);

    const report = {
      timestamp: new Date(),
      overallScore: this.calculateOverallScore(checks),
      checks: checks,
      recommendations: this.generateRecommendations(checks),
      nextReviewDate: this.calculateNextReviewDate(),
    };

    // 生成合规报告
    await this.reportService.generateComplianceReport(report);

    // 发送合规告警
    await this.sendComplianceAlerts(report);

    return report;
  }

  private async checkDataProtectionCompliance(): Promise<ComplianceCheck> {
    const checks = [
      await this.checkPrivacyPolicyCompliance(),
      await this.checkConsentMechanismCompliance(),
      await this.checkDataMinimizationCompliance(),
      await this.checkUserRightsCompliance(),
      await this.checkDataSecurityCompliance(),
      await this.checkBreachResponseCompliance(),
    ];

    return {
      category: 'DATA_PROTECTION',
      score: this.calculateCategoryScore(checks),
      items: checks,
      status: this.determineCategoryStatus(checks),
    };
  }

  private async checkPrivacyPolicyCompliance(): Promise<ComplianceItem> {
    // 检查隐私政策是否最新
    const currentPolicy = await this.getCurrentPrivacyPolicy();
    const lastUpdate = currentPolicy.lastUpdateDate;
    const daysSinceUpdate = (Date.now() - lastUpdate.getTime()) / (1000 * 60 * 60 * 24);

    const isCompliant = daysSinceUpdate <= 365; // 年度更新要求

    return {
      name: '隐私政策合规性',
      description: '隐私政策是否符合最新法律要求',
      status: isCompliant ? 'COMPLIANT' : 'NON_COMPLIANT',
      score: isCompliant ? 100 : 0,
      evidence: {
        lastUpdateDate: lastUpdate,
        daysSinceUpdate: Math.floor(daysSinceUpdate),
        requiredUpdateFrequency: 365,
      },
      recommendations: isCompliant ? [] : [
        '更新隐私政策以符合最新法律要求',
        '增加数据处理的具体描述',
        '明确用户权利行使方式',
      ],
    };
  }

  private async checkConsentMechanismCompliance(): Promise<ComplianceItem> {
    // 检查同意机制实施情况
    const consentStats = await this.getConsentStatistics();
    
    const hasValidConsent = consentStats.explicitConsentRate > 0.95;
    const hasWithdrawalMechanism = consentStats.withdrawalMechanismActive;
    const hasGranularConsent = consentStats.granularConsentSupported;

    const score = (
      (hasValidConsent ? 40 : 0) +
      (hasWithdrawalMechanism ? 30 : 0) +
      (hasGranularConsent ? 30 : 0)
    );

    return {
      name: '用户同意机制',
      description: '用户同意收集和处理的机制是否有效',
      status: score >= 80 ? 'COMPLIANT' : 'PARTIALLY_COMPLIANT',
      score: score,
      evidence: consentStats,
      recommendations: score < 80 ? [
        '提高明确同意获取率',
        '完善同意撤回机制',
        '实施细粒度同意选项',
      ] : [],
    };
  }

  private async generateComplianceRecommendations(
    checks: ComplianceCheck[]
  ): Promise<ComplianceRecommendation[]> {
    const recommendations: ComplianceRecommendation[] = [];

    for (const check of checks) {
      for (const item of check.items) {
        if (item.status !== 'COMPLIANT' && item.recommendations.length > 0) {
          recommendations.push({
            category: check.category,
            priority: this.calculateRecommendationPriority(item),
            title: `改进 ${item.name}`,
            description: item.recommendations.join('; '),
            dueDate: this.calculateRecommendationDueDate(item),
            owner: await this.assignRecommendationOwner(check.category),
          });
        }
      }
    }

    return recommendations.sort((a, b) => 
      this.comparePriority(a.priority, b.priority)
    );
  }

  // 定期合规报告
  @Cron('0 0 1 * *') // 每月1日执行
  async generateMonthlyComplianceReport(): Promise<void> {
    const report = await this.performComplianceCheck();
    
    // 发送给管理层
    await this.reportService.sendToManagement(report);
    
    // 发送给合规团队
    await this.reportService.sendToComplianceTeam(report);
    
    // 存档报告
    await this.reportService.archiveReport(report);
  }

  // 季度深度审计
  @Cron('0 0 1 */3 *') // 每季度执行
  async performQuarterlyAudit(): Promise<void> {
    const auditReport = await this.auditService.performComprehensiveAudit();
    
    // 外部审计师验证
    if (auditReport.requiresExternalValidation) {
      await this.scheduleExternalAudit(auditReport);
    }
    
    // 更新合规状态
    await this.updateComplianceStatus(auditReport);
  }
}
```

---

## 总结

本安全规范文档为AI智能营养餐厅系统提供了全面的安全保护框架，涵盖了从认证授权到应急响应的各个安全层面。

### 核心安全特性

1. **多层防护**: 网络层、应用层、数据层全方位保护
2. **零信任架构**: 每个请求都需要验证和授权
3. **隐私优先**: 符合GDPR和国内法律法规要求
4. **实时监控**: 24/7安全事件监控和响应
5. **合规保证**: 满足行业标准和监管要求

### 实施优先级

**P0 (立即实施):**
- JWT Token安全策略
- RBAC权限控制
- 基础数据加密
- API输入验证

**P1 (短期实施):**
- 安全监控系统
- 数据脱敏机制
- 应急响应流程
- 合规检查机制

**P2 (中期实施):**
- 高级威胁检测
- 业务连续性计划
- 隐私权利自动化
- 安全培训体系

这个安全框架将为系统提供企业级的安全保护，确保用户数据安全和业务连续性。

---

**文档状态**: ✅ 安全架构设计完成  
**下一步**: 实施核心安全机制和监控系统