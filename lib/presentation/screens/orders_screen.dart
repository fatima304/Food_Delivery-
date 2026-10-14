import 'package:flutter/material.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

import '../widgets/app_nav.dart';
import '../../injection.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';
import '../widgets/order_history_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.orderHistory),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const AppNav(index: 3),
      body: StreamBuilder<List<OrderModel>>(
        stream: getIt<OrdersRepository>().watchOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.couldNotLoadOrders,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data!;
          if (orders.isEmpty) {
            return  Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 84,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    l10n.noOrdersYet,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.noOrdersDescription, textAlign: TextAlign.center),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              Text(
                '${orders.length} ${l10n.ordersCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 14),
              for (final order in orders) OrderHistoryCard(order: order),
            ],
          );
        },
      ),
    );
  }
}
