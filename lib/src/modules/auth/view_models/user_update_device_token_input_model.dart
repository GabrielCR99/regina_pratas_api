import 'package:equatable/equatable.dart';

import '../../../core/helpers/request_mapping.dart';
import 'platform.dart';

class UserUpdateDeviceTokenInputModel extends RequestMapping
    with EquatableMixin {
  int userId;
  late String token;
  late Platform platform;

  UserUpdateDeviceTokenInputModel({required this.userId, required super.data});

  @override
  void map() {
    token = data['token'];
    platform = data['platform'].toLowerCase() == 'ios'
        ? Platform.ios
        : Platform.android;
  }

  @override
  List<Object?> get props => [userId, token, platform];
}
