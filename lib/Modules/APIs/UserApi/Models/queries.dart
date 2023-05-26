// Usecase get my profile
import 'dart:convert';

class UserProfileModel {
  String username;
  String email;
  String password;
  String firstName;
  String lastName;
  String createdAt;
  String updatedAt;

  UserProfileModel(
      {this.username,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAt});

  factory UserProfileModel.fromJson(Map<String, dynamic> map) {
    return UserProfileModel(
      username: map["username"],
      email: map["email"],
      password: map["password"],
      firstName: map["first_name"],
      lastName: map["last_name"],
      createdAt: map["created_at"],
      updatedAt: map["updated_at"],
    );
  }
}

List<UserProfileModel> userProfileModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<UserProfileModel>.from(
      data['data'].map((item) => UserProfileModel.fromJson(item)));
}
