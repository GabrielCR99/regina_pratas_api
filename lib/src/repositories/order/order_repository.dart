import '../../modules/order/view_models/order_view_model.dart';

abstract class OrderRepository {
  Future<int> saveOrder(OrderViewModel order);
  Future<void> confirmPaymentByTransactionId(String transactionId);
  Future<void> updateTransactionId(int orderId, String transactionId);
}
