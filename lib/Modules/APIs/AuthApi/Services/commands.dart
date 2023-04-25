import 'dart:convert';

import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCommandsService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> postLogin(LoginModel data) async {
    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json'
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/login"),
      headers: header,
      body: LoginModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['role'] != 1) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token_key', responseData['token']);
        await prefs.setString(
            'username_key', responseData['result']['username']);
        await prefs.setString(
            'image_key', responseData['result']['image_url'].toString());
        await prefs.setString(
            'role_lsit_key', jsonEncode(responseData['result']['role']));

        // Lecturer or student role
        return [
          {
            "message": "success",
            "body": responseData['result'],
            "token": responseData['token']
          }
        ];
      } else {
        // Admin role
        return [
          {
            "message": "failed",
            "body": "Sorry, admin doesn't have access to MI-FIK mobile",
            "token": null
          }
        ];
      }
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      // Validation failed
      return [
        {"message": "failed", "body": responseData['result'], "token": null}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error", "token": null}
      ];
    }
  }
}
