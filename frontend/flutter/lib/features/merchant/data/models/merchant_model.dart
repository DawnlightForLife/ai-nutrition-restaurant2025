import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/merchant.dart';

part 'merchant_model.freezed.dart';
part 'merchant_model.g.dart';

/// Umerchant 数据模型
@freezed
class UmerchantModel with _$UmerchantModel {
  const factory UmerchantModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UmerchantModel;

  factory UmerchantModel.fromJson(Map<String, dynamic> json) =>
      _$UmerchantModelFromJson(json);
      
  const UmerchantModel._();
  
  /// 转换为实体
  Umerchant toEntity() => Umerchant(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UmerchantModel.fromEntity(Umerchant entity) => UmerchantModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
