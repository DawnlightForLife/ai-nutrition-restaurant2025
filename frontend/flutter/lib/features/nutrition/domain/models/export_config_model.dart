/// 导出格式枚举
enum ExportFormat {
  json('JSON', 'json', '数据格式，适合开发者'),
  pdf('PDF', 'pdf', '便携文档格式，适合查看和打印'),
  excel('Excel', 'xlsx', '电子表格格式，适合数据分析');

  const ExportFormat(this.displayName, this.extension, this.description);
  
  final String displayName;
  final String extension;
  final String description;
}

/// 导出配置模型
class ExportConfig {
  final ExportFormat format;
  final bool includeBasicInfo;
  final bool includeHealthGoals;
  final bool includeDietaryPreferences;
  final bool includeProgress;
  final bool includeDetailedConfig;
  final String? customFileName;
  final DateTime? dateRange;
  final List<String>? selectedProfileIds;

  const ExportConfig({
    required this.format,
    this.includeBasicInfo = true,
    this.includeHealthGoals = true,
    this.includeDietaryPreferences = true,
    this.includeProgress = true,
    this.includeDetailedConfig = false,
    this.customFileName,
    this.dateRange,
    this.selectedProfileIds,
  });

  /// 创建默认配置
  factory ExportConfig.defaultConfig(ExportFormat format) {
    return ExportConfig(
      format: format,
      includeBasicInfo: true,
      includeHealthGoals: true,
      includeDietaryPreferences: true,
      includeProgress: true,
      includeDetailedConfig: false,
    );
  }

  /// 创建最小配置（仅基本信息）
  factory ExportConfig.minimal(ExportFormat format) {
    return ExportConfig(
      format: format,
      includeBasicInfo: true,
      includeHealthGoals: false,
      includeDietaryPreferences: false,
      includeProgress: false,
      includeDetailedConfig: false,
    );
  }

  /// 创建完整配置（所有信息）
  factory ExportConfig.complete(ExportFormat format) {
    return ExportConfig(
      format: format,
      includeBasicInfo: true,
      includeHealthGoals: true,
      includeDietaryPreferences: true,
      includeProgress: true,
      includeDetailedConfig: true,
    );
  }

  /// 复制并修改配置
  ExportConfig copyWith({
    ExportFormat? format,
    bool? includeBasicInfo,
    bool? includeHealthGoals,
    bool? includeDietaryPreferences,
    bool? includeProgress,
    bool? includeDetailedConfig,
    String? customFileName,
    DateTime? dateRange,
    List<String>? selectedProfileIds,
  }) {
    return ExportConfig(
      format: format ?? this.format,
      includeBasicInfo: includeBasicInfo ?? this.includeBasicInfo,
      includeHealthGoals: includeHealthGoals ?? this.includeHealthGoals,
      includeDietaryPreferences: includeDietaryPreferences ?? this.includeDietaryPreferences,
      includeProgress: includeProgress ?? this.includeProgress,
      includeDetailedConfig: includeDetailedConfig ?? this.includeDetailedConfig,
      customFileName: customFileName ?? this.customFileName,
      dateRange: dateRange ?? this.dateRange,
      selectedProfileIds: selectedProfileIds ?? this.selectedProfileIds,
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'format': format.name,
      'include_basic_info': includeBasicInfo,
      'include_health_goals': includeHealthGoals,
      'include_dietary_preferences': includeDietaryPreferences,
      'include_progress': includeProgress,
      'include_detailed_config': includeDetailedConfig,
      'custom_file_name': customFileName,
      'date_range': dateRange?.toIso8601String(),
      'selected_profile_ids': selectedProfileIds,
    };
  }

  /// 从JSON创建
  factory ExportConfig.fromJson(Map<String, dynamic> json) {
    return ExportConfig(
      format: ExportFormat.values.firstWhere(
        (f) => f.name == json['format'],
        orElse: () => ExportFormat.json,
      ),
      includeBasicInfo: json['include_basic_info'] ?? true,
      includeHealthGoals: json['include_health_goals'] ?? true,
      includeDietaryPreferences: json['include_dietary_preferences'] ?? true,
      includeProgress: json['include_progress'] ?? true,
      includeDetailedConfig: json['include_detailed_config'] ?? false,
      customFileName: json['custom_file_name'],
      dateRange: json['date_range'] != null 
          ? DateTime.parse(json['date_range']) 
          : null,
      selectedProfileIds: json['selected_profile_ids']?.cast<String>(),
    );
  }

  /// 获取包含的字段数量
  int get includedFieldsCount {
    int count = 0;
    if (includeBasicInfo) count++;
    if (includeHealthGoals) count++;
    if (includeDietaryPreferences) count++;
    if (includeProgress) count++;
    if (includeDetailedConfig) count++;
    return count;
  }

  /// 是否为空配置
  bool get isEmpty {
    return !includeBasicInfo && 
           !includeHealthGoals && 
           !includeDietaryPreferences && 
           !includeProgress && 
           !includeDetailedConfig;
  }

  /// 获取配置描述
  String get description {
    if (isEmpty) return '未选择任何数据';
    
    final fields = <String>[];
    if (includeBasicInfo) fields.add('基本信息');
    if (includeHealthGoals) fields.add('健康目标');
    if (includeDietaryPreferences) fields.add('饮食偏好');
    if (includeProgress) fields.add('进度统计');
    if (includeDetailedConfig) fields.add('详细配置');
    
    return fields.join('、');
  }

  @override
  String toString() {
    return 'ExportConfig(format: $format, fields: $includedFieldsCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ExportConfig &&
      other.format == format &&
      other.includeBasicInfo == includeBasicInfo &&
      other.includeHealthGoals == includeHealthGoals &&
      other.includeDietaryPreferences == includeDietaryPreferences &&
      other.includeProgress == includeProgress &&
      other.includeDetailedConfig == includeDetailedConfig &&
      other.customFileName == customFileName;
  }

  @override
  int get hashCode {
    return format.hashCode ^
      includeBasicInfo.hashCode ^
      includeHealthGoals.hashCode ^
      includeDietaryPreferences.hashCode ^
      includeProgress.hashCode ^
      includeDetailedConfig.hashCode ^
      customFileName.hashCode;
  }
}

/// 导出结果类
class ExportResult {
  final bool isSuccess;
  final String message;
  final String? filePath;
  final String? fileName;
  final int? fileSize;
  final String? error;

  const ExportResult._({
    required this.isSuccess,
    required this.message,
    this.filePath,
    this.fileName,
    this.fileSize,
    this.error,
  });

  /// 成功结果
  factory ExportResult.success({
    required String message,
    String? filePath,
    String? fileName,
    int? fileSize,
  }) {
    return ExportResult._(
      isSuccess: true,
      message: message,
      filePath: filePath,
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  /// 失败结果
  factory ExportResult.failure(String error) {
    return ExportResult._(
      isSuccess: false,
      message: error,
      error: error,
    );
  }

  /// 获取文件大小描述
  String? get fileSizeDescription {
    if (fileSize == null) return null;
    
    if (fileSize! < 1024) {
      return '${fileSize}B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    } else {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
  }

  @override
  String toString() {
    return isSuccess 
        ? 'ExportResult.success($message)'
        : 'ExportResult.failure($error)';
  }
}