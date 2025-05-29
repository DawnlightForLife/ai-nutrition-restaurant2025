import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/common.dart';

part 'common_model.freezed.dart';
part 'common_model.g.dart';

/// Ucommon 数据模型
@freezed
class UcommonModel with _$UcommonModel {
  const factory UcommonModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UcommonModel;

  factory UcommonModel.fromJson(Map<String, dynamic> json) =>
      _$UcommonModelFromJson(json);
      
  const UcommonModel._();
  
  /// 转换为实体
  Ucommon toEntity() => Ucommon(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UcommonModel.fromEntity(Ucommon entity) => UcommonModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
