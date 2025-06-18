import '../entities/order.dart';

/// Uorder 仓储接口
abstract class UorderRepository {
  Future<List<Uorder>> getUorders();
  Future<Uorder?> getUorder(String id);
  Future<Uorder> createUorder(Uorder order);
  Future<Uorder> updateUorder(Uorder order);
  Future<void> deleteUorder(String id);
}
