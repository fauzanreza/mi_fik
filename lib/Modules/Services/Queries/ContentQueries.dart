import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Contents/Content.dart';
import 'package:mi_fik/Modules/Variables/global.dart';

class ContentQueriesService {
  final String baseUrl = "https://mifik.id";
  Client client = Client();

  Future<List<ContentModel>> getContentArchive() async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/schedule/my/$selectedArchiveId"));
    if (response.statusCode == 200) {
      return ContentModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
