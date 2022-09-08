import 'dart:convert';

class ServiceException implements Exception {
  final String message;
  final int statusCode;

  const ServiceException({required this.message, required this.statusCode});

  String toJson() => jsonEncode({'message': message});
}
