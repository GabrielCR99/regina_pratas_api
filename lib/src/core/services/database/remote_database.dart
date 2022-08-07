import 'package:mysql1/mysql1.dart';

abstract class RemoteDatabase {
  Future<Results> query(
    String sql, {
    List<Object?> params = const [],
  });
  Future<T?> transaction<T>(
    Future<T> Function(TransactionContext) queryBlock, {
    Function(Object)? onError,
  });
  Future<List<Results>> queryMulti(
    String sql, {
    List<List<Object?>> params = const [],
  });
}
