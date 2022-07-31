import 'dart:convert';

class ServiceException {
  final String message;
  final int statusCode;

  const ServiceException({required this.message, required this.statusCode});

  String toJson() => jsonEncode({'message': message});
}
