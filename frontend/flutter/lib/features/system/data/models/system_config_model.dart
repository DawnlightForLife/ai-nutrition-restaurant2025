import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/system_config.dart';

part 'system_config_model.freezed.dart';
part 'system_config_model.g.dart';

/// 系统配置模型
@freezed
class SystemConfigModel with _$SystemConfigModel {
  const SystemConfigModel._();
  
  const factory SystemConfigModel({
    String? id,
    required String key,
    required dynamic value,
    String? valueType,
    String? category,
    String? description,
    bool? isPublic,
    bool? isEditable,
    Map<String, dynamic>? updatedBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? remark,
  }) = _SystemConfigModel;
  
  factory SystemConfigModel.fromJson(Map<String, dynamic> json) =>
      _$SystemConfigModelFromJson(json);
  
  factory SystemConfigModel.fromEntity(SystemConfig entity) {
    return SystemConfigModel(
      id: entity.id,
      key: entity.key,
      value: entity.value,
      valueType: entity.valueType.name,
      category: entity.category.name,
      description: entity.description,
      isPublic: entity.isPublic,
      isEditable: entity.isEditable,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      remark: entity.remark,
    );
  }
  
  SystemConfig toEntity() {
    return SystemConfig(
      id: id,
      key: key,
      value: value,
      valueType: ConfigValueType.fromString(valueType ?? 'string'),
      category: ConfigCategory.fromString(category ?? 'system'),
      description: description ?? '',
      isPublic: isPublic ?? false,
      isEditable: isEditable ?? true,
      createdAt: createdAt,
      updatedAt: updatedAt,
      remark: remark,
    );
  }
}