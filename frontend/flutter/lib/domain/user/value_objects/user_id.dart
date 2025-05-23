import 'package:dartz/dartz.dart';
import '../../common/value_objects/value_object.dart';
import '../../common/failures/value_failure.dart';

/// 用户ID值对象
class UserId extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  
  factory UserId(String input) {
    return UserId._(
      validateUserId(input),
    );
  }
  
  const UserId._(this.value) : super(value);
}

/// 验证用户ID
Either<ValueFailure<String>, String> validateUserId(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  }
  return right(input);
}