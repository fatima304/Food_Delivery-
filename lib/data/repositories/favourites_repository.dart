import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meal_model.dart';

class FavouritesRepository {
  FavouritesRepository(this._firestore, this._auth);
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw StateError('Please sign in to use favourites.');
    return uid;
  }

  CollectionReference<Map<String, dynamic>> collectionFor(String uid) =>
      _firestore.collection('users').doc(uid).collection('favourites');

  Stream<List<MealModel>> watchFor(String uid) =>
      collectionFor(uid).snapshots().map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        // Older documents may use an ID field rather than TheMealDB's idMeal.
        return MealModel.fromJson({
          ...data,
          'idMeal': data['idMeal'] ?? data['mealId'] ?? doc.id,
          'strMeal': data['strMeal'] ?? data['name'] ?? '',
          'strMealThumb': data['strMealThumb'] ?? data['imageUrl'] ?? '',
        });
      }).where((meal) => meal.id.isNotEmpty).toList());

  Future<void> save(MealModel meal) => collectionFor(_uid).doc(meal.id).set({
        ...meal.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });

  Future<void> remove(String mealId) => collectionFor(_uid).doc(mealId).delete();
}
