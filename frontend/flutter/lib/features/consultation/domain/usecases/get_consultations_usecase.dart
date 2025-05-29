import 'package:dartz/dartz.dart';
import '../../../../core/base/use_case.dart';
import '../../../../core/error/failures.dart';
import '../entities/consultation.dart';
import '../repositories/consultation_repository.dart';

/// 获取Uconsultation列表用例
class GetUconsultationsUseCase implements UseCase<List<Uconsultation>, NoParams> {
  final UconsultationRepository repository;

  GetUconsultationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Uconsultation>>> call(NoParams params) async {
    return await repository.getUconsultations();
  }
}
