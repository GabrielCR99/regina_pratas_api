import 'package:jaguar_jwt/jaguar_jwt.dart';

abstract class JwtService {
  String generateToken({required int userId, required String audience});
  String generateRefreshToken(String accessToken);
  JwtClaim getClaims(String token);
  void validateToken({String? issuer, String? audience});
}
