import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// UseCase基类
/// 所有用例都应该实现这个接口
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 无参数的UseCase
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}