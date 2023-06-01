// ignore: depend_on_referenced_packages
import 'package:get/get.dart';
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/QuestionApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<QuestionBodyModel>> getActiveFAQ() async {
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/faq/question/active/10"),
        headers: header);
    if (response.statusCode == 200) {
      return questionBodyModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }

  Future<List<MyQuestionModel>> getMyFAQ(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');

    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/faq/question?page=$page"),
        headers: header);
    if (response.statusCode == 200) {
      return myQuestionModelFromJsonWPaginate(response.body);
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
