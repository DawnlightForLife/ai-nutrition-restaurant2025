import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/forum.dart';
import '../repositories/forum_repository.dart';

/// 获取Uforum列表用例
class GetUforumsUseCase implements UseCase<List<Uforum>, NoParams> {
  final UforumRepository repository;

  GetUforumsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Uforum>>> call(NoParams params) async {
    return await repository.getUforums();
  }
}
