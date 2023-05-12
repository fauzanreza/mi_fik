import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/APIs/SystemApi/Models/query_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationQueriesService {
  final String baseUrl = "https://mifik.id";
  final String emuUrl = "http://10.0.2.2:8000";
  Client client = Client();

  Future<List<NotificationModel>> getAllNotification(int page) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token_key');
    final header = {
      'Accept': 'application/json',
      'Authorization': "Bearer $token",
    };

    final response = await client.get(
        Uri.parse("$emuUrl/api/v1/notification/my?page=$page"),
        headers: header);
    if (response.statusCode == 200) {
      return notificationJsonWPaginate(response.body);
    } else {
      return null;
    }
  }
}
