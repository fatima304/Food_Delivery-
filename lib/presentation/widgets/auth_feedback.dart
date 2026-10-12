import 'package:food_delivery/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/core/constants/app_colors.dart';

void showAuthFeedback(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.error,
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              localizedAuthMessage(context, message),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.dismiss,
        textColor: Colors.white,
        onPressed: messenger.hideCurrentSnackBar,
      ),
    ),
  );
}

String localizedAuthMessage(BuildContext context, String message) {
  final l = AppLocalizations.of(context)!;
  switch (message) {
    case 'No user found with this email.':
      return l.noUser;
    case 'Incorrect password provided.':
      return l.wrongPassword;
    case 'An account already exists with this email.':
      return l.emailInUse;
    case 'The email address is not valid.':
      return l.firebaseInvalidEmail;
    case 'The password is too weak.':
      return l.weakPassword;
    case 'This user account has been disabled.':
      return l.userDisabled;
    case 'Too many attempts. Please try again later.':
      return l.tooManyAttempts;
    case 'Incorrect email or password. Please try again.':
      return l.incorrectCredentials;
    case 'No internet connection. Check your connection and try again.':
      return l.noInternet;
    case 'Email sign-in is unavailable right now. Please contact support.':
      return l.emailUnavailable;
    case 'Unable to complete your request. Please try again.':
      return l.unableRequest;
    case 'Network error. Please check your internet connection.':
      return l.networkError;
    case 'An unexpected error occurred. Please try again.':
      return l.unexpectedError;
    default:
      return message;
  }
}
