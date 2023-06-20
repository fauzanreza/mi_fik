import 'dart:convert';

import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/TagApi/Models/queries.dart';
import 'package:mi_fik/Modules/Variables/style.dart';
import 'package:mi_fik/Pages/Landings/LoginPage/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<TagCategoryModel>> getAllTagCategory() async {
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/dictionaries/type/TAG-001"),
        headers: header);
    if (response.statusCode == 200) {
      return tagCategoryModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<TagAllModel>> getAllTagByCategory(String cat) async {
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/tag/cat/$cat/20?page=1"),
        headers: header);
    if (response.statusCode == 200) {
      return tagAllModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<MyTagModel>> getMyTag() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final username = prefs.getString('username_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client
        .get(Uri.parse("$emuUrl/api/v1/user/$username/role"), headers: header);
    var responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      await prefs.setString('role_list_key', jsonEncode(responseData['data']));
      return myTagModelFromJson(response.body);
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
