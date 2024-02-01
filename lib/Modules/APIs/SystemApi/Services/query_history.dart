import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_history.dart';
import 'package:mi_fik/Modules/Helpers/template.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryQueriesService {
  final String baseUrl = "https://mifik.leonardhors.site";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<HistoryModel>> getMyHistory(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (prefs.containsKey("myhistory-$page-sess")) {
        if (!isOffline) {
          Get.snackbar(
              "Warning".tr, "Lost connection, all data shown are local".tr,
              backgroundColor: whiteColor);
          isOffline = true;
        }
        return historyJsonWPaginate(prefs.getString("myhistory-$page-sess"));
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

      final response = await client.get(
          Uri.parse("$emuUrl/api/v1/history/my?page=$page"),
          headers: header);
      if (response.statusCode == 200) {
        prefs.setString("myhistory-$page-sess", response.body);
        return historyJsonWPaginate(response.body);
      } else if (response.statusCode == 401) {
        await getDestroyTrace(false);
        return null;
      } else {
        return null;
      }
    }
  }
}
