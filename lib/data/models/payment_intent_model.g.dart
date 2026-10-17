// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_intent_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentIntentModel _$PaymentIntentModelFromJson(Map<String, dynamic> json) =>
    PaymentIntentModel(
      id: json['id'] as String,
      clientSecret: json['client_secret'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$PaymentIntentModelToJson(PaymentIntentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'client_secret': instance.clientSecret,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
    };
