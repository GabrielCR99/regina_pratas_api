import 'package:bcrypt/bcrypt.dart';

import './bcrypt_service.dart';

class BcryptServiceImpl implements BcryptService {
  @override
  String gerateHash(String text) => BCrypt.hashpw(text, BCrypt.gensalt());

  @override
  bool compareHash(String text, String hash) => BCrypt.checkpw(text, hash);
}
