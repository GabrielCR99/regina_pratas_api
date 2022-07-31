import 'dart:convert';

class UserNotFoundException implements Exception {
  final String message;
  final int statusCode;

  const UserNotFoundException({
    required this.message,
    required this.statusCode,
  });

  String toJson() => jsonEncode({'message': message});
}
