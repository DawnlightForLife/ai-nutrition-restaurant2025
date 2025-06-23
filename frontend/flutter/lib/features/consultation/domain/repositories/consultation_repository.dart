import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/consultation_entity.dart';
import '../entities/chat_message_entity.dart';
import '../entities/nutrition_plan_entity.dart';

abstract class ConsultationRepository {
  // Consultation CRUD operations
  Future<Either<Failure, List<ConsultationEntity>>> getConsultations({
    String? userId,
    String? nutritionistId,
    ConsultationStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    int? page,
    int? limit,
  });

  Future<Either<Failure, ConsultationEntity>> getConsultationById(String consultationId);

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
  });

  Future<Either<Failure, ConsultationEntity>> updateConsultation(
    String consultationId,
    Map<String, dynamic> updates,
  );

  Future<Either<Failure, ConsultationEntity>> updateConsultationStatus(
    String consultationId,
    ConsultationStatus newStatus,
  );

  Future<Either<Failure, bool>> deleteConsultation(String consultationId);

  // Chat message operations
  Future<Either<Failure, List<ChatMessageEntity>>> getConsultationMessages(
    String consultationId, {
    int? page,
    int? limit,
  });

  Future<Either<Failure, ChatMessageEntity>> sendMessage({
    required String consultationId,
    required String senderId,
    required String content,
    MessageType? messageType,
    List<Map<String, dynamic>>? attachments,
  });

  Future<Either<Failure, bool>> markMessageAsRead(String messageId);

  Future<Either<Failure, ChatMessageEntity>> editMessage(
    String messageId,
    String newContent,
  );

  Future<Either<Failure, bool>> deleteMessage(String messageId);

  // Nutrition plan operations
  Future<Either<Failure, List<NutritionPlanEntity>>> getNutritionPlans({
    String? userId,
    String? nutritionistId,
    PlanStatus? status,
    int? page,
    int? limit,
  });

  Future<Either<Failure, NutritionPlanEntity>> getNutritionPlanById(String planId);

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
  });

  Future<Either<Failure, NutritionPlanEntity>> updateNutritionPlan(
    String planId,
    Map<String, dynamic> updates,
  );

  Future<Either<Failure, bool>> deleteNutritionPlan(String planId);

  // AI-powered features
  Future<Either<Failure, Map<String, dynamic>>> getAIRecommendations({
    required String userId,
    required Map<String, dynamic> healthData,
    required List<String> goals,
  });

  Future<Either<Failure, Map<String, dynamic>>> analyzeFood({
    required String imageUrl,
    String? description,
  });

  // Real-time features
  Stream<ChatMessageEntity> subscribeToMessages(String consultationId);
  Stream<ConsultationEntity> subscribeToConsultationUpdates(String consultationId);
}