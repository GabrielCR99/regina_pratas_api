abstract class BcryptService {
  String generateHash(String text);
  bool compareHash(String text, String hash);
}
