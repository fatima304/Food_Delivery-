/// Builds the Firestore profile payload for a newly registered user.
/// Firebase's server timestamp is added by the data service.
class UserProfileBuilder {
  String _fullName = '';
  String _email = '';

  UserProfileBuilder withFullName(String name) {
    _fullName = name;
    return this;
  }

  UserProfileBuilder withEmail(String email) {
    _email = email;
    return this;
  }

  Map<String, dynamic> build() => {'fullName': _fullName, 'email': _email};
}
