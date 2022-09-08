import 'package:shelf_modular/shelf_modular.dart';

import 'resources/order_resource.dart';

class OrderModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [Route.resource(OrderResource())];
}
