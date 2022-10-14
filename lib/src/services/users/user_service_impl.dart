import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../core/exceptions/service_exception.dart';
import '../../core/exceptions/user_not_found_exception.dart';
import '../../core/services/jwt/jwt_service.dart';
import '../../core/services/logger/app_logger.dart';
import '../../entities/user.dart';
import '../../modules/auth/view_models/refresh_token_view_model.dart';
import '../../modules/auth/view_models/update_url_avatar_view_model.dart';
import '../../modules/auth/view_models/user_confirm_input_model.dart';
import '../../modules/auth/view_models/user_refresh_token_input_model.dart';
import '../../modules/auth/view_models/user_save_input_model.dart';
import '../../modules/auth/view_models/user_update_device_token_input_model.dart';
import '../../repositories/user/user_repository.dart';
import 'user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _logger;
  final JwtService _jwtService;

  const UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger logger,
    required JwtService jwtService,
  })  : _userRepository = userRepository,
        _logger = logger,
        _jwtService = jwtService;

  @override
  Future<void> createUser(UserSaveInputModel user) async {
    final userEntity = User(
      name: user.name,
      email: user.email,
      phone: user.phone,
      document: user.document,
      password: user.password,
      registerType: 'App',
      about: '',
      userRole: user.role,
    );

    await _userRepository.createUser(userEntity);
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    required String role,
  }) =>
      _userRepository.login(email: email, password: password, role: role);

  @override
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
    required String name,
    String? imageAvatar,
  }) async {
    try {
      return await _userRepository.loginByEmailSocialKey(
        email: email,
        socialKey: socialKey,
        socialType: socialType,
      );
    } on UserNotFoundException catch (e) {
      _logger.error('User not found, creating one user', e);

      final user = User(
        name: name,
        email: email,
        imageAvatar: imageAvatar,
        registerType: socialType,
        socialKey: socialKey,
        password: DateTime.now().toString(),
        about: '',
        userRole: 'usuario',
      );

      return _userRepository.createUser(user);
    }
  }

  @override
  Future<User> findById(int id) => _userRepository.findById(id);

  @override
  Future<RefreshTokenViewModel> refreshToken(
    UserRefreshTokenInputModel inputModel,
  ) async {
    _validateRefreshToken(inputModel);

    final newAccessToken = _jwtService.generateToken(
      userId: inputModel.user,
      audience: inputModel.role!,
    );

    final newRefreshToken = _jwtService
        .generateRefreshToken(newAccessToken.replaceAll('Bearer ', ''));

    final user = User(
      id: inputModel.user,
      refreshToken: newRefreshToken,
    );

    await _userRepository.updateRefreshToken(user);

    return RefreshTokenViewModel(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
    );
  }

  void _validateRefreshToken(UserRefreshTokenInputModel inputModel) {
    try {
      final refreshToken = inputModel.refreshToken.split(' ');

      if (refreshToken.length != 2 || refreshToken.first != 'Bearer') {
        _logger.error('Invalid refresh token');
        throw const ServiceException(
          message: 'Invalid refresh token',
          statusCode: 403,
        );
      }

      _jwtService
          .getClaims(refreshToken.last)
          .validate(issuer: inputModel.accessToken, audience: inputModel.role);
    } on ServiceException {
      rethrow;
    } on JwtException catch (e, s) {
      _logger.error('Invalid refresh token', e);
      Error.throwWithStackTrace(
        ServiceException(message: e.message, statusCode: 403),
        s,
      );
    } catch (e, s) {
      Error.throwWithStackTrace(
        ServiceException(
          message: 'Error while validating refresh token ${e.toString()}',
          statusCode: 500,
        ),
        s,
      );
    }
  }

  @override
  Future<String> confirmLogin(UserConfirmInputModel inputModel) async {
    final refreshToken =
        _jwtService.generateRefreshToken(inputModel.accessToken);

    final user = User(
      id: inputModel.userId,
      refreshToken: refreshToken,
      iosToken: inputModel.iosDeviceToken,
      androidToken: inputModel.androidDeviceToken,
    );

    await _userRepository.updateUserDeviceTokenAndRefreshToken(user);

    return refreshToken;
  }

  @override
  Future<User> updateAvatar(UpdateUrlAvatarViewModel viewModel) async {
    await _userRepository.updateUrlAvatar(
      id: viewModel.userId,
      urlAvatar: viewModel.urlAvatar,
    );

    return findById(viewModel.userId);
  }

  @override
  Future<void> updateDeviceToken(UserUpdateDeviceTokenInputModel inputModel) =>
      _userRepository.updateDeviceToken(
        id: inputModel.userId,
        token: inputModel.token,
        platform: inputModel.platform,
      );
}
