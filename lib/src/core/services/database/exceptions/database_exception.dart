import 'dart:convert';

class DatabaseException implements Exception {
  final String message;
  final int databaseErrorCode;

  DatabaseException({required this.message, required this.databaseErrorCode});

  String toJson() => jsonEncode({
        'message': message,
        'database_error_code': databaseErrorCode,
      });
}
