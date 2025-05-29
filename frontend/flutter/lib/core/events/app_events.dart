import '../services/event_bus.dart';

// ========== 认证事件 ==========

/// 用户登录成功事件
class UserLoggedInEvent extends DomainEvent {
  final String userId;
  final String token;
  
  UserLoggedInEvent({
    required this.userId,
    required this.token,
  });
}

/// 用户登出事件
class UserLoggedOutEvent extends DomainEvent {
  final String? reason;
  
  UserLoggedOutEvent({this.reason});
}

/// 认证失败事件
class AuthenticationFailedEvent extends DomainEvent {
  final String message;
  final int? errorCode;
  
  AuthenticationFailedEvent({
    required this.message,
    this.errorCode,
  });
}

// ========== 用户事件 ==========

/// 用户资料更新事件
class UserProfileUpdatedEvent extends DomainEvent {
  final String userId;
  final Map<String, dynamic> changes;
  
  UserProfileUpdatedEvent({
    required this.userId,
    required this.changes,
  });
}

/// 用户角色变更事件
class UserRoleChangedEvent extends DomainEvent {
  final String userId;
  final List<String> oldRoles;
  final List<String> newRoles;
  
  UserRoleChangedEvent({
    required this.userId,
    required this.oldRoles,
    required this.newRoles,
  });
}

// ========== 营养事件 ==========

/// 营养档案创建事件
class NutritionProfileCreatedEvent extends DomainEvent {
  final String profileId;
  final String userId;
  
  NutritionProfileCreatedEvent({
    required this.profileId,
    required this.userId,
  });
}

/// 营养档案更新事件
class NutritionProfileUpdatedEvent extends DomainEvent {
  final String profileId;
  final Map<String, dynamic> changes;
  
  NutritionProfileUpdatedEvent({
    required this.profileId,
    required this.changes,
  });
}

/// AI推荐生成事件
class AIRecommendationGeneratedEvent extends DomainEvent {
  final String recommendationId;
  final String profileId;
  final String type;
  
  AIRecommendationGeneratedEvent({
    required this.recommendationId,
    required this.profileId,
    required this.type,
  });
}

// ========== 订单事件 ==========

/// 订单创建事件
class OrderCreatedEvent extends DomainEvent {
  final String orderId;
  final String userId;
  final double amount;
  
  OrderCreatedEvent({
    required this.orderId,
    required this.userId,
    required this.amount,
  });
}

/// 订单完成事件
class OrderCompletedEvent extends DomainEvent {
  final String orderId;
  final String status;
  
  OrderCompletedEvent({
    required this.orderId,
    required this.status,
  });
}

// ========== 系统事件 ==========

/// 网络状态变更事件
class NetworkStatusChangedEvent extends DomainEvent {
  final bool isConnected;
  final String connectionType;
  
  NetworkStatusChangedEvent({
    required this.isConnected,
    required this.connectionType,
  });
}

/// 应用生命周期事件
class AppLifecycleEvent extends DomainEvent {
  final AppLifecycleState state;
  
  AppLifecycleEvent({required this.state});
}

enum AppLifecycleState {
  resumed,
  inactive,
  paused,
  detached,
}

/// 错误事件
class ErrorOccurredEvent extends DomainEvent {
  final String message;
  final String? stackTrace;
  final String source;
  
  ErrorOccurredEvent({
    required this.message,
    this.stackTrace,
    required this.source,
  });
}