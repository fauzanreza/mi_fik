import 'dart:convert';

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
      Uri.parse("$emuUrl/api/v1/logout"),
      headers: header,
    );

    var respondeDecode = jsonDecode(response.body);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return [
        {"message": "success", "body": respondeDecode["message"], "token": null}
      ];
    } else if (response.statusCode == 401) {
      return [
        {"message": "failed", "body": respondeDecode["message"], "token": null}
      ];
    } else {
      return [
        {"message": "failed", "body": "Unknown error", "token": null}
      ];
    }
  }
}
