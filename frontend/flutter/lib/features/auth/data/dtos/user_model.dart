import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../shared/enums/user_role.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    String? email,
    String? nickname,
    String? avatar,
    required UserRole role,
    @Default(false) bool isProfileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}