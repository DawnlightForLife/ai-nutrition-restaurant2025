import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../domain/common/failures/failure.dart';

/// 用例基类
/// 
/// 所有用例都应该继承此类或其变体
/// Type: 返回类型
/// Params: 参数类型
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// 无参数用例基类
abstract class NoParamsUseCase<Type> {
  Future<Either<Failure, Type>> call();
}

/// 流式用例基类
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// 无参数流式用例基类
abstract class NoParamsStreamUseCase<Type> {
  Stream<Either<Failure, Type>> call();
}

/// 空参数
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}