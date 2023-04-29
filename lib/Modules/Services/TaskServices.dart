import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Task.dart';

class TaskService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<bool> updateTask(TaskModel data, int id) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/task/update/$id"),
      headers: {"content-type": "application/json"},
      body: TaskModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
