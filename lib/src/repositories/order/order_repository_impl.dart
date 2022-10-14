import 'dart:io';

import '../../core/exceptions/failure.dart';
import '../../core/services/database/exceptions/database_exception.dart';
import '../../core/services/database/remote_database.dart';
import '../../core/services/logger/app_logger.dart';
import '../../modules/order/view_models/order_view_model.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final RemoteDatabase _database;
  final AppLogger _logger;

  const OrderRepositoryImpl({
    required RemoteDatabase database,
    required AppLogger logger,
  })  : _database = database,
        _logger = logger;

  @override
  Future<void> confirmPaymentByTransactionId(String transactionId) async {
    try {
      await _database.query(
        '''UPDATE pedido SET status_pedido = ? WHERE id_transacao = ?''',
        params: ['F', transactionId],
      );
    } on DatabaseException catch (e, s) {
      _logger.error('Error confirming payment by transaction id', e, s);

      Error.throwWithStackTrace(
        const Failure(message: '', statusCode: HttpStatus.badRequest),
        s,
      );
    }
  }

  @override
  Future<int> saveOrder(OrderViewModel order) async {
    try {
      var orderIdResponse = 0;

      await _database.transaction((_) async {
        final result = await _database.query(
          ''' INSERT INTO pedido(usuario_id, cpf_cliente, endereco_entrega, status_pedido) 
          VALUES (?, ?, ?, ?) ''',
        );
        final orderId = result.insertId;
        await _database.queryMulti(
          '''INSERT INTO pedido_item (quantidade, pedido_id, produto_id)
        VALUES (?, ?, ?) ''',
          params: order.items
              .map((item) => [item.amount, orderId, item.productId])
              .toList(),
        );
        if (orderId != null) {
          orderIdResponse = orderId;
        }
      });

      return orderIdResponse;
    } on DatabaseException catch (e, s) {
      _logger.error('Error saving order', e, s);

      Error.throwWithStackTrace(
        const Failure(
          message: 'Error saving order',
          statusCode: HttpStatus.badRequest,
        ),
        s,
      );
    }
  }

  @override
  Future<void> updateTransactionId(int orderId, String transactionId) async {
    try {
      await _database.query(
        '''UPDATE pedido SET id_transacao = ? WHERE id = ? ''',
        params: [transactionId, orderId],
      );
    } on DatabaseException catch (e, s) {
      Error.throwWithStackTrace(
        const Failure(
          message: 'Could not update transaction id',
          statusCode: HttpStatus.badRequest,
        ),
        s,
      );
    }
  }
}
