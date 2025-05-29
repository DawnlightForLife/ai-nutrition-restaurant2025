/// 自动生成的 Provider 索引
/// 
/// 生成时间: 2025-05-29 11:04:57.202052
/// Provider 数量: 62
/// 
/// ⚠️ 不要手动编辑此文件，运行以下命令重新生成：
/// dart run tools/generate_provider_index.dart
library;

import '../../app.dart';
import '../../core/coordinators/coordinator_manager.dart';
import '../../core/coordinators/example_usage.dart';
import '../../core/di/injection_container.dart';
import '../../core/router/router_manager.dart';
import '../../features/admin/presentation/controllers/admin_controller.dart';
import '../../features/admin/presentation/providers/admin_provider.dart';
import '../../features/auth/data/injection.dart';
import '../../features/auth/di/auth_injection.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/presentation/coordinators/auth_flow_coordinator.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/consultation/presentation/coordinators/consultation_flow_coordinator.dart';
import '../../features/consultation/presentation/providers/consultation_provider.dart';
import '../../features/forum/presentation/controllers/forum_controller.dart';
import '../../features/forum/presentation/providers/forum_provider.dart';
import '../../features/global_pages/presentation/controllers/common_controller.dart';
import '../../features/global_pages/presentation/providers/common_provider.dart';
import '../../features/merchant/presentation/controllers/merchant_controller.dart';
import '../../features/merchant/presentation/providers/merchant_provider.dart';
import '../../features/nutrition/di/nutrition_injection.dart';
import '../../features/nutrition/presentation/coordinators/nutrition_flow_coordinator.dart';
import '../../features/nutrition/presentation/providers/nutrition_profile_provider.dart';
import '../../features/nutritionist/presentation/controllers/nutritionist_controller.dart';
import '../../features/nutritionist/presentation/providers/nutritionist_provider.dart';
import '../../features/order/di/order_injection.dart';
import '../../features/order/presentation/coordinators/order_flow_coordinator.dart';
import '../../features/order/presentation/providers/order_provider.dart';
import '../../features/recommendation/di/recommendation_injection.dart';
import '../../features/recommendation/presentation/providers/recommendation_provider.dart';
import '../../features/user/di/user_injection.dart';
import '../../features/user/presentation/providers/user_profile_provider.dart';

/// Provider 索引
abstract class ProviderIndex {

  // ========== core ==========
  static const appRouterProvider = appRouterProvider;
  static const appThemeProvider = appThemeProvider;
  static const coordinatorManagerProvider = coordinatorManagerProvider;
  static const dioClientProvider = dioClientProvider;
  static const localeProvider = localeProvider;
  static const networkInfoProvider = networkInfoProvider;
  static const routerManagerProvider = routerManagerProvider;
  static const someBusinessLogicProvider = someBusinessLogicProvider;
  static const themeModeProvider = themeModeProvider;

  // ========== recommendation ==========
  static const getUrecommendationsUseCaseProvider = getUrecommendationsUseCaseProvider;
  static const recommendationFacadeProvider = recommendationFacadeProvider;
  static const recommendationProvider = recommendationProvider;
  static const recommendationRepositoryProvider = recommendationRepositoryProvider;

  // ========== order ==========
  static const getUordersUseCaseProvider = getUordersUseCaseProvider;
  static const orderFacadeProvider = orderFacadeProvider;
  static const orderFlowCoordinatorProvider = orderFlowCoordinatorProvider;
  static const orderProvider = orderProvider;
  static const orderRepositoryProvider = orderRepositoryProvider;

  // ========== auth ==========
  static const authApiServiceProvider = authApiServiceProvider;
  static const authFacadeProvider = authFacadeProvider;
  static const authFacadeProvider = authFacadeProvider;
  static const authFlowCoordinatorProvider = authFlowCoordinatorProvider;
  static const authStateProvider = authStateProvider;
  static const authStateProvider = authStateProvider;
  static const sharedPreferencesProvider = sharedPreferencesProvider;

  // ========== admin ==========
  static const adminProvider = adminProvider;
  static const adminProvider = adminProvider;
  static const adminRepositoryProvider = adminRepositoryProvider;
  static const adminRepositoryProvider = adminRepositoryProvider;
  static const getUadminsUseCaseProvider = getUadminsUseCaseProvider;

  // ========== consultation ==========
  static const consultationFlowCoordinatorProvider = consultationFlowCoordinatorProvider;
  static const consultationProvider = consultationProvider;
  static const consultationRepositoryProvider = consultationRepositoryProvider;
  static const getUconsultationsUseCaseProvider = getUconsultationsUseCaseProvider;

  // ========== user ==========
  static const userFacadeProvider = userFacadeProvider;
  static const userProfileProvider = userProfileProvider;
  static const userRepositoryProvider = userRepositoryProvider;

  // ========== forum ==========
  static const forumProvider = forumProvider;
  static const forumProvider = forumProvider;
  static const forumRepositoryProvider = forumRepositoryProvider;
  static const forumRepositoryProvider = forumRepositoryProvider;
  static const getUforumsUseCaseProvider = getUforumsUseCaseProvider;

  // ========== nutrition ==========
  static const authServiceProvider = authServiceProvider;
  static const nutritionApiProvider = nutritionApiProvider;
  static const nutritionFacadeProvider = nutritionFacadeProvider;
  static const nutritionFlowCoordinatorProvider = nutritionFlowCoordinatorProvider;
  static const nutritionProfileProvider = nutritionProfileProvider;

  // ========== merchant ==========
  static const getUmerchantsUseCaseProvider = getUmerchantsUseCaseProvider;
  static const merchantProvider = merchantProvider;
  static const merchantProvider = merchantProvider;
  static const merchantRepositoryProvider = merchantRepositoryProvider;
  static const merchantRepositoryProvider = merchantRepositoryProvider;

  // ========== nutritionist ==========
  static const getUnutritionistsUseCaseProvider = getUnutritionistsUseCaseProvider;
  static const nutritionistProvider = nutritionistProvider;
  static const nutritionistProvider = nutritionistProvider;
  static const nutritionistRepositoryProvider = nutritionistRepositoryProvider;
  static const nutritionistRepositoryProvider = nutritionistRepositoryProvider;

  // ========== global_pages ==========
  static const commonProvider = commonProvider;
  static const commonProvider = commonProvider;
  static const commonRepositoryProvider = commonRepositoryProvider;
  static const commonRepositoryProvider = commonRepositoryProvider;
  static const getUcommonsUseCaseProvider = getUcommonsUseCaseProvider;
}

/// Provider 统计信息
class ProviderStats {
  static const totalCount = 62;
  static const moduleCount = {
    'core': 9,
    'recommendation': 4,
    'order': 5,
    'auth': 7,
    'admin': 5,
    'consultation': 4,
    'user': 3,
    'forum': 5,
    'nutrition': 5,
    'merchant': 5,
    'nutritionist': 5,
    'global_pages': 5,
  };
}
