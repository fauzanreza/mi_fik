import 'dart:convert';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/ContentApi/Models/command_tasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskCommandsService {
  final String baseUrl = "https://mifik.leonardhors.site";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> addTask(AddTaskModel data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/task/create"),
      headers: header,
      body: addTaskModelToJson(data),
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
        {
          "message": "failed",
          "body": "Unknown error, please contact the admin".tr
        }
      ];
    }
  }

  Future<List<Map<String, dynamic>>> updateTask(
      AddTaskModel data, String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.put(
      Uri.parse("$emuUrl/api/v1/task/update/$id"),
      headers: header,
      body: addTaskModelToJson(data), // Same request as add task
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
        {
          "message": "failed",
          "body": "Unknown error, please contact the admin".tr
        }
      ];
    }
  }

  Future deleteTask(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.delete(
      Uri.parse("$emuUrl/api/v1/task/delete/$id"),
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
        {
          "message": "failed",
          "body": "Unknown error, please contact the admin".tr
        }
      ];
    }
  }
}
