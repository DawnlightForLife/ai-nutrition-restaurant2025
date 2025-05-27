import 'package:equatable/equatable.dart';
import '../../common/entities/entity.dart';
import '../../user/value_objects/user_id.dart';

// 类型别名，保持向后兼容
typedef AiRecommendation = AIRecommendation;

/// AI推荐实体
class AIRecommendation extends Entity {
  final String id;
  final UserId userId;
  final String mealType; // 餐次类型：breakfast, lunch, dinner, snack
  final List<RecommendedDish> dishes; // 推荐的菜品
  final Map<String, double> nutritionSummary; // 营养摘要
  final double confidenceScore; // 推荐置信度
  final String reasoning; // 推荐理由
  final DateTime createdAt;
  final DateTime? consumedAt; // 用餐时间

  const AIRecommendation({
    required this.id,
    required this.userId,
    required this.mealType,
    required this.dishes,
    required this.nutritionSummary,
    required this.confidenceScore,
    required this.reasoning,
    required this.createdAt,
    this.consumedAt,
  });

  /// 总卡路里
  double get totalCalories {
    return dishes.fold(0.0, (sum, dish) => sum + dish.calories);
  }

  /// 是否已用餐
  bool get isConsumed => consumedAt != null;

  /// 创建副本
  AIRecommendation copyWith({
    String? id,
    UserId? userId,
    String? mealType,
    List<RecommendedDish>? dishes,
    Map<String, double>? nutritionSummary,
    double? confidenceScore,
    String? reasoning,
    DateTime? createdAt,
    DateTime? consumedAt,
  }) {
    return AIRecommendation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealType: mealType ?? this.mealType,
      dishes: dishes ?? this.dishes,
      nutritionSummary: nutritionSummary ?? this.nutritionSummary,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      reasoning: reasoning ?? this.reasoning,
      createdAt: createdAt ?? this.createdAt,
      consumedAt: consumedAt ?? this.consumedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        mealType,
        dishes,
        nutritionSummary,
        confidenceScore,
        reasoning,
        createdAt,
        consumedAt,
      ];
}

/// 推荐菜品
class RecommendedDish extends Equatable {
  final String dishId;
  final String name;
  final String description;
  final double calories;
  final Map<String, double> nutrition; // 营养成分
  final double price;
  final String? imageUrl;
  final double matchScore; // 匹配度评分

  const RecommendedDish({
    required this.dishId,
    required this.name,
    required this.description,
    required this.calories,
    required this.nutrition,
    required this.price,
    this.imageUrl,
    required this.matchScore,
  });

  @override
  List<Object?> get props => [
        dishId,
        name,
        description,
        calories,
        nutrition,
        price,
        imageUrl,
        matchScore,
      ];
} 