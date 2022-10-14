import 'package:shelf_modular/shelf_modular.dart';

import 'core/core_module.dart';
import 'core/guards/auth_guard.dart';
import 'modules/auth/auth_module.dart';
import 'modules/not_found/not_found_handler.dart';
import 'modules/order/order_module.dart';
import 'modules/product/product_module.dart';
import 'modules/swagger/swagger_handler.dart';
import 'modules/user/user_module.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  List<ModularRoute> get routes => [
        Route.get('/**', notFoundHandler),
        Route.post('/**', notFoundHandler),
        Route.put('/**', notFoundHandler),
        Route.delete('/**', notFoundHandler),
        Route.get('/docs/**', swaggerHandler),
        Route.module('/auth', module: AuthModule()),
        Route.module(
          '/user',
          module: UserModule(),
          middlewares: [const AuthGuard()],
        ),
        Route.module('/products', module: ProductModule()),
        Route.module('/order', module: OrderModule()),
      ];
}
