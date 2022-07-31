import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/request_validate_exceptions.dart';
import '../../../core/exceptions/service_exception.dart';
import '../../../core/exceptions/user_not_found_exception.dart';
import '../../../core/guards/auth_guard.dart';
import '../../../core/services/jwt/jwt_service.dart';
import '../../../core/services/logger/app_logger.dart';
import '../../../entities/user.dart';
import '../../../services/users/user_service.dart';
import '../view_models/login_view_model.dart';
import '../view_models/user_confirm_input_model.dart';
import '../view_models/user_refresh_token_input_model.dart';

class AuthResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/', _loginHandler),
        Route.put('/refresh', _refreshTokenHandler, middlewares: [AuthGuard()]),
        Route.path(
          '/confirm',
          _confirmLoginHandler,
          middlewares: [AuthGuard()],
        ),
      ];

  Future<Response> _loginHandler(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final service = injector<UserService>();
    final jwtService = injector<JwtService>();
    final log = injector<AppLogger>();

    try {
      final loginViewModel = LoginViewModel(data: arguments.data);

      User user;

      if (!loginViewModel.socialLogin) {
        loginViewModel.loginEmailValidate();
        user = await service.login(
          email: loginViewModel.email,
          password: loginViewModel.password!,
          role: loginViewModel.role,
        );
      } else {
        loginViewModel.loginSocialValidate();
        user = await service.loginByEmailSocialKey(
          email: loginViewModel.email,
          imageAvatar: loginViewModel.avatar,
          socialKey: loginViewModel.socialKey!,
          socialType: loginViewModel.socialType!,
        );
      }

      return Response.ok(
        jsonEncode({
          'access_token': jwtService.generateToken(
            userId: user.id!,
            audience: user.userRole!,
          ),
        }),
      );
    } on UserNotFoundException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } on RequestValidationException catch (e, s) {
      log.error('Required parameters not sent', e, s);

      return Response.badRequest(body: jsonEncode(e.errors));
    } on Failure catch (e, s) {
      log.error('Error while trying to login', e, s);

      return Response(e.statusCode, body: e.toJson());
    }
  }

  Future<Response> _refreshTokenHandler(
    ModularArguments arguments,
    Request request,
    Injector injector,
  ) async {
    try {
      final user = int.parse(request.headers['user']!);
      final role = request.headers['role']!;
      final accessToken = request.headers['access_token']!;

      final inputModel = UserRefreshTokenInputModel(
        user: user,
        role: role,
        accessToken: accessToken,
        data: arguments.data,
      );

      final userToken = await injector<UserService>().refreshToken(inputModel);

      return Response.ok(
        jsonEncode({
          'access_token': userToken.accessToken,
          'refresh_token': userToken.refreshToken,
        }),
      );
    } on ServiceException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  Future<Response> _confirmLoginHandler(
    ModularArguments arguments,
    Injector injector,
    Request request,
  ) async {
    try {
      final user = int.parse(request.headers['user']!);
      final audience = request.headers['role']!;
      final token = injector<JwtService>()
          .generateToken(userId: user, audience: audience)
          .replaceAll('Bearer ', '');

      final inputModel = UserConfirmInputModel(
        userId: user,
        accessToken: token,
        data: arguments.data,
      )..validateRequest();

      final newAccessToken =
          await injector<UserService>().confirmLogin(inputModel);

      return Response.ok(
        jsonEncode(
          {'access_token': 'Bearer $token', 'refresh_token': newAccessToken},
        ),
      );
    } on RequestValidationException catch (e) {
      return Response.badRequest(body: jsonEncode(e.errors));
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }
}
