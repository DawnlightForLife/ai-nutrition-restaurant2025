import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 草稿存储服务
/// 
/// 用于保存和恢复营养档案创建过程中的草稿数据
class DraftStorageService {
  static const String _draftKeyPrefix = 'nutrition_profile_draft_';
  static const String _draftListKey = 'nutrition_profile_draft_list';
  
  final SharedPreferences _prefs;

  DraftStorageService(this._prefs);

  /// 保存草稿
  /// 
  /// [draftId] 草稿ID，如果为null则自动生成
  /// [data] 草稿数据
  /// [profileName] 档案名称（用于显示）
  Future<String> saveDraft({
    String? draftId,
    required Map<String, dynamic> data,
    String? profileName,
  }) async {
    final id = draftId ?? 'draft_${DateTime.now().millisecondsSinceEpoch}';
    final key = '$_draftKeyPrefix$id';
    
    final draftInfo = DraftInfo(
      id: id,
      profileName: profileName ?? '未命名档案',
      data: data,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    // 保存草稿数据
    await _prefs.setString(key, jsonEncode(draftInfo.toJson()));
    
    // 更新草稿列表
    await _updateDraftList(id, draftInfo);
    
    return id;
  }

  /// 加载草稿
  /// 
  /// [draftId] 草稿ID
  Future<DraftInfo?> loadDraft(String draftId) async {
    final key = '$_draftKeyPrefix$draftId';
    final jsonString = _prefs.getString(key);
    
    if (jsonString == null) return null;
    
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return DraftInfo.fromJson(json);
    } catch (e) {
      // 如果解析失败，删除损坏的草稿
      await deleteDraft(draftId);
      return null;
    }
  }

  /// 获取所有草稿列表
  Future<List<DraftInfo>> getAllDrafts() async {
    final draftListJson = _prefs.getString(_draftListKey);
    if (draftListJson == null) return [];
    
    try {
      final List<dynamic> draftList = jsonDecode(draftListJson);
      final List<DraftInfo> drafts = [];
      
      for (final item in draftList) {
        final draftInfo = DraftInfo.fromJson(item as Map<String, dynamic>);
        drafts.add(draftInfo);
      }
      
      // 按更新时间倒序排列
      drafts.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return drafts;
    } catch (e) {
      return [];
    }
  }

  /// 删除草稿
  Future<void> deleteDraft(String draftId) async {
    final key = '$_draftKeyPrefix$draftId';
    await _prefs.remove(key);
    
    // 从草稿列表中移除
    await _removeDraftFromList(draftId);
  }

  /// 清空所有草稿
  Future<void> clearAllDrafts() async {
    final drafts = await getAllDrafts();
    
    for (final draft in drafts) {
      final key = '$_draftKeyPrefix${draft.id}';
      await _prefs.remove(key);
    }
    
    await _prefs.remove(_draftListKey);
  }

  /// 检查是否有草稿
  Future<bool> hasDrafts() async {
    final drafts = await getAllDrafts();
    return drafts.isNotEmpty;
  }

  /// 获取草稿数量
  Future<int> getDraftCount() async {
    final drafts = await getAllDrafts();
    return drafts.length;
  }

  /// 更新草稿列表
  Future<void> _updateDraftList(String draftId, DraftInfo draftInfo) async {
    final drafts = await getAllDrafts();
    
    // 检查是否已存在
    final existingIndex = drafts.indexWhere((d) => d.id == draftId);
    if (existingIndex >= 0) {
      // 更新现有草稿信息
      drafts[existingIndex] = draftInfo;
    } else {
      // 添加新草稿
      drafts.add(draftInfo);
    }
    
    // 限制草稿数量（最多保存10个）
    if (drafts.length > 10) {
      final oldestDrafts = drafts.skip(10).toList();
      for (final oldDraft in oldestDrafts) {
        await deleteDraft(oldDraft.id);
      }
      drafts.removeRange(10, drafts.length);
    }
    
    // 保存更新后的列表
    final draftListJson = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await _prefs.setString(_draftListKey, draftListJson);
  }

  /// 从草稿列表中移除草稿
  Future<void> _removeDraftFromList(String draftId) async {
    final drafts = await getAllDrafts();
    drafts.removeWhere((d) => d.id == draftId);
    
    final draftListJson = jsonEncode(drafts.map((d) => d.toJson()).toList());
    await _prefs.setString(_draftListKey, draftListJson);
  }

  /// 自动清理过期草稿（超过30天）
  Future<void> cleanupExpiredDrafts() async {
    final drafts = await getAllDrafts();
    final now = DateTime.now();
    final expiredDrafts = drafts.where((draft) {
      final daysSinceUpdate = now.difference(draft.updatedAt).inDays;
      return daysSinceUpdate > 30;
    }).toList();
    
    for (final draft in expiredDrafts) {
      await deleteDraft(draft.id);
    }
  }
}

/// 草稿信息模型
class DraftInfo {
  final String id;
  final String profileName;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime updatedAt;

  DraftInfo({
    required this.id,
    required this.profileName,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 获取草稿完成度（与实体类NutritionProfileV2保持一致）
  double get completionPercentage {
    int filledFields = 0;
    int totalFields = 8; // 必填字段总数

    // 检查必填字段（与实体类保持一致）
    if (data['profileName']?.toString().isNotEmpty == true) filledFields++;
    if (data['gender']?.toString().isNotEmpty == true) filledFields++;
    if (data['ageGroup']?.toString().isNotEmpty == true) filledFields++;
    if (data['height']?.toString().isNotEmpty == true) {
      final height = double.tryParse(data['height'].toString());
      if (height != null && height > 0) filledFields++;
    }
    if (data['weight']?.toString().isNotEmpty == true) {
      final weight = double.tryParse(data['weight'].toString());
      if (weight != null && weight > 0) filledFields++;
    }
    if (data['healthGoal']?.toString().isNotEmpty == true || 
        (data['healthGoals'] is List && (data['healthGoals'] as List).isNotEmpty)) filledFields++;
    if (data['targetCalories']?.toString().isNotEmpty == true) {
      final calories = double.tryParse(data['targetCalories'].toString());
      if (calories != null && calories > 0) filledFields++;
    }
    if (data['dietaryPreferences'] is List && (data['dietaryPreferences'] as List).isNotEmpty) filledFields++;

    // 计算可选字段的完整度（权重较低）
    int optionalFilledFields = 0;
    int optionalTotalFields = 6;
    
    if (data['medicalConditions'] is List && (data['medicalConditions'] as List).isNotEmpty) optionalFilledFields++;
    if (data['exerciseFrequency']?.toString().isNotEmpty == true) optionalFilledFields++;
    if (data['nutritionPreferences'] is List && (data['nutritionPreferences'] as List).isNotEmpty) optionalFilledFields++;
    if (data['specialStatus'] is List && (data['specialStatus'] as List).isNotEmpty) optionalFilledFields++;
    if (data['forbiddenIngredients'] is List && (data['forbiddenIngredients'] as List).isNotEmpty) optionalFilledFields++;
    if (data['allergies'] is List && (data['allergies'] as List).isNotEmpty) optionalFilledFields++;

    // 必填字段占80%权重，可选字段占20%权重
    final requiredPercentage = (filledFields / totalFields) * 0.8;
    final optionalPercentage = (optionalFilledFields / optionalTotalFields) * 0.2;
    
    return requiredPercentage + optionalPercentage;
  }

  /// 获取草稿摘要
  String get summary {
    final parts = <String>[];
    
    if (data['gender']?.toString().isNotEmpty == true) {
      parts.add(_getGenderText(data['gender']));
    }
    
    if (data['ageGroup']?.toString().isNotEmpty == true) {
      parts.add(_getAgeGroupText(data['ageGroup']));
    }
    
    if (data['healthGoal']?.toString().isNotEmpty == true) {
      parts.add(_getHealthGoalText(data['healthGoal']));
    }
    
    return parts.isEmpty ? '基本信息' : parts.join(' · ');
  }

  String _getGenderText(String? gender) {
    switch (gender) {
      case 'male': return '男性';
      case 'female': return '女性';
      default: return '';
    }
  }

  String _getAgeGroupText(String? ageGroup) {
    switch (ageGroup) {
      case 'child': return '儿童';
      case 'teenager': return '青少年';
      case 'adult': return '成年人';
      case 'senior': return '老年人';
      default: return '';
    }
  }

  String _getHealthGoalText(String? healthGoal) {
    switch (healthGoal) {
      case 'loseWeight': return '减重';
      case 'gainMuscle': return '增肌';
      case 'maintainWeight': return '维持';
      case 'improveHealth': return '改善健康';
      default: return '';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileName': profileName,
      'data': data,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory DraftInfo.fromJson(Map<String, dynamic> json) {
    return DraftInfo(
      id: json['id'] as String,
      profileName: json['profileName'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  DraftInfo copyWith({
    String? id,
    String? profileName,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DraftInfo(
      id: id ?? this.id,
      profileName: profileName ?? this.profileName,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}