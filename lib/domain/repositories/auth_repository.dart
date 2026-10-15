/// Authentication operations exposed to the presentation layer.
/// Firebase implementation details belong in the data/service layers.
abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  });

  Future<void> logout();
}
