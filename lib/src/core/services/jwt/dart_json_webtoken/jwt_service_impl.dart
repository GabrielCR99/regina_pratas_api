import 'package:jaguar_jwt/jaguar_jwt.dart';

import '../../dotenv/dot_env_service.dart';
import '../jwt_service.dart';

class JwtServiceImpl implements JwtService {
  final DotEnvService _dotEnvService;

  JwtServiceImpl({required DotEnvService dotEnvService})
      : _dotEnvService = dotEnvService;

  @override
  String generateToken({required int userId, required String audience}) {
    final claimSet = JwtClaim(
      issuer: 'Regina Pratas',
      subject: userId.toString(),
      expiry: DateTime.now().add(const Duration(days: 1)),
      notBefore: DateTime.now(),
      issuedAt: DateTime.now(),
      audience: [audience],
      maxAge: const Duration(days: 1),
    );

    return 'Bearer ${issueJwtHS256(claimSet, _dotEnvService['JWT_SECRET']!)}';
  }

  @override
  String generateRefreshToken(String accessToken) {
    final expiry = int.parse(_dotEnvService['REFRESH_TOKEN_EXPIRY_DAYS']!);
    final notBefore =
        int.parse(_dotEnvService['REFRESH_TOKEN_NOT_BEFORE_HOURS']!);

    final claimSet = JwtClaim(
      issuer: accessToken,
      subject: 'RefreshToken',
      expiry: DateTime.now().add(Duration(days: expiry)),
      notBefore: DateTime.now().add(Duration(hours: notBefore)),
      issuedAt: DateTime.now(),
      otherClaims: const <String, dynamic>{},
    );

    return 'Bearer ${issueJwtHS256(claimSet, _dotEnvService['JWT_SECRET']!)}';
  }

  @override
  JwtClaim getClaims(String token) =>
      verifyJwtHS256Signature(token, _dotEnvService['JWT_SECRET']!);

  @override
  void validateToken({String? issuer, String? audience}) =>
      validateToken(issuer: issuer, audience: audience);
}
