import '../../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> findAll();
  Future<Product> findById(int id);
}
