import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';

class RequestExtractor {
  String getBearerAuthorization(Request request) {
    final authorization =
        request.headers[HttpHeaders.authorizationHeader] ?? '';

    final parts = authorization.split(' ');

    return parts.last;
  }

  LoginCredential getBasicAuthorization(Request request) {
    var authorization = request.headers['authorization'] ?? '';

    final parts = authorization.split(' ');

    authorization = String.fromCharCodes(base64Decode(parts.last));
    final credentials = authorization.split(':');

    return LoginCredential(
      email: credentials.first,
      password: credentials.last,
    );
  }
}

class LoginCredential {
  final String email;
  final String password;

  const LoginCredential({required this.email, required this.password});
}
