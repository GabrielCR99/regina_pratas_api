import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import '../../dotenv/dot_env_service.dart';
import '../exceptions/database_exception.dart';
import '../remote_database.dart';

class MySqlDatabase implements RemoteDatabase {
  final DotEnvService _dotEnv;

  MySqlDatabase({required DotEnvService dotEnv}) : _dotEnv = dotEnv {
    _init();
  }

  Future<MySqlConnection> _init() async {
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

    return connection;
  }

  @override
  Future<Results> query(
    String query, {
    List<Object?> params = const [],
  }) async {
    MySqlConnection? connection;

    try {
      connection = await _init();

      return await connection.query(query, params);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    } finally {
      await connection?.close();
    }
  }

  @override
  Future<T?> transaction<T>(
    Future<T> Function(TransactionContext p1) queryBlock, {
    Function(Object p1)? onError,
  }) async {
    MySqlConnection? connection;

    try {
      connection = await _init();

      return await connection.transaction<T>(queryBlock, onError: onError);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    } finally {
      await connection?.close();
    }
  }

  @override
  Future<List<Results>> queryMulti(
    String sql, {
    List<List<Object?>> params = const [],
  }) async {
    MySqlConnection? connection;

    try {
      connection = await _init();

      return await connection.queryMulti(sql, params);
    } on MySqlException catch (e, s) {
      Error.throwWithStackTrace(
        DatabaseException(message: e.message, databaseErrorCode: e.errorNumber),
        s,
      );
    } finally {
      await connection?.close();
    }
  }
}
