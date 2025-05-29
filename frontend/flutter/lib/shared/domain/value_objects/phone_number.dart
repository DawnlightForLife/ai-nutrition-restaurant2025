/// 手机号码值对象
/// 
/// 对应后端的值对象设计，确保前后端领域模型一致
library;

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'phone_number.freezed.dart';

/// 手机号码值对象
@freezed
class PhoneNumber with _$PhoneNumber {
  const PhoneNumber._();
  
  const factory PhoneNumber(String value) = _PhoneNumber;

  /// 创建手机号码
  static Either<PhoneNumberFailure, PhoneNumber> create(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.isEmpty) {
      return left(const PhoneNumberFailure.empty());
    }
    
    // 中国手机号验证
    if (!RegExp(r'^1[3-9]\d{9}$').hasMatch(cleaned)) {
      return left(const PhoneNumberFailure.invalid());
    }
    
    return right(PhoneNumber(cleaned));
  }
  
  /// 格式化显示
  String get formatted => '${value.substring(0, 3)} ${value.substring(3, 7)} ${value.substring(7)}';
  
  /// 脱敏显示
  String get masked => '${value.substring(0, 3)}****${value.substring(7)}';
}

/// 手机号码失败类型
@freezed
class PhoneNumberFailure with _$PhoneNumberFailure {
  const factory PhoneNumberFailure.empty() = _Empty;
  const factory PhoneNumberFailure.invalid() = _Invalid;
}