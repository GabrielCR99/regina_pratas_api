import '../../entities/user.dart';
import '../../modules/auth/view_models/platform.dart';

abstract class UserRepository {
  Future<User> createUser(User user);
  Future<User> login({
    required String email,
    required String password,
    required String role,
  });
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
  });
  Future<void> updateUserDeviceTokenAndRefreshToken(User user);
  Future<void> updateRefreshToken(User user);
  Future<User> findById(int id);
  Future<void> updateUrlAvatar({required int id, required String urlAvatar});
  Future<void> updateDeviceToken({
    required int id,
    required String token,
    required Platform platform,
  });
}
