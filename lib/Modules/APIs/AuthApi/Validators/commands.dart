import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';

class LoginValidator {
  static Map<String, dynamic> validateLogin(LoginModel data) {
    if (data.username.isEmpty) {
      return {"status": false, "message": "Username can't be empty"};
    }
    if (data.password.isEmpty) {
      return {"status": false, "message": "Password can't be empty"};
    }
    return {"status": true, "message": "Validation success"};
  }
}
