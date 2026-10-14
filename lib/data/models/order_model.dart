import 'package:cloud_firestore/cloud_firestore.dart';

/// Firestore order data. `id` is the document id (not a stored field).
class OrderModel {
  const OrderModel({
    required this.id,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    this.userId = '',
    this.subtotal = 0,
    this.deliveryFee = 0,
    this.createdAt,
  });

  final String id;
  final String userId;
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final String status;
  final DateTime? createdAt;

  static double amount(Object? value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static DateTime? _date(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  factory OrderModel.fromJson(Map<String, dynamic> json, {String? id}) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
              .whereType<Map>()
              .map(
                (item) =>
                    item.map((key, value) => MapEntry(key.toString(), value)),
              )
              .toList()
        : <Map<String, dynamic>>[];
    return OrderModel(
      id: id ?? json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      items: items,
      subtotal: amount(json['subtotal']),
      deliveryFee: amount(json['deliveryFee']),
      total: amount(json['total']),
      paymentMethod: json['paymentMethod']?.toString() ?? 'cash',
      status: json['status']?.toString() ?? 'pending',
      createdAt: _date(json['createdAt']),
    );
  }

  factory OrderModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) => OrderModel.fromJson(doc.data() ?? <String, dynamic>{}, id: doc.id);

  /// Serializable map, useful for caching or APIs (includes the document id).
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'total': total,
    'paymentMethod': paymentMethod,
    'status': status,
    'createdAt': createdAt?.toIso8601String(),
  };

  /// Firestore payload (document id is stored in the document path).
  Map<String, dynamic> toFirestore() => {
    'userId': userId,
    'items': items.map((item) => Map<String, dynamic>.from(item)).toList(),
    'subtotal': subtotal,
    'deliveryFee': deliveryFee,
    'total': total,
    'paymentMethod': paymentMethod,
    'status': status,
    'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
  };
}
