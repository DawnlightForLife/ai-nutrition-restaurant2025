/// 营养师模型类
///
/// 用于表示系统中的营养师信息
class Nutritionist {
  /// 营养师唯一标识ID
  final String id;
  
  /// 营养师姓名
  final String name;
  
  /// 头像URL
  final String? avatarUrl;
  
  /// 专业领域
  final List<String> specializations;
  
  /// 简介
  final String bio;
  
  /// 资质证书
  final List<String> certifications;
  
  /// 工作经验年限
  final int yearsOfExperience;
  
  /// 用户评分 (1-5)
  final double rating;
  
  /// 评价数量
  final int reviewCount;
  
  /// 咨询价格
  final double consultationFee;
  
  /// 是否在线可用
  final bool isAvailable;

  /// 构造函数
  Nutritionist({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.specializations,
    required this.bio,
    required this.certifications,
    required this.yearsOfExperience,
    required this.rating,
    required this.reviewCount,
    required this.consultationFee,
    required this.isAvailable,
  });

  /// 从JSON解析为营养师对象
  factory Nutritionist.fromJson(Map<String, dynamic> json) {
    return Nutritionist(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      specializations: List<String>.from(json['specializations']),
      bio: json['bio'],
      certifications: List<String>.from(json['certifications']),
      yearsOfExperience: json['yearsOfExperience'],
      rating: json['rating'].toDouble(),
      reviewCount: json['reviewCount'],
      consultationFee: json['consultationFee'].toDouble(),
      isAvailable: json['isAvailable'],
    );
  }

  /// 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'specializations': specializations,
      'bio': bio,
      'certifications': certifications,
      'yearsOfExperience': yearsOfExperience,
      'rating': rating,
      'reviewCount': reviewCount,
      'consultationFee': consultationFee,
      'isAvailable': isAvailable,
    };
  }
} 