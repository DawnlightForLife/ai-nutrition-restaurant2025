import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../common/failures/value_failure.dart';

/// 值对象基类
/// 
/// 值对象是不可变的，通过值而非标识进行比较
/// 所有值对象都应该继承此类
abstract class ValueObject<T> extends Equatable {
  final Either<ValueFailure<T>, T> value;
  
  const ValueObject(this.value);
  
  /// 获取值或在失败时抛出异常
  T getOrCrash() {
    return value.fold(
      (failure) => throw UnexpectedValueError(failure),
      (value) => value,
    );
  }
  
  /// 获取值或返回默认值
  T getOrElse(T defaultValue) {
    return value.fold(
      (_) => defaultValue,
      (value) => value,
    );
  }
  
  /// 检查值是否有效
  bool isValid() => value.isRight();
  
  /// 获取失败信息
  ValueFailure<T>? get failure => value.fold(
    (failure) => failure,
    (_) => null,
  );
  
  @override
  List<Object?> get props => [value];
}

/// 意外值错误
class UnexpectedValueError extends Error {
  final ValueFailure failure;
  
  UnexpectedValueError(this.failure);
  
  @override
  String toString() {
    return 'UnexpectedValueError: $failure';
  }
}