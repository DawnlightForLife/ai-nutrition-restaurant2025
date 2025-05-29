import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/nutritionist.dart';

part 'nutritionist_model.freezed.dart';
part 'nutritionist_model.g.dart';

/// Unutritionist 数据模型
@freezed
class UnutritionistModel with _$UnutritionistModel {
  const factory UnutritionistModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UnutritionistModel;

  factory UnutritionistModel.fromJson(Map<String, dynamic> json) =>
      _$UnutritionistModelFromJson(json);
      
  const UnutritionistModel._();
  
  /// 转换为实体
  Unutritionist toEntity() => Unutritionist(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UnutritionistModel.fromEntity(Unutritionist entity) => UnutritionistModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
