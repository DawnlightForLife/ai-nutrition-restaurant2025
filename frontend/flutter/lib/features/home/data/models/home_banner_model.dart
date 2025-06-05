import '../../domain/entities/home_banner.dart';

/// 首页Banner数据模型
class HomeBannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? targetUrl;
  final String type;
  final bool isActive;
  final int order;
  final String createdAt;
  
  const HomeBannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.targetUrl,
    required this.type,
    required this.isActive,
    required this.order,
    required this.createdAt,
  });
  
  /// 从JSON创建模型
  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      subtitle: (json['subtitle'] ?? '').toString(),
      imageUrl: (json['imageUrl'] ?? '').toString(),
      targetUrl: json['targetUrl']?.toString(),
      type: (json['type'] ?? 'promotion').toString(),
      isActive: json['isActive'] as bool? ?? true,
      order: json['order'] as int? ?? 0,
      createdAt: (json['createdAt'] ?? DateTime.now().toIso8601String()).toString(),
    );
  }
  
  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'imageUrl': imageUrl,
      'targetUrl': targetUrl,
      'type': type,
      'isActive': isActive,
      'order': order,
      'createdAt': createdAt,
    };
  }
  
  /// 转换为领域实体
  HomeBanner toEntity() {
    return HomeBanner(
      id: id,
      title: title,
      subtitle: subtitle,
      imageUrl: imageUrl,
      targetUrl: targetUrl,
      type: _mapStringToBannerType(type),
      isActive: isActive,
      order: order,
      createdAt: DateTime.parse(createdAt),
    );
  }
  
  /// 字符串转Banner类型
  BannerType _mapStringToBannerType(String typeString) {
    switch (typeString.toLowerCase()) {
      case 'promotion':
        return BannerType.promotion;
      case 'announcement':
        return BannerType.announcement;
      case 'feature':
        return BannerType.feature;
      case 'external':
        return BannerType.external;
      default:
        return BannerType.promotion;
    }
  }
}