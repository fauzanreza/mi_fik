import 'package:get/get.dart';
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';
import 'package:mi_fik/Modules/Variables/global.dart';

class AuthValidator {
  static Map<String, dynamic> validateLogin(LoginModel data) {
    if (data.username.isEmpty) {
      return {"status": false, "message": "Username $emptyInputMsg"};
    }
    if (data.password.isEmpty) {
      return {"status": false, "message": "Password $emptyInputMsg"};
    }
    return {"status": true, "message": "Validation success".tr};
  }

  static Map<String, dynamic> validateAccount(dynamic data) {
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
            "Username should be around $usernameMinLength up to $usernameLength character"
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
            "Email should be around $emailMinLength up to $emailMaxLength character"
      };
    }
    return {"status": true, "message": "Validation success".tr};
  }
}
