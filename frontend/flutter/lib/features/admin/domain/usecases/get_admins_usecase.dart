import '../../../../core/base/use_case.dart';
import '../entities/admin.dart';
import '../repositories/admin_repository.dart';

/// 获取Uadmin列表用例
class GetUadminsUseCase implements UseCase<List<Uadmin>, NoParams> {
  final UadminRepository repository;

  GetUadminsUseCase(this.repository);

  @override
  Future<List<Uadmin>> call(NoParams params) async {
    return await repository.getUadmins();
  }
}
