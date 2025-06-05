import '../../domain/entities/recommendation_card.dart';

/// 推荐卡片数据模型
class RecommendationCardModel {
  final String id;
  final String type;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? targetRoute;
  final Map<String, dynamic>? data;
  final bool isVisible;
  final int priority;
  final String? expiresAt;
  
  const RecommendationCardModel({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.targetRoute,
    this.data,
    required this.isVisible,
    required this.priority,
    this.expiresAt,
  });
  
  /// 从JSON创建模型
  factory RecommendationCardModel.fromJson(Map<String, dynamic> json) {
    return RecommendationCardModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      type: (json['type'] ?? 'aiRecommendation').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      imageUrl: json['imageUrl']?.toString(),
      targetRoute: json['targetRoute']?.toString(),
      data: json['data'] as Map<String, dynamic>?,
      isVisible: json['isVisible'] as bool? ?? true,
      priority: json['priority'] as int? ?? 0,
      expiresAt: json['expiresAt']?.toString(),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'targetRoute': targetRoute,
      'data': data,
      'isVisible': isVisible,
      'priority': priority,
      'expiresAt': expiresAt,
    };
  }
  
  /// 转换为领域实体
  RecommendationCard toEntity() {
    return RecommendationCard(
      id: id,
      type: _mapStringToCardType(type),
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      targetRoute: targetRoute,
      data: data,
      isVisible: isVisible,
      priority: priority,
      expiresAt: expiresAt != null ? DateTime.parse(expiresAt!) : null,
    );
  }
  
  /// 字符串转卡片类型
  RecommendationCardType _mapStringToCardType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'airecommendation':
        return RecommendationCardType.aiRecommendation;
      case 'newuserguide':
        return RecommendationCardType.newUserGuide;
      case 'couponrecommendation':
        return RecommendationCardType.couponRecommendation;
      case 'nutritionistonline':
        return RecommendationCardType.nutritionistOnline;
      case 'newfeature':
        return RecommendationCardType.newFeature;
      case 'orderstatus':
        return RecommendationCardType.orderStatus;
      default:
        return RecommendationCardType.aiRecommendation;
    }
  }
}