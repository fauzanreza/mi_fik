import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_info.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoQueriesService {
  final String baseUrl = "https://mifik.leonardhors.site";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<InfoModel> getInfo(String page, String loc) async {
    final prefs = await SharedPreferences.getInstance();

    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("info-$page-$loc-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return infoModelFromJson(prefs.getString("info-$page-$loc-sess"));
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

      final response = await client.get(
          Uri.parse("$emuUrl/api/v1/info/page/$page/location/$loc"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("info-$page-$loc-sess", response.body);
        return infoModelFromJson(response.body);
      } else {
        return null;
      }
    }
  }
}
