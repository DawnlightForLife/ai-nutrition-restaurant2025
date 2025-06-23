import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../enums/specialization_area.dart';
import 'nutritionist.dart';

/// 营养师筛选条件
class NutritionistFilter extends Equatable {
  final String? searchKeyword;
  final bool onlineOnly;
  final bool verifiedOnly;
  final bool highRatingOnly;
  final List<SpecializationArea>? specialties;
  final List<ConsultationType>? consultationTypes;
  final double? minPrice;
  final double? maxPrice;
  final NutritionistSortBy sortBy;
  
  // 新增属性以匹配API
  final String? specialization;
  final double? minRating;
  final RangeValues? priceRange;
  final int? limit;
  final int? offset;
  final bool? sortAscending;

  const NutritionistFilter({
    this.searchKeyword,
    this.onlineOnly = false,
    this.verifiedOnly = false,
    this.highRatingOnly = false,
    this.specialties,
    this.consultationTypes,
    this.minPrice,
    this.maxPrice,
    this.sortBy = NutritionistSortBy.rating,
    // 新增属性
    this.specialization,
    this.minRating,
    this.priceRange,
    this.limit,
    this.offset,
    this.sortAscending,
  });

  /// 是否为空筛选条件
  bool get isEmpty {
    return searchKeyword == null &&
        !onlineOnly &&
        !verifiedOnly &&
        !highRatingOnly &&
        (specialties == null || specialties!.isEmpty) &&
        (consultationTypes == null || consultationTypes!.isEmpty) &&
        minPrice == null &&
        maxPrice == null &&
        sortBy == NutritionistSortBy.rating;
  }

  /// 复制并修改筛选条件
  NutritionistFilter copyWith({
    String? searchKeyword,
    bool? onlineOnly,
    bool? verifiedOnly,
    bool? highRatingOnly,
    List<SpecializationArea>? specialties,
    List<ConsultationType>? consultationTypes,
    double? minPrice,
    double? maxPrice,
    NutritionistSortBy? sortBy,
  }) {
    return NutritionistFilter(
      searchKeyword: searchKeyword ?? this.searchKeyword,
      onlineOnly: onlineOnly ?? this.onlineOnly,
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
      highRatingOnly: highRatingOnly ?? this.highRatingOnly,
      specialties: specialties ?? this.specialties,
      consultationTypes: consultationTypes ?? this.consultationTypes,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [
        searchKeyword,
        onlineOnly,
        verifiedOnly,
        highRatingOnly,
        specialties,
        consultationTypes,
        minPrice,
        maxPrice,
        sortBy,
        specialization,
        minRating,
        priceRange,
        limit,
        offset,
        sortAscending,
      ];
}

/// 营养师排序方式
enum NutritionistSortBy {
  rating,
  price,
  consultationCount,
  experience,
}

/// 营养师排序方式扩展
extension NutritionistSortByX on NutritionistSortBy {
  String get displayName {
    switch (this) {
      case NutritionistSortBy.rating:
        return '评分排序';
      case NutritionistSortBy.price:
        return '价格排序';
      case NutritionistSortBy.consultationCount:
        return '咨询量排序';
      case NutritionistSortBy.experience:
        return '经验排序';
    }
  }
}