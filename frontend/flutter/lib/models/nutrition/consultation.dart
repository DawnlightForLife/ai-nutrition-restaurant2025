/// 营养咨询模型类
///
/// 用于表示用户与营养师之间的咨询会话
class Consultation {
  /// 咨询唯一标识ID
  final String id;
  
  /// 用户ID
  final String userId;
  
  /// 营养师ID
  final String nutritionistId;
  
  /// 咨询主题
  final String topic;
  
  /// 咨询详细描述
  final String description;
  
  /// 咨询开始时间
  final DateTime startTime;
  
  /// 咨询持续时间（分钟）
  final int duration;
  
  /// 咨询状态：scheduled（已预约）, ongoing（进行中）, completed（已完成）, cancelled（已取消）
  final String status;
  
  /// 咨询费用
  final double fee;
  
  /// 用户评分 (1-5)
  final double? rating;
  
  /// 用户评价
  final String? review;
  
  /// 咨询笔记（通常由营养师提供）
  final String? notes;
  
  /// 预约创建时间
  final DateTime createdAt;
  
  /// 最后更新时间
  final DateTime updatedAt;

  /// 构造函数
  Consultation({
    required this.id,
    required this.userId,
    required this.nutritionistId,
    required this.topic,
    required this.description,
    required this.startTime,
    required this.duration,
    required this.status,
    required this.fee,
    this.rating,
    this.review,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON解析为咨询对象
  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'],
      userId: json['userId'],
      nutritionistId: json['nutritionistId'],
      topic: json['topic'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      duration: json['duration'],
      status: json['status'],
      fee: json['fee'].toDouble(),
      rating: json['rating']?.toDouble(),
      review: json['review'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'nutritionistId': nutritionistId,
      'topic': topic,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'duration': duration,
      'status': status,
      'fee': fee,
      'rating': rating,
      'review': review,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
} 