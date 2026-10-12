// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to continue to your account';

  @override
  String get createAccount => 'Create account';

  @override
  String get signUpSubtitle => 'Join us and start ordering your favorite food';

  @override
  String get noAccount => 'Don’t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get signIn => 'Sign In';

  @override
  String get emailAddress => 'Email address';

  @override
  String get fullName => 'Full name';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get resetNotConnected => 'Password reset is not connected yet';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get creatingAccount => 'Creating account...';

  @override
  String get termsAgreement =>
      'I agree to the Terms of Service and Privacy Policy';

  @override
  String get acceptTerms => 'Please accept the terms first';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get onboardingTitle => 'Delicious food\ndelivered to';

  @override
  String get onboardingAccent => 'your doorstep';

  @override
  String get onboardingDescription =>
      'Discover the best restaurants near you and enjoy your favorite meals at home.';

  @override
  String get getStarted => 'Get Started  →';

  @override
  String get onboardingSignIn => 'Already have an account?  Sign In';

  @override
  String get signedIn => 'You are signed in!';

  @override
  String get signOut => 'Sign out';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get sessionError =>
      'Unable to check your session. Please restart the app.';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get firstLetterCapital => 'First letter must be capital';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get invalidEmail => 'Enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMin => 'Password must be at least 6 characters';

  @override
  String get confirmRequired => 'Confirm password is required';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get noUser => 'No user found with this email.';

  @override
  String get wrongPassword => 'Incorrect password provided.';

  @override
  String get emailInUse => 'An account already exists with this email.';

  @override
  String get firebaseInvalidEmail => 'The email address is not valid.';

  @override
  String get weakPassword => 'The password is too weak.';

  @override
  String get userDisabled => 'This user account has been disabled.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please try again later.';

  @override
  String get incorrectCredentials =>
      'Incorrect email or password. Please try again.';

  @override
  String get noInternet =>
      'No internet connection. Check your connection and try again.';

  @override
  String get emailUnavailable =>
      'Email sign-in is unavailable right now. Please contact support.';

  @override
  String get unableRequest =>
      'Unable to complete your request. Please try again.';

  @override
  String get networkError =>
      'Network error. Please check your internet connection.';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';
}
