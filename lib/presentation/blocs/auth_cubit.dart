import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/domain/repositories/auth_repository.dart';

import 'auth_state.dart';

// Cubit pattern for managing authentication state
// Handles login, sign up, and logout operations with proper state management
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(AuthInitial());

  final AuthRepository _authRepository;

  // Convert Firebase exceptions to user-friendly messages
  // Never exposes raw Firebase error messages to users
  String _getErrorMessage(dynamic error) {
    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'noUser';
        case 'wrong-password':
          return 'wrongPassword';
        case 'email-already-in-use':
          return 'emailInUse';
        case 'invalid-email':
          return 'firebaseInvalidEmail';
        case 'weak-password':
          return 'weakPassword';
        case 'user-disabled':
          return 'userDisabled';
        case 'too-many-requests':
          return 'tooManyAttempts';
        case 'invalid-credential':
        case 'invalid-login-credentials':
          return 'incorrectCredentials';
        case 'network-request-failed':
          return 'noInternet';
        case 'operation-not-allowed':
          return 'emailUnavailable';
        default:
          return 'unableRequest';
      }
    }

    if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      return 'networkError';
    }

    return 'unexpectedError';
  }

  Future<void> login({required String email, required String password}) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());

    try {
      await _authRepository.login(email: email, password: password);

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;
    emit(AuthLoading());

    try {
      await _authRepository.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );

      emit(AuthSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    if (state is AuthLoading) return;
    emit(AuthLoading());
    try {
      await _authRepository.logout();
      // Emit AuthInitial to signal successful logout
      // AuthWrapper will navigate to login screen when it receives this state
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }
}
