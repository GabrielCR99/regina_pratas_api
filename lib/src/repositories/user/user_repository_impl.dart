import 'dart:io';

import 'package:mysql1/mysql1.dart';

import '../../core/exceptions/failure.dart';
import '../../core/exceptions/user_exists_exception.dart';
import '../../core/exceptions/user_not_found_exception.dart';
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
    const query = ''' 
      INSERT INTO usuario (nome, email, senha, celular, sobre, tipo_cadastro, funcao_usuario)
      VALUES (?, ?, ?, ?, ?, ?, ?) 
      ''';
    try {
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
      const message = 'User already exists';
      const failureMessage = 'Error while registering user';

      if (e.message.contains('usuario.unique_index')) {
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
    try {
      final result = await _database.query(
        ''' 
        SELECT id, nome, email, celular, sobre, tipo_cadastro 
        FROM usuario 
        WHERE id = ?''',
        params: [id],
      );

      if (result.isEmpty) {
        _logger.error('User not found with id $id');
        throw UserNotFoundException(
          statusCode: HttpStatus.notFound,
          message: 'User not found with id $id',
        );
      } else {
        final mySqlData = result.first;

        return User(
          name: mySqlData['nome'],
          email: mySqlData['email'],
          about: mySqlData['sobre'],
          phone: mySqlData['celular'],
          registerType: mySqlData['tipo_cadastro'],
          imageAvatar: (mySqlData['img_avatar'] as Blob?)?.toString(),
        );
      }
    } on DatabaseException catch (e, s) {
      _logger.error(e.message, e, s);
      Error.throwWithStackTrace(
        const Failure(
          message: 'Error while finding user',
          statusCode: HttpStatus.internalServerError,
        ),
        s,
      );
    }
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    required String role,
  }) async {
    const query = ''' 
      SELECT * FROM usuario WHERE email = ?
      ''';

    const notFoundException = UserNotFoundException(
      message: 'Invalid user or password',
      statusCode: HttpStatus.notFound,
    );
    try {
      final result = await _database.query(query, params: [email.trim()]);

      final passwordEquals =
          _bcryptService.compareHash(password, result.first['senha']);

      if (result.isEmpty || !passwordEquals) {
        _logger.error('Invalid user or password');
        throw notFoundException;
      } else {
        final mySqlData = result.first;

        return User(
          id: mySqlData['id'] as int,
          name: mySqlData['nome'] as String,
          email: mySqlData['email'],
          phone: mySqlData['celular'],
          userRole: mySqlData['funcao_usuario'] as String,
          about: mySqlData['sobre'] as String,
          registerType: mySqlData['tipo_cadastro'],
          iosToken: (mySqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (mySqlData['android_token'] as Blob?)?.toString(),
          refreshToken: (mySqlData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (mySqlData['img_avatar'] as Blob?)?.toString(),
        );
      }
    } on DatabaseException catch (e, s) {
      _logger.error('Error while trying to login', e, s);
      Error.throwWithStackTrace(
        Failure(message: e.message, statusCode: HttpStatus.internalServerError),
        s,
      );
    }
  }

  @override
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
  }) async {
    try {
      final result = await _database.query(
        ''' 
        SELECT * FROM usuario WHERE email = ?
        ''',
        params: [email],
      );

      if (result.isEmpty) {
        throw const UserNotFoundException(
          message: 'Usuário não encontrado',
          statusCode: HttpStatus.notFound,
        );
      } else {
        final mySqlData = result.first;

        if (mySqlData['social_id'] == null ||
            mySqlData['social_id'] != socialKey) {
          await _database.query(
            ''' 
            UPDATE usuario 
            SET social_id = ?, tipo_cadastro = ? 
            WHERE id = ? 
            ''',
            params: [socialKey, socialType, mySqlData['id']],
          );
        }

        return User(
          id: mySqlData['id'] as int,
          email: mySqlData['email'],
          registerType: mySqlData['tipo_cadastro'],
          iosToken: (mySqlData['ios_token'] as Blob?)?.toString(),
          androidToken: (mySqlData['android_token'] as Blob?)?.toString(),
          refreshToken: (mySqlData['refresh_token'] as Blob?)?.toString(),
          imageAvatar: (mySqlData['img_avatar'] as Blob?)?.toString(),
          about: mySqlData['sobre'],
          phone: (mySqlData['celular'] as Blob?).toString(),
          userRole: mySqlData['funcao_usuario'] ?? 'usuario',
          name: mySqlData['nome'],
          document: mySqlData['documento'],
        );
      }
    } on DatabaseException catch (e, s) {
      _logger.error('Error logging in with social key', e, s);
      Error.throwWithStackTrace(
        Failure(message: e.message, statusCode: HttpStatus.internalServerError),
        s,
      );
    }
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
    try {
      await _database.query(
        ''' 
        UPDATE usuario 
        SET refresh_token = ? 
        WHERE id = ?''',
        params: [user.refreshToken, user.id],
      );
    } on DatabaseException catch (e, s) {
      _logger.error(e.message, e, s);

      Error.throwWithStackTrace(
        Failure(
          message: e.message,
          statusCode: HttpStatus.internalServerError,
        ),
        s,
      );
    }
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
    try {
      final setParams = <String, dynamic>{};

      if (user.iosToken != null) {
        setParams.putIfAbsent('ios_token', () => user.iosToken);
      } else {
        setParams.putIfAbsent('android_token', () => user.androidToken);
      }

      final query = ''' 
      UPDATE usuario
      SET ${setParams.keys.first} = ?, refresh_token = ?
      WHERE id = ?
      ''';

      await _database.query(
        query,
        params: [setParams.values.first, user.refreshToken, user.id],
      );
    } on DatabaseException catch (e, s) {
      _logger.error('Error while confirming login!', e, s);
      Error.throwWithStackTrace(
        const Failure(
          message: 'Error while confirming login!',
          statusCode: HttpStatus.internalServerError,
        ),
        s,
      );
    }
  }
}
