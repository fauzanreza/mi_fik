// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/UserApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<UserProfileModel>> getMyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response =
        await client.get(Uri.parse("$emuUrl/api/v1/user/"), headers: header);
    if (response.statusCode == 200) {
      return userProfileModelFromJson(response.body);
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

  Future<List<UserRequestModel>> getMyReq(bool isLogged) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client
        .get(Uri.parse("$emuUrl/api/v1/user/request/my"), headers: header);
    if (response.statusCode == 200) {
      return userRequestModelFromJson(response.body);
    } else if (response.statusCode == 401) {
      if (isLogged) {
        await prefs.clear();

        Get.offAll(() => const LoginPage());
        Get.snackbar("Alert".tr, "Session lost, please sign in again".tr,
            backgroundColor: whitebg);
      }

      return null;
    } else {
      return null;
    }
  }
}
