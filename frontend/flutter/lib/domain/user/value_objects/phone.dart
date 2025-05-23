import 'package:dartz/dartz.dart';
import '../../common/value_objects/value_object.dart';
import '../../common/failures/value_failure.dart';

/// 手机号值对象
class Phone extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  
  factory Phone(String input) {
    return Phone._(
      validatePhone(input),
    );
  }
  
  const Phone._(this.value) : super(value);
}

/// 验证手机号格式（中国大陆）
Either<ValueFailure<String>, String> validatePhone(String input) {
  const phoneRegex = r'^1[3-9]\d{9}$';
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  }
  if (!RegExp(phoneRegex).hasMatch(input)) {
    return left(ValueFailure.invalidPhone(failedValue: input));
  }
  return right(input);
}