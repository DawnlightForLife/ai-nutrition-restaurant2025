import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// Uuser 数据模型
@freezed
class UuserModel with _$UuserModel {
  const factory UuserModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UuserModel;

  factory UuserModel.fromJson(Map<String, dynamic> json) =>
      _$UuserModelFromJson(json);
      
  const UuserModel._();
  
  /// 转换为实体
  Uuser toEntity() => Uuser(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UuserModel.fromEntity(Uuser entity) => UuserModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
