import 'dart:convert';

// Usecase get my profile
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

// Usecase add new request
class AddNewReqModel {
  var userRole;
  String reqType;

  AddNewReqModel({this.userRole, this.reqType});

  Map<String, dynamic> toJson() {
    return {"user_role": userRole, "req_type": reqType};
  }
}

String AddNewReqModelToJson(AddNewReqModel data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
