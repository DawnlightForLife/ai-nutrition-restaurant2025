/// Recommendation 模块依赖注入
/// 
/// 管理 AI 推荐模块的所有依赖注入
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/injection_container.dart';
import '../data/datasources/recommendation_remote_datasource.dart';
import '../data/repositories/recommendation_repository_impl.dart';
import '../domain/repositories/recommendation_repository.dart';
import '../domain/usecases/get_recommendations_usecase.dart';
import '../application/facades/recommendation_facade.dart';

/// Recommendation 模块依赖注入容器
class RecommendationInjection {
  RecommendationInjection._();

  // ========== Data Sources ==========
  
  /// Recommendation 远程数据源
  static final recommendationRemoteDataSourceProvider = 
      createServiceProvider<RecommendationRemoteDataSource>((ref) {
    final dio = ref.watch(InjectionContainer.dioClientProvider);
    return RecommendationRemoteDataSourceImpl(dio);
  });

  // ========== Repositories ==========
  
  /// Recommendation 仓库
  static final recommendationRepositoryProvider = 
      createRepositoryProvider<RecommendationRepository>((ref) {
    return RecommendationRepositoryImpl(
      remoteDataSource: ref.watch(recommendationRemoteDataSourceProvider),
      networkInfo: ref.watch(InjectionContainer.networkInfoProvider),
    );
  });

  // ========== Use Cases ==========
  
  /// 获取推荐列表用例
  static final getRecommendationsUseCaseProvider = 
      createUseCaseProvider<GetRecommendationsUseCase>((ref) {
    return GetRecommendationsUseCase(
      repository: ref.watch(recommendationRepositoryProvider),
    );
  });

  // TODO: 添加其他推荐相关用例
  // static final generateRecommendationUseCaseProvider = ...
  // static final saveRecommendationUseCaseProvider = ...
  // static final submitFeedbackUseCaseProvider = ...

  // ========== Facades ==========
  
  /// Recommendation 业务门面
  static final recommendationFacadeProvider = Provider<RecommendationFacade>((ref) {
    return RecommendationFacade(
      getRecommendationsUseCase: ref.watch(getRecommendationsUseCaseProvider),
      // TODO: 添加其他用例依赖
    );
  });
}

// 占位实现（实际开发时替换）
abstract class RecommendationRemoteDataSource {}
class RecommendationRemoteDataSourceImpl implements RecommendationRemoteDataSource {
  RecommendationRemoteDataSourceImpl(DioClient dio);
}