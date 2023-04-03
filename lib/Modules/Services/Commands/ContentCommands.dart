import 'package:http/http.dart' show Client;
import 'package:intl/intl.dart';
import 'package:mi_fik/Modules/Helpers/Converter.dart';
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/main.dart';

class ContentCommandsService {
  final String baseUrl = "https://mifik.id";
  Client client = Client();

  Future<bool> addContent(ContentModel data) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/content/create/$passIdUser"),
      headers: {"content-type": "application/json"},
      body: ContentModelToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
