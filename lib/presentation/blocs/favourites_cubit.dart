import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/meal_model.dart';
import '../../data/repositories/favourites_repository.dart';

class FavouritesState {
  const FavouritesState({this.meals = const [], this.loading = true, this.error});
  final List<MealModel> meals;
  final bool loading;
  final String? error;
  bool contains(String id) => meals.any((meal) => meal.id == id);
}

class FavouritesCubit extends Cubit<FavouritesState> {
  FavouritesCubit(this._repository, this._auth) : super(const FavouritesState()) {
    _authSubscription = _auth.authStateChanges().listen(_onAuthChanged);
    _onAuthChanged(_auth.currentUser);
  }
  final FavouritesRepository _repository;
  final FirebaseAuth _auth;
  StreamSubscription<User?>? _authSubscription;
  StreamSubscription<List<MealModel>>? _subscription;

  void _onAuthChanged(User? user) {
    _subscription?.cancel();
    _subscription = null;
    if (user == null) {
      emit(const FavouritesState(meals: [], loading: false));
      return;
    }
    emit(const FavouritesState());
    _subscription = _repository.watch().listen(
      (meals) => emit(FavouritesState(meals: meals, loading: false)),
      onError: (Object error) => emit(FavouritesState(
        meals: state.meals, loading: false, error: error.toString(),
      )),
    );
  }

  Future<void> toggle(MealModel meal) async {
    try {
      if (state.contains(meal.id)) {
        await _repository.remove(meal.id);
      } else {
        await _repository.save(meal);
      }
    } catch (error) {
      emit(FavouritesState(meals: state.meals, loading: false,
          error: 'Could not update favourites: $error'));
    }
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    await _subscription?.cancel();
    return super.close();
  }
}
