import 'package:equatable/equatable.dart';

/// 配置值类型枚举
enum ConfigValueType {
  boolean,
  number,
  string,
  json,
  array;
  
  static ConfigValueType fromString(String value) {
    return ConfigValueType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ConfigValueType.string,
    );
  }
}

/// 配置分类枚举
enum ConfigCategory {
  feature,
  system,
  business,
  ui,
  security;
  
  static ConfigCategory fromString(String value) {
    return ConfigCategory.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ConfigCategory.system,
    );
  }
}

/// 系统配置实体
class SystemConfig extends Equatable {
  final String? id;
  final String key;
  final dynamic value;
  final ConfigValueType valueType;
  final ConfigCategory category;
  final String description;
  final bool isPublic;
  final bool isEditable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? remark;
  
  const SystemConfig({
    this.id,
    required this.key,
    required this.value,
    required this.valueType,
    required this.category,
    required this.description,
    required this.isPublic,
    required this.isEditable,
    this.createdAt,
    this.updatedAt,
    this.remark,
  });
  
  @override
  List<Object?> get props => [
    id,
    key,
    value,
    valueType,
    category,
    description,
    isPublic,
    isEditable,
    createdAt,
    updatedAt,
    remark,
  ];
  
  SystemConfig copyWith({
    String? id,
    String? key,
    dynamic value,
    ConfigValueType? valueType,
    ConfigCategory? category,
    String? description,
    bool? isPublic,
    bool? isEditable,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? remark,
  }) {
    return SystemConfig(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
      valueType: valueType ?? this.valueType,
      category: category ?? this.category,
      description: description ?? this.description,
      isPublic: isPublic ?? this.isPublic,
      isEditable: isEditable ?? this.isEditable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      remark: remark ?? this.remark,
    );
  }
  
  /// 获取类型化的值
  T? getValue<T>() {
    if (value is T) {
      return value as T;
    }
    return null;
  }
  
  /// 获取布尔值
  bool getBoolValue() {
    if (valueType == ConfigValueType.boolean) {
      return value == true;
    }
    return false;
  }
  
  /// 获取字符串值
  String getStringValue() {
    if (value == null) return '';
    return value.toString();
  }
  
  /// 获取数字值
  num getNumberValue() {
    if (valueType == ConfigValueType.number) {
      if (value is num) {
        return value as num;
      }
      // 尝试解析字符串
      final parsed = num.tryParse(value.toString());
      if (parsed != null) {
        return parsed;
      }
    }
    return 0;
  }
}

/// 认证配置常量
class CertificationConfigKeys {
  static const String merchantCertificationEnabled = 'merchant_certification_enabled';
  static const String nutritionistCertificationEnabled = 'nutritionist_certification_enabled';
  static const String merchantCertificationMode = 'merchant_certification_mode';
  static const String nutritionistCertificationMode = 'nutritionist_certification_mode';
}

/// 认证模式枚举
enum CertificationMode {
  contact('contact', '联系客服'),
  auto('auto', '自动认证');
  
  final String value;
  final String label;
  
  const CertificationMode(this.value, this.label);
  
  static CertificationMode fromString(String value) {
    return CertificationMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CertificationMode.contact,
    );
  }
}