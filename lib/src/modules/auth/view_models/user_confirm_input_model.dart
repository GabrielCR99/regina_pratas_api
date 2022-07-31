import '../../../core/exceptions/request_validate_exceptions.dart';
import '../../../core/helpers/request_mapping.dart';

class UserConfirmInputModel extends RequestMapping {
  int userId;
  String accessToken;
  String? iosDeviceToken;
  String? androidDeviceToken;

  UserConfirmInputModel({
    required this.userId,
    required this.accessToken,
    required super.data,
  });

  @override
  void map() {
    iosDeviceToken = data['ios_token'];
    androidDeviceToken = data['android_token'];
  }

  void validateRequest() {
    final errors = <String, String>{};

    if (iosDeviceToken == null && androidDeviceToken == null) {
      errors['device_token'] = 'required';
    }

    if (errors.isNotEmpty) {
      Error.throwWithStackTrace(
        RequestValidationException(errors: errors),
        StackTrace.current,
      );
    }
  }
}
