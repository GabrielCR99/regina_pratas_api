import '../../entities/user.dart';
import '../../modules/auth/view_models/user_save_input_model.dart';

abstract class UserService {
  Future<User> createUser(UserSaveInputModel user);
  Future<User> login({
    required String email,
    required String password,
    bool supplierUser = false,
  });
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
    String? imageAvatar,
  });
/*   Future<String> confirmLogin(UserConfirmInputModel inputModel);
  Future<RefreshTokenViewModel> refreshToken(
    UserRefreshTokenInputModel inputModel,
  );
  Future<User> findById(int id);
  Future<User> updateAvatar(UpdateUrlAvatarViewModel viewModel);
  Future<void> updateDeviceToken(UserUpdateDeviceTokenInputModel inputModel); */
}
