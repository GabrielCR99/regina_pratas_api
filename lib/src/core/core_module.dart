import 'package:shelf_modular/shelf_modular.dart';

import 'services/bcrypt/bcrypt_service.dart';
import 'services/bcrypt/bcrypt_service_impl.dart';
import 'services/database/mysql/my_sql_database.dart';
import 'services/database/remote_database.dart';
import 'services/dotenv/dot_env_service.dart';
import 'services/jwt/dart_json_webtoken/jwt_service_impl.dart';
import 'services/jwt/jwt_service.dart';
import 'services/logger/app_logger.dart';
import 'services/logger/app_logger_impl.dart';
import 'services/request_extractor/request_extractor.dart';

class CoreModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<AppLogger>((_) => AppLoggerImpl(), export: true),
        Bind.singleton((_) => DotEnvService(), export: true),
        Bind.singleton<BcryptService>((_) => BcryptServiceImpl(), export: true),
        Bind.singleton<JwtService>(
          (i) => JwtServiceImpl(dotEnvService: i<DotEnvService>()),
          export: true,
        ),
        Bind.singleton<RemoteDatabase>(
          (i) => MySqlDatabase(dotEnv: i<DotEnvService>()),
          export: true,
        ),
        Bind.singleton((_) => RequestExtractor(), export: true),
      ];
}
