/// Nutrition 模块依赖注入
/// 
/// 管理 Nutrition 模块的所有依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/datasources/nutrition_api.dart';
import '../data/repositories/nutrition_repository_impl.dart';
import '../domain/repositories/nutrition_repository.dart';
import '../domain/usecases/create_nutrition_profile_usecase.dart';
import '../domain/usecases/delete_nutrition_profile_usecase.dart';
import '../domain/usecases/get_nutrition_profiles_usecase.dart';
import '../domain/usecases/update_nutrition_profile_usecase.dart';
import '../application/facades/nutrition_facade.dart';

/// Nutrition 模块依赖注入容器
class NutritionInjection {
  NutritionInjection._();

  // ========== Data Sources ==========
  
  /// Nutrition API 数据源
  static final nutritionApiProvider = createServiceProvider<NutritionApi>((ref) {
    final dio = ref.watch(InjectionContainer.dioClientProvider);
    return NutritionApi(dio.dio);
  });

  // ========== Repositories ==========
  
  /// Nutrition 仓库
  static final nutritionRepositoryProvider = createRepositoryProvider<NutritionRepository>((ref) {
    return NutritionRepositoryImpl(
      remoteDataSource: ref.watch(nutritionApiProvider),
      networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
    );
  });

  // ========== Use Cases ==========
  
  /// 创建营养档案用例
  static final createNutritionProfileUseCaseProvider = 
      createUseCaseProvider<CreateNutritionProfileUseCase>((ref) {
    return CreateNutritionProfileUseCase(
      repository: ref.watch(nutritionRepositoryProvider),
    );
  });

  /// 获取营养档案列表用例
  static final getNutritionProfilesUseCaseProvider = 
      createUseCaseProvider<GetNutritionProfilesUseCase>((ref) {
    return GetNutritionProfilesUseCase(
      repository: ref.watch(nutritionRepositoryProvider),
    );
  });

  /// 更新营养档案用例
  static final updateNutritionProfileUseCaseProvider = 
      createUseCaseProvider<UpdateNutritionProfileUseCase>((ref) {
    return UpdateNutritionProfileUseCase(
      repository: ref.watch(nutritionRepositoryProvider),
    );
  });

  /// 删除营养档案用例
  static final deleteNutritionProfileUseCaseProvider = 
      createUseCaseProvider<DeleteNutritionProfileUseCase>((ref) {
    return DeleteNutritionProfileUseCase(
      repository: ref.watch(nutritionRepositoryProvider),
    );
  });

  // ========== Facades ==========
  
  /// Nutrition 业务门面
  static final nutritionFacadeProvider = Provider<NutritionFacade>((ref) {
    return NutritionFacade(
      createNutritionProfileUseCase: ref.watch(createNutritionProfileUseCaseProvider),
      getNutritionProfilesUseCase: ref.watch(getNutritionProfilesUseCaseProvider),
      updateNutritionProfileUseCase: ref.watch(updateNutritionProfileUseCaseProvider),
      deleteNutritionProfileUseCase: ref.watch(deleteNutritionProfileUseCaseProvider),
    );
  });
}