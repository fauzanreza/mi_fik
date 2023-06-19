// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/HelpApi/Models/queries.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelpQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<HelpTypeModel>> getHelpType() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response =
        await client.get(Uri.parse("$emuUrl/api/v1/help"), headers: header);
    if (response.statusCode == 200) {
      return helpTypeModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<HelpBodyModel>> getHelpBody(String type) async {
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(Uri.parse("$emuUrl/api/v1/help/$type"),
        headers: header);
    if (response.statusCode == 200) {
      return helpBodyModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }

  Future<List<HelpBodyModel>> getAbout() async {
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(Uri.parse("$emuUrl/api/v1/help/about"),
        headers: header);
    if (response.statusCode == 200) {
      return helpBodyModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }
}
