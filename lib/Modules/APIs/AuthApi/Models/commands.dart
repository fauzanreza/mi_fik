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

// Usecase post request recover pass
class RequestRecoverModel {
  String username;
  String email;
  String token;
  String type;

  RequestRecoverModel({this.username, this.email, this.token, this.type});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "validation_token": token,
      "type": type
    };
  }
}

String requestRecoverModelToJson(RequestRecoverModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Usecase edit password
class EditPassModel {
  String username;
  String password;
  String token;

  EditPassModel({this.username, this.password, this.token});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "validation_token": token
    };
  }
}

String editPassModelToJson(EditPassModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
