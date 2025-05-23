import 'package:dartz/dartz.dart';
import '../../common/value_objects/value_object.dart';
import '../../common/failures/value_failure.dart';

/// 邮箱值对象
class Email extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  
  factory Email(String input) {
    return Email._(
      validateEmail(input),
    );
  }
  
  const Email._(this.value) : super(value);
}

/// 验证邮箱格式
Either<ValueFailure<String>, String> validateEmail(String input) {
  const emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  }
  if (!RegExp(emailRegex).hasMatch(input)) {
    return left(ValueFailure.invalidEmail(failedValue: input));
  }
  return right(input);
}