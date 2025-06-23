import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/providers/dio_provider.dart';
import '../../domain/entities/consultation_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/entities/nutrition_plan_entity.dart';
import '../../domain/repositories/consultation_repository.dart';
import '../../data/repositories/consultation_repository_impl.dart';

// Repository provider
final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ConsultationRepositoryImpl(apiClient);
});

// Consultation list provider
final consultationListProvider = StateNotifierProvider.family<
    ConsultationListNotifier, AsyncValue<List<ConsultationEntity>>, ConsultationListParams>(
  (ref, params) => ConsultationListNotifier(ref.watch(consultationRepositoryProvider), params),
);

// Single consultation provider
final consultationProvider = StateNotifierProvider.family<
    ConsultationNotifier, AsyncValue<ConsultationEntity?>, String>(
  (ref, consultationId) => ConsultationNotifier(ref.watch(consultationRepositoryProvider), consultationId),
);

// Chat messages provider
final chatMessagesProvider = StateNotifierProvider.family<
    ChatMessagesNotifier, AsyncValue<List<ChatMessageEntity>>, String>(
  (ref, consultationId) => ChatMessagesNotifier(ref.watch(consultationRepositoryProvider), consultationId),
);

// Parameters classes
class ConsultationListParams {
  final String? userId;
  final String? nutritionistId;
  final ConsultationStatus? status;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? page;
  final int? limit;

  ConsultationListParams({
    this.userId,
    this.nutritionistId,
    this.status,
    this.startDate,
    this.endDate,
    this.page,
    this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsultationListParams &&
          userId == other.userId &&
          nutritionistId == other.nutritionistId &&
          status == other.status &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          page == other.page &&
          limit == other.limit;

  @override
  int get hashCode =>
      userId.hashCode ^
      nutritionistId.hashCode ^
      status.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      page.hashCode ^
      limit.hashCode;
}

// Notifier classes
class ConsultationListNotifier extends StateNotifier<AsyncValue<List<ConsultationEntity>>> {
  final ConsultationRepository _repository;
  final ConsultationListParams params;

  ConsultationListNotifier(this._repository, this.params) : super(const AsyncValue.loading()) {
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    state = const AsyncValue.loading();
    final result = await _repository.getConsultations(
      userId: params.userId,
      nutritionistId: params.nutritionistId,
      status: params.status,
      startDate: params.startDate,
      endDate: params.endDate,
      page: params.page,
      limit: params.limit,
    );
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (consultations) => state = AsyncValue.data(consultations),
    );
  }

  Future<void> refreshConsultations() async {
    await loadConsultations();
  }

  Future<bool> updateConsultationStatus(String consultationId, ConsultationStatus newStatus) async {
    final result = await _repository.updateConsultationStatus(consultationId, newStatus);
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (updatedConsultation) {
        state.whenData((consultations) {
          final updatedConsultations = consultations.map((c) =>
              c.id == consultationId ? updatedConsultation : c).toList();
          state = AsyncValue.data(updatedConsultations);
        });
        return true;
      },
    );
  }
}

class ConsultationNotifier extends StateNotifier<AsyncValue<ConsultationEntity?>> {
  final ConsultationRepository _repository;
  final String consultationId;

  ConsultationNotifier(this._repository, this.consultationId) : super(const AsyncValue.loading()) {
    loadConsultation();
  }

  Future<void> loadConsultation() async {
    state = const AsyncValue.loading();
    final result = await _repository.getConsultationById(consultationId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (consultation) => state = AsyncValue.data(consultation),
    );
  }

  Future<void> refreshConsultation() async {
    await loadConsultation();
  }
}

class ChatMessagesNotifier extends StateNotifier<AsyncValue<List<ChatMessageEntity>>> {
  final ConsultationRepository _repository;
  final String consultationId;

  ChatMessagesNotifier(this._repository, this.consultationId) : super(const AsyncValue.loading()) {
    loadMessages();
  }

  Future<void> loadMessages() async {
    state = const AsyncValue.loading();
    final result = await _repository.getConsultationMessages(consultationId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (messages) => state = AsyncValue.data(messages),
    );
  }

  Future<bool> sendMessage({
    required String senderId,
    required String content,
    MessageType? messageType,
    List<Map<String, dynamic>>? attachments,
  }) async {
    final result = await _repository.sendMessage(
      consultationId: consultationId,
      senderId: senderId,
      content: content,
      messageType: messageType,
      attachments: attachments,
    );
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (newMessage) {
        state.whenData((messages) {
          state = AsyncValue.data([...messages, newMessage]);
        });
        return true;
      },
    );
  }

  Future<bool> markMessageAsRead(String messageId) async {
    final result = await _repository.markMessageAsRead(messageId);
    return result.fold(
      (failure) => false,
      (_) {
        state.whenData((messages) {
          final updatedMessages = messages.map((m) =>
              m.id == messageId ? m.copyWith(isRead: true, readAt: DateTime.now()) : m).toList();
          state = AsyncValue.data(updatedMessages);
        });
        return true;
      },
    );
  }
}