import '../../../core/helpers/request_mapping.dart';

class UserRefreshTokenInputModel extends RequestMapping {
  int user;
  String? role;
  String accessToken;
  late String refreshToken;

  UserRefreshTokenInputModel({
    required this.user,
    required this.accessToken,
    required super.data,
    this.role,
  });

  @override
  void map() {
    refreshToken = data['refresh_token'];
  }
}
