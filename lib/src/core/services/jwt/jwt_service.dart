abstract class JwtService {
  String generateToken({required int userId, required String audience});
  String generateRefreshToken(String accessToken);
  dynamic verifyToken(String token);
}
