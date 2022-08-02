import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'src/app_module.dart';

Future<Handler> startShelfModular() async => Modular(
      module: AppModule(),
      middlewares: [
        logRequests(),
        _jsonResponse(),
        _corsMiddleware(),
      ],
    );

Middleware _jsonResponse() => (handler) => (request) async {
      var response = await handler(request);

      return response.change(headers: {'content-Type': 'application/json'});
    };

Middleware _corsMiddleware() => (handler) => (request) async {
      const headers = {
        HttpHeaders.accessControlAllowOriginHeader: '*',
        HttpHeaders.accessControlAllowMethodsHeader:
            'GET, POST, PATCH, PUT, DELETE, OPTIONS',
        HttpHeaders.accessControlAllowHeadersHeader:
            '${HttpHeaders.contentTypeHeader}, ${HttpHeaders.authorizationHeader}',
      };

      if (request.method == 'OPTIONS') {
        return Response(200, headers: headers);
      }
      final response = await handler(request);

      return response.change(headers: headers);
    };
