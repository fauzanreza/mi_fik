import 'dart:convert';

// Usecase update profile
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

String editUserProfileModelToJson(EditUserProfileModel data) {
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
