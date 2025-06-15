import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/nutrition_profile_v2.dart';
import '../../domain/constants/nutrition_constants.dart';

/// 营养档案导出服务
/// 
/// 支持多种格式的数据导出：JSON、CSV、文本格式
class ProfileExportService {
  
  /// 导出为JSON格式
  Future<ExportResult> exportToJson(
    List<NutritionProfileV2> profiles, {
    String? customFilename,
  }) async {
    try {
      final filename = customFilename ?? 'nutrition_profiles_${_getTimestamp()}.json';
      
      final jsonData = {
        'exportInfo': {
          'version': '1.0',
          'exportDate': DateTime.now().toIso8601String(),
          'profileCount': profiles.length,
          'appVersion': '1.0.0',
        },
        'profiles': profiles.map((profile) => _profileToJsonMap(profile)).toList(),
      };
      
      final jsonString = const JsonEncoder.withIndent('  ').convert(jsonData);
      final file = await _saveToFile(filename, jsonString);
      
      return ExportResult.success(
        filePath: file.path,
        filename: filename,
        format: ExportFormat.json,
        fileSize: await file.length(),
      );
      
    } catch (e) {
      return ExportResult.error('JSON导出失败：$e');
    }
  }

  /// 导出为CSV格式
  Future<ExportResult> exportToCsv(
    List<NutritionProfileV2> profiles, {
    String? customFilename,
  }) async {
    try {
      final filename = customFilename ?? 'nutrition_profiles_${_getTimestamp()}.csv';
      
      // CSV表头
      final headers = [
        '档案名称', '性别', '年龄段', '身高(cm)', '体重(kg)',
        '健康目标', '目标热量(kcal)', '饮食偏好', '疾病史',
        '运动频率', '营养偏向', '特殊状态', '禁忌食材', '过敏原',
        '完整度(%)', '创建时间', '更新时间'
      ];
      
      // CSV数据行
      final rows = profiles.map((profile) => [
        profile.profileName,
        _getGenderText(profile.gender),
        _getAgeGroupText(profile.ageGroup),
        profile.height.toString(),
        profile.weight.toString(),
        _getHealthGoalText(profile.healthGoal),
        profile.targetCalories.toString(),
        _listToString(profile.dietaryPreferences.map(_getDietaryPreferenceText)),
        _listToString(profile.medicalConditions.map(_getMedicalConditionText)),
        _getExerciseFrequencyText(profile.exerciseFrequency),
        _listToString(profile.nutritionPreferences.map(_getNutritionPreferenceText)),
        _listToString(profile.specialStatus.map(_getSpecialStatusText)),
        _listToString(profile.forbiddenIngredients),
        _listToString(profile.allergies),
        '${profile.completionPercentage}%',
        _formatDateTime(profile.createdAt),
        _formatDateTime(profile.updatedAt),
      ]).toList();
      
      final csvData = [headers, ...rows];
      final csvString = const ListToCsvConverter().convert(csvData);
      
      final file = await _saveToFile(filename, csvString);
      
      return ExportResult.success(
        filePath: file.path,
        filename: filename,
        format: ExportFormat.csv,
        fileSize: await file.length(),
      );
      
    } catch (e) {
      return ExportResult.error('CSV导出失败：$e');
    }
  }

  /// 导出为可读文本格式
  Future<ExportResult> exportToText(
    List<NutritionProfileV2> profiles, {
    String? customFilename,
  }) async {
    try {
      final filename = customFilename ?? 'nutrition_profiles_${_getTimestamp()}.txt';
      
      final buffer = StringBuffer();
      buffer.writeln('营养档案导出报告');
      buffer.writeln('=' * 50);
      buffer.writeln('导出时间：${_formatDateTime(DateTime.now())}');
      buffer.writeln('档案数量：${profiles.length}个');
      buffer.writeln();
      
      for (int i = 0; i < profiles.length; i++) {
        final profile = profiles[i];
        buffer.writeln('档案 ${i + 1}：${profile.profileName}');
        buffer.writeln('-' * 30);
        buffer.writeln('基本信息：');
        buffer.writeln('  性别：${_getGenderText(profile.gender)}');
        buffer.writeln('  年龄段：${_getAgeGroupText(profile.ageGroup)}');
        buffer.writeln('  身高：${profile.height}cm');
        buffer.writeln('  体重：${profile.weight}kg');
        buffer.writeln();
        
        buffer.writeln('健康目标：');
        buffer.writeln('  目标：${_getHealthGoalText(profile.healthGoal)}');
        buffer.writeln('  目标热量：${profile.targetCalories}kcal/天');
        buffer.writeln();
        
        if (profile.dietaryPreferences.isNotEmpty) {
          buffer.writeln('饮食偏好：');
          for (final pref in profile.dietaryPreferences) {
            buffer.writeln('  • ${_getDietaryPreferenceText(pref)}');
          }
          buffer.writeln();
        }
        
        if (profile.medicalConditions.isNotEmpty) {
          buffer.writeln('健康状况：');
          for (final condition in profile.medicalConditions) {
            buffer.writeln('  • ${_getMedicalConditionText(condition)}');
          }
          buffer.writeln();
        }
        
        if (profile.exerciseFrequency != null) {
          buffer.writeln('运动频率：${_getExerciseFrequencyText(profile.exerciseFrequency)}');
          buffer.writeln();
        }
        
        if (profile.allergies.isNotEmpty || profile.forbiddenIngredients.isNotEmpty) {
          buffer.writeln('禁忌信息：');
          if (profile.allergies.isNotEmpty) {
            buffer.writeln('  过敏原：${profile.allergies.join('、')}');
          }
          if (profile.forbiddenIngredients.isNotEmpty) {
            buffer.writeln('  禁忌食材：${profile.forbiddenIngredients.join('、')}');
          }
          buffer.writeln();
        }
        
        buffer.writeln('档案信息：');
        buffer.writeln('  完整度：${profile.completionPercentage}%');
        buffer.writeln('  创建时间：${_formatDateTime(profile.createdAt)}');
        buffer.writeln('  更新时间：${_formatDateTime(profile.updatedAt)}');
        
        if (i < profiles.length - 1) {
          buffer.writeln();
          buffer.writeln('=' * 50);
          buffer.writeln();
        }
      }
      
      final file = await _saveToFile(filename, buffer.toString());
      
      return ExportResult.success(
        filePath: file.path,
        filename: filename,
        format: ExportFormat.text,
        fileSize: await file.length(),
      );
      
    } catch (e) {
      return ExportResult.error('文本导出失败：$e');
    }
  }

  /// 分享导出的文件
  Future<ShareResult> shareExportedFile(ExportResult exportResult) async {
    if (!exportResult.isSuccess) {
      return ShareResult.error('无法分享失败的导出文件');
    }
    
    try {
      final result = await Share.shareXFiles(
        [XFile(exportResult.filePath!)],
        text: '营养档案导出文件 - ${exportResult.filename}',
        subject: '营养档案数据',
      );
      
      return ShareResult.success(result);
      
    } catch (e) {
      return ShareResult.error('分享失败：$e');
    }
  }

  /// 获取导出文件的信息
  Future<List<ExportFileInfo>> getExportedFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final exportDir = Directory('${directory.path}/exports');
      
      if (!await exportDir.exists()) {
        return [];
      }
      
      final files = await exportDir.list().toList();
      final exportFiles = <ExportFileInfo>[];
      
      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          final filename = file.path.split('/').last;
          final format = _getFormatFromFilename(filename);
          
          exportFiles.add(ExportFileInfo(
            filename: filename,
            filePath: file.path,
            format: format,
            fileSize: stat.size,
            createdAt: stat.modified,
          ));
        }
      }
      
      // 按创建时间倒序排列
      exportFiles.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return exportFiles;
      
    } catch (e) {
      return [];
    }
  }

  /// 删除导出文件
  Future<bool> deleteExportedFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// 清理所有导出文件
  Future<int> clearAllExportedFiles() async {
    try {
      final files = await getExportedFiles();
      int deletedCount = 0;
      
      for (final fileInfo in files) {
        if (await deleteExportedFile(fileInfo.filePath)) {
          deletedCount++;
        }
      }
      
      return deletedCount;
    } catch (e) {
      return 0;
    }
  }

  // 私有辅助方法
  
  Map<String, dynamic> _profileToJsonMap(NutritionProfileV2 profile) {
    return {
      'id': profile.id,
      'profileName': profile.profileName,
      'gender': profile.gender,
      'ageGroup': profile.ageGroup,
      'height': profile.height,
      'weight': profile.weight,
      'healthGoal': profile.healthGoal,
      'targetCalories': profile.targetCalories,
      'dietaryPreferences': profile.dietaryPreferences,
      'medicalConditions': profile.medicalConditions,
      'exerciseFrequency': profile.exerciseFrequency,
      'nutritionPreferences': profile.nutritionPreferences,
      'specialStatus': profile.specialStatus,
      'forbiddenIngredients': profile.forbiddenIngredients,
      'allergies': profile.allergies,
      'activityDetails': profile.activityDetails,
      'healthGoalDetails': profile.healthGoalDetails,
      'isPrimary': profile.isPrimary,
      'completionPercentage': profile.completionPercentage,
      'createdAt': profile.createdAt.toIso8601String(),
      'updatedAt': profile.updatedAt.toIso8601String(),
    };
  }

  Future<File> _saveToFile(String filename, String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');
    
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }
    
    final file = File('${exportDir.path}/$filename');
    return await file.writeAsString(content);
  }

  String _getTimestamp() {
    final now = DateTime.now();
    return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_'
           '${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.year}年${dateTime.month}月${dateTime.day}日 '
           '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _listToString(Iterable<String> items) {
    return items.isEmpty ? '-' : items.join('、');
  }

  String _getGenderText(String gender) {
    return NutritionConstants.genderOptions[gender] ?? gender;
  }

  String _getAgeGroupText(String ageGroup) {
    return NutritionConstants.ageGroupOptions[ageGroup] ?? ageGroup;
  }

  String _getHealthGoalText(String healthGoal) {
    return NutritionConstants.healthGoalOptions[healthGoal] ?? healthGoal;
  }

  String _getDietaryPreferenceText(String pref) {
    return NutritionConstants.dietaryPreferenceOptions[pref] ?? pref;
  }

  String _getMedicalConditionText(String condition) {
    return NutritionConstants.medicalConditionOptions[condition] ?? condition;
  }

  String _getNutritionPreferenceText(String pref) {
    return NutritionConstants.nutritionPreferenceOptions[pref] ?? pref;
  }

  String _getSpecialStatusText(String status) {
    return NutritionConstants.specialStatusOptions[status] ?? status;
  }

  String _getExerciseFrequencyText(String? frequency) {
    if (frequency == null) return '-';
    return NutritionConstants.exerciseFrequencyOptions[frequency] ?? frequency;
  }

  ExportFormat _getFormatFromFilename(String filename) {
    if (filename.endsWith('.json')) return ExportFormat.json;
    if (filename.endsWith('.csv')) return ExportFormat.csv;
    if (filename.endsWith('.txt')) return ExportFormat.text;
    return ExportFormat.unknown;
  }
}

// 数据模型定义

enum ExportFormat {
  json,
  csv,
  text,
  unknown,
}

class ExportResult {
  final bool isSuccess;
  final String? filePath;
  final String? filename;
  final ExportFormat? format;
  final int? fileSize;
  final String? error;

  ExportResult._({
    required this.isSuccess,
    this.filePath,
    this.filename,
    this.format,
    this.fileSize,
    this.error,
  });

  factory ExportResult.success({
    required String filePath,
    required String filename,
    required ExportFormat format,
    required int fileSize,
  }) {
    return ExportResult._(
      isSuccess: true,
      filePath: filePath,
      filename: filename,
      format: format,
      fileSize: fileSize,
    );
  }

  factory ExportResult.error(String error) {
    return ExportResult._(
      isSuccess: false,
      error: error,
    );
  }

  String get fileSizeText {
    if (fileSize == null) return '';
    final kb = fileSize! / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)}KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(1)}MB';
    }
  }
}

class ShareResult {
  final bool isSuccess;
  final ShareResultStatus? status;
  final String? error;

  ShareResult._({
    required this.isSuccess,
    this.status,
    this.error,
  });

  factory ShareResult.success(ShareResultStatus status) {
    return ShareResult._(
      isSuccess: true,
      status: status,
    );
  }

  factory ShareResult.error(String error) {
    return ShareResult._(
      isSuccess: false,
      error: error,
    );
  }
}

class ExportFileInfo {
  final String filename;
  final String filePath;
  final ExportFormat format;
  final int fileSize;
  final DateTime createdAt;

  ExportFileInfo({
    required this.filename,
    required this.filePath,
    required this.format,
    required this.fileSize,
    required this.createdAt,
  });

  String get formatText {
    switch (format) {
      case ExportFormat.json:
        return 'JSON';
      case ExportFormat.csv:
        return 'CSV';
      case ExportFormat.text:
        return 'TXT';
      case ExportFormat.unknown:
        return '未知';
    }
  }

  String get fileSizeText {
    final kb = fileSize / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(1)}KB';
    } else {
      final mb = kb / 1024;
      return '${mb.toStringAsFixed(1)}MB';
    }
  }
}