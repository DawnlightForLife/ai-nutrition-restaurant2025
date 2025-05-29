/// 商家模块统一业务门面
/// 
/// 聚合商家相关的所有用例和业务逻辑
library;

import 'package:dartz/dartz.dart';
import '../../domain/entities/merchant.dart';
import '../../domain/usecases/get_merchants_usecase.dart';

/// 商家业务门面
class MerchantFacade {
  const MerchantFacade({
    required this.getMerchantsUseCase,
  });

  final GetMerchantsUseCase getMerchantsUseCase;

  /// 获取商家列表
  Future<Either<MerchantFailure, List<Merchant>>> getMerchants({
    String? category,
    double? latitude,
    double? longitude,
    double? radius,
    int? limit,
    int? offset,
  }) async {
    // TODO: 实现获取商家列表的业务逻辑
    throw UnimplementedError('getMerchants 待实现');
  }

  /// 获取商家详情
  Future<Either<MerchantFailure, MerchantDetail>> getMerchantDetail({
    required String merchantId,
  }) async {
    // TODO: 实现获取商家详情的业务逻辑
    throw UnimplementedError('getMerchantDetail 待实现');
  }

  /// 获取商家菜单
  Future<Either<MerchantFailure, List<MenuItem>>> getMerchantMenu({
    required String merchantId,
    String? category,
  }) async {
    // TODO: 实现获取商家菜单的业务逻辑
    throw UnimplementedError('getMerchantMenu 待实现');
  }

  /// 更新商家信息
  Future<Either<MerchantFailure, Merchant>> updateMerchantInfo({
    required String merchantId,
    required MerchantUpdateRequest request,
  }) async {
    // TODO: 实现更新商家信息的业务逻辑
    throw UnimplementedError('updateMerchantInfo 待实现');
  }

  /// 获取商家统计数据
  Future<Either<MerchantFailure, MerchantStats>> getMerchantStats({
    required String merchantId,
    required DateRange dateRange,
  }) async {
    // TODO: 实现获取商家统计数据的业务逻辑
    throw UnimplementedError('getMerchantStats 待实现');
  }

  /// 管理商家营业状态
  Future<Either<MerchantFailure, void>> updateBusinessStatus({
    required String merchantId,
    required BusinessStatus status,
  }) async {
    // TODO: 实现管理商家营业状态的业务逻辑
    throw UnimplementedError('updateBusinessStatus 待实现');
  }
}

/// 商家业务失败类型
abstract class MerchantFailure {}

/// 商家详情
abstract class MerchantDetail {}

/// 菜单项
abstract class MenuItem {}

/// 商家更新请求
abstract class MerchantUpdateRequest {}

/// 商家统计数据
abstract class MerchantStats {}

/// 日期范围
abstract class DateRange {}

/// 营业状态
enum BusinessStatus {
  open,
  closed,
  busy,
  holiday,
}