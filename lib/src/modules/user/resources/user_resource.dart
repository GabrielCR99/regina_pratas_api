import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/user_not_found_exception.dart';
import '../../../core/services/logger/app_logger.dart';
import '../../../services/users/user_service.dart';
import '../../auth/view_models/update_url_avatar_view_model.dart';
import '../../auth/view_models/user_update_device_token_input_model.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _findByIdHandler),
        Route.put('/avatar', _updateAvatarImageHandler),
        Route.put('/device', _updateDeviceTokenHandler),
      ];

  Future<Response> _findByIdHandler(Injector injector, Request request) async {
    final service = injector<UserService>();

    try {
      final user = int.parse(request.headers['user']!);
      final userData = await service.findById(user);

      return Response.ok(
        jsonEncode({
          'name': userData.name,
          'email': userData.email,
          'about': userData.about,
          'phone': userData.phone,
          'image_avatar': userData.imageAvatar,
        }),
      );
    } on UserNotFoundException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.toJson());
    }
  }

  Future<Response> _updateAvatarImageHandler(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final service = injector<UserService>();
    final log = injector<AppLogger>();

    try {
      final userId = int.parse(request.headers['user']!);
      final updateUrlAvatar =
          UpdateUrlAvatarViewModel(userId: userId, data: arguments.data);

      final user = await service.updateAvatar(updateUrlAvatar);

      return Response.ok(
        jsonEncode({
          'email': user.email,
          'register_type': user.registerType,
          'image_avatar': user.imageAvatar,
        }),
      );
    } on Failure catch (e) {
      log.error(e.message, e);

      return Response(e.statusCode, body: e.toJson());
    } on Exception catch (e, s) {
      log.error('Error updating avatar', e, s);

      return Response.internalServerError(
        body: jsonEncode({'message': 'Error updating avatar'}),
      );
    }
  }

  Future<Response> _updateDeviceTokenHandler(
    Injector injector,
    Request request,
    ModularArguments arguments,
  ) async {
    final service = injector<UserService>();
    final log = injector<AppLogger>();

    try {
      final userId = int.parse(request.headers['user']!);
      final updateDeviceToken =
          UserUpdateDeviceTokenInputModel(userId: userId, data: arguments.data);

      await service.updateDeviceToken(updateDeviceToken);

      return Response(200);
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } on Exception catch (e, s) {
      log.error('Error updating device token', e, s);

      return Response.internalServerError(
        body: jsonEncode({'message': 'Error updating device token'}),
      );
    }
  }
}
