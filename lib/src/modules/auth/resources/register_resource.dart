import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/user_exists_exception.dart';
import '../../../core/services/logger/app_logger.dart';
import '../../../services/users/user_service.dart';
import '../view_models/user_save_input_model.dart';

class RegisterResource extends Resource {
  @override
  List<Route> get routes => [
        Route.post('/register', _registerHandler),
      ];

  Future<Response> _registerHandler(
    ModularArguments arguments,
    Injector injector,
  ) async {
    final service = injector<UserService>();
    final logger = injector<AppLogger>();

    try {
      final user = UserSaveInputModel.requestMapping(data: arguments.data);
      await service.createUser(user);

      return Response.ok(jsonEncode({'message': 'User created'}));
    } on UserExistsException catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.toJson());
    } catch (e, s) {
      logger.error('Error while registering user', e, s);

      return Response.internalServerError();
    }
  }
}
