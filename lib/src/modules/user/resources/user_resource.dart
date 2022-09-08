import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/exceptions/failure.dart';
import '../../../core/exceptions/user_not_found_exception.dart';
import '../../../services/users/user_service.dart';

class UserResource extends Resource {
  @override
  List<Route> get routes => [Route.get('/', _findByIdHandler)];

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
}
