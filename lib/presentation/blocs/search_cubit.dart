import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/home_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._repository) : super(const SearchState());
  final HomeRepository _repository;
  int _requestId = 0;

  Future<void> load() async {
    final requestId = ++_requestId;
    emit(
      SearchState(
        categories: state.categories,
        meals: state.meals,
        loading: true,
      ),
    );
    try {
      final categories = await _repository.getCategories();
      final meals = await _repository.getMeals();
      if (isClosed || requestId != _requestId) return;
      emit(SearchState(categories: categories, meals: meals.take(12).toList()));
    } catch (error) {
      if (isClosed || requestId != _requestId) return;
      emit(
        SearchState(
          categories: state.categories,
          meals: state.meals,
          error: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> search(String text) async {
    final query = text.trim();
    if (query.isEmpty) {
      await load();
      return;
    }
    final requestId = ++_requestId;
    emit(
      SearchState(
        categories: state.categories,
        meals: state.meals,
        query: query,
        loading: true,
      ),
    );
    try {
      final meals = await _repository.searchMeals(query);
      if (isClosed || requestId != _requestId) return;
      emit(
        SearchState(categories: state.categories, meals: meals, query: query),
      );
    } catch (error) {
      if (isClosed || requestId != _requestId) return;
      emit(
        SearchState(
          categories: state.categories,
          query: query,
          error: _errorMessage(error),
        ),
      );
    }
  }

  Future<void> selectCategory(String category) async {
    final requestId = ++_requestId;
    emit(
      SearchState(
        categories: state.categories,
        selectedCategory: category,
        loading: true,
      ),
    );
    try {
      final meals = await _repository.getMeals(category: category);
      if (isClosed || requestId != _requestId) return;
      emit(
        SearchState(
          categories: state.categories,
          meals: meals,
          selectedCategory: category,
        ),
      );
    } catch (error) {
      if (isClosed || requestId != _requestId) return;
      emit(
        SearchState(
          categories: state.categories,
          selectedCategory: category,
          error: _errorMessage(error),
        ),
      );
    }
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout) {
        return 'checkInternet';
      }
    }
    return 'loadMeals';
  }
}
