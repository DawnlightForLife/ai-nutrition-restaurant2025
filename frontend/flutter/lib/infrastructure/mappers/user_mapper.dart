import 'package:dartz/dartz.dart';
import '../../domain/user/entities/user.dart';
import '../../domain/user/value_objects/user_id.dart';
import '../../domain/user/value_objects/email.dart';
import '../../domain/user/value_objects/phone.dart';
import '../../domain/user/value_objects/user_name.dart';
import '../../domain/user/value_objects/user_role.dart';
import '../../domain/common/failures/failures.dart';
import '../dtos/user_dto.dart';

/// 用户映射器
/// 负责DTO和实体之间的转换
class UserMapper {
  /// 将UserDto转换为User实体
  static Either<AppFailure, User> fromDto(UserDto dto) {
    try {
      // 创建值对象
      final userIdResult = UserId(dto.id);
      final emailResult = dto.email != null ? Email(dto.email!) : null;
      final phoneResult = Phone(dto.phone);
      final nicknameResult = dto.nickname != null ? UserName(dto.nickname!) : UserName('用户${dto.phone.substring(dto.phone.length - 4)}');
      final roleResult = UserRole(dto.role);

      // 检查值对象是否有效
      return userIdResult.value.fold(
        (failure) => Left(ValidationFailure(message: 'Invalid user ID: ${failure.toString()}')),
        (userId) => phoneResult.value.fold(
          (failure) => Left(ValidationFailure(message: 'Invalid phone: ${failure.toString()}')),
          (phone) => nicknameResult.value.fold(
            (failure) => Left(ValidationFailure(message: 'Invalid nickname: ${failure.toString()}')),
            (nickname) => roleResult.value.fold(
              (failure) => Left(ValidationFailure(message: 'Invalid role: ${failure.toString()}')),
              (role) {
                // 如果有邮箱，检查邮箱是否有效
                if (emailResult != null) {
                  return emailResult.value.fold(
                    (failure) => Left(ValidationFailure(message: 'Invalid email: ${failure.toString()}')),
                    (email) => Right(_createUser(
                      userId: userIdResult,
                      email: emailResult,
                      phone: phoneResult,
                      nickname: nicknameResult,
                      role: roleResult,
                      dto: dto,
                    )),
                  );
                } else {
                  // 没有邮箱的情况，创建默认邮箱
                  final defaultEmail = Email('${dto.phone}@temp.com');
                  return defaultEmail.value.fold(
                    (failure) => Left(ValidationFailure(message: 'Invalid email: ${failure.toString()}')),
                    (email) => Right(_createUser(
                      userId: userIdResult,
                      email: defaultEmail,
                      phone: phoneResult,
                      nickname: nicknameResult,
                      role: roleResult,
                      dto: dto,
                    )),
                  );
                }
              },
            ),
          ),
        ),
      );
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  /// 创建User实体的辅助方法
  static User _createUser({
    required UserId userId,
    required Email email,
    required Phone phone,
    required UserName nickname,
    required UserRole role,
    required UserDto dto,
  }) {
    return User(
      id: userId,
      email: email,
      phone: phone,
      nickname: nickname,
      role: role,
      avatar: dto.avatar,
      gender: dto.gender,
      age: dto.age,
      isActive: dto.isActive ?? true,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt ?? DateTime.now(),
    );
  }

  /// 将User实体转换为UserDto
  static UserDto toDto(User user) {
    return UserDto(
      id: user.id.value.fold((_) => '', (id) => id),
      email: user.email.value.fold((_) => null, (email) => email),
      phone: user.phone.value.fold((_) => '', (phone) => phone),
      nickname: user.nickname.value.fold((_) => null, (name) => name),
      role: user.role.value.fold((_) => 'user', (role) => role),
      avatar: user.avatar,
      gender: user.gender,
      age: user.age,
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    );
  }
}