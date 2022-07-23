import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

class RequestExtractor {
  String getBearerAuthorization(Request request) {
    final authorization = request.headers['authorization'] ?? '';
    if (authorization.isEmpty) {
      throw JWTInvalidError;
    }

    final parts = authorization.split(' ');

    if (parts.length != 2 || parts.first != 'Bearer') {
      throw JWTInvalidError;
    }

    return parts.last;
  }

  LoginCredential getBasicAuthorization(Request request) {
    var authorization = request.headers['authorization'] ?? '';

    if (authorization.isEmpty) {
      throw JWTInvalidError;
    }

    final parts = authorization.split(' ');

    if (parts.length != 2 || parts.first != 'Basic') {
      throw JWTInvalidError;
    }

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

  LoginCredential({required this.email, required this.password});
}
