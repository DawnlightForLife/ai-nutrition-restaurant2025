import 'dart:convert';

import '../../models/nutrition/nutritionist.dart';
import '../../models/nutrition/consultation.dart';
import '../core/api_service.dart';
import '../../common/constants/api_constants.dart';

/// 营养师服务类
///
/// 提供营养师相关API交互功能
/// 负责与后端API通信，处理网络请求和响应数据的转换
class NutritionistService {
  /// API服务实例，用于发送HTTP请求
  final ApiService _apiService;

  /// 构造函数
  /// 
  /// @param apiService API服务实例
  NutritionistService(this._apiService);

  /// 获取营养师列表
  ///
  /// 从服务器获取分页的营养师列表，支持多种筛选条件
  /// 
  /// @param page 页码，从1开始
  /// @param limit 每页数量
  /// @param specialization 可选，按专业领域筛选
  /// @param rating 可选，按最低评分筛选
  /// @param token 用户令牌，可选
  /// @return 包含营养师列表及分页信息的Map
  Future<Map<String, dynamic>> getNutritionists({
    required int page,
    int limit = 10,
    String? specialization,
    double? rating,
    String? token,
  }) async {
    // 构建查询参数
    final Map<String, dynamic> queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    if (specialization != null) {
      queryParams['specialization'] = specialization;
    }

    if (rating != null) {
      queryParams['minRating'] = rating.toString();
    }

    // 发送GET请求获取营养师列表
    final response = await _apiService.get(
      ApiConstants.nutritionist,
      queryParams: queryParams,
      token: token,
    );

    // 处理响应数据，将JSON转换为模型对象
    final List<dynamic> nutritionistData = response['nutritionists'];
    final List<Nutritionist> nutritionists = nutritionistData
        .map((data) => Nutritionist.fromJson(data))
        .toList();

    // 返回标准化的结果，包含营养师列表和分页信息
    return {
      'nutritionists': nutritionists,
      'total': response['total'],
      'page': response['page'],
      'totalPages': response['totalPages'],
    };
  }

  /// 获取营养师详情
  ///
  /// 根据营养师ID获取单个营养师的完整信息
  ///
  /// @param nutritionistId 营养师ID
  /// @param token 用户令牌，可选
  /// @return 营养师详情对象
  Future<Nutritionist> getNutritionistDetails({
    required String nutritionistId,
    String? token,
  }) async {
    // 发送GET请求获取营养师详情
    final response = await _apiService.get(
      '${ApiConstants.nutritionist}/$nutritionistId',
      token: token,
    );

    // 将响应数据转换为营养师模型对象
    return Nutritionist.fromJson(response);
  }

  /// 预约营养师咨询
  ///
  /// 为当前用户创建与指定营养师的咨询预约
  ///
  /// @param nutritionistId 营养师ID
  /// @param consultationDate 咨询日期时间
  /// @param topicId 咨询主题ID
  /// @param message 附加消息
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 创建成功的咨询预约对象
  Future<Consultation> bookConsultation({
    required String nutritionistId,
    required DateTime consultationDate,
    required String topicId,
    String? message,
    required String token,
  }) async {
    // 构建请求数据
    final Map<String, dynamic> data = {
      'nutritionistId': nutritionistId,
      'consultationDate': consultationDate.toIso8601String(),
      'topicId': topicId,
    };

    if (message != null) {
      data['message'] = message;
    }

    // 发送POST请求创建咨询预约
    final response = await _apiService.post(
      ApiConstants.consultations,
      data: data,
      token: token,
    );

    // 将响应数据转换为咨询模型对象
    return Consultation.fromJson(response);
  }

  /// 获取用户的咨询预约列表
  ///
  /// 获取当前登录用户的所有咨询预约记录
  ///
  /// @param status 可选，按状态筛选（pending待处理，confirmed已确认，completed已完成，cancelled已取消）
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 咨询预约列表
  Future<List<Consultation>> getUserConsultations({
    String? status,
    required String token,
  }) async {
    // 构建查询参数
    final Map<String, dynamic> queryParams = {};
    if (status != null) {
      queryParams['status'] = status;
    }

    // 发送GET请求获取用户的咨询预约
    final response = await _apiService.get(
      ApiConstants.userConsultations,
      queryParams: queryParams,
      token: token,
    );

    // 处理响应数据，将JSON转换为模型对象
    final List<dynamic> consultationData = response['consultations'];
    return consultationData
        .map((data) => Consultation.fromJson(data))
        .toList();
  }

  /// 取消咨询预约
  ///
  /// 取消用户已预约但尚未进行的咨询
  ///
  /// @param consultationId 咨询预约ID
  /// @param reason 可选，取消原因
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 操作是否成功
  Future<bool> cancelConsultation({
    required String consultationId,
    String? reason,
    required String token,
  }) async {
    // 构建请求数据
    final Map<String, dynamic> data = {};
    if (reason != null) {
      data['reason'] = reason;
    }

    // 发送PUT请求取消咨询预约
    await _apiService.put(
      '${ApiConstants.consultations}/$consultationId/cancel',
      data: data,
      token: token,
    );

    // 取消成功返回true
    return true;
  }

  /// 评价营养师咨询
  ///
  /// 为已完成的咨询提交评价和评分
  ///
  /// @param consultationId 咨询预约ID
  /// @param rating 评分（1-5）
  /// @param review 可选，文字评价
  /// @param token 用户令牌，必须提供（需要登录）
  /// @return 操作是否成功
  Future<bool> rateConsultation({
    required String consultationId,
    required int rating,
    String? review,
    required String token,
  }) async {
    // 验证评分范围
    if (rating < 1 || rating > 5) {
      throw ArgumentError('评分必须在1到5之间');
    }

    // 构建请求数据
    final Map<String, dynamic> data = {
      'rating': rating,
    };

    if (review != null) {
      data['review'] = review;
    }

    // 发送POST请求提交评价
    await _apiService.post(
      '${ApiConstants.consultations}/$consultationId/review',
      data: data,
      token: token,
    );

    // 评价成功返回true
    return true;
  }

  /// 获取营养师可用预约时间
  ///
  /// 获取指定营养师未来可预约的时间段列表
  ///
  /// @param nutritionistId 营养师ID
  /// @param startDate 开始日期
  /// @param endDate 结束日期
  /// @param token 用户令牌，可选
  /// @return 可用时间段列表
  Future<List<DateTime>> getAvailableSlots({
    required String nutritionistId,
    required DateTime startDate,
    required DateTime endDate,
    String? token,
  }) async {
    // 构建查询参数
    final Map<String, dynamic> queryParams = {
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };

    // 发送GET请求获取可用时间段
    final response = await _apiService.get(
      '${ApiConstants.nutritionist}/$nutritionistId/available-slots',
      queryParams: queryParams,
      token: token,
    );

    // 处理响应数据，将字符串日期转换为DateTime对象
    final List<dynamic> slotData = response['availableSlots'];
    return slotData.map((slot) => DateTime.parse(slot)).toList();
  }

  /// 获取咨询主题列表
  ///
  /// 获取系统中所有可选的咨询主题
  ///
  /// @param token 用户令牌，可选
  /// @return 咨询主题列表，包含ID和名称
  Future<List<Map<String, dynamic>>> getConsultationTopics({
    String? token,
  }) async {
    // 发送GET请求获取咨询主题
    final response = await _apiService.get(
      ApiConstants.consultationTopics,
      token: token,
    );

    // 返回主题列表
    return List<Map<String, dynamic>>.from(response['topics']);
  }
} 