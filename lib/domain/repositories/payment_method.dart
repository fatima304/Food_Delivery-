/// Payment-method selection; card processing is handled by StripePaymentCubit.
abstract class PaymentMethod {
  const PaymentMethod();
  String get id;
  Future<void> process(double total);
}

class CashPayment implements PaymentMethod {
  const CashPayment();
  @override
  String get id => 'cash';
  @override
  Future<void> process(double total) async {}
}

class CardPayment implements PaymentMethod {
  const CardPayment();
  @override
  String get id => 'card';
  @override
  Future<void> process(double total) async {}
}
