import 'package:flutter/material.dart';

/// 营养模块错误处理服务
class NutritionErrorHandlingService {
  /// 解析错误并返回用户友好的消息
  static String getErrorMessage(dynamic error) {
    if (error == null) return '未知错误';
    
    final errorString = error.toString().toLowerCase();
    
    // 网络相关错误
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return '网络连接异常，请检查网络后重试';
    }
    
    // 数据相关错误
    if (errorString.contains('format') || 
        errorString.contains('parse') ||
        errorString.contains('json')) {
      return '数据格式错误，请稍后重试';
    }
    
    // 权限相关错误
    if (errorString.contains('permission') || 
        errorString.contains('unauthorized') ||
        errorString.contains('forbidden')) {
      return '权限不足，请重新登录';
    }
    
    // 存储相关错误
    if (errorString.contains('storage') || 
        errorString.contains('disk') ||
        errorString.contains('space')) {
      return '存储空间不足，请清理后重试';
    }
    
    // 营养档案特定错误
    if (errorString.contains('profile not found') ||
        errorString.contains('档案不存在')) {
      return '档案不存在，可能已被删除';
    }
    
    if (errorString.contains('duplicate') ||
        errorString.contains('重复')) {
      return '档案名称已存在，请使用其他名称';
    }
    
    if (errorString.contains('validation') ||
        errorString.contains('invalid')) {
      return '输入数据不符合要求，请检查后重试';
    }
    
    // AI推荐相关错误
    if (errorString.contains('ai') || 
        errorString.contains('recommendation')) {
      return 'AI推荐服务暂时不可用，请稍后重试';
    }
    
    // 默认错误消息
    return '操作失败，请稍后重试';
  }
  
  /// 获取错误类型
  static ErrorType getErrorType(dynamic error) {
    if (error == null) return ErrorType.unknown;
    
    final errorString = error.toString().toLowerCase();
    
    if (errorString.contains('network') || 
        errorString.contains('connection') ||
        errorString.contains('timeout')) {
      return ErrorType.network;
    }
    
    if (errorString.contains('permission') || 
        errorString.contains('unauthorized')) {
      return ErrorType.permission;
    }
    
    if (errorString.contains('validation') ||
        errorString.contains('invalid')) {
      return ErrorType.validation;
    }
    
    if (errorString.contains('storage') || 
        errorString.contains('disk')) {
      return ErrorType.storage;
    }
    
    return ErrorType.general;
  }
  
  /// 是否可以重试
  static bool canRetry(dynamic error) {
    final errorType = getErrorType(error);
    return errorType == ErrorType.network || 
           errorType == ErrorType.general ||
           errorType == ErrorType.unknown;
  }
  
  /// 获取重试建议
  static String getRetryAdvice(dynamic error) {
    final errorType = getErrorType(error);
    
    switch (errorType) {
      case ErrorType.network:
        return '请检查网络连接后重试';
      case ErrorType.permission:
        return '请重新登录后重试';
      case ErrorType.validation:
        return '请检查输入信息后重试';
      case ErrorType.storage:
        return '请清理存储空间后重试';
      case ErrorType.general:
      case ErrorType.unknown:
        return '请稍后重试';
    }
  }
}

/// 错误类型枚举
enum ErrorType {
  network,    // 网络错误
  permission, // 权限错误
  validation, // 验证错误
  storage,    // 存储错误
  general,    // 一般错误
  unknown,    // 未知错误
}

/// 用户反馈类型
enum FeedbackType {
  success,    // 成功
  info,       // 信息
  warning,    // 警告
  error,      // 错误
}

/// 反馈消息模型
class FeedbackMessage {
  final String message;
  final FeedbackType type;
  final String? actionLabel;
  final VoidCallback? action;
  final Duration duration;
  
  const FeedbackMessage({
    required this.message,
    required this.type,
    this.actionLabel,
    this.action,
    this.duration = const Duration(seconds: 4),
  });
  
  /// 创建成功消息
  factory FeedbackMessage.success(
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    return FeedbackMessage(
      message: message,
      type: FeedbackType.success,
      actionLabel: actionLabel,
      action: action,
      duration: const Duration(seconds: 3),
    );
  }
  
  /// 创建错误消息
  factory FeedbackMessage.error(
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    return FeedbackMessage(
      message: message,
      type: FeedbackType.error,
      actionLabel: actionLabel,
      action: action,
      duration: const Duration(seconds: 5),
    );
  }
  
  /// 创建警告消息
  factory FeedbackMessage.warning(
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    return FeedbackMessage(
      message: message,
      type: FeedbackType.warning,
      actionLabel: actionLabel,
      action: action,
      duration: const Duration(seconds: 4),
    );
  }
  
  /// 创建信息消息
  factory FeedbackMessage.info(
    String message, {
    String? actionLabel,
    VoidCallback? action,
  }) {
    return FeedbackMessage(
      message: message,
      type: FeedbackType.info,
      actionLabel: actionLabel,
      action: action,
      duration: const Duration(seconds: 3),
    );
  }
}