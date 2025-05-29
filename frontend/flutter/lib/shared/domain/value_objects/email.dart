/// 邮箱值对象
/// 
/// 对应后端的值对象设计，确保前后端领域模型一致
library;

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'email.freezed.dart';

/// 邮箱值对象
@freezed
class Email with _$Email {
  const Email._();
  
  const factory Email(String value) = _Email;

  /// 创建邮箱
  static Either<EmailFailure, Email> create(String input) {
    final trimmed = input.trim().toLowerCase();
    
    if (trimmed.isEmpty) {
      return left(const EmailFailure.empty());
    }
    
    // 邮箱格式验证
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(trimmed)) {
      return left(const EmailFailure.invalid());
    }
    
    return right(Email(trimmed));
  }
  
  /// 获取用户名部分
  String get username => value.split('@').first;
  
  /// 获取域名部分
  String get domain => value.split('@').last;
}

/// 邮箱失败类型
@freezed
class EmailFailure with _$EmailFailure {
  const factory EmailFailure.empty() = _EmptyEmail;
  const factory EmailFailure.invalid() = _InvalidEmail;
}