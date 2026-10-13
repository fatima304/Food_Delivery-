import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/cart_item.dart';
import '../models/meal_model.dart';

class CartRepository {
  CartRepository(this.db, this.auth);
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  DocumentReference<Map<String, dynamic>> _cart(String uid) =>
      db.collection('users').doc(uid).collection('cart').doc('current');

  Future<List<CartItem>> load(String uid) async {
    final snapshot = await _cart(uid).get();
    final raw = snapshot.data()?['items'];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((entry) {
      final data = Map<String, dynamic>.from(entry);
      return CartItem(
        meal: MealModel.fromJson(Map<String, dynamic>.from(data['meal'] as Map)),
        quantity: (data['quantity'] as num).toInt(),
      );
    }).where((item) => item.quantity > 0).toList();
  }

  Future<void> save(String uid, List<CartItem> items) => _cart(uid).set({
        'items': items.map((item) => {
          'meal': item.meal.toJson(),
          'quantity': item.quantity,
        }).toList(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
}
