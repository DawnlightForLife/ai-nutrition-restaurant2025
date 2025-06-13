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
    String? avatar, // 旧字段，保留兼容性
    String? avatarUrl, // 新字段，优先使用
    required UserRole role,
    @Default(false) bool isProfileCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// 扩展UserModel添加便捷方法
extension UserModelExtension on UserModel {
  // 获取头像URL（优先使用avatarUrl，兼容avatar字段）
  String? get displayAvatarUrl => avatarUrl ?? avatar;
}