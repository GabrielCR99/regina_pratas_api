import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../../dotenv/dot_env_service.dart';
import '../jwt_service.dart';

class JwtServiceImpl implements JwtService {
  final DotEnvService _dotEnvService;

  JwtServiceImpl({required DotEnvService dotEnvService})
      : _dotEnvService = dotEnvService;

  @override
  String generateToken(Map<String, dynamic> claims, String audience) {
    final jwt = JWT(
      claims,
      issuer: 'reginaPratas',
      audience: Audience.one(audience),
    );

    return jwt.sign(SecretKey(_dotEnvService['JWT_SECRET']!));
  }

  @override
  Map<String, dynamic> getPayload(String token) {
    final jwt = JWT.verify(
      token,
      SecretKey(_dotEnvService['JWT_SECRET']!),
      checkExpiresIn: false,
      checkHeaderType: false,
      checkNotBefore: false,
    );

    return jwt.payload;
  }

  @override
  void verifyToken(String token, String audience) => JWT.verify(
        token,
        SecretKey(_dotEnvService['JWT_SECRET']!),
        audience: Audience.one(audience),
      );
}
