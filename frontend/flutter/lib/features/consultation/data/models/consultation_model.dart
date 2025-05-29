import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/consultation.dart';

part 'consultation_model.freezed.dart';
part 'consultation_model.g.dart';

/// Uconsultation 数据模型
@freezed
class UconsultationModel with _$UconsultationModel {
  const factory UconsultationModel({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _UconsultationModel;

  factory UconsultationModel.fromJson(Map<String, dynamic> json) =>
      _$UconsultationModelFromJson(json);
      
  const UconsultationModel._();
  
  /// 转换为实体
  Uconsultation toEntity() => Uconsultation(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
  
  /// 从实体创建
  factory UconsultationModel.fromEntity(Uconsultation entity) => UconsultationModel(
    id: entity.id,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );
}
