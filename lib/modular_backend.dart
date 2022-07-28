import 'dart:io';

import 'src/app_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

Future<Handler> startShelfModular() async {
  return Modular(
    module: AppModule(),
    middlewares: [
      logRequests(),
      _jsonResponse(),
      _corsMiddleware(),
    ],
  );
}

Middleware _jsonResponse() => (handler) => (request) async {
      final response = await handler(request);

      return response.change(
        headers: {
          HttpHeaders.contentTypeHeader:
              ContentType('application', 'json', charset: 'utf-8').toString(),
          ...response.headers,
        },
      );
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

      return response.change(headers: {...headers, ...response.headers});
    };
