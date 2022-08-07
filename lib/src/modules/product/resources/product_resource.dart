import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../core/exceptions/failure.dart';
import '../../../repositories/product/product_repository.dart';

class ProductResource extends Resource {
  @override
  List<Route> get routes => [
        Route.get('/', _findAllProductsHandler),
      ];

  Future<Response> _findAllProductsHandler(Injector injector) async {
    final productRepository = injector.get<ProductRepository>();

    try {
      final products = await productRepository.findAll();

      return Response.ok(
        jsonEncode(products.map((e) => e.toMap()).toList()),
        headers: {'content-type': 'application/json'},
      );
    } on Failure catch (e) {
      return Response(e.statusCode, body: e.message);
    }
  }
}
