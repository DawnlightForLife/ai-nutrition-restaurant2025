import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/order.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// Uorder 数据模型
@freezed
class UorderModel with _$UorderModel {
  const factory UorderModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UorderModel;

  factory UorderModel.fromJson(Map<String, dynamic> json) =>
      _$UorderModelFromJson(json);
      
  const UorderModel._();
  
  /// 转换为实体
  Uorder toEntity() => Uorder(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UorderModel.fromEntity(Uorder entity) => UorderModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
