import 'package:equatable/equatable.dart';
import '../enums/certification_level.dart';
import '../enums/specialization_area.dart';

/// 营养师实体
class Nutritionist extends Equatable {
  final String id;
  final String userId;
  final String name;
  final List<String> specializations;
  final int experienceYears;
  final String bio;
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final double consultationFee;
  final List<String> languages;
  final List<String> certifications;
  final bool isOnlineAvailable;
  final bool isInPersonAvailable;
  final String verificationStatus;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // 在线状态相关字段
  final bool isOnline;
  final bool isAvailable;
  final DateTime? lastActiveAt;
  final String? statusMessage;
  final List<ConsultationType> availableConsultationTypes;
  final double responseTime; // 平均响应时间（分钟）
  
  // 向后兼容的属性
  String? get avatar => avatarUrl.isEmpty ? null : avatarUrl;
  int get consultationCount => reviewCount;
  double get consultationPrice => consultationFee;
  List<SpecializationArea> get specialties => specializations
      .map((s) => SpecializationArea.values.firstWhere(
            (e) => e.name == s,
            orElse: () => SpecializationArea.weightManagement,
          ))
      .toList();
  bool get isVerified => verificationStatus == 'approved';
  
  const Nutritionist({
    required this.id,
    required this.userId,
    required this.name,
    required this.specializations,
    required this.experienceYears,
    required this.bio,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.consultationFee,
    required this.languages,
    required this.certifications,
    required this.isOnlineAvailable,
    required this.isInPersonAvailable,
    required this.verificationStatus,
    required this.createdAt,
    required this.updatedAt,
    // 在线状态字段
    this.isOnline = false,
    this.isAvailable = false,
    this.lastActiveAt,
    this.statusMessage,
    this.availableConsultationTypes = const [],
    this.responseTime = 0.0,
  });

  /// 营养师状态标签
  String get statusLabel {
    if (!isVerified) return '未认证';
    if (!isOnline) return '离线';
    return '在线';
  }

  /// 营养师状态颜色
  String get statusColor {
    if (!isVerified) return 'gray';
    if (!isOnline) return 'orange';
    return 'green';
  }

  /// 格式化的专业领域
  String get specialtiesText {
    if (specialties.isEmpty) return '暂无专业信息';
    return specialties.map((s) => s.displayName).join('、');
  }

  /// 格式化的工作年限
  String get experienceText {
    if (experienceYears == 0) return '暂无经验信息';
    return '${experienceYears}年经验';
  }

  /// 格式化的价格
  String get priceText {
    if (consultationPrice <= 0) return '价格面议';
    return '¥${consultationPrice.toInt()}/次';
  }

  /// 格式化的评分
  String get ratingText {
    if (rating <= 0) return '暂无评分';
    return '${rating.toStringAsFixed(1)}分';
  }

  /// 获取在线状态文本
  String get onlineStatusText {
    if (!isVerified) return '未认证';
    if (!isOnline) return '离线';
    if (!isAvailable) return '忙碌';
    return '在线';
  }
  
  /// 获取在线状态颜色
  String get onlineStatusColor {
    if (!isVerified) return 'gray';
    if (!isOnline) return 'red';
    if (!isAvailable) return 'orange';
    return 'green';
  }
  
  /// 获取最后活跃时间文本
  String get lastActiveText {
    if (lastActiveAt == null) return '未知';
    final now = DateTime.now();
    final diff = now.difference(lastActiveAt!);
    
    if (diff.inMinutes < 1) return '刚刚活跃';
    if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前活跃';
    if (diff.inHours < 24) return '${diff.inHours}小时前活跃';
    return '${diff.inDays}天前活跃';
  }
  
  /// 获取响应时间文本
  String get responseTimeText {
    if (responseTime <= 0) return '响应时间未知';
    if (responseTime < 1) return '通常几秒内回复';
    if (responseTime < 60) return '通常${responseTime.toInt()}分钟内回复';
    return '通常1小时内回复';
  }

  /// 是否可以预约
  bool get canBook {
    return isVerified && isOnline && isAvailable && availableConsultationTypes.isNotEmpty;
  }
  
  @override
  List<Object?> get props => [
    id, userId, name, specializations, experienceYears, bio, avatarUrl,
    rating, reviewCount, consultationFee, languages, certifications,
    isOnlineAvailable, isInPersonAvailable, verificationStatus,
    createdAt, updatedAt, isOnline, isAvailable, lastActiveAt,
    statusMessage, availableConsultationTypes, responseTime,
  ];
}

/// 工作时间
class WorkingHours extends Equatable {
  final String mondayToFriday;
  final String weekend;
  final String? notes;

  const WorkingHours({
    required this.mondayToFriday,
    required this.weekend,
    this.notes,
  });

  @override
  List<Object?> get props => [mondayToFriday, weekend, notes];
}

/// 咨询类型
enum ConsultationType {
  text,
  voice,
  video,
  offline,
}

/// 咨询类型扩展
extension ConsultationTypeX on ConsultationType {
  String get displayName {
    switch (this) {
      case ConsultationType.text:
        return '文字咨询';
      case ConsultationType.voice:
        return '语音咨询';
      case ConsultationType.video:
        return '视频咨询';
      case ConsultationType.offline:
        return '线下咨询';
    }
  }

  String get icon {
    switch (this) {
      case ConsultationType.text:
        return '💬';
      case ConsultationType.voice:
        return '🎤';
      case ConsultationType.video:
        return '📹';
      case ConsultationType.offline:
        return '🏥';
    }
  }
}

/// 为了向后兼容，保留旧的 Unutritionist 类
@Deprecated('Use Nutritionist instead')
class Unutritionist extends Equatable {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Unutritionist({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  
  @override
  List<Object?> get props => [id, createdAt, updatedAt];
}