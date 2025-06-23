import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/consultation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/nutrition_plan_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../models/consultation_model.dart';
import '../models/chat_message_model.dart';
import '../models/nutrition_plan_model.dart';

class ConsultationRepositoryImpl implements ConsultationRepository {
  final ApiClient _apiClient;

  ConsultationRepositoryImpl(this._apiClient);

  @override
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations({
    String? userId,
    String? nutritionistId,
    ConsultationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['userId'] = userId;
      if (nutritionistId != null) queryParams['nutritionistId'] = nutritionistId;
      if (status != null) queryParams['status'] = status.value;
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get('/consultations',
          queryParameters: queryParams);

      final responseData = response.data['data'] ?? {};
      final List<dynamic> consultationsJson = responseData['consultations'] ?? [];
      final consultations = consultationsJson
          .map((json) => ConsultationModel.fromJson(json).toEntity())
          .toList();

      return Right(consultations);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch consultations'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConsultationEntity>> getConsultationById(
      String consultationId) async {
    try {
      final response = await _apiClient.get('/consultations/$consultationId');
      
      final consultationJson = response.data['data'];
      final consultation = ConsultationModel.fromJson(consultationJson).toEntity();
      
      return Right(consultation);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch consultation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConsultationEntity>> createConsultation({
    required String userId,
    required String nutritionistId,
    required ConsultationType type,
    required String title,
    required String description,
    required DateTime scheduledStartTime,
    required int duration,
    required double price,
    List<String>? tags,
  }) async {
    try {
      final request = CreateConsultationRequest(
        userId: userId,
        nutritionistId: nutritionistId,
        type: type,
        title: title,
        description: description,
        scheduledStartTime: scheduledStartTime,
        duration: duration,
        price: price,
        tags: tags ?? [],
      );

      final response = await _apiClient.post('/consultations',
          data: request.toJson());
      
      final consultationJson = response.data['data'];
      final consultation = ConsultationModel.fromJson(consultationJson).toEntity();
      
      return Right(consultation);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to create consultation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConsultationEntity>> updateConsultation(
    String consultationId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiClient.put('/consultations/$consultationId',
          data: updates);
      
      final consultationJson = response.data['data'];
      final consultation = ConsultationModel.fromJson(consultationJson).toEntity();
      
      return Right(consultation);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update consultation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConsultationEntity>> updateConsultationStatus(
    String consultationId,
    ConsultationStatus newStatus,
  ) async {
    try {
      final response = await _apiClient.put('/consultations/$consultationId/status',
          data: {'status': newStatus.value});
      
      final consultationJson = response.data['data'];
      final consultation = ConsultationModel.fromJson(consultationJson).toEntity();
      
      return Right(consultation);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update consultation status'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteConsultation(String consultationId) async {
    try {
      await _apiClient.delete('/consultations/$consultationId');
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete consultation'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatMessageEntity>>> getConsultationMessages(
    String consultationId, {
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get('/chat-messages/$consultationId',
          queryParameters: queryParams);

      final responseData = response.data['data'] ?? {};
      final List<dynamic> messagesJson = responseData['messages'] ?? [];
      final messages = messagesJson
          .map((json) => ChatMessageModel.fromJson(json).toEntity())
          .toList();

      return Right(messages);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch messages'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String consultationId,
    required String senderId,
    required String content,
    MessageType? messageType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    try {
      final response = await _apiClient.post('/chat-messages/$consultationId',
          data: {
            'senderId': senderId,
            'content': content,
            'messageType': messageType?.name ?? MessageType.text.name,
            'attachments': attachments ?? [],
          });
      
      final messageJson = response.data['data'];
      final message = ChatMessageModel.fromJson(messageJson).toEntity();
      
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to send message'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> markMessageAsRead(String messageId) async {
    try {
      await _apiClient.put('/chat-messages/$messageId/read');
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to mark message as read'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> editMessage(
    String messageId,
    String newContent,
  ) async {
    try {
      final response = await _apiClient.put('/chat-messages/$messageId',
          data: {'content': newContent});
      
      final messageJson = response.data['data'];
      final message = ChatMessageModel.fromJson(messageJson).toEntity();
      
      return Right(message);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to edit message'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteMessage(String messageId) async {
    try {
      await _apiClient.delete('/chat-messages/$messageId');
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete message'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NutritionPlanEntity>>> getNutritionPlans({
    String? userId,
    String? nutritionistId,
    PlanStatus? status,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (userId != null) queryParams['userId'] = userId;
      if (nutritionistId != null) queryParams['nutritionistId'] = nutritionistId;
      if (status != null) queryParams['status'] = status.name;
      if (page != null) queryParams['page'] = page;
      if (limit != null) queryParams['limit'] = limit;

      final response = await _apiClient.get('/nutrition-plans',
          queryParameters: queryParams);

      final responseData = response.data['data'] ?? {};
      final List<dynamic> plansJson = responseData['plans'] ?? [];
      final plans = plansJson
          .map((json) => NutritionPlanModel.fromJson(json).toEntity())
          .toList();

      return Right(plans);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch nutrition plans'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionPlanEntity>> getNutritionPlanById(
      String planId) async {
    try {
      final response = await _apiClient.get('/nutrition-plans/$planId');
      
      final planJson = response.data['data'];
      final plan = NutritionPlanModel.fromJson(planJson).toEntity();
      
      return Right(plan);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to fetch nutrition plan'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionPlanEntity>> createNutritionPlan({
    required String userId,
    required String nutritionistId,
    String? consultationId,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required NutritionGoals goals,
    required List<DailyPlan> dailyPlans,
    List<FoodRecommendation>? recommendedFoods,
    List<FoodRestriction>? restrictedFoods,
    MealTiming? mealTiming,
  }) async {
    try {
      final response = await _apiClient.post('/nutrition-plans',
          data: {
            'userId': userId,
            'nutritionistId': nutritionistId,
            'consultationId': consultationId,
            'title': title,
            'description': description,
            'startDate': startDate.toIso8601String(),
            'endDate': endDate.toIso8601String(),
            'goals': goals.toJson(),
            'dailyPlans': dailyPlans.map((p) => p.toJson()).toList(),
            'recommendedFoods': recommendedFoods?.map((f) => f.toJson()).toList() ?? [],
            'restrictedFoods': restrictedFoods?.map((f) => f.toJson()).toList() ?? [],
            'mealTiming': mealTiming?.toJson(),
          });
      
      final planJson = response.data['data'];
      final plan = NutritionPlanModel.fromJson(planJson).toEntity();
      
      return Right(plan);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to create nutrition plan'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NutritionPlanEntity>> updateNutritionPlan(
    String planId,
    Map<String, dynamic> updates,
  ) async {
    try {
      final response = await _apiClient.put('/nutrition-plans/$planId',
          data: updates);
      
      final planJson = response.data['data'];
      final plan = NutritionPlanModel.fromJson(planJson).toEntity();
      
      return Right(plan);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to update nutrition plan'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteNutritionPlan(String planId) async {
    try {
      await _apiClient.delete('/nutrition-plans/$planId');
      return const Right(true);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to delete nutrition plan'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getAIRecommendations({
    required String userId,
    required Map<String, dynamic> healthData,
    required List<String> goals,
  }) async {
    try {
      final response = await _apiClient.post('/ai-recommendations',
          data: {
            'userId': userId,
            'healthData': healthData,
            'goals': goals,
          });
      
      final recommendations = response.data['data'] as Map<String, dynamic>;
      return Right(recommendations);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to get AI recommendations'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> analyzeFood({
    required String imageUrl,
    String? description,
  }) async {
    try {
      final response = await _apiClient.post('/ai-recommendations/analyze-food',
          data: {
            'imageUrl': imageUrl,
            'description': description,
          });
      
      final analysis = response.data['data'] as Map<String, dynamic>;
      return Right(analysis);
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Failed to analyze food'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<ChatMessageEntity> subscribeToMessages(String consultationId) {
    // TODO: Implement WebSocket subscription for real-time messages
    // This would integrate with the backend's Socket.IO implementation
    throw UnimplementedError('WebSocket subscription not yet implemented');
  }

  @override
  Stream<ConsultationEntity> subscribeToConsultationUpdates(String consultationId) {
    // TODO: Implement WebSocket subscription for real-time consultation updates
    // This would integrate with the backend's Socket.IO implementation
    throw UnimplementedError('WebSocket subscription not yet implemented');
  }
}