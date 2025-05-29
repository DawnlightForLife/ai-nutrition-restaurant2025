import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation.dart';

part 'recommendation_model.freezed.dart';
part 'recommendation_model.g.dart';

/// Urecommendation 数据模型
@freezed
class UrecommendationModel with _$UrecommendationModel {
  const factory UrecommendationModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UrecommendationModel;

  factory UrecommendationModel.fromJson(Map<String, dynamic> json) =>
      _$UrecommendationModelFromJson(json);
      
  const UrecommendationModel._();
  
  /// 转换为实体
  Urecommendation toEntity() => Urecommendation(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UrecommendationModel.fromEntity(Urecommendation entity) => UrecommendationModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
