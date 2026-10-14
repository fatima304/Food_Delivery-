import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/home_repository.dart';
import 'meal_details_state.dart';

class MealDetailsCubit extends Cubit<MealDetailsState> {
  final HomeRepository repository;
  MealDetailsCubit(this.repository) : super(const MealDetailsState());

  Future<void> load(String mealId) async {
    emit(MealDetailsState(meal: state.meal, loading: true));
    try {
      final meal = await repository.getMealDetails(mealId);
      if (isClosed) return;
      emit(
        MealDetailsState(
          meal: meal,
          error: meal == null ? 'mealUnavailable' : null,
        ),
      );
    } on DioException catch (error) {
      if (isClosed) return;
      final offline = error.type == DioExceptionType.connectionError;
      emit(
        MealDetailsState(
          meal: state.meal,
          error: offline ? 'checkInternet' : 'loadMealDetails',
        ),
      );
    } catch (_) {
      if (!isClosed)
        emit(MealDetailsState(meal: state.meal, error: 'somethingWrong'));
    }
  }
}
