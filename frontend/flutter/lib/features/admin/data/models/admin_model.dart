import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/admin.dart';

part 'admin_model.freezed.dart';
part 'admin_model.g.dart';

/// Uadmin 数据模型
@freezed
class UadminModel with _$UadminModel {
  const factory UadminModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UadminModel;

  factory UadminModel.fromJson(Map<String, dynamic> json) =>
      _$UadminModelFromJson(json);
      
  const UadminModel._();
  
  /// 转换为实体
  Uadmin toEntity() => Uadmin(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UadminModel.fromEntity(Uadmin entity) => UadminModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
