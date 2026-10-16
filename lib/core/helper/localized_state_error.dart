import 'package:flutter/widgets.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

/// Translates known presentation-state messages while keeping state logic unchanged.
String localizedStateError(BuildContext context, String? message) {
  final l = AppLocalizations.of(context)!;
  switch (message) {
    case "mealUnavailable":
      return l.errorMealDetailsUnavailable;
    case "checkInternet":
      return l.errorCheckInternet;
    case "loadMealDetails":
      return l.errorLoadMealDetails;
    case "somethingWrong":
      return l.errorSomethingWrong;
    case "loadFavourites":
      return l.errorLoadFavourites;
    case "updateFavourites":
      return l.errorUpdateFavourites;
    case "requestTimedOut":
      return l.errorRequestTimedOut;
    case "couldNotConnect":
      return l.errorCouldNotConnect;
    case "loadMealsNow":
      return l.errorLoadMealsNow;
    case "loadingMeals":
      return l.errorLoadingMeals;
    case "biometricFailed":
      return l.errorBiometricFailed;
    case "authenticate":
      return l.errorAuthenticate;
    case "loadMeals":
      return l.errorLoadMeals;
    case "loadDeviceInfo":
      return l.errorLoadDeviceInfo;
    case "loadCart":
      return l.errorLoadCart;
    case "signInFirst":
      return l.errorSignInFirst;
    default:
      return l.errorSomethingWrong;
  }
}
