import 'package:flutter/foundation.dart';
import '../../models/nutrition/consultation.dart';
import '../../services/consultation/consultation_service.dart';

/// 咨询服务提供者类
///
/// 管理应用中营养咨询相关的状态和操作
class ConsultationProvider with ChangeNotifier {
  /// 咨询服务实例
  final ConsultationService _consultationService;
  
  /// 用户的所有咨询
  List<Consultation> _consultations = [];
  
  /// 当前正在查看的咨询
  Consultation? _currentConsultation;
  
  /// 加载状态
  bool _isLoading = false;
  
  /// 错误信息
  String? _error;

  /// 构造函数
  ConsultationProvider(this._consultationService);

  /// 获取用户的所有咨询列表
  List<Consultation> get consultations => _consultations;
  
  /// 获取当前咨询
  Consultation? get currentConsultation => _currentConsultation;
  
  /// 获取加载状态
  bool get isLoading => _isLoading;
  
  /// 获取错误信息
  String? get error => _error;

  /// 设置加载状态
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// 设置错误信息
  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  /// 加载用户的所有咨询
  Future<void> loadConsultations() async {
    _setLoading(true);
    _setError(null);
    
    try {
      final consultations = await _consultationService.getUserConsultations();
      _consultations = consultations;
      notifyListeners();
    } catch (e) {
      _setError('加载咨询列表失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 加载单个咨询详情
  Future<void> loadConsultationDetail(String consultationId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final consultation = await _consultationService.getConsultationDetail(consultationId);
      _currentConsultation = consultation;
      notifyListeners();
    } catch (e) {
      _setError('加载咨询详情失败: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// 创建新的咨询
  Future<bool> createConsultation({
    required String nutritionistId,
    required String topic,
    required String description,
    required DateTime startTime,
    required int duration,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final consultation = await _consultationService.createConsultation(
        nutritionistId: nutritionistId,
        topic: topic,
        description: description,
        startTime: startTime,
        duration: duration,
      );
      
      _consultations.add(consultation);
      _currentConsultation = consultation;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('创建咨询失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 取消咨询
  Future<bool> cancelConsultation(String consultationId) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final success = await _consultationService.cancelConsultation(consultationId);
      
      if (success) {
        // 更新本地咨询状态
        final index = _consultations.indexWhere((c) => c.id == consultationId);
        if (index != -1) {
          // 由于Consultation是不可变的，我们创建一个新的对象
          final updatedConsultation = Consultation(
            id: _consultations[index].id,
            userId: _consultations[index].userId,
            nutritionistId: _consultations[index].nutritionistId,
            topic: _consultations[index].topic,
            description: _consultations[index].description,
            startTime: _consultations[index].startTime,
            duration: _consultations[index].duration,
            status: 'cancelled',
            fee: _consultations[index].fee,
            rating: _consultations[index].rating,
            review: _consultations[index].review,
            notes: _consultations[index].notes,
            createdAt: _consultations[index].createdAt,
            updatedAt: DateTime.now(),
          );
          
          _consultations[index] = updatedConsultation;
          
          if (_currentConsultation?.id == consultationId) {
            _currentConsultation = updatedConsultation;
          }
          
          notifyListeners();
        }
      }
      
      return success;
    } catch (e) {
      _setError('取消咨询失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 提交咨询评价
  Future<bool> submitReview({
    required String consultationId,
    required double rating,
    required String review,
  }) async {
    _setLoading(true);
    _setError(null);
    
    try {
      final success = await _consultationService.submitReview(
        consultationId: consultationId,
        rating: rating,
        review: review,
      );
      
      if (success) {
        // 更新本地咨询的评价信息
        final index = _consultations.indexWhere((c) => c.id == consultationId);
        if (index != -1) {
          final updatedConsultation = Consultation(
            id: _consultations[index].id,
            userId: _consultations[index].userId,
            nutritionistId: _consultations[index].nutritionistId,
            topic: _consultations[index].topic,
            description: _consultations[index].description,
            startTime: _consultations[index].startTime,
            duration: _consultations[index].duration,
            status: _consultations[index].status,
            fee: _consultations[index].fee,
            rating: rating,
            review: review,
            notes: _consultations[index].notes,
            createdAt: _consultations[index].createdAt,
            updatedAt: DateTime.now(),
          );
          
          _consultations[index] = updatedConsultation;
          
          if (_currentConsultation?.id == consultationId) {
            _currentConsultation = updatedConsultation;
          }
          
          notifyListeners();
        }
      }
      
      return success;
    } catch (e) {
      _setError('提交评价失败: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 按状态过滤咨询
  List<Consultation> getConsultationsByStatus(String status) {
    return _consultations.where((consultation) => 
      consultation.status == status
    ).toList();
  }

  /// 清除错误
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 