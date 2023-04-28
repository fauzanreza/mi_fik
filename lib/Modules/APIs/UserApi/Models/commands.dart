// Usecase get my profile
import 'dart:convert';

class EditUserProfileModel {
  String password;
  String firstName;
  String lastName;

  EditUserProfileModel({this.password, this.firstName, this.lastName});

  Map<String, dynamic> toJson() {
    return {
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}

String EditUserProfileModelToJson(EditUserProfileModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
