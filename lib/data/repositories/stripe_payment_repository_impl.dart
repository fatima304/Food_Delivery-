import '../../domain/entities/payment_receipt.dart';
import '../../domain/repositories/stripe_payment_repository.dart';
import '../../services/stripe_payment_service.dart';
import '../models/payment_intent_input_model.dart';

class StripePaymentRepositoryImpl implements StripePaymentRepository {
  const StripePaymentRepositoryImpl(this._service);
  final StripePaymentService _service;

  @override
  Future<PaymentReceipt> pay({required double total}) async {
    if (!total.isFinite || total < 0.50) {
      throw ArgumentError('The total must be at least \$0.50.');
    }
    return _service.pay(
      input: PaymentIntentInputModel(
        amount: (total * 100).round(),
        currency: 'usd',
      ),
    );
  }
}
