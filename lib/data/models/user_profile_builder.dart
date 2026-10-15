import 'user_profile_model.dart';

/// Builder Pattern: prepare a profile before saving it to Firestore.
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

  UserProfileModel build() =>
      UserProfileModel(fullName: _fullName, email: _email);
}
