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
    case 'noUser':
      return l.noUser;
    case 'wrongPassword':
      return l.wrongPassword;
    case 'emailInUse':
      return l.emailInUse;
    case 'firebaseInvalidEmail':
      return l.firebaseInvalidEmail;
    case 'weakPassword':
      return l.weakPassword;
    case 'userDisabled':
      return l.userDisabled;
    case 'tooManyAttempts':
      return l.tooManyAttempts;
    case 'incorrectCredentials':
      return l.incorrectCredentials;
    case 'noInternet':
      return l.noInternet;
    case 'emailUnavailable':
      return l.emailUnavailable;
    case 'unableRequest':
      return l.unableRequest;
    case 'networkError':
      return l.networkError;
    case 'unexpectedError':
      return l.unexpectedError;
    default:
      return l.unexpectedError;
  }
}
