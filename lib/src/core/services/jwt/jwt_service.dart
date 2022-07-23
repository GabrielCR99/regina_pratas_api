abstract class JwtService {
  String generateToken(Map<String, dynamic> claims, String audience);
  void verifyToken(String token, String hmacKey);
  Map<String, dynamic> getPayload(String token);
}
