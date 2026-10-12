import 'package:flutter/widgets.dart';
import 'package:food_delivery/l10n/app_localizations.dart';

class LocalizedValidation {
  static String? message(BuildContext context, String? error) {
    if (error == null) return null;
    final l = AppLocalizations.of(context)!;
    switch (error) {
      case 'Full name is required':
        return l.fullNameRequired;
      case 'First letter must be capital':
        return l.firstLetterCapital;
      case 'Email is required':
        return l.emailRequired;
      case 'Enter a valid email':
        return l.invalidEmail;
      case 'Password is required':
        return l.passwordRequired;
      case 'Password must be at least 6 characters':
        return l.passwordMin;
      case 'Confirm password is required':
        return l.confirmRequired;
      case 'Passwords do not match':
        return l.passwordMismatch;
      default:
        return error;
    }
  }
}
