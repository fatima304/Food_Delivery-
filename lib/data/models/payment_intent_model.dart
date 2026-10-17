import 'package:json_annotation/json_annotation.dart';

part 'payment_intent_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PaymentIntentModel {
  const PaymentIntentModel({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
    required this.status,
  });

  final String id;
  final String clientSecret;
  final int amount;
  final String currency;
  final String status;

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentIntentModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentIntentModelToJson(this);
}
