/// 首页Banner实体
class HomeBanner {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? targetUrl;
  final BannerType type;
  final bool isActive;
  final int order;
  final DateTime createdAt;
  
  const HomeBanner({
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
}

/// Banner类型枚举
enum BannerType {
  promotion,    // 促销活动
  announcement, // 公告
  feature,      // 功能介绍
  external,     // 外部链接
}