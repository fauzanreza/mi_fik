import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/UserApi/Models/commands.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCommandsService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> putProfileData(
      EditUserProfileModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.put(
      Uri.parse("$emuUrl/api/v1/user/update/data"),
      headers: header,
      body: editUserProfileModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [
        {
          "message": "success",
          "body": responseData["message"],
        }
      ];
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      // Validation failed
      return [
        {"message": "failed", "body": responseData['result']}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error"}
      ];
    }
  }

  Future<List<Map<String, dynamic>>> postUserReq(AddNewReqModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/user/request/role"),
      headers: header,
      body: addNewReqModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [
        {
          "message": "success",
          "body": responseData["message"],
        }
      ];
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      // Validation failed
      return [
        {"message": "failed", "body": responseData['result']}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error"}
      ];
    }
  }

  Future putFirebase(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.put(
      Uri.parse("$emuUrl/api/v1/user/update/token/$key"),
      headers: header,
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [
        {
          "message": "success",
          "body": responseData["message"],
        }
      ];
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      // Validation failed
      return [
        {"message": "failed", "body": responseData['result']}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error"}
      ];
    }
  }

  Future<List<Map<String, dynamic>>> putProfileImage(
      EditUserImageModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.put(
      Uri.parse("$emuUrl/api/v1/user/update/image"),
      headers: header,
      body: editUserProfileImageModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [
        {
          "message": "success",
          "body": responseData["message"],
        }
      ];
    } else if (response.statusCode == 422 || response.statusCode == 401) {
      // Validation failed
      return [
        {"message": "failed", "body": responseData['result']}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error"}
      ];
    }
  }
}
