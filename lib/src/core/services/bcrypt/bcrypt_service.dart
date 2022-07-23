abstract class BcryptService {
  String gerateHash(String text);
  bool compareHash(String text, String hash);
}
