import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  const OrderModel({required this.id, required this.items, required this.total,
    required this.paymentMethod, required this.status, this.createdAt});
  final String id;
  final List<Map<String, dynamic>> items;
  final double total;
  final String paymentMethod;
  final String status;
  final DateTime? createdAt;

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return OrderModel(
      id: doc.id,
      items: (data['items'] as List<dynamic>? ?? [])
          .whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList(),
      total: (data['total'] as num? ?? 0).toDouble(),
      paymentMethod: data['paymentMethod'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
