import '../../core/services/logger/app_logger.dart';
import '../../entities/user.dart';
import '../../modules/auth/view_models/user_save_input_model.dart';
import '../../repositories/user/user_repository.dart';
import 'user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _logger;

  const UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger logger,
  })  : _userRepository = userRepository,
        _logger = logger;

  @override
  Future<User> createUser(UserSaveInputModel user) {
    final userEntity = User(
      name: user.name,
      email: user.email,
      password: user.password,
      registerType: 'App',
      about: '',
      userRole: user.role,
    );

    return _userRepository.createUser(userEntity);
  }

  @override
  Future<User> login({
    required String email,
    required String password,
    bool supplierUser = false,
  }) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
    String? imageAvatar,
  }) {
    // TODO: implement loginByEmailSocialKey
    throw UnimplementedError();
  }
}
