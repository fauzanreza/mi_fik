// ignore: depend_on_referenced_packages
import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/APIs/ContentApi/Models/query_contents.dart';
import 'package:mi_fik/Modules/Helpers/converter.dart';
import 'package:mi_fik/Modules/Variables/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<ContentHeaderModel>> getAllContentHeader(
      tag, order, date, find, page) async {
    String finds = await getFind(find);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
        Uri.parse(
            "$emuUrl/api/v2/content/slug/$tag/order/$order/date/$date/find/$finds?page=$page"),
        headers: header);
    if (response.statusCode == 200) {
      return contentHeaderModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }

  Future<List<ContentDetailModel>> getContentDetail(slug) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client
        .get(Uri.parse("$emuUrl/api/v1/content/slug/$slug"), headers: header);
    if (response.statusCode == 200) {
      return contentDetailModelFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<List<ScheduleModel>> getSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
        Uri.parse(
            "$emuUrl/api/v1/content/date/${DateFormat("yyyy-MM-dd").format(slctSchedule)}"),
        headers: header);
    if (response.statusCode == 200) {
      return scheduleModelFromJsonWPaginate(response.body);
    } else {
      return null;
    }
  }

  Future<List<ScheduleTotalModel>> getTotalSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
        Uri.parse(
            "$emuUrl/api/v1/content/date/${DateFormat("yyyy-MM-dd").format(slctSchedule)}"),
        headers: header);
    if (response.statusCode == 200) {
      return scheduleTotalModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
