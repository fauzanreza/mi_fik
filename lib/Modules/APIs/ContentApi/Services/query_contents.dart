import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Helpers/generator.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ContentQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<ContentHeaderModel>> getAllContentHeader(
      tag, order, date, find, page) async {
    String finds = await getFind(find);
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("content-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return contentHeaderModelFromJsonWPaginate(
            prefs.getString("content-sess"));
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
      int utc = getUTCHourOffset();

      final response = await client.get(
          Uri.parse(
              "$emuUrl/api/v1/content/slug/$tag/order/$order/date/$date/$utc/find/$finds?page=$page"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("content-sess", response.body);
        return contentHeaderModelFromJsonWPaginate(response.body);
      } else if (response.statusCode == 401) {
        await getDestroyTrace(false);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<ContentDetailModel>> getContentDetail(slug) async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("content-detail-$slug-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return contentDetailModelFromJson(
            prefs.getString("content-detail-$slug-sess"));
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

      final response = await client
          .get(Uri.parse("$emuUrl/api/v1/content/slug/$slug"), headers: header);
      if (response.statusCode == 200) {
        prefs.setString("content-detail-$slug-sess", response.body);
        return contentDetailModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        await getDestroyTrace(false);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<ScheduleModel>> getSchedule(DateTime date, int page) async {
    final prefs = await SharedPreferences.getInstance();
    String dateStr = DateFormat("yyyy-MM-dd").format(date);

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("schedule-$dateStr-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return scheduleModelFromJsonWPaginate(
            prefs.getString("schedule-$dateStr-sess"));
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
      int utc = getUTCHourOffset();

      final response = await client.get(
          Uri.parse("$emuUrl/api/v1/content/date/$dateStr/$utc?page=$page"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("schedule-$dateStr-sess", response.body);
        return scheduleModelFromJsonWPaginate(response.body);
      } else if (response.statusCode == 401) {
        await getDestroyTrace(false);
        return null;
      } else {
        return null;
      }
    }
  }

  Future<List<ScheduleTotalModel>> getTotalSchedule(DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    String dateStr = DateFormat("yyyy-MM-dd").format(date);

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("scheduletotal-$dateStr-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return scheduleTotalModelFromJson(
            prefs.getString("scheduletotal-$dateStr-sess"));
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
      int utc = getUTCHourOffset();

      final response = await client.get(
          Uri.parse("$emuUrl/api/v1/content/date/$dateStr/$utc"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("scheduletotal-$dateStr-sess", response.body);
        return scheduleTotalModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        await getDestroyTrace(false);
        return null;
      } else {
        return null;
      }
    }
  }
}
