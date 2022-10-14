import '../../../core/helpers/request_mapping.dart';

class UpdateUrlAvatarViewModel extends RequestMapping {
  int userId;
  late String urlAvatar;

  UpdateUrlAvatarViewModel({required this.userId, required super.data});

  @override
  void map() {
    urlAvatar = data['url_avatar'];
  }
}
