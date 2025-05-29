import 'package:freezed_annotation/freezed_annotation.dart';

part 'coordinator_result.freezed.dart';

/// Coordinator 执行结果
@freezed
class CoordinatorResult<T> with _$CoordinatorResult<T> {
  const factory CoordinatorResult.success({
    required T data,
    String? message,
  }) = _Success<T>;
  
  const factory CoordinatorResult.failure({
    required String error,
    String? code,
  }) = _Failure<T>;
  
  const factory CoordinatorResult.cancelled() = _Cancelled<T>;
}