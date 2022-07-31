import 'package:mysql1/mysql1.dart';

abstract class RemoteDatabase {
  Future<Results> query(
    String sql, {
    List<Object?> params = const [],
  });
}
