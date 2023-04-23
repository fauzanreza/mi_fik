import 'dart:convert';

// Usecase login
class LoginModel {
  String username;
  String password;

  LoginModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {"username": username, "password": password};
  }
}

String LoginModelToJson(LoginModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
