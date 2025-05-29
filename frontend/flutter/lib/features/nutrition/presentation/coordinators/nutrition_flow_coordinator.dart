import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/coordinators/base_coordinator.dart';
import '../../../../core/coordinators/coordinator_result.dart';
import '../../../../features/recommendation/presentation/router/recommendation_router.dart';
import '../../domain/entities/nutrition_profile.dart';
import '../providers/nutrition_profile_provider.dart';
import '../router/nutrition_router.dart';

/// 营养管理流程协调器
/// 处理营养档案创建、AI推荐、结果展示等业务流程
class NutritionFlowCoordinator extends BaseCoordinator {
  NutritionFlowCoordinator(super.ref);
  
  @override
  Future<void> start() async {
    // 导航到营养档案列表
    await router.navigateTo(NutritionRouter.profilesPath);
  }
  
  /// 处理营养档案创建完成后的流程
  Future<CoordinatorResult<void>> handleProfileCreationSuccess(
    NutritionProfile profile,
  ) async {
    try {
      // 1. 显示创建成功提示
      _showSuccessMessage('营养档案创建成功');
      
      // 2. 询问是否立即进行AI推荐
      final shouldGetRecommendation = await _showRecommendationDialog();
      
      if (shouldGetRecommendation) {
        // 3. 导航到AI推荐聊天页面
        await router.navigateTo(NutritionRouter.aiChatPath);
      } else {
        // 4. 返回档案列表
        await router.navigateTo(NutritionRouter.profilesPath);
      }
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '档案创建流程处理失败',
        code: 'PROFILE_CREATION_ERROR',
      );
    }
  }
  
  /// 处理AI推荐完成后的流程
  Future<CoordinatorResult<void>> handleAiRecommendationComplete(
    String recommendationId,
  ) async {
    try {
      // 1. 导航到推荐结果页面
      await router.navigateTo(
        NutritionRouter.aiResultPathWithId(recommendationId),
      );
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: 'AI推荐流程处理失败',
        code: 'AI_RECOMMENDATION_ERROR',
      );
    }
  }
  
  /// 处理推荐结果查看完成后的流程
  Future<CoordinatorResult<void>> handleRecommendationViewComplete(
    String recommendationId,
  ) async {
    try {
      // 1. 询问是否需要反馈
      final shouldProvideFeedback = await _showFeedbackDialog();
      
      if (shouldProvideFeedback) {
        // 2. 导航到反馈页面
        await router.navigateTo(
          RecommendationRouter.feedbackPathWithId(recommendationId),
        );
      } else {
        // 3. 返回推荐列表
        await router.navigateTo(RecommendationRouter.listPath);
      }
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '推荐查看流程处理失败',
        code: 'RECOMMENDATION_VIEW_ERROR',
      );
    }
  }
  
  /// 处理营养档案切换流程
  Future<CoordinatorResult<void>> handleProfileSwitch(String profileId) async {
    try {
      // 1. 更新当前激活的档案
      await _setActiveProfile(profileId);
      
      // 2. 刷新相关数据
      ref.invalidate(userProfileProvider);
      
      // 3. 显示切换成功提示
      _showSuccessMessage('已切换到选定的营养档案');
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '档案切换失败',
        code: 'PROFILE_SWITCH_ERROR',
      );
    }
  }
  
  /// 处理档案删除流程
  Future<CoordinatorResult<void>> handleProfileDeletion(String profileId) async {
    try {
      // 1. 显示确认对话框
      final confirmed = await _showDeleteConfirmation();
      
      if (!confirmed) {
        return const CoordinatorResult.cancelled();
      }
      
      // 2. 执行删除
      // TODO: 调用删除 API
      
      // 3. 刷新列表
      ref.invalidate(userProfileProvider);
      
      // 4. 显示删除成功提示
      _showSuccessMessage('营养档案已删除');
      
      return const CoordinatorResult.success(data: null);
    } catch (e) {
      return CoordinatorResult.failure(
        error: '档案删除失败',
        code: 'PROFILE_DELETION_ERROR',
      );
    }
  }
  
  /// 显示成功消息
  void _showSuccessMessage(String message) {
    // TODO: 实现消息提示
  }
  
  /// 显示推荐对话框
  Future<bool> _showRecommendationDialog() async {
    // TODO: 实现对话框
    return true;
  }
  
  /// 显示反馈对话框
  Future<bool> _showFeedbackDialog() async {
    // TODO: 实现对话框
    return false;
  }
  
  /// 显示删除确认对话框
  Future<bool> _showDeleteConfirmation() async {
    // TODO: 实现对话框
    return false;
  }
  
  /// 设置激活的档案
  Future<void> _setActiveProfile(String profileId) async {
    // TODO: 实现设置逻辑
  }
}

/// Provider
final nutritionFlowCoordinatorProvider = Provider((ref) {
  return NutritionFlowCoordinator(ref);
});