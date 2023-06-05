import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';

class UserValidator {
  static Map<String, dynamic> validateRegis(RegisterModel data) {
    if (data.username.isEmpty) {
      return {"status": false, "message": "Username can't be empty"};
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
      return {"status": false, "message": "Email can't be empty"};
    }
    if (data.email.length < emailMinLength ||
        data.email.length > emailMaxLength) {
      return {
        "status": false,
        "message":
            "Email should be around $emailMinLength up to $emailMaxLength character"
      };
    }
    if (data.password.isEmpty) {
      return {"status": false, "message": "Password can't be empty"};
    }
    if (data.password.length < passwordMinLength ||
        data.password.length > passwordLength) {
      return {
        "status": false,
        "message":
            "Password should be around $passwordMinLength up to $passwordLength character"
      };
    }
    if (data.firstName.isEmpty) {
      return {"status": false, "message": "First name can't be empty"};
    }
    if (data.firstName.length < fnameLength) {
      return {
        "status": false,
        "message": "First name should below $fnameLength character"
      };
    }
    return {"status": true, "message": "Validation success"};
  }
}
