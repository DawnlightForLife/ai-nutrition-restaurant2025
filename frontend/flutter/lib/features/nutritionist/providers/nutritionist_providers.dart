import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/dio_provider.dart';
import '../data/datasources/nutritionist_remote_datasource.dart';
import '../data/repositories/nutritionist_repository_impl.dart';
import '../domain/repositories/nutritionist_repository.dart';
import '../presentation/providers/nutritionist_list_provider.dart';

/// 营养师远程数据源提供者
final nutritionistRemoteDataSourceProvider = Provider<NutritionistRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return NutritionistRemoteDataSourceImpl(dio: dio);
});

/// 营养师仓储提供者
final nutritionistRepositoryProvider = Provider<NutritionistRepository>((ref) {
  final remoteDataSource = ref.watch(nutritionistRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  
  return NutritionistRepositoryImpl(
    remoteDataSource: remoteDataSource,
    networkInfo: networkInfo,
  );
});

/// 营养师列表Provider (重新定义以使用正确的依赖注入)
final nutritionistListProvider = StateNotifierProvider<NutritionistListNotifier, NutritionistListState>((ref) {
  final repository = ref.watch(nutritionistRepositoryProvider);
  return NutritionistListNotifier(repository);
});