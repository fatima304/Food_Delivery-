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

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('users').doc(_uid).collection('favourites');

  Stream<List<MealModel>> watch() => _collection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => MealModel.fromJson(doc.data())).toList());

  Future<void> save(MealModel meal) => _collection.doc(meal.id).set({
        ...meal.toJson(),
        'savedAt': FieldValue.serverTimestamp(),
      });

  Future<void> remove(String mealId) => _collection.doc(mealId).delete();
}
