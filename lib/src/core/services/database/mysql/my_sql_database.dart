import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../dotenv/dot_env_service.dart';
import '../exceptions/database_exception.dart';
import '../remote_database.dart';

class MySqlDatabase implements RemoteDatabase, Disposable {
  final DotEnvService _dotEnv;

  MySqlDatabase({required DotEnvService dotEnv}) : _dotEnv = dotEnv {
    _init();
  }

  final completer = Completer<MySqlConnection>();

  Future<void> _init() async {
    final url = _dotEnv['DATABASE_URL'] ?? '';
    final uri = Uri.parse(url);
    final uriUserInfo = uri.userInfo.split(':');
    final username = uriUserInfo.first;
    final password = uriUserInfo.last;

    final connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: uri.host,
        port: uri.port,
        user: username,
        password: password,
        db: uri.pathSegments.first,
      ),
    );

    // ! This delay is intended because the package has a bug with MySQL version 8.0 and above
    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    completer.complete(connection);
  }

  @override
  Future<Results> query(
    String query, {
    List<Object?> params = const [],
  }) async {
    try {
      final connection = await completer.future;

      return await connection.query(query, params);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    }
  }

  @override
  Future<void> dispose() async {
    final conn = await completer.future;
    await conn.close();
  }

  @override
  Future<T?> transaction<T>(
    Future<T> Function(TransactionContext p1) queryBlock, {
    Function(Object p1)? onError,
  }) async {
    try {
      final connection = await completer.future;

      return await connection.transaction<T>(queryBlock, onError: onError);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    }
  }

  @override
  Future<List<Results>> queryMulti(
    String sql, {
    List<List<Object?>> params = const [],
  }) async {
    try {
      final connection = await completer.future;

      return await connection.queryMulti(sql, params);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    }
  }
}
