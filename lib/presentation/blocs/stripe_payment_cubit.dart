import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/payment_receipt.dart';
import '../../domain/repositories/stripe_payment_repository.dart';

part 'stripe_payment_state.dart';

class StripePaymentCubit extends Cubit<StripePaymentState> {
  StripePaymentCubit(this._repository) : super(const StripePaymentInitial());
  final StripePaymentRepository _repository;

  Future<PaymentReceipt?> makePayment({required double total}) async {
    if (state is StripePaymentLoading) return null;
    emit(const StripePaymentLoading());
    try {
      final receipt = await _repository.pay(total: total);
      emit(StripePaymentSuccess(receipt));
      return receipt;
    } catch (error) {
      emit(StripePaymentFailure(_messageFor(error)));
      return null;
    }
  }

  String _messageFor(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('cancel')) {
      return 'paymentCancelled';
    }
    return 'paymentNotConfirmed';
  }
}
