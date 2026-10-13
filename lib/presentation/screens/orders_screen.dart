import 'package:flutter/material.dart';
import '../../injection.dart';
import '../../data/models/order_model.dart';
import '../../data/repositories/orders_repository.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Order History')),
    body: StreamBuilder<List<OrderModel>>(
      stream: getIt<OrdersRepository>().watchOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return const Center(child: Text('Could not load orders.'));
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final orders = snapshot.data!;
        if (orders.isEmpty) return const Center(child: Text('No orders yet'));
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final date = order.createdAt;
            final dateText = date == null ? 'Just now' :
              '${date.day}/${date.month}/${date.year}';
            return Card(child: ExpansionTile(
              title: Text('Order #${order.id.substring(0, 8)}'),
              subtitle: Text('${order.status} • ${dateText}'),
              trailing: Text('\$${order.total.toStringAsFixed(2)}'),
              children: [
                for (final item in order.items)
                  ListTile(
                    title: Text(item['name']?.toString() ?? 'Meal'),
                    subtitle: Text('Qty: ${item['quantity']}'),
                    trailing: Text('\$${(item['lineTotal'] as num? ?? 0).toStringAsFixed(2)}'),
                  ),
                ListTile(title: const Text('Payment'), subtitle: Text(order.paymentMethod)),
              ],
            ));
          },
        );
      },
    ),
  );
}
