import '../../models/nutrition/consultation.dart';
import '../core/api_service.dart';
import '../../common/constants/api_constants.dart';

/// 咨询服务类
///
/// 负责与后端API交互，处理与营养咨询相关的所有网络请求
class ConsultationService {
  /// API服务实例
  final ApiService _apiService;

  /// 构造函数
  ConsultationService(this._apiService);

  /// 获取用户的所有咨询
  ///
  /// 返回当前登录用户的所有咨询列表
  Future<List<Consultation>> getUserConsultations() async {
    try {
      final response = await _apiService.get(
        ApiConstants.userConsultations,
      );
      
      final List<dynamic> data = response['data'];
      return data.map((json) => Consultation.fromJson(json)).toList();
    } catch (e) {
      throw Exception('获取咨询列表失败: $e');
    }
  }

  /// 获取咨询详情
  ///
  /// [consultationId] 咨询ID
  /// 返回指定ID的咨询详情
  Future<Consultation> getConsultationDetail(String consultationId) async {
    try {
      final response = await _apiService.get(
        '${ApiConstants.consultations}/$consultationId',
      );
      
      return Consultation.fromJson(response['data']);
    } catch (e) {
      throw Exception('获取咨询详情失败: $e');
    }
  }

  /// 创建新的咨询
  ///
  /// [nutritionistId] 营养师ID
  /// [topic] 咨询主题
  /// [description] 咨询描述
  /// [startTime] 开始时间
  /// [duration] 咨询时长（分钟）
  /// 返回创建的咨询对象
  Future<Consultation> createConsultation({
    required String nutritionistId,
    required String topic,
    required String description,
    required DateTime startTime,
    required int duration,
  }) async {
    try {
      final payload = {
        'nutritionistId': nutritionistId,
        'topic': topic,
        'description': description,
        'startTime': startTime.toIso8601String(),
        'duration': duration,
      };
      
      final response = await _apiService.post(
        ApiConstants.consultations,
        data: payload,
      );
      
      return Consultation.fromJson(response['data']);
    } catch (e) {
      throw Exception('创建咨询失败: $e');
    }
  }

  /// 取消咨询
  ///
  /// [consultationId] 咨询ID
  /// 返回是否成功取消
  Future<bool> cancelConsultation(String consultationId) async {
    try {
      final response = await _apiService.put(
        '${ApiConstants.consultations}/$consultationId/cancel',
      );
      
      return response['success'] == true;
    } catch (e) {
      throw Exception('取消咨询失败: $e');
    }
  }

  /// 提交咨询评价
  ///
  /// [consultationId] 咨询ID
  /// [rating] 评分（1-5）
  /// [review] 评价内容
  /// 返回是否成功提交评价
  Future<bool> submitReview({
    required String consultationId,
    required double rating,
    required String review,
  }) async {
    try {
      final payload = {
        'rating': rating,
        'review': review,
      };
      
      final response = await _apiService.put(
        '${ApiConstants.consultations}/$consultationId/review',
        data: payload,
      );
      
      return response['success'] == true;
    } catch (e) {
      throw Exception('提交评价失败: $e');
    }
  }

  /// 获取咨询主题列表
  ///
  /// 返回系统中所有可选的咨询主题
  Future<List<Map<String, dynamic>>> getConsultationTopics() async {
    try {
      final response = await _apiService.get(
        ApiConstants.consultationTopics,
      );
      
      final List<dynamic> data = response['topics'];
      return List<Map<String, dynamic>>.from(data);
    } catch (e) {
      throw Exception('获取咨询主题失败: $e');
    }
  }
} 