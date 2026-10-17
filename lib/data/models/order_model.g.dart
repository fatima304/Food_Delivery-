// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String? ?? '',
  items: (json['items'] as List<dynamic>)
      .map((e) => e as Map<String, dynamic>)
      .toList(),
  total: json['total'] == null ? 0.0 : OrderModel._toDouble(json['total']),
  paymentMethod: json['paymentMethod'] as String? ?? 'cash',
  status: json['status'] as String? ?? 'pending',
  paymentStatus: json['paymentStatus'] as String? ?? '',
  paymentIntentId: json['paymentIntentId'] as String?,
  userId: json['userId'] as String? ?? '',
  subtotal: json['subtotal'] == null
      ? 0.0
      : OrderModel._toDouble(json['subtotal']),
  deliveryFee: json['deliveryFee'] == null
      ? 0.0
      : OrderModel._toDouble(json['deliveryFee']),
  createdAt: OrderModel._dateFromJson(json['createdAt']),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'total': instance.total,
      'paymentMethod': instance.paymentMethod,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'paymentIntentId': instance.paymentIntentId,
      'createdAt': OrderModel._dateToJson(instance.createdAt),
    };
