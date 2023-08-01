import 'dart:convert';

// Usecase update profile
class EditUserProfileModel {
  String firstName;
  String lastName;

  EditUserProfileModel({this.firstName, this.lastName});

  Map<String, dynamic> toJson() {
    return {
      "first_name": firstName,
      "last_name": lastName,
    };
  }
}

String editUserProfileModelToJson(EditUserProfileModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Usecase register profile
class RegisterModel {
  String username;
  String password;
  String email;
  String firstName;
  String lastName;
  int validUntil;

  RegisterModel(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName,
      this.validUntil});

  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": password,
      "first_name": firstName,
      "last_name": lastName,
      "batch_year": validUntil,
    };
  }
}

String registerModelToJson(RegisterModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Usecase add new request
class AddNewReqModel {
  String userRole;
  String reqType;

  AddNewReqModel({this.userRole, this.reqType});

  Map<String, dynamic> toJson() {
    return {"user_role": userRole, "req_type": reqType};
  }
}

String addNewReqModelToJson(AddNewReqModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

// Usecase update profile image
class EditUserImageModel {
  String imageUrl; // Nullable

  EditUserImageModel({this.imageUrl});

  Map<String, dynamic> toJson() {
    return {"image_url": imageUrl};
  }
}

String editUserProfileImageModelToJson(EditUserImageModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
