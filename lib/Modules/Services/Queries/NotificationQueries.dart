import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Notifications/Notifications.dart';

class NotificationQueriesService {
  final String baseUrl = "https://mifik.id";
  Client client = Client();

  Future<List<NotificationModel>> getMyNotif(userId, page) async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/v1/notification/$userId?page=$page"));
    if (response.statusCode == 200) {
      return NotificationModelFromJsonwPaginate(response.body);
    } else {
      return null;
    }
  }
}
