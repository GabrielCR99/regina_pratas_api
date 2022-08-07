import 'dart:io';

import 'package:mysql1/mysql1.dart';

import '../../core/exceptions/failure.dart';
import '../../core/services/database/exceptions/database_exception.dart';
import '../../core/services/database/remote_database.dart';
import '../../core/services/logger/app_logger.dart';
import '../../entities/product.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDatabase _database;
  final AppLogger _logger;

  const ProductRepositoryImpl({
    required RemoteDatabase database,
    required AppLogger logger,
  })  : _database = database,
        _logger = logger;

  @override
  Future<List<Product>> findAll() async {
    try {
      final result = await _database.query('SELECT * FROM produto');

      return result
          .map(
            (p) => Product(
              id: p['id']?.toInt() ?? 0,
              name: p['nome'] ?? '',
              description: (p['descricao'] as Blob?)?.toString() ?? '',
              image: (p['imagem'] as Blob?)?.toString() ?? '',
              price: p['preco']?.toDouble() ?? 0.0,
              category: p['categoria_id']?.toInt() ?? 0,
            ),
          )
          .toList();
    } on DatabaseException catch (e, s) {
      _logger.error('Error while finding all products', e, s);

      throw const Failure(
        message: 'Error while finding all products',
        statusCode: HttpStatus.notFound,
      );
    }
  }

  @override
  Future<Product> findById(int id) async {
    try {
      final result = await _database.query(
        'SELECT * FROM produto WHERE id = ?',
        params: [id],
      );

      return result
          .map(
            (p) => Product(
              id: p['id']?.toInt() ?? 0,
              name: p['nome'] ?? '',
              description: (p['descricao'] as Blob?)?.toString() ?? '',
              image: (p['imagem'] as Blob?)?.toString() ?? '',
              price: p['preco']?.toDouble() ?? 0.0,
              category: p['categoria_id']?.toInt() ?? 0,
            ),
          )
          .first;
    } on DatabaseException catch (e, s) {
      _logger.error('Error while finding product with id $id', e, s);

      throw const Failure(
        message: 'Error while finding product by id',
        statusCode: HttpStatus.notFound,
      );
    }
  }
}
