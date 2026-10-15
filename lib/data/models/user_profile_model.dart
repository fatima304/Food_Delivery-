/// Basic user information stored in the users collection.
class UserProfileModel {
  const UserProfileModel({required this.fullName, required this.email});

  final String fullName;
  final String email;

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      fullName: json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'fullName': fullName, 'email': email};
}
