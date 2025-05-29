/// 营养师模块统一业务门面
/// 
/// 聚合营养师相关的所有用例和业务逻辑
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/nutritionist.dart';
import '../../domain/usecases/get_nutritionists_usecase.dart';

/// 营养师业务门面
class NutritionistFacade {
  const NutritionistFacade({
    required this.getNutritionistsUseCase,
  });

  final GetNutritionistsUseCase getNutritionistsUseCase;

  /// 获取营养师列表
  Future<Either<NutritionistFailure, List<Nutritionist>>> getNutritionists({
    String? specialty,
    double? minRating,
    bool? isOnline,
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取营养师列表的业务逻辑
    throw UnimplementedError('getNutritionists 待实现');
  }

  /// 获取营养师详情
  Future<Either<NutritionistFailure, NutritionistDetail>> getNutritionistDetail({
    required String nutritionistId,
  }) async {
    // TODO: 实现获取营养师详情的业务逻辑
    throw UnimplementedError('getNutritionistDetail 待实现');
  }

  /// 获取营养师排班
  Future<Either<NutritionistFailure, List<Schedule>>> getNutritionistSchedule({
    required String nutritionistId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // TODO: 实现获取营养师排班的业务逻辑
    throw UnimplementedError('getNutritionistSchedule 待实现');
  }

  /// 更新营养师状态
  Future<Either<NutritionistFailure, void>> updateOnlineStatus({
    required String nutritionistId,
    required bool isOnline,
  }) async {
    // TODO: 实现更新营养师状态的业务逻辑
    throw UnimplementedError('updateOnlineStatus 待实现');
  }

  /// 获取营养师评价
  Future<Either<NutritionistFailure, List<Review>>> getNutritionistReviews({
    required String nutritionistId,
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取营养师评价的业务逻辑
    throw UnimplementedError('getNutritionistReviews 待实现');
  }

  /// 获取营养师统计数据
  Future<Either<NutritionistFailure, NutritionistStats>> getNutritionistStats({
    required String nutritionistId,
    required StatsPeriod period,
  }) async {
    // TODO: 实现获取营养师统计数据的业务逻辑
    throw UnimplementedError('getNutritionistStats 待实现');
  }
}

/// 营养师业务失败类型
abstract class NutritionistFailure {}

/// 营养师详情
abstract class NutritionistDetail {}

/// 排班信息
abstract class Schedule {}

/// 评价信息
abstract class Review {}

/// 营养师统计数据
abstract class NutritionistStats {}

/// 统计周期
enum StatsPeriod {
  daily,
  weekly,
  monthly,
  yearly,
}