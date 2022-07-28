import 'dart:convert';

class UserExistsException implements Exception {
  final int statusCode;
  final String message;

  const UserExistsException({
    required this.statusCode,
    required this.message,
  });

  String toJson() => jsonEncode({'message': message});
}
