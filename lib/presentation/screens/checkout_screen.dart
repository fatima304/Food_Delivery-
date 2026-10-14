import '../widgets/app_back_button.dart';

import 'package:food_delivery/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../../injection.dart';
import '../../data/repositories/orders_repository.dart';
import '../../domain/repositories/payment_method.dart';
import '../blocs/cart_bloc.dart';
import '../blocs/cart_event.dart';
import '../blocs/cart_state.dart';

import 'package:food_delivery/presentation/widgets/custom_button.dart';

import '../widgets/ui_parts.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});
  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod payment = const CashPayment();
  bool placing = false;

  Future<void> _placeOrder() async {
    if (placing) return;
    final cart = context.read<CartBloc>();
    final state = cart.state;
    if (state.items.isEmpty) return;
    setState(() => placing = true);
    try {
      await cart.waitForWrites();
      await getIt<OrdersRepository>().placeOrder(
        items: state.items,
        subtotal: state.subtotal,
        deliveryFee: state.deliveryFee,
        payment: payment,
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
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.couldNotPlaceOrder),
        ),
      );
    } finally {
      if (mounted) setState(() => placing = false);
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
          RadioListTile<bool>(
            title: Text(l10n.cashOnDelivery),
            value: true,
            groupValue: payment is CashPayment,
            onChanged: (v) => setState(() => payment = const CashPayment()),
          ),
          RadioListTile<bool>(
            title: Text(l10n.creditDebitCard),
            value: false,
            groupValue: payment is CashPayment,
            onChanged: (v) => setState(() => payment = const CardPayment()),
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
