import 'package:flutter/material.dart';
import '../../data/models/order_model.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.order});
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final date = order.createdAt;
    final dateText = date == null ? 'Processing' :
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    final status = order.status.toUpperCase();
    return Card(
      margin: const EdgeInsets.only(bottom: 14), elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: colors.outlineVariant.withOpacity(.6))),
      child: Padding(padding: const EdgeInsets.all(15), child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: colors.primaryContainer,
              child: Icon(Icons.receipt_long_outlined, color: colors.primary)),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                const SizedBox(height: 3),
                Text(dateText, style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant))])),
            Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(20)),
              child: Text(status, style: TextStyle(fontSize: 10,
                fontWeight: FontWeight.w700, color: colors.onPrimaryContainer))),
          ]),
          const SizedBox(height: 14),
          Divider(color: colors.outlineVariant.withOpacity(.5)),
          for (final item in order.items) Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(children: [
              ClipRRect(borderRadius: BorderRadius.circular(9),
                child: (item['imageUrl']?.toString().isNotEmpty ?? false)
                  ? Image.network(item['imageUrl'].toString(), width: 45, height: 45,
                      fit: BoxFit.cover, errorBuilder: (_, __, ___) =>
                        const SizedBox(width: 45, height: 45, child: Icon(Icons.fastfood_outlined)))
                  : const SizedBox(width: 45, height: 45, child: Icon(Icons.fastfood_outlined))),
              const SizedBox(width: 10),
              Expanded(child: Text(item['name']?.toString() ?? 'Meal',
                maxLines: 2, overflow: TextOverflow.ellipsis)),
              Text('×${item['quantity'] ?? 1}', style: TextStyle(color: colors.onSurfaceVariant)),
              const SizedBox(width: 10),
              Text('\$${OrderModel.amount(item['lineTotal']).toStringAsFixed(2)}'),
            ])),
          Divider(color: colors.outlineVariant.withOpacity(.5)),
          Row(children: [
            Icon(Icons.payments_outlined, size: 17, color: colors.onSurfaceVariant),
            const SizedBox(width: 6),
            Expanded(child: Text(order.paymentMethod, style: TextStyle(
              fontSize: 12, color: colors.onSurfaceVariant))),
            Text('\$${order.total.toStringAsFixed(2)}', style: TextStyle(
              color: colors.primary, fontSize: 17, fontWeight: FontWeight.w800)),
          ]),
        ])),
    );
  }
}
