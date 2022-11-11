import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/DB/Model/Task.dart';
import 'package:mi_fik/main.dart';

class TaskService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<bool> addTask(TaskModel data) async {
    final response = await client.post(
      Uri.parse("${baseUrl}/api/task/create/${passIdUser}"),
      headers: {"content-type": "application/json"},
      body: TaskModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateTask(TaskModel data, int id) async {
    final response = await client.put(
      Uri.parse("${baseUrl}/api/task/update/${id}"),
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
