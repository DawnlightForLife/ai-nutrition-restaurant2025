/// 咨询模块统一业务门面
/// 
/// 聚合咨询相关的所有用例和业务逻辑
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/consultation.dart';
import '../../domain/usecases/get_consultations_usecase.dart';

/// 咨询业务门面
class ConsultationFacade {
  const ConsultationFacade({
    required this.getConsultationsUseCase,
  });

  final GetConsultationsUseCase getConsultationsUseCase;

  /// 获取咨询列表
  Future<Either<ConsultationFailure, List<Consultation>>> getConsultations({
    String? userId,
    ConsultationStatus? status,
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取咨询列表的业务逻辑
    throw UnimplementedError('getConsultations 待实现');
  }

  /// 创建新咨询
  Future<Either<ConsultationFailure, Consultation>> createConsultation({
    required String userId,
    required String nutritionistId,
    required String topic,
    required String description,
  }) async {
    // TODO: 实现创建咨询的业务逻辑
    throw UnimplementedError('createConsultation 待实现');
  }

  /// 回复咨询
  Future<Either<ConsultationFailure, ConsultationMessage>> replyConsultation({
    required String consultationId,
    required String message,
    required String senderId,
  }) async {
    // TODO: 实现回复咨询的业务逻辑
    throw UnimplementedError('replyConsultation 待实现');
  }

  /// 关闭咨询
  Future<Either<ConsultationFailure, Consultation>> closeConsultation({
    required String consultationId,
    String? summary,
  }) async {
    // TODO: 实现关闭咨询的业务逻辑
    throw UnimplementedError('closeConsultation 待实现');
  }

  /// 获取咨询详情
  Future<Either<ConsultationFailure, ConsultationDetail>> getConsultationDetail({
    required String consultationId,
  }) async {
    // TODO: 实现获取咨询详情的业务逻辑
    throw UnimplementedError('getConsultationDetail 待实现');
  }
}

/// 咨询业务失败类型
abstract class ConsultationFailure {}

/// 咨询状态
enum ConsultationStatus {
  pending,
  active,
  closed,
}

/// 咨询消息
abstract class ConsultationMessage {}

/// 咨询详情
abstract class ConsultationDetail {}