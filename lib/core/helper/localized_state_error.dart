import 'package:flutter/widgets.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

/// Translates known presentation-state messages while keeping state logic unchanged.
String localizedStateError(BuildContext context, String? message) {
  final l = AppLocalizations.of(context)!;
  switch (message) {
    case "Meal details are unavailable.":
      return l.errorMealDetailsUnavailable;
    case "Check your internet connection and try again.":
      return l.errorCheckInternet;
    case "Unable to load meal details. Please try again.":
      return l.errorLoadMealDetails;
    case "Something went wrong. Please try again.":
      return l.errorSomethingWrong;
    case "Could not load favourites. Check your connection and Firestore rules.":
      return l.errorLoadFavourites;
    case "Could not update favourites. Please try again.":
      return l.errorUpdateFavourites;
    case "The request timed out. Please try again.":
      return l.errorRequestTimedOut;
    case "Could not connect. Check your internet connection.":
      return l.errorCouldNotConnect;
    case "Unable to load meals right now. Please try again.":
      return l.errorLoadMealsNow;
    case "Something went wrong while loading meals.":
      return l.errorLoadingMeals;
    case "Biometric authentication was cancelled or failed.":
      return l.errorBiometricFailed;
    case "Unable to authenticate. Please try again.":
      return l.errorAuthenticate;
    case "Could not load meals. Please try again.":
      return l.errorLoadMeals;
    case "Unable to load device information.":
      return l.errorLoadDeviceInfo;
    case "Could not load your cart. Please try again.":
      return l.errorLoadCart;
    case "Please sign in first.":
      return l.errorSignInFirst;
    default:
      return message ?? l.errorSomethingWrong;
  }
}
