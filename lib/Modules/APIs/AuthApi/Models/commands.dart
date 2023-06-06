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

String loginModelToJson(LoginModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Usecase check registered account
class RegisteredModel {
  String username;
  String email;

  RegisteredModel({this.username, this.email});

  Map<String, dynamic> toJson() {
    return {"username": username, "email": email};
  }
}

String registeredModelToJson(RegisteredModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
