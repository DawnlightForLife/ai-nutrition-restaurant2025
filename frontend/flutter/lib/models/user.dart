class User {
  final String id;
  final String name;
  final String phone;
  final String role; // user / merchant / nutritionist / admin
  final String? avatarUrl;
  final String? region;
  final int? age;
  final double? height;
  final double? weight;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.avatarUrl,
    this.region,
    this.age,
    this.height,
    this.weight,
  });

  // 从 JSON 构造 User 对象
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? 'user',
      avatarUrl: json['avatarUrl'],
      region: json['region'],
      age: json['age'],
      height: (json['height'] as num?)?.toDouble(),
      weight: (json['weight'] as num?)?.toDouble(),
    );
  }

  // 将 User 转为 JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'role': role,
      'avatarUrl': avatarUrl,
      'region': region,
      'age': age,
      'height': height,
      'weight': weight,
    };
  }
}
