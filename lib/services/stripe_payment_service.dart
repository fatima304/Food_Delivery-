import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../data/models/payment_intent_input_model.dart';
import '../data/models/payment_intent_model.dart';
import '../domain/entities/payment_receipt.dart';

/// TEST MODE ONLY: the secret key in an APK can be extracted.
/// Replace direct Stripe API calls with a trusted server before real payments.
class StripePaymentService {
  StripePaymentService({required this.secretKey, Dio? dio})
    : _dio = dio ?? Dio();
  final String secretKey;
  final Dio _dio;

  void _checkTestKey() {
    if (!secretKey.startsWith('sk_test_')) {
      throw StateError('Only a Stripe test secret key is allowed.');
    }
  }

  Future<PaymentIntentModel> createPaymentIntent({
    required PaymentIntentInputModel input,
  }) async {
    _checkTestKey();
    final response = await _dio.post<Map<String, dynamic>>(
      'https://api.stripe.com/v1/payment_intents',
      data: {
        ...input.toJson().map((key, value) => MapEntry(key, value.toString())),
        'automatic_payment_methods[enabled]': 'true',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {'Authorization': 'Bearer $secretKey'},
      ),
    );
    final data = response.data;
    if (data == null || data['id'] == null || data['client_secret'] == null) {
      throw StateError('Invalid Stripe PaymentIntent response.');
    }
    return PaymentIntentModel.fromJson(data);
  }

  Future<void> presentPaymentSheet({required String clientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        merchantDisplayName: 'StreetBite',
        paymentIntentClientSecret: clientSecret,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  Future<String> getPaymentStatus(String intentId) async {
    _checkTestKey();
    final response = await _dio.get<Map<String, dynamic>>(
      'https://api.stripe.com/v1/payment_intents/$intentId',
      options: Options(headers: {'Authorization': 'Bearer $secretKey'}),
    );
    final status = response.data?['status'];
    if (status is! String) throw StateError('Missing payment status.');
    return status;
  }

  Future<PaymentReceipt> pay({required PaymentIntentInputModel input}) async {
    final intent = await createPaymentIntent(input: input);
    await presentPaymentSheet(clientSecret: intent.clientSecret);
    final status = await getPaymentStatus(intent.id);
    if (status != 'succeeded') {
      throw StateError('Payment not confirmed (status: $status).');
    }
    return PaymentReceipt(paymentIntentId: intent.id, status: status);
  }
}
