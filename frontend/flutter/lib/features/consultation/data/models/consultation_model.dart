import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/consultation_entity.dart';

part 'consultation_model.freezed.dart';
part 'consultation_model.g.dart';

@freezed
class ConsultationModel with _$ConsultationModel {
  const ConsultationModel._();
  
  const factory ConsultationModel({
    @JsonKey(name: '_id') required String id,
    required String userId,
    required String nutritionistId,
    required String orderNumber,
    required ConsultationStatus status,
    required ConsultationType type,
    required String title,
    required String description,
    @Default([]) List<String> tags,
    required DateTime scheduledStartTime,
    required DateTime scheduledEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    required int duration,
    required double price,
    @Default('') String meetingUrl,
    @Default('') String meetingId,
    @Default('') String meetingPassword,
    @Default({}) Map<String, dynamic> paymentInfo,
    double? rating,
    @Default('') String feedback,
    @Default('') String summary,
    @Default([]) List<String> attachments,
    String? nutritionPlanId,
    String? aiRecommendationId,
    @Default({}) Map<String, dynamic> metadata,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ConsultationModel;

  factory ConsultationModel.fromJson(Map<String, dynamic> json) => 
      _$ConsultationModelFromJson(json);
}

// Extension methods to convert between models and entities
extension ConsultationModelX on ConsultationModel {
  ConsultationEntity toEntity() {
    return ConsultationEntity(
      id: id,
      userId: userId,
      nutritionistId: nutritionistId,
      orderNumber: orderNumber,
      status: status,
      type: type,
      title: title,
      description: description,
      tags: tags,
      scheduledStartTime: scheduledStartTime,
      scheduledEndTime: scheduledEndTime,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      duration: duration,
      price: price,
      meetingUrl: meetingUrl,
      meetingId: meetingId,
      meetingPassword: meetingPassword,
      paymentInfo: paymentInfo,
      rating: rating,
      feedback: feedback,
      summary: summary,
      attachments: attachments,
      nutritionPlanId: nutritionPlanId,
      aiRecommendationId: aiRecommendationId,
      metadata: metadata,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

@freezed
class CreateConsultationRequest with _$CreateConsultationRequest {
  const factory CreateConsultationRequest({
    required String userId,
    required String nutritionistId,
    required ConsultationType type,
    required String title,
    required String description,
    required DateTime scheduledStartTime,
    required int duration,
    required double price,
    @Default([]) List<String> tags,
  }) = _CreateConsultationRequest;

  factory CreateConsultationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateConsultationRequestFromJson(json);
}

@freezed
class UpdateConsultationRequest with _$UpdateConsultationRequest {
  const factory UpdateConsultationRequest({
    String? title,
    String? description,
    ConsultationStatus? status,
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    String? summary,
    double? rating,
    String? feedback,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) = _UpdateConsultationRequest;

  factory UpdateConsultationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateConsultationRequestFromJson(json);
}