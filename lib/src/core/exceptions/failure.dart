import 'dart:convert';

class Failure implements Exception {
  final String message;
  final int statusCode;

  const Failure({required this.message, required this.statusCode});

  String toJson() => jsonEncode({'message': message});
}
