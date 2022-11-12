import 'package:http/http.dart' show Client;
import 'package:mi_fik/DB/Model/Tag.dart';

class TagService {
  final String baseUrl = "https://mifik.leonardhors.site";
  Client client = Client();

  Future<List<TagModel>> getAllTag() async {
    final response = await client.get(Uri.parse("$baseUrl/api/tag"));
    if (response.statusCode == 200) {
      return TagModelFromJson(response.body);
    } else {
      return null;
    }
  }
}
