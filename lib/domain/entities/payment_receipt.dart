class PaymentReceipt {
  const PaymentReceipt({required this.paymentIntentId, required this.status});
  final String paymentIntentId;
  final String status;
}
