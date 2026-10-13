import 'package:flutter/material.dart';
import '../../injection.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';
import '../widgets/order_history_card.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Order History'), centerTitle: true),
    body: StreamBuilder<List<OrderModel>>(
      stream: getIt<OrdersRepository>().watchOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Padding(
          padding: EdgeInsets.all(24), child: Text('Could not load your orders. Please try again.',
          textAlign: TextAlign.center)));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final orders = snapshot.data!;
        if (orders.isEmpty) return Center(child: Column(
          mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.receipt_long_outlined, size: 84,
              color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 18),
            const Text('No orders yet', style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text('Your completed orders will appear here.',
              textAlign: TextAlign.center),
          ]));
        return ListView(padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          children: [Text('${orders.length} orders', style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant)),
            const SizedBox(height: 14),
            for (final order in orders) OrderHistoryCard(order: order),
          ]);
      },
    ),
  );
}
