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

  static double amount(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    final rawItems = data['items'];
    final items = rawItems is List
        ? rawItems.whereType<Map>().map((item) =>
            item.map((key, value) => MapEntry(key.toString(), value))).toList()
        : <Map<String, dynamic>>[];
    final rawDate = data['createdAt'];
    DateTime? createdAt;
    if (rawDate is Timestamp) createdAt = rawDate.toDate();
    if (rawDate is DateTime) createdAt = rawDate;
    return OrderModel(
      id: doc.id,
      items: items,
      total: amount(data['total']),
      paymentMethod: data['paymentMethod']?.toString() ?? 'Cash',
      status: data['status']?.toString() ?? 'pending',
      createdAt: createdAt,
    );
  }
}
