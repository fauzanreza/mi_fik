import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/AuthApi/Models/commands.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCommandsService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";

  Client client = Client();

  Future<List<Map<String, dynamic>>> postLogin(
      LoginModel data, bool isRegis) async {
    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json'
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/login"),
      headers: header,
      body: loginModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (responseData['role'] != 1) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('id_key', responseData['result']['id']);
        await prefs.setString(
            'username_key', responseData['result']['username']);
        await prefs.setString(
            'image_key', responseData['result']['image_url'].toString());
        await prefs.setString('token_key', responseData['token']);

        if (responseData['result']['role'] != null) {
          var roles = responseData['result']['role'];
          var passRoleGeneral = "";
          roles.forEach((e) {
            if (e['slug_name'] == "lecturer") {
              passRoleGeneral = "Lecturer";
              return;
            } else if (e['slug_name'] == "student") {
              passRoleGeneral = "Student";
              return;
            } else if (e['slug_name'] == "staff") {
              passRoleGeneral = "Staff";
              return;
            }
          });
          await prefs.setString('role_general_key', passRoleGeneral);
          await prefs.setString('role_list_key', jsonEncode(roles));

          // Lecturer or student role
          // Has been accepted and have a role
          return [
            {
              "message": "success",
              "body": responseData['result'],
              "token": responseData['token'],
              "access": true
            }
          ];
        } else {
          // Not yet accepted and doesnt have a role
          // So it redirect to register page
          isFillForm = true;
          isCheckedRegister = true;
          checkAvaiabilityRegis = true;
          usernameAvaiabilityCheck = responseData['result']['username'];
          emailAvaiabilityCheck = responseData['result']['email'];
          passRegisCtrl = responseData['result']['password'];
          fnameRegisCtrl = responseData['result']['first_name'];
          lnameRegisCtrl = responseData['result']['last_name'];

          //Check if user had pending request
          final token = responseData['token'];
          final header = {
            'Accept': 'application/json',
            'Authorization': "Bearer $token",
          };

          if (!isRegis) {
            final resReq = await client.get(
                Uri.parse("$emuUrl/api/v1/user/request/my"),
                headers: header);
            if (resReq.statusCode == 200) {
              isWaiting = true;
              indexRegis = 5;
            } else if (resReq.statusCode == 404) {
              indexRegis = 4;
            } else if (resReq.statusCode == 401) {
              Get.snackbar(
                  "Alert".tr, "Failed to validate request, please try again".tr,
                  backgroundColor: whitebg);
            } else {
              indexRegis = 4;
            }
          } else {
            indexRegis = 3;
          }

          await prefs.setString(
              'profile_data_key', jsonEncode(responseData['result']));
          return [
            {
              "message": "success",
              "body": responseData['result'],
              "token": responseData['token'],
              "access": false,
            }
          ];
        }
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

  Future<List<Map<String, dynamic>>> postCheckUser(RegisteredModel data) async {
    final header = {
      'Accept': 'application/json',
      'content-type': 'application/json'
    };

    final response = await client.post(
      Uri.parse("$emuUrl/api/v1/check/user"),
      headers: header,
      body: registeredModelToJson(data),
    );

    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return [
        {"message": "success", "body": responseData['result']}
      ];
    } else if (response.statusCode == 422 || response.statusCode == 401) {
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
