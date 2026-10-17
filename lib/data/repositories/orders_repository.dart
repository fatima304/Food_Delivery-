import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/payment_method.dart';
import '../models/order_model.dart';
import '../../domain/entities/payment_receipt.dart';

class OrdersRepository {
  OrdersRepository(this.db, this.auth);
  final FirebaseFirestore db;
  final FirebaseAuth auth;

  Stream<List<OrderModel>> watchOrders() {
    final uid = auth.currentUser?.uid;
    if (uid == null) return Stream.value([]);
    return db
        .collection('users')
        .doc(uid)
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(OrderModel.fromFirestore).toList(),
        );
  }

  Future<String> placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required PaymentMethod payment,
    PaymentReceipt? receipt,
  }) async {
    final uid = auth.currentUser?.uid;
    if (uid == null) throw StateError('Please sign in to place an order.');
    if (items.isEmpty) throw StateError('Your cart is empty.');
    if (payment is CardPayment && receipt == null) {
      throw StateError('A confirmed card payment is required.');
    }
    final total = subtotal + deliveryFee;
    final user = db.collection('users').doc(uid);
    // A stable document ID prevents duplicates on retries of the same payment.
    final order = receipt == null
        ? user.collection('orders').doc()
        : user.collection('orders').doc(receipt.paymentIntentId);
    final cart = user.collection('cart').doc('current');
    final batch = db.batch();
    batch.set(order, {
      'userId': uid,
      'items': items
          .map(
            (item) => {
              'mealId': item.meal.id,
              'name': item.meal.name,
              'imageUrl': item.meal.imageUrl,
              'quantity': item.quantity,
              'unitPrice': item.meal.price,
              'lineTotal': item.total,
            },
          )
          .toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'paymentMethod': payment.id,
      'paymentStatus': receipt == null ? 'cash_on_delivery' : receipt.status,
      'paymentIntentId': receipt?.paymentIntentId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.set(cart, {'items': [], 'updatedAt': FieldValue.serverTimestamp()});
    await batch.commit();
    return order.id;
  }
}
