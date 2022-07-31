import 'resources/user_resource.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../repositories/user/user_repository.dart';
import '../../repositories/user/user_repository_impl.dart';
import '../../services/users/user_service.dart';
import '../../services/users/user_service_impl.dart';

class UserModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton<UserRepository>(
      (i) => UserRepositoryImpl(
        logger: i(),
        database: i(),
        bcryptService: i(),
      ),
    ),
    Bind.singleton<UserService>(
      (i) => UserServiceImpl(
        logger: i(),
        userRepository: i(),
        jwtService: i(),
      ),
    ),
  ];

  @override
  final List<ModularRoute> routes = [
    Route.resource(UserResource()),
  ];
}
