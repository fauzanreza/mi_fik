import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/ArchiveApi/Models/queries.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArchiveQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<ArchiveModel>> getMyArchive(String find, String type) async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("archive-sess-$find-$type")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whitebg);
          isOffline = true;
        }
        return archiveModelFromJson(
            prefs.getString("archive-sess-$find-$type"));
      } else {
        return archiveModelFromJson(null);
      }
    } else {
      if (isOffline) {
        Get.snackbar("Warning".tr, "Welcome back, all data are now realtime".tr,
            backgroundColor: whitebg);
        isOffline = false;
      }
      final token = prefs.getString('token_key');
      final header = {
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      };

      final response = await client.get(
          Uri.parse("$emuUrl/api/v1/archive/$find/type/$type"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("archive-sess-$find-$type", response.body);
        return archiveModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        await prefs.clear();
        Get.offAll(() => const LoginPage());
        Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
            backgroundColor: whitebg);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<ScheduleModel>> getArchiveContent(String slug) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client
        .get(Uri.parse("$emuUrl/api/v1/archive/by/$slug"), headers: header);
    if (response.statusCode == 200) {
      return scheduleModelFromJsonWPaginate(response.body);
    } else if (response.statusCode == 401) {
      Get.offAll(() => const LoginPage());
      Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
          backgroundColor: whitebg);
      return null;
    } else {
      return null;
    }
  }
}
