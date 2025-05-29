import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommendation_item.freezed.dart';
part 'recommendation_item.g.dart';

/// 推荐项目实体
/// 
/// 表示AI推荐系统生成的单个推荐项目
@freezed
class RecommendationItem with _$RecommendationItem {
  const factory RecommendationItem({
    /// 推荐项目ID
    required String id,
    
    /// 推荐类型（dish/meal/plan等）
    required String type,
    
    /// 推荐项目标题
    required String title,
    
    /// 推荐项目描述
    required String description,
    
    /// 推荐项目图片URL
    String? imageUrl,
    
    /// 推荐评分（1-5分）
    @Default(0.0) double score,
    
    /// 推荐置信度（0-1）
    @Default(0.0) double confidence,
    
    /// 营养信息
    NutritionInfo? nutritionInfo,
    
    /// 价格信息
    PriceInfo? priceInfo,
    
    /// 推荐原因
    @Default([]) List<String> reasons,
    
    /// 标签
    @Default([]) List<String> tags,
    
    /// 是否可用
    @Default(true) bool isAvailable,
    
    /// 创建时间
    DateTime? createdAt,
    
    /// 更新时间
    DateTime? updatedAt,
    
    /// 扩展数据
    @Default({}) Map<String, dynamic> metadata,
  }) = _RecommendationItem;

  factory RecommendationItem.fromJson(Map<String, dynamic> json) =>
      _$RecommendationItemFromJson(json);
}

/// 营养信息
@freezed
class NutritionInfo with _$NutritionInfo {
  const factory NutritionInfo({
    /// 热量（千卡）
    @Default(0.0) double calories,
    
    /// 蛋白质（克）
    @Default(0.0) double protein,
    
    /// 脂肪（克）
    @Default(0.0) double fat,
    
    /// 碳水化合物（克）
    @Default(0.0) double carbs,
    
    /// 纤维（克）
    @Default(0.0) double fiber,
    
    /// 糖分（克）
    @Default(0.0) double sugar,
    
    /// 钠（毫克）
    @Default(0.0) double sodium,
    
    /// 其他营养成分
    @Default({}) Map<String, double> others,
  }) = _NutritionInfo;

  factory NutritionInfo.fromJson(Map<String, dynamic> json) =>
      _$NutritionInfoFromJson(json);
}

/// 价格信息
@freezed
class PriceInfo with _$PriceInfo {
  const factory PriceInfo({
    /// 原价
    @Default(0.0) double originalPrice,
    
    /// 现价
    @Default(0.0) double currentPrice,
    
    /// 折扣（0-1）
    @Default(0.0) double discount,
    
    /// 货币代码
    @Default('CNY') String currency,
    
    /// 价格单位
    @Default('份') String unit,
  }) = _PriceInfo;

  factory PriceInfo.fromJson(Map<String, dynamic> json) =>
      _$PriceInfoFromJson(json);
}

/// 推荐项目扩展方法
extension RecommendationItemExtension on RecommendationItem {
  /// 是否有折扣
  bool get hasDiscount => priceInfo?.discount != null && priceInfo!.discount > 0;
  
  /// 是否高评分（4分以上）
  bool get isHighRated => score >= 4.0;
  
  /// 是否高置信度（0.8以上）
  bool get isHighConfidence => confidence >= 0.8;
  
  /// 获取格式化价格
  String get formattedPrice {
    if (priceInfo == null) return '';
    return '¥${priceInfo!.currentPrice.toStringAsFixed(2)}';
  }
  
  /// 获取格式化评分
  String get formattedScore => score.toStringAsFixed(1);
  
  /// 获取营养摘要
  String get nutritionSummary {
    if (nutritionInfo == null) return '';
    return '${nutritionInfo!.calories.toInt()}千卡 | ${nutritionInfo!.protein.toInt()}g蛋白质';
  }
}