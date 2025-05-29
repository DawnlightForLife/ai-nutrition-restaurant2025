import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/forum.dart';

part 'forum_model.freezed.dart';
part 'forum_model.g.dart';

/// Uforum 数据模型
@freezed
class UforumModel with _$UforumModel {
  const factory UforumModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UforumModel;

  factory UforumModel.fromJson(Map<String, dynamic> json) =>
      _$UforumModelFromJson(json);
      
  const UforumModel._();
  
  /// 转换为实体
  Uforum toEntity() => Uforum(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UforumModel.fromEntity(Uforum entity) => UforumModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
