import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<HelpTypeModel>> getHelpType() async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("help-type-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return helpTypeModelFromJson(prefs.getString("help-type-sess"));
      } else {
        return null;
      }
    } else {
      if (isOffline) {
        Get.snackbar("Warning".tr, "Welcome back, all data are now realtime".tr,
            backgroundColor: whiteColor);
        isOffline = false;
      }
      final token = prefs.getString('token_key');
      final header = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };

      final response =
          await client.get(Uri.parse("$baseUrl/api/v1/help"), headers: header);
      if (response.statusCode == 200) {
        prefs.setString("help-type-sess", response.body);

        return helpTypeModelFromJson(response.body);
      } else {
        return null;
      }
    }
  }

  Future<List<HelpBodyModel>> getHelpBody(String type) async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("help-type-$type-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return helpBodyModelFromJsonWPaginate(
            prefs.getString("help-type-$type-sess"));
      } else {
        return null;
      }
    } else {
      if (isOffline) {
        Get.snackbar("Warning".tr, "Welcome back, all data are now realtime".tr,
            backgroundColor: whiteColor);
        isOffline = false;
      }
      final header = {
        'Accept': 'application/json',
      };

      final response = await client.get(Uri.parse("$baseUrl/api/v1/help/$type"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("help-type-$type-sess", response.body);
        return helpBodyModelFromJsonWPaginate(response.body);
      } else {
        return null;
      }
    }
  }

  Future<List<HelpBodyModel>> getAbout() async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("help-about-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return helpBodyModelFromJsonWPaginate(
            prefs.getString("help-about-sess"));
      } else {
        return null;
      }
    } else {
      if (isOffline) {
        Get.snackbar("Warning".tr, "Welcome back, all data are now realtime".tr,
            backgroundColor: whiteColor);
        isOffline = false;
      }
      final header = {
        'Accept': 'application/json',
      };

      final response = await client.get(Uri.parse("$baseUrl/api/v1/help/about"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("help-about-sess", response.body);
        return helpBodyModelFromJsonWPaginate(response.body);
      } else {
        return null;
      }
    }
  }
}
