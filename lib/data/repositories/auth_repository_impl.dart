import 'package:food_delivery/domain/repositories/auth_repository.dart';
import 'package:food_delivery/services/auth_service.dart';

/// Connects the domain contract to Firebase through AuthService.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authService);

  final AuthService _authService;

  @override
  Future<void> login({required String email, required String password}) async {
    await _authService.login(email: email, password: password);
  }

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await _authService.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  @override
  Future<void> logout() => _authService.logout();
}
