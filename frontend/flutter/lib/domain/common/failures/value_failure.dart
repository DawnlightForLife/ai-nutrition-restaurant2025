import 'package:freezed_annotation/freezed_annotation.dart';

part 'value_failure.freezed.dart';

/// 值对象验证失败类型
@freezed
class ValueFailure<T> with _$ValueFailure<T> {
  // 通用失败
  const factory ValueFailure.empty({
    required T failedValue,
  }) = Empty<T>;
  
  const factory ValueFailure.tooLong({
    required T failedValue,
    required int max,
  }) = TooLong<T>;
  
  const factory ValueFailure.tooShort({
    required T failedValue,
    required int min,
  }) = TooShort<T>;
  
  const factory ValueFailure.invalidFormat({
    required T failedValue,
    String? message,
  }) = InvalidFormat<T>;
  
  // 数值相关
  const factory ValueFailure.numberTooLarge({
    required T failedValue,
    required num max,
  }) = NumberTooLarge<T>;
  
  const factory ValueFailure.numberTooSmall({
    required T failedValue,
    required num min,
  }) = NumberTooSmall<T>;
  
  const factory ValueFailure.notANumber({
    required T failedValue,
  }) = NotANumber<T>;
  
  // 特定领域失败
  const factory ValueFailure.invalidEmail({
    required T failedValue,
  }) = InvalidEmail<T>;
  
  const factory ValueFailure.invalidPhone({
    required T failedValue,
  }) = InvalidPhone<T>;
  
  const factory ValueFailure.weakPassword({
    required T failedValue,
  }) = WeakPassword<T>;
}