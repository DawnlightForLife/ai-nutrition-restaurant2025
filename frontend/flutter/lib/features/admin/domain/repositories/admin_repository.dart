import '../entities/admin.dart';

/// Uadmin 仓储接口
abstract class UadminRepository {
  Future<List<Uadmin>> getUadmins();
  Future<Uadmin?> getUadmin(String id);
  Future<Uadmin> createUadmin(Uadmin admin);
  Future<Uadmin> updateUadmin(Uadmin admin);
  Future<void> deleteUadmin(String id);
}
