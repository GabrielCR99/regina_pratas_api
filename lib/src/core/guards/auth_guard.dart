import 'dart:convert';
import 'dart:io';

import 'package:jaguar_jwt/jaguar_jwt.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../services/jwt/jwt_service.dart';
import '../services/request_extractor/request_extractor.dart';

class AuthGuard extends ModularMiddleware {
  final List<String> roles;
  final bool isRefreshToken;

  const AuthGuard({this.roles = const <String>[], this.isRefreshToken = false});

  @override
  Handler call(Handler handler, [ModularRoute? route]) {
    final extractor = Modular.get<RequestExtractor>();
    final jwt = Modular.get<JwtService>();

    return (request) async {
      try {
        if (!request.headers.containsKey(HttpHeaders.authorizationHeader)) {
          throw JwtException.invalidToken;
        }

        final token = extractor.getBearerAuthorization(request);

        final claims = jwt.getClaims(token);

        final claimsMap = claims.toJson();

        final userId = claimsMap['sub'];
        final role = claimsMap['aud'] as List<String>? ?? const ['usuario'];

        if (request.url.path != 'auth/refresh') {
          claims.validate(issuer: 'Regina Pratas', audience: role.first);
        }

        if (userId == null) {
          throw JwtException.invalidToken;
        }

        final securityHeaders = {
          'user': userId,
          'access_token': token,
          'role': role,
        };

        if (roles.contains(role.first) || roles.isEmpty) {
          return await handler(request.change(headers: securityHeaders));
        }

        return Response.forbidden(
          jsonEncode(
            {'message': 'Você não tem permissão para acessar este recurso'},
          ),
        );
      } on JwtException catch (e) {
        return Response.forbidden(jsonEncode({'message': e.message}));
      }
    };
  }
}
