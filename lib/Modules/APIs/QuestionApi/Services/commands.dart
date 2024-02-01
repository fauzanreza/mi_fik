import 'dart:convert';

import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/commands.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionCommandsService {
  final String baseUrl = "https://mifik.leonardhors.site";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> postFAQ(AddQuestionModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/faq/question"),
      headers: header,
      body: addQuestionModelToJson(data),
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
        {"message": "failed", "body": responseData['message']}
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
