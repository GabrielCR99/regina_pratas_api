import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'core/core_module.dart';
import 'modules/auth/auth_module.dart';
import 'modules/swagger/swagger_handler.dart';
import 'modules/user/user_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.get(
          '/**',
          (request) => Response.notFound(
            jsonEncode({
              'timestamp': HttpDate.format(DateTime.now()),
              'status': HttpStatus.notFound,
              'message': 'Not found',
              'path': request.url.path,
            }),
          ),
        ),
        Route.get('/docs/**', swaggerHandler),
        Route.module('/auth', module: AuthModule()),
        Route.module('/user', module: UserModule()),
      ];
}
