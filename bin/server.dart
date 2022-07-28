import 'dart:io';

import 'package:regina_pratas_api/modular_backend.dart';
import 'package:regina_pratas_api/src/core/services/logger/app_logger_impl.dart';
import 'package:shelf/shelf_io.dart';

Future<void> main() async {
  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler = await startShelfModular();

  final server = await serve(handler, ip, port);

  AppLoggerImpl().info('Serving at ws://${server.address.host}:${server.port}');
}
