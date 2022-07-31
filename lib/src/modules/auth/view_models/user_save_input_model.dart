import '../../../core/helpers/request_mapping.dart';

class UserSaveInputModel extends RequestMapping {
  late String name;
  late String email;
  late String phone;
  late String document;
  late String password;
  late String role;

  UserSaveInputModel.requestMapping({required super.data});

  @override
  void map() {
    name = data['name'];
    email = data['email'];
    phone = data['phone'];
    document = data['document'];
    password = data['password'];
    role = data['role'];
  }
}
