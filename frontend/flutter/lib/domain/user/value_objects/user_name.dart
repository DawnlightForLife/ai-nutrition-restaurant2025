import 'package:dartz/dartz.dart';
import '../../common/value_objects/value_object.dart';
import '../../common/failures/value_failure.dart';

/// 用户昵称值对象
class UserName extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  
  factory UserName(String input) {
    return UserName._(
      validateUserName(input),
    );
  }
  
  const UserName._(this.value) : super(value);
  
  static const int maxLength = 20;
  static const int minLength = 2;
}

/// 验证用户昵称
Either<ValueFailure<String>, String> validateUserName(String input) {
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  }
  if (input.length < UserName.minLength) {
    return left(ValueFailure.tooShort(
      failedValue: input,
      min: UserName.minLength,
    ));
  }
  if (input.length > UserName.maxLength) {
    return left(ValueFailure.tooLong(
      failedValue: input,
      max: UserName.maxLength,
    ));
  }
  return right(input);
}