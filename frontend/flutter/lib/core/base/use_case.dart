import 'package:equatable/equatable.dart';
import 'package:ai_nutrition_restaurant/core/failures/failures.dart';

/// UseCase基类
/// 所有用例都应该实现这个接口
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

/// 无参数的UseCase
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}