import 'package:dio/dio.dart';

/// Stable error codes, translated by localizedStateError in the UI.
/// Never pass exception.toString() directly to a user-facing widget.
class ErrorCodes {
  static String forMeals(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'requestTimedOut';
        case DioExceptionType.connectionError:
          return 'checkInternet';
        default:
          return 'loadMeals';
      }
    }
    return 'somethingWrong';
  }
}
