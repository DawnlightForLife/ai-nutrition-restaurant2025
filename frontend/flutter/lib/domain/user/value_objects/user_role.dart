import 'package:dartz/dartz.dart';
import '../../common/value_objects/value_object.dart';
import '../../common/failures/value_failure.dart';

/// 用户角色值对象
class UserRole extends ValueObject<String> {
  @override
  final Either<ValueFailure<String>, String> value;
  
  factory UserRole(String input) {
    return UserRole._(
      validateUserRole(input),
    );
  }
  
  const UserRole._(this.value) : super(value);
  
  // 预定义角色常量
  static UserRole get admin => UserRole('admin');
  static UserRole get user => UserRole('user');
  static UserRole get nutritionist => UserRole('nutritionist');
  static UserRole get merchant => UserRole('merchant');
}

/// 验证用户角色
Either<ValueFailure<String>, String> validateUserRole(String input) {
  const validRoles = ['admin', 'user', 'nutritionist', 'merchant'];
  
  if (input.isEmpty) {
    return left(ValueFailure.empty(failedValue: input));
  }
  if (!validRoles.contains(input)) {
    return left(ValueFailure.invalidFormat(
      failedValue: input,
      message: '无效的用户角色',
    ));
  }
  return right(input);
}