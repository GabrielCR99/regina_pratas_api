import 'dart:async';
import 'dart:io';

import 'package:mysql1/mysql1.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../dotenv/dot_env_service.dart';
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

    var connection = await MySqlConnection.connect(
      ConnectionSettings(
        host: uri.host,
        db: uri.pathSegments.first,
        port: uri.port,
        password: password,
        user: username,
      ),
    );

    if (Platform.isWindows) {
      await Future.delayed(const Duration(milliseconds: 10));
    }

    completer.complete(connection);
  }

  @override
  Future<Results> query(
    String sql, {
    List<Object?> params = const [],
  }) async {
    final connection = await completer.future;

    return await connection.query(sql, params);
  }

  @override
  Future<void> dispose() async {
    final connection = await completer.future;
    connection.close();
  }
}
