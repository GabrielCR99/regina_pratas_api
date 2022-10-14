import '../../entities/user.dart';
import '../../modules/auth/view_models/refresh_token_view_model.dart';
import '../../modules/auth/view_models/update_url_avatar_view_model.dart';
import '../../modules/auth/view_models/user_confirm_input_model.dart';
import '../../modules/auth/view_models/user_refresh_token_input_model.dart';
import '../../modules/auth/view_models/user_save_input_model.dart';
import '../../modules/auth/view_models/user_update_device_token_input_model.dart';

abstract class UserService {
  Future<void> createUser(UserSaveInputModel user);
  Future<User> login({
    required String email,
    required String password,
    required String role,
  });
  Future<User> loginByEmailSocialKey({
    required String email,
    required String socialKey,
    required String socialType,
    required String name,
    String? imageAvatar,
  });
  Future<User> findById(int id);
  Future<RefreshTokenViewModel> refreshToken(
    UserRefreshTokenInputModel inputModel,
  );
  Future<String> confirmLogin(UserConfirmInputModel inputModel);

  Future<User> updateAvatar(UpdateUrlAvatarViewModel viewModel);
  Future<void> updateDeviceToken(UserUpdateDeviceTokenInputModel inputModel);
}
