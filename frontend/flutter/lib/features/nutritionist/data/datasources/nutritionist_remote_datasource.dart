import 'package:dio/dio.dart';
import '../models/nutritionist_model.dart';

abstract class NutritionistRemoteDataSource {
  Future<NutritionistListResponse> getNutritionists({
    String? specialization,
    double? minRating,
    String? consultationFeeRange,
    int? limit,
    int? skip,
    String? sortBy,
    int? sortOrder,
  });

  Future<NutritionistResponse> getNutritionistById(String id);
  Future<NutritionistResponse> createNutritionist(Map<String, dynamic> nutritionist);
  Future<NutritionistResponse> updateNutritionist(String id, Map<String, dynamic> nutritionist);
  Future<void> deleteNutritionist(String id);
}

class NutritionistRemoteDataSourceImpl implements NutritionistRemoteDataSource {
  final Dio dio;

  NutritionistRemoteDataSourceImpl({required this.dio});

  @override
  Future<NutritionistListResponse> getNutritionists({
    String? specialization,
    double? minRating,
    String? consultationFeeRange,
    int? limit,
    int? skip,
    String? sortBy,
    int? sortOrder,
  }) async {
    final queryParams = <String, dynamic>{};
    
    if (specialization != null) queryParams['specialization'] = specialization;
    if (minRating != null) queryParams['minRating'] = minRating;
    if (consultationFeeRange != null) queryParams['consultationFeeRange'] = consultationFeeRange;
    if (limit != null) queryParams['limit'] = limit;
    if (skip != null) queryParams['skip'] = skip;
    if (sortBy != null) queryParams['sortBy'] = sortBy;
    if (sortOrder != null) queryParams['sortOrder'] = sortOrder;

    final response = await dio.get(
      '/nutritionists',
      queryParameters: queryParams,
    );

    return NutritionistListResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<NutritionistResponse> getNutritionistById(String id) async {
    final response = await dio.get('/nutritionists/$id');
    return NutritionistResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<NutritionistResponse> createNutritionist(Map<String, dynamic> nutritionist) async {
    final response = await dio.post(
      '/nutritionists',
      data: nutritionist,
    );
    return NutritionistResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<NutritionistResponse> updateNutritionist(String id, Map<String, dynamic> nutritionist) async {
    final response = await dio.put(
      '/nutritionists/$id',
      data: nutritionist,
    );
    return NutritionistResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteNutritionist(String id) async {
    await dio.delete('/nutritionists/$id');
  }
}

// 响应模型
class NutritionistResponse {
  final bool success;
  final String message;
  final NutritionistModel? data;

  NutritionistResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NutritionistResponse.fromJson(Map<String, dynamic> json) {
    return NutritionistResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null ? NutritionistModel.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }
}

class NutritionistListResponse {
  final bool success;
  final String message;
  final List<NutritionistModel> data;
  final Map<String, dynamic>? pagination;

  NutritionistListResponse({
    required this.success,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory NutritionistListResponse.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List<dynamic>? ?? [];
    return NutritionistListResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: dataList.map((item) => NutritionistModel.fromJson(item as Map<String, dynamic>)).toList(),
      pagination: json['pagination'] as Map<String, dynamic>?,
    );
  }
}
