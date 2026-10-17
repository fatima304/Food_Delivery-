part of 'stripe_payment_cubit.dart';

abstract class StripePaymentState {
  const StripePaymentState();
}

class StripePaymentInitial extends StripePaymentState {
  const StripePaymentInitial();
}

class StripePaymentLoading extends StripePaymentState {
  const StripePaymentLoading();
}

class StripePaymentSuccess extends StripePaymentState {
  const StripePaymentSuccess(this.receipt);
  final PaymentReceipt receipt;
}

class StripePaymentFailure extends StripePaymentState {
  const StripePaymentFailure(this.message);
  final String message;
}
