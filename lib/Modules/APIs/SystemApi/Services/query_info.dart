import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<InfoModel>> getInfo(String page, String loc) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/info/page/$page/location/$loc"),
        headers: header);
    if (response.statusCode == 200) {
      return infoModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
