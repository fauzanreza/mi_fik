import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/Helpers/validation.dart';

class AuthValidator {
  static Map<String, dynamic> validateLogin(LoginModel data) {
    if (data.username.isEmpty) {
      return {"status": false, "message": "Username can't be empty"};
    }
    if (data.password.isEmpty) {
      return {"status": false, "message": "Password can't be empty"};
    }
    return {"status": true, "message": "Validation success"};
  }

  static Map<String, dynamic> validateAccount(RegisteredModel data) {
    if (data.username.isEmpty) {
      return {
        "status": false,
        "message": "Username can't be empty",
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
        "message": "Email can't be empty",
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
    return {"status": true, "message": "Validation success"};
  }
}
