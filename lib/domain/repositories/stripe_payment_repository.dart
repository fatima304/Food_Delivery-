import '../entities/payment_receipt.dart';

abstract class StripePaymentRepository {
  Future<PaymentReceipt> pay({required double total});
}
