class User {
  final String id;
  final String nickname;
  final String phone;
  final String email;
  final String? avatarUrl;
  final String role;
  final double? height;
  final double? weight;
  final int? age;
  final bool isNutritionistVerified;
  final bool isMerchantVerified;
  final String? nutritionistVerificationStatus;
  final String? merchantVerificationStatus;
  final Map<String, dynamic>? nutritionistVerificationData;
  final Map<String, dynamic>? merchantVerificationData;
  final String? nutritionistRejectionReason;
  final String? merchantRejectionReason;

  User({
    required this.id,
    required this.nickname,
    required this.phone,
    required this.email,
    this.avatarUrl,
    required this.role,
    this.height,
    this.weight,
    this.age,
    this.isNutritionistVerified = false,
    this.isMerchantVerified = false,
    this.nutritionistVerificationStatus,
    this.merchantVerificationStatus,
    this.nutritionistVerificationData,
    this.merchantVerificationData,
    this.nutritionistRejectionReason,
    this.merchantRejectionReason,
  });

  // 从JSON创建User对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      nickname: json['nickname'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      role: json['role'] ?? 'user',
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      age: json['age'],
      isNutritionistVerified: json['isNutritionistVerified'] ?? false,
      isMerchantVerified: json['isMerchantVerified'] ?? false,
      nutritionistVerificationStatus: json['nutritionistVerificationStatus'],
      merchantVerificationStatus: json['merchantVerificationStatus'],
      nutritionistVerificationData: json['nutritionistVerificationData'],
      merchantVerificationData: json['merchantVerificationData'],
      nutritionistRejectionReason: json['nutritionistRejectionReason'],
      merchantRejectionReason: json['merchantRejectionReason'],
    );
  }

  // 将User对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'phone': phone,
      'email': email,
      'avatarUrl': avatarUrl,
      'role': role,
      'height': height,
      'weight': weight,
      'age': age,
      'isNutritionistVerified': isNutritionistVerified,
      'isMerchantVerified': isMerchantVerified,
      'nutritionistVerificationStatus': nutritionistVerificationStatus,
      'merchantVerificationStatus': merchantVerificationStatus,
      'nutritionistVerificationData': nutritionistVerificationData,
      'merchantVerificationData': merchantVerificationData,
      'nutritionistRejectionReason': nutritionistRejectionReason,
      'merchantRejectionReason': merchantRejectionReason,
    };
  }

  // 检查是否可以切换到营养师身份
  bool canSwitchToNutritionist() {
    return isNutritionistVerified && nutritionistVerificationStatus == 'approved';
  }

  // 检查是否可以切换到商家身份
  bool canSwitchToMerchant() {
    return isMerchantVerified && merchantVerificationStatus == 'approved';
  }

  // 检查是否有待审核的认证申请
  bool hasPendingVerifications() {
    return (nutritionistVerificationStatus == 'pending') || 
           (merchantVerificationStatus == 'pending');
  }

  // 创建带有更新属性的User副本
  User copyWith({
    String? id,
    String? nickname,
    String? phone,
    String? email,
    String? avatarUrl,
    String? role,
    double? height,
    double? weight,
    int? age,
    bool? isNutritionistVerified,
    bool? isMerchantVerified,
    String? nutritionistVerificationStatus,
    String? merchantVerificationStatus,
    Map<String, dynamic>? nutritionistVerificationData,
    Map<String, dynamic>? merchantVerificationData,
    String? nutritionistRejectionReason,
    String? merchantRejectionReason,
  }) {
    return User(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      isNutritionistVerified: isNutritionistVerified ?? this.isNutritionistVerified,
      isMerchantVerified: isMerchantVerified ?? this.isMerchantVerified,
      nutritionistVerificationStatus: nutritionistVerificationStatus ?? this.nutritionistVerificationStatus,
      merchantVerificationStatus: merchantVerificationStatus ?? this.merchantVerificationStatus,
      nutritionistVerificationData: nutritionistVerificationData ?? this.nutritionistVerificationData,
      merchantVerificationData: merchantVerificationData ?? this.merchantVerificationData,
      nutritionistRejectionReason: nutritionistRejectionReason ?? this.nutritionistRejectionReason,
      merchantRejectionReason: merchantRejectionReason ?? this.merchantRejectionReason,
    );
  }
}
