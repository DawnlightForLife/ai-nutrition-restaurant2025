/// 推荐卡片实体（基于页面设计文档的动态模块）
class RecommendationCard {
  final String id;
  final RecommendationCardType type;
  final String title;
  final String subtitle;
  final String? imageUrl;
  final String? targetRoute;
  final Map<String, dynamic>? data;
  final bool isVisible;
  final int priority;
  final DateTime? expiresAt;
  
  const RecommendationCard({
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
}

/// 推荐卡片类型（对应页面设计文档中的首页动态模块）
enum RecommendationCardType {
  aiRecommendation,     // AI推荐卡片
  newUserGuide,         // 新用户引导卡片
  couponRecommendation, // 优惠券推荐
  nutritionistOnline,   // 营养师在线状态
  newFeature,           // 新功能Banner
  orderStatus,          // 订单状态提醒
}