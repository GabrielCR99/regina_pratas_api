import 'package:shelf_modular/shelf_modular.dart';

import '../../core/guards/auth_guard.dart';
import '../../repositories/product/product_repository.dart';
import '../../repositories/product/product_repository_impl.dart';
import 'resources/product_resource.dart';

class ProductModule extends Module {
  @override
  List<Bind<Object>> get binds => [
        Bind.singleton<ProductRepository>(
          (i) => ProductRepositoryImpl(database: i(), logger: i()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        Route.resource(ProductResource(), middlewares: [const AuthGuard()]),
      ];
}
