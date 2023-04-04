import 'package:http/http.dart' show Client;
import 'package:mi_fik/Modules/Models/Tags/Tag.dart';

class TagService {
  final String baseUrl = "https://mifik.id";
  Client client = Client();

  Future<List<TagModel>> getAllTag(pageTag) async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/v1/tag/10?page=$pageTag"));
    if (response.statusCode == 200) {
      return TagModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
