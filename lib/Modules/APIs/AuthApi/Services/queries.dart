import 'dart:convert';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class AuthQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> getSignOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
      Uri.parse("$emuUrl/api/v1/logout/mobile"),
      headers: header,
    );

    if (response.statusCode == 200) {
      var respondeDecode = jsonDecode(response.body);
      return [
        {"message": "success", "body": respondeDecode["message"], "code": 200}
      ];
    } else if (response.statusCode == 401) {
      var respondeDecode = jsonDecode(response.body);
      return [
        {"message": "failed", "body": respondeDecode["message"], "code": 401}
      ];
    } else {
      return [
        {
          "message": "failed",
          "body": "Unknown error, please contact the admin".tr
        }
      ];
    }
  }
}
