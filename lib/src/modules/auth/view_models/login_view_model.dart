import '../../../core/exceptions/request_validate_exceptions.dart';
import '../../../core/helpers/request_mapping.dart';

class LoginViewModel extends RequestMapping {
  late String email;
  late bool socialLogin;
  late String role;
  String? password;
  String? avatar;
  String? socialType;
  String? socialKey;

  LoginViewModel({required super.data});

  @override
  void map() {
    email = data['email'];
    socialLogin = data['social_login'];
    role = data['role'];
    password = data['password'];
    avatar = data['avatar'];
    socialType = data['social_type'];
    socialKey = data['social_key'];
  }

  void loginEmailValidate() {
    final errors = <String, String>{};

    if (password == null) {
      errors['password'] = 'required';
    }

    if (errors.isNotEmpty) {
      Error.throwWithStackTrace(
        RequestValidationException(errors: errors),
        StackTrace.current,
      );
    }
  }

  void loginSocialValidate() {
    final errors = <String, String>{};

    if (socialType == null) {
      errors['social_type'] = 'required';
    }

    if (socialKey == null) {
      errors['social_key'] = 'required';
    }

    if (errors.isNotEmpty) {
      Error.throwWithStackTrace(
        RequestValidationException(errors: errors),
        StackTrace.current,
      );
    }
  }
}
