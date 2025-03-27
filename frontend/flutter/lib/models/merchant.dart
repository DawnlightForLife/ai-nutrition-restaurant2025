/// 商家模型
class Merchant {
  final String id;
  final String userId;
  final String businessName;
  final String businessType;
  final String? description;
  final String? address;
  final Map<String, dynamic>? location;
  final String? phone;
  final String? email;
  final bool isVerified;
  final String status;
  final Map<String, dynamic>? operatingHours;
  final String? logoUrl;
  final List<String>? images;
  final double? rating;
  final int reviewCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Merchant({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.businessType,
    this.description,
    this.address,
    this.location,
    this.phone,
    this.email,
    this.isVerified = false,
    required this.status,
    this.operatingHours,
    this.logoUrl,
    this.images,
    this.rating,
    this.reviewCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// 从JSON创建Merchant对象
  factory Merchant.fromJson(Map<String, dynamic> json) {
    return Merchant(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId'] ?? '',
      businessName: json['businessName'] ?? '',
      businessType: json['businessType'] ?? '',
      description: json['description'],
      address: json['address'],
      location: json['location'],
      phone: json['phone'],
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
      status: json['status'] ?? 'pending',
      operatingHours: json['operatingHours'],
      logoUrl: json['logoUrl'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// 将Merchant对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'businessName': businessName,
      'businessType': businessType,
      'description': description,
      'address': address,
      'location': location,
      'phone': phone,
      'email': email,
      'isVerified': isVerified,
      'status': status,
      'operatingHours': operatingHours,
      'logoUrl': logoUrl,
      'images': images,
      'rating': rating,
      'reviewCount': reviewCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// 用于调试的字符串表示
  @override
  String toString() {
    return 'Merchant{id: $id, businessName: $businessName, businessType: $businessType, '
           'userId: $userId, isVerified: $isVerified, status: $status}';
  }

  /// 检查商家是否营业中
  bool isOpen() {
    if (status != 'active') return false;
    if (operatingHours == null) return false;
    
    // 获取当前日期和时间
    final now = DateTime.now();
    final dayOfWeek = _getDayOfWeek(now.weekday);
    
    // 检查今天是否有营业时间
    if (!operatingHours!.containsKey(dayOfWeek)) return false;
    
    // 获取今天的营业时间
    final todayHours = operatingHours![dayOfWeek];
    if (todayHours == null || todayHours['closed'] == true) return false;
    
    // 获取开始和结束时间
    final openTime = todayHours['open'];
    final closeTime = todayHours['close'];
    if (openTime == null || closeTime == null) return false;
    
    // 解析时间字符串 (格式: "HH:MM")
    final openHour = int.parse(openTime.split(':')[0]);
    final openMinute = int.parse(openTime.split(':')[1]);
    final closeHour = int.parse(closeTime.split(':')[0]);
    final closeMinute = int.parse(closeTime.split(':')[1]);
    
    // 创建开始和结束时间的DateTime对象
    final openDateTime = DateTime(now.year, now.month, now.day, openHour, openMinute);
    final closeDateTime = DateTime(now.year, now.month, now.day, closeHour, closeMinute);
    
    // 检查当前时间是否在营业时间内
    return now.isAfter(openDateTime) && now.isBefore(closeDateTime);
  }

  /// 获取星期几的英文表示
  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  /// 创建带有更新属性的Merchant副本
  Merchant copyWith({
    String? businessName,
    String? businessType,
    String? description,
    String? address,
    Map<String, dynamic>? location,
    String? phone,
    String? email,
    bool? isVerified,
    String? status,
    Map<String, dynamic>? operatingHours,
    String? logoUrl,
    List<String>? images,
    double? rating,
    int? reviewCount,
  }) {
    return Merchant(
      id: id,
      userId: userId,
      businessName: businessName ?? this.businessName,
      businessType: businessType ?? this.businessType,
      description: description ?? this.description,
      address: address ?? this.address,
      location: location ?? this.location,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      operatingHours: operatingHours ?? this.operatingHours,
      logoUrl: logoUrl ?? this.logoUrl,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
} 