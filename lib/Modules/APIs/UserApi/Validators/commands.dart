import 'package:get/get.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';

class UserValidator {
  static Map<String, dynamic> validateRegis(RegisterModel data) {
    if (data.username.isEmpty) {
      return {
        "status": false,
        "message": "Username $emptyInputMsg",
        "loc": "username"
      };
    }
    if (data.username.length < usernameMinLength ||
        data.username.length > usernameLength) {
      return {
        "status": false,
        "message":
            "Username should be around $usernameMinLength up to $usernameLength character",
        "loc": "username"
      };
    }
    if (data.email.isEmpty) {
      return {
        "status": false,
        "message": "Email $emptyInputMsg",
        "loc": "email"
      };
    }
    if (data.email.length < emailMinLength ||
        data.email.length > emailMaxLength) {
      return {
        "status": false,
        "message":
            "Email should be around $emailMinLength up to $emailMaxLength character",
        "loc": "email"
      };
    }
    if (data.password.isEmpty) {
      return {
        "status": false,
        "message": "Password $emptyInputMsg",
        "loc": "password"
      };
    }
    if (data.password.length < passwordMinLength ||
        data.password.length > passwordLength) {
      return {
        "status": false,
        "message":
            "Password should be around $passwordMinLength up to $passwordLength character",
        "loc": "password"
      };
    }
    if (data.firstName.isEmpty) {
      return {
        "status": false,
        "message": "First name $emptyInputMsg",
        "loc": "last_name"
      };
    }
    if (data.firstName.length > fnameLength) {
      return {
        "status": false,
        "message": "First name should below $fnameLength character",
        "loc": "last_name"
      };
    }
    return {"status": true, "message": "Validation success".tr};
  }

  static Map<String, dynamic> validateEditPass(EditPassModel data) {
    if (data.password.length < passwordMinLength ||
        data.password.length > passwordLength) {
      return {
        "status": false,
        "message":
            "Password should be around $passwordMinLength up to $passwordLength character",
        "loc": "password"
      };
    }
    return {"status": true, "message": "Validation success".tr};
  }
}
