import '../../domain/repositories/payment_method.dart';

import 'package:food_delivery/presentation/blocs/stripe_payment_cubit.dart';
import 'package:food_delivery/domain/entities/payment_receipt.dart';

import '../../core/widgets/app_back_button.dart';

import 'package:food_delivery/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../injection.dart';
import '../../data/repositories/orders_repository.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';

import 'package:food_delivery/core/widgets/custom_button.dart';

import '../../core/widgets/ui_parts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod payment = const CashPayment();
  bool placing = false;
  PaymentReceipt? _confirmedPayment;
  String? _paidCartSignature;

  String _cartSignature(CartState state) =>
      "${state.items.map((item) => "${item.meal.id}:${item.quantity}:${item.meal.price}").join("|")}:${state.total.toStringAsFixed(2)}";

  Future<void> _placeOrder() async {
    if (placing) return;

    final cart = context.read<CartBloc>();
    final state = cart.state;

    if (state.items.isEmpty) return;

    setState(() => placing = true);

    try {
      await cart.waitForWrites();

      if (_confirmedPayment != null &&
          _paidCartSignature != _cartSignature(state)) {
        throw StateError('Cart changed after card payment.');
      }
      if (payment is CardPayment && _confirmedPayment == null) {
        final stripeCubit = getIt<StripePaymentCubit>();
        final receipt = await stripeCubit.makePayment(total: state.total);

        if (!mounted) return;

        if (receipt == null) {
          final paymentState = stripeCubit.state;

          final message = paymentState is StripePaymentFailure
              ? paymentState.message
              : 'paymentNotConfirmed';

          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message == 'paymentCancelled'
                    ? l10n.paymentCancelled
                    : l10n.paymentNotConfirmed,
              ),
            ),
          );

          return;
        }
        _confirmedPayment = receipt;
        _paidCartSignature = _cartSignature(state);
      }

      await getIt<OrdersRepository>().placeOrder(
        items: state.items,
        subtotal: state.subtotal,
        deliveryFee: state.deliveryFee,
        payment: payment,
        receipt: payment is CardPayment ? _confirmedPayment : null,
      );

      cart.add(const CartClear());

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.orderPlacedSuccessfully),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.orders,
        (route) => route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _confirmedPayment != null
                ? AppLocalizations.of(context)!.paymentOrderSaveFailed
                : AppLocalizations.of(context)!.checkoutOrderFailed,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => placing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(l10n.checkout),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: placing ? l10n.placingOrder : l10n.placeOrder,
            onPressed: placing ? null : _placeOrder,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const FoodPhoto(height: 150),
          SectionHeading(l10n.paymentMethod),
          RadioGroup<bool>(
            groupValue: payment is CashPayment,
            onChanged: (value) {
              setState(() {
                payment = value == true
                    ? const CashPayment()
                    : const CardPayment();
                _confirmedPayment = null;
                _paidCartSignature = null;
              });
            },
            child: Column(
              children: [
                RadioListTile<bool>(
                  title: Text(l10n.cashOnDelivery),
                  value: true,
                ),
                RadioListTile<bool>(
                  title: Text(l10n.creditDebitCard),
                  value: false,
                ),
              ],
            ),
          ),
          SectionHeading(l10n.orderSummary),
          BlocBuilder<CartBloc, CartState>(
            builder: (_, cart) => Column(
              children: [
                ListTile(
                  title: Text(l10n.subtotal),
                  trailing: Text('\$${cart.subtotal.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text(l10n.deliveryFee),
                  trailing: Text('\$${cart.deliveryFee.toStringAsFixed(2)}'),
                ),
                ListTile(
                  title: Text(l10n.total),
                  trailing: Text('\$${cart.total.toStringAsFixed(2)}'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
