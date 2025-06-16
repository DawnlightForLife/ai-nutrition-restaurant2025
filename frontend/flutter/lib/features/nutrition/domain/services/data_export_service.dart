import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import '../entities/nutrition_profile_v2.dart';
import '../models/export_config_model.dart';

/// 数据导出服务
/// 支持多种格式的营养档案数据导出
class DataExportService {

  /// 导出单个档案
  static Future<ExportResult> exportProfile(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) async {
    try {
      switch (config.format) {
        case ExportFormat.json:
          return await _exportToJson([profile], config);
        case ExportFormat.pdf:
          return await _exportToPdf([profile], config);
        case ExportFormat.excel:
          return await _exportToExcel([profile], config);
      }
    } catch (e) {
      return ExportResult.failure('导出失败: ${e.toString()}');
    }
  }

  /// 批量导出档案
  static Future<ExportResult> exportProfiles(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      if (profiles.isEmpty) {
        return ExportResult.failure('没有可导出的档案');
      }

      switch (config.format) {
        case ExportFormat.json:
          return await _exportToJson(profiles, config);
        case ExportFormat.pdf:
          return await _exportToPdf(profiles, config);
        case ExportFormat.excel:
          return await _exportToExcel(profiles, config);
      }
    } catch (e) {
      return ExportResult.failure('导出失败: ${e.toString()}');
    }
  }

  /// 导出为JSON格式
  static Future<ExportResult> _exportToJson(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      final data = {
        'export_info': {
          'export_time': DateTime.now().toIso8601String(),
          'export_version': '1.0.0',
          'total_profiles': profiles.length,
          'export_config': config.toJson(),
        },
        'profiles': profiles.map((profile) => _profileToExportData(profile, config)).toList(),
      };

      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      final fileName = _generateFileName(config, 'json');
      final filePath = await _saveToFile(jsonString, fileName);

      return ExportResult.success(
        filePath: filePath,
        fileName: fileName,
        fileSize: jsonString.length,
        message: '成功导出 ${profiles.length} 个档案为JSON格式',
      );
    } catch (e) {
      return ExportResult.failure('JSON导出失败: ${e.toString()}');
    }
  }

  /// 导出为PDF格式
  static Future<ExportResult> _exportToPdf(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      final pdf = pw.Document();
      
      // 添加PDF页面
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // 标题
              pw.Header(
                level: 0,
                text: '🥗 营养档案导出报告',
                textStyle: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              
              // 导出信息
              pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '导出信息',
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('导出时间: ${DateTime.now().toString()}'),
                    pw.Text('档案数量: ${profiles.length}'),
                    pw.Text('导出格式: PDF'),
                    pw.Text('包含内容: ${config.description}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 30),
              
              // 档案列表
              ...profiles.map((profile) => _generateProfilePdf(profile, config)),
            ];
          },
        ),
      );

      // 保存PDF
      final fileName = _generateFileName(config, 'pdf');
      final bytes = await pdf.save();
      final filePath = await _saveBytesToFile(bytes, fileName);

      return ExportResult.success(
        filePath: filePath,
        fileName: fileName,
        fileSize: bytes.length,
        message: '成功导出 ${profiles.length} 个档案为PDF格式',
      );
    } catch (e) {
      // 如果PDF生成失败，降级为HTML导出
      return await _exportToHtml(profiles, config);
    }
  }

  /// 导出为Excel格式
  static Future<ExportResult> _exportToExcel(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      final excel = Excel.createExcel();
      final sheet = excel['营养档案'];
      
      // 添加表头
      final headers = _getExcelHeaders(config);
      for (int i = 0; i < headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
          ..value = TextCellValue(headers[i])
          ..cellStyle = CellStyle(
            fontColorHex: ExcelColor.white,
            backgroundColorHex: ExcelColor.blue,
            bold: true,
          );
      }
      
      // 添加数据行
      for (int rowIndex = 0; rowIndex < profiles.length; rowIndex++) {
        final rowData = _profileToExcelRow(profiles[rowIndex], config);
        for (int colIndex = 0; colIndex < rowData.length; colIndex++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, 
            rowIndex: rowIndex + 1,
          ));
          
          final value = rowData[colIndex];
          if (value is String) {
            cell.value = TextCellValue(value);
          } else if (value is num) {
            cell.value = DoubleCellValue(value.toDouble());
          } else {
            cell.value = TextCellValue(value.toString());
          }
        }
      }
      
      // 自动调整列宽
      for (int i = 0; i < headers.length; i++) {
        sheet.setColumnAutoFit(i);
      }

      // 保存Excel文件
      final fileName = _generateFileName(config, 'xlsx');
      final bytes = excel.encode()!;
      final filePath = await _saveBytesToFile(bytes, fileName);

      return ExportResult.success(
        filePath: filePath,
        fileName: fileName,
        fileSize: bytes.length,
        message: '成功导出 ${profiles.length} 个档案为Excel格式',
      );
    } catch (e) {
      // 如果Excel生成失败，降级为CSV导出
      return await _exportToCsv(profiles, config);
    }
  }

  /// 降级方案：导出为HTML格式
  static Future<ExportResult> _exportToHtml(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      final html = _generateHtmlReport(profiles, config);
      final fileName = _generateFileName(config, 'html');
      final filePath = await _saveToFile(html, fileName);

      return ExportResult.success(
        filePath: filePath,
        fileName: fileName,
        fileSize: html.length,
        message: '成功导出 ${profiles.length} 个档案为HTML格式',
      );
    } catch (e) {
      return ExportResult.failure('HTML导出失败: ${e.toString()}');
    }
  }

  /// 降级方案：导出为CSV格式
  static Future<ExportResult> _exportToCsv(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) async {
    try {
      final csv = _generateCsvData(profiles, config);
      final fileName = _generateFileName(config, 'csv');
      final filePath = await _saveToFile(csv, fileName);

      return ExportResult.success(
        filePath: filePath,
        fileName: fileName,
        fileSize: csv.length,
        message: '成功导出 ${profiles.length} 个档案为CSV格式',
      );
    } catch (e) {
      return ExportResult.failure('CSV导出失败: ${e.toString()}');
    }
  }

  /// 将档案转换为导出数据
  static Map<String, dynamic> _profileToExportData(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) {
    final data = <String, dynamic>{};

    // 基本信息
    if (config.includeBasicInfo) {
      data['basic_info'] = {
        'profile_name': profile.profileName,
        'gender': profile.gender,
        'age_group': profile.ageGroup,
        'height': profile.height,
        'weight': profile.weight,
        'bmi': profile.weight / ((profile.height / 100) * (profile.height / 100)),
        'created_at': profile.createdAt.toIso8601String(),
        'updated_at': profile.updatedAt.toIso8601String(),
      };
    }

    // 健康目标
    if (config.includeHealthGoals) {
      data['health_goals'] = {
        'primary_goal': profile.healthGoal,
        'target_calories': profile.targetCalories,
        'health_goal_details': profile.healthGoalDetails,
      };
    }

    // 饮食偏好
    if (config.includeDietaryPreferences) {
      data['dietary_preferences'] = {
        'preferences': profile.dietaryPreferences,
        'medical_conditions': profile.medicalConditions,
        'exercise_frequency': profile.exerciseFrequency,
        'nutrition_preferences': profile.nutritionPreferences,
        'special_status': profile.specialStatus,
        'forbidden_ingredients': profile.forbiddenIngredients,
        'allergies': profile.allergies,
      };
    }

    // 进度统计
    if (config.includeProgress) {
      data['progress'] = {
        'completion_percentage': profile.completionPercentage,
        'total_energy_points': profile.totalEnergyPoints,
        'current_streak': profile.currentStreak,
        'best_streak': profile.bestStreak,
        'last_active_date': profile.lastActiveDate?.toIso8601String(),
        'nutrition_progress': profile.nutritionProgress,
      };
    }

    // 详细配置
    if (config.includeDetailedConfig) {
      data['detailed_config'] = {
        'activity_details': profile.activityDetails,
        'is_primary': profile.isPrimary,
      };
    }

    return data;
  }

  /// 生成Excel表头
  static List<String> _getExcelHeaders(ExportConfig config) {
    final headers = <String>[];

    if (config.includeBasicInfo) {
      headers.addAll([
        '档案名称', '性别', '年龄段', '身高(cm)', '体重(kg)', 'BMI', '创建时间', '更新时间'
      ]);
    }

    if (config.includeHealthGoals) {
      headers.addAll(['主要健康目标', '目标热量(kcal)']);
    }

    if (config.includeDietaryPreferences) {
      headers.addAll(['饮食偏好', '运动频率']);
    }

    if (config.includeProgress) {
      headers.addAll(['完整度(%)', '能量点数', '当前连续天数', '最佳连续天数']);
    }

    return headers;
  }

  /// 将档案转换为Excel行数据
  static List<dynamic> _profileToExcelRow(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) {
    final row = <dynamic>[];

    if (config.includeBasicInfo) {
      final bmi = profile.weight / ((profile.height / 100) * (profile.height / 100));
      row.addAll([
        profile.profileName,
        profile.gender,
        profile.ageGroup,
        profile.height,
        profile.weight,
        bmi.toStringAsFixed(1),
        profile.createdAt.toString(),
        profile.updatedAt.toString(),
      ]);
    }

    if (config.includeHealthGoals) {
      row.addAll([
        profile.healthGoal,
        profile.targetCalories,
      ]);
    }

    if (config.includeDietaryPreferences) {
      row.addAll([
        profile.dietaryPreferences.join(', '),
        profile.exerciseFrequency ?? '',
      ]);
    }

    if (config.includeProgress) {
      row.addAll([
        profile.completionPercentage,
        profile.totalEnergyPoints,
        profile.currentStreak,
        profile.bestStreak,
      ]);
    }

    return row;
  }

  /// 生成HTML报告
  static String _generateHtmlReport(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="zh-CN">');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="UTF-8">');
    buffer.writeln('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('<title>营养档案导出报告</title>');
    buffer.writeln('<style>');
    buffer.writeln(_getHtmlStyles());
    buffer.writeln('</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');
    
    // 标题
    buffer.writeln('<div class="header">');
    buffer.writeln('<h1>🥗 营养档案导出报告</h1>');
    buffer.writeln('<p>导出时间: ${DateTime.now().toString()}</p>');
    buffer.writeln('<p>档案数量: ${profiles.length}</p>');
    buffer.writeln('</div>');
    
    // 档案列表
    for (final profile in profiles) {
      buffer.writeln(_generateProfileHtml(profile, config));
    }
    
    buffer.writeln('</body>');
    buffer.writeln('</html>');
    
    return buffer.toString();
  }

  /// 生成CSV数据
  static String _generateCsvData(
    List<NutritionProfileV2> profiles,
    ExportConfig config,
  ) {
    final headers = _getExcelHeaders(config);
    final rows = profiles.map((profile) => _profileToExcelRow(profile, config)).toList();
    
    // 使用csv包生成CSV
    return const ListToCsvConverter().convert([headers, ...rows]);
  }

  /// 生成文件名
  static String _generateFileName(ExportConfig config, String extension) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final prefix = config.customFileName?.isNotEmpty == true 
        ? config.customFileName! 
        : 'nutrition_profiles';
    return '${prefix}_$timestamp.$extension';
  }

  /// 保存文件到本地
  static Future<String> _saveToFile(String content, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
    return file.path;
  }

  /// 保存字节数据到本地
  static Future<String> _saveBytesToFile(List<int> bytes, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// 生成单个档案的PDF内容
  static pw.Widget _generateProfilePdf(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 30),
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // 档案标题
          pw.Text(
            profile.profileName,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
            ),
          ),
          pw.SizedBox(height: 15),
          
          // 基本信息
          if (config.includeBasicInfo) ...[
            pw.Text(
              '📋 基本信息',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(children: [
                  pw.Text('性别: ${profile.gender}'),
                  pw.Text('年龄段: ${profile.ageGroup}'),
                  pw.Text('身高: ${profile.height}cm'),
                  pw.Text('体重: ${profile.weight}kg'),
                ]),
              ],
            ),
            pw.SizedBox(height: 15),
          ],
          
          // 健康目标
          if (config.includeHealthGoals) ...[
            pw.Text(
              '🎯 健康目标',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text('主要目标: ${profile.healthGoal}'),
            pw.Text('目标热量: ${profile.targetCalories}kcal/天'),
            pw.SizedBox(height: 15),
          ],
          
          // 进度统计
          if (config.includeProgress) ...[
            pw.Text(
              '📊 进度统计',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1),
              },
              children: [
                pw.TableRow(children: [
                  pw.Text('完整度: ${profile.completionPercentage}%'),
                  pw.Text('能量点数: ${profile.totalEnergyPoints}'),
                  pw.Text('连续天数: ${profile.currentStreak}天'),
                  pw.Text('最佳记录: ${profile.bestStreak}天'),
                ]),
              ],
            ),
            pw.SizedBox(height: 15),
          ],
          
          // 饮食偏好
          if (config.includeDietaryPreferences && profile.dietaryPreferences.isNotEmpty) ...[
            pw.Text(
              '🍽️ 饮食偏好',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(profile.dietaryPreferences.join(', ')),
            pw.SizedBox(height: 15),
          ],
        ],
      ),
    );
  }

  /// 分享导出的文件
  static Future<void> shareExportedFile(ExportResult result) async {
    if (result.isSuccess && result.filePath != null) {
      await Share.shareXFiles(
        [XFile(result.filePath!)],
        text: result.message,
      );
    }
  }

  /// 获取HTML样式
  static String _getHtmlStyles() {
    return '''
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        line-height: 1.6;
        color: #333;
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
        background: #f5f5f5;
      }
      .header {
        text-align: center;
        background: linear-gradient(135deg, #6366f1, #8b5cf6);
        color: white;
        padding: 30px;
        border-radius: 10px;
        margin-bottom: 30px;
      }
      .profile {
        background: white;
        padding: 25px;
        margin-bottom: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      }
      .profile h2 {
        color: #6366f1;
        border-bottom: 2px solid #e5e7eb;
        padding-bottom: 10px;
      }
      .info-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin: 20px 0;
      }
      .info-item {
        background: #f8fafc;
        padding: 15px;
        border-radius: 8px;
        border-left: 4px solid #6366f1;
      }
      .info-item strong {
        color: #374151;
        display: block;
        margin-bottom: 5px;
      }
    ''';
  }

  /// 生成单个档案的HTML
  static String _generateProfileHtml(
    NutritionProfileV2 profile,
    ExportConfig config,
  ) {
    final buffer = StringBuffer();
    
    buffer.writeln('<div class="profile">');
    buffer.writeln('<h2>${profile.profileName}</h2>');
    
    if (config.includeBasicInfo) {
      buffer.writeln('<h3>📋 基本信息</h3>');
      buffer.writeln('<div class="info-grid">');
      buffer.writeln('<div class="info-item"><strong>性别</strong>${profile.gender}</div>');
      buffer.writeln('<div class="info-item"><strong>年龄段</strong>${profile.ageGroup}</div>');
      buffer.writeln('<div class="info-item"><strong>身高</strong>${profile.height}cm</div>');
      buffer.writeln('<div class="info-item"><strong>体重</strong>${profile.weight}kg</div>');
      buffer.writeln('</div>');
    }
    
    if (config.includeHealthGoals) {
      buffer.writeln('<h3>🎯 健康目标</h3>');
      buffer.writeln('<div class="info-grid">');
      buffer.writeln('<div class="info-item"><strong>主要目标</strong>${profile.healthGoal}</div>');
      buffer.writeln('<div class="info-item"><strong>目标热量</strong>${profile.targetCalories}kcal</div>');
      buffer.writeln('</div>');
    }
    
    if (config.includeProgress) {
      buffer.writeln('<h3>📊 进度统计</h3>');
      buffer.writeln('<div class="info-grid">');
      buffer.writeln('<div class="info-item"><strong>完整度</strong>${profile.completionPercentage}%</div>');
      buffer.writeln('<div class="info-item"><strong>能量点数</strong>${profile.totalEnergyPoints}</div>');
      buffer.writeln('<div class="info-item"><strong>连续天数</strong>${profile.currentStreak}天</div>');
      buffer.writeln('</div>');
    }
    
    buffer.writeln('</div>');
    
    return buffer.toString();
  }
}