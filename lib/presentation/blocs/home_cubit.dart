import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;
  int _request = 0;
  HomeCubit(this.repository) : super(const HomeState());

  Future<void> load() async {
    final request = ++_request;
    emit(
      HomeState(
        loading: true,
        categories: state.categories,
        meals: state.meals,
        selectedCategory: state.selectedCategory,
        offers: state.offers,
      ),
    );
    try {
      final categories = await repository.getCategories();
      final meals = await repository.getMeals();
      if (isClosed || request != _request) return;
      emit(
        HomeState(
          categories: categories,
          meals: meals,
          offers: meals.take(5).toList(),
        ),
      );
    } catch (error) {
      if (isClosed || request != _request) return;
      emit(
        HomeState(
          categories: state.categories,
          meals: state.meals,
          error: _message(error),
          offers: state.offers,
        ),
      );
    }
  }

  Future<void> selectCategory(String? category) async {
    if (category == state.selectedCategory &&
        !state.loading &&
        state.error == null)
      return;
    final request = ++_request;
    emit(
      HomeState(
        loading: true,
        categories: state.categories,
        meals: state.meals,
        selectedCategory: category,
        offers: state.offers,
      ),
    );
    try {
      final meals = await repository.getMeals(category: category);
      if (isClosed || request != _request) return;
      emit(
        HomeState(
          categories: state.categories,
          meals: meals,
          selectedCategory: category,
          offers: state.offers,
        ),
      );
    } catch (error) {
      if (isClosed || request != _request) return;
      emit(
        HomeState(
          categories: state.categories,
          meals: state.meals,
          selectedCategory: category,
          error: _message(error),
          offers: state.offers,
        ),
      );
    }
  }

  String _message(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return 'The request timed out. Please try again.';
      }
      if (error.type == DioExceptionType.connectionError) {
        return 'Could not connect. Check your internet connection.';
      }
      return 'Unable to load meals right now. Please try again.';
    }
    return 'Something went wrong while loading meals.';
  }
}
