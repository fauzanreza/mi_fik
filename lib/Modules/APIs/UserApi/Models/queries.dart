import 'dart:convert';

// Usecase get my profile
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

// Usecase get my request
class UserRequestModel {
  List<dynamic> tagSlugName;
  String type;
  String createdAt;

  UserRequestModel({this.tagSlugName, this.createdAt, this.type});

  factory UserRequestModel.fromJson(Map<String, dynamic> map) {
    return UserRequestModel(
        tagSlugName: map["tag_slug_name"],
        type: map["request_type"],
        createdAt: map["created_at"]);
  }
}

List<UserRequestModel> userRequestModelFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<UserRequestModel>.from(
      data['data'].map((item) => UserRequestModel.fromJson(item)));
}
