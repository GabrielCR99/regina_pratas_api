import 'dart:io';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/services/bcrypt/bcrypt_service.dart';
import '../../core/services/database/exceptions/database_exception.dart';
import '../../core/services/database/remote_database.dart';
import '../../core/services/logger/app_logger.dart';
import '../../entities/user.dart';
import '../../modules/auth/view_models/platform.dart';
import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDatabase _database;
  final AppLogger _logger;
  final BcryptService _bcryptService;

  const UserRepositoryImpl({
    required RemoteDatabase database,
    required AppLogger logger,
    required BcryptService bcryptService,
  })  : _database = database,
        _logger = logger,
        _bcryptService = bcryptService;

  @override
  Future<User> createUser(User user) async {
    try {
      const query =
          ''' 
      INSERT INTO usuario (nome, email, senha, celular, sobre, tipo_cadastro, funcao_usuario)
      VALUES (?, ?, ?, ?, ?, ?, ?) 
      ''';

      final result = await _database.query(
        query,
        params: [
          user.name,
          user.email,
          _bcryptService.generateHash(user.password ?? ''),
          user.phone,
          user.about,
          user.registerType,
          user.userRole,
        ],
      );

      return user.copyWith(id: result.insertId);
    } on DatabaseException catch (e, s) {
      const message = 'Usuário já existe';
      const failureMessage = 'Error while registering user';

      if (e.message.contains('usuario.email_UNIQUE')) {
        _logger.error(message, e, s);
        Error.throwWithStackTrace(
          const UserExistsException(
            message: message,
            statusCode: HttpStatus.badRequest,
          ),
          s,
        );
      }

      _logger.error(e.message, e, s);
      Error.throwWithStackTrace(
        const Failure(
          message: failureMessage,
          statusCode: HttpStatus.internalServerError,
        ),
        s,
      );
    }
  }

  @override
  Future<User> findById(int id) async {
    // TODO: implement findById
    throw UnimplementedError();
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    bool supplierUser = false,
  }) async {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
  }) async {
    // TODO: implement loginByEmailSocialKey
    throw UnimplementedError();
  }

  @override
  Future<void> updateDeviceToken({
    required int id,
    required String token,
    required Platform platform,
  }) async {
    // TODO: implement updateDeviceToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateRefreshToken(User user) async {
    // TODO: implement updateRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<void> updateUrlAvatar({
    required int id,
    required String urlAvatar,
  }) async {
    // TODO: implement updateUrlAvatar
    throw UnimplementedError();
  }

  @override
  Future<void> updateUserDeviceTokenAndRefreshToken(User user) async {
    // TODO: implement updateUserDeviceTokenAndRefreshToken
    throw UnimplementedError();
  }
}
